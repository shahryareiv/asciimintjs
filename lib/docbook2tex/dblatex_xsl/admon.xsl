<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:param name="figure.note"/>
<xsl:param name="figure.tip"/>
<xsl:param name="figure.important">warning</xsl:param>
<xsl:param name="figure.warning">warning</xsl:param>
<xsl:param name="figure.caution">warning</xsl:param>

<xsl:template match="note|important|warning|caution|tip">
  <xsl:text>\begin{DBKadmonition}{</xsl:text>
  <xsl:call-template name="admon.graphic"/><xsl:text>}{</xsl:text>
  <xsl:choose> 
    <xsl:when test="title">
      <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="title"/></xsl:call-template>
    </xsl:when> 
    <xsl:otherwise>
      <xsl:call-template name="gentext.element.name"/>
    </xsl:otherwise> 
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{DBKadmonition}&#10;</xsl:text>
</xsl:template>

<xsl:template match="note/title|important/title|
                     warning/title|caution/title|tip/title"/>

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="name($node)='warning'">
      <xsl:value-of select="$figure.warning"/>
    </xsl:when>
    <xsl:when test="name($node)='caution'">
      <xsl:value-of select="$figure.caution"/>
    </xsl:when>
    <xsl:when test="name($node)='important'">
      <xsl:value-of select="$figure.important"/>
    </xsl:when>
    <xsl:when test="name($node)='note'">
      <xsl:value-of select="$figure.note"/>
    </xsl:when>
    <xsl:when test="name($node)='tip'">
      <xsl:value-of select="$figure.tip"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
