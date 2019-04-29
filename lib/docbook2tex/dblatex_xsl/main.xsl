<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ng="http://docbook.org/docbook-ng"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="db ng exsl"
                version="1.0">

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="*" mode="info.copy">
  <xsl:for-each select="(info
                        |referenceinfo
                        |refentryinfo
                        |articleinfo
                        |sectioninfo
                        |appendixinfo
                        |bibliographyinfo
                        |chapterinfo
                        |sect1info
                        |sect2info
                        |sect3info
                        |sect4info
                        |sect5info
                        |partinfo
                        |prefaceinfo
                        |docinfo)[1]/child::*">
    <xsl:copy-of select=".|@*"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="/" mode="doc-wrap-with">
  <xsl:param name="root"/>
  <xsl:variable name="rootnode" select="./*[1]"/>
  <xsl:message>
    <xsl:text>Warning: </xsl:text>
    <xsl:value-of select="local-name($rootnode)"/>
    <xsl:if test="$rootnode/@id or $rootnode/@xml:id">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="($rootnode/@id|$rootnode/@xml:id)[1]"/>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text> wrapped with </xsl:text>
    <xsl:value-of select="$root"/>
  </xsl:message>

  <xsl:element name="{$root}">
    <!-- Get the node attributes -->
    <xsl:for-each select="node()/@*[not(id)]">
      <xsl:copy-of select="."/>
    </xsl:for-each>

    <!-- Get titles from the node -->
    <xsl:for-each select="node()/title|node()/subtitle|node()/titleabbrev">
      <xsl:copy-of select="."/>
    </xsl:for-each>

    <!-- Take the infos from the node -->
    <xsl:element name="{$root}info">
      <xsl:apply-templates select="node()" mode="info.copy"/>
    </xsl:element>

    <!-- Now the wrapped node -->
    <xsl:copy-of select="node()|@*"/>
  </xsl:element>
</xsl:template>


<xsl:template match="/" mode="doc-wrap">
  <xsl:message>
    <xsl:text>Warning: the root element is not an article nor a book</xsl:text>
  </xsl:message>
  <xsl:variable name="root">
    <xsl:choose>
    <xsl:when test="part|chapter">
      <xsl:value-of select="'book'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'article'"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="rnode">
    <xsl:apply-templates select="." mode="doc-wrap-with">
      <xsl:with-param name="root" select="$root"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- Process the DocBook document subset -->
  <xsl:apply-templates select="exsl:node-set($rnode)/*" mode="wrapper"/>
</xsl:template>


<xsl:template match="/">
  <xsl:param name="rfs" select="0"/>
  <xsl:if test="$rfs = 0 and $output.quietly = 0">
    <xsl:message>
    <xsl:text>XSLT stylesheets DocBook - LaTeX 2e </xsl:text>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$version"/><xsl:text>)</xsl:text>
    </xsl:message>
    <xsl:message>===================================================</xsl:message>
  </xsl:if>
  <xsl:choose>
  <xsl:when test="set|book|article">
    <xsl:apply-templates/>
  </xsl:when>
  <xsl:when test="function-available('exsl:node-set')
                  and (*/self::ng:* or */self::db:*)">
    <xsl:if test="$output.quietly = 0">
      <xsl:message>Stripping NS from DocBook 5/NG document.</xsl:message>
    </xsl:if>
    <xsl:variable name="nons">
      <xsl:apply-templates mode="stripNS"/>
    </xsl:variable>
    <xsl:if test="$output.quietly = 0">
      <xsl:message>Processing stripped document.</xsl:message>
    </xsl:if>
    <xsl:apply-templates select="exsl:node-set($nons)">
      <xsl:with-param name="rfs" select="1"/>
    </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="." mode="doc-wrap"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- DocBook NG/V5 translated to DocBook V4, taken from the
     DocBook XSL Stylesheets
  -->

<xsl:template match="*" mode="stripNS">
  <xsl:choose>
    <xsl:when test="self::ng:* or self::db:*">
      <xsl:element name="{local-name(.)}">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="stripNS"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="stripNS"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ng:link|db:link" mode="stripNS">
  <xsl:variable xmlns:xlink="http://www.w3.org/1999/xlink"
                name="href" select="@xlink:href|@href"/>
  <xsl:choose>
    <xsl:when test="$href != '' and not(starts-with($href,'#'))">
      <ulink url="{$href}">
        <xsl:for-each select="@*">
          <xsl:if test="local-name(.) != 'href'">
            <xsl:copy/>
          </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates mode="stripNS"/>
      </ulink>
    </xsl:when>
    <xsl:when test="$href != '' and starts-with($href,'#')">
      <link linkend="{substring-after($href,'#')}">
        <xsl:for-each select="@*">
          <xsl:if test="local-name(.) != 'href'">
            <xsl:copy/>
          </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates mode="stripNS"/>
      </link>
    </xsl:when>
    <xsl:otherwise>
      <link>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="stripNS"/>
      </link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()" mode="stripNS">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>

