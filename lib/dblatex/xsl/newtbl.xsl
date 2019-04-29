<?xml version='1.0' encoding="utf-8" ?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="doc exsl" version='1.0'>
  
<!--==================== newtbl table handling ========================-->
<!--=                                                                 =-->
<!--= Copyright (C) 2004-2006 Vistair Systems Ltd (www.vistair.com)   =-->
<!--=                                                                 =-->
<!--= Released under the GNU General Public Licence (GPL)             =-->
<!--= (Commercial and other licences by arrangement)                  =-->
<!--=                                                                 =-->
<!--= Release 23/04/2006 by DCRH                                      =-->
<!--=                                                                 =-->
<!--= Email david@vistair.com with bugs, comments etc                 =-->
<!--=                                                                 =-->
<!--===================================================================-->

<!-- Step though each column, generating a colspec entry for it. If a  -->
<!-- colspec was given in the xml, then use it, otherwise generate a -->
<!-- default one -->
<xsl:template name="tbl.defcolspec">
  <xsl:param name="colnum" select="1"/>
  <xsl:param name="colspec"/>
  <xsl:param name="align"/>
  <xsl:param name="rowsep"/>
  <xsl:param name="colsep"/>
  <xsl:param name="cols"/>
  <xsl:param name="autowidth"/>
  
  <xsl:if test="$colnum &lt;= $cols">
    <xsl:choose>
      <xsl:when test="$colspec/colspec[@colnum = $colnum]">
        <xsl:copy-of select="$colspec/colspec[@colnum = $colnum]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="natwidth">
          <xsl:call-template name="natural-width">
            <xsl:with-param name="autowidth" select="$autowidth"/>
            <xsl:with-param name="colnum" select="$colnum"/>
          </xsl:call-template>
        </xsl:variable>
 
        <colspec colnum='{$colnum}' align='{$align}' star='1'
                 rowsep='{$rowsep}' colsep='{$colsep}' 
                 colwidth='\newtblstarfactor'>
          <xsl:if test="$natwidth = 1">
            <xsl:attribute name="autowidth">1</xsl:attribute>
          </xsl:if>
        </colspec>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="tbl.defcolspec">
      <xsl:with-param name="colnum" select="$colnum + 1"/>
      <xsl:with-param name="align" select="$align"/>
      <xsl:with-param name="rowsep" select="$rowsep"/>
      <xsl:with-param name="colsep" select="$colsep"/>
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="autowidth" select="$autowidth"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>



<!-- replace-string function as XSLT doesn't have one built in. -->
<xsl:template name="replace-string">
  <xsl:param name="text"/>
  <xsl:param name="replace"/>
  <xsl:param name="with"/>
  <xsl:choose>
    <xsl:when test="contains($text,$replace)">
      <xsl:value-of select="substring-before($text,$replace)"/>
      <xsl:value-of select="$with"/>
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text"
                        select="substring-after($text,$replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This template extracts the fixed part of a colwidth specification.
     It should be able to do this:
     a+b+c+d*+e+f -> a+b+c+e+f
     a+b+c+d*     -> a+b+c
     d*+e+f       -> e+f      
-->
<xsl:template name="colfixed.get">
  <xsl:param name="width" select="@colwidth"/>
  <xsl:param name="stared" select="'0'"/>
  
  <xsl:choose>
    <xsl:when test="contains($width, '*')">
      <xsl:variable name="after"
                    select="substring-after(substring-after($width, '*'), '+')"/>
      <xsl:if test="contains(substring-before($width, '*'), '+')">
        <xsl:call-template name="colfixed.get">
          <xsl:with-param name="width" select="substring-before($width, '*')"/>
          <xsl:with-param name="stared" select="'1'"/>
        </xsl:call-template>
        <xsl:if test="$after!=''">
          <xsl:text>+</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="$after"/>
    </xsl:when>
    <xsl:when test="$stared='1'">
      <xsl:value-of select="substring-before($width, '+')"/>
      <xsl:if test="contains(substring-after($width, '+'), '+')">
        <xsl:text>+</xsl:text>
        <xsl:call-template name="colfixed.get">
          <xsl:with-param name="width" select="substring-after($width, '+')"/>
          <xsl:with-param name="stared" select="'1'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$width"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="colstar.get">
  <xsl:param name="width"/>
  <xsl:choose>
    <xsl:when test="contains($width, '+')">
      <xsl:call-template name="colstar.get">
        <xsl:with-param name="width" select="substring-after($width, '+')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="string(number($width))='NaN'">1</xsl:when>
        <xsl:otherwise>
          <!-- Use number() to ensure to have something well formatted -->
          <xsl:value-of select="number($width)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Evaluate from the autowidth statement if the current column width
     is its natural size determined by the column cells contents -->
<xsl:template name="natural-width">
  <xsl:param name="autowidth"/>
  <xsl:param name="colnum" select="1"/>

  <xsl:choose>
  <xsl:when test="not(string(@colwidth)) and 
                  (contains($autowidth,'default') or
                   contains($autowidth,'all'))">1</xsl:when>
  <xsl:when test="contains(@colwidth,'*') and
                  contains($autowidth,'all')">1</xsl:when>
  <xsl:when test="contains(concat($autowidth,' '),concat(' ',$colnum,' ')) and
                  contains($autowidth,'column')">1</xsl:when>
  <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Ensure each column has a colspec and each colspec has a valid column -->
