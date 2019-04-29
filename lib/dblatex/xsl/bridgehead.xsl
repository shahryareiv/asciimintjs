<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:template match="bridgehead">
  <xsl:param name="renderas" select="@renderas"/>
  <xsl:choose>
    <xsl:when test="$renderas='sect1' or $renderas='sect2' or $renderas='sect3'">
      <xsl:text>&#10;\</xsl:text>
      <xsl:if test="$renderas='sect2'"><xsl:text>sub</xsl:text></xsl:if>
      <xsl:if test="$renderas='sect3'"><xsl:text>subsub</xsl:text></xsl:if>
      <xsl:text>section*{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
      <xsl:call-template name="label.id"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;\paragraph*{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
      <xsl:call-template name="label.id"/>
      <xsl:text>&#10;&#10;\noindent&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
