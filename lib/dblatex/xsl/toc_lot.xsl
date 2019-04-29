<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- ToC/LoT parameters -->
<xsl:param name="doc.lot.show">figure,table</xsl:param>
<xsl:param name="doc.toc.show">1</xsl:param>


<!-- Noting to do: things are done by latex -->
<xsl:template match="toc"/>
<xsl:template match="lot"/>
<xsl:template match="lotentry"/>
<xsl:template match="tocpart|tocchap|tocfront|tocback|tocentry"/>
<xsl:template match="toclevel1|toclevel2|toclevel3|toclevel4|toclevel5"/>


<!-- Print one LoT -->
<xsl:template match="book|article" mode="lot">
  <xsl:param name="lot"/>

  <xsl:choose>
  <xsl:when test="$lot='figure' and .//figure">
    <xsl:text>\listoffigures&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$lot='table' and .//table">
    <xsl:text>\listoftables&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$lot='example' and .//example">
    <!-- A non standard float list -->
    <xsl:text>\listof{</xsl:text>
    <xsl:value-of select="$lot"/>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'ListofExamples'"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$lot='equation' and .//equation">
    <!-- A non standard float list -->
    <xsl:text>\listof{dbequation}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'ListofEquations'"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- Print the ToC and all the LoTs listed in $doc.lot.show -->
<xsl:template match="book|article" mode="toc_lots">
  <xsl:if test="$doc.toc.show != '0'">
    <xsl:text>\tableofcontents&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="." mode="lots"/>
</xsl:template>

<!-- Print all the LoTs listed in $doc.lot.show -->
<xsl:template match="book|article" mode="lots">
  <xsl:param name="lots" select="$doc.lot.show"/>

  <xsl:choose>
  <xsl:when test="contains($lots, ',')">
    <xsl:apply-templates select="." mode="lot">
      <xsl:with-param name="lot"
                      select="normalize-space(substring-before($lots, ','))"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="lots">
      <xsl:with-param name="lots" select="substring-after($lots, ',')"/>
    </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="." mode="lot">
      <xsl:with-param name="lot" select="normalize-space($lots)"/>
    </xsl:apply-templates>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Update the TOC depth for printed TOC and PDF bookmarks -->
<xsl:template name="set-tocdepth">
  <xsl:param name="depth"/>
  <!-- For printed TOC -->
  <xsl:text>\addtocontents{toc}{\protect\setcounter{tocdepth}{</xsl:text>
  <xsl:value-of select="$depth"/>
  <xsl:text>}\ignorespaces}&#10;</xsl:text>
  <!-- For bookmarks -->
  <xsl:text>\setcounter{tocdepth}{</xsl:text>
  <xsl:value-of select="$depth"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
