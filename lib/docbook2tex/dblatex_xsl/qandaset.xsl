<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- qandaset parameters -->
<xsl:param name="qanda.defaultlabel">number</xsl:param>


<xsl:template match="qandaset">
  <!-- is it displayed as a section? -->
  <xsl:variable name="title"
                select="(title|blockinfo/title|info/title)[1]"/>

  <xsl:if test="$title">
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level">
        <xsl:call-template name="get.sect.level"/>
      </xsl:with-param>
      <xsl:with-param name="num" select="'0'"/>
      <xsl:with-param name="title" select="$title"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="qandaset/title"/>
<xsl:template match="qandaset/blockinfo"/>


<!-- ############
     # qandadiv #
     ############ -->

<xsl:template match="qandadiv/title"/>

<xsl:template match="qandadiv">
  <!-- display the title according the section depth -->
  <xsl:variable name="l">
    <xsl:value-of select="count(ancestor::qandadiv)"/>
  </xsl:variable>
  <xsl:variable name="lset">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="ancestor::qandaset"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="blockinfo/title|info/title|title">
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level">
        <xsl:choose>
        <xsl:when test="ancestor::qandaset[title|blockinfo/title|info/title]">
          <xsl:value-of select="$l+$lset+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$l+$lset"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:apply-templates/>
</xsl:template>


<!-- ##############
     # qandaentry #
     ############## -->

<!-- should be really processed -->
<xsl:template match="label"/>

<xsl:template match="qandaentry">
  <xsl:variable name="defaultlabel">
    <xsl:choose>
    <xsl:when test="ancestor::qandaset[@defaultlabel]">
      <xsl:value-of select="ancestor::qandaset/@defaultlabel"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$qanda.defaultlabel"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- if default label is a number, display the quandaentries
       like an enumerate list
    -->
  <xsl:if test="not(preceding-sibling::qandaentry) and
                $defaultlabel='number'">
    <xsl:text>&#10;\begin{enumerate}&#10;</xsl:text>
  </xsl:if>

  <xsl:apply-templates select="question" mode="wp">
    <xsl:with-param name="defaultlabel" select="$defaultlabel"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="answer" mode="wp">
    <xsl:with-param name="defaultlabel" select="$defaultlabel"/>
  </xsl:apply-templates>

  <xsl:if test="not(following-sibling::qandaentry) and
                $defaultlabel='number'">
    <xsl:text>&#10;\end{enumerate}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="question" mode="wp">
  <xsl:param name="defaultlabel"/>

  <xsl:choose>
  <xsl:when test="$defaultlabel='number'">
    <xsl:text>\item</xsl:text>
    <xsl:if test="label">
      <!-- label has priority on defaultlabel -->
      <xsl:text>[\textbf{</xsl:text>
      <xsl:value-of select="label"/>
      <xsl:text>}]</xsl:text>
    </xsl:if>
    <xsl:text>{}</xsl:text>
  </xsl:when>
  <xsl:when test="label">
    <xsl:text>\textbf{</xsl:text>
    <xsl:value-of select="label"/>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:when test="$defaultlabel='qanda'">
    <xsl:text>\textbf{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'question'"/>
    </xsl:call-template>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <!-- don't use textit since we can have several paragraphs -->
  <xsl:text>{\it </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="answer" mode="wp">
  <xsl:param name="defaultlabel"/>

  <xsl:choose>
  <xsl:when test="$defaultlabel='number'">
    <!-- answers are other paragraphs of the enumerated entry -->
    <xsl:text>&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="label">
    <xsl:text>&#10;\noindent\textbf{</xsl:text>
    <xsl:value-of select="label"/>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:when test="$defaultlabel='qanda'">
    <xsl:text>&#10;\noindent\textbf{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'answer'"/>
    </xsl:call-template>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates/>
  <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>


</xsl:stylesheet>
