<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="imageobjectco.hide" select="0"/>

<xsl:template match="mediaobjectco">
  <xsl:if test="not(parent::figure)">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{minipage}{\linewidth}&#10;</xsl:text>
    <xsl:text>\begin{center}&#10;</xsl:text>
  </xsl:if>
  <!-- Forget the textobject -->
  <xsl:apply-templates select="imageobjectco[1]"/>
  <xsl:if test="not(parent::figure)">
    <xsl:text>\end{center}&#10;</xsl:text>
    <xsl:text>\end{minipage}&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="imageobjectco">
  <!-- Do as if we could have several imageobjects (DocBook 5) -->
  <xsl:variable name="idx">
    <xsl:call-template name="mediaobject.select.idx"/>
  </xsl:variable>
  <xsl:apply-templates select="imageobject[position()=$idx]"/>
  <xsl:apply-templates select="calloutlist"/>
</xsl:template>

<xsl:template match="imageobjectco" mode="graphic.begin">
  <xsl:text>\begin{overpic}</xsl:text>
</xsl:template>

<xsl:template match="imageobjectco" mode="graphic.end">
  <xsl:text>&#10;\picfactoreval</xsl:text>
  <xsl:apply-templates select="areaspec//area" mode="graphic"/>
  <xsl:text>\end{overpic}</xsl:text>
</xsl:template>

<!-- Cut a coord of the form "x,y" and gives x or y -->
<xsl:template name="coord.get">
  <xsl:param name="axe"/>
  <xsl:param name="def"/>
  <xsl:param name="xy"/>

  <xsl:choose>
  <xsl:when test="contains($xy, ',')">
    <xsl:choose>
    <xsl:when test="$axe='x'">
      <xsl:value-of select="substring-before($xy, ',')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring-after($xy, ',')"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="$axe=$def">
      <xsl:value-of select="$xy"/>
    </xsl:if>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Check the validity or a coordinate -->
<xsl:template name="coord.check">
  <xsl:param name="x"/>
  <xsl:if test="$x!=''">
    <xsl:choose>
    <xsl:when test="string(number($x))='NaN'">
      <xsl:message>
        <xsl:text>*** Error: </xsl:text>
        <xsl:value-of select="$x"/>
        <xsl:text>: invalid calspair coordinate</xsl:text>
      </xsl:message>
      <xsl:value-of select='1'/>
    </xsl:when>
    <xsl:when test="number($x)&gt;10000">
      <xsl:message>
        <xsl:text>*** Error: </xsl:text>
        <xsl:value-of select="$x"/>
        <xsl:text>: calspair out of range</xsl:text>
      </xsl:message>
      <xsl:value-of select='1'/>
    </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- Put the callout mark on the graphic, according to the caspair
     coordinates -->

<xsl:template match="area" mode="graphic">
  <xsl:variable name="x1y1">
    <xsl:value-of select="substring-before(@coords, ' ')"/>
  </xsl:variable>
  <xsl:variable name="x2y2">
    <xsl:value-of select="substring-after(@coords, ' ')"/>
  </xsl:variable>

  <!-- coordinates -->
  <xsl:variable name="x1">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x1y1"/>
      <xsl:with-param name="axe" select="'x'"/>
      <xsl:with-param name="def" select="'x'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="y1">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x1y1"/>
      <xsl:with-param name="axe" select="'y'"/>
      <xsl:with-param name="def" select="'x'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="x2">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x2y2"/>
      <xsl:with-param name="axe" select="'x'"/>
      <xsl:with-param name="def" select="'y'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="y2">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x2y2"/>
      <xsl:with-param name="axe" select="'y'"/>
      <xsl:with-param name="def" select="'y'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- consistency check of @coords -->
  <xsl:variable name="coord.error">
    <xsl:if test="$x1y1='' or $x2y2=''">
      <xsl:message>
        <xsl:text>*** Error: </xsl:text>
        <xsl:value-of select="@coords"/>
        <xsl:text>: invalid calspair</xsl:text>
      </xsl:message>
      <xsl:value-of select="'1'"/>
    </xsl:if>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$x1"/>
    </xsl:call-template>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$y1"/>
    </xsl:call-template>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$x2"/>
    </xsl:call-template>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$y2"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$coord.error=''">
    <xsl:text>\calspair{</xsl:text>

    <!-- choose horizontal coordinate -->
    <xsl:choose>
      <xsl:when test="$x1 != '' and $x2 != ''">
        <xsl:value-of select="(number($x1)+number($x2)) div 200"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number(concat($x1, $x2)) div 100"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}{</xsl:text>
    <!-- choose vertical coordinate -->
    <xsl:choose>
      <xsl:when test="$y1 != '' and $y2 != ''">
        <xsl:value-of select="(number($y1)+number($y2)) div 200"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number(concat($y1, $y2)) div 100"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}{</xsl:text>
    <!-- callout markup in the image. No tex escape sequence needed here -->
    <xsl:apply-templates select="." mode="latex.programlisting">
      <xsl:with-param name="co-tagin" select="''"/>
      <xsl:with-param name="co-tagout" select="''"/>
      <xsl:with-param name="co-hide" select="$imageobjectco.hide"/>
    </xsl:apply-templates>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>
  
</xsl:stylesheet>
