<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Literal parameters -->
<xsl:param name="literal.width.ignore">0</xsl:param>
<xsl:param name="literal.layout.options"/>
<xsl:param name="literal.lines.showall">1</xsl:param>
<xsl:param name="literal.role"/>
<xsl:param name="literal.class">monospaced</xsl:param>
<xsl:param name="literal.extensions"/>
<xsl:param name="linenumbering.scope"/>
<xsl:param name="linenumbering.default"/>
<xsl:param name="linenumbering.everyNth"/>
<!-- Use scalable dblatex listing if the feature is required -->
<xsl:param name="literal.environment">
  <xsl:choose>
  <xsl:when test="contains($literal.extensions,'scale')">
    <xsl:text>lstcode</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>lstlisting</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<xsl:template name="verbatim.setup">
  <!-- dblatex requires that a listing environment starts with 'lst' -->
  <xsl:if test="substring($literal.environment,1,3) != 'lst'">
    <xsl:message terminate="yes">
      <xsl:text>Error: </xsl:text>
      <xsl:value-of select="$literal.environment"/>
      <xsl:text>: a listing environment must start with 'lst'</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:apply-templates select="//screen|//programlisting"
                       mode="save.verbatim.preamble"/>
</xsl:template>

<xsl:template name="verbatim.setup2">
  <xsl:text>\lstsetup&#10;</xsl:text>
</xsl:template>


<xsl:template match="address">
  <xsl:call-template name="output.verbatim"/>
</xsl:template>

<xsl:template match="text()" mode="save.verbatim"/>

<xsl:template match="address"
              mode="save.verbatim">
  <xsl:call-template name="save.verbatim"/>
</xsl:template>

<xsl:template name="save.verbatim">
  <xsl:param name="content">
    <xsl:apply-templates mode="latex.verbatim"/>
  </xsl:param>
  <xsl:text>&#10;\begin{SaveVerbatim}{</xsl:text>
  <xsl:value-of select="generate-id()"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:value-of select="$content"/>
  <xsl:text>&#10;\end{SaveVerbatim}&#10;</xsl:text>
</xsl:template>

<xsl:template name="output.verbatim">
  <xsl:param name="content">
    <xsl:apply-templates mode="latex.verbatim"/>
  </xsl:param>
  <!-- In tables just use the data previously saved -->
  <xsl:choose>
  <xsl:when test="ancestor::entry|
                  ancestor::legalnotice">
    <xsl:text>\UseVerbatim{</xsl:text>
    <xsl:value-of select="generate-id(.)"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>&#10;\begin{verbatim}</xsl:text>
    <xsl:value-of select="$content"/>
    <xsl:text>\end{verbatim}&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Special cases where nothing to output in verbatim mode -->
<xsl:template match="alt" mode="latex.verbatim"/>

<!-- Returns the filename from @fileref or @entityref attribute -->
<xsl:template match="*" mode="filename.get">
  <xsl:choose>
  <xsl:when test="@entityref">
    <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="@fileref"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Template that must be called by elements that want to be escaped in a
     programlisting environment. It escapes the tex sequence, *but* prints
     out the sequence only if probing is not required (i.e. = 0).
     
     Probing is used by a parent that wants to know if it contains some
     element that needs some tex escaping.
     -->

<xsl:template name="verbatim.embed">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>
  <xsl:param name="content"/>

  <xsl:value-of select="concat($co-tagin, 't&gt;')"/>
  <xsl:if test="$probe = 0">
    <xsl:choose>
      <xsl:when test="$content != ''">
        <xsl:value-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:value-of select="'&lt;/t&gt;'"/>
</xsl:template>

<!-- Template to format (bold, italic) the calling element. The format is
     specified by the <style> that drives the corresponding delimiter
     sequence. Styles can be nested, so apply the same template mode to
     children.
     -->

<xsl:template name="verbatim.format">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>
  <xsl:param name="style" select="'b'"/>
  <xsl:param name="content"/>

  <xsl:value-of select="concat($co-tagin, $style, '&gt;')"/>
  <xsl:if test="$probe = 0">
    <xsl:choose>
      <xsl:when test="$content != ''">
        <xsl:value-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="latex.programlisting">
          <xsl:with-param name="co-tagin" select="$co-tagin"/>
          <xsl:with-param name="rnode" select="$rnode"/>
          <xsl:with-param name="probe" select="$probe"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:value-of select="concat('&lt;/', $style, '&gt;')"/>
</xsl:template>

<!-- A latex Processing-Instruction in verbatim is meaningfull, so
     process it.
     -->

<xsl:template match="processing-instruction('latex')"
              mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:value-of select="concat($co-tagin, 't', '&gt;')"/>
  <xsl:value-of select="."/>
  <xsl:value-of select="concat('&lt;/', 't', '&gt;')"/>
</xsl:template>

<!-- ==================================================================== -->

<!-- By default an element in a programlisting environment just prints out its
     text() adapted to this environment, and apply to its children the same
     template. -->

<xsl:template match="*" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:if test="$output.quietly = 0">
    <xsl:message>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text>: default template used in programlisting or screen</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:apply-templates mode="latex.programlisting">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:apply-templates>
</xsl:template>


<!-- ==================================================================== -->

<!-- The following templates now works only with the listings package -->

<!-- The listing content is internal to the element, and is not a reference
     to an external file -->

<xsl:template match="programlisting|screen|literallayout" mode="internal">
  <xsl:param name="opt"/>
  <xsl:param name="co-tagin"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="env" select="'lstlisting'"/>


  <xsl:text>&#10;\begin{</xsl:text>
  <xsl:value-of select="$env"/>
  <xsl:text>}</xsl:text>
  <xsl:if test="$opt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$opt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <!-- some text just after the open tag must be put on a new line -->
  <xsl:if test="not(contains(.,'&#10;')) or
                string-length(normalize-space(
                  substring-before(.,'&#10;')))&gt;0">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="latex.programlisting">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
  </xsl:apply-templates>
  <!-- ensure to have the end on a separate line -->
  <xsl:if test="substring(.,string-length(.))!='&#10;' and
                substring(translate(.,' &#09;',''),
                  string-length(translate(.,' &#09;','')))!='&#10;'">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\end{</xsl:text>
  <xsl:value-of select="$env"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="linenumbering">
  <xsl:choose>
    <xsl:when test="@linenumbering='numbered'">1</xsl:when>
    <xsl:when test="@linenumbering and @linenumbering!='numbered'">0</xsl:when>
    <xsl:when test="$linenumbering.default='numbered' and 
                   (contains(concat(' ',$linenumbering.scope,' '),
                             concat(' ',local-name(.),' ')))">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>
 
