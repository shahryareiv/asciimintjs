#
# Simple converter from text configuration to XML configuration
#
import sys
import os
import xml.etree.ElementTree as ET
import xml.dom.minidom

package_base = os.path.join(os.path.dirname(sys.argv[0]), "..")
sys.path.append(os.path.realpath(os.path.join(package_base, "lib")))

from dbtexmf.core.txtparser import TextConfig

class XmlMapper:
    """
    Make a correspondence beetween text keywords to equivalent XML nodes
    and how to convert the keyword data to XML content (fill_method)
    """
    def __init__(self, fill_method, *args):
        self.tags = args
        self.value = None
        self.fill_method = fill_method

    def format(self, dir, value):
        self.value = value
        return [self]


class TextXmlMapper(TextConfig):
    """
    Use the original class to parse the text config file the same way,
    but give to this class the role to map the config data to XML equivalent
    """
    conf_mapping = {
        'TexInputs' : XmlMapper("text", 'latex','texinputs'),
        'TexPost'   : XmlMapper("mod_or_file", 'latex','texpost'),
        'FigPath'   : XmlMapper("file", 'imagedata','figpath'),
        'XslParam'  : XmlMapper("file", 'xslt','stylesheet'),
        'TexStyle'  : XmlMapper("mod_or_file", 'latex','texstyle'),
        'Options'   : XmlMapper("text", 'options')
    }

class XmlConfig:
    """
    Build an XML configuration file from an XML mapping
    """
    xmlns = "http://dblatex.sourceforge.net/config"
    def __init__(self, config_dir=""):
        self.root = ET.Element("config")
        self.root.set("xmlns", self.xmlns)
        self.tree = ET.ElementTree(self.root)
        ET.register_namespace("", self.xmlns)
        self.config_dir = config_dir

    def add_element(self, xmldesc):
        xmlnode = self.root
        for tag in xmldesc.tags[:-1]:
            element = xmlnode.find(tag)
            if not(element is None):
                xmlnode = element
            else:
                xmlnode = ET.SubElement(xmlnode, tag)

        last_node = ET.SubElement(xmlnode, xmldesc.tags[-1])
        self.fill_node(last_node, xmldesc.value, xmldesc.fill_method)

    def write(self, stream):
        data = ET.tostring(self.root)
        doc = xml.dom.minidom.parseString(data)
        stream.write(doc.toprettyxml(indent="  "))

    def fill_node(self, xmlnode, value, fill_method):
        fill_calls = {
            "file": self.fill_file,
            "text": self.fill_text,
            "mod_or_file": self.fill_mod_or_file
        }
        fill_function = fill_calls.get(fill_method, None)
        if fill_function: fill_function(xmlnode, value)

    def fill_file(self, xmlnode, value):
        xmlnode.set("fileref", value)

    def fill_mod(self, xmlnode, value):
        xmlnode.set("use", value)

    def fill_text(self, xmlnode, value):
        xmlnode.text = value
        
    def fill_mod_or_file(self, xmlnode, value):
        if os.path.isabs(value) and os.path.isfile(value):
            self.fill_file(xmlnode, value)
        elif os.path.isfile(os.path.join(self.config_dir, value)):
            self.fill_file(xmlnode, value)
        else:
            self.fill_mod(xmlnode, value)


if __name__ == "__main__":
    from optparse import OptionParser
    parser = OptionParser(usage="%s <config_input.txt> <config_output.xml>" \
                          % sys.argv[0])

    (options, args) = parser.parse_args()

    if len(args) != 2:
        print >> sys.stderr, "Invalid argument count: expected 2"
        parser.parse_args(["-h"])

    txt_file = args[0]
    xml_file = args[1]

    txt_config = TextXmlMapper()
    txt_config.fromfile(txt_file)

    xml_config = XmlConfig(os.path.dirname(txt_file))
    for xmldesc in txt_config.options():
        xml_config.add_element(xmldesc)

    f = open(xml_file, "w")
    xml_config.write(f)
    f.close()