<!-- number, width, alignment, colsep, rowsep -->
<xsl:template match="colspec" mode="newtbl">
  <xsl:param name="colnum" select="1"/>
  <xsl:param name="align"/>
  <xsl:param name="colsep"/>
  <xsl:param name="rowsep"/>
  <xsl:param name="autowidth"/>

  <xsl:variable name="natwidth">
    <xsl:call-template name="natural-width">
      <xsl:with-param name="autowidth" select="$autowidth"/>
      <xsl:with-param name="colnum">
         <xsl:choose><xsl:when test="@colnum">
           <xsl:value-of select="@colnum"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="$colnum"/>
         </xsl:otherwise></xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:copy>
    <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
    <xsl:if test="$natwidth = 1">
      <xsl:attribute name="autowidth">1</xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@colnum)">
      <xsl:attribute name="colnum"><xsl:value-of select="$colnum"/>
      </xsl:attribute>
    </xsl:if>
    <!-- Find out if the column width contains fixed width -->
    <xsl:variable name="fixed">
      <xsl:call-template name="colfixed.get"/>
    </xsl:variable>
    
    <xsl:if test="$fixed!=''">
      <xsl:attribute name="fixedwidth">
        <xsl:value-of select="$fixed"/>
      </xsl:attribute>
    </xsl:if>
    <!-- Replace '*' with our to-be-computed factor -->
    <xsl:if test="contains(@colwidth,'*')">
      <xsl:attribute name="colwidth">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="@colwidth"/>
          <xsl:with-param name="replace">*</xsl:with-param>
          <xsl:with-param name="with">\newtblstarfactor</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="star">
        <xsl:call-template name="colstar.get">
          <xsl:with-param name="width" select="substring-before(@colwidth, '*')"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <!-- No colwidth specified? Assume '*' -->
    <xsl:if test="not(string(@colwidth))">
      <xsl:attribute name="colwidth">\newtblstarfactor</xsl:attribute>
      <xsl:attribute name="star">1</xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@align)">
      <xsl:attribute name="align"><xsl:value-of select="$align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@rowsep)">
      <xsl:attribute name="rowsep"><xsl:value-of select="$rowsep"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@colsep)">
      <xsl:attribute name="colsep"><xsl:value-of select="$colsep"/>
      </xsl:attribute>
    </xsl:if>
    <!-- bgcolor specified via a PI -->
    <xsl:variable name="bgcolor">
      <xsl:call-template name="pi.dblatex_bgcolor"/>
    </xsl:variable>
    <xsl:if test="$bgcolor != ''">
      <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/>
      </xsl:attribute>
    </xsl:if>

  </xsl:copy>
  
  <xsl:variable name="nextcolnum">
    <xsl:choose>
      <xsl:when test="@colnum"><xsl:value-of select="@colnum + 1"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$colnum + 1"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:apply-templates mode="newtbl"
                       select="following-sibling::colspec[1]">
    <xsl:with-param name="colnum" select="$nextcolnum"/>
    <xsl:with-param name="align" select="$align"/>
    <xsl:with-param name="colsep" select="$colsep"/>
    <xsl:with-param name="rowsep" select="$rowsep"/>
    <xsl:with-param name="autowidth" select="$autowidth"/>
  </xsl:apply-templates>
</xsl:template>



<!-- Generate a complete set of colspecs for each column in the table -->
<xsl:template name="tbl.colspec">
  <xsl:param name="autowidth"/>
  <xsl:param name="align"/>
  <xsl:param name="rowsep"/>
  <xsl:param name="colsep"/>
  <xsl:param name="cols"/>
  
  <!-- First, get the colspecs that have been specified -->
  <xsl:variable name="givencolspec">
    <xsl:apply-templates mode="newtbl" select="colspec[1]">
      <xsl:with-param name="align" select="$align"/>
      <xsl:with-param name="rowsep" select="$rowsep"/>
      <xsl:with-param name="colsep" select="$colsep"/>
      <xsl:with-param name="autowidth" select="$autowidth"/>
    </xsl:apply-templates>
  </xsl:variable>
  
  <!-- Now generate colspecs for each missing column -->
  <xsl:call-template name="tbl.defcolspec">
    <xsl:with-param name="colspec" select="exsl:node-set($givencolspec)"/>
    <xsl:with-param name="cols" select="$cols"/>
    <xsl:with-param name="align" select="$align"/>
    <xsl:with-param name="rowsep" select="$rowsep"/>
    <xsl:with-param name="colsep" select="$colsep"/>
    <xsl:with-param name="autowidth" select="$autowidth"/>
  </xsl:call-template>
</xsl:template>



<!-- Create a blank entry element. We check the 'entries' node-set -->
<!-- to see if we should copy an entry from the row above instead -->
<xsl:template name="tbl.blankentry">
  <xsl:param name="colnum"/>
  <xsl:param name="colend"/>
  <xsl:param name="rownum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="entries"/>
  <xsl:param name="rowcolor"/>
  
  <xsl:if test="$colnum &lt;= $colend">
    <xsl:variable name="entry"
                  select="$entries/*[self::entry or self::entrytbl]
                                    [@colstart=$colnum and @rowend &gt;= $rownum]"/>
    <xsl:choose>
      <xsl:when test="$entry">
        <!-- Just copy this entry then -->
        <xsl:copy-of select="$entry"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="bgcolor">
          <xsl:choose>
          <xsl:when test="$rowcolor != ''">
            <xsl:value-of select="$rowcolor"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$colspec/colspec[@colnum=$colnum]/@bgcolor"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- No rowspan entry found from the row above, so create a blank -->
        <entry colstart='{$colnum}' colend='{$colnum}' 
               rowstart='{$rownum}' rowend='{$rownum}'
               colsep='{$colspec/colspec[@colnum=$colnum]/@colsep}'
               defrowsep='{$colspec/colspec[@colnum=$colnum]/@rowsep}'
               align='{$colspec/colspec[@colnum=$colnum]/@align}'
               bgcolor='{$bgcolor}'/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nextcol">
      <xsl:choose>
        <xsl:when test="$entry">
          <xsl:value-of select="$entry/@colend"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$colnum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="tbl.blankentry">
      <xsl:with-param name="colnum" select="$nextcol + 1"/>
      <xsl:with-param name="colend" select="$colend"/>
      <xsl:with-param name="rownum" select="$rownum"/>
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="rowcolor" select="$rowcolor"/>
      <xsl:with-param name="entries" select="$entries"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- Check the entry column range is valid -->
<xsl:template name="check-colrange">
  <xsl:param name="colnum"/>
  <xsl:param name="rownum"/>
  <xsl:param name="colend"/>
  <xsl:param name="colstart"/>

  <xsl:variable name="msg">
    <xsl:text>Invalid table entry row=</xsl:text>
    <xsl:value-of select="$rownum"/>
    <xsl:text>/column=</xsl:text>
    <xsl:value-of select="$colnum"/>
  </xsl:variable>
  <xsl:if test="string(number($colend))='NaN'">
    <xsl:message terminate="yes">
      <xsl:value-of select="$msg"/>
      <xsl:text> (@colend)</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="string(number($colstart))='NaN'">
    <xsl:message terminate="yes">
      <xsl:value-of select="$msg"/>
      <xsl:text> (@colstart)</xsl:text>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!-- Returns a RTF of entry elements. rowsep, colsep and align are all -->
