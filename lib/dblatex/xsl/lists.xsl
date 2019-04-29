<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Lists parameters -->
<xsl:param name="seg.item.separator">, </xsl:param>
<xsl:param name="variablelist.term.separator">, </xsl:param>
<xsl:param name="term.breakline">0</xsl:param>
<xsl:param name="segmentedlist.as.table" select="0"/>


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

<!-- ==================================================================== -->
<!-- Segmentedlist stuff -->

<xsl:template match="segmentedlist">
  <xsl:variable name="presentation">
    <xsl:call-template name="pi.dblatex_list-presentation"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$presentation = 'table'">
      <xsl:apply-templates select="." mode="seglist-table"/>
    </xsl:when>
    <xsl:when test="$presentation = 'list'">
      <xsl:apply-templates select="." mode="seglist-inline"/>
    </xsl:when>
    <xsl:when test="$segmentedlist.as.table != 0">
      <xsl:apply-templates select="." mode="seglist-table"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="seglist-inline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="segmentedlist" mode="seglist-inline">
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

<!-- ==================================================================== -->
<!-- Segmentedlist table presentation by Karl O. Pinc -->
<!--
      To make a LaTeX table we want to know:

      A) How much overall columnar space there is so we can equally
      apportion any leftover space using the proportional space
      allocator, '*'.

      B) Whether to autosize columns, letting LaTeX base the width on
      content, and B.1) which ones to autosize.

      Unfortunately these 2 types of information may be transmitted to
      us via one value, either the default.table.width param or the
      dblatex table-width PI.  We operate on the principal that the
      dblatex table-width PI completely overrides the
      default.table.width param, so we've really only one value to
      work with at any one time.  Since we get a single value we
      receive only one of A or B and must assume the other.

      We may or may not receive additional information regards A or B
      via the newtbl.autowidth param or the dblatex newtbl-autowidth
      PI or the dblatex colwidth PI.

      This is resolved as follows:
       o When B is specified, assume page width for A.
       o When A is specified, assume every column is equally apportioned.
       o When nothing is specified, assume page width for A and
         autosizing of every column.

      Note that page width is not a universally good default for
      table width.  Proportionally spaced columns will "appropriately"
      fill the page, but adding any fixed width columns or
      autowidth columns will result in a table that's wider than
      a page.

      To gain complete control the user must specify A, the overall
      table width, using param or PI above.  Then specify the width of
      each column, whether fixed, proportional, proportional + fixed,
      or autosized, via other methods.

      This works because the PIs and params that otherwise control
      table layout have precedence over the table width controls.  The
      dblatex colwidth PI only occurs within a lexically "inner"
      portion of the document so it always has priority.
      newtbl.autowidth (and the newtbl-autowidth PI) is defined to
      have priority over table.width (and it's PI).
      -->

<!-- Table width specifier from PI or param? -->
<xsl:template name="segtable.table-width">
  <xsl:variable name="table-width">
    <xsl:call-template name="pi.dblatex_table-width"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$table-width = ''">
      <xsl:value-of select="$default.table.width"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$table-width"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- The user-specified list of autowidth columns.  -->
<!-- (A "column:..." keyword denoting which columns are autowidth.) -->
<xsl:template name="segtable.autocols">
  <xsl:param name="autowidth-pi"/>  <!-- the latex newtbl-autowidth PI -->
  <xsl:param name="table-width"/>   <!-- user specified table width    -->

  <xsl:choose>
    <xsl:when test="contains($autowidth-pi, 'column:')">
      <xsl:value-of select="$autowidth-pi"/>
    </xsl:when>
    <xsl:when test="$autowidth-pi = ''
                    and contains($table-width, 'column:')">
      <xsl:value-of select="$table-width"/>
    </xsl:when>
  </xsl:choose>
  <!-- End with a space so we can use contains() to test content.  -->
  <xsl:text> </xsl:text>
</xsl:template>

<!-- Let LaTeX determine column width or space columns equally? -->
<xsl:template name="segtable.autowidth">
  <xsl:param name="autowidth.pi"/>  <!-- the latex newtbl-autowidth PI -->
  <xsl:param name="table-width"/>   <!-- user specified table width    -->

  <!-- Autowidth specifier from PI or param? -->
  <xsl:variable name="autowidth">
    <xsl:choose>
      <xsl:when test="$autowidth.pi = ''">
        <xsl:value-of select="$newtbl.autowidth"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$autowidth.pi"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Normalize to "0" or "1" for sanity. -->
  <xsl:choose>
    <xsl:when test="$autowidth = ''">
      <!-- Fall back to the table width specification. -->
      <xsl:choose>
        <xsl:when test="$table-width = ''">
          <!-- no info, default to autowidth -->
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:when test="contains($table-width, 'auto')">
          <xsl:choose>
            <xsl:when test="contains($table-width, 'none')
                            or contains($table-width, 'column:')">
              <!-- explicit "none", or only some but not all -->
              <xsl:text>none</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <!-- "default" and "all" mean "all" -->
              <xsl:text>1</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <!-- Explicit table width absent explicit autowidth -->
          <!-- Do proportional spacing -->
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:otherwise>
      <!-- use autowidth data -->
      <xsl:choose>
        <xsl:when test="contains($autowidth, 'column:')">
          <!-- The unspecified columns are proportionally spaced. -->
          <xsl:text>0</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$autowidth = 'none'">
              <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>1</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Make colspec for a constructed proportional column. -->
<xsl:template name="proportional.column">
  <colspec
      colwidth="\newtblstarfactor"
      star="1"/>
</xsl:template>

<!-- Make colspec for a constructed autowidth column. -->
<xsl:template name="autowidth.column">
  <colspec
      autowidth="1"/>
</xsl:template>

<!-- Make colspec for a column where the user specifies the column width. -->
<xsl:template name="user.specified.column">
  <xsl:param name="colwidth.pi"/>  <!-- the latex colwidth PI -->

  <xsl:variable name="fixed">
    <xsl:call-template name="colfixed.get">
      <xsl:with-param name="width" select="$colwidth.pi"/>
    </xsl:call-template>
  </xsl:variable>

  <colspec>
    <xsl:if test="$fixed != ''">
      <xsl:attribute name="fixedwidth">
        <xsl:value-of select="$fixed"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="contains($colwidth.pi, '*')">
        <xsl:attribute name="colwidth">
          <!-- This call duplicates code in newtbl.xsl -->
          <xsl:call-template name="replace-string">
            <xsl:with-param name="text" select="$colwidth.pi"/>
            <xsl:with-param name="replace">*</xsl:with-param>
            <xsl:with-param name="with">\newtblstarfactor</xsl:with-param>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:attribute name="star">
          <xsl:call-template name="colstar.get">
            <!-- This also is a duplicate of code in newtbl.xsl -->
            <xsl:with-param
                name="width"
                select="substring-before($colwidth.pi, '*')"/>
          </xsl:call-template>
        </xsl:attribute>
      </xsl:when>

      <xsl:otherwise>
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$colwidth.pi"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </colspec>
</xsl:template>

<!-- Use newtbl.xsl templates to calculate proportional column widths:
   - tbl.sizes wants colspecs so build a set of fake colspec elements.
   -
   - tbl.sizes takes a collection of colspec elements, each having
   - the following (optional) attributes:
   -
   - fixedwidth
   -   String.  The fixed part (from colfixed.get) of a specified
   -   column width.
   -
   - star
   -   String (that we know can be converted to a number).
   -   The "prefix count" of the * (from colstar.get).
   -
   - colwidth
   -   String.  The user-specified column width with * replaced with
   -   "\newtblstarfactor".
   -
   - The code in this file uses the (optional) attributes:
   -   colwidth
   -   autowidth
   -     String (always "1").  When present (regardless of value!)
   -     autowidth means the column is latex spaced.
-->

<!-- Build up a complete colspec for each column -->
<xsl:template name="segtable.colspecs">
  <xsl:param name="table-width"/>   <!-- user specified table width    -->

  <xsl:variable name="autowidth.pi">
    <xsl:call-template name="pi.dblatex_autowidth"/>
  </xsl:variable>

  <!-- Let LaTeX determine column width or space columns equally? -->
  <xsl:variable name="autowidth">
    <xsl:call-template name="segtable.autowidth">
      <xsl:with-param name="autowidth.pi" select="$autowidth.pi"/>
      <xsl:with-param name="table-width"  select="$table-width"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- The user-specified list of autowidth columns.  -->
  <xsl:variable name="autocols">
    <xsl:call-template name="segtable.autocols">
      <xsl:with-param name="autowidth.pi" select="$autowidth.pi"/>
      <xsl:with-param name="table-width"  select="$table-width"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Build the colspecs -->
  <xsl:for-each select="segtitle">
    <xsl:variable name="colwidth.pi">
      <xsl:call-template name="pi.dblatex_colwidth"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$colwidth.pi = ''">
        <!-- Make up a colwidth -->
        <xsl:choose>
          <xsl:when test="contains($autocols,
                                   concat(' ', position(), ' '))
                          or $autowidth = '1'">
            <xsl:call-template name="autowidth.column"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="proportional.column"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:when test="$colwidth.pi = 'autowidth.default'
                      or $colwidth.pi = 'autowidth.all'">
        <xsl:call-template name="autowidth.column"/>
      </xsl:when>

      <xsl:when test="$colwidth.pi = 'autowidth.none'">
        <xsl:call-template name="proportional.column"/>
      </xsl:when>

      <xsl:otherwise>
        <!-- The user specified an actual column width. -->
        <xsl:call-template name="user.specified.column">
          <xsl:with-param name="colwidth.pi" select="$colwidth.pi"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<!-- Output latex to compute latex lengths needed for tables. -->
