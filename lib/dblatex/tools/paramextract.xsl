<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:output indent="yes"/> 

<!-- 
     Extract all the parameters from the XSL stylesheets.
     Example of use:

     xsltproc extractparam.xsl docbook.xsl > paramgroup.xml
     xsltproc -.-param chunk 1 extractparam.xsl docbook.xsl
-->
<xsl:param name="chunk" select="0"/>
<xsl:param name="chunk.prefix" select="''"/>
<xsl:param name="chunk.suffix" select="'sxml'"/>

<xsl:include href="../xsl/chunker.xsl"/>

<xsl:template match="/">
  <xsl:choose>
  <xsl:when test="$chunk = 0">
    <xsl:element name="xsl:paramgroup">
      <xsl:apply-templates select="xsl:stylesheet"/>
    </xsl:element>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="xsl:stylesheet"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="xsl:param">

  <xsl:message>
    <xsl:value-of select="@name"/>
    <xsl:text> = </xsl:text>
    <xsl:choose>
    <xsl:when test=". != ''">
      <xsl:value-of select="."/>
      <xsl:text> (string)</xsl:text>
    </xsl:when>
    <xsl:when test="@select">
      <xsl:value-of select="@select"/>
      <xsl:text> (select) </xsl:text>
      <xsl:choose>
      <xsl:when test="@select = number(@select)">
        <xsl:text> (number) </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> (string) </xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> (empty) </xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:message>

  <!-- copy the parameter -->
  <xsl:variable name="param">
    <xsl:element name="xsl:param">
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:variable>

  <!-- put it in the main stream, or chunk as a new file -->
  <xsl:choose>
  <xsl:when test="$chunk = 0">
    <xsl:copy-of select="$param"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="write.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="$chunk.prefix"/>
        <xsl:value-of select="@name"/>
        <xsl:text>.</xsl:text>
        <xsl:value-of select="$chunk.suffix"/>
      </xsl:with-param>
      <xsl:with-param name="omit-xml-declaration" select="'yes'"/>
      <xsl:with-param name="method" select="'xml'"/>
      <xsl:with-param name="content" select="$param"/>
      <xsl:with-param name="indent" select="'yes'"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template match="xsl:stylesheet">
  <xsl:apply-templates select="xsl:param"/>
  <xsl:apply-templates select="xsl:include"/>
</xsl:template>


<xsl:template match="xsl:include">
  <xsl:variable name="doc" select="document(@href)"/>

  <xsl:message>Params defined in <xsl:value-of select="@href"/></xsl:message>

  <xsl:apply-templates select="$doc/xsl:stylesheet"/>
</xsl:template>

</xsl:stylesheet>
