<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="para|simpara">
  <xsl:text>&#10;</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="formalpara">
  <xsl:text>&#10;{\bf </xsl:text>
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="title"/>
  </xsl:call-template>
  <xsl:text>} </xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="formalpara/title"></xsl:template>


<!--========================================================================== 
 |  Especial Cases Do not add Linefeed 
 +============================================================================-->

<xsl:template match="listitem/para|step/para|entry/para
                    |listitem/simpara|step/simpara|entry/simpara">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="textobject/para"> <xsl:apply-templates/> </xsl:template>
<xsl:template match="question/para"> <xsl:apply-templates/> </xsl:template>
<xsl:template match="answer/para"> <xsl:apply-templates/> </xsl:template>

<!--===============
 |  Miscellaneous
 +================= -->

<xsl:template match="ackno">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
