<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="preface.tocdepth">0</xsl:param>
<xsl:param name="dedication.tocdepth">0</xsl:param>
<xsl:param name="colophon.tocdepth">0</xsl:param>
<xsl:param name="beginpage.as.pagebreak" select="1"/>


<xsl:template match="colophon">
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="number($colophon.tocdepth)"/>
    <xsl:with-param name="title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Colophon'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="dedication">
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="number($dedication.tocdepth)"/>
    <xsl:with-param name="title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Dedication'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface">
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="number($preface.tocdepth)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="section.unnumbered">
  <xsl:param name="tocdepth" select="0"/>
  <xsl:param name="level" select="'0'"/>
  <xsl:param name="titlenode" select="(title|info/title)[1]"/>
  <xsl:param name="title"/>

  <xsl:apply-templates select="." mode="endnotes"/>

  <xsl:call-template name="section.unnumbered.begin">
    <xsl:with-param name="tocdepth" select="$tocdepth"/>
    <xsl:with-param name="level" select="$level"/>
    <xsl:with-param name="titlenode" select="$titlenode"/>
    <xsl:with-param name="title" select="$title"/>
  </xsl:call-template>

  <xsl:apply-templates select="." mode="section.body"/>

  <xsl:call-template name="section.unnumbered.end">
    <xsl:with-param name="tocdepth" select="$tocdepth"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="section.unnumbered.begin">
  <xsl:param name="tocdepth" select="0"/>
  <xsl:param name="level" select="'0'"/>
  <xsl:param name="titlenode" select="title"/>
  <xsl:param name="title"/>
  <xsl:choose>
  <xsl:when test="number($tocdepth) = -1">
    <xsl:call-template name="mapheading"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- don't use starred headings, but rely on counters instead -->
    <xsl:text>\setcounter{secnumdepth}{-1}&#10;</xsl:text>
    <xsl:if test="$tocdepth &lt;= $toc.section.depth">
      <xsl:call-template name="set-tocdepth">
        <xsl:with-param name="depth" select="$tocdepth - 1"/>
      </xsl:call-template>
    </xsl:if>
    <!-- those sections have optional title -->
    <xsl:choose>
      <xsl:when test="$titlenode">
        <xsl:call-template name="makeheading">
          <xsl:with-param name="level" select="$level"/>
          <xsl:with-param name="allnum" select="'1'"/>
          <xsl:with-param name="title" select="$titlenode"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="maketitle">
          <xsl:with-param name="level" select="$level"/>
          <xsl:with-param name="allnum" select="'1'"/>
          <xsl:with-param name="title" select="$title"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="section.unnumbered.end">
  <xsl:param name="tocdepth" select="0"/>
  <xsl:if test="number($tocdepth) &gt; -1">
    <!-- restore the initial counters -->
    <xsl:text>\setcounter{secnumdepth}{</xsl:text>
    <xsl:value-of select="$doc.section.depth"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:if test="$tocdepth &lt;= $toc.section.depth">
      <xsl:call-template name="set-tocdepth">
        <xsl:with-param name="depth" select="$toc.section.depth"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- By default the (unumbered) section body just processes children -->
<xsl:template match="*" mode="section.body">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dedication/title"></xsl:template>
<xsl:template match="dedication/subtitle"></xsl:template>
<xsl:template match="dedication/titleabbrev"></xsl:template>
<xsl:template match="colophon/title"></xsl:template>
<xsl:template match="preface/title"></xsl:template>
<xsl:template match="preface/titleabbrev"></xsl:template>
<xsl:template match="preface/subtitle"></xsl:template>
<xsl:template match="preface/docinfo|prefaceinfo"></xsl:template>

<!-- preface sect{1-5} mapped like sections -->

<xsl:template match="preface//sect1|
                     preface//sect2|
                     preface//sect3|
                     preface//sect4|
                     preface//sect5">
  <xsl:choose>
  <xsl:when test="number($preface.tocdepth) = -1">
    <xsl:call-template name="makeheading">
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="makeheading">
      <xsl:with-param name="name" select="local-name(.)"/>
      <xsl:with-param name="allnum" select="'1'"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="preface//section">
  <xsl:variable name="allnum">
    <xsl:choose>
    <xsl:when test="number($preface.tocdepth) = -1">0</xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="makeheading">
    <xsl:with-param name="level" select="count(ancestor::section)+1"/>
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<!-- don't know where to put it -->
<xsl:template match="beginpage">
  <xsl:if test="$beginpage.as.pagebreak=1">
    <xsl:choose>
    <xsl:when test="@pagenum != ''">
      <xsl:message>Cannot start a new page at a specific page number</xsl:message>
    </xsl:when>
    <xsl:when test="@role = 'openright'">
      <xsl:text>\cleardoublepage&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\clearpage&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