<xsl:template match="programlisting|screen|literallayout">
  <xsl:param name="rnode" select="/"/>

  <!-- formula to compute the listing width -->
  <xsl:variable name="width">
    <xsl:if test="$literal.width.ignore='0' and
                  @width and string(number(@width))!='NaN'">
      <xsl:text>\setlength{\lstwidth}{</xsl:text>
      <xsl:value-of select="@width"/>
      <xsl:text>\lstcharwidth+2\lstframesep}</xsl:text>
    </xsl:if>
  </xsl:variable>

  <!-- is there some elements needing escaping? -->
  <xsl:variable name="escaped">
    <xsl:apply-templates mode="latex.programlisting">
      <xsl:with-param name="probe" select="1"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- get the listing escape sequence if needed -->
  <xsl:variable name="co-tagin">
    <xsl:if test="descendant::co or $escaped != ''">
      <xsl:call-template name="co-tagin-gen"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="linenumbered">
    <xsl:call-template name="linenumbering"/>
  </xsl:variable>

  <xsl:variable name="role">
    <xsl:choose>
    <xsl:when test="@role">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$literal.role"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="opt">
    <!-- skip empty endlines -->
    <xsl:if test="$literal.lines.showall='0'">
      <xsl:text>showlines=false,</xsl:text>
    </xsl:if>
    <!-- Remove wrap mode if required -->
    <xsl:if test="$role='overflow'">
      <xsl:text>breaklines=false,</xsl:text>
    </xsl:if>
    <!-- The scaling feature is not available with standard listings -->
    <xsl:if test="contains($literal.extensions, 'scale')">
      <xsl:choose>
      <xsl:when test="$role='scale' or 
          ($role='' and $literal.extensions='scale.by.width' and $width!='')">
        <xsl:text>scale=true,</xsl:text>
        <!-- don't wrap to scale to the longest line if no width specified -->
        <xsl:if test="$width=''">
          <xsl:text>breaklines=false,</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>scale=false,</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- language option is only for programlisting -->
    <xsl:if test="@language">
      <xsl:text>language=</xsl:text>
      <xsl:value-of select="@language"/>
      <xsl:text>,</xsl:text>
    </xsl:if>
    <!-- listing width -->
    <xsl:if test="$width!=''">
      <xsl:text>linewidth=\lstwidth,</xsl:text>
    </xsl:if>
    <!-- print line numbers -->
    <xsl:if test="$linenumbered=1">
      <xsl:text>numbers=left,</xsl:text>
      <xsl:if test="number($linenumbering.everyNth) &gt; 1">
        <xsl:text>stepnumber=</xsl:text>
        <xsl:value-of select="number($linenumbering.everyNth)"/>
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:if>
    <!-- find the fist line number to print -->
    <xsl:choose>
    <xsl:when test="@startinglinenumber">
      <xsl:text>firstnumber=</xsl:text>
      <xsl:value-of select="@startinglinenumber"/>
      <xsl:text>,</xsl:text>
    </xsl:when>
    <xsl:when test="@continuation and (@continuation='continues')">
      <!-- ask for continuation -->
      <xsl:text>firstnumber=last</xsl:text>
      <xsl:text>,</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- explicit restart numbering -->
      <xsl:text>firstnumber=1</xsl:text>
      <xsl:text>,</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
    <!-- In literallayout no specific background, nor monospaced font -->
    <xsl:if test="self::literallayout">
      <xsl:text>backgroundcolor={},</xsl:text>
      <xsl:choose>
      <xsl:when test="@class='monospaced' or
                      $literal.class='monospaced'">
        <xsl:text>basicstyle=\ttfamily,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>basicstyle=\normalfont,flexiblecolumns,</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- TeX/verb delimiters if tex or formatting is embedded (like <co>s) -->
    <xsl:if test="$co-tagin!=''">
      <xsl:call-template name="listing-delim">
        <xsl:with-param name="tagin" select="$co-tagin"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <!-- put the listing with formula here -->
  <xsl:if test="$width!=''">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$width"/>
  </xsl:if>
  <xsl:choose>
  <xsl:when test="descendant::imagedata[@format='linespecific']|
                  descendant::inlinegraphic[@format='linespecific']|
                  descendant::textdata">
    <!-- the listing content is in an external file -->
    <xsl:text>&#10;\lstinputlisting</xsl:text>
    <xsl:if test="$opt!=''">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$opt"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates
        select="descendant::imagedata|descendant::inlinegraphic|
                descendant::textdata"
        mode="filename.get"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!-- the listing content is internal -->
    <xsl:apply-templates select="." mode="internal">
      <xsl:with-param name="rnode" select="$rnode"/>
      <xsl:with-param name="co-tagin" select="$co-tagin"/>
      <xsl:with-param name="opt" select="$opt"/>
      <xsl:with-param name="env" select="$literal.environment"/>
    </xsl:apply-templates>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Defines the style delimiters to use, and the tex sequence delimiters -->