<!-- extracted from spanspec/colspec as required -->
<!-- Skipped columns have blank entry elements created -->
<!-- Existing entry elements in the given entries node-set are checked to -->
<!-- see if they should extend into this row and are copied if so -->
<!-- Each element is given additional attributes: -->
<!-- rowstart = The top row number of the table this entry -->
<!-- rowend = The bottom row number of the table this entry -->
<!-- colstart = The starting column number of this entry -->
<!-- colend = The ending column number of this entry -->
<!-- defrowsep = The default rowsep value inherited from the entry's span -->
<!--     or colspec -->
<xsl:template match="entry|entrytbl" mode="newtbl.buildentries">
  <xsl:param name="colnum"/>
  <xsl:param name="rownum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="spanspec"/>
  <xsl:param name="frame"/>
  <xsl:param name="rowcolor"/>
  <xsl:param name="entries"/>
  <xsl:param name="tabletype"/>

  <xsl:variable name="cols" select="count($colspec/*)"/>
 
  <xsl:if test="$colnum &lt;= $cols">

    <xsl:variable name="entry"
        select="$entries/*[self::entry or self::entrytbl]
                                [@colstart=$colnum and @rowend &gt;= $rownum]"/>
    <!-- Do we have an existing entry element from a previous row that -->
    <!-- should be copied into this row? -->
    <xsl:choose><xsl:when test="$entry">
      <!-- Just copy this entry then -->
      <xsl:copy-of select="$entry"/>

      <!-- Process the next column using this current entry -->
      <xsl:apply-templates mode="newtbl.buildentries" select=".">
        <xsl:with-param name="colnum" 
                        select="$entries/entry[@colstart=$colnum]/@colend + 1"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="rowcolor" select="$rowcolor"/>
        <xsl:with-param name="entries" select="$entries"/>
        <xsl:with-param name="tabletype" select="$tabletype"/>
      </xsl:apply-templates>
      </xsl:when><xsl:otherwise>
      <!-- Get any span for this entry -->
      <xsl:variable name="span">
        <xsl:if test="@spanname and $spanspec[@spanname=current()/@spanname]">
          <xsl:copy-of select="$spanspec[@spanname=current()/@spanname]"/>
        </xsl:if>
      </xsl:variable>
      
      <!-- Get the starting column number for this cell -->
      <xsl:variable name="colstart">
        <xsl:choose>
          <!-- Check colname first -->
          <xsl:when test="$colspec/colspec[@colname=current()/@colname]">
            <xsl:value-of
                select="$colspec/colspec[@colname=current()/@colname]/@colnum"/>
          </xsl:when>
          <!-- Now check span -->
          <xsl:when test="exsl:node-set($span)/spanspec/@namest">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  exsl:node-set($span)/spanspec/@namest]/@colnum"/>
          </xsl:when>
          <!-- Now check namest attribute -->
          <xsl:when test="@namest">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  current()/@namest]/@colnum"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$colnum"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Get the ending column number for this cell -->
      <xsl:variable name="colend">
        <xsl:choose>
          <!-- Check span -->
          <xsl:when test="exsl:node-set($span)/spanspec/@nameend">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  exsl:node-set($span)/spanspec/@nameend]/@colnum"/>
          </xsl:when>
          <!-- Check nameend attribute -->
          <xsl:when test="@nameend">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  current()/@nameend]/@colnum"/>
          </xsl:when>
          <!-- Otherwise end == start -->
          <xsl:otherwise>
            <xsl:value-of select="$colstart"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Check column consistency -->
      <xsl:call-template name="check-colrange">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colstart" select="$colstart"/>
        <xsl:with-param name="colend" select="$colend"/>
      </xsl:call-template>

      <!-- No offset between column and cell content for entrytbl -->
      <xsl:variable name="coloff">
        <xsl:choose>
          <xsl:when test="self::entrytbl">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Does this entry want to start at a later column? -->
      <xsl:if test="$colnum &lt; $colstart">
        <!-- If so, create some blank entries to fill in the gap -->
        <xsl:call-template name="tbl.blankentry">
          <xsl:with-param name="colnum" select="$colnum"/>
          <xsl:with-param name="colend" select="$colstart - 1"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
          <xsl:with-param name="entries" select="$entries"/>
        </xsl:call-template>
      </xsl:if>
      
      <!-- Get the colsep override from this entry or its span -->
      <xsl:variable name="colsep">
        <xsl:choose>
          <!-- Entry element override -->
          <xsl:when test="@colsep"><xsl:value-of select="@colsep"/></xsl:when>
          <!-- Then any span present -->
          <xsl:when test="exsl:node-set($span)/spanspec/@colsep">
            <xsl:value-of select="exsl:node-set($span)/spanspec/@colsep"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise take from colspec -->
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@colsep"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Get the default rowsep for this entry -->
      <xsl:variable name="defrowsep">
        <xsl:choose>
          <!-- Check any span present -->
          <xsl:when test="exsl:node-set($span)/spanspec/@rowsep">
            <xsl:value-of select="exsl:node-set($span)/spanspec/@rowsep"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise take from colspec -->
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@rowsep"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Generate cell alignment -->
      <xsl:variable name="align">
        <xsl:choose>
          <!-- Entry element attribute first -->
          <xsl:when test="string(@align)">
            <xsl:value-of select="@align"/>
          </xsl:when>
          <!-- Then any span present -->
          <xsl:when test="exsl:node-set($span)/spanspec/@align">
            <xsl:value-of select="exsl:node-set($span)/spanspec/@align"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise take from colspec -->
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@align"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Vertical cell alignment -->
      <xsl:variable name="valign">
        <xsl:choose>
          <!-- Entry element attribute first -->
          <xsl:when test="string(@valign)">
            <xsl:value-of select="@valign"/>
          </xsl:when>
          <!-- Then parent row -->
          <xsl:when test="../@valign">
            <xsl:value-of select="../@valign"/>
          </xsl:when>
          <!-- Then parent tbody|thead -->
          <xsl:when test="../../@valign">
            <xsl:value-of select="../../@valign"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="cellcolor">
        <xsl:call-template name="pi.dblatex_bgcolor"/>
      </xsl:variable>

      <xsl:variable name="bgcolor">
        <xsl:choose>
          <xsl:when test="$cellcolor != ''">
            <xsl:value-of select="$cellcolor"/>
          </xsl:when>
          <xsl:when test="$rowcolor != ''">
            <xsl:value-of select="$rowcolor"/>
          </xsl:when>
          <xsl:when test="$colspec/colspec[@colnum=$colstart]/@bgcolor">
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@bgcolor"/>
          </xsl:when>
          <xsl:when test="ancestor::*[self::table or self::informaltable]/@bgcolor">
            <xsl:value-of select="ancestor::*[self::table or
                                              self::informaltable]/@bgcolor"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:copy>
        <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
        <xsl:attribute name="colstart">
          <xsl:value-of select="$colstart"/>
        </xsl:attribute>
        <xsl:attribute name="colend">
          <xsl:value-of select="$colend"/>
        </xsl:attribute>
        <xsl:attribute name="coloff">
          <xsl:value-of select="$coloff"/>
        </xsl:attribute>
        <xsl:attribute name="rowstart">
          <xsl:value-of select="$rownum"/>
        </xsl:attribute>
        <xsl:attribute name="rowend">
          <xsl:choose>
            <xsl:when test="@morerows and @morerows > 0">
              <xsl:value-of select="@morerows + $rownum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$rownum"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="colsep">
          <xsl:value-of select="$colsep"/>
        </xsl:attribute>
        <xsl:attribute name="defrowsep">
          <xsl:value-of select="$defrowsep"/>
        </xsl:attribute>
        <xsl:attribute name="align">
          <xsl:value-of select="$align"/>
        </xsl:attribute>
        <xsl:attribute name="valign">
          <xsl:value-of select="$valign"/>
        </xsl:attribute>
        <xsl:if test="$bgcolor != ''">
          <xsl:attribute name="bgcolor">
            <xsl:value-of select="$bgcolor"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="tabletype">
          <xsl:value-of select="$tabletype"/>
        </xsl:attribute>
        <!-- Process the output here, to stay in the document context. -->
        <!-- In RTF entries the document links/refs are lost -->
        <xsl:element name="output">
          <xsl:apply-templates select="." mode="output"/>
        </xsl:element>
      </xsl:copy>
      
      <!-- See if we've run out of entries for the current row -->
      <xsl:if test="$colend &lt; $cols and
                    not(following-sibling::*[self::entry or self::entrytbl][1])">
        <!-- Create more blank entries to pad the row -->
        <xsl:call-template name="tbl.blankentry">
          <xsl:with-param name="colnum" select="$colend + 1"/>
          <xsl:with-param name="colend" select="$cols"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
          <xsl:with-param name="entries" select="$entries"/>
          <xsl:with-param name="tabletype" select="$tabletype"/>
        </xsl:call-template>
      </xsl:if>
      
      <xsl:apply-templates mode="newtbl.buildentries" 
               select="following-sibling::*[self::entry or self::entrytbl][1]">
        <xsl:with-param name="colnum" select="$colend + 1"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="rowcolor" select="$rowcolor"/>
        <xsl:with-param name="entries" select="$entries"/>
        <xsl:with-param name="tabletype" select="$tabletype"/>
      </xsl:apply-templates>
    </xsl:otherwise></xsl:choose>
  </xsl:if>  <!-- $colnum <= $cols -->
