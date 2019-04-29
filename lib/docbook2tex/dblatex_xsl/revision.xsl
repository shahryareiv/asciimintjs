<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="revhistory">
  <xsl:if test="$latex.output.revhistory=1">
    <xsl:text>
%% ----------------------
%% Revision History Table
%% ----------------------
\renewcommand{\DBKrevhistory}{
\begin{DBKrevtable}
</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>
\end{DBKrevtable}}

    </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="revhistory/revision">
  <xsl:variable name="revnumber" select=".//revnumber"/>
  <xsl:variable name="revdate"   select=".//date"/>
  <xsl:variable name="revremark" select=".//revremark|.//revdescription"/>
  <xsl:variable name="revauthor" select=".//authorinitials|.//author"/>
  <xsl:text>~\par&#10;</xsl:text>
  <!-- Elements de la revision -->
  <xsl:if test="$revnumber">
    <xsl:apply-templates select="$revnumber"/>
  </xsl:if>
  <xsl:text>~\par&#10;</xsl:text>
  <xsl:text>&#10;&amp; </xsl:text>
  <xsl:text>~\par&#10;</xsl:text>
  <xsl:apply-templates select="$revdate"/>
  <xsl:text>&#10;&amp; </xsl:text>
  <xsl:text>~\par&#10;</xsl:text>
  <xsl:if test="$revremark"> 
    <xsl:apply-templates select="$revremark"/> 
  </xsl:if>
  <xsl:text>&#10;&amp; </xsl:text>
  <xsl:text>~\par&#10;</xsl:text>
  <xsl:if test="count($revauthor)!=0">
    <xsl:apply-templates select="$revauthor"/>
  </xsl:if>
  <xsl:text>&#10;\tabularnewline&#10;</xsl:text>
  <xsl:text>\hline&#10;</xsl:text>
</xsl:template>

<xsl:template match="revision/revnumber">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/date">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/authorinitials">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/authorinitials[1]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/revremark">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="revision/revdescription">
  <xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
