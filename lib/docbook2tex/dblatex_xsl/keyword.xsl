<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<!-- keywords are not displayed but become index entries -->

<xsl:template match="keywordset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="subjectset"/>

<xsl:template match="keyword">
  <xsl:text>\index{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>
