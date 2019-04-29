#
# dblatex - Installer extensions for Debian
#
import os
import glob
import shutil

class DebianInstaller:
    """
    Adapt the setup tool installation to match debian specific rules.
    The first step is to adpat the paths, the second step to provide the
    required links.

    The known limitations:
    - The dblatex script assumes the install prefix is standard
    - The documentation is not installed
    - The latex packages are found only when installed in standard tex dirs
    """
    def __init__(self, install_object):
        self.install_obj = install_object

    def adapt_paths(self):
        # Add debian-specific python modules to install
        self.install_obj.distribution.packages += ['dbtexmf.contrib',
                                                 'dbtexmf.contrib.debian']
        self.install_obj.distribution.package_dir['dbtexmf.contrib'] = \
                                                                 'lib/contrib'

        # Which latex dirs to maintain under share
        texdirs = glob.glob("latex/*")
        tex_share = []
        for _dir in texdirs:
            if not(os.path.basename(_dir) in ("contrib", "style", "misc")):
                tex_share.append(_dir)

        # Redefine the data install paths
        self.install_obj.distribution.data_files = \
          [('share/dblatex/latex', tex_share),
           ('share/xml/docbook/stylesheet/dblatex', ['xsl']),
           ('share/texmf/tex/latex/dblatex', ['latex/contrib',
                                              'latex/style',
                                              'latex/misc']),
           ('share/man/man1', ['docs/manpage/dblatex.1.gz'])] 
    
    def finalize(self):
        texdir = os.path.join(self.install_obj.install_data,
                              "share/texmf/tex/latex/dblatex")

        # Add the links to the debian standard paths
        contrib_lnk = os.path.join(self.install_obj.install_data, 
                                  'share/dblatex/latex/contrib')
        xsl_lnk = os.path.join(self.install_obj.install_data, 
                               'share/dblatex/xsl')

        if not(os.path.exists(contrib_lnk)):
            os.symlink("../../texmf/tex/latex/dblatex/contrib", contrib_lnk)

        if not(os.path.exists(xsl_lnk)):
            os.symlink("../xml/docbook/stylesheet/dblatex/xsl", xsl_lnk)

        # Remove useless latex packages or license files
        for _file in ("passivetex/LICENSE",
                      "attachfile.sty",
                      "bibtopic.sty",
                      "enumitem.sty",
                      "lastpage.sty",
                      "ragged2e.sty"):
            os.remove("%s" % (os.path.join(texdir, "misc", _file)))

        # Overwrite the dblatex script with the debian specific one
        shutil.copy("lib/contrib/debian/dblatex",
                    self.install_obj.install_scripts)

