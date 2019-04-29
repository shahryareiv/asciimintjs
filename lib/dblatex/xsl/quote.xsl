<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="epigraph|blockquote">
  <xsl:text>\begin{quote}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::attribution)]"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="attribution"/>
  <xsl:text>\end{quote}&#10;</xsl:text>
</xsl:template>

<xsl:template match="epigraph/title|blockquote/title">
  <xsl:text>{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="attribution">
  <xsl:text>\hspace*\fill---</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
