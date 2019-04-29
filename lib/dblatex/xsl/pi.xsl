<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="processing-instruction()"/>

<!-- Raw latex text, e.g "<?latex \sloppy ?>" -->
<xsl:template match="processing-instruction('latex')">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="processing-instruction('db2latex')">
  <xsl:value-of select="."/>
</xsl:template>

<!-- ==================================================================== -->
<!-- The bibtex PI.  -->

<xsl:template name="pi.bibtex_bibfiles">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('bibtex')"/>
    <xsl:with-param name="attribute" select="'bibfiles'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.bibtex_bibstyle">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('bibtex')"/>
    <xsl:with-param name="attribute" select="'bibstyle'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.bibtex_mode">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis" select="$node/processing-instruction('bibtex')"/>
    <xsl:with-param name="attribute" select="'mode'"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
<!-- The texmath PI.  -->

<xsl:template name="pi.texmath_delimiters">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('texmath')"/>
    <xsl:with-param name="attribute" select="'delimiters'"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
<!-- The dblatex PI.  -->

<xsl:template name="pi.dblatex_angle">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'angle'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dblatex_citestyle">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'citestyle'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dblatex_colwidth">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'colwidth'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dblatex_bgcolor">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'bgcolor'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dblatex_table-width">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'table-width'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dblatex_autowidth">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'autowidth'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="pi.dblatex_list-presentation">
  <xsl:param name="node" select="."/>
  <xsl:call-template name="pi-attribute">
    <xsl:with-param name="pis"
                    select="$node/processing-instruction('dblatex')"/>
    <xsl:with-param name="attribute" select="'list-presentation'"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
