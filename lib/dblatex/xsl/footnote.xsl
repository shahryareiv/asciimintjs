<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="exsl" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->
<xsl:param name="footnote.as.endnote" select="0"/>
<xsl:param name="endnotes.heading.style" select="'select:title'"/>
<xsl:param name="endnotes.heading.groups"/>
<xsl:param name="endnotes.heading.command"/>
<xsl:param name="endnotes.counter.resetby" select="'part chapter'"/>

<xsl:attribute-set name="endnotes.properties.default">
  <xsl:attribute name="package">endnotes</xsl:attribute>

  <!-- No header: endnotes are embedded in another section -->
  <xsl:attribute name="heading">\mbox{}\par</xsl:attribute>

  <!-- Show end notes as a numbered list -->
  <xsl:attribute name="font-size">\normalsize</xsl:attribute>
  <xsl:attribute name="note-format">%
  \leftskip=1.8em\noindent
  \makebox[0pt][r]{\theenmark.~~\rule{0pt}{\baselineskip}}\ignorespaces
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="endnotes.properties"
                   use-attribute-sets="endnotes.properties.default"/>

<!-- ==================================================================== -->

<xsl:template match="footnote">
  <xsl:choose>
  <!-- in forbidden areas, only put the footnotemark. footnotetext will
       follow in the next possible area (foottext mode) -->
  <xsl:when test="ancestor::term|
                  ancestor::title">
    <xsl:text>\footnotemark{}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\footnote{</xsl:text>
    <xsl:call-template name="label.id">
      <xsl:with-param name="inline" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Table cells are forbidden for footnotes -->
<xsl:template match="footnote[ancestor::entry]">
  <xsl:text>\footnotemark{}</xsl:text>
</xsl:template>

<xsl:template match="footnoteref">
  <!-- Works only with footmisc -->
  <xsl:text>\footref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- display the text of the footnotes contained in this element -->
<xsl:template match="*" mode="foottext">
  <xsl:variable name="foot" select="descendant::footnote"/>
  <xsl:if test="count($foot)&gt;0">
    <xsl:text>\addtocounter{footnote}{-</xsl:text>
    <xsl:value-of select="count($foot)"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="$foot" mode="foottext"/>
  </xsl:if>
</xsl:template>

<xsl:template match="footnote" mode="foottext">
  <xsl:text>\stepcounter{footnote}&#10;</xsl:text>
  <xsl:text>\footnotetext{</xsl:text>
  <xsl:apply-templates/>
  <xsl:call-template name="label.id"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- in a programlisting do as normal but in tex-escaped pattern -->
<xsl:template match="footnote" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.embed">
    <xsl:with-param name="co-taging" select="$co-tagin"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="*" mode="toc.skip">
  <xsl:apply-templates mode="toc.skip"/>
</xsl:template>

<!-- escape characters as usual -->
<xsl:template match="text()" mode="toc.skip">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- in this mode the footnotes must vanish -->
<xsl:template match="footnote" mode="toc.skip"/>

<!-- ==================================================================== -->

<xsl:template name="footnote.setup">
  <xsl:if test="$footnote.as.endnote=1">
    <xsl:text>\makeatletter&#10;</xsl:text>
    <xsl:call-template name="endnotes.setup"/>
    <xsl:text>\let\footnote=\endnote&#10;</xsl:text>
    <xsl:text>\let\footnotetext=\endnotetext&#10;</xsl:text>
    <xsl:text>\let\footnotemark=\endnotemark&#10;</xsl:text>
    <xsl:text>\let\c@footnote=\c@endnote&#10;</xsl:text>
    <xsl:text>\makeatother&#10;</xsl:text>
    <!-- Endnotes now uses the footnote counter: prevent from chapter reset -->
    <xsl:if test="(not(contains($endnotes.heading.groups,'chapter'))
                   or not(contains($endnotes.counter.resetby, 'chapter')))
                   and count(//chapter)!=0 ">
      <xsl:text>\usepackage{chngcntr}&#10;</xsl:text>
      <xsl:text>\counterwithout{footnote}{chapter}&#10;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Default setup, to remove if already defined in a latex style, or to
     override if another formatting or package is required -->

<xsl:template name="endnotes.setup">
  <xsl:variable name="endnotesetup">
    <endnotesetup xsl:use-attribute-sets="endnotes.properties"/>
  </xsl:variable>
    
  <xsl:apply-templates select="exsl:node-set($endnotesetup)/*"/>
</xsl:template>

<xsl:template match="endnotesetup">
  <xsl:variable name="package">
    <xsl:choose>
    <xsl:when test="@package"><xsl:value-of select="@package"/></xsl:when>
    <xsl:otherwise>endnotes</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>\usepackage{</xsl:text>
  <xsl:value-of select="$package"/>
  <xsl:text>}&#10;</xsl:text>

  <xsl:if test="@heading">
    <xsl:text>\def\enoteheading{</xsl:text>
    <xsl:value-of select="@heading"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="@font-size">
    <xsl:text>\def\enotesize{</xsl:text>
    <xsl:value-of select="@font-size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="@note-format">
    <xsl:text>\def\enoteformat{</xsl:text>
    <xsl:value-of select="@note-format"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<!-- Just append the endnotes to the other content -->
<xsl:template match="index" mode="endnotes">
  <xsl:apply-templates select="*"/>
  <xsl:if test="$footnote.as.endnote=1">
    <xsl:text>\theendnotes&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="endnotes"/>

<!-- By default only these elements are known to be endnotes groups -->
<xsl:template match="chapter|part" mode="endnotes">
  <xsl:call-template name="endnotes.add.header"/>
</xsl:template>

<xsl:template name="endnotes.add.header">
  <xsl:param name="verbose" select="1"/>
  <xsl:param name="reset-counter">
    <xsl:choose>
    <xsl:when test="contains($endnotes.counter.resetby,local-name(.))">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="0"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="endnotes.section"
                select="//index[@type='endnotes'][1]/parent::*"/>

  <xsl:if test="$verbose=2">
    <xsl:message>Endnotes sections found: <xsl:value-of
               select="count($endnotes.section)"/></xsl:message>
  </xsl:if>

  <xsl:if test="$footnote.as.endnote=1 and 
                contains($endnotes.heading.groups, local-name(.)) and
                count($endnotes.section)!=0 and count(descendant::footnote)!=0">

    <xsl:variable name="level">
      <xsl:call-template name="get.sect.level">
        <xsl:with-param name="n" select="$endnotes.section"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$verbose=2">
      <xsl:message>
         <xsl:text>Endnotes headings level: </xsl:text>
         <xsl:value-of select="$level+1"/></xsl:message>
    </xsl:if>

    <!-- Use xref templates to format the title with xrefstyle features -->
    <xsl:variable name="title">
      <xsl:call-template name="xref.nolink">
        <xsl:with-param name="string">
          <xsl:apply-templates select="." mode="object.xref.markup">
            <xsl:with-param name="purpose" select="'xref'"/>
            <xsl:with-param name="xrefstyle" select="$endnotes.heading.style"/>
            <xsl:with-param name="referrer" select="."/>
            <xsl:with-param name="verbose" select="$verbose"/>
          </xsl:apply-templates>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- Use a defined heading command, or compute one from section level -->
    <xsl:variable name="heading">
      <xsl:choose>
      <xsl:when test="$endnotes.heading.command!=''">
        <xsl:value-of
                select="concat($endnotes.heading.command, '{', $title, '}')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="maketitle">
          <xsl:with-param name="level" select="$level+1"/>
          <xsl:with-param name="allnum" select="'0'"/>
          <xsl:with-param name="num" select="'0'"/>
          <xsl:with-param name="title" select="$title"/>
          <xsl:with-param name="with-label" select="0"/>
        </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="$reset-counter!=0">
      <xsl:text>\setcounter{endnote}{0}</xsl:text>
    </xsl:if>
    <xsl:text>\addtoendnotes{\protect</xsl:text>
    <xsl:value-of select="$heading"/>
    <xsl:text>}&#10;</xsl:text>

  </xsl:if>
</xsl:template>

</xsl:stylesheet>
