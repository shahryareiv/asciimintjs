import os
import glob
import re
from subprocess import Popen, PIPE
from xml.dom.minidom import parseString

def strip_list(lst, patterns):
    striped = []
    for p in lst:
        strip = 0
        for pat in patterns:
            if pat in p:
                strip = 1
                break
        if not(strip):
            striped.append(p)
    return striped


def get_doc_params(docparam):
    xsl_params_get = \
"""<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:output method="text" indent="yes"/> 

<xsl:template match="programlisting">
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="/">
  <xsl:apply-templates select="//programlisting"/>
</xsl:template>

</xsl:stylesheet>
"""

    xsltmp = "/tmp/getparam.xsl"
    xsl = open("/tmp/getparam.xsl", "w")
    xsl.write(xsl_params_get)
    xsl.close()

    p = Popen("xsltproc --xinclude %s %s" % (xsltmp, docparam), shell=True,
              stdout=PIPE, )#stderr=open("/dev/null", "w"))
    data = p.communicate()[0].split("\n")
    params = []
    for line in data:
        m = re.search("<xsl:param *name=\"([^\"]*)", line)
        if m:
            params.append(m.group(1)+".xml")

    return params

def get_xsl_params(xslextract, xsltarget):
    # Get the list of all the parameters
    p = Popen("xsltproc %s %s" % (xslextract, xsltarget), shell=True,
              stdout=PIPE, stderr=open("/dev/null", "w"))
    dom = parseString(p.communicate()[0])

    params = []
    for e in dom.getElementsByTagName("xsl:param"):
        params.append(str(e.getAttribute("name"))+".xml")
    return params


def main():
    tooldir = os.path.dirname(__file__)
    topdir = os.path.abspath(os.path.join(tooldir, ".."))
    xslextract = os.path.join(topdir, "tools", "paramextract.xsl")
    xsltarget = os.path.join(topdir, "xsl", "docbook.xsl")
    synopdir = os.path.join(topdir, "docs", "params", "syn")
    refentdir = os.path.join(topdir, "docs", "params")

    # d1 = get_doc_params(os.path.join(refentdir, "param.xml"))

    # parfiles
    parfiles = get_xsl_params(xslextract, xsltarget)

    # Get the list of parameter synopsis
    synfiles = [os.path.basename(f) for f in glob.glob("%s/*.xml" % synopdir)]

    # Get the list of parameter refentries
    reffiles = [os.path.basename(f) for f in glob.glob("%s/*.xml" % refentdir)]

    # Strip parameters we know are not documented
    tostrip = ("l10n", "olink", "chunker", "autolabel",
               "target.database.document", "targets.filename",
               "current.docid")
    parfiles = strip_list(parfiles, tostrip)
    synfiles = strip_list(synfiles, tostrip)
    reffiles = strip_list(reffiles, tostrip)

    parfiles.sort()
    synfiles.sort()
    reffiles.sort()

    # Strip files that are not parameter refentries
    for p in ("param", "template"):
        reffiles.remove(p+".xml")

    # Check if there's some missed parameters
    sp = set(parfiles)
    ss = set(synfiles)
    sr = set(reffiles)

    torem_from_syn = ss - sp
    print "==========="
    print "In param list, missing in %s:\n" % (synopdir), sp - ss
    print "\nIn param list, missing in refentries:\n", sp - sr
    print "\nIn synopsis, not in param list:\n", torem_from_syn
    print "\nIn synopsis, missing in refentries:\n", ss - sr - torem_from_syn
    print "\nIn refentries, missing in %s:\n" % (synopdir), sr - ss


if __name__ == "__main__":
    main()
