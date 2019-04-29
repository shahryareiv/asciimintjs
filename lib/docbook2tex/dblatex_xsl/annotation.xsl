<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<!-- Annotation support mostly taken from the DocBook Project stylesheets. Only
     The inlined output and the annotation content output are different (use
     of attachfile macros, and latex file output). -->

<xsl:param name="annotation.support" select="'0'"/>

<xsl:key name="gid" match="*" use="generate-id()"/>

<!-- Content of the annotation file -->
<xsl:template match="annotation" mode="write">
  <xsl:text>\documentclass</xsl:text>
  <xsl:if test="$latex.class.options!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$latex.class.options"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>{article}&#10;</xsl:text>
  <xsl:text>\usepackage[T1]{fontenc}&#10;</xsl:text>
  <xsl:text>\usepackage[latin1]{inputenc}&#10;</xsl:text>

  <xsl:call-template name="font.setup"/>
  <xsl:text>\usepackage[hyperlink]{</xsl:text>
  <xsl:value-of select="$latex.style"/>
  <xsl:text>}&#10;</xsl:text>

  <xsl:call-template name="citation.setup"/>
  <xsl:call-template name="lang.setup"/>

  <xsl:text>\pagestyle{empty}&#10;</xsl:text>

  <xsl:text>\begin{document}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{document}&#10;</xsl:text>
</xsl:template>

<!-- Build the annotation latex file -->
<xsl:template match="annotation" mode="build.texfile">
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename">
      <xsl:text>annot_</xsl:text>
      <xsl:value-of select="generate-id()"/>
      <xsl:text>.rtex</xsl:text>
    </xsl:with-param>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:apply-templates select="." mode="write"/>
    </xsl:with-param>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="annotation"/>

<!-- Show the annotations (if any) related to this element -->
<xsl:template match="*" mode="annotation.links">
  <xsl:if test="$annotation.support != '0'">
  <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
  <!-- do any annotations apply to the context node? -->

  <xsl:variable name="aids">
    <xsl:if test="$id!=''">
      <xsl:for-each select="//annotation">
        <xsl:if test="contains(concat(' ',@annotates,' '),concat(' ',$id,' '))">
          <xsl:value-of select="generate-id()"/>
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="normalize-space(@annotations) != ''">
      <xsl:call-template name="annotations-pointed-to">
        <xsl:with-param name="annotations"
                        select="normalize-space(@annotations)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:if test="$aids != ''">
    <xsl:call-template name="apply-annotations-by-gid">
      <xsl:with-param name="gids" select="normalize-space($aids)"/>
    </xsl:call-template>
  </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="annotations-pointed-to">
  <xsl:param name="annotations"/>
  <xsl:choose>
    <xsl:when test="contains($annotations, ' ')">
      <xsl:variable name='a'
                    select="key('id', substring-before($annotations, ' '))"/>
      <xsl:if test="$a">
        <xsl:value-of select="generate-id($a)"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:call-template name="annotations-pointed-to">
        <xsl:with-param name="annotations"
                        select="substring-after($annotations, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name='a'
                    select="key('id', $annotations)"/>
      <xsl:if test="$a">
        <xsl:value-of select="generate-id($a)"/>
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="apply-annotations-by-gid">
  <xsl:param name="gids"/>

  <xsl:choose>
    <xsl:when test="contains($gids, ' ')">
      <xsl:variable name="gid" select="substring-before($gids, ' ')"/>
      <xsl:apply-templates select="key('gid', $gid)"
                           mode="annotation-inline"/>
      <xsl:call-template name="apply-annotations-by-gid">
        <xsl:with-param name="gids" select="substring-after($gids, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="key('gid', $gids)"
                           mode="annotation-inline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="annotation" mode="annotation-inline">
  <xsl:text>\attachfile</xsl:text>
  <xsl:if test="title">
    <xsl:text>[</xsl:text>
    <xsl:text>subject={</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="title"/>
    </xsl:call-template>
    <xsl:text>}]</xsl:text>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:text>annot_</xsl:text>
  <xsl:value-of select="generate-id()"/>
  <xsl:text>.pdf</xsl:text>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>


<!-- load the needed package, and build the annotation files -->
<xsl:template name="annotation.setup">
  <xsl:if test="$annotation.support != '0' and .//annotation">
    <xsl:text>\usepackage{attachfile}&#10;</xsl:text>
    <xsl:apply-templates select=".//annotation" mode="build.texfile"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
