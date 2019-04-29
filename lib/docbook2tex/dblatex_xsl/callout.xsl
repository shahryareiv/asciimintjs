<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Callout parameters -->
<xsl:param name="co.tagout" select="'&lt;/t&gt;'"/>
<xsl:param name="co.linkends.show" select="'1'"/>
<xsl:param name="callout.markup.circled" select="'1'"/>
<xsl:param name="callout.linkends.hot" select="'1'"/>
<xsl:param name="calloutlist.style" select="'leftmargin=1cm,style=sameline'"/>

<!-- Prerequesite: the following latex macros are defined:
     * \co{text}
     * \coref{text}{label}
     * \colabel{label}
     * \collabel{label}
-->


<!-- Generate the enter TeX escape sequence for <co>. The principle is to
     find the first sequence of the form "<[try]" that is not contained in
     the listing, to ensure that no conflict will occur with lstlisting -->

<xsl:template name="co-tagin-gen">
  <xsl:param name="text" select="."/>
  <xsl:param name="try" select="'0'"/>
  <xsl:variable name="tag">
    <xsl:text>&lt;</xsl:text>
    <xsl:if test="$try &gt; 0">
      <xsl:value-of select="$try"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="contains($text, $tag)">
    <!-- <xsl:message>Try another escape sequence in verbatim</xsl:message> -->
    <xsl:call-template name="co-tagin-gen">
      <xsl:with-param name="text" select="$text"/>
      <xsl:with-param name="try" select="$try+1"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <!-- Ok, this sequence can be used safely -->
    <xsl:value-of select="$tag"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Create the link to the referenced element -->
<xsl:template name="coref.link.create">
  <xsl:param name="ref"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="circled" select="0"/>

  <!-- Cannot use directly id() because it must work on several RTF -->
  <!-- The element is also searched in the root tree for things stripped
       in the RTF, like <areaset>s -->
  <xsl:variable name="coitem"
                select="($rnode//*[@id=$ref or @xml:id=$ref]|
                        //*[@id=$ref or @xml:id=$ref])[1]"/>
  <xsl:apply-templates select="$coitem" mode="coref.link">
    <xsl:with-param name="circled" select="$circled"/>
    <xsl:with-param name="from" select="local-name(.)"/>
  </xsl:apply-templates>
</xsl:template>


