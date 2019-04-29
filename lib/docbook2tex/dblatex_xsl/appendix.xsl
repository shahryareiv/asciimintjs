<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="appendix">
  <xsl:if test="not (preceding-sibling::appendix)">
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>% Appendixes start here&#10;</xsl:text>
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>\begin{appendices}&#10;</xsl:text>
  </xsl:if>
  <xsl:call-template name="makeheading">
    <!-- raise to the highest existing book section level (part or chapter) -->
    <xsl:with-param name="level">
      <xsl:choose>
      <xsl:when test="preceding-sibling::part or
                      following-sibling::part">-1</xsl:when>
      <xsl:when test="parent::book or parent::part">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>

  <xsl:if test="not (following-sibling::appendix)">
    <xsl:text>&#10;\end{appendices}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="appendix/title"></xsl:template>
<xsl:template match="appendix/titleabbrev"></xsl:template>
<xsl:template match="appendix/subtitle"></xsl:template>
<xsl:template match="appendix/docinfo|appendixinfo"></xsl:template>

</xsl:stylesheet>

