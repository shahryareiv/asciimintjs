<?xml version='1.0' encoding="utf-8" ?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="doc exsl" version='1.0'>

<xsl:param name="default.table.rules">none</xsl:param>



<xsl:template match="table|informaltable" mode="htmlTable">
  <xsl:param name="tabletype">tabular</xsl:param>
  <xsl:param name="tablewidth">\linewidth-2\tabcolsep</xsl:param>
  <xsl:param name="tableframe">all</xsl:param>

  <xsl:variable name="numcols">
    <xsl:call-template name="widest-html-row">
      <xsl:with-param name="rows" select=".//tr"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Get the specified table width -->
  <xsl:variable name="table.width">
    <xsl:call-template name="table.width">
      <xsl:with-param name="fullwidth" select="$tablewidth"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Find the table width -->
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="not(contains($table.width,'auto'))">
        <xsl:value-of select="$table.width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="table.width">
          <xsl:with-param name="fullwidth" select="$tablewidth"/>
          <xsl:with-param name="exclude" select="'auto'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Now the frame style -->
  <xsl:variable name="frame">
    <xsl:choose>
      <xsl:when test="@frame">
        <xsl:call-template name="cals.frame">
          <xsl:with-param name="frame" select="@frame"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$tableframe"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colspec">
    <xsl:choose>
    <xsl:when test="colgroup or col">
      <xsl:apply-templates select="(colgroup|col)[1]"
                           mode="make.colspec">
        <xsl:with-param name="colnum" select="1"/>
        <xsl:with-param name="colmax" select="$numcols"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="make.colspec.default">
        <xsl:with-param name="colnum" select="1"/>
        <xsl:with-param name="colmax" select="$numcols"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Build the <row>s from the <tr>s -->
  <xsl:variable name="rows-head" select="tr[child::th]"/>
  <xsl:variable name="rows-body" select="tr[not(child::th)]"/>

  <xsl:variable name="rows">
    <!-- First the header -->
    <xsl:choose>
    <xsl:when test="thead">
      <xsl:apply-templates select="thead" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$rows-head[1]" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
        <xsl:with-param name="rownum" select="1"/>
        <xsl:with-param name="context" select="'thead'"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>

    <!-- Then the body -->
    <xsl:choose>
    <xsl:when test="tbody">
      <xsl:apply-templates select="tbody" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$rows-body[1]" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
        <xsl:with-param name="rownum" select="count($rows-head) +
                                              count(thead/*) + 1"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="tfoot/tr[1]" mode="htmlTable">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      <xsl:with-param name="rownum" select="count(.//tr[not(parent::tfoot)])+1"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- Complete the colspecs @width from the fully expended <row>s -->
  <xsl:variable name="colspec2">
    <xsl:call-template name="build.colwidth">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      <xsl:with-param name="rows" select="exsl:node-set($rows)"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- TIP: to check the built RTF elements, uncomment and call testtbl.xsl 
  <xsl:copy-of select="exsl:node-set($colspec2)"/>
  <xsl:copy-of select="exsl:node-set($rows)"/>
  -->

  <xsl:variable name="t.rows" select="exsl:node-set($rows)"/>

  <xsl:text>\begingroup%&#10;</xsl:text>

  <!-- Set cellpadding, but only on columns -->
  <xsl:if test="@cellpadding">
    <xsl:text>\setlength{\tabcolsep}{</xsl:text>
    <xsl:choose>
    <xsl:when test="contains(@cellpadding, '%')">
      <xsl:value-of
          select="number(substring-before(@cellpadding,'%')) div 100"/>
      <xsl:text>\linewidth</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@cellpadding"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}%&#10;</xsl:text>
  </xsl:if>

  <xsl:text>\setlength{\tablewidth}{</xsl:text>
  <xsl:value-of select="$width"/>
  <xsl:text>}%&#10;</xsl:text>

  <xsl:if test="$tabletype != 'tabularx'">
    <xsl:call-template name="tbl.sizes">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$tabletype = 'tabularx'">
    <xsl:call-template name="tbl.valign.x">
      <xsl:with-param name="valign" select="@valign"/>
    </xsl:call-template>
  </xsl:if>
  
  <!-- Translate the table to latex -->

  <!-- Start the table declaration -->
  <xsl:call-template name="tbl.begin">
    <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="width" select="$width"/>
  </xsl:call-template>

  <!-- Need a top line? -->
  <xsl:if test="$frame = 'all' or $frame = 'top' or $frame = 'topbot'">
    <xsl:text>\hline</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>

  <!-- First, the head rows -->
  <xsl:variable name="headrows">
    <xsl:apply-templates select="$t.rows/*[@type='thead']"
                         mode="htmlTable">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
      <xsl:with-param name="context" select="'thead'"/>
      <xsl:with-param name="frame" select="$frame"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:apply-templates select="." mode="newtbl.endhead">
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="headrows" select="$headrows"/>
  </xsl:apply-templates>

  <!-- Then, the body rows -->
  <xsl:apply-templates select="$t.rows/*[@type!='thead']"
                       mode="htmlTable">
    <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
    <xsl:with-param name="context" select="'tbody'"/>
    <xsl:with-param name="frame" select="$frame"/>
  </xsl:apply-templates>

  <!-- Need a bottom line? -->
  <xsl:if test="$frame = 'all' or $frame = 'bottom' or $frame = 'topbot'">
    <xsl:text>\hline</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:text>\end{</xsl:text>
  <xsl:value-of select="$tabletype"/>
  <xsl:text>}\endgroup%&#10;</xsl:text>

</xsl:template>


<!-- Build the latex row from the <row> element -->
<xsl:template match="row" mode="htmlTable">
  <xsl:param name="colspec"/>
  <xsl:param name="context"/>
  <xsl:param name="frame"/>

  <xsl:apply-templates mode="newtbl">
    <xsl:with-param name="colspec" select="$colspec"/>
    <xsl:with-param name="context" select="$context"/>
    <xsl:with-param name="frame" select="$frame"/>
    <xsl:with-param name="rownum" select="@rownum"/>
  </xsl:apply-templates>

  <!-- End this row -->
  <xsl:text>\tabularnewline&#10;</xsl:text>
  
  <!-- Now process rowseps only if not the last row -->
  <xsl:if test="@rowsep=1">
    <xsl:choose>
    <xsl:when test="$newtbl.use.hhline='1'">
      <xsl:call-template name="hhline.build">
        <xsl:with-param name="entries" select="."/>
        <xsl:with-param name="rownum" select="@rownum"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="clines.build">
        <xsl:with-param name="entries" select="."/>
        <xsl:with-param name="rownum" select="@rownum"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>


<xsl:template match="thead" mode="htmlTable">
  <xsl:param name="colspec"/>
  <xsl:apply-templates select="tr[1]" mode="htmlTable">
    <xsl:with-param name="colspec" select="$colspec"/>
    <xsl:with-param name="rownum" select="1"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="tbody" mode="htmlTable">
  <xsl:param name="colspec"/>
  <xsl:apply-templates select="tr[1]" mode="htmlTable">
    <xsl:with-param name="colspec" select="$colspec"/>
    <xsl:with-param name="rownum"
                    select="count(preceding-sibling::*[self::tbody or
                                                       self::thead]/*)+1"/>
  </xsl:apply-templates>
</xsl:template>


<!-- Build an intermediate <row> element from a <tr> only if the row
     has the required 'context'
  -->
<xsl:template match="tr" mode="htmlTable">
  <xsl:param name="rownum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="oldentries"><nop/></xsl:param>
  <xsl:param name="context"/>

  <xsl:variable name="type">
    <xsl:choose>
    <xsl:when test="parent::thead">thead</xsl:when>
    <xsl:when test="parent::tbody">tbody</xsl:when>
    <xsl:when test="parent::tfoot">tfoot</xsl:when>
    <!-- 'tr' contain 'th' and is not in a t* group -->
    <xsl:when test="th">thead</xsl:when>
    <xsl:otherwise>tbody</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$context='' or $type=$context">
    <xsl:variable name="entries">
      <xsl:apply-templates select="(td|th)[1]" mode="htmlTable">
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colnum" select="1"/>
        <xsl:with-param name="entries" select="exsl:node-set($oldentries)"/>
      </xsl:apply-templates>
    </xsl:variable>

    <row type='{$type}' rownum='{$rownum}'>
      <xsl:call-template name="html.table.row.rules"/>
      <xsl:copy-of select="$entries"/>
    </row>

    <xsl:apply-templates select="following-sibling::tr[1]" mode="htmlTable">
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="rownum" select="$rownum + 1"/>
      <xsl:with-param name="oldentries" select="$entries"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
  </xsl:if>

</xsl:template>

<!-- ==================================================================== -->

<!-- This template writes rowsep equivalant for html tables -->
<xsl:template name="html.table.row.rules">
  <xsl:variable name="border" 
                select="(ancestor::table |
                         ancestor::informaltable)[last()]/@border"/>
  <xsl:variable name="table.rules"
                select="(ancestor::table |
                         ancestor::informaltable)[last()]/@rules"/>

  <xsl:variable name="rules">
    <xsl:choose>
      <xsl:when test="$table.rules != ''">
        <xsl:value-of select="$table.rules"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) != 0">
        <xsl:value-of select="'all'"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) = 0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:when test="$default.table.rules != ''">
        <xsl:value-of select="$default.table.rules"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>

    <xsl:when test="$rules = 'none'">
      <xsl:attribute name="rowsep">0</xsl:attribute>
    </xsl:when>

    <xsl:when test="$rules = 'cols'">
      <xsl:attribute name="rowsep">0</xsl:attribute>
    </xsl:when>

    <!-- If not the last row, add border below -->
    <xsl:when test="$rules = 'rows' or $rules = 'all'">
      <xsl:variable name="rowborder">
        <xsl:choose>
          <!-- If in thead and tbody has rows, add border -->
          <xsl:when test="parent::thead/
                          following-sibling::tbody/tr">1</xsl:when>
          <!-- If in tbody and tfoot has rows, add border -->
          <xsl:when test="parent::tbody/
                          following-sibling::tfoot/tr">1</xsl:when>
          <!-- If in thead and table has body rows, add border -->
          <xsl:when test="parent::thead/
                          following-sibling::tr">1</xsl:when>
          <xsl:when test="parent::tbody/
                          preceding-sibling::tfoot/tr">1</xsl:when>
          <xsl:when test="preceding-sibling::tfoot/tr">1</xsl:when>
          <!-- If following rows, but not rowspan reaches last row -->
          <xsl:when test="following-sibling::tr and
             not(@rowspan = count(following-sibling::tr) + 1)">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$rowborder = 1">
        <xsl:attribute name="rowsep">1</xsl:attribute>
      </xsl:if>
    </xsl:when>

    <!-- rules only between 'thead' and 'tbody', or 'tbody' and 'tfoot' -->
    <xsl:when test="$rules = 'groups' and parent::thead 
                    and not(following-sibling::tr)">
      <xsl:attribute name="rowsep">1</xsl:attribute>
    </xsl:when>
    <xsl:when test="$rules = 'groups' and parent::tfoot 
                    and not(preceding-sibling::tr)">
      <xsl:attribute name="rowsep">1</xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="html.table.column.rules">
  <xsl:param name="colnum"/>
  <xsl:param name="colmax"/>

  <xsl:variable name="border" 
                select="(ancestor-or-self::table |
                         ancestor-or-self::informaltable)[last()]/@border"/>
  <xsl:variable name="table.rules"
                select="(ancestor-or-self::table |
                         ancestor-or-self::informaltable)[last()]/@rules"/>

  <xsl:variable name="rules">
    <xsl:choose>
      <xsl:when test="$table.rules != ''">
        <xsl:value-of select="$table.rules"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) != 0">
        <xsl:value-of select="'all'"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) = 0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:when test="$default.table.rules != ''">
        <xsl:value-of select="$default.table.rules"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$rules = 'none'">
      <xsl:attribute name="colsep">0</xsl:attribute>
    </xsl:when>
    <xsl:when test="$rules = 'rows'">
      <xsl:attribute name="colsep">0</xsl:attribute>
    </xsl:when>
    <xsl:when test="$rules = 'groups'">
      <xsl:attribute name="colsep">0</xsl:attribute>
    </xsl:when>
    <!-- If not the last column, add border after -->
    <xsl:when test="($rules = 'cols' or $rules = 'all') and
                    ($colnum &lt; $colmax)">
      <xsl:attribute name="colsep">1</xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="td|th" mode="htmlTable">
  <xsl:param name="rownum"/>
  <xsl:param name="colnum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="entries"/>

  <xsl:variable name="cols" select="count($colspec/*)"/>
 
  <xsl:if test="$colnum &lt;= $cols">

    <xsl:variable name="entry"
                  select="$entries/*[self::entry or self::entrytbl]
                                    [@colstart=$colnum and
                                     @rowend &gt;= $rownum]"/>

    <!-- Do we have an existing entry element from a previous row that -->
    <!-- should be copied into this row? -->
    <xsl:choose><xsl:when test="$entry">
      <!-- Just copy this entry then -->
      <xsl:copy-of select="$entry"/>

      <!-- Process the next column using this current entry -->
      <xsl:apply-templates mode="htmlTable" select=".">
        <xsl:with-param name="colnum" 
                        select="$entries/entry[@colstart=$colnum]/@colend + 1"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="entries" select="$entries"/>
      </xsl:apply-templates>
    </xsl:when><xsl:otherwise>

      <xsl:variable name="colstart" select="$colnum"/>

      <xsl:variable name="colend">
        <xsl:choose>
        <xsl:when test="@colspan">
          <xsl:value-of select="@colspan + $colnum -1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$colnum"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rowend">
        <xsl:choose>
        <xsl:when test="@rowspan">
          <xsl:value-of select="@rowspan + $rownum -1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rownum"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rowcolor" select="parent::tr/@bgcolor"/>

      <xsl:variable name="col" select="$colspec/colspec[@colnum=$colstart]"/>

      <xsl:variable name="bgcolor">
        <xsl:choose>
          <xsl:when test="$rowcolor != ''">
            <xsl:value-of select="$rowcolor"/>
          </xsl:when>
          <xsl:when test="$col/@bgcolor">
            <xsl:value-of select="$col/@bgcolor"/>
          </xsl:when>
          <xsl:when test="ancestor::*[@bgcolor]">
            <xsl:value-of select="ancestor::*[@bgcolor][last()]/@bgcolor"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="valign">
        <xsl:choose>
          <xsl:when test="../@valign">
            <xsl:value-of select="../@valign"/>
          </xsl:when>
          <xsl:when test="$col/@valign">
            <xsl:value-of select="$col/@valign"/>
          </xsl:when>
          <xsl:when test="ancestor::*[@valign]">
            <xsl:value-of select="ancestor::*[@valign][last()]/@valign"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="align">
        <xsl:choose>
          <xsl:when test="../@align">
            <xsl:value-of select="../@align"/>
          </xsl:when>
          <xsl:when test="$col/@align">
            <xsl:value-of select="$col/@align"/>
          </xsl:when>
          <xsl:when test="ancestor::*[@align]">
            <xsl:value-of select="ancestor::*[@align][last()]/@align"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <entry>
        <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
        <xsl:attribute name="colstart">
          <xsl:value-of select="$colstart"/>
        </xsl:attribute>
        <xsl:attribute name="colend">
          <xsl:value-of select="$colend"/>
        </xsl:attribute>
        <xsl:attribute name="rowstart">
          <xsl:value-of select="$rownum"/>
        </xsl:attribute>
        <xsl:attribute name="rowend">
          <xsl:value-of select="$rowend"/>
        </xsl:attribute>
        <xsl:if test="$rowend &gt; $rownum">
          <xsl:attribute name="morerows">
            <xsl:value-of select="$rowend - $rownum"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$col/@colsep = 1">
          <xsl:attribute name="colsep">
            <xsl:value-of select="1"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@bgcolor) and $bgcolor != ''">
          <xsl:attribute name="bgcolor">
            <xsl:value-of select="$bgcolor"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@valign) and $valign != ''">
          <xsl:attribute name="valign">
            <xsl:value-of select="$valign"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@align) and $align != ''">
          <xsl:attribute name="align">
            <xsl:value-of select="$align"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:element name="output">
          <xsl:apply-templates select="." mode="output"/>
        </xsl:element>
      </entry>

      <xsl:choose>
      <xsl:when test="following-sibling::*[self::td or self::th]">

        <xsl:apply-templates
              select="following-sibling::*[self::td or self::th][1]"
              mode="htmlTable">
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="colnum" select="$colend + 1"/>
          <xsl:with-param name="entries" select="$entries"/>
        </xsl:apply-templates>

      </xsl:when>
      <xsl:when test="$colend &lt; $cols">
        <!-- Create more blank entries to pad the row -->
        <xsl:call-template name="tbl.blankentry">
          <xsl:with-param name="colnum" select="$colend + 1"/>
          <xsl:with-param name="colend" select="$cols"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="entries" select="$entries"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
        </xsl:call-template>

      </xsl:when>
      </xsl:choose>
    </xsl:otherwise></xsl:choose>
  </xsl:if>
</xsl:template>

<!-- Process the entry content, and remove spurious empty lines -->
<xsl:template match="td|th" mode="output">
  <xsl:call-template name="normalize-border">
    <xsl:with-param name="string">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="tr" mode="span">
  <xsl:param name="currow"/>
  <xsl:variable name="tr.pos" select="position()"/>
  <xsl:variable name="spantds" select="td[@rowspan][$tr.pos + @rowspan &gt; 
                                                    $currow]"/>
  <xsl:if test="$spantds">
    <span rownum="{$currow}" p="{$tr.pos}">
      <xsl:attribute name="value">
        <xsl:value-of
        select="sum($spantds/@colspan)+count($spantds[not(@colspan)])"/>
      </xsl:attribute>
    </span>
  </xsl:if>
</xsl:template>


<xsl:template name="widest-html-row">
  <xsl:param name="rows" select="''"/>
  <xsl:param name="count" select="0"/>
  <xsl:param name="currow" select="1"/>
  <xsl:variable name="row" select="$rows[position()=$currow]"/>
  <xsl:choose>
    <xsl:when test="not($row)">
      <xsl:value-of select="$count"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="count1" select="count($row/*[not(@colspan)])"/>
      <xsl:variable name="count2" select="sum($row/*/@colspan)"/>
      <xsl:variable name="countn" select="$count1 + $count2"/>

      <!-- retrieve the previous <td>s that contain a @rowspan
           that span over the current row -->
      <xsl:variable name="spantds">
        <xsl:apply-templates
             select="$rows[position() &lt; $currow]"
             mode="span">
          <xsl:with-param name="currow" select="$currow"/>
        </xsl:apply-templates>
      </xsl:variable>

      <!-- get the additional columns implied by the upward spanning <td> -->
      <xsl:variable name="addcols"
                    select="sum(exsl:node-set($spantds)/*/@value)"/>

      <!-- TIP: uncomment to debug the column count algorithm
      <foo> <xsl:copy-of select="$spantds"/> </foo>

      <xsl:message>
        <xsl:text>p=</xsl:text><xsl:value-of select="$currow"/>
        <xsl:text> c=</xsl:text><xsl:value-of select="$count"/>
        <xsl:text> s=</xsl:text><xsl:value-of select="$addcols"/>
      </xsl:message>
      -->

      <xsl:choose>
        <xsl:when test="$count &gt; ($countn + $addcols)">
          <xsl:call-template name="widest-html-row">
            <xsl:with-param name="rows" select="$rows"/>
            <xsl:with-param name="count" select="$count"/>
            <xsl:with-param name="currow" select="$currow + 1"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="widest-html-row">
            <xsl:with-param name="rows" select="$rows"/>
            <xsl:with-param name="count" select="$countn + $addcols"/>
            <xsl:with-param name="currow" select="$currow + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="build.colwidth">
  <xsl:param name="colspec"/>
  <xsl:param name="rows"/>

  <xsl:for-each select="$colspec/*">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="colentries"
                  select="$rows/row/entry[@colstart &lt;= $pos and
                                          @colend &gt;= $pos][@width]"/>

    <xsl:variable name="pct">
      <xsl:call-template name="max.percent">
        <xsl:with-param name="entries" select="$colentries"/>
        <xsl:with-param name="maxpct">
          <xsl:choose>
          <xsl:when test="substring(@width,string-length(@width))='%'">
            <xsl:value-of select="number(substring-before(@width, '%'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="fixed">
      <xsl:call-template name="max.value">
        <xsl:with-param name="entries" select="$colentries"/>
        <xsl:with-param name="maxval">
          <xsl:choose>
          <xsl:when test="string(number(@width))!='NaN'">
            <xsl:value-of select="number(@width)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="star">
      <xsl:choose>
      <xsl:when test="substring(@width,string-length(@width))='*'">
        <xsl:value-of select="number(substring-before(@width, '*'))"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- '0*' is allowed and meaningfull, so use a negative number to
             signify a missing star -->
        <xsl:value-of select="-1"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--
    <xsl:message>
      <xsl:value-of select="$pos"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="count($colentries)"/>
      <xsl:text> pct=</xsl:text><xsl:value-of select="$pct"/>
      <xsl:text> val=</xsl:text><xsl:value-of select="$fixed"/>
      <xsl:text> star=</xsl:text><xsl:value-of select="$star"/>
    </xsl:message>
    -->

    <xsl:copy>
      <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>

      <!-- Now, make precedences between the found width types -->
      <xsl:choose>
      <!-- the special form "0*" means to use the column's content width -->
      <xsl:when test="$star = 0">
        <xsl:attribute name="autowidth">1</xsl:attribute>
        <!-- set a star to reserve some default space for the column -->
        <xsl:attribute name="colwidth">
          <xsl:text>\newtblstarfactor</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="star">
          <xsl:value-of select="1"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$star &gt; 0">
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$star"/>
          <xsl:text>\newtblstarfactor</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="star">
          <xsl:value-of select="$star"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$pct &gt; 0">
        <xsl:variable name="width">
          <xsl:value-of select="$pct div 100"/>
          <xsl:text>\tablewidth</xsl:text>
        </xsl:variable>
        <xsl:attribute name="fixedwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$fixed &gt; 0">
        <!-- the width is expressed in 'px' bus is seen as 'pt' for tex -->
        <xsl:variable name="width">
          <xsl:value-of select="$fixed"/>
          <xsl:text>pt</xsl:text>
        </xsl:variable>
        <xsl:attribute name="fixedwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@width != ''">
          <xsl:message>
            <xsl:text>Warning: Unrecognized width attribute (</xsl:text>
            <xsl:value-of select="@width"/>
            <xsl:text>) in column of HTML table</xsl:text>
          </xsl:message>
        </xsl:if>
        <!-- no width specified: equivalent to a '*' -->
        <xsl:attribute name="colwidth">
          <xsl:text>\newtblstarfactor</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="star">1</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:for-each>
