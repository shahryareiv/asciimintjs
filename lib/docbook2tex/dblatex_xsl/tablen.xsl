<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Upper table and informaltable templates. They make the wrapper environment
     depending of the kind of table (floating, landscape, role) and call the
     actual newtbl engine. The $newtbl.use parameter is now removed. -->

<xsl:param name="newtbl.format.thead">\bfseries%&#10;</xsl:param>
<xsl:param name="newtbl.format.tbody"/>
<xsl:param name="newtbl.format.tfoot"/>
<xsl:param name="newtbl.bgcolor.thead"/>
<xsl:param name="newtbl.default.colsep" select="'1'"/>
<xsl:param name="newtbl.default.rowsep" select="'1'"/>
<xsl:param name="newtbl.use.hhline" select="'0'"/>
<xsl:param name="newtbl.autowidth"/>
<xsl:param name="table.title.top" select="'0'"/>
<xsl:param name="table.in.float" select="'1'"/>
<xsl:param name="table.default.position" select="'[htbp]'"/>
<xsl:param name="table.default.tabstyle"/>
<xsl:param name="default.table.width"/>


<xsl:template match="table">
  <xsl:choose>
  <xsl:when test="$table.in.float='1'">
    <xsl:apply-templates select="." mode="float"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="." mode="longtable"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="." mode="foottext"/>
</xsl:template>