<!-- Create the link to a <co> (maybe via <area>) or a <callout> -->
<xsl:template match="co|area|callout" mode="coref.link">
  <xsl:param name="circled" select="0"/>
  <xsl:param name="from"/>
  <xsl:variable name="coval">
    <xsl:apply-templates select="." mode="conumber"/>
  </xsl:variable>

  <!-- The markup can be a bubble or a simple number -->
  <xsl:variable name="markup">
    <xsl:choose>
    <xsl:when test="$circled != 0">
      <xsl:text>\conum{</xsl:text>
      <xsl:value-of select="$coval"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:when test="$from='callout' and $callout.markup.circled='1'">
      <xsl:text>\conum{</xsl:text>
      <xsl:value-of select="$coval"/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$coval"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- In <callout> the markup can be not hot -->
  <xsl:choose>
  <xsl:when test="$callout.linkends.hot='0' and $from='callout'">
    <xsl:value-of select="$markup"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\hyperref[</xsl:text>
    <xsl:value-of select="(@id|@xml:id)[1]"/>
    <xsl:text>]{</xsl:text>
    <xsl:value-of select="$markup"/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- A link to an areaset means linking to each contained <area> -->
<xsl:template match="areaset" mode="coref.link">
  <xsl:param name="circled" select="0"/>
  <xsl:param name="from"/>
  <xsl:for-each select="area">
    <xsl:apply-templates select="." mode="coref.link">
      <xsl:with-param name="circled" select="$circled"/>
      <xsl:with-param name="from" select="$from"/>
    </xsl:apply-templates>
    <xsl:if test="position()!=last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<!-- Split and make the references of the arearefs/linkends list -->
<xsl:template name="corefs.split">
  <xsl:param name="refs"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:choose>
  <xsl:when test="contains($refs, ' ')">
    <xsl:call-template name="coref.link.create">
      <xsl:with-param name="ref" select="substring-before($refs, ' ')"/>
      <xsl:with-param name="rnode" select="$rnode"/>
    </xsl:call-template>
    <xsl:text>, </xsl:text>
    <xsl:call-template name="corefs.split">
      <xsl:with-param name="refs" select="substring-after($refs, ' ')"/>
      <xsl:with-param name="rnode" select="$rnode"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="coref.link.create">
      <xsl:with-param name="ref" select="$refs"/>
      <xsl:with-param name="rnode" select="$rnode"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="co|area" mode="linkends.create">
  <xsl:param name="rnode" select="/"/>
  <xsl:if test="@linkends and $co.linkends.show='1'">
    <xsl:text>[</xsl:text>
    <xsl:call-template name="corefs.split">
      <xsl:with-param name="refs" select="normalize-space(@linkends)"/>
      <xsl:with-param name="rnode" select="$rnode"/>
    </xsl:call-template>
    <xsl:text>]</xsl:text>
  </xsl:if>
</xsl:template>


<xsl:template match="co|area" mode="latex.programlisting">
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="co-tagout" select="$co.tagout"/>
  <xsl:param name="co-hide" select="0"/>
  <xsl:variable name="conum">
    <xsl:apply-templates select="." mode="conumber"/>
  </xsl:variable>
  <xsl:variable name="id" select="(@id|@xml:id)[1]"/>

  <xsl:if test="$co-tagin != ''">
    <xsl:value-of select="concat($co-tagin, 't>')"/>
  </xsl:if>
  <xsl:choose>
  <xsl:when test="$co-hide != 0">
    <xsl:if test="$id">
      <xsl:text>\colabel{</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
  </xsl:when>
  <xsl:when test="$id">
    <xsl:text>\coref{</xsl:text>
    <xsl:value-of select="$conum"/>
    <xsl:text>}{</xsl:text>
    <xsl:value-of select="$id"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\co{</xsl:text>
    <xsl:value-of select="$conum"/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="." mode="linkends.create">
    <xsl:with-param name="rnode" select="$rnode"/>
  </xsl:apply-templates>
  <xsl:value-of select="$co-tagout"/>
</xsl:template>


<!-- Print the markup of the co referenced by coref -->
<xsl:template match="coref" mode="latex.programlisting">
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="co-tagout" select="$co.tagout"/>
  <xsl:variable name="linkend" select="@linkend"/>
  <xsl:variable name="co" select="$rnode//*[@id=$linkend or @xml:id=$linkend]"/>

  <xsl:choose>
  <xsl:when test="$co">
    <xsl:variable name="conum">
      <xsl:apply-templates select="$co" mode="conumber"/>
    </xsl:variable>
    <!-- Entry tex sequence -->
    <xsl:value-of select="concat($co-tagin, 't>')"/>
    <!-- The same number mark than the pointed <co> -->
    <xsl:text>\conum{</xsl:text>
    <xsl:value-of select="$conum"/>
    <xsl:text>}</xsl:text>
    <!-- Display also the <co> linkends -->
    <xsl:apply-templates select="$co" mode="linkends.create">
      <xsl:with-param name="rnode" select="$rnode"/>
    </xsl:apply-templates>
    <!-- Exit tex sequence -->
    <xsl:value-of select="$co-tagout"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:message>
      <xsl:text>*** Invalid coref/@linkend='</xsl:text>
      <xsl:value-of select="@linkend"/>
      <xsl:text>'</xsl:text>
    </xsl:message>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- List of the callouts descriptions -->
<xsl:template match="calloutlist">
  <xsl:param name="rnode" select="/"/>
  <xsl:apply-templates select="title"/>
  <xsl:text>&#10;\begin{description}&#10;</xsl:text>
  <xsl:if test="$calloutlist.style != ''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$calloutlist.style"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="callout" mode="item">
    <xsl:with-param name="rnode" select="$rnode"/>
  </xsl:apply-templates>
  <xsl:text>\end{description}&#10;</xsl:text>
</xsl:template>

<!-- Callout Description -->
<xsl:template match="callout" mode="item">
  <xsl:param name="rnode" select="/"/>
  <xsl:text>\item[{</xsl:text>
  <xsl:call-template name="corefs.split">
    <xsl:with-param name="refs" select="normalize-space(@arearefs)"/>
    <xsl:with-param name="rnode" select="$rnode"/>
  </xsl:call-template>
  <xsl:text>}]</xsl:text>
  <xsl:if test="(@id|@xml:id) and $co.linkends.show='1'">
    <xsl:text>\collabel{</xsl:text>
    <xsl:value-of select="(@id|@xml:id)[1]"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<!-- Callout list title -->
<xsl:template match="calloutlist/title">
  <xsl:text>&#10;{\bf </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select=".."/>
  </xsl:call-template>
  <!-- Ask to latex to let the title with its list -->
  <xsl:text>\nopagebreak&#10;</xsl:text>
</xsl:template>


<!-- Callout numbering -->
<xsl:template match="co|callout" mode="conumber">
  <xsl:number from="literallayout|programlisting|screen|synopsis|calloutlist"
              level="any"
              format="1"/>
</xsl:template>

<xsl:template match="area" mode="conumber">
  <xsl:number from="areaspec"
              level="any"
              format="1"/>
</xsl:template>

</xsl:stylesheet>
