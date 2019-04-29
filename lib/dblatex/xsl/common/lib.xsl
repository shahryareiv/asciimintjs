<?xml version="1.0" encoding="ASCII"?>
<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     This module implements DTD-independent functions

     ******************************************************************** -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Only an excerpt of the original file -->

<xsl:template name="dot.count">
  <!-- Returns the number of "." characters in a string -->
  <xsl:param name="string"/>
  <xsl:param name="count" select="0"/>
  <xsl:choose>
    <xsl:when test="contains($string, '.')">
      <xsl:call-template name="dot.count">
        <xsl:with-param name="string" select="substring-after($string, '.')"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="pi-attribute">
  <xsl:param name="pis" select="processing-instruction('BOGUS_PI')"/>
  <xsl:param name="attribute">filename</xsl:param>
  <xsl:param name="count">1</xsl:param>

  <xsl:choose>
    <xsl:when test="$count&gt;count($pis)">
      <!-- not found -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pi">
        <xsl:value-of select="$pis[$count]"/>
      </xsl:variable>
      <xsl:variable name="pivalue">
        <xsl:value-of select="concat(' ', normalize-space($pi))"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($pivalue,concat(' ', $attribute, '='))">
          <xsl:variable name="rest"
               select="substring-after($pivalue,concat(' ', $attribute,'='))"/>
          <xsl:variable name="quote" select="substring($rest,1,1)"/>
          <xsl:value-of select="substring-before(substring($rest,2),$quote)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$pis"/>
            <xsl:with-param name="attribute" select="$attribute"/>
            <xsl:with-param name="count" select="$count + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xpath.location">
  <xsl:param name="node" select="."/>
  <xsl:param name="path" select="''"/>

  <xsl:variable name="next.path">
    <xsl:value-of select="local-name($node)"/>
    <xsl:if test="$path != ''">/</xsl:if>
    <xsl:value-of select="$path"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$node/parent::*">
      <xsl:call-template name="xpath.location">
        <xsl:with-param name="node" select="$node/parent::*"/>
        <xsl:with-param name="path" select="$next.path"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$next.path"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="count.uri.path.depth">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="count" select="0"/>

  <xsl:choose>
    <xsl:when test="contains($filename, '/')">
      <xsl:call-template name="count.uri.path.depth">
        <xsl:with-param name="filename"
                        select="substring-after($filename, '/')"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trim.common.uri.paths">
  <xsl:param name="uriA" select="''"/>
  <xsl:param name="uriB" select="''"/>
  <xsl:param name="return" select="'A'"/>

  <xsl:choose>
    <xsl:when test="contains($uriA, '/') and contains($uriB, '/')                     and substring-before($uriA, '/') = substring-before($uriB, '/')">
      <xsl:call-template name="trim.common.uri.paths">
        <xsl:with-param name="uriA" select="substring-after($uriA, '/')"/>
        <xsl:with-param name="uriB" select="substring-after($uriB, '/')"/>
        <xsl:with-param name="return" select="$return"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$return = 'A'">
          <xsl:value-of select="$uriA"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$uriB"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="copy-string">
  <!-- returns 'count' copies of 'string' -->
  <xsl:param name="string"/>
  <xsl:param name="count" select="0"/>
  <xsl:param name="result"/>

  <xsl:choose>
    <xsl:when test="$count&gt;0">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="count" select="$count - 1"/>
        <xsl:with-param name="result">
          <xsl:value-of select="$result"/>
          <xsl:value-of select="$string"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$result"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
