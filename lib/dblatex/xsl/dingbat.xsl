<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template name="dingbat">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:call-template name="dingbat.characters">
    <xsl:with-param name="dingbat" select="$dingbat"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dingbat.characters">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:choose>
    <xsl:when test="$dingbat='bullet'"> $\bullet$ </xsl:when>
    <!-- \textnormal to prevent from latex/3420 bug in bold environment -->
    <xsl:when test="$dingbat='copyright'">\textnormal{\copyright}</xsl:when>
    <xsl:when test="$dingbat='registered'">\textnormal{\textregistered}</xsl:when>
    <xsl:when test="$dingbat='trademark'">\texttrademark{}</xsl:when>
    <xsl:when test="$dingbat='nbsp'">&#x00A0;</xsl:when>
    <xsl:when test="$dingbat='ldquo'">"</xsl:when>
    <xsl:when test="$dingbat='rdquo'">"</xsl:when>
    <xsl:when test="$dingbat='lsquo'">'</xsl:when>
    <xsl:when test="$dingbat='rsquo'">'</xsl:when>
    <xsl:when test="$dingbat='em-dash'">&#x2014;</xsl:when>
    <xsl:when test="$dingbat='mdash'">&#x2014;</xsl:when>
    <xsl:when test="$dingbat='en-dash'">&#x2013;</xsl:when>
    <xsl:when test="$dingbat='ndash'">&#x2013;</xsl:when>
    <xsl:otherwise>
      <xsl:text> [dingbat?] </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