</xsl:template>



<!-- Output the current entry node -->
<xsl:template match="entry|entrytbl" mode="newtbl">
  <xsl:param name="colspec"/>
  <xsl:param name="context"/>
  <xsl:param name="frame"/>
  <xsl:param name="rownum"/>
  
  <xsl:variable name="cols" select="count($colspec/*)"/>
  <!--
      <xsl:if test="@colstart &gt; $cols">
      <xsl:message>BANG</xsl:message>
      </xsl:if>
  -->
  <xsl:if test="@colstart &lt;= $cols">
    
    <!-- Should this column be sized by latex? -->
    <xsl:variable name="autowidth"
                  select="$colspec/colspec[@colnum=current()/@colstart]/@autowidth"/>

    <xsl:variable name="moreprint"
                  select="not($autowidth and (@rowstart != $rownum))"/>

    <!-- Generate the column spec for this column -->
    <xsl:text>\multicolumn{</xsl:text>
    <xsl:value-of select="@colend - @colstart + 1"/>
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates select="." mode="tbl.colfmt">
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="frame" select="$frame"/>
      <xsl:with-param name="autowidth" select="$autowidth"/>
    </xsl:apply-templates>
    <xsl:text>}{</xsl:text>
    
    <!-- Put everything inside a multirow if required -->
    <xsl:if test="@morerows and @morerows > 0 and $moreprint">
      <!-- Multirow doesn't use setlength and hence our calc stuff doesn't -->
      <!-- work. Do it manually then -->
      <xsl:if test="not($autowidth)">
        <xsl:text>\setlength{\newtblcolwidth}{</xsl:text>
        <!-- Put the column width here for line wrapping -->
        <xsl:call-template name="tbl.colwidth">
          <xsl:with-param name="col" select="@colstart"/>
          <xsl:with-param name="colend" select="@colend"/>
          <xsl:with-param name="colspec" select="$colspec"/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:text>\multirowii</xsl:text>
      
      <!-- Vertical alignment done by custom multirow -->
      <xsl:if test="@valign and @valign!=''">
        <xsl:choose>
        <xsl:when test="@valign = 'top'"><xsl:text>[p]</xsl:text></xsl:when>
        <xsl:when test="@valign = 'bottom'"><xsl:text>[b]</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>[m]</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      
      <xsl:text>{</xsl:text>
      <xsl:value-of select="@morerows + 1"/>
      <xsl:choose>
        <xsl:when test="not($autowidth)">
          <xsl:text>}{</xsl:text>
          <!-- Only output the contents of this row if it's on the correct -->
          <!-- row -ve width means don't output the cell contents, but maybe -->
          <!-- just output a height spacer. -->
          <xsl:if test="@rowstart != $rownum">
            <xsl:text>-</xsl:text>
          </xsl:if>
          <xsl:text>\newtblcolwidth}{</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>}{*}{</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    
    <!-- Do rotate if required. What to do about line wrapping though?? -->
    <xsl:if test="@rotate and @rotate != 0">
      <xsl:text>\rotatebox{90}{</xsl:text>
    </xsl:if>
    
    <xsl:if test="not($autowidth)">  
      <xsl:choose>
        <xsl:when test="@align = 'left'">
          <xsl:text>\raggedright</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'right'">
          <xsl:text>\raggedleft</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'center'">
          <xsl:text>\centering</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'justify'"></xsl:when>
        <xsl:when test="@align != ''">
          <xsl:message>Word-wrapped alignment <xsl:value-of 
          select="@align"/> not supported</xsl:message>
        </xsl:when>
      </xsl:choose>
    </xsl:if>  
    
    <!-- Apply some default formatting depending on context -->
    <xsl:choose>
      <xsl:when test="$context = 'thead'">
        <xsl:value-of select="$newtbl.format.thead"/>
      </xsl:when>
      <xsl:when test="$context = 'tbody'">
        <xsl:value-of select="$newtbl.format.tbody"/>
      </xsl:when>
      <xsl:when test="$context = 'tfoot'">
        <xsl:value-of select="$newtbl.format.tfoot"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Unknown context <xsl:value-of select="$context"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- Dump out the entry contents -->
    <xsl:if test="$moreprint">
      <xsl:text>%&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="output">
          <xsl:value-of select="output"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="output"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>%&#10;</xsl:text>
    </xsl:if>
    
    <!-- Close off multirow if required -->
    <xsl:if test="@morerows and @morerows > 0 and $moreprint">
      <xsl:text>}</xsl:text>
    </xsl:if>
    
    <!-- Close off rotate if required -->
    <xsl:if test="@rotate and @rotate != 0">
      <xsl:text>}</xsl:text>
    </xsl:if>
    
    <!-- End of the multicolumn -->
    <xsl:text>}</xsl:text>
    
    <!-- Put in the column separator -->
    <xsl:if test="@colend != $cols">
      <xsl:text>&amp;</xsl:text>
    </xsl:if>
    
  </xsl:if> <!-- colstart > cols -->
  
</xsl:template>


<!-- Process the entry content, and remove spurious empty lines -->
<xsl:template match="entry" mode="output">
  <xsl:call-template name="normalize-border">
    <xsl:with-param name="string">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- Actually build the embedded table like tgroup does -->
<xsl:template match="entrytbl" mode="output">
  <xsl:call-template name="tgroup">
    <xsl:with-param name="tablewidth" select="'\linewidth-2\arrayrulewidth'"/>
    <xsl:with-param name="tableframe" select="'none'"/>
  </xsl:call-template>
</xsl:template>


<!-- Rowsep building using \cline - done within a row -->
<xsl:template name="clines.build">
  <xsl:param name="entries"/>
  <xsl:param name="rownum"/>

  <!-- Store any rowsep for this row -->
  <xsl:variable name="thisrowsep" select="@rowsep"/>

  <xsl:for-each select="$entries/*">
    <!-- Only do rowsep for this col if it's not spanning this row -->
    <xsl:if test="@rowend = $rownum">
      <xsl:variable name="dorowsep">
        <xsl:choose>
          <!-- Entry rowsep override -->
          <xsl:when test="@rowsep">
            <xsl:value-of select="@rowsep"/>
          </xsl:when>
          <!-- Row rowsep override -->
          <xsl:when test="$thisrowsep">
            <xsl:value-of select="$thisrowsep"/>
          </xsl:when>
          <!-- Else use the default for this column -->
          <xsl:otherwise>
            <xsl:value-of select="@defrowsep"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$dorowsep = 1">
        <xsl:text>\cline{</xsl:text>
        <xsl:value-of select="@colstart"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@colend"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- Rowsep building using \hhline - done within a row -->
<xsl:template name="hhline.build">
  <xsl:param name="entries"/>
  <xsl:param name="rownum"/>

  <!-- Store any rowsep for this row -->
  <xsl:variable name="thisrowsep" select="@rowsep"/>

  <xsl:text>\hhline{</xsl:text>
  <xsl:for-each select="$entries/*">
    <xsl:variable name="dorowsep">
      <xsl:choose>
        <!-- Only do rowsep for this col if it's not spanning this row -->
        <xsl:when test="@rowend != $rownum">
          <xsl:value-of select="0"/>
        </xsl:when>
        <!-- Entry rowsep override -->
        <xsl:when test="@rowsep">
          <xsl:value-of select="@rowsep"/>
        </xsl:when>
        <!-- Row rowsep override -->
        <xsl:when test="$thisrowsep">
          <xsl:value-of select="$thisrowsep"/>
        </xsl:when>
        <!-- Else use the default for this column -->
        <xsl:otherwise>
          <xsl:value-of select="@defrowsep"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- hhline separator value -->
    <xsl:variable name="hsep">
      <xsl:choose>
        <xsl:when test="$dorowsep = 1">-</xsl:when>
        <xsl:otherwise>~</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@colstart = @colend">
        <xsl:value-of select="$hsep"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*{</xsl:text>
        <xsl:value-of select="@colend - @colstart + 1"/>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select="$hsep"/>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>}</xsl:text>
</xsl:template>


<!-- Process each row in turn -->
<xsl:template match="row" mode="newtbl">
  <xsl:param name="tabletype"/>
  <xsl:param name="rownum"/>
  <xsl:param name="rows"/>
  <xsl:param name="colspec"/>
  <xsl:param name="spanspec"/>
  <xsl:param name="frame"/>
  <xsl:param name="oldentries"><nop/></xsl:param>
  <xsl:param name="rowstack"/>

  <xsl:variable name="bgcolor.pi">
    <xsl:call-template name="pi.dblatex_bgcolor"/>
  </xsl:variable>

  <xsl:variable name="rowcolor">
    <xsl:choose>
      <xsl:when test="$bgcolor.pi!=''">
        <xsl:value-of select="$bgcolor.pi"/>
      </xsl:when>
      <xsl:when test="ancestor::thead">
        <xsl:value-of select="$newtbl.bgcolor.thead"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

   <!-- Build the entry node-set -->
  <xsl:variable name="entries">
    <xsl:choose>
      <xsl:when test="(entry|entrytbl)[1]">
        <xsl:apply-templates mode="newtbl.buildentries" select="(entry|entrytbl)[1]">
          <xsl:with-param name="colnum" select="1"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="spanspec" select="$spanspec"/>
          <xsl:with-param name="frame" select="$frame"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
          <xsl:with-param name="entries" select="exsl:node-set($oldentries)"/>
          <xsl:with-param name="tabletype" select="$tabletype"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="exsl:node-set($oldentries)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Now output each entry -->
  <xsl:variable name="context" select="local-name(..)"/>
  <xsl:variable name="row-output">
    <xsl:if test="$context = 'thead'">
      <xsl:value-of select="$rowstack"/>
    </xsl:if>

    <xsl:if test="$rownum = 1">
      <!-- Need a top line? -->
      <xsl:if test="$frame = 'all' or $frame = 'top' or $frame = 'topbot'">
        <xsl:text>\hline</xsl:text>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="exsl:node-set($entries)/*" mode="newtbl">
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="frame" select="$frame"/>
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="rownum" select="$rownum"/>
    </xsl:apply-templates>
    
    <!-- End this row -->
    <xsl:text>\tabularnewline&#10;</xsl:text>
    
    <!-- Now process rowseps only if not the last row -->
    <xsl:if test="$rownum != $rows">
      <xsl:choose>
      <xsl:when test="$newtbl.use.hhline='1'">
        <xsl:call-template name="hhline.build">
          <xsl:with-param name="entries" select="exsl:node-set($entries)"/>
          <xsl:with-param name="rownum" select="$rownum"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="clines.build">
          <xsl:with-param name="entries" select="exsl:node-set($entries)"/>
          <xsl:with-param name="rownum" select="$rownum"/>
        </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <!-- Head rows must be buffered -->
  <xsl:if test="$context != 'thead'">
    <xsl:value-of select="$row-output"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="following-sibling::row[1]">
      <xsl:apply-templates mode="newtbl" select="following-sibling::row[1]">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="rownum" select="$rownum + 1"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="oldentries" select="$entries"/>
        <xsl:with-param name="rowstack" select="$row-output"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$context = 'tfoot'">
    </xsl:when>
    <xsl:otherwise>
      <!-- Ask to table to end the head -->
      <xsl:if test="$context = 'thead'">
        <xsl:apply-templates select="(ancestor::table
                                     |ancestor::informaltable)[last()]"
                             mode="newtbl.endhead">
          <xsl:with-param name="tabletype" select="$tabletype"/>
          <xsl:with-param name="headrows" select="$row-output"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:apply-templates mode="newtbl" 
                           select="(../following-sibling::tbody/row)[1]">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="rownum" select="$rownum + 1"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="oldentries" select="$entries"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Calculate column width between two columns -->
<xsl:template name="tbl.colwidth">
  <xsl:param name="col"/>
  <xsl:param name="colend"/>
  <xsl:param name="colspec"/>
  
  <xsl:value-of select="$colspec/colspec[@colnum=$col]/@colwidth"/>
  
  <xsl:if test="$col &lt; $colend">
    <xsl:text>+2\tabcolsep+\arrayrulewidth+</xsl:text>
    <xsl:call-template name="tbl.colwidth">
      <xsl:with-param name="col" select="$col + 1"/>
      <xsl:with-param name="colend" select="$colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="tbl.colwidth2">
  <xsl:param name="col"/>
  <xsl:param name="colend"/>
  <xsl:param name="colspec"/>
  
  <xsl:value-of select="$colspec/colspec[@colnum=$col]/@fixedwidth"/>
  
  <xsl:if test="$col &lt; $colend">
    <xsl:text>+</xsl:text>
    <xsl:call-template name="tbl.colwidth2">
      <xsl:with-param name="col" select="$col + 1"/>
      <xsl:with-param name="colend" select="$colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="entry|entrytbl" mode="width.colfmt">
  <xsl:param name="colspec"/>
  <xsl:param name="color"/>
  <xsl:param name="rsep"/>

  <!-- Color in pre-command -->
  <xsl:if test="$color != ''">
    <xsl:value-of select="concat('>{',$color,'}')"/>
  </xsl:if>

  <!-- Get the column width -->
  <xsl:variable name="width">
    <xsl:call-template name="tbl.colwidth">
      <xsl:with-param name="col" select="@colstart"/>
      <xsl:with-param name="colend" select="@colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
    <xsl:if test="$rsep = ''">
      <xsl:text>+\arrayrulewidth</xsl:text>
    </xsl:if>
    <xsl:if test="@coloff = 0">
      <xsl:text>+2\tabcolsep</xsl:text>
    </xsl:if>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="@valign = 'top'">
      <xsl:text>p</xsl:text>
    </xsl:when>
    <xsl:when test="@valign = 'bottom'">
      <xsl:text>b</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>m</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$width"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="entry|entrytbl" mode="widthx.colfmt">
  <xsl:param name="colspec"/>
  <xsl:param name="color"/>

  <xsl:variable name="stars" 
                select="sum(exsl:node-set($colspec)/colspec
                            [@colnum &gt;= current()/@colstart and 
                             @colnum &lt;= current()/@colend]/@star)"/>

  <!-- Get the column fixed width part -->
  <xsl:variable name="width">
    <xsl:call-template name="tbl.colwidth2">
      <xsl:with-param name="col" select="@colstart"/>
      <xsl:with-param name="colend" select="@colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$stars = 0">
    <xsl:if test="$color != ''">
      <xsl:value-of select="concat('>{',$color,'}')"/>
    </xsl:if>
    <!-- Only a fixed width -->
    <xsl:choose>
      <xsl:when test="@valign = 'top'">
        <xsl:text>p</xsl:text>
      </xsl:when>
      <xsl:when test="@valign = 'bottom'">
        <xsl:text>b</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>m</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$width"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>>{</xsl:text>
    <xsl:value-of select="$color"/>
    <xsl:text>\setlength\hsize{</xsl:text>
    <xsl:if test="$width != ''">
      <xsl:value-of select="$width"/>
      <xsl:text>+</xsl:text>
    </xsl:if>
    <xsl:value-of select="$stars"/>
    <xsl:text>\hsize}}X</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Convert a frame tag to a CALS frame equivalent -->
