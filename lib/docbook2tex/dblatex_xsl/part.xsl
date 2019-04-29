<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="part">
  <xsl:text>%&#10;</xsl:text>
  <xsl:text>% PART&#10;</xsl:text>
  <xsl:text>%&#10;</xsl:text>
  <xsl:call-template name="mapheading"/>
  <xsl:apply-templates/>
  <!-- Force exiting the part. It assumes the bookmark package available -->
  <xsl:if test="not(following-sibling::part)">
    <xsl:text>\bookmarksetup{startatroot}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="part/docinfo"/>
<xsl:template match="part/title"/>
<xsl:template match="part/subtitle"/>

<xsl:template match="partintro">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="partintro/title"/>
<xsl:template match="partintro/subtitle"/>
<xsl:template match="partintro/titleabbrev"/>

</xsl:stylesheet>
