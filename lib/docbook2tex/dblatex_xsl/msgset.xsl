<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="msg">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgmain">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgmain/title|msgsub/title|msgrel/title">
  <xsl:text>{\textbf{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}} </xsl:text>
</xsl:template>

<xsl:template match="msgsub">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgrel">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msginfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msglevel|msgorig|msgaud">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>\textbf{</xsl:text>
  <xsl:call-template name="gentext.element.name"/>
  <xsl:text>: </xsl:text>
  <xsl:text>} </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="msgexplan">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

