<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                version='1.0'>

<xsl:output method="text" indent="yes"/>

<!-- Print out the filenames of the books to compile from a <set>. This
     stylesheet cannot be used standalone, because the following parameters must
     exist:

      <xsl:param name="use.id.as.filename" select="0"/>
      <xsl:param name="set.book.num" select="1"/>
     
     The output method is text, in order to be compatible with the imported
     dblatex XSL stylesheets output method.
-->

<xsl:template match="book" mode="give.basename">
  <xsl:choose>
    <xsl:when test="not(@id) or $use.id.as.filename = 0">
      <xsl:value-of select="concat('book', position())"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@id"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="/">
  <xsl:if test="$set.book.num = 'all'">
    <xsl:apply-templates select="//book[parent::set]" mode="give.basename"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