</xsl:template>


<!-- Find the maximum width expressed in percentage in column entries -->
<xsl:template name="max.percent">
  <xsl:param name="entries"/>
  <xsl:param name="maxpct" select="0"/>

  <xsl:choose>
  <xsl:when test="$entries">
    <xsl:variable name="width" select="$entries[1]/@width"/>

    <xsl:variable name="newpct">
      <xsl:choose>
      <xsl:when test="substring($width,string-length($width))='%'">
        <xsl:variable name="pct"
                      select="number(substring-before($width, '%'))"/>
        <xsl:choose>
        <xsl:when test="$pct &gt; $maxpct">
          <xsl:value-of select="$pct"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$maxpct"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$maxpct"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="max.percent">
      <xsl:with-param name="maxpct" select="$newpct"/>
      <xsl:with-param name="entries" select="$entries[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$maxpct"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Find the maximum width expressed in numbers in column entries -->
<xsl:template name="max.value">
  <xsl:param name="entries"/>
  <xsl:param name="maxval" select="0"/>

  <xsl:choose>
  <xsl:when test="$entries">
    <xsl:variable name="width" select="$entries[1]/@width"/>

    <xsl:variable name="newval">
      <xsl:choose>
      <xsl:when test="string(number($width))!='NaN'">
        <xsl:variable name="val" select="number($width)"/>
        <xsl:choose>
        <xsl:when test="$val &gt; $maxval">
          <xsl:value-of select="$val"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$maxval"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$maxval"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="max.value">
      <xsl:with-param name="maxval" select="$newval"/>
      <xsl:with-param name="entries" select="$entries[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$maxval"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Build empty default <colspec>s elements.
