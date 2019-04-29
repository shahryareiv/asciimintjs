<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template name="pdf-document-information">
  <xsl:param name="pdfauthor"/>

  <xsl:variable name="pdftitle">
    <xsl:apply-templates select="(title
                                 |info/title
                                 |bookinfo/title
                                 |articleinfo/title
                                 |artheader/title)[1]" mode="pdfmeta"/>
  </xsl:variable>

  <xsl:variable name="pdfsubject">
    <xsl:if test="//subjectterm">
      <xsl:for-each select="//subjectterm">
        <xsl:apply-templates select="." mode="pdfmeta"/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="pdfkeywords">
    <xsl:if test="//keyword">
      <xsl:for-each select="//keyword">
        <xsl:apply-templates select="." mode="pdfmeta"/>
        <xsl:if test="position() != last()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>


  <xsl:text>\hypersetup{%&#10;</xsl:text>
  <xsl:if test="$doc.pdfcreator.show='1'">
    <xsl:text>pdfcreator={DBLaTeX-</xsl:text>
    <xsl:value-of select="$version"/>
    <xsl:text>},%&#10;</xsl:text>
  </xsl:if>

  <xsl:text>pdftitle={</xsl:text>
  <xsl:value-of select="$pdftitle"/>
  <xsl:text>},%&#10;</xsl:text>
  
  <xsl:text>pdfauthor={</xsl:text>
  <xsl:value-of select="$pdfauthor"/>
  <xsl:text>}</xsl:text>

  <xsl:if test="$pdfsubject != ''">
    <xsl:text>,%&#10;</xsl:text>
    <xsl:text>pdfsubject={</xsl:text>
    <xsl:value-of select="normalize-space($pdfsubject)"/>
    <xsl:text>}</xsl:text>
  </xsl:if>

  <xsl:if test="$pdfkeywords != ''">
    <xsl:text>,%&#10;</xsl:text>
    <xsl:text>pdfkeywords={</xsl:text>
    <xsl:value-of select="normalize-space($pdfkeywords)"/>
    <xsl:text>}</xsl:text>
  </xsl:if>

  <xsl:text>}&#10;</xsl:text>
</xsl:template>


<!-- In PDF metadata, no formatting required, just text content -->
<xsl:template match="title|keyword|subjectterm" mode="pdfmeta">
  <xsl:apply-templates mode="pdfmeta"/>
</xsl:template>

<xsl:template match="text()" mode="pdfmeta">
  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>
