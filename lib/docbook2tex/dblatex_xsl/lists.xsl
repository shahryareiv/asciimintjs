<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Lists parameters -->
<xsl:param name="seg.item.separator">, </xsl:param>
<xsl:param name="variablelist.term.separator">, </xsl:param>
<xsl:param name="term.breakline">0</xsl:param>


<xsl:template match="variablelist/title|
                     orderedlist/title | itemizedlist/title | simplelist/title">
  <xsl:text>&#10;{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select=".."/>
  </xsl:call-template>
  <!-- Ask to latex to let the title with its list -->
  <xsl:text>\nopagebreak&#10;</xsl:text>
</xsl:template>

<!-- In latex, the list nesting depth is limited. The depths are checked in
     order to prevent from compilation crash. If the depth is correct
     the templates that actually do the work are called.
 -->
<xsl:template match="itemizedlist|orderedlist|variablelist">
  <xsl:variable name="ditem" select="count(ancestor-or-self::itemizedlist)"/>
  <xsl:variable name="dorder" select="count(ancestor-or-self::orderedlist)"/>
  <xsl:variable name="dvar" select="count(ancestor-or-self::variablelist)"/>
  <xsl:choose>
  <xsl:when test="$ditem &gt; 4">
    <xsl:message>*** Error: itemizedlist too deeply nested (&gt; 4)</xsl:message>
    <xsl:text>[Error: itemizedlist too deeply nested]</xsl:text>
  </xsl:when>
  <xsl:when test="$dorder &gt; 4">
    <xsl:message>*** Error: orderedlist too deeply nested (&gt; 4)</xsl:message>
    <xsl:text>[Error: orderedlist too deeply nested]</xsl:text>
  </xsl:when>
  <xsl:when test="($ditem+$dorder+$dvar) &gt; 6">
    <xsl:message>*** Error: lists too deeply nested (&gt; 6)</xsl:message>
    <xsl:text>[Error: lists too deeply nested]</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!-- Ok, can print the list -->
    <xsl:apply-templates select="." mode="print"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist" mode="print">
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="*[not(self::title or
                                     self::titleabbrev or
                                     self::listitem)]"/>
  <xsl:text>\begin{itemize}</xsl:text>
  <!-- Process the option -->
  <xsl:call-template name="opt.group">
    <xsl:with-param name="opts" select="@spacing"/>
    <xsl:with-param name="mode" select="'enumitem'"/>
  </xsl:call-template>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="listitem"/>
  <xsl:text>\end{itemize}&#10;</xsl:text>
</xsl:template>

<xsl:template match="orderedlist" mode="print">
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="*[not(self::title or
                                     self::titleabbrev or
                                     self::listitem)]"/>
  <xsl:text>\begin{enumerate}</xsl:text>
  <!-- Process the options -->
  <xsl:call-template name="opt.group">
    <xsl:with-param name="opts" select="@numeration|@continuation|@spacing"/>
    <xsl:with-param name="mode" select="'enumitem'"/>
  </xsl:call-template>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="listitem"/>
  <xsl:text>\end{enumerate}&#10;</xsl:text>
</xsl:template>

<xsl:template match="variablelist" mode="print">
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="*[not(self::title or
                                     self::titleabbrev or
                                     self::varlistentry)]"/>
  <xsl:text>&#10;\noindent&#10;</xsl:text> 
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates select="varlistentry"/>
  <xsl:text>\end{description}&#10;</xsl:text>
</xsl:template>

<xsl:template match="listitem">
  <!-- Add {} to avoid some mess with following square brackets [...] -->
  <xsl:text>&#10;\item{}</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="varlistentry">
  <xsl:text>\item[{</xsl:text>
  <xsl:apply-templates select="term"/>
  <xsl:text>}] </xsl:text>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="."/>
  </xsl:call-template>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="term"/>
  </xsl:call-template>
  <xsl:apply-templates select="term" mode="foottext"/>
  <xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="varlistentry/term">
  <xsl:apply-templates/>
  <xsl:if test="position()!=last()">
    <xsl:value-of select="$variablelist.term.separator"/>
  </xsl:if>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <xsl:choose>
  <!-- add a space to force linebreaks for immediate following lists -->
  <xsl:when test="child::*[1][self::itemizedlist or
                              self::orderedlist or
                              self::variablelist][not(child::title)]">
    <xsl:text>~</xsl:text>
  </xsl:when>
  <!-- add a space to force linebreaks for immediate following listings -->
  <xsl:when test="child::*[1][self::programlisting][not(child::title)]">
    <xsl:text>~</xsl:text>
  </xsl:when>
  <!-- add a space to avoid the term be centered -->
  <xsl:when test="child::*[not(self::indexterm)][1][self::figure]">
    <xsl:text>~ </xsl:text>
  </xsl:when>
  <!-- force linebreak after the term. The space is to avoid side effect
       with immediate following brackets [...]-->
  <xsl:when test="$term.breakline='1'">
    <xsl:text>\hspace{0em}\\~&#10;</xsl:text>
  </xsl:when>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>


<!-- ################
     # List Options #
     ################ -->

