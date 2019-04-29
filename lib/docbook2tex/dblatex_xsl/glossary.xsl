<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="glossary.tocdepth">5</xsl:param>
<xsl:param name="glossary.numbered">1</xsl:param>

<!-- ############
     # glossary #
     ############ -->

<xsl:template match="glossary">
  <xsl:text>% --------	&#10;</xsl:text>
  <xsl:text>% GLOSSARY	&#10;</xsl:text>
  <xsl:text>% --------	&#10;</xsl:text>

  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level"/>
  </xsl:variable>

  <xsl:variable name="title.text">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Glossary'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$glossary.numbered = '0'">
    <!-- Unumbered section (but in TOC) -->
    <xsl:call-template name="section.unnumbered">
      <xsl:with-param name="tocdepth" select="number($glossary.tocdepth)"/>
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title.text"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="title">
    <!-- Numbered section from a <title> node -->
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="allnum" select="'1'"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="section.body"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- Numbered section from a generated title -->
    <xsl:call-template name="maketitle">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title.text"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="section.body"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossary" mode="section.body">
  <xsl:variable name="divs" select="glossdiv"/>
  <xsl:variable name="entries" select="glossentry"/>
  <xsl:variable name="preamble" select="*[not(self::title
                                          or self::subtitle
                                          or self::glossdiv
                                          or self::glossentry)]"/>
  <xsl:if test="$preamble">
    <xsl:apply-templates select="$preamble"/>
  </xsl:if>

  <xsl:if test="$entries">
    <xsl:text>&#10;\noindent&#10;</xsl:text>
    <xsl:text>\begin{description}&#10;</xsl:text>
    <xsl:apply-templates select="$entries"/>
    <xsl:text>&#10;\end{description}&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="$divs">
    <xsl:apply-templates select="$divs"/>
  </xsl:if>
</xsl:template>

<xsl:template match="glossary/glossaryinfo"/>
<xsl:template match="glossary/title"/>
<xsl:template match="glossary/subtitle"/>
<xsl:template match="glossary/titleabbrev"/>


<!-- ############
     # glossdiv #
     ############ -->

<xsl:template match="glossdiv">
  <!-- find the appropriate section level -->
  <xsl:variable name="l">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="parent::glossary"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="map.sect.level">
    <xsl:with-param name="level" select="$l+1"/>
  </xsl:call-template>
  <xsl:text>{</xsl:text>
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="title"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id"/>

  <!-- display the stuff before the entries -->
  <xsl:apply-templates select="*[not(self::glossentry)]"/>
  
  <!-- now, display the description list -->
  <xsl:text>&#10;\noindent&#10;</xsl:text>
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates select="glossentry"/>
  <xsl:text>&#10;\end{description}&#10;</xsl:text>
</xsl:template>


<!-- #############
     # glosslist #
     ############# -->

<xsl:template match="glossdiv/title" />

<xsl:template match="glosslist">
  <xsl:text>&#10;\noindent&#10;</xsl:text>
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;\end{description}&#10;</xsl:text>
</xsl:template>

<xsl:template match="glosslist/title" />
<xsl:template match="glosslist/blockinfo" />


<!-- ##############
     # glossentry #
     ############## -->

<xsl:template match="glossentry">
  <xsl:apply-templates select="*[not(self::glosssee or self::glossdef)]"/>
  <xsl:apply-templates select="glosssee|glossdef"/>
  <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="glossentry/glossterm">
  <xsl:text>\item[</xsl:text>
  <xsl:if test="../@id or ../@xml:id">
    <xsl:text>\hypertarget{</xsl:text>
    <xsl:value-of select="(../@id|../@xml:id)[1]"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:variable name="term">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($term)"/>
  <xsl:text>}]~ </xsl:text>
</xsl:template>

<xsl:template match="glossentry/acronym">
  <xsl:text> (\texttt{</xsl:text><xsl:apply-templates/><xsl:text>}) </xsl:text>
</xsl:template>
  
<xsl:template match="glossentry/abbrev">
  <xsl:text> [ </xsl:text><xsl:apply-templates/><xsl:text> ] </xsl:text> 
</xsl:template>

<!-- not printed -->
<xsl:template match="glossentry/revhistory"/>
  
<xsl:template match="glossentry/glossdef">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::glossseealso)]"/>
  <xsl:apply-templates select="glossseealso"/>
</xsl:template>

<xsl:template match="glossseealso|glosssee">
  <xsl:variable name="oterm" select="@otherterm"/>
  <xsl:variable name="targets" select="//node()[@id=$oterm or @xml:id=$oterm]"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:text> </xsl:text>
  <xsl:if test="position()=1">
    <xsl:if test="self::glosssee">
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:call-template name="gentext.element.name"/>
    <xsl:call-template name="gentext.space"/>
  </xsl:if>
  <xsl:text>"</xsl:text>
  <xsl:choose>
    <xsl:when test="@otherterm">
      <xsl:call-template name="hyperlink.markup">
        <xsl:with-param name="linkend" select="@otherterm"/>
        <xsl:with-param name="text">
          <xsl:choose>
          <xsl:when test="$text!=''">
            <xsl:value-of select="$text"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$target" mode="xref"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>"</xsl:text>

  <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:text>.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>, </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossentry" mode="xref">
  <xsl:apply-templates select="./glossterm" mode="xref"/>
</xsl:template>

<xsl:template match="glossterm" mode="xref">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>

