<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="screenshot">
  <xsl:if test="not(parent::figure)">
    <xsl:call-template name="figure.begin"/>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="not(parent::figure)">
    <xsl:call-template name="figure.end"/>
  </xsl:if>
</xsl:template>

<xsl:template match="screeninfo"/>

<xsl:template match="inlinegraphic|graphic">
  <xsl:choose>
  <xsl:when test="$imagedata.file.check='1'">
    <xsl:variable name="filename">
      <xsl:apply-templates select="." mode="filename.get"/>
    </xsl:variable>
    <xsl:text>\imgexists{</xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="imagedata"/>
    <xsl:text>}{[</xsl:text>
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="$filename"/>
    </xsl:call-template>
    <xsl:text> not found]}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="imagedata"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