<!-- Process a group of options (reusable) -->
<xsl:template name="opt.group">
  <xsl:param name="opts"/>
  <xsl:param name="mode" select="'opt'"/>
  <xsl:param name="left" select="'['"/>
  <xsl:param name="right" select="']'"/>

  <xsl:variable name="result">
    <xsl:for-each select="$opts">
      <xsl:variable name="str">
        <xsl:apply-templates select="." mode="enumitem"/>
      </xsl:variable>
      <!-- Put a separator only if something really printed -->
      <xsl:if test="$str!='' and position()!=1">
        <xsl:text>,</xsl:text>
      </xsl:if>
      <xsl:value-of select="$str"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$result != ''">
    <xsl:value-of select="$left"/>
    <!-- Remove spurious first comma -->
    <xsl:choose>
      <xsl:when test="starts-with($result, ',')">
        <xsl:value-of select="substring-after($result, ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$right"/>
  </xsl:if>
</xsl:template>

<xsl:template match="@numeration" mode="enumitem">
  <xsl:text>label=</xsl:text>
  <xsl:choose>
    <xsl:when test=".='arabic'">\arabic*.</xsl:when>
    <xsl:when test=".='upperalpha'">\Alph*.</xsl:when>
    <xsl:when test=".='loweralpha'">\alph*.</xsl:when>
    <xsl:when test=".='upperroman'">\Roman*.</xsl:when>
    <xsl:when test=".='lowerroman'">\roman*.</xsl:when>
    <xsl:otherwise>\arabic*.</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@continuation" mode="enumitem">
  <xsl:if test=". = 'continues'">
    <xsl:text>resume</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="@spacing" mode="enumitem">
  <xsl:if test=". = 'compact'">
    <xsl:text>itemsep=0pt</xsl:text>
  </xsl:if>
</xsl:template>


<!-- ##############
     # Simplelist #
     ############## -->

<xsl:template name="tabular.string">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="i" select="1"/>
  <xsl:if test="$i &lt;= $cols">
    <xsl:text>l</xsl:text>
    <xsl:call-template name="tabular.string">
      <xsl:with-param name="i" select="$i+1"/>
      <xsl:with-param name="cols" select="$cols"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="member">
  <!-- Put in a group to protect each member from side effects (esp. \\) -->
  <xsl:text>{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>


<!-- Inline simplelist is a comma separated list of items -->

<xsl:template match="simplelist[@type='inline']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member">
  <xsl:apply-templates/>
  <xsl:if test="position()!=last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>


<!-- Horizontal simplelist, is actually a tabular -->

<xsl:template match="simplelist[@type='horiz']">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;\begin{tabular*}{\linewidth}{</xsl:text>
  <xsl:call-template name="tabular.string">
    <xsl:with-param name="cols" select="$cols"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text> 
  <xsl:for-each select="member">
    <xsl:apply-templates select="."/>
    <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:text> \\&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="position() mod $cols">
      <xsl:text> &amp; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> \\&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;\end{tabular*}&#10;</xsl:text>
</xsl:template>

<!-- Vertical simplelist, a tabular too -->

<xsl:template match="simplelist|simplelist[@type='vert']">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;\begin{tabular*}{\linewidth}{</xsl:text>
  <xsl:call-template name="tabular.string">
    <xsl:with-param name="cols" select="$cols"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text> 

  <!-- recusively display each row -->
  <xsl:call-template name="simplelist.vert.row">
    <xsl:with-param name="rows" select="floor((count(member)+$cols - 1) div $cols)"/>
  </xsl:call-template>
  <xsl:text>&#10;\end{tabular*}&#10;</xsl:text>
</xsl:template>

<xsl:template name="simplelist.vert.row">
  <xsl:param name="cell">0</xsl:param>
  <xsl:param name="rows"/>
  <xsl:if test="$cell &lt; $rows">
    <xsl:for-each select="member[((position()-1) mod $rows) = $cell]">
      <xsl:apply-templates select="."/>
      <xsl:if test="position()!=last()">
        <xsl:text> &amp; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text> \\&#10;</xsl:text> 
    <xsl:call-template name="simplelist.vert.row">
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- Segmentedlist stuff -->

<xsl:template match="segmentedlist">
  <xsl:text>\noindent </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="segmentedlist/title">
  <xsl:text>{\bf </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}\\&#10;</xsl:text>
</xsl:template>

<xsl:template match="segtitle">
</xsl:template>

<xsl:template match="segtitle" mode="segtitle-in-seg">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="seglistitem">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::seglistitem">
    <xsl:text> \\</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- We trust in the right count of segtitle declarations -->

<xsl:template match="seg">
  <xsl:variable name="segnum" select="count(preceding-sibling::seg)+1"/>
  <xsl:variable name="seglist" select="ancestor::segmentedlist"/>
  <xsl:variable name="segtitles" select="$seglist/segtitle"/>

  <!--
     Note: segtitle is only going to be the right thing in a well formed
     SegmentedList.  If there are too many Segs or too few SegTitles,
     you'll get something odd...maybe an error
  -->

  <xsl:text>\emph{</xsl:text>
  <xsl:apply-templates select="$segtitles[$segnum=position()]"
                       mode="segtitle-in-seg"/>
  <xsl:text>:} </xsl:text>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::seg">
    <xsl:value-of select="$seg.item.separator"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

