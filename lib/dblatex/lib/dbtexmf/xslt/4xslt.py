#
# 4Suite plugin
#
import sys
import os

from Ft.Xml.Xslt import Processor
from Ft.Lib.Uri import OsPathToUri
from Ft.Xml import Catalog, InputSource
from Ft.Xml.Domlette import NonvalidatingReader

class FourXslt:
    def __init__(self):
        self.verbose = 0
        self.use_catalogs = 1
        # Do it only once
        self.factory = self.get_factory()

    def get_deplist(self):
        return []

    def get_factory(self):
        system_catalogs = ['/etc/xml/catalog',
                           '/usr/local/share/xml/catalog']

        system_catalogs = [p for p in system_catalogs if os.path.exists(p)]

        if system_catalogs:
            xml_catalog_files = os.getenv("XML_CATALOG_FILES")
            if xml_catalog_files:
                xml_catalog_files += " " + " ".join(system_catalogs)
            else:
                xml_catalog_files = " ".join(system_catalogs)
            os.environ["XML_CATALOG_FILES"] = xml_catalog_files

        # The factory now takes into account the new XSML_CATALOG_FILES
        factory = InputSource.InputSourceFactory(catalog=Catalog.GetDefaultCatalog())
        return factory

    def run(self, xslfile, xmlfile, outfile, opts=None, params=None):
        proc = Processor.Processor()
        proc.msgPrefix = ""
        proc.msgSuffix = "\n"
        factory = self.factory

        uri = OsPathToUri(xmlfile)
        xml = factory.fromUri(uri)

        uri =  OsPathToUri(xslfile)
        xslt = factory.fromUri(uri,  processIncludes=False)

        o = open(outfile, "w")
        proc.appendStylesheet(xslt)
        if params:
            rc = proc.run(xml, outputStream=o, topLevelParams=params)
        else:
            rc = proc.run(xml, outputStream=o)
        o.close()


class Xslt(FourXslt):
    "Plugin Class to load"


def main():
    run(sys.argv[1], sys.argv[2], sys.argv[3])

if __name__ == "__main__":
    main()
