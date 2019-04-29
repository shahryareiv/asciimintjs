<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Convert hexadecimal format to decimal -->
<xsl:template name="hex-to-int">
  <xsl:param name="hex" select="'0'"/>

  <xsl:choose>
  <xsl:when test="string-length($hex)=1">
    <xsl:call-template name="char-to-int">
      <xsl:with-param name="char" select="$hex"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="low.int">
      <xsl:call-template name="char-to-int">
        <xsl:with-param name="char"
                        select="substring($hex, string-length($hex))"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="high.int">
      <xsl:call-template name="hex-to-int">
        <xsl:with-param name="hex"
                        select="substring($hex, 1, string-length($hex)-1)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$low.int + 16*$high.int"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="char-to-int">
  <xsl:param name="char" select="'0'"/>
  <xsl:variable name="c">
    <xsl:value-of select="translate($char, 'abcdef', 'ABCDEF')"/>
  </xsl:variable>

  <xsl:value-of select="string-length(substring-before('0123456789ABCDEF',
                                      $c))"/>
</xsl:template>

<!-- Convert xxyyzz to rate(xx),rate(yy),rate(zz) -->
<xsl:template name="hex-to-rgb">
  <xsl:param name="hex" select="'0'"/>
  <xsl:choose>
  <xsl:when test="string-length($hex) &lt;= 2">
    <xsl:call-template name="hex-to-rate">
      <xsl:with-param name="hex" select="$hex"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="right">
      <xsl:call-template name="hex-to-rate">
        <xsl:with-param name="hex"
                        select="substring($hex, string-length($hex)-1)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="left">
      <xsl:call-template name="hex-to-rgb">
        <xsl:with-param name="hex"
                        select="substring($hex, 1, string-length($hex)-2)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$left"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$right"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Convert 0xCC to 0.8 = 204/255 -->
<xsl:template name="hex-to-rate">
  <xsl:param name="hex" select="'0'"/>
  <xsl:variable name="int">
    <xsl:call-template name="hex-to-int">
      <xsl:with-param name="hex" select="$hex"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="round(($int * 100) div 255) div 100"/>
</xsl:template>


<!-- Convert color to a proper latex format:
     #xxyyzz   => [rgb]{u,v,w}
     #xaxaxa   => [gray]{u}
     xxx       => {xxx}
     {xxx}     => {xxx}
     [aa]{xxx} => [aa]{xxx}
-->
<xsl:template name="get-color">
  <xsl:param name="color"/>
  <xsl:choose>
  <xsl:when test="starts-with($color, '#')">
    <xsl:variable name="fullcolor"
                  select="concat('000000', substring-after($color, '#'))"/>
    <xsl:variable name="rcolor"
                  select="substring($fullcolor, string-length($fullcolor)-5)"/>
    <xsl:variable name="r" select="substring($rcolor,1,2)"/>
    <xsl:variable name="g" select="substring($rcolor,3,2)"/>
    <xsl:variable name="b" select="substring($rcolor,5,2)"/>
    <xsl:choose>
    <xsl:when test="$r=$g and $g=$b">
      <xsl:text>[gray]{</xsl:text>
      <xsl:call-template name="hex-to-rate">
        <xsl:with-param name="hex" select="$r"/>
      </xsl:call-template>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>[rgb]{</xsl:text>
      <xsl:call-template name="hex-to-rgb">
        <xsl:with-param name="hex" select="$rcolor"/>
      </xsl:call-template>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="starts-with($color, '[') or starts-with($color, '{')">
    <xsl:value-of select="$color"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$color"/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Just for a unit-test like that:
     <u>
       <rgb>CCFFEE</rgb>
       <rgb>DD7E67</rgb>
       <rgb>7A33</rgb>
       <color>#d5</color>
       <color>#7A33</color>
       <color>#3a7a33</color>
       <color>#3a3a3a</color>
       <color>#cccccc</color>
       <color>red</color>
       <color>{blue}</color>
       <color>[gray]{0.8}</color>
     </u>
-->
<xsl:template match="rgb">
  <xsl:call-template name="hex-to-rgb">
    <xsl:with-param name="hex" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="color">
  <xsl:call-template name="get-color">
    <xsl:with-param name="color" select="."/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
