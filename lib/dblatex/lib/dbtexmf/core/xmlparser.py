import os
import re
import xml.etree.ElementTree as ET
from txtparser import texinputs_parse

class BaseOption:
    def __init__(self, config, optname):
        self.config = config
        self.optname = optname
        self._value = None

    def optvalue(self):
        return self._value

    def get(self, what, default=None):
        return None

    def options(self):
        value = self.optvalue()
        if self.optname and value:
            return ["%s=%s" % (self.optname, value)]
        else:
            return []

    def fromnode(self, xmlnode):
        self._value = xmlnode.text

    def modules(self):
        return {}

class CommandConfig:
    def __init__(self, config, type="command"):
        self.config = config
        self.type = type
        self.args = []
        self.stdin = None
        self.stdout = None
        self.shell = False

    def options(self):
        return self.args

    def modules(self):
        return {}

    def fromnode(self, xmlnode):
        self.stdin = xmlnode.get("input")
        self.stdout = xmlnode.get("output")
        self.shell = xmlnode.get("shell")
        args = (xmlnode.text or "").split()
        for arg in xmlnode:
            if arg.text: args.append(arg.text)
            args.extend((arg.tail or "").split())
        self.args = args

class TexStyle(BaseOption):
    def __init__(self, config, optname):
        BaseOption.__init__(self, config, optname)
        self.filepath = ""

    def optvalue(self):
        return self.filepath

    def fromnode(self, xmlnode):
        self.filepath = xmlnode.get("fileref") or xmlnode.get("use")

class TexPath(BaseOption):
    def __init__(self, config, optname):
        BaseOption.__init__(self, config, optname)
        self.paths = []

    def optvalue(self):
        return os.pathsep.join(self.paths)

    def fromnode(self, xmlnode):
        if not(xmlnode.text): return
        self.paths = texinputs_parse(xmlnode.text, self.config.basedir)

class FilePath(BaseOption):
    def __init__(self, config, optname):
        BaseOption.__init__(self, config, optname)
        self.filepath = ""

    def optvalue(self):
        return self.filepath

    def fromnode(self, xmlnode):
        filepath = xmlnode.get("fileref")
        if not(filepath):
            return
        if not(os.path.isabs(filepath)):
            filepath = os.path.normpath(os.path.join(self.config.basedir,
                                                     filepath))
        self.filepath = filepath


class ModuleConfig(BaseOption):
    def __init__(self, config, optname):
        BaseOption.__init__(self, config, optname)
        self.commands = []
        self.extra_args = None
        self.module_name = ""
        self.module_file = ""

    def optvalue(self):
        return self.module_name or self.module_file

    def modules(self):
        if self.module_name:
            return {self.module_name: self}
        else:
            return {}

    def fromnode(self, xmlnode):
        ns = { "x": self.config.xmlns }
        self._handle_location(xmlnode)
        xmlopts = xmlnode.find("x:options", ns)
        xmlcmds = xmlnode.find("x:command", ns)
        xmlchain = xmlnode.find("x:commandchain", ns)
        if not(xmlchain is None):
            xmlcmds = xmlchain.findall("x:command", ns)
            for cmd in xmlcmds:
                args = CommandConfig(self.config)
                args.fromnode(cmd)
                self.commands.append(args)
        elif not(xmlcmds is None):
            args = CommandConfig(self.config)
            args.fromnode(xmlcmds)
            self.commands.append(args)
        elif not(xmlopts is None):
            # FIXME
            self.extra_args = CommandConfig(self.config, type="option")
            self.extra_args.fromnode(xmlopts)

    def _handle_location(self, xmlnode):
        self.module_name = xmlnode.get("use")
        self.module_file = xmlnode.get("fileref")
        if not(self.module_name) and self.module_file:
            p = FilePath(self.config, "")
            p.fromnode(xmlnode)
            self.module_file = p.filepath

class ImageConverterConfig(ModuleConfig):
    def __init__(self, config, optname):
        ModuleConfig.__init__(self, config, optname)

    def __repr__(self):
        return self.module_name

    def fromnode(self, xmlnode):
        self.imgsrc = xmlnode.get("src")
        self.imgdst = xmlnode.get("dst")
        self.docformat = xmlnode.get("docformat") or "*"
        self.backend = xmlnode.get("backend") or "*"
        ModuleConfig.fromnode(self, xmlnode)
        name = "%s/%s/%s/%s" % (self.imgsrc, self.imgdst,
                                self.docformat, self.backend)
        self.module_name = name

