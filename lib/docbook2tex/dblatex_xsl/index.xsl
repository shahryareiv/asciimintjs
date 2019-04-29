<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="index.tocdepth">5</xsl:param>
<xsl:param name="index.numbered">1</xsl:param>


<xsl:template name="index.print">
  <xsl:param name="node" select="."/>
  <!-- actual sorting entry -->
  <xsl:if test="$node/@sortas">
    <xsl:call-template name="scape.index">
      <xsl:with-param name="string" select="$node/@sortas"/>
    </xsl:call-template>
    <xsl:text>@{</xsl:text>
  </xsl:if>
  <!-- entry display -->
  <xsl:call-template name="scape.index">
    <xsl:with-param name="string" select="$node"/>
  </xsl:call-template>
  <xsl:if test="$node/@sortas">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm">
  <xsl:param name="close" select="''"/>
  <xsl:text>\index{</xsl:text>
  <xsl:call-template name="index.print">
    <xsl:with-param name="node" select="./primary"/>
  </xsl:call-template>
  <xsl:if test="./secondary">
    <xsl:text>!</xsl:text>
    <xsl:call-template name="index.print">
      <xsl:with-param name="node" select="./secondary"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:if test="./tertiary">
    <xsl:text>!</xsl:text>
    <xsl:call-template name="index.print">
      <xsl:with-param name="node" select="./tertiary"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:if test="./see">
    <xsl:text>|see{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="./see"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:if test="./seealso">
    <xsl:text>|see{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="./seealso"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <!-- page range opening/close -->
  <xsl:choose>
  <xsl:when test="$close!=''">
    <xsl:value-of select="$close"/>
  </xsl:when>
  <xsl:when test="@class='startofrange'">
    <!-- sanity check: only open range if related close is found -->
    <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
    <xsl:choose>
    <xsl:when test="//indexterm[@class='endofrange' and @startref=$id]">
      <xsl:text>|(</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
      <xsl:text>Error: cannot find indexterm[@startref='</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>'] end of range</xsl:text>
      </xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  </xsl:choose>
  <xsl:text>}</xsl:text>
  <!-- don't want to be stuck to the next para -->
  <xsl:if test="following-sibling::*[1][self::para or self::formalpara or
                                        self::simpara]">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- simply duplicate the referenced starting range indexterm, and close the
     range -->

<xsl:template match="indexterm[@class='endofrange']">
  <xsl:variable name="id" select="@startref"/>
  <xsl:apply-templates select="//indexterm[@class='startofrange' and 
                                           (@id=$id or @xml:id=$id)]">
    <xsl:with-param name="close" select="'|)'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="primary|secondary|tertiary|see|seealso"/>
<xsl:template match="indexentry"/>
<xsl:template match="primaryie|secondaryie|tertiaryie|seeie|seealsoie"/>


<!-- in a programlisting -->
<xsl:template match="indexterm" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.embed">
    <xsl:with-param name="co-taging" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>


<!-- ignore index entries in TOC -->
<xsl:template match="indexterm" mode="toc.skip"/>

 
<!-- todo -->
<xsl:template match="index|setindex">
<!--
  <xsl:call-template name="label.id"/>
  <xsl:text>\printindex&#10;</xsl:text>
  -->
</xsl:template>


<xsl:template name="printindex">
  <xsl:if test="number($index.numbered) = 0">
    <xsl:text>\setcounter{secnumdepth}{-1}&#10;</xsl:text>
    <xsl:call-template name="set-tocdepth">
      <xsl:with-param name="depth" select="number($index.tocdepth) - 1"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:text>\printindex&#10;</xsl:text>

  <xsl:if test="number($index.numbered) = 0">
    <xsl:call-template name="section.unnumbered.end">
      <xsl:with-param name="tocdepth" select="number($index.tocdepth)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="index/title"></xsl:template>
<xsl:template match="index/subtitle"></xsl:template>
<xsl:template match="index/titleabbrev"></xsl:template>

<xsl:template match="indexdiv">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="indexdiv/title">
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="itermset">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
