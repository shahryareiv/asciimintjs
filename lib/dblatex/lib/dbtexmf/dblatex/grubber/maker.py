# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
This module contains all the classes used to manage the building
dependencies.
"""
import os
import time
import subprocess

from msg import _, msg

class Depend (object): #{{{2
    """
    This is a base class to represent file dependencies. It provides the base
    functionality of date checking and recursive making, supposing the
    existence of a method `run()' in the object. This method is supposed to
    rebuild the files of this node, returning zero on success and something
    else on failure.
    """
    def __init__ (self, env, prods=None, sources={}, loc={}):
        """
        Initialize the object for a given set of output files and a given set
        of sources. The argument `prods' is a list of file names, and the
        argument `sources' is a dictionary that associates file names with
        dependency nodes. The optional argument `loc' is a dictionary that
        describes where in the sources this dependency was created.
        """
        self.env = env
        if prods:
            self.prods = prods
        else:
            self.prods = []
        self.set_date()
        self.sources = sources
        self.making = 0
        self.failed_dep = None
        self.loc = loc

    def set_date (self):
        """
        Define the date of the last build of this node as that of the most
        recent file among the products. If some product does not exist or
        there are ne products, the date is set to None.
        """
        if self.prods == []:
            # This is a special case used in rubber.Environment
            self.date = None
        else:
            try:
                # We set the node's date to that of the most recently modified
                # product file, assuming all other files were up to date then
                # (though not necessarily modified).
                self.date = max(map(os.path.getmtime, self.prods))
            except OSError:
                # If some product file does not exist, set the last
                # modification date to None.
                self.date = None

    def should_make (self):
        """
        Check the dependencies. Return true if this node has to be recompiled,
        i.e. if some dependency is modified. Nothing recursive is done here.
        """
        if not self.date:
            return 1
        for src in self.sources.values():
            if src.date > self.date:
                return 1
        return 0

    def make (self, force=0):
        """
        Make the destination file. This recursively makes all dependencies,
        then compiles the target if dependencies were modified. The semantics
        of the return value is the following:
        - 0 means that the process failed somewhere (in this node or in one of
          its dependencies)
        - 1 means that nothing had to be done
        - 2 means that something was recompiled (therefore nodes that depend
          on this one have to be remade)
        """
        if self.making:
            print "FIXME: cyclic make"
            return 1
        self.making = 1

        # Make the sources
        self.failed_dep = None
        must_make = force
        for src in self.sources.values():
            ret = src.make()
            if ret == 0:
                self.making = 0
                self.failed_dep = src.failed_dep
                return 0
            if ret == 2:
                must_make = 1
        
        # Make this node if necessary

        if must_make or self.should_make():
            if force:
                ret = self.force_run()
            else:
                ret = self.run()
            if ret:
                self.making = 0
                self.failed_dep = self
                return 0

            # Here we must take the integer part of the value returned by
            # time.time() because the modification times for files, returned
            # by os.path.getmtime(), is an integer. Keeping the fractional
            # part could lead to errors in time comparison with the main log
            # file when the compilation of the document is shorter than one
            # second...

            self.date = int(time.time())
            self.making = 0
            return 2
        self.making = 0
        return 1

    def force_run (self):
        """
        This method is called instead of 'run' when rebuilding this node was
        forced. By default it is equivalent to 'run'.
        """
        return self.run()

    def failed (self):
        """
        Return a reference to the node that caused the failure of the last
        call to "make". If there was no failure, return None.
        """
        return self.failed_dep

    def get_errors (self):
        """
        Report the errors that caused the failure of the last call to run.
        """
        if None:
            yield None

    def clean (self):
        """
        Remove the files produced by this rule and recursively clean all
        dependencies.
        """
        for file in self.prods:
            if os.path.exists(file):
                msg.log(_("removing %s") % file)
                os.unlink(file)
        for src in self.sources.values():
            src.clean()
        self.date = None

    def reinit (self):
        """
        Reinitializing depends on actual dependency leaf
        """
        pass

    def leaves (self):
        """
        Return a list of all source files that are required by this node and
        cannot be built, i.e. the leaves of the dependency tree.
        """
        if self.sources == {}:
            return self.prods
        ret = []
        for dep in self.sources.values():
            ret.extend(dep.leaves())
        return ret


class DependLeaf (Depend): #{{{2
    """
    This class specializes Depend for leaf nodes, i.e. source files with no
    dependencies.
    """
    def __init__ (self, env, *dest, **args):
        """
        Initialize the node. The arguments of this method are the file
        names, since one single node may contain several files.
        """
        Depend.__init__(self, env, prods=list(dest), **args)

    def run (self):
        # FIXME
        if len(self.prods) == 1:
            msg.error(_("%r does not exist") % self.prods[0], **self.loc)
        else:
            msg.error(_("one of %r does not exist") % self.prods, **self.loc)
        return 1

    def clean (self):
        pass


class DependShell (Depend): #{{{2
    """
    This class specializes Depend for generating files using shell commands.
    """
    def __init__ (self, env, cmd, **args):
        Depend.__init__(self, env, **args)
        self.cmd = cmd

    def run (self):
        msg.progress(_("running %s") % self.cmd[0])
        rc = subprocess.call(self.cmd, stdout=msg.stdout)
        if rc != 0:
            msg.error(_("execution of %s failed") % self.cmd[0])
            return 1
        return 0


class Maker:
    """
    Very simple builder environment. Much simpler than the original rubber
    Environment.
    """
    def __init__(self):
        self.dep_nodes = []

    def dep_last(self):
        if not(self.dep_nodes):
            return None
        else:
            return self.dep_nodes[-1]

    def dep_append(self, dep):
        self.dep_nodes.append(dep)

    def make(self, force=0):
        if not(self.dep_nodes):
            return 0
        # Just ask the last one to compile
        rc = self.dep_nodes[-1].make(force=force)
        if (rc == 0):
            return -1
        else:
            return 0

    def reinit(self):
        # Forget the old dependency nodes
        self.__init__()

