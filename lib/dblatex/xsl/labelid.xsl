<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Title parameters -->
<xsl:param name="titleabbrev.in.toc">1</xsl:param>


<xsl:template name="mapheading">
  <xsl:call-template name="makeheading">
    <xsl:with-param name="command">
      <xsl:call-template name="sec-map">
        <xsl:with-param name="keyword" select="local-name(.)"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="makeheading">
  <xsl:param name="num" select="'1'"/>
  <xsl:param name="allnum" select="'0'"/>
  <xsl:param name="level"/>
  <xsl:param name="name"/>
  <xsl:param name="command"/>
  <!-- Title must be a node -->
  <xsl:param name="title" select="(title|info/title)[1]"/>

  <xsl:variable name="rcommand">
    <xsl:choose>
    <xsl:when test="$command=''">
      <xsl:call-template name="map.sect.level">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="allnum" select="$allnum"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$command"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Force section number counter if required. No consistency checked -->
  <xsl:if test="@label and @label!=''">
    <xsl:choose>
    <xsl:when test="string(number(@label))='NaN' or floor(@label)!=@label">
      <xsl:message>
      <xsl:text>Warning: only an integer in @label can be processed: '</xsl:text>
      <xsl:value-of select="@label"/>
      <xsl:text>'</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <!-- The counter name is the same than the command -->
      <xsl:text>\setcounter{</xsl:text>
      <xsl:value-of select="substring-after($rcommand, '\')"/>
      <xsl:text>}{</xsl:text>
      <xsl:value-of select="number(@label)-1"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:value-of select="$rcommand"/>
  <xsl:apply-templates select="$title" mode="format.title">
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:apply-templates>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates select="$title" mode="foottext"/>
</xsl:template>

<!-- Make a section heading from a title string. It gives something like:
     \section{title string}\label{label.id}
     -->
<xsl:template name="maketitle">
  <xsl:param name="num" select="'1'"/>
  <xsl:param name="allnum" select="'0'"/>
  <xsl:param name="with-label" select="1"/>
  <xsl:param name="level"/>
  <xsl:param name="name"/>
  <xsl:param name="command"/>
  <xsl:param name="title"/>

  <xsl:variable name="rcommand">
    <xsl:choose>
    <xsl:when test="$command=''">
      <xsl:call-template name="map.sect.level">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="allnum" select="$allnum"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$command"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$rcommand"/>
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$title"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:if test="$with-label != 0">
    <xsl:call-template name="label.id"/>
  </xsl:if>
</xsl:template>


<xsl:template name="label.id">
  <xsl:param name="object" select="."/>
  <xsl:param name="string" select="''"/>
  <xsl:param name="inline" select="0"/>
  <!-- object.id cannot be used since it always provides an id -->
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$object/@id">
        <xsl:value-of select="$object/@id"/>
      </xsl:when>
      <xsl:when test="$object/@xml:id">
        <xsl:value-of select="$object/@xml:id"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$string"/>
  <xsl:if test="$id!=''">
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="normalize-space($id)"/>
    <xsl:text>}</xsl:text>
    <!-- beware, hyperlabel is docbook specific -->
    <xsl:text>\hyperlabel{</xsl:text>
    <xsl:value-of select="normalize-space($id)"/>
    <xsl:text>}</xsl:text>
    <xsl:if test="$inline=0">
      <xsl:text>%&#10;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Make the title part of a section heading from a title node.
     It gives something like:
     [{string in TOC}]{heading string}
     -->
<xsl:template match="title|table/caption" mode="format.title">
  <xsl:param name="allnum" select="'0'"/>
  <xsl:apply-templates select="." mode="toc">
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:apply-templates>
  <xsl:text>{</xsl:text> 
  <!-- should be normalized, but it is done by post processing -->
  <xsl:apply-templates select="." mode="content"/>
  <xsl:text>}&#10;</xsl:text> 
</xsl:template>

<!-- optionally the TOC entry text can be different from the actual
     title if the title contains unsupported things like hot links
     or graphics, or if some titleabbrev is provided and should be used
     for the TOC.
 -->
<xsl:template match="title|table/caption" mode="toc">
  <xsl:param name="allnum" select="0"/>
  <xsl:param name="pre" select="'[{'"/>
  <xsl:param name="post" select="'}]'"/>

  <!-- Use the titleabbrev for the TOC (if possible) -->
  <xsl:variable name="abbrev">
    <xsl:if test="$titleabbrev.in.toc='1'">
      <xsl:apply-templates
        mode="toc.skip"
        select="(../titleabbrev
                |../sect1info/titleabbrev
                |../sect2info/titleabbrev
                |../sect3info/titleabbrev
                |../sect4info/titleabbrev
                |../sect5info/titleabbrev
                |../sectioninfo/titleabbrev
                |../chapterinfo/titleabbrev
                |../partinfo/titleabbrev
                |../refsect1info/titleabbrev
                |../refsect2info/titleabbrev
                |../refsect3info/titleabbrev
                |../refsectioninfo/titleabbrev
                |../referenceinfo/titleabbrev
                )[1]"/>
    </xsl:if>
  </xsl:variable>

  <!-- Nothing in the TOC for unnumbered sections -->
  <xsl:variable name="unnumbered"
                select="parent::refsect1
                       |parent::refsect2
                       |parent::refsect3
                       |parent::refsection
                       |ancestor::preface
                       |parent::colophon
                       |parent::dedication"/>

  <xsl:if test="($allnum=1 or not($unnumbered)) and
                ($abbrev!='' or
                (descendant::footnote|
                 descendant::xref|
                 descendant::link|
                 descendant::ulink|
                 descendant::anchor|
                 descendant::glossterm[@linkend]|
                 descendant::inlinegraphic|
                 descendant::inlinemediaobject) or
                 (descendant::glossterm and $glossterm.auto.link != 0))">
    <xsl:value-of select="$pre"/> 
    <xsl:choose>
    <xsl:when test="$abbrev!=''">
      <!-- The TOC contains the titleabbrev content -->
      <xsl:value-of select="normalize-space($abbrev)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- The TOC contains the toc-safe title -->
      <xsl:variable name="s">
        <xsl:apply-templates mode="toc.skip"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($s)"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$post"/> 
  </xsl:if>
</xsl:template>

<xsl:template match="title|table/caption" mode="content">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
