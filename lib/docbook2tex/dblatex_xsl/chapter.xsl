<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="chapter">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% ------- &#10;</xsl:text>
  <xsl:text>% Chapter &#10;</xsl:text>
  <xsl:text>% ------- &#10;</xsl:text>
  <xsl:call-template name="mapheading"/>
  <xsl:apply-templates/>
</xsl:template>

<!-- An empty label specifies an unnumbered chapter -->
<xsl:template match="chapter[@label and @label='']">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% ------------------ &#10;</xsl:text>
  <xsl:text>% Unnumbered Chapter &#10;</xsl:text>
  <xsl:text>% ------------------ &#10;</xsl:text>
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="$toc.section.depth + 1"/>
    <xsl:with-param name="level" select="0"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter/title"/>
<xsl:template match="chapter/titleabbrev"/>
<xsl:template match="chapter/subtitle"/>
<xsl:template match="chapterinfo/pubdate"/>
<xsl:template match="chapter/docinfo|chapterinfo">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

