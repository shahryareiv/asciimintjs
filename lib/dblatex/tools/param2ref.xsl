<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
              xmlns:m="http://www.w3.org/1998/Math/MathML"
              version="1.0">

<xsl:output encoding="UTF-8" indent="yes"/>

<!-- This stylesheet builds a refentry XML file for each parameter listed in
     the passed <informaltable>. This translation should be done only once
     to migrate from manual v0.2.9 to manual v0.2.10 where each parameter is
     described like the DocBook Project does, i.e. through refentries.

     The default parameter reference tree is like this:
     ./    : where to store the refentry XML files built by this stylesheet
     ./syn : where to store the synopsis XML files built by another XSLT

     Example of use in the tools/ dir to put param refentries in tools/params/:

     xsltproc -+-stringparam ref.prefix params/ \
              param2ref.xsl ../docs/custom/param.xml
-->

<xsl:param name="ref.prefix"></xsl:param>
<xsl:param name="syn.prefix">syn/</xsl:param>
<xsl:param name="syn.suffix">xml</xsl:param>

<xsl:include href="../xsl/chunker.xsl"/>

<xsl:template match="/">
  <xsl:apply-templates select="//informaltable"/>
</xsl:template>

<xsl:template match="informaltable">
  <xsl:apply-templates select="//tbody/row"/>
</xsl:template>

<xsl:template match="row">
  <xsl:variable name="param-name" select="entry[1]/text()"/>

  <xsl:variable name="refentry">
  <refentry id="{$param-name}">
  <refmeta>
    <refentrytitle>
      <xsl:value-of select="$param-name"/>
    </refentrytitle>
    <!-- don't know what to do with this
    <refmiscinfo class="other" otherclass="datatype">boolean</refmiscinfo>
    -->
  </refmeta>
  <refnamediv>
    <refname><xsl:value-of select="$param-name"/></refname>
    <refpurpose>???</refpurpose>
  </refnamediv>

  <refsynopsisdiv>
    <programlisting>
      <!-- Point to the actual param synopsis -->
      <xsl:element name="xi:include"
                   namespace="http://www.w3.org/2001/XInclude">
        <xsl:attribute name="parse">text</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($syn.prefix, $param-name, '.',
                                       $syn.suffix)"/>
        </xsl:attribute>
      </xsl:element></programlisting>
  </refsynopsisdiv>

  <refsection><title>Description</title>
    <para>
    <xsl:apply-templates select="entry[2]/node()" mode="copy"/>
    </para>
  </refsection>
  </refentry>
  </xsl:variable>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename">
      <xsl:value-of select="$ref.prefix"/>
      <xsl:value-of select="$param-name"/>
      <xsl:text>.xml</xsl:text>
    </xsl:with-param>
    <xsl:with-param name="method" select="'xml'"/>
    <xsl:with-param name="doctype-public"
                    select="'-//OASIS//DTD DocBook XML V4.4//EN'"/>
    <xsl:with-param name="doctype-system"
           select="'http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd'"/>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
    <xsl:with-param name="content" select="$refentry"/>
    <xsl:with-param name="indent" select="'yes'"/>
  </xsl:call-template>

</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:copy-of select="."/>
</xsl:template>


</xsl:stylesheet>
