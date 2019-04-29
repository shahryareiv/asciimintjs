<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="listings.xml"/>


<xsl:template name="line.pad">
  <xsl:param name="count"/>
  <xsl:if test="$count &gt; 0">
    <xsl:text> </xsl:text>
    <xsl:call-template name="line.pad">
      <xsl:with-param name="count" select="$count - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- Recursively insert <co> elements in the listing text -->
<xsl:template name="insert.co">
  <xsl:param name="text"/>
  <xsl:param name="areas"/>
  <xsl:param name="areaid" select="'1'"/>
  <xsl:param name="line" select="'1'"/>
  <xsl:param name="col" select="'1'"/>

  <xsl:variable name="area" select="$areas[position()=$areaid]"/>
  <xsl:variable name="arealine">
    <xsl:choose>
    <xsl:when test="contains($area/@coords, ' ')">
      <xsl:value-of select="substring-before($area/@coords, ' ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$area/@coords"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="areacol" select="substring-after($area/@coords, ' ')"/>

  <xsl:choose>
  <xsl:when test="string-length($text)=0">
    <!-- no more text in this listing -->
  </xsl:when>
  <xsl:when test="not($area)">
    <!-- no more <co> to insert, copy the rest of the text -->
    <xsl:value-of select="$text"/>
  </xsl:when>
  <xsl:when test="$arealine &gt; $line">
    <!-- print the lines until we reach the <area> coord line -->
    <!-- print the end of the current line -->
    <xsl:value-of select="substring-before($text, '&#10;')"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="insert.co">
      <xsl:with-param name="text" select="substring-after($text, '&#10;')"/>
      <xsl:with-param name="line" select="$line+1"/>
      <xsl:with-param name="areaid" select="$areaid"/>
      <xsl:with-param name="areas" select="$areas"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <!-- line length -->
    <xsl:variable name="strlen">
      <xsl:choose>
      <xsl:when test="contains($text, '&#10;')">
        <xsl:value-of select="string-length(substring-before($text, '&#10;'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string-length($text)"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- relative column position -->
    <xsl:variable name="colpos">
      <xsl:value-of select="$areacol - $col"/>
    </xsl:variable>

    <!-- padding count -->
    <xsl:variable name="padlen">
      <xsl:choose>
      <xsl:when test="$areacol!='' and ($colpos &gt; $strlen)">
        <xsl:value-of select="$colpos - $strlen"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'0'"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- number of characters before <co> to print -->
    <xsl:variable name="count">
      <xsl:choose>
      <xsl:when test="$areacol='' or ($padlen &gt; 0)">
        <xsl:value-of select="$strlen"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$colpos"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- line part to insert before <co> -->
    <xsl:if test="$count &gt; 0">
      <xsl:value-of select="substring($text,1,$count)"/>
    </xsl:if>

    <!-- insert padding spaces -->
    <xsl:if test="$padlen &gt; 0">
      <xsl:call-template name="line.pad">
        <xsl:with-param name="count" select="$padlen"/>
      </xsl:call-template>
    </xsl:if>

    <!-- <co> to insert for this line -->
    <co>
      <xsl:for-each select="$area/@id|$area/@xml:id|$area/@linkends">
        <xsl:copy/></xsl:for-each>
    </co>
    <!-- continue, for the next <area> if any -->
    <xsl:call-template name="insert.co">
      <xsl:with-param name="text" select="substring($text,$count+1)"/>
      <xsl:with-param name="line" select="$line"/>
      <xsl:with-param name="areaid" select="$areaid+1"/>
      <xsl:with-param name="areas" select="$areas"/>
      <xsl:with-param name="col" select="$col+$count"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template match="programlisting|screen" mode="build.listing.co">
  <xsl:param name="listing"/>
  <xsl:param name="areas"/>

  <xsl:variable name="content">
    <xsl:apply-templates mode="latex.programlisting"/>
  </xsl:variable>

  <xsl:element name="{local-name($listing)}">
    <!-- Inherit the original attributes -->
    <xsl:for-each select="$listing/@*">
      <xsl:copy/>
    </xsl:for-each>

    <xsl:call-template name="insert.co">
      <xsl:with-param name="text" select="$content"/>
      <xsl:with-param name="areas" select="$areas"/>
    </xsl:call-template>
  </xsl:element>

</xsl:template>


<xsl:template match="programlistingco|screenco">
  <!-- Build a new listing with the embedded <co> -->
  <xsl:variable name="newlisting">
    <xsl:apply-templates select="programlisting|screen" mode="build.listing.co">
      <xsl:with-param name="listing" select="programlisting|screen"/>
      <xsl:with-param name="areas" select="areaspec//area"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:apply-templates select="exsl:node-set($newlisting)/*">
    <xsl:with-param name="rnode" select="calloutlist"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="calloutlist">
    <xsl:with-param name="rnode" select="exsl:node-set($newlisting)"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="areaspec|areaset|area"/>


<!-- Process the external files referenced in a programlistingco or screenco
     environment. Since in XSLT 1.0 you cannot directly include text files, the
     workaround is to load the data from a listings database file. -->

<xsl:template match="textdata|
                     imagedata[@format='linespecific']|
                     inlinegraphic[@format='linespecific']"
              mode="latex.programlisting">

  <xsl:variable name="name" select="name(.)"/>
  <xsl:variable name="lst.doc" select="document($listings.xml)"/>
  <xsl:variable name="lst.id">
    <xsl:apply-templates select="." mode="lstid"/>
  </xsl:variable>
  <xsl:variable name="lst.ext"
      select="$lst.doc/listings/listing[@type=$name][@lstid=$lst.id]"/>

  <xsl:if test="$output.quietly = 0">
    <xsl:message><xsl:text>Load external file </xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$lst.id"/>
      <xsl:text>]</xsl:text>
      <xsl:if test="not($lst.ext)">
        <xsl:text>(failed)</xsl:text> 
      </xsl:if>
    </xsl:message>
  </xsl:if>

  <xsl:apply-templates mode="latex.programlisting" select="$lst.ext"/>
</xsl:template>

<!-- The intermediate elements in external file handling just apply
     the templates in the same mode. -->
<xsl:template match="textobject|listing"
              mode="latex.programlisting">
  <xsl:apply-templates mode="latex.programlisting"/>
</xsl:template>


<xsl:template match="textdata|
                     imagedata[@format='linespecific']|
                     inlinegraphic[@format='linespecific']" mode="lstid">
  <xsl:number from="/"
              level="any"
              format="1"/>
</xsl:template>

</xsl:stylesheet>
