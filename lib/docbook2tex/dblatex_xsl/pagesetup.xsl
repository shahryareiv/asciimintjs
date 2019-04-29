<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################
    
    This stylesheet allows to setup paper and page dimensions through some
    predefined parameters. Most of the page setup parameters come from the
    DocBook XSL FO parameters. The latex packages used to perform this setup
    are the well known 'geometry' and 'crop'.

    This feature has been sponsored by Freexian (http://www.freexian.com).
    
-->
<xsl:param name="page.height"/>
<xsl:param name="page.margin.bottom"/>
<xsl:param name="page.margin.inner"/>
<xsl:param name="page.margin.outer"/>
<xsl:param name="page.margin.top"/>
<xsl:param name="page.width"/>
<xsl:param name="paper.type"/>
<xsl:param name="geometry.options"/>
<xsl:param name="crop.marks" select="0"/>
<xsl:param name="crop.paper.type"/>
<xsl:param name="crop.page.width"/>
<xsl:param name="crop.page.height"/>
<xsl:param name="crop.mode" select="'cam'"/>
<xsl:param name="crop.options"/>

<xsl:template name="page.setup">

  <xsl:variable name="geometry.setup">
    <geometry paperwidth="{$page.width}"
              paperheight="{$page.height}"
              papername="{$paper.type}"
              right="{$page.margin.outer}"
              left="{$page.margin.inner}"
              top="{$page.margin.top}"
              bottom="{$page.margin.bottom}"/>
  </xsl:variable>

  <xsl:variable name="geometry.params">
    <xsl:for-each select="exsl:node-set($geometry.setup)//@*">
      <xsl:if test=". != ''">
        <xsl:value-of select="local-name()"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$geometry.options"/>
  </xsl:variable>

  <!-- The body includes the header and footer -->
  <xsl:if test="$geometry.params != ''">
    <xsl:text>\usepackage[includeheadfoot,</xsl:text> 
    <xsl:value-of select="$geometry.params"/>
    <xsl:text>]{geometry}&#10;</xsl:text> 
  </xsl:if>

  <xsl:if test="$crop.marks != 0">
    <xsl:variable name="crop.params">
      <xsl:choose>
      <xsl:when test="$crop.paper.type != ''">
        <xsl:value-of select="$crop.paper.type"/>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:when test="$crop.page.width != '' and
                      $crop.page.height != ''">
        <!-- No 'true' length, assuming no scaling -->
        <xsl:text>width=</xsl:text>
        <xsl:value-of select="$crop.page.width"/>
        <xsl:text>,</xsl:text>
        <xsl:text>height=</xsl:text>
        <xsl:value-of select="$crop.page.height"/>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: crop required without crop size setup</xsl:text>
        </xsl:message>
      </xsl:otherwise>

      <!-- FIXME: find out how to use crop.margin. The following fails:
      <xsl:otherwise>
        <xsl:text>width=\pagewidth</xsl:text>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>,</xsl:text>
        <xsl:text>height=\pageheight</xsl:text>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>,</xsl:text>
      </xsl:otherwise>
      -->
      </xsl:choose>
      <xsl:value-of select="$crop.options"/>
    </xsl:variable>

    <xsl:if test="$crop.params != ''">
      <xsl:text>\usepackage[</xsl:text> 
      <xsl:value-of select="$crop.params"/>
      <xsl:text>center,</xsl:text>
      <xsl:value-of select="$crop.mode"/>
      <xsl:text>]{crop}&#10;</xsl:text> 
    </xsl:if>
  </xsl:if>

</xsl:template>

<!-- Unit-test cases:
     dblatex -P paper.type=a5paper
             -P page.margin.outer=1cm
             -P page.margin.inner=3cm pagesetup.xml

     dblatex -P paper.type=a5paper
             -P page.margin.outer=1cm
             -P page.margin.inner=3cm
             -P crop.marks=1
             -P crop.paper.type=a4 pagesetup.xml

     dblatex -P page.width=18.89cm
             -P page.height=24.58cm
             -P page.margin.outer=1cm
             -P page.margin.inner=3cm
             -P crop.marks=1 
             -P crop.page.width=21cm
             -P crop.page.height=29.7cm pagesetup.xml
-->
</xsl:stylesheet>
