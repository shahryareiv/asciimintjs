<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="example.default.position">[H]</xsl:param>
<xsl:param name="example.float.type">none</xsl:param>


<xsl:template match="example">
  <xsl:choose>
    <xsl:when test="@floatstyle='none' or
                   (not(@floatstyle) and $example.float.type='none')">
      <xsl:apply-templates select="." mode="block"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="float"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="example" mode="block">
  <xsl:text>&#10;\begin{longfloat}{example}{</xsl:text>
  <!-- caption -->
  <xsl:apply-templates select="title"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>&#10;\end{longfloat}&#10;</xsl:text>
</xsl:template>

<xsl:template match="example" mode="float">
  <xsl:text>&#10;\begin{example}</xsl:text>
  <!-- float placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$example.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <!-- caption -->
  <xsl:apply-templates select="title"/>
  <xsl:text>&#10;\end{example}&#10;</xsl:text>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="example/title">
  <xsl:text>\caption</xsl:text>
  <xsl:apply-templates select="." mode="format.title"/>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="parent::example"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