<xsl:template name="listing-delim">
  <xsl:param name="tagin" select="'&lt;'"/>
  <xsl:variable name="tex" select="concat($tagin, 't&gt;')"/>
  <xsl:variable name="bf" select="concat($tagin, 'b&gt;')"/>
  <xsl:variable name="it" select="concat($tagin, 'i&gt;')"/>

  <xsl:text>escapeinside={</xsl:text>
  <xsl:value-of select="$tex"/>
  <xsl:text>}{&lt;/t&gt;}</xsl:text>
  <xsl:text>,</xsl:text>
  <xsl:text>moredelim={**[is][\bfseries]{</xsl:text>
  <xsl:value-of select="$bf"/>
  <xsl:text>}{&lt;/b&gt;}},</xsl:text>
  <xsl:text>moredelim={**[is][\itshape]{</xsl:text>
  <xsl:value-of select="$it"/>
  <xsl:text>}{&lt;/i&gt;}},</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<!-- Global listing saving, for listings in footnotes, since we never know
     in which context the footnotes are used. A check is done to not cover
     the other saving points in tables. -->

<xsl:template match="programlisting|screen|literallayout"
              mode="save.verbatim.preamble">
  <xsl:if test="not(ancestor::table or ancestor::informaltable) and
                ancestor::footnote">
    <xsl:apply-templates select="." mode="save.verbatim"/>
  </xsl:if>
</xsl:template>


<!-- Listings does not work in tables, even for external files. So, we
     use the fancyvrb verbatim coupled to listings for the rendering stuff.
     This mode assumes that all the verbatim data is in an external
     file. Using the save/use commands would work except for linenumbering
     stuff. -->

