<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:template match="footnote">
  <xsl:choose>
  <!-- in forbidden areas, only put the footnotemark. footnotetext will
       follow in the next possible area (foottext mode) -->
  <xsl:when test="ancestor::term|
                  ancestor::title">
    <xsl:text>\footnotemark{}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\footnote{</xsl:text>
    <xsl:call-template name="label.id">
      <xsl:with-param name="inline" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Table cells are forbidden for footnotes -->
<xsl:template match="footnote[ancestor::entry]">
  <xsl:text>\footnotemark{}</xsl:text>
</xsl:template>

<xsl:template match="footnoteref">
  <!-- Works only with footmisc -->
  <xsl:text>\footref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- display the text of the footnotes contained in this element -->
<xsl:template match="*" mode="foottext">
  <xsl:variable name="foot" select="descendant::footnote"/>
  <xsl:if test="count($foot)&gt;0">
    <xsl:text>\addtocounter{footnote}{-</xsl:text>
    <xsl:value-of select="count($foot)"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="$foot" mode="foottext"/>
  </xsl:if>
</xsl:template>

<xsl:template match="footnote" mode="foottext">
  <xsl:text>\stepcounter{footnote}&#10;</xsl:text>
  <xsl:text>\footnotetext{</xsl:text>
  <xsl:apply-templates/>
  <xsl:call-template name="label.id"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- in a programlisting do as normal but in tex-escaped pattern -->
<xsl:template match="footnote" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.embed">
    <xsl:with-param name="co-taging" select="$co-tagin"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="*" mode="toc.skip">
  <xsl:apply-templates mode="toc.skip"/>
</xsl:template>

<!-- escape characters as usual -->
<xsl:template match="text()" mode="toc.skip">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- in this mode the footnotes must vanish -->
<xsl:template match="footnote" mode="toc.skip"/>

</xsl:stylesheet>
