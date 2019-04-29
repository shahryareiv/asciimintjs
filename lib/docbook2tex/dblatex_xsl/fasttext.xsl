<?xml version='1.0' encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY t1 "&#x370;t">
<!ENTITY t2 "&#x371;t">
<!ENTITY u1 "&#x370;u">
<!ENTITY u2 "&#x371;u">
<!ENTITY v1 "&#x370;u">
<!ENTITY v2 "&#x371;u">
<!ENTITY h1 "&#x370;h">
<!ENTITY h2 "&#x371;h">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- These templates boost the text processing but needs some post-parsing
     to escape the TeX characters and do the encoding. -->

<!-- use Reserved Unicode characters as delimiters -->
<xsl:template name="scape" >
  <xsl:param name="string"/>
  <xsl:text>&t1;</xsl:text>
  <xsl:value-of select="$string"/>
  <xsl:text>&t2;</xsl:text>
</xsl:template>

<!-- tag the text for post-processing -->
<xsl:template match="text()">
  <xsl:text>&t1;</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>&t2;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="latex.programlisting">
  <xsl:param name="probe" select="0"/>
  <xsl:if test="$probe = 0">
    <xsl:text>&v1;</xsl:text>
    <xsl:value-of select="."/> 
    <xsl:text>&v2;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="text()" mode="latex.verbatim">
  <xsl:text>&v1;</xsl:text>
  <xsl:value-of select="."/> 
  <xsl:text>&v2;</xsl:text>
</xsl:template>

<!-- specific handling depending on the context -->
<xsl:template match="text()[ancestor::ulink]">
  <!-- LaTeX chars are scaped. Each / except the :// is mapped to a /\- -->
  <xsl:apply-templates select="." mode="slash.hyphen"/>
</xsl:template>

<!-- replace some text in a string *as if* the string is already escaped.
     Here it ends to inserting raw text between tags. -->
<xsl:template name="scape-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:call-template name="string-replace">
    <xsl:with-param name="string" select="$string"/>
    <xsl:with-param name="from" select="$from"/>
    <xsl:with-param name="to" select="concat('&t2;',$to,'&t1;')"/>
  </xsl:call-template>
</xsl:template>

<!-- just ask for encoding -->
<xsl:template name="scape-encode" >
  <xsl:param name="string"/>
  <xsl:text>&u1;</xsl:text>
  <xsl:value-of select="$string"/>
  <xsl:text>&u2;</xsl:text>
</xsl:template>

<!-- ask for hyphenating -->
<xsl:template name="hyphen-encode" >
  <xsl:param name="string"/>
  <xsl:text>&h1;</xsl:text>
  <xsl:value-of select="$string"/>
  <xsl:text>&h2;</xsl:text>
</xsl:template>

<!-- specific behaviour for MML -->
<xsl:template match="m:*/text()">
  <xsl:call-template name="mmltext"/>
</xsl:template>

<xsl:template name="normalize-scape" >
  <xsl:param name="string"/>
  <xsl:call-template name="scape">
    <xsl:with-param name="string">
      <xsl:value-of select="normalize-space($string)"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
