<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="tex.math.in.alt" select="'latex'"/>
<xsl:param name="alt.use" select="0"/>
<xsl:param name="equation.default.position">[H]</xsl:param>


<xsl:template match="inlineequation|informalequation" name="equation">
  <xsl:choose>
  <xsl:when test="alt and $tex.math.in.alt='latex'">
    <xsl:apply-templates select="alt" mode="latex"/>
  </xsl:when>
  <xsl:when test="alt and (count(child::*)=1 or $alt.use='1')">
    <!-- alt is simply some text -->
    <xsl:apply-templates select="alt"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="*[not(self::alt)]"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="equation">
  <xsl:variable name="delim">
    <xsl:if test="descendant::alt/processing-instruction('texmath')">
      <xsl:call-template name="pi-attribute">
        <xsl:with-param name="pis"
                   select="descendant::alt/processing-instruction('texmath')"/>
        <xsl:with-param name="attribute" select="'delimiters'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="title">
    <xsl:text>&#10;\begin{dbequation}</xsl:text>
    <!-- float placement preference -->
    <xsl:choose>
      <xsl:when test="@floatstyle != ''">
        <xsl:value-of select="@floatstyle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$equation.default.position"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="equation"/>
    <xsl:text>&#10;\caption{</xsl:text>
    <xsl:call-template name="normalize-scape">
       <xsl:with-param name="string" select="title"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
    <xsl:call-template name="label.id"/>
    <xsl:text>&#10;\end{dbequation}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$delim='user'">
    <!-- The user provide its own environment -->
    <xsl:call-template name="equation"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- This is an actual LaTeX equation -->
    <xsl:text>&#10;\begin{equation}&#10;</xsl:text>
    <xsl:call-template name="label.id"/>
    <xsl:call-template name="equation"/>
    <xsl:text>&#10;\end{equation}&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="alt|mathphrase">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="equation/title"/>

<!-- Direct copy of the content -->

<xsl:template match="alt" mode="latex">
  <xsl:variable name="delim">
    <xsl:if test="processing-instruction('texmath')">
      <xsl:call-template name="pi-attribute">
        <xsl:with-param name="pis"
                   select="processing-instruction('texmath')"/>
        <xsl:with-param name="attribute" select="'delimiters'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="tex">
    <xsl:variable name="text" select="normalize-space(.)"/>
    <xsl:variable name="len" select="string-length($text)"/>
    <xsl:choose>
    <xsl:when test="$delim='user'">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:when test="ancestor::equation[not(child::title)]">
      <!-- Remove any math mode in an equation environment -->
      <xsl:choose>
      <xsl:when test="starts-with($text,'$') and
                      substring($text,$len,$len)='$'">
        <xsl:copy-of select="substring($text, 2, $len - 2)"/>
      </xsl:when>
      <xsl:when test="(starts-with($text,'\[') and
                       substring($text,$len - 1,$len)='\]') or
                      (starts-with($text,'\(') and
                       substring($text,$len - 1,$len)='\)')">
        <xsl:copy-of select="substring($text, 3, $len - 4)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- Test to be DB5 compatible, where <alt> can be in other elements -->
    <xsl:when test="ancestor::equation or
                    ancestor::informalequation or
                    ancestor::inlineequation">
      <!-- Keep the specified math mode... -->
      <xsl:choose>
      <xsl:when test="(starts-with($text,'\[') and
                       substring($text,$len - 1,$len)='\]') or
                      (starts-with($text,'\(') and
                       substring($text,$len - 1,$len)='\)') or
                      (starts-with($text,'$') and
                       substring($text,$len,$len)='$')">
        <xsl:copy-of select="$text"/>
      </xsl:when>
      <!-- ...Or wrap in default math mode -->
      <xsl:otherwise>
        <xsl:copy-of select="concat('$', $text, '$')"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>
  <!-- Encode it properly -->
  <xsl:call-template name="scape-encode">
    <xsl:with-param name="string" select="$tex"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
