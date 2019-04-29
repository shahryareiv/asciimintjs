<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="sgmltag|tag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="normalize-space(@class)"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$class='attribute'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:when test="$class='attvalue'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:when test="$class='element'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:when test="$class='endtag'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$/</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='genentity'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>\&amp;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='numcharref'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>\&amp;\#</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='paramentity'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>\%</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='pi'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>?$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='xmlpi'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>?$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='starttag'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='emptytag'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>/$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='sgmlcomment'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$!$--$</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>$--&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.charseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
