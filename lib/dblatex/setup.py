#!/usr/bin/env python
# -*- coding: ISO-8859-1 -*-
#
# dblatex python setup script - See the COPYRIGHT
#
import os
import sys
import re
import glob
import subprocess

try:
    from setuptools import setup
    from setuptools.command.install import install
except ImportError:
    from distutils.core import setup
    from distutils.command.install import install

from distutils.command.build import build
from distutils.command.build_scripts import build_scripts
from distutils.command.install_data import install_data
from distutils.command.sdist import sdist
from distutils import log
from subprocess import Popen, PIPE
sys.path.append("lib")
from contrib.debian.installer import DebianInstaller

#
# Build the command line script
#
class BuildScripts(build_scripts):

    SHELL_SCRIPT = """#!%(env_executable)s%(env_args)s%(py_executable)s
import sys
import os

package_base = %(package_base)s

%(lib_path)s
%(catalogs)s
%(style_set)s
from %(package_path)s import %(package)s
%(package)s.main(base=package_base)
"""

    CATALOGS = """cat = os.environ.get("SGML_CATALOG_FILES")
if cat:
    cat += ":%s"
else:
    cat = "%s"
os.environ["SGML_CATALOG_FILES"] = cat
"""

    def run(self):
        """
        Create the proper script for the current platform.
        """
        if not self.scripts:
            return

        # The script can only work with package data
        self.data_files = self.distribution.data_files
        if not(self.data_files):
            return

        if self.dry_run:
            return

        # Ensure the destination directory exists
        self.mkpath(self.build_dir)

        # Data useful for building the script
        install = self.distribution.get_command_obj("install")
        if not(install.install_data):
            return

        self._install_lib = os.path.normpath(install.install_lib)
        self._root = install.root
        if self._root:
            self._root = os.path.normpath(self._root)
        self._package_base = os.path.join(install.install_data,
                                          self.data_files[0][0])
        self._catalogs = install.catalogs
        self._style = install.style
        self._use_py_path = install.use_python_path
        print self._package_base

        # Build the command line script
        self.build_script()

    def _strip_root(self, *paths):
        if not(self._root):
            return paths

        newpaths = []
        for path in paths:
            if path.startswith(self._root):
                newpaths.append(path[len(self._root):])
            else:
                newpaths.append(path)
        return newpaths

    def build_script(self):
        script_name = self.scripts[0]

        # prepare args for the bang path at the top of the script
        ENV_BIN = '/usr/bin/env'
        env_args = ''
        if self._use_py_path:
            env_exec = ''
            py_exec = sys.executable
        elif os.name == 'posix':
            # Some Solaris platforms may not have an 'env' binary.
            # If /usr/bin/env exists, use '#!/usr/bin/env python'
            # otherwise, use '#!' + sys.executable
            env_exec = os.path.isfile(ENV_BIN) and \
                os.access(ENV_BIN, os.X_OK) and ENV_BIN or ''
            py_exec = env_exec and 'python' or sys.executable
        else:
            # shouldn't matter on non-POSIX; we'll just use defaults
            env_exec = ENV_BIN
            py_exec = 'python'

        # Retrieve actual installation paths
        lib_path, package_base = self._strip_root(self._install_lib,
                                                  self._package_base)

        # Just help for non standard installation paths
        if lib_path in sys.path:
            lib_path = ""
        else:
            lib_path = "sys.path.append(r\"%s\")" % lib_path

        # Things to adapt when building an egg
        if "/egg" in lib_path:
            lib_path = ""
            package_base = 'os.path.abspath(os.path.join(os.path.dirname('\
                           '__file__), "..", "..", "share", "dblatex"))'
        else:
            package_base = 'r"%s"' % (package_base)

        if self._catalogs:
            catalogs = self.CATALOGS % (self._catalogs, self._catalogs)
        else:
            catalogs = ""

        if self._style:
            style_set = "sys.argv.insert(1, '-T%s')" % self._style
        else:
            style_set = ""

        script_args = { 'env_executable': env_exec,
                        'env_args': env_exec and (' %s' % env_args) or '',
                        'py_executable': py_exec,
                        'lib_path': lib_path,
                        'style_set': style_set,
                        'package': "dblatex",
                        'package_path': "dbtexmf.dblatex",
                        'catalogs': catalogs,
                        'package_base': package_base }

        script = self.SHELL_SCRIPT % script_args
        script_name = os.path.basename(script_name)
        outfile = os.path.join(self.build_dir, script_name)
        fd = os.open(outfile, os.O_WRONLY|os.O_CREAT|os.O_TRUNC, 0755)
        os.write(fd, script)
        os.close(fd)