<!-- Switch to CALS or HTML templates -->
<xsl:template name="make.table.content">
  <xsl:param name="tabletype">tabular</xsl:param>
  <xsl:param name="tablewidth">\linewidth-2\tabcolsep</xsl:param>

  <xsl:choose>
    <xsl:when test="tgroup">
      <xsl:apply-templates select="tgroup" mode="newtbl">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="tablewidth" select="$tablewidth"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="htmlTable">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="tablewidth" select="$tablewidth"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="table" mode="float">
  <!-- do we need to change text size? -->
  <xsl:variable name="size">
    <xsl:choose>
    <xsl:when test="@role='small' or @role='footnotesize' or
                    @role='scriptsize' or @role='tiny'">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>normal</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- pgwide usefull in two column mode -->
  <xsl:variable name="table.env">
    <xsl:text>table</xsl:text>
    <xsl:if test="@pgwide='1'">
      <xsl:text>*</xsl:text>
    </xsl:if>
  </xsl:variable>
  <!-- in a float only tabular or tabularx allowed -->
  <xsl:variable name="tabletype">
    <xsl:choose>
    <xsl:when test="@tabstyle='tabular' or @tabstyle='tabularx'">
      <xsl:value-of select="@tabstyle"/>
    </xsl:when>
    <xsl:when test="$table.default.tabstyle='tabular' or
                    $table.default.tabstyle='tabularx'">
      <xsl:value-of select="$table.default.tabstyle"/>
    </xsl:when>
    <xsl:otherwise>tabular</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@orient='land'">
    <xsl:text>\begin{landscape}&#10;</xsl:text>
  </xsl:if>
  <xsl:value-of select="concat('\begin{', $table.env, '}')"/>
  <!-- table placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$table.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
  <!-- title caption before the table -->
  <xsl:if test="$table.title.top='1'">
    <xsl:apply-templates select="title|caption"/>
  </xsl:if>
  <xsl:if test="$size!='normal'">
    <xsl:text>\begin{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\begin{center}&#10;</xsl:text>

  <!-- do the actual work -->
  <xsl:call-template name="make.table.content">
    <xsl:with-param name="tabletype" select="$tabletype"/>
  </xsl:call-template>

  <xsl:text>&#10;\end{center}&#10;</xsl:text>
  <xsl:if test="$size!='normal'">
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$table.title.top='0'">
    <xsl:apply-templates select="title|caption"/>
  </xsl:if>
  <xsl:value-of select="concat('\end{', $table.env, '}&#10;')"/>
  <xsl:if test="@orient='land'">
    <xsl:text>\end{landscape}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="table/title|table/caption">
  <xsl:text>&#10;\caption</xsl:text>
  <xsl:apply-templates select="." mode="format.title"/>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="parent::table"/>
  </xsl:call-template>
</xsl:template>


<!-- Use the longtable features to have captions for formal tables -->
<xsl:template match="table" mode="longtable">
  <!-- do we need to change text size? -->
  <xsl:variable name="size">
    <xsl:choose>
    <xsl:when test="@role='small' or @role='footnotesize' or
                    @role='scriptsize' or @role='tiny'">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>normal</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="@orient='land'">
    <xsl:text>\begin{landscape}&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="$size!='normal'">
    <xsl:text>\begin{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\begin{center}&#10;</xsl:text>

  <!-- do the actual work -->
  <xsl:call-template name="make.table.content">
    <xsl:with-param name="tabletype" select="'longtable'"/>
  </xsl:call-template>

  <xsl:text>&#10;\end{center}&#10;</xsl:text>
  <xsl:if test="$size!='normal'">
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="@orient='land'">
    <xsl:text>\end{landscape}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="table/title|table/caption" mode="longtable">
  <xsl:variable name="toc">
    <xsl:apply-templates select="." mode="toc"/>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates select="." mode="content"/>
  </xsl:variable>
  <xsl:text>\caption</xsl:text>
  <!-- The title in the TOC -->
  <xsl:choose>
  <xsl:when test="$toc != ''">
    <xsl:value-of select="$toc"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>[{</xsl:text>
    <xsl:value-of select="$content"/>
    <xsl:text>}]</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$content"/>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="parent::table"/>
  </xsl:call-template>
  <xsl:text>}\tabularnewline&#10;</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="align.environment">
  <xsl:param name="align"/>
  <xsl:param name="align-default" select="'center'"/>

  <xsl:choose>
    <xsl:when test="$align = 'left'">
      <xsl:text>flushright</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'right'">
      <xsl:text>flushleft</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'center'">
      <xsl:text>center</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$align-default"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tbl.align.begin">
  <xsl:param name="tabletype"/>

  <!-- provision for user-specified alignment -->
  <xsl:variable name="align" select="'center'"/>

  <xsl:choose>
  <xsl:when test="$tabletype = 'longtable'">
    <xsl:choose>
    <xsl:when test="$align = 'left'">
      <xsl:text>\raggedright</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'right'">
      <xsl:text>\raggedleft</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'center'">
      <xsl:text>\centering</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'justify'"></xsl:when>
    <xsl:otherwise>
      <xsl:message>Word-wrapped alignment <xsl:value-of 
          select="$align"/> not supported</xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="alignenv">
      <xsl:call-template name="align.environment">
        <xsl:with-param name="align" select="$align"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('\begin{',$alignenv,'}')"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tbl.align.end">
  <xsl:param name="tabletype"/>

  <!-- provision for user-specified alignment -->
  <xsl:variable name="align" select="'center'"/>

  <xsl:if test="$tabletype != 'longtable'">
    <xsl:variable name="alignenv">
      <xsl:call-template name="align.environment">
        <xsl:with-param name="align" select="$align"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('\end{',$alignenv,'}')"/>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="informaltable">
  <!-- do we need to change text size? -->
  <xsl:variable name="size">
    <xsl:choose>
    <xsl:when test="@role='small' or @role='footnotesize' or
                    @role='scriptsize' or @role='tiny'">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>normal</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- are we a nested table? -->
  <xsl:variable name="nested" select="ancestor::entry|ancestor::td"/>

  <!-- longtables cannot be nested -->
  <xsl:variable name="tabletype">
    <xsl:choose>
    <xsl:when test="$nested">tabular</xsl:when>
    <xsl:when test="@tabstyle='tabular' or @tabstyle='tabularx'">
      <xsl:value-of select="@tabstyle"/>
    </xsl:when>
    <xsl:when test="$table.default.tabstyle='tabular' or
                    $table.default.tabstyle='tabularx'">
      <xsl:value-of select="$table.default.tabstyle"/>
    </xsl:when>
    <xsl:otherwise>longtable</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@orient='land'">
    <xsl:text>\begin{landscape}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$size!='normal'">
    <xsl:text>\begin{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:choose>
  <xsl:when test="not($nested)">
    <xsl:text>&#10;&#10;{</xsl:text>
    <!-- table alignment -->
    <xsl:call-template name="tbl.align.begin">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:call-template>
    <!-- do the actual work -->
    <xsl:if test="$tabletype='longtable'">
      <xsl:text>\savetablecounter </xsl:text>
    </xsl:if>

    <xsl:call-template name="make.table.content">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:call-template>

    <xsl:if test="$tabletype='longtable'">
      <xsl:text>\restoretablecounter%&#10;</xsl:text>
    </xsl:if>
    <xsl:call-template name="tbl.align.end">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="make.table.content">
      <xsl:with-param name="tabletype" select="$tabletype"/>
      <xsl:with-param name="tablewidth" select="'\linewidth'"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$size!='normal'">
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="@orient='land'">
    <xsl:text>\end{landscape}&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="." mode="foottext"/>
</xsl:template>

<!-- Hook for the newtbl to decide what to do after the table head,
     depending on the type of table used.
-->
<xsl:template match="informaltable" mode="newtbl.endhead">
  <xsl:param name="tabletype"/>
  <xsl:param name="headrows"/>
  <xsl:value-of select="$headrows"/>
  <xsl:if test="$tabletype='longtable' and $headrows!=''">
    <!-- longtable endhead to put only when there's an actual head -->
    <xsl:text>\endhead&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="table" mode="newtbl.endhead">
  <xsl:param name="tabletype"/>
  <xsl:param name="headrows"/>
  <xsl:choose>
  <xsl:when test="$tabletype='longtable'">
    <!-- longtable endhead -->
    <xsl:choose>
    <xsl:when test="$table.in.float='0'">
      <xsl:apply-templates select="title|caption" mode="longtable"/>
      <xsl:value-of select="$headrows"/>
      <xsl:text>\endfirsthead&#10;</xsl:text>
      <xsl:text>\caption[]</xsl:text>
      <xsl:text>{(continued)}\tabularnewline&#10;</xsl:text>
      <xsl:value-of select="$headrows"/>
      <xsl:text>\endhead&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$headrows!=''">
      <xsl:value-of select="$headrows"/>
      <xsl:text>\endhead&#10;</xsl:text>
    </xsl:when>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$headrows"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