<xsl:template name="cals.frame">
  <xsl:param name="frame"/>

  <xsl:choose>
  <xsl:when test="$frame='void'">none</xsl:when>
  <xsl:when test="$frame='above'">top</xsl:when>
  <xsl:when test="$frame='below'">bottom</xsl:when>
  <xsl:when test="$frame='hsides'">topbot</xsl:when>
  <xsl:when test="$frame='vsides'">sides</xsl:when>
  <xsl:when test="$frame='box'">all</xsl:when>
  <xsl:when test="$frame='border'">all</xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$frame"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Generate a latex column specifier, possibly surrounded by '|' -->
<xsl:template match="entry|entrytbl" mode="tbl.colfmt">
  <xsl:param name="frame"/>
  <xsl:param name="colspec"/>
  <xsl:param name="autowidth"/>
  
  <xsl:variable name="cols" select="count($colspec/*)"/>

  <!-- Need a colsep to the left? - only if first column and frame says so -->
  <xsl:if test="@colstart = 1 and ($frame = 'all' or $frame = 'sides')">
    <xsl:text>|</xsl:text>
  </xsl:if>

  <!-- Need a colsep to the right? - only if last column and frame says -->
  <!-- so, or we are not the last column and colsep says so  -->
  <xsl:variable name="rsep">
    <xsl:if test="(@colend = $cols and ($frame = 'all' or $frame = 'sides')) or 
                  (@colend != $cols and @colsep = 1)">
      <xsl:text>|</xsl:text>
    </xsl:if>
  </xsl:variable>

  <!-- Remove the offset between column and cell content? -->
  <xsl:if test="@coloff = 0">
    <xsl:text>@{}</xsl:text>
  </xsl:if>

  <!-- Column color? -->
  <xsl:variable name="color">
    <xsl:if test="@bgcolor != ''">
      <xsl:text>\columncolor</xsl:text>
      <xsl:call-template name="get-color">
        <xsl:with-param name="color" select="@bgcolor"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>
  
  <xsl:choose>
  <xsl:when test="not($autowidth)">
    <xsl:choose>
    <xsl:when test="@tabletype = 'tabularx'">
      <xsl:apply-templates select="." mode="widthx.colfmt">
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="color" select="$color"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="width.colfmt">
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="color" select="$color"/>
        <xsl:with-param name="rsep" select="$rsep"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="$color != ''">
      <xsl:value-of select="concat('>{',$color,'}')"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@align = 'left'">l</xsl:when>
      <xsl:when test="@align = 'right'">r</xsl:when>
      <xsl:when test="@align = 'center'">c</xsl:when>
      <xsl:otherwise>c</xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
  
  <xsl:if test="@coloff = 0">
    <xsl:text>@{}</xsl:text>
  </xsl:if>

  <xsl:value-of select="$rsep"/>
