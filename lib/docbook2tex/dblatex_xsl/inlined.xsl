<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="filename.as.url">1</xsl:param>
<xsl:param name="hyphenation.format">monoseq,sansseq</xsl:param>
<xsl:param name="hyphenation.setup"/>
<xsl:param name="monoseq.small">0</xsl:param>


<xsl:template name="inline.setup">
  <xsl:if test="$hyphenation.format='nohyphen' or
                contains($hyphenation.setup,'sloppy')">
    <xsl:text>\sloppy&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- Use the dblatex hyphenation only if enabled for this format.
     If no format is specified, the check is done on the calling
     element name
-->
<xsl:template name="inline.hyphenate">
  <xsl:param name="string"/>
  <xsl:param name="format" select="local-name()"/>
  <xsl:choose>
  <xsl:when test="contains($hyphenation.format, $format)">
    <xsl:call-template name="hyphen-encode">
      <xsl:with-param name="string" select="$string"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:copy-of select="$string"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.boldseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\textbf{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.italicseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\emph{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- Cela prend plus de temps que la version qui suit... Bizarre.
<xsl:template name="inline.monoseq">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:text>\texttt{\emph{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}}</xsl:text>
</xsl:template>
-->

<xsl:template name="inline.sansseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\textsf{</xsl:text>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'sansseq'"/>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline.boldmonoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>{\ttfamily\bfseries{</xsl:text>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'boldmonoseq'"/>
  </xsl:call-template>
  <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template name="inline.superscriptseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>$^{\text{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}}$</xsl:text>
</xsl:template>

<xsl:template name="inline.subscriptseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>$_{\text{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}}$</xsl:text>
</xsl:template>

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\texttt{</xsl:text>
  <xsl:if test="not($monoseq.small = '0')">
    <xsl:text>\small{</xsl:text>
  </xsl:if>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'monoseq'"/>
  </xsl:call-template>
  <xsl:if test="not($monoseq.small = '0')">
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\texttt{\emph{\small{</xsl:text>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'monoseq'"/>
  </xsl:call-template>
  <xsl:text>}}}</xsl:text>
</xsl:template>

<xsl:template name="inline.underlineseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\underline{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- ==================================================================== -->
<!-- some special cases -->

<xsl:template match="author|editor|othercredit|personname">
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="authorinitials">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="authorgroup">
  <xsl:variable name="string">
    <xsl:call-template name="person.name.list"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($string)"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="accel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="action">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="application">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="classname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="code">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="exceptionname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="interfacename">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="methodname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="command">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="computeroutput">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="constant">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="database">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="errorcode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="errorname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="errortype">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="envar">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="filename">
  <xsl:choose>
  <!-- \Url cannot stand in a section heading -->
  <xsl:when test="$filename.as.url='1' and
                  not(ancestor::title or ancestor::refentrytitle)">
    <!-- Guess hyperref is always used now. -->
    <xsl:apply-templates mode="nolinkurl"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="inline.monoseq"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- By default propagate the mode -->
<xsl:template match="*" mode="nolinkurl">
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:apply-templates mode="nolinkurl">
    <xsl:with-param name="command" select="$command"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="text()" mode="nolinkurl">
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:call-template name="nolinkurl-output">
    <xsl:with-param name="url" select="."/>
    <xsl:with-param name="command" select="$command"/>
  </xsl:call-template>
</xsl:template>

<!-- Come back to inline.monoseq for templates where nolinkurl cannot apply -->
<xsl:template match="subscript|superscript" mode="nolinkurl">
  <xsl:call-template name="inline.monoseq">
    <xsl:with-param name="content">
      <xsl:apply-templates select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="replaceable" mode="nolinkurl">
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:call-template name="inline.italicmonoseq">
    <xsl:with-param name="content">
      <xsl:apply-templates mode="nolinkurl">
        <xsl:with-param name="command" select="$command"/>
      </xsl:apply-templates>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="indexterm" mode="nolinkurl">
  <xsl:apply-templates select="."/>
</xsl:template>


<xsl:template match="function">
  <xsl:choose>
    <xsl:when test="$function.parens != '0'
                    or parameter or function or replaceable"> 
      <xsl:variable name="nodes" select="text()|*"/>
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:apply-templates select="$nodes[1]"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="$nodes[position()>1]"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.monoseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="function/parameter" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="function/replaceable" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="replaceable" priority="1">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="guibutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guiicon">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guilabel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guimenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guimenuitem">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guisubmenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="hardware">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="interface">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="interfacedefinition">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="keycap">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="keycode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="keysym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="literal">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="medialabel">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="mousebutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="option">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="package">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="parameter">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="property">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="prompt">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="returnvalue">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="shortcut">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="structfield">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="structname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="symbol">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="systemitem">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="token">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="type">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="uri">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="userinput">
  <xsl:call-template name="inline.boldmonoseq"/>
</xsl:template>

<xsl:template match="abbrev">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="acronym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="citerefentry">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="citetitle">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="emphasis[@role='bold' or @role='strong']">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="emphasis[@role='underline']">
  <xsl:call-template name="inline.underlineseq"/>
</xsl:template>

<xsl:template match="errortext">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="firstname|surname|honorific|othername|lineage">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="foreignphrase">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="markup">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="phrase">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="quote">
  <xsl:variable name="depth">
    <xsl:call-template name="dot.count">
      <xsl:with-param name="string">
        <xsl:number level="multiple"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$depth mod 2 = 0">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.nestedstartquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.nestedendquote"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="varname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="wordasword">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="lineannotation">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="superscript">
  <xsl:call-template name="inline.superscriptseq"/>
</xsl:template>

<xsl:template match="subscript">
  <xsl:call-template name="inline.subscriptseq"/>
</xsl:template>

<xsl:template match="trademark">
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat">trademark</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="trademark[@class='copyright' or
                               @class='registered']">
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat" select="@class"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="trademark[@class='service']">
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="inline.superscriptseq">
    <xsl:with-param name="content" select="'SM'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="firstterm|glossterm">
  <xsl:variable name="termtext">
    <xsl:call-template name="inline.italicseq"/>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="@linkend">
    <xsl:call-template name="hyperlink.markup">
      <xsl:with-param name="linkend" select="@linkend"/>
      <xsl:with-param name="text" select="$termtext"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="$glossterm.auto.link != 0">
    <xsl:variable name="term">
      <xsl:choose>
        <xsl:when test="@baseform">
          <xsl:value-of select="normalize-space(@baseform)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="glossentry"
       select="(//glossentry[normalize-space(glossterm)=$term or
                             normalize-space(glossterm/@baseform)=$term][@id])[1]"/>
    <xsl:choose>
    <xsl:when test="$glossentry">
      <xsl:call-template name="hyperlink.markup">
        <xsl:with-param name="linkend" select="$glossentry/@id"/>
        <xsl:with-param name="text" select="$termtext"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Error: no ID glossentry for glossterm: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>.</xsl:text>
      </xsl:message>
      <xsl:value-of select="$termtext"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$termtext"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"></xsl:when>
      <xsl:otherwise>-</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="./*">
    <xsl:if test="position()>1"><xsl:value-of select="$joinchar"/></xsl:if>
    <xsl:apply-templates/>
  </xsl:for-each>
</xsl:template>

<xsl:strip-space elements="menuchoice shortcut"/>

<xsl:template match="menuchoice">
  <xsl:variable name="shortcut" select="./shortcut"/>
  <!-- print the menuchoice tree -->
  <xsl:for-each select="*[not(self::shortcut)]">
    <xsl:if test="position() > 1">
      <xsl:choose>
        <xsl:when test="self::guimenuitem or self::guisubmenu">
          <xsl:text>\hspace{2pt}\ensuremath{\to{}}</xsl:text>
        </xsl:when>
        <xsl:otherwise>+</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <!-- now, the shortcut if any -->
  <xsl:if test="$shortcut">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="$shortcut"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="jobtitle|corpauthor|orgname|orgdiv">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:call-template name="inline.charseq"/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="comment|remark">
  <xsl:if test="$show.comments != 0">
    <xsl:text>\comment</xsl:text>
    <xsl:if test="@role">
      <xsl:text>[title={</xsl:text>
      <xsl:value-of select="@role"/>
      <xsl:text>}]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:variable name="string">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($string)"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="productname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="productnumber">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="pob|street|city|state|postcode|country|phone|fax|otheraddr">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->
<!-- inline elements in program listings -->

<xsl:template name="verbatim.boldseq">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>
  <xsl:param name="style" select="'b'"/>
  <xsl:param name="content"/>

  <xsl:call-template name="verbatim.format">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
    <xsl:with-param name="style" select="'b'"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="userinput" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.boldseq">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="emphasis" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:variable name="style">
    <xsl:choose>
    <xsl:when test="@role='bold' or @role='strong'">
      <xsl:value-of select="'b'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'i'"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="verbatim.format">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
    <xsl:with-param name="style" select="$style"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="replaceable" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.format">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
    <xsl:with-param name="style" select="'i'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="optional" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates mode="latex.programlisting">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:apply-templates>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

</xsl:stylesheet>
