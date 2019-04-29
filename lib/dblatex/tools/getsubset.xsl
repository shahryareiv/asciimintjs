<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version="1.0">

<!-- This stylesheet builds the latex data just for a portion of the input
     XML document, the portion being identified by its identifier (@id)
     through the '$extractid' parameter.

     No need to <xsl:import> the main dblatex XSL stylesheet, since dblatex
     does it for you.
-->

<xsl:param name="extractid"/>

<xsl:template match="/">
  <xsl:apply-templates mode="extract"/>
</xsl:template>

<xsl:template match="*" mode="extract">
  <xsl:choose>
  <xsl:when test="@id=$extractid">
    <xsl:message>
      <xsl:text>Found '</xsl:text>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text>' with id='</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>'</xsl:text>
    </xsl:message>
    <xsl:variable name="texdata">
      <!-- do the normal stuff -->
      <xsl:apply-templates select="."/>
    </xsl:variable>

    <!-- output the partial object as whole document -->
    <xsl:call-template name="wrap.tex">
      <xsl:with-param name="content" select="$texdata"/>
    </xsl:call-template>

    <!-- building an intermediate file instead would be:
    <xsl:call-template name="build.texfile">
      <xsl:with-param name="content" select="$texdata"/>
      <xsl:with-param name="id" select="@id"/>
    </xsl:call-template>

    -->
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates mode="extract"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="extract"/>

<!-- Content of the tex file -->
<xsl:template name="wrap.tex">
  <xsl:param name="content"/>

  <xsl:text>\documentclass</xsl:text>
  <xsl:if test="$latex.class.options!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$latex.class.options"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>{article}&#10;</xsl:text>
  <xsl:text>\usepackage[T1]{fontenc}&#10;</xsl:text>
  <xsl:text>\usepackage[latin1]{inputenc}&#10;</xsl:text>

  <xsl:call-template name="font.setup"/>
  <xsl:text>\usepackage[hyperlink]{</xsl:text>
  <xsl:value-of select="$latex.style"/>
  <xsl:text>}&#10;</xsl:text>

  <xsl:call-template name="citation.setup"/>
  <xsl:call-template name="lang.setup"/>

  <xsl:text>\pagestyle{empty}&#10;</xsl:text>

  <xsl:text>\begin{document}&#10;</xsl:text>
  <xsl:value-of select="$content"/>
  <xsl:text>\end{document}&#10;</xsl:text>
</xsl:template>

<!-- Build a latex file -->
<!-- In the case one wants to build an intermediate file -->
<xsl:template name="build.texfile">
  <xsl:param name="content"/>
  <xsl:param name="id"/>
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename">
      <xsl:text>tex_</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>.rtex</xsl:text>
    </xsl:with-param>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:call-template name="wrap.tex">
        <xsl:with-param name="content" select="$content"/>
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