class Build(build):
    """
    Build the documentation if missing or required to rebuild
    """
    user_options = build.user_options + \
                 [('docbook-xsl=', None,
                   'DocBook Project Stylesheet base directory (build_doc)')]

    def initialize_options(self):
        build.initialize_options(self)
        self.docbook_xsl = None

    def run(self):
        # Do the default tasks
        build.run(self)
        # And build the doc
        self.build_doc()

    def build_doc(self):
        log.info("running build_doc")
        htmldir = os.path.join("docs", "xhtml")
        pdfdocs = glob.glob(os.path.join("docs", "[mr]*.pdf"))
        manpage = os.path.join("docs", "manpage", "dblatex.1.gz")

        # Lazy check to avoid a rebuild for nothing
        if (not(self.force) and os.path.exists(htmldir) and len(pdfdocs) >= 2
            and os.path.exists(manpage)):
            return

        # Assumes that make is the GNU make
        cmd = ["make", "-C", "docs", "VERSION=%s" % (get_version())]
        if self.docbook_xsl:
            cmd.append("XSLDBK=%s" % os.path.abspath(self.docbook_xsl))

        subprocess.call(cmd)


def find_programs(utils):
    sys.path.append("lib")
    from contrib.which import which
    util_paths = {}
    missed = []
    for util in utils:
        try:
            path = which.which(util)
            util_paths[util] = path
        except which.WhichError:
            missed.append(util)
    sys.path.remove("lib")
    return (util_paths, missed)

def kpsewhich(tex_file):
    if os.name == "nt":
        close_fds = False
    else:
        close_fds = True
    p = Popen("kpsewhich %s" % tex_file, shell=True,
              stdin=PIPE, stdout=PIPE, close_fds=close_fds)
    out = "".join(p.stdout.readlines()).strip()
    return out


class Sdist(sdist):
    """
    Make the source package, and remove the .pyc files
    """
    def prune_file_list(self):
        sdist.prune_file_list(self)
        self.filelist.exclude_pattern(r'.*.pyc', is_regex=1)


class Install(install):

    user_options = install.user_options + \
                   [('catalogs=', None, 'default SGML catalogs'),
                    ('nodeps', None, 'don\'t check the dependencies'),
                    ('style=', None, 'default style to use'),
                    ('use-python-path', None, 'don\'t use env to locate python')]

    def initialize_options(self):
        install.initialize_options(self)
        self.catalogs = None
        self.nodeps = None
        self.style = None
        self.use_python_path = None
        # Prevents from undefined 'install_layout' attribute
        if not(getattr(self, "install_layout", None)):
            self.install_layout = None

    def check_util_dependencies(self):
        # First, check non critical graphic tools
        found, missed = find_programs(("epstopdf", "convert", "fig2dev"))
        for util in found:
            print "+checking %s... yes" % util
        for util in missed:
            print "+checking %s... no" % util
        if missed:
            print("warning: not found: %s" % ", ".join(missed))

        # Now, be serious
        found, missed = find_programs(("latex", "makeindex",
                                       "pdflatex", "kpsewhich"))
        for util in found:
            print "+checking %s... yes" % util
        for util in missed:
            print "+checking %s... no" % util
        if missed:
            raise OSError("not found: %s" % ", ".join(missed))

    def check_xslt_dependencies(self):
        sys.path.insert(0, "lib")
        from dbtexmf.xslt import xslt
        sys.path.remove("lib")

        # At least one XSLT must be available
        deplists = xslt.get_deplists()
        if not(deplists):
            raise OSError("no XSLT available")

        # For each XSLT check the programs they depend on
        xslt_found = []
        xslt_missed = []
        for (mod, deplist) in deplists:
            if not(deplist):
                xslt_found.append(mod)
                print "+checking XSLT %s... yes" % mod
                continue
            found, missed = find_programs(deplist)
            if missed:
                xslt_missed.append(mod)
                print "+checking XSLT %s... no (missing %s)" % \
                      (mod, ", ".join(missed))
            else:
                xslt_found.append(mod)
                print "+checking XSLT %s... yes" % mod

        if not(xslt_found):
            raise OSError("XSLT not installed: %s" % ", ".join(xslt_missed))
        elif xslt_missed:
            print "warning: XSLT not found: %s" % ", ".join(xslt_missed)

    def check_latex_dependencies(self):
        # Find the Latex files from the package
        stys = []
        for root, dirs, files in os.walk('latex/'):
            stys += glob.glob(os.path.join(root, "*.sty"))
        if stys:
            own_stys = [os.path.basename(s)[:-4] for s in stys]
        else:
            own_stys = []

        # Find the used packages
        used_stys = []
        re_sty = re.compile(r"\\usepackage\s*\[?.*\]?{(\w+)}")
        for sty in stys:
            f = open(sty)
            for line in f:
                line = line.split("%")[0]
                m = re_sty.search(line)
                if m:
                    p = m.group(1)
                    try:
                        used_stys.index(p)
                    except:
                        used_stys.append(p)
            f.close()

        # Now look if they are found
        found_stys = []
        mis_stys = []
        used_stys.sort()

        # Dirty...
        for f in ("truncate", "elfonts", "CJKutf8", "pinyin", "ifxetex"):
            try:
                used_stys.remove(f)
            except:
                pass

        for sty in used_stys:
            if sty in found_stys:
                continue
            status = "+checking %s... " % sty
            if sty in own_stys:
                status += "found in package"
                found_stys.append(sty)
                print status
                continue
            stypath = kpsewhich("%s.sty" % sty)
            if stypath:
                status += "yes"
                found_stys.append(sty)
            else:
                status += "no"
                mis_stys.append(sty)
            print status
            
        if mis_stys:
            raise OSError("not found: %s" % ", ".join(mis_stys))

    def run(self):
        if self.install_layout == "deb":
            db = DebianInstaller(self)
        else:
            db = None

        if not(db) and not(self.nodeps):
            try:
                self.check_xslt_dependencies()
                self.check_util_dependencies()
                self.check_latex_dependencies()
            except Exception, e:
                print >>sys.stderr, "Error: %s" % e
                sys.exit(1)

        if db: db.adapt_paths()

        # If no build is required, at least build the script
        if self.skip_build:
            self.run_command('build_scripts')

        install.run(self)

        if db: db.finalize()


