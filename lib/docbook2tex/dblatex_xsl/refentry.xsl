<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="refentry.tocdepth">5</xsl:param>
<xsl:param name="refentry.numbered">1</xsl:param>
<xsl:param name="refentry.generate.name" select="0"/>
<xsl:param name="refclass.suppress" select="0"/>

<xsl:template name="refsect.level">
  <xsl:param name="n" select="."/>
  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="$n/ancestor::refentry"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="offset">
    <xsl:choose>
    <xsl:when test="local-name($n)='refsynopsisdiv'">1</xsl:when>
    <xsl:when test="local-name($n)='refsect1'">1</xsl:when>
    <xsl:when test="local-name($n)='refsect2'">2</xsl:when>
    <xsl:when test="local-name($n)='refsect3'">3</xsl:when>
    <xsl:when test="local-name($n)='refsection'">
      <xsl:value-of select="count($n/ancestor::refsection)+1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$level + $offset"/>
</xsl:template>

<!-- #############
     # reference #
     ############# -->

<xsl:template match="reference">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% Reference &#10;</xsl:text>
  <xsl:text>% ---------&#10;</xsl:text>
  <xsl:call-template name="makeheading">
    <!-- raise to the highest existing book section level (part or chapter) -->
    <xsl:with-param name="level">
      <xsl:choose>
      <xsl:when test="preceding-sibling::part or
                      following-sibling::part">-1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates select="partintro"/>
  <xsl:apply-templates select="*[local-name(.) != 'partintro']"/>
</xsl:template>

<xsl:template match="reference/docinfo"/>
<xsl:template match="reference/title"/>  
<xsl:template match="reference/subtitle"/>
<xsl:template match="refentryinfo|refentryinfo/*"/>

<!-- ############
     # refentry #
     ############ -->

<xsl:template match="refentry">
  <xsl:variable name="refmeta" select=".//refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//refname"/>
  <xsl:variable name="title">
    <xsl:choose>
    <xsl:when test="$refentrytitle">
      <xsl:apply-templates select="$refentrytitle[1]"/>
    </xsl:when>
    <xsl:when test="$refname">
      <xsl:apply-templates select="$refname[1]"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% Refentry &#10;</xsl:text>
  <xsl:text>% ---------&#10;</xsl:text>

  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level"/>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$refentry.numbered = '0'">
    <!-- Unumbered refentry title (but in TOC) -->
    <xsl:call-template name="section.unnumbered">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="tocdepth" select="$refentry.tocdepth"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <!-- Numbered refentry title -->
    <xsl:call-template name="maketitle">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="refmeta">
  <xsl:apply-templates select="indexterm"/>
</xsl:template>

<xsl:template match="refentrytitle">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="manvolnum">
  <xsl:if test="$refentry.xref.manvolnum != 0">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ###############
     # refsynopsis #
     ############### -->

<!-- A refsynopsisdiv with a title is handled like a refsectx -->
<xsl:template match="refsynopsisdiv">
  <!-- Without title, generate a localized "Synopsis" heading -->
  <xsl:call-template name="maketitle">
    <xsl:with-param name="num" select="'0'"/>
    <xsl:with-param name="level">
      <xsl:call-template name="refsect.level"/>
    </xsl:with-param>
    <xsl:with-param name="title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdivinfo"/>
<xsl:template match="refsynopsisdiv/title"/>

<!-- ##############
     # refnamediv #
     ############## -->

<xsl:template match="refnamediv">
  <!-- Generate a localized "Name" subheading if is non-zero -->
  <xsl:if test="$refentry.generate.name != 0">
    <xsl:call-template name="maketitle">
      <xsl:with-param name="num" select="'0'"/>
      <xsl:with-param name="level">
        <xsl:call-template name="refsect.level"/>
      </xsl:with-param>
      <xsl:with-param name="title">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'RefName'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <!-- refdescriptor is used only if no refname -->
  <xsl:choose>
  <xsl:when test="refname">
    <xsl:apply-templates select="refname"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="refdescriptor"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="*[local-name(.)!='refname' and
                                 local-name(.)!='refdescriptor']"/>
</xsl:template>

<xsl:template match="refname">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::refname">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:text> --- </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refdescriptor">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refclass">
  <xsl:if test="$refclass.suppress = 0">
    <!-- Displayed as block -->
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="@role">
      <xsl:value-of select="@role"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ############
     # refsectx #
     ############ -->

<xsl:template match="refsect1/title"/>
<xsl:template match="refsect2/title"/>
<xsl:template match="refsect3/title"/>
<xsl:template match="refsection/title"/>
<xsl:template match="refsect1info"/>
<xsl:template match="refsect2info"/>
<xsl:template match="refsect3info"/>

<xsl:template match="refsection|refsect1|refsect2|refsect3">
  <xsl:call-template name="makeheading">
    <xsl:with-param name="level">
      <xsl:call-template name="refsect.level"/>
    </xsl:with-param>
    <xsl:with-param name="num" select="0"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdiv[title|
                                    refsynopsisdivinfo/title|
                                    info/title]">
  <!-- Select the title node -->
  <xsl:variable name="title"
                select="(title|
                         refsynopsisdivinfo/title|
                         info/title)[1]"/>

  <xsl:call-template name="makeheading">
    <xsl:with-param name="level">
      <xsl:call-template name="refsect.level"/>
    </xsl:with-param>
    <xsl:with-param name="num" select="0"/>
    <xsl:with-param name="title" select="$title"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
