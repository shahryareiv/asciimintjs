<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="text()">
  <xsl:call-template name="scape">
  <xsl:with-param name="string" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="text()" mode="latex.verbatim">
  <xsl:value-of select="."/> 
</xsl:template>

<xsl:template name="do.slash.hyphen">
  <xsl:param name="str"/>
  <xsl:choose>
  <xsl:when test="contains($str,'/')">
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="substring-before($str,'/')"/>
    </xsl:call-template>
    <xsl:text>/\-</xsl:text>
    <xsl:call-template name="do.slash.hyphen">
      <xsl:with-param name="str" select="substring-after($str,'/')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="$str"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="slash.hyphen">
  <xsl:choose>
  <xsl:when test="contains(.,'://')">
    <xsl:call-template name="scape">
      <xsl:with-param name="string">
        <xsl:value-of select="substring-before(.,'://')"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="'://'"/>
    <xsl:call-template name="do.slash.hyphen">
      <xsl:with-param name="str" select="substring-after(.,'://')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="do.slash.hyphen">
      <xsl:with-param name="str" select="."/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Beware, we must replace some text in an escaped string -->
<xsl:template name="scape.index">
  <xsl:param name="string"/>
  <xsl:call-template name="scape-replace">
  <xsl:with-param name="from">@</xsl:with-param>
  <xsl:with-param name="to">"@</xsl:with-param>
  <xsl:with-param name="string">
    <xsl:call-template name="scape-replace">
    <xsl:with-param name="from">!</xsl:with-param>
    <xsl:with-param name="to">"!</xsl:with-param>
    <xsl:with-param name="string">
      <xsl:call-template name="scape-replace">
      <xsl:with-param name="from">|</xsl:with-param>
      <xsl:with-param name="to">\ensuremath{"|}</xsl:with-param>
      <xsl:with-param name="string">
        <!-- if '\{' and '\}' count is not in the same in the
             index term, latex indexing fails.
             so use a macro to avoid this side effect -->
        <xsl:call-template name="scape-replace">
        <xsl:with-param name="from">\tbleft </xsl:with-param>
        <xsl:with-param name="to">\textbraceleft{}</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:call-template name="scape-replace">
          <xsl:with-param name="from">\tbright </xsl:with-param>
          <xsl:with-param name="to">\textbraceright{}</xsl:with-param>
          <xsl:with-param name="string">
            <!-- need two passes to avoid mess with macro ending with {} -->
            <xsl:call-template name="scape-replace">
            <xsl:with-param name="from">{</xsl:with-param>
            <xsl:with-param name="to">\tbleft </xsl:with-param>
            <xsl:with-param name="string">
              <xsl:call-template name="scape-replace">
              <xsl:with-param name="from">}</xsl:with-param>
              <xsl:with-param name="to">\tbright </xsl:with-param>
              <xsl:with-param name="string">
                <xsl:call-template name="scape-replace">
                <xsl:with-param name="from">"</xsl:with-param>
                <xsl:with-param name="to">""</xsl:with-param>
                <xsl:with-param name="string">
                   <xsl:call-template name="normalize-scape">
                    <xsl:with-param name="string" select="$string"/>
                  </xsl:call-template>
                </xsl:with-param>
                </xsl:call-template></xsl:with-param>
              </xsl:call-template></xsl:with-param>
            </xsl:call-template></xsl:with-param>
          </xsl:call-template></xsl:with-param>
        </xsl:call-template></xsl:with-param>
      </xsl:call-template></xsl:with-param>
    </xsl:call-template></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- TODO: how to scape tabs? xt plants -->
<!-- If probing is required the text is silently skipped.
     See verbatim.xsl for an overview of the verbatim environment design
     that explains the need of probing.
-->
<xsl:template match="text()" mode="latex.programlisting">
  <xsl:param name="probe" select="0"/>
  <xsl:if test="$probe = 0">
    <xsl:value-of select="."/> 
  </xsl:if>
</xsl:template>

<xsl:template name="normalize-scape" >
  <xsl:param name="string"/>
  <xsl:call-template name="scape">
    <xsl:with-param name="string" select="normalize-space($string)"/>
  </xsl:call-template>
</xsl:template>


<!-- So many lines to do so little: removing spurious blank lines
     before and after actual text, but keeping in-between blank lines.
-->
<xsl:template name="normalize-border" >
  <xsl:param name="string"/>
  <xsl:param name="step" select="'start'"/>
  <xsl:variable name="left" select="substring-before($string,'&#10;')"/>

  <xsl:choose>
  <xsl:when test="not(contains($string,'&#10;'))">
    <xsl:value-of select="$string"/>
  </xsl:when>
  <xsl:when test="$step='start'">
    <xsl:choose>
    <xsl:when test="string-length(normalize-space($left))=0">
      <xsl:call-template name="normalize-border">
        <xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$left"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="normalize-border">
        <xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
        <xsl:with-param name="step" select="'cont'"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$left"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:variable name="right" select="substring-after($string,'&#10;')"/>
    <xsl:if test="string-length(normalize-space($right))!=0">
      <xsl:call-template name="normalize-border">
        <xsl:with-param name="string" select="$right"/>
        <xsl:with-param name="step" select="'cont'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--  (c) David Carlisle
      replace all occurences of the character(s) `from'
      by the string `to' in the string `string'.
  -->
<xsl:template name="string-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:choose>
    <xsl:when test="contains($string,$from)">
      <xsl:value-of select="substring-before($string,$from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="string-replace">
        <xsl:with-param name="string" select="substring-after($string,$from)"/>
        <xsl:with-param name="from" select="$from"/>
        <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