-->
<xsl:template name="make.colspec.default">
  <xsl:param name="colmax"/>
  <xsl:param name="colnum"/>

  <xsl:if test="$colnum &lt;= $colmax">
    <colspec>
      <xsl:attribute name="colnum">
        <xsl:value-of select="$colnum"/>
      </xsl:attribute>
      <xsl:call-template name="html.table.column.rules">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:call-template>
    </colspec>

    <xsl:call-template name="make.colspec.default">
      <xsl:with-param name="colnum" select="$colnum + 1"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<!-- Build the equivalent <colspec>s elements from <colgroup>s and <col>s
     and use default colspec for undefined <col>s in order to have a colspec
     per actual column.
-->

<xsl:template match="colgroup" mode="make.colspec">
  <xsl:param name="done" select="0"/>
  <xsl:param name="colnum"/>
  <xsl:param name="colmax"/>

  <xsl:choose>
  <xsl:when test="col">
    <!-- the spec are handled by <col>s -->
    <xsl:apply-templates select="col[1]" mode="make.colspec">
      <xsl:with-param name="colnum" select="$colnum"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>

    <xsl:variable name="span">
      <xsl:choose>
        <xsl:when test="@span">
          <xsl:value-of select="@span"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
    <xsl:when test="$done &lt; $span">
      <!-- bgcolor specified via a PI -->
      <xsl:variable name="bgcolor">
        <xsl:call-template name="pi.dblatex_bgcolor"/>
      </xsl:variable>

      <colspec>
        <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
        <xsl:attribute name="colnum">
          <xsl:value-of select="$colnum"/>
        </xsl:attribute>
        <xsl:if test="$bgcolor != ''">
          <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="html.table.column.rules">
          <xsl:with-param name="colnum" select="$colnum"/>
          <xsl:with-param name="colmax" select="$colmax"/>
        </xsl:call-template>
      </colspec>

      <xsl:apply-templates select="." mode="make.colspec">
        <xsl:with-param name="done" select="$done + 1"/>
        <xsl:with-param name="colnum" select="$colnum + 1"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="following-sibling::*[self::colgroup or self::col]">
      <xsl:apply-templates select="following-sibling::*[self::colgroup or
                                                        self::col][1]"
                           mode="make.colspec">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:apply-templates>
    </xsl:when>
    <!-- build empty default <colspec>s for missing columns -->
    <xsl:when test="$colnum &lt;= $colmax">
      <xsl:call-template name="make.colspec.default">
        <xsl:with-param name="colmax" select="$colmax"/>
        <xsl:with-param name="colnum" select="$colnum"/>
      </xsl:call-template>
    </xsl:when>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="col" mode="make.colspec">
  <xsl:param name="done" select="0"/>
  <xsl:param name="colnum"/>
  <xsl:param name="colmax"/>

  <!--
  <xsl:message>
    <xsl:text>p=</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="generate-id()"/>
    <xsl:text> r=</xsl:text>
    <xsl:value-of select="$colnum"/>
  </xsl:message>
  -->

  <xsl:variable name="span">
    <xsl:choose>
      <xsl:when test="@span">
        <xsl:value-of select="@span"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <!-- clone the same <colspec> span times -->
  <xsl:when test="$done &lt; $span">
    <!-- bgcolor specified via a PI or a colgroup parent PI -->
    <xsl:variable name="bgcolor.pi">
      <xsl:call-template name="pi.dblatex_bgcolor"/>
    </xsl:variable>
    <xsl:variable name="bgcolor">
      <xsl:choose>
      <xsl:when test="$bgcolor.pi != ''">
        <xsl:value-of select="$bgcolor.pi"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="pi.dblatex_bgcolor">
          <xsl:with-param name="node" select="parent::colgroup"/>
        </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <colspec>
      <xsl:for-each select="parent::colgroup/@*"><xsl:copy/></xsl:for-each>
      <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
      <xsl:attribute name="colnum">
        <xsl:value-of select="$colnum"/>
      </xsl:attribute>
      <xsl:if test="$bgcolor != ''">
        <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="html.table.column.rules">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:call-template>
    </colspec>

    <xsl:apply-templates select="." mode="make.colspec">
      <xsl:with-param name="done" select="$done + 1"/>
      <xsl:with-param name="colnum" select="$colnum + 1"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <!-- process the next following <col*> -->
  <xsl:when test="following-sibling::*[self::colgroup or self::col]">
    <xsl:apply-templates
        select="following-sibling::*[self::col or self::colgroup][1]"
        mode="make.colspec">
      <xsl:with-param name="colnum" select="$colnum"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <!-- if <col> is a <colgroup> child, process the next <col*> at the parent
       level -->
  <xsl:when test="parent::colgroup[following-sibling::*[self::colgroup or
                                                        self::col]]">
    <xsl:apply-templates select="parent::colgroup/
                                 following-sibling::*[self::col or
                                                      self::colgroup][1]"
                         mode="make.colspec">
      <xsl:with-param name="colnum" select="$colnum"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <!-- build empty default <colspec>s for missing columns -->
  <xsl:when test="$colnum &lt;= $colmax">
    <xsl:call-template name="make.colspec.default">
      <xsl:with-param name="colmax" select="$colmax"/>
      <xsl:with-param name="colnum" select="$colnum"/>
    </xsl:call-template>
  </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