class ImageFormatConfig(BaseOption):
    def __init__(self, config, optname):
        BaseOption.__init__(self, config, optname)
        self.imgsrc = ""
        self.imgdst = ""
        self.docformat = ""
        self.backend = ""

    def fromnode(self, xmlnode):
        self.imgsrc = xmlnode.get("src")
        self.imgdst = xmlnode.get("dst")
        self.docformat = xmlnode.get("docformat") or "*"
        self.backend = xmlnode.get("backend") or "*"

class XsltEngineConfig(ModuleConfig):
    def __init__(self, config, optname):
        ModuleConfig.__init__(self, config, optname)

    def __repr__(self):
        return self.module_name

    def fromnode(self, xmlnode):
        self.param_format = xmlnode.get("param-format")
        ModuleConfig.fromnode(self, xmlnode)
        if not(self.module_name or self.module_file):
            self.module_name = "xsltconf"

class XmlConfigGroup:
    node_parsers = {}

    def __init__(self, config):
        self.config = config
        self.tagname = ""
        self.infos = {}

    def get(self, tag, default=""):
        if default == "": default = BaseOption(self, "")
        return self.infos.get(tag, default)

    def _register(self, xmlnode, info):
        tag = self.strip_ns(xmlnode.tag)
        taglist = self.infos.get(tag, [])
        taglist.append(info)
        self.infos[tag] = taglist

    def strip_ns(self, tag):
        return self.config.strip_ns(tag)

    def options(self):
        opts = []
        for parsers in self.infos.values():
            for parser in parsers:
                opts.extend(parser.options())
        return opts

    def modules(self):
        mods = {}
        for parsers in self.infos.values():
            for parser in parsers:
                mods.update(parser.modules())
        return mods

    def fromnode(self, xmlnode):
        self.tagname = xmlnode.tag
        for child in xmlnode:
            found = self.node_parsers.get(self.strip_ns(child.tag))
            if found:
                optname, parser_cls = found
                parser = parser_cls(self.config, optname)
                parser.fromnode(child)
                self._register(child, parser)

class LatexConfig(XmlConfigGroup):
    node_parsers = {
        "texinputs":  ("--texinputs", TexPath),
        "bibinputs":  ("--bib-path", TexPath),
        "bstinputs":  ("--bst-path", TexPath),
        "texstyle":   ("--texstyle", TexStyle),
        "indexstyle": ("--indexstyle", FilePath),
        "backend":    ("--backend", ModuleConfig),
        "texpost":    ("--texpost", ModuleConfig)
    }

class XsltConfig(XmlConfigGroup):
    node_parsers = {
        "stylesheet": ("--xsl-user", FilePath),
        "engine":     ("--xslt", XsltEngineConfig)
    }

class ImageConfig(XmlConfigGroup):
    node_parsers = {
        "figpath": ("--fig-path", FilePath),
        "figformat": ("--fig-format", BaseOption),
        "converter": ("", ImageConverterConfig),
        "formatrule": ("", ImageFormatConfig)
    }


class XmlConfig:
    """
    Parses an XML configuration file and stores its data in
    configuration objects.
    """
    node_parsers = {
        "latex": LatexConfig,
        "xslt": XsltConfig,
        "imagedata": ImageConfig,
        "options": CommandConfig
    }
    xmlns = "http://dblatex.sourceforge.net/config"
    root_tag = "config"

    def __init__(self):
        self.basedir = ""
        self.infos = {}

    def _register(self, xmlnode, info):
        self.infos[self.strip_ns(xmlnode.tag)] = info

    def get(self, tag, default=""):
        if default == "": default = BaseOption(self, "")
        return self.infos.get(tag, default)

    def options(self):
        opts = []
        for parser in self.infos.values():
            opts.extend(parser.options())
        return opts

    def modules(self):
        mods = {}
        for parser in self.infos.values():
            mods.update(parser.modules())
        return mods

    def strip_ns(self, tag):
        return tag.replace("{%s}" % self.xmlns, "", 1)

    def fromfile(self, filename):
        self.basedir = os.path.dirname(os.path.realpath(filename))

        document = ET.parse(filename)
        root = document.getroot()
        self._check_root(root.tag)
        for child in root:
            parser_cls = self.node_parsers.get(self.strip_ns(child.tag))
            if parser_cls:
                parser = parser_cls(self)
                parser.fromnode(child)
                self._register(child, parser)

    def _check_root(self, root):
        xmlns, tag = self._split_xmlns(root)
        if tag != self.root_tag:
            raise ValueError("Expect the XML config root element being '%s'" % \
                             self.root_tag)
        if xmlns and xmlns != self.xmlns:
            raise ValueError("Invalid XML config xmlns: '%s'" % xmlns)

    def _split_xmlns(self, tag):
        m = re.match("{([^}]+)}(.*)", tag)
        if m:
            return m.group(1), m.group(2)
        else:
            return "", tag

