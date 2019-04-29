<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    version='1.0'>

<xsl:import href="mmltex.xsl"/>

<!-- because xsltproc cannot strip "m:*" elements -->
<xsl:strip-space elements="m:math m:mrow m:mstyle m:mtd m:mphantom
                           m:mi m:mo m:ms m:mn m:mtext m:maction"/>

<!-- hook for mml text template -->
<xsl:template name="mmltext">
  <xsl:call-template name="replaceEntities">
    <xsl:with-param name="content" select="normalize-space()"/>
  </xsl:call-template>
</xsl:template>

<!-- ====================================
     MML TeX patches or missing templates
     ==================================== -->

<!-- to put mathml in a latex (informal) equation environment -->
<xsl:template match="m:math">
  <xsl:choose>
  <xsl:when test="ancestor::equation[not(child::title)]">
    <xsl:apply-templates/>
  </xsl:when>
  <xsl:when test="ancestor::informalequation">
    <xsl:text>&#10;\[&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text> \]&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-imports/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- don't know how to render this -->
<xsl:template match="m:maligngroup"/>

<!-- 3.3.6 -->
<!-- don't know how to render this -->
<xsl:template match="m:mpadded">
  <xsl:apply-templates/>
</xsl:template>

<!-- 4.4.2.3 fn -->
<xsl:template match="m:fn"> <!-- for m:fn alone -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="m:malignmark|m:maction">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