<xsl:template match="programlisting|screen|literallayout"
              mode="save.verbatim">
  <xsl:if test="not(descendant::imagedata[@format='linespecific']|
                    descendant::inlinegraphic[@format='linespecific']|
                    descendant::textdata)">
    <xsl:variable name="str1" select="."/>
    <xsl:variable name="str">
      <xsl:apply-templates mode="latex.programlisting"/>
    </xsl:variable>

    <xsl:text>\begin{VerbatimOut}{tmplst-</xsl:text>
    <xsl:value-of select="generate-id()"/>
    <xsl:text>}</xsl:text>
    <!-- some text just after the open tag must be put on a new line -->
    <xsl:if test="not(contains($str1,'&#10;')) or
           string-length(
             normalize-space(substring-before($str1,'&#10;')))&gt;0">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:value-of select="$str"/>
    <!-- put a \n only if needed -->
    <xsl:if test="substring($str1,string-length($str1))!='&#10;' and
                  substring(translate($str1,' &#09;',''),
                    string-length(translate($str1,' &#09;','')))!='&#10;'">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:text>\end{VerbatimOut}&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Special case for literal blocks in tables or foonotes -->
<xsl:template match="*[self::entry or
                       self::entrytbl or
                       self::footnote]//
                     *[self::programlisting or
                       self::screen or
                       self::literallayout]">

  <xsl:variable name="lsopt">
    <!-- language option is only for programlisting -->
    <xsl:if test="@language">
      <xsl:text>language=</xsl:text>
      <xsl:value-of select="@language"/>
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="linenumbered">
    <xsl:call-template name="linenumbering"/>
  </xsl:variable>

  <xsl:variable name="fvopt">
    <!-- print line numbers -->
    <xsl:if test="$linenumbered=1">
      <xsl:text>numbers=left,</xsl:text>
      <xsl:if test="number($linenumbering.everyNth) &gt; 1">
        <xsl:text>stepnumber=</xsl:text>
        <xsl:value-of select="number($linenumbering.everyNth)"/>
        <xsl:text>,</xsl:text>
      </xsl:if>
      <!-- find the fist line number to print -->
      <xsl:choose>
      <xsl:when test="@startinglinenumber">
        <xsl:text>firstnumber=</xsl:text>
        <xsl:value-of select="@startinglinenumber"/>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:when test="@continuation and (@continuation='continues')">
        <!-- ask for continuation -->
        <xsl:text>firstnumber=last</xsl:text>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- explicit restart numbering -->
        <xsl:text>firstnumber=1</xsl:text>
        <xsl:text>,</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- In literallayout no specific background, nor monospaced font -->
    <xsl:if test="self::literallayout">
      <xsl:choose>
      <xsl:when test="@class='monospaced' or
                      $literal.class='monospaced'">
        <xsl:text>fontfamily=tt,</xsl:text>
      </xsl:when>
      <!-- FIXME: don't know how to force to use normal text font -->
      </xsl:choose>
    </xsl:if>
    
    <!-- TODO: TeX delimiters if <co>s are embedded. Use commandchars -->
  </xsl:variable>

  <xsl:text>\begin{fvlisting}</xsl:text>
  <xsl:if test="$lsopt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$lsopt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>\VerbatimInput</xsl:text>
  <xsl:if test="$fvopt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$fvopt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>

  <xsl:text>{</xsl:text>
  <xsl:choose>
  <xsl:when test="descendant::imagedata[@format='linespecific']|
                  descendant::inlinegraphic[@format='linespecific']|
                  descendant::textdata">
    <!-- the listing content is in a (real) external file -->
    <xsl:apply-templates
        select="descendant::imagedata|descendant::inlinegraphic|
                descendant::textdata"
        mode="filename.abs.get"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- the listing is outputed in a temporary file -->
    <xsl:text>tmplst-</xsl:text>
    <xsl:value-of select="generate-id(.)"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>

  <xsl:text>\end{fvlisting}&#10;</xsl:text>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="filename.abs.get">
  <xsl:choose>
  <xsl:when test="@entityref">
    <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
  </xsl:when>
  <xsl:when test="contains(@fileref, ':')">
    <!-- absolute uri scheme -->
    <xsl:value-of select="substring-after(@fileref, ':')"/>
  </xsl:when>
  <xsl:when test="starts-with(@fileref, '/')">
    <!-- absolute unix like path -->
    <xsl:value-of select="@fileref"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- relative to the doc directory -->
    <xsl:value-of select="$current.dir"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="@fileref"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