<xsl:template name="segtable.length.setup">
  <xsl:param name="table-width"/>   <!-- user specified table width    -->
  <xsl:param name="colspecs"/>      <!-- constructed column specifiers -->

  <!-- What is the latex table width? -->
  <xsl:variable name="width">
    <!-- The $fullwidth value written here is also hardcoded into -->
    <!-- newtbl.xsl, htmltbl.xsl, and tablen.xsl. (!) Cleanup is -->
    <!-- likely called for. -->
    <xsl:variable name="fullwidth">\linewidth-2\tabcolsep</xsl:variable>
    <xsl:choose>
    <xsl:when test="$table-width = ''
                    or contains($table-width, 'auto')">
      <xsl:value-of select="$fullwidth"/>
    </xsl:when>
    <xsl:when test="contains($table-width, '%')">
      <xsl:value-of select="number(substring-before($table-width, '%'))
                            div 100"/>
      <xsl:value-of select="$fullwidth"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$table-width"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Setup latex for fixed table width. -->
  <xsl:call-template name="tbl.sizes">
    <xsl:with-param name="colspec" select="$colspecs"/>
    <xsl:with-param name="width" select="$width"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="segmentedlist" mode="seglist-table">
  <!-- Bug: <info> elements are ignored, except for their <title> -->
  <!-- and <titleabbrev> elements. -->

  <!-- Which table width value are we using, PI or param? -->
  <xsl:variable name="table-width">
    <xsl:call-template name="segtable.table-width"/>
  </xsl:variable>

  <!-- Build up a complete colspec for each column -->
  <xsl:variable name="colspecs-text">
    <xsl:call-template name="segtable.colspecs">
      <xsl:with-param name="table-width" select="$table-width"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- Convert to nodes so we can use it.  -->
  <xsl:variable name="colspecs" select="exsl:node-set($colspecs-text)"/>

  <!-- Setup latex (nested) group(s) for table. -->
  <xsl:text>&#10;&#10;{\raggedright\savetablecounter</xsl:text>
  <xsl:text>\begingroup%&#10;</xsl:text>

  <!-- Output latex to compute latex lengths needed for tables. -->
  <xsl:call-template name="segtable.length.setup">
    <xsl:with-param name="table-width" select="$table-width"/>
    <xsl:with-param name="colspecs"    select="$colspecs"/>
  </xsl:call-template>

  <!-- Start table. -->
  <!-- Title goes in table; it's in the heading so if the table -->
  <!-- spans multiple pages there's always a title. -->

  <!-- No "custom" padding before or after the longtable. -->
  <!-- The content of a segmentedlist (aside from the <info> content, -->
  <!-- which presumably isn't rendered in the table itself except for -->
  <!-- <title> and <titleabbrev>) is all inline so we don't need to   -->
  <!-- worry about nested tables and can safely set LTpre and LTpost. -->
  <xsl:text>\setlength{\LTpre}{\parskip}</xsl:text>

  <!-- longtable puts an extra empty row at the bottom so              -->
  <!-- offset the bottom padding by one row height.                    -->
  <!-- Near as I can tell the extra row is the "dummy" row, consisting -->
  <!-- of a bunch of "m" chars followed by an "i".  So use the height  -->
  <!-- of an "i" as the height of the extra row.                       -->
  <xsl:text>\setlength{\LTpost}{\parskip-\fontcharht\font`i}%&#10;</xsl:text>

  <xsl:text>\begin{longtable}[l]{</xsl:text>
  <xsl:for-each select="$colspecs/colspec">
    <xsl:text>l</xsl:text>
  </xsl:for-each>
  <xsl:text>}&#10;</xsl:text>

  <!-- Apply templates to children separately so we can use position() -->
  <!-- when processing segtitle. -->

  <xsl:apply-templates mode="seg-table"
                       select="title|info/title|titleabbrev|info/titleabbrev">
    <xsl:with-param name="colspecs" select="$colspecs"/>
  </xsl:apply-templates>

  <xsl:apply-templates mode="seg-table" select="segtitle">
    <xsl:with-param name="colspecs" select="$colspecs"/>
  </xsl:apply-templates>

  <xsl:apply-templates mode="seg-table" select="seglistitem">
    <xsl:with-param name="colspecs" select="$colspecs"/>
  </xsl:apply-templates>

  <xsl:text>\end{longtable}\endgroup%&#10;</xsl:text>
  <xsl:text>\restoretablecounter%&#10;</xsl:text>

  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="title|titleabbrev" mode="seglist-title">
  <xsl:text>{\bf </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="segmentedlist/title
                     | segmentedlist/info/title
                     | segmentedlist/titleabbrev[not(../title)]
                     | segmentedlist/info/titleabbrev[not(../title)]"
              mode="seg-table">
  <xsl:param name="colspecs"/>

  <!-- Autowidth in any column then use autowidth for title, -->
  <!-- otherwise, use the sum of the column widths. -->

  <xsl:text>\multicolumn{</xsl:text>
  <xsl:value-of select="count($colspecs/colspec)"/>
  <xsl:text>}{</xsl:text>
  <xsl:choose>
    <xsl:when test="$colspecs/colspec/@autowidth">
      <xsl:text>l</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>p{</xsl:text>
      <xsl:for-each select="$colspecs/colspec">
        <xsl:value-of select="@colwidth"/>
        <xsl:if test="following-sibling::colspec">
          <xsl:text>+\tabcolsep+</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}{\raggedright%&#10;</xsl:text>
  <xsl:apply-templates select="." mode="seglist-title"/>
  <xsl:text>%&#10;}\tabularnewline&#10;</xsl:text>
</xsl:template>

<xsl:template name="segmentedlist.col">
  <!-- Make segmentedlist column -->
  <xsl:param name="colspecs"/>
  <xsl:param name="format"/>
  <xsl:param name="heading" select="0"/>

  <xsl:variable name="position">
    <xsl:value-of select="position()"/>
  </xsl:variable>

  <xsl:variable name="colspec"
                select="$colspecs/colspec[position()=$position]"/>

  <xsl:variable name="colwidth">
    <xsl:value-of select="$colspec/@colwidth"/>
  </xsl:variable>

  <!-- value-of a missing attribute returns a empty text node,
       - but we want to know about the _existance_ of the attribute,
       - not it's content, and testing for "" is ugly.
       - So "select=..." in variable. -->
  <xsl:variable name="autowidth"
                select="$colspec/@autowidth"/>

  <xsl:text>\multicolumn{1}{</xsl:text>
  <!-- centering/justification and column width -->
  <!-- (and open { for cell content) -->
  <xsl:choose>
  <xsl:when test="$autowidth">
    <xsl:choose>
      <xsl:when test="$format = 'p'">
	<xsl:text>l</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>c</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}{%&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$format"/>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$colwidth"/>
    <xsl:text>}}{</xsl:text>
    <xsl:choose>
      <xsl:when test="$format = 'p'">
	<xsl:text>\raggedright</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>\centering</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>%&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  <!-- cell content -->
  <xsl:choose>
    <xsl:when test="$heading">
      <xsl:text>\emph{</xsl:text>
      <xsl:apply-templates select="."
			   mode="segtitle-in-seg"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>%&#10;}</xsl:text>
  <!-- separate from future content -->
  <xsl:choose>
    <xsl:when test="position() != last()">
      <xsl:text>&amp;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when
            test="self::segtitle
                  or parent::seglistitem[following-sibling::seglistitem]">
          <xsl:text>\tabularnewline</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>%</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="segtitle" mode="seg-table">
  <xsl:param name="colspecs"/>

  <xsl:call-template name="segmentedlist.col">
    <xsl:with-param name="colspecs" select="$colspecs"/>
    <xsl:with-param name="format">m</xsl:with-param>
    <xsl:with-param name="heading" select="1"/>
  </xsl:call-template>
  <xsl:if test="not(following-sibling::segtitle)">
    <xsl:text>\endhead&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="seglistitem" mode="seg-table">
  <xsl:param name="colspecs"/>
  <xsl:apply-templates mode="seg-table">
    <xsl:with-param name="colspecs" select="$colspecs"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="seg" mode="seg-table">
  <xsl:param name="colspecs"/>

  <xsl:call-template name="segmentedlist.col">
    <xsl:with-param name="colspecs" select="$colspecs"/>
    <xsl:with-param name="format">p</xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>

