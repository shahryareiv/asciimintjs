<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="set.book.num">1</xsl:param>


<!-- ################
     # Set of books #
     ################ -->

<!-- Handle all the books or a single book -->
<xsl:template match="set">
  <xsl:choose>
  <xsl:when test="$set.book.num = 'all'">
    <xsl:if test="$output.quietly = 0">
      <xsl:message>Output all the books from the set</xsl:message>
    </xsl:if>
    <!-- Write a latex file per book -->
    <xsl:apply-templates select="//book" mode="build.texfile"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:message>
      <xsl:text>Warning: only print the book [</xsl:text>
      <xsl:value-of select="$set.book.num"/>
      <xsl:text>]</xsl:text>
    </xsl:message>
    <xsl:apply-templates select="//book[position()=$set.book.num]"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Chunk a tex file per book -->
<xsl:template match="book" mode="build.texfile">
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename">
      <xsl:call-template name="bookname"/>
      <xsl:text>.rtex</xsl:text>
    </xsl:with-param>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:apply-templates select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- Print out the book filename formatted according to <template> -->
<xsl:template match="book" mode="bookname" name="bookname">
  <xsl:param name="template" select="'%b'"/>
  <xsl:param name="exclude-gid"/>

  <xsl:variable name="local-gid">
    <xsl:apply-templates select="." mode="booknumber"/>
  </xsl:variable>

  <xsl:if test="$local-gid != $exclude-gid">
    <xsl:variable name="basename">
      <xsl:choose>
      <xsl:when test="(not(@id) and not(@xml:id)) or $use.id.as.filename = 0">
        <xsl:value-of select="concat('book', $local-gid)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="(@id|@xml:id)[1]"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="string-replace">
      <xsl:with-param name="string" select="$template"/>
      <xsl:with-param name="from" select="'%b'"/>
      <xsl:with-param name="to" select="$basename"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- Give the list of the external documents that xr-hyper must know.
     This template must be called in the latex book preamble.
     -->
<xsl:template name="make.external.docs">
  <!-- The list must contain only external books, not the current one -->
  <xsl:variable name="local-gid">
    <xsl:apply-templates select="." mode="booknumber"/>
  </xsl:variable>

  <!-- The list is meaningful only if several books are printed out -->
  <xsl:if test="$set.book.num = 'all'">
    <xsl:apply-templates select="//book[parent::set]" mode="bookname">
      <xsl:with-param name="template"
                      select="'\externaldocument{%b}[%b]&#10;'"/>
      <xsl:with-param name="exclude-gid" select="$local-gid"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>


<xsl:template match="set/setinfo"></xsl:template>
<xsl:template match="set/title"></xsl:template>
<xsl:template match="set/subtitle"></xsl:template>


<!-- Book numbering -->
<xsl:template match="book" mode="booknumber">
  <xsl:number from="/"
              level="any"
              format="1"/>
</xsl:template>

</xsl:stylesheet>
