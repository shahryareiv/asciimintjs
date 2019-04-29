<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!-- Target Database set by the command line

<xsl:param name="target.database.document">olinkdb.xml</xsl:param>
-->

<!-- Use the Bob Stayton's Tip related to olinking -->
<xsl:param name="current.docid" select="/*/@id"/>

<!-- Use the literal scaling feature -->
<xsl:param name="literal.extensions">scale.by.width</xsl:param>

<!-- We want the TOC links in the titles, and in blue. -->
<xsl:param name="latex.hyperparam">colorlinks,linkcolor=blue,pdfstartview=FitH</xsl:param>

<!-- Put the dblatex logo -->
<xsl:param name="doc.publisher.show">1</xsl:param>

<!-- Show the list of examples too -->
<xsl:param name="doc.lot.show">figure,table,example</xsl:param>

<!-- DocBook like description -->
<xsl:param name="term.breakline">1</xsl:param>

<!-- Manpage titles not numbered -->
<xsl:param name="refentry.numbered">0</xsl:param>

<xsl:template match="parameter">
  <xsl:variable name="name" select="."/>
  <xsl:variable name="target" select="key('id',$name)[1]"/>

  <xsl:choose>
  <xsl:when test="count($target) &gt; 0">
    <!-- Hot link to the parameter refentry -->
    <xsl:call-template name="hyperlink.markup">
      <xsl:with-param name="linkend" select="$name"/>
      <xsl:with-param name="text">
        <xsl:apply-imports/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- Index entry for this parameter -->
    <xsl:text>\index{Parameters!</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!--
    <xsl:message>No reference for parameter: '<xsl:value-of
    select="$name"/>'</xsl:message>
    -->
    <xsl:apply-imports/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="sgmltag[@class='xmlpi']">
  <xsl:variable name="name" select="normalize-space(.)"/>
  <xsl:variable name="nameref" select="concat('pi-',translate($name,' ','_'))"/>
  <xsl:variable name="target" select="key('id',$nameref)[1]"/>

  <xsl:choose>
  <xsl:when test="count($target) &gt; 0">
    <!-- Hot link to the parameter refentry -->
    <xsl:call-template name="hyperlink.markup">
      <xsl:with-param name="linkend" select="$nameref"/>
      <xsl:with-param name="text">
        <xsl:apply-imports/>
      </xsl:with-param>
    </xsl:call-template>
    <!-- Index entry for this parameter -->
    <xsl:text>\index{Processing Instructions!</xsl:text>
    <xsl:value-of select="$name"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!--
    <xsl:message>No reference for parameter: '<xsl:value-of
    select="$name"/>'</xsl:message>
    -->
    <xsl:apply-imports/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
