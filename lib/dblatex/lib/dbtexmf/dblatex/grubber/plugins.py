# This file is part of Rubber and thus covered by the GPL
# (c) Emmanuel Beffara, 2002--2006
"""
Mechanisms to dynamically load extra modules to help the LaTeX compilation.
All the modules must be derived from the TexModule class.
"""
import imp

from os.path import *
from msg import _, msg

import sys

class TexModule (object):
    """
    This is the base class for modules. Each module should define a class
    named 'Module' that derives from this one. The default implementation
    provides all required methods with no effects.
    """
    def __init__ (self, env, dict):
        """
        The constructor receives two arguments: 'env' is the compiling
        environment, 'dict' is a dictionary that describes the command that
        caused the module to load.
        """

    def pre_compile (self):
        """
        This method is called before the first LaTeX compilation. It is
        supposed to build any file that LaTeX would require to compile the
        document correctly. The method must return true on failure.
        """
        return 0

    def post_compile (self):
        """
        This method is called after each LaTeX compilation. It is supposed to
        process the compilation results and possibly request a new
        compilation. The method must return true on failure.
        """
        return 0

    def last_compile (self):
        """
        This method is called after the last LaTeX compilation.
        It is supposed to terminate the compilation for its specific needs.
        The method must return true on failure.
        """
        return 0

    def clean (self):
        """
        This method is called when cleaning the compiled files. It is supposed
        to remove all the files that this modules generates.
        """

    def command (self, cmd, args):
        """
        This is called when a directive for the module is found in the source.
        The method can raise 'AttributeError' when the directive does not
        exist and 'TypeError' if the syntax is wrong. By default, when called
        with argument "foo" it calls the method "do_foo" if it exists, and
        fails otherwise.
        """
        getattr(self, "do_" + cmd)(*args)

    def get_errors (self):
        """
        This is called if something has failed during an operation performed
        by this module. The method returns a generator with items of the same
        form as in LaTeXDep.get_errors.
        """
        if None:
            yield None


class Plugins (object):
    """
    This class gathers operations related to the management of external Python
    modules. Modules are requested through the `register' method, and
    they are searched for first in the current directory, then in the
    (possibly) specified Python package (using Python's path).
    """
    def __init__ (self, path=None):
        """
        Initialize the module set, possibly setting a path name in which
        modules will be searched for.
        """
        self.modules = {}
        if not path:
            self.path = [dirname(__file__)]
            sys.path.append(self.path[0])
        else:
            self.path = path

    def __getitem__ (self, name):
        """
        Return the module object of the given name.
        """
        return self.modules[name]

    def register (self, name):
        """
        Attempt to register a module with the specified name. If an
        appropriate module is found, load it and store it in the object's
        dictionary. Return 0 if no module was found, 1 if a module was found
        and loaded, and 2 if the module was found but already loaded.
        """
        if self.modules.has_key(name):
            return 2
        try:
            file, path, descr = imp.find_module(name, [""])
        except ImportError:
            if not self.path:
                return 0
            try:
                file, path, descr = imp.find_module(name, self.path)
            except ImportError:
                return 0
        module = imp.load_module(name, file, path, descr)
        file.close()
        self.modules[name] = module
        return 1

    def clear(self):
        """
        Empty the module table, unregistering every module registered. No
        modules are unloaded, however, but this has no other effect than
        speeding the registration if the modules are loaded again.
        """
        self.modules.clear()


class Modules (Plugins):
    """
    This class gathers all operations related to the management of modules.
    The modules are    searched for first in the current directory, then as
    scripts in the 'modules' directory in the program's data directort, then
    as a Python module in the package `rubber.latex'.
    """
    def __init__ (self, env):
        #Plugins.__init__(self, rubber.rules.latex.__path__)
        Plugins.__init__(self)
        self.env = env
        self.objects = {}
        self.commands = {}

    def __getitem__ (self, name):
        """
        Return the module object of the given name.
        """
        return self.objects[name]

    def has_key (self, name):
        """
        Check if a given module is loaded.
        """
        return self.objects.has_key(name)

    def register (self, name, dict={}):
        """
        Attempt to register a package with the specified name. If a module is
        found, create an object from the module's class called `Module',
        passing it the environment and `dict' as arguments, and execute all
        delayed commands for this module. The dictionary describes the
        command that caused the registration.
        """
        if self.has_key(name):
            msg.debug(_("module %s already registered") % name)
            return 2

        # First look for a script

        moddir = ""
        mod = None
        for path in "", join(moddir, "modules"):
            file = join(path, name + ".rub")
            if exists(file):
                mod = ScriptModule(self.env, file)
                msg.log(_("script module %s registered") % name)
                break

        # Then look for a Python module

        if not mod:
            if Plugins.register(self, name) == 0:
                msg.debug(_("no support found for %s") % name)
                return 0
            mod = self.modules[name].Module(self.env, dict)
            msg.log(_("built-in module %s registered") % name)

        # Run any delayed commands.

        if self.commands.has_key(name):
            for (cmd, args, vars) in self.commands[name]:
                msg.push_pos(vars)
                try:
                    mod.command(cmd, args)
                except AttributeError:
                    msg.warn(_("unknown directive '%s.%s'") % (name, cmd))
                except TypeError:
                    msg.warn(_("wrong syntax for '%s.%s'") % (name, cmd))
                msg.pop_pos()
            del self.commands[name]

        self.objects[name] = mod
        return 1

    def clear (self):
        """
        Unregister all modules.
        """
        Plugins.clear(self)
        self.objects = {}
        self.commands = {}

    def command (self, mod, cmd, args):
        """
        Send a command to a particular module. If this module is not loaded,
        store the command so that it will be sent when the module is register.
        """
        if self.objects.has_key(mod):
            self.objects[mod].command(cmd, args)
        else:
            if not self.commands.has_key(mod):
                self.commands[mod] = []
            self.commands[mod].append((cmd, args, self.env.vars.copy()))