class InstallData(install_data):

    def run(self):
        ignore_pattern = os.path.sep + r"(CVS|RCS)" + os.path.sep
        # literal backslash must be doubled in regular expressions
        ignore_pattern = ignore_pattern.replace('\\', r'\\')

        # Walk through sub-dirs, specified in data_files and build the
        # full data files list accordingly
        full_data_files = []
        for install_base, paths in self.data_files:
            base_files = []
            for path in paths:
                if os.path.isdir(path):
                    pref = os.path.dirname(path)
                    for root, dirs, files in os.walk(path):
                        if re.search(ignore_pattern, root + os.sep):
                            continue
                        # Only the last directory is copied, not the full path
                        if not(pref):
                            iroot = root
                        else:
                            iroot = root.split(pref + os.path.sep, 1)[1]
                        idir = os.path.join(install_base, iroot)
                        files = [os.path.join(root, i) for i in files]
                        if files:
                            full_data_files += [(idir, files)]
                else:
                    base_files.append(path)

            if base_files:
                full_data_files += [(install_base, base_files)]

        # Replace synthetic data_files by the full one, and do the actual job
        self.data_files = full_data_files
        rc = install_data.run(self)

        if self.distribution.get_command_obj("install").install_layout != "deb":
            self.adapt_installed_data()
        return rc

    def adapt_installed_data(self):
        installed = self.get_outputs()
        for data_file in installed:
            if os.path.basename(data_file) == "param.xsl":
                self._set_texlive_version(data_file)
                break

    def _set_texlive_version(self, param_file):
        """Detect the installed Texlive version from hyperref.sty version, and
        override the texlive.version param accordingly."""
        hyper_sty = kpsewhich("hyperref.sty")
        if not(hyper_sty):
            # Cannot do anything, give up
            return

        # Grab the value from package version
        d = open(hyper_sty).read()
        m = re.search("\\ProvidesPackage{hyperref}\s+\[(\d+)", d, re.M)
        if not(m):
            return
        year = m.group(1)

        # Patch the parameter with the found value
        p = open(param_file).read()
        p2 = re.sub('name="texlive.version">.*<',
                    'name="texlive.version">%s<' % year, p)
        f = open(param_file, "w")
        f.write(p2)
        f.close()


def get_version():
    sys.path.insert(0, "lib")
    from dbtexmf.dblatex import dblatex
    d = dblatex.DbLatex(base=os.getcwd())
    sys.path.remove("lib")
    return d.get_version()


if __name__ == "__main__":
    pdfdocs = glob.glob(os.path.join("docs", "[mr]*.pdf"))
    htmldoc = [os.path.join("docs", "xhtml")]
    classifiers = [
       "Operating System :: OS Independent",
       "Topic :: Text Processing :: Markup :: XML",
       "License :: OSI Approved :: GNU General Public License (GPL)"
    ]

    description = """
       dblatex is a program that transforms your SGML/XML DocBook documents to
       DVI, PostScript or PDF by translating them into pure LaTeX as a first
       process.  MathML 2.0 markups are supported, too. It started as a clone
       of DB2LaTeX.
       """

    setup(name="dblatex",
        version=get_version(),
        description='DocBook to LaTeX/ConTeXt Publishing',
        author='Benoit Guillon',
        author_email='marsgui@users.sourceforge.net',
        url='http://dblatex.sf.net',
        license='GPL Version 2 or later',
        long_description=description,
        classifiers=classifiers,
        packages=['dbtexmf',
                  'dbtexmf.core',
                  'dbtexmf.xslt',
                  'dbtexmf.dblatex',
                  'dbtexmf.dblatex.xetex',
                  'dbtexmf.dblatex.grubber'],
        package_dir={'dbtexmf':'lib/dbtexmf'},
        package_data={'dbtexmf.core':['sgmlent.txt'],
                      'dbtexmf.dblatex.grubber':['xindylang.xml']},
        data_files=[('share/dblatex', ['xsl', 'latex', 'etc/schema']),
                    ('share/doc/dblatex', pdfdocs),
                    ('share/doc/dblatex', htmldoc),
                    ('share/man/man1', ['docs/manpage/dblatex.1.gz'])],
        scripts=['scripts/dblatex'],
        cmdclass={'build': Build,
                  'build_scripts': BuildScripts,
                  'install': Install,
                  'install_data': InstallData,
                  'sdist': Sdist}
        )