</xsl:template>


<xsl:template name="table.width">
  <xsl:param name="fullwidth"/>
  <xsl:param name="exclude"/>

  <xsl:variable name="piwidth">
    <xsl:call-template name="pi.dblatex_table-width">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <!-- precedence between table-widths specifications -->
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$piwidth != '' and
                      ($exclude='' or not(contains($piwidth,$exclude)))">
        <xsl:value-of select="$piwidth"/>
      </xsl:when>
      <xsl:when test="(@width or ../@width) and
                      ($exclude='' or not(contains(../@width,$exclude)))">
        <xsl:value-of select="(@width|../@width)[last()]"/>
      </xsl:when>
      <xsl:when test="$default.table.width != '' and
                      ($exclude='' or
                      not(contains($default.table.width,$exclude)))">
        <xsl:value-of select="$default.table.width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fullwidth"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- convert percentage to real width -->
  <xsl:choose>
    <xsl:when test="contains($width, '%')">
      <xsl:value-of select="number(substring-before($width, '%')) div 100"/>
      <xsl:value-of select="$fullwidth"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$width"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template name="tbl.sizes">
  <xsl:param name="colspec"/>
  <xsl:param name="width"/>

  <!-- Now get latex to calculate the 'spare' width of the table -->
  <!-- (Table width - widths of all specified columns - gaps between columns)-->
  <xsl:text>\setlength{\newtblsparewidth}{</xsl:text>
  <xsl:value-of select="$width"/>
  <xsl:for-each select="$colspec/*">
    <xsl:if test="@fixedwidth">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="translate(@fixedwidth,'+','-')"/>
    </xsl:if>
    <xsl:text>-2\tabcolsep</xsl:text>
  </xsl:for-each>
  <xsl:text>}%&#10;</xsl:text>
  
  <!-- Now get latex to calculate widths of cols with starred colwidths -->
  
  <xsl:variable name="numunknown" 
                select="sum($colspec/colspec/@star)"/>
  <!-- If we have at least one such col, then work out how wide it should -->
  <!-- be -->
  <xsl:if test="$numunknown &gt; 0">
    <xsl:text>\setlength{\newtblstarfactor}{\newtblsparewidth / \real{</xsl:text>
    <xsl:value-of select="$numunknown"/>
    <xsl:text>}}%&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- tabularx vertical alignment setup, global to the whole table -->
