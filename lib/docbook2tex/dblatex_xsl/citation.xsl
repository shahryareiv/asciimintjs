<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:param name="citation.natbib.use" select="'0'"/>
<xsl:param name="citation.natbib.options"/>
<xsl:param name="citation.default.style"/>


<!-- Loads the natbib package if required -->
<xsl:template name="citation.setup">
  <xsl:if test="$citation.natbib.use!='0'">
    <xsl:text>\usepackage</xsl:text>
    <xsl:if test="$citation.natbib.options!=''">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$citation.natbib.options"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{natbib}&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Parses a cite macro like \citep[...][...] so that the bracket contents
     are converted safely to latex strings. Special care about the optional
     enclosing curly braces telling to use this content block [{...}] so that
     you can put some '[...]' in it. -->

<xsl:template name="cite-parse">
  <xsl:param name="macro"/>

  <xsl:variable name="brackets">
    <xsl:choose>
    <xsl:when test="contains($macro,'[{') and
                    contains(substring-after($macro,'[{'),'}]')">
      <xsl:value-of select="'[{ }]'"/>
    </xsl:when>
    <xsl:when test="contains($macro,'[') and
                    contains(substring-after($macro,'['),']')">
      <xsl:value-of select="'[ ]'"/>
    </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$brackets!=''">
    <xsl:variable name="bs" select="substring-before($brackets,' ')"/>
    <xsl:variable name="be" select="substring-after($brackets,' ')"/>
    <xsl:variable name="opt"
                  select="substring-before(substring-after($macro,$bs),$be)"/>
    <xsl:value-of select="substring-before($macro,$bs)"/>
    <xsl:value-of select="$bs"/>
    <!-- escape brackets content -->
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="$opt"/>
    </xsl:call-template>
    <xsl:value-of select="$be"/>
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro"
                      select="substring-after($macro,concat($bs,$opt,$be))"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$macro"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Format a specific citation style from @role, a PI, or the default style.
     The citation styles are disabled if natbib is not used -->

<xsl:template match="citation" mode="cite-style">
  <!-- maybe a citation style from PI -->
  <xsl:variable name="pi">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="processing-instruction('dblatex')"/>
      <xsl:with-param name="attribute" select="'citestyle'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$citation.natbib.use='0'">
    <xsl:text>\cite</xsl:text>
  </xsl:when>
  <xsl:when test="@role and (starts-with(@role,'\cite') or
                             starts-with(@role,'\Cite'))">
    <!-- a natbib citation style from @role -->
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro" select="@role"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="starts-with($pi,'\cite') or starts-with($pi,'\Cite')">
    <!-- a natbib citation style from PI -->
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro" select="$pi"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="$citation.default.style!=''">
    <!-- the default natbib citation style -->
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro" select="$citation.default.style"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\cite</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="citation">
  <xsl:apply-templates select="." mode="cite-style"/>
  <xsl:text>{</xsl:text>
  <!-- we take the raw text: we don't want that "_" becomes "\_" -->
  <xsl:value-of select="."/>
  <xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>
