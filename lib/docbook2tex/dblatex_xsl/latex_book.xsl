<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version="1.0">

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:import href="docbook.xsl"/>
<xsl:import href="mathml2/mathml.xsl"/>


<xsl:template name="apply-templates">
  <xsl:apply-imports/>
  <xsl:apply-templates select="." mode="annotation.links"/>
</xsl:template>

<xsl:template match="*[not(self::indexterm or
                           self::calloutlist or
                           self::programlisting or
                           self::screen or
                           self::book or
                           self::article)]">
  <xsl:call-template name="apply-templates"/>
</xsl:template>

<xsl:template match="*[@revisionflag]">
  <xsl:choose>
    <xsl:when test="local-name(.) = 'para'
                    or local-name(.) = 'simpara'
                    or local-name(.) = 'formalpara'
                    or local-name(.) = 'section'
                    or local-name(.) = 'sect1'
                    or local-name(.) = 'sect2'
                    or local-name(.) = 'sect3'
                    or local-name(.) = 'sect4'
                    or local-name(.) = 'sect5'
                    or local-name(.) = 'chapter'
                    or local-name(.) = 'preface'
                    or local-name(.) = 'itemizedlist'
                    or local-name(.) = 'varlistentry'
                    or local-name(.) = 'glossary'
                    or local-name(.) = 'bibliography'
                    or local-name(.) = 'appendix'">
      <xsl:text>&#10;\cbstart{}</xsl:text>
      <xsl:call-template name="apply-templates"/>
      <xsl:text>\cbend{}&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="local-name(.) = 'phrase'
                    or local-name(.) = 'ulink'
                    or local-name(.) = 'filename'
                    or local-name(.) = 'literal'
                    or local-name(.) = 'member'
                    or local-name(.) = 'glossterm'
                    or local-name(.) = 'sgmltag'
                    or local-name(.) = 'quote'
                    or local-name(.) = 'emphasis'
                    or local-name(.) = 'command'
                    or local-name(.) = 'xref'">
      <xsl:text>\cbstart{}</xsl:text>
      <xsl:call-template name="apply-templates"/>
      <xsl:text>\cbend{}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Revisionflag on unexpected element: </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text> (Assuming block)</xsl:text>
      </xsl:message>
      <xsl:text>&#10;\cbstart{}</xsl:text>
      <xsl:call-template name="apply-templates"/>
      <xsl:text>\cbend{}&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