<xsl:template name="tbl.valign.x">
  <xsl:param name="valign"/>

  <xsl:variable name="valign.param">
    <xsl:choose>
    <xsl:when test="$valign = 'top'"><xsl:text>p</xsl:text></xsl:when>
    <xsl:when test="$valign = 'bottom'"><xsl:text>b</xsl:text></xsl:when>
    <!-- default vertical alignment -->
    <xsl:otherwise><xsl:text>m</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>\def\tabularxcolumn#1{</xsl:text>
  <xsl:value-of select="$valign.param"/>
  <xsl:text>{#1}}</xsl:text>
</xsl:template>


<xsl:template name="tbl.begin">
  <xsl:param name="colspec"/>
  <xsl:param name="tabletype"/>
  <xsl:param name="width"/>

  <xsl:text>\begin{</xsl:text>
  <xsl:value-of select="$tabletype"/>
  <xsl:text>}</xsl:text>

  <xsl:choose>
  <xsl:when test="$tabletype = 'tabularx'">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$width"/>
    <xsl:text>}{</xsl:text>
    <xsl:for-each select="$colspec/*">
      <xsl:choose>
      <xsl:when test="@star">
        <xsl:text>&gt;{\hsize=</xsl:text>
        <xsl:if test="@fixedwidth">
          <xsl:value-of select="@fixedwidth"/>
          <xsl:text>+</xsl:text>
        </xsl:if>
        <xsl:value-of select="@star"/>
        <xsl:text>\hsize}X</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>l</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>{</xsl:text>
    <!-- The initial column definition -->
    <xsl:for-each select="$colspec/*">
      <xsl:text>l</xsl:text>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- The main starting point of the table handling -->
<xsl:template match="tgroup" mode="newtbl" name="tgroup">
  <xsl:param name="tabletype">tabular</xsl:param>
  <xsl:param name="tablewidth">\linewidth-2\tabcolsep</xsl:param>
  <xsl:param name="tableframe">all</xsl:param>

  <!-- First, save the table verbatim data, but only at tgroup level -->
  <xsl:if test="not(self::entrytbl)">
    <xsl:apply-templates mode="save.verbatim"/>
  </xsl:if>
  <xsl:text>\begingroup%&#10;</xsl:text>

  <!-- Set cellpadding -->
  <xsl:if test="../@cellpadding">
    <xsl:text>\setlength{\tabcolsep}{</xsl:text>
    <xsl:value-of select="../@cellpadding"/>
    <xsl:text>}%&#10;</xsl:text>
  </xsl:if>

  <!-- Get the number of columns -->
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@cols">
        <xsl:value-of select="@cols"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(tbody/row[1]/*[self::entry or
                              self::entrytbl])"/>
        <xsl:message>Warning: table's tgroup lacks cols attribute. 
        Assuming <xsl:value-of select="count(tbody/row[1]/*)"/>.
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Get the number of rows -->
  <xsl:variable name="rows" select="count(*/row)"/>
  
  <xsl:if test="$rows = 0">
    <xsl:message>Warning: 0 rows</xsl:message>
  </xsl:if>

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

  <!-- Get the autowidth option -->
  <xsl:variable name="autowidth">
    <xsl:choose>
      <xsl:when test="contains($table.width,'auto')">
        <!-- Expect something like 'autowidth.all' or 'autowidth.default' -->
        <xsl:value-of select="$table.width"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$newtbl.autowidth"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Get default align -->
  <xsl:variable name="align" 
                select="@align|parent::node()[not(*/@align)]/@align"/>
  
  <!-- Get default colsep -->
  <xsl:variable name="colsep" 
                select="@colsep|parent::node()[not(*/@colsep)]/@colsep"/>
  
  <!-- Get default rowsep -->
  <xsl:variable name="rowsep" 
                select="@rowsep|parent::node()[not(*/@rowsep)]/@rowsep"/>
  
  <!-- Now the frame style -->
  <xsl:variable name="frame">
    <xsl:choose>
      <xsl:when test="../@frame">
        <xsl:value-of select="../@frame"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$tableframe"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Build up a complete colspec for each column -->
  <xsl:variable name="colspec">
    <xsl:call-template name="tbl.colspec">
      <xsl:with-param name="autowidth" select="$autowidth"/>
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rowsep">
        <xsl:choose>
          <xsl:when test="$rowsep"><xsl:value-of select="$rowsep"/>
          </xsl:when>
          <xsl:when test="$newtbl.default.rowsep">
            <xsl:value-of select="$newtbl.default.rowsep"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="colsep">
        <xsl:choose>
          <xsl:when test="$colsep"><xsl:value-of select="$colsep"/>
          </xsl:when>
          <xsl:when test="$newtbl.default.colsep">
            <xsl:value-of select="$newtbl.default.colsep"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="align">
        <xsl:choose>
          <xsl:when test="$align"><xsl:value-of select="$align"/>
          </xsl:when>
          <xsl:otherwise>left</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- Get all the spanspecs as an RTF -->
  <xsl:variable name="spanspec" select="spanspec"/>

  <xsl:if test="$tabletype != 'tabularx'">
    <xsl:call-template name="tbl.sizes">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$tabletype = 'tabularx'">
    <xsl:call-template name="tbl.valign.x">
      <xsl:with-param name="valign" select="tbody/@valign"/>
    </xsl:call-template>
  </xsl:if>
  
  <!-- Start the next table on a new line -->
  <xsl:if test="preceding::tgroup">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  
  <!-- Start the table declaration -->
  <xsl:call-template name="tbl.begin">
    <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="width" select="$width"/>
  </xsl:call-template>

  <xsl:if test="not(thead)">
    <xsl:apply-templates select="(ancestor::table
                                 |ancestor::informaltable)[last()]"
                         mode="newtbl.endhead">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:apply-templates>
  </xsl:if>
 
  <!-- Go through each row, starting with the header -->
  <xsl:apply-templates mode="newtbl" select="((thead|tbody)/row)[1]">
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="rownum" select="1"/>
    <xsl:with-param name="rows" select="$rows"/>
    <xsl:with-param name="frame" select="$frame"/>
    <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
    <xsl:with-param name="spanspec" select="exsl:node-set($spanspec)"/>
  </xsl:apply-templates>

  <!-- Go through each footer row -->
  <xsl:apply-templates mode="newtbl" select="tfoot/row[1]">
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="rownum" select="count(thead/row|tbody/row)+1"/>
    <xsl:with-param name="rows" select="$rows"/>
    <xsl:with-param name="frame" select="$frame"/>
    <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
    <xsl:with-param name="spanspec" select="exsl:node-set($spanspec)"/>
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

</xsl:stylesheet>
