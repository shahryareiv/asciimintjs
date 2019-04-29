<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template name="nolinkurl">
  <xsl:param name="url" select="@url"/>
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:value-of select="$command"/>
  <xsl:text>{</xsl:text>
  <xsl:call-template name="scape-encode">
    <xsl:with-param name="string" select="$url"/>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- The funny thing is that in table cells, it fails if the URL ends with a
     '\'. The workaround is to append a space. Moreover, the problem occurs only
     if the ending '\'s are non a multiple of 2!
-->
<xsl:template name="nolinkurl2">
  <xsl:param name="url" select="@url"/>
  <xsl:param name="command" select="'\nolinkurl'"/>
  <!-- Ignore the URL that contains only a '\n' -->
  <xsl:if test="$url != '&#10;'">
    <xsl:variable name="bscount">
      <xsl:call-template name="bslash-end-count">
        <xsl:with-param name="url" select="$url"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$command"/>
    <xsl:text>{</xsl:text>
    <xsl:call-template name="scape-encode">
      <xsl:with-param name="string" select="$url"/>
    </xsl:call-template>
    <xsl:if test="$bscount mod 2">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Count the number of '\' ending the url (only for entries) -->
<xsl:template name="bslash-end-count">
  <xsl:param name="count" select="0"/>
  <xsl:param name="url"/>

  <xsl:choose>
  <xsl:when test="$url = ''">
    <xsl:value-of select="$count"/>
  </xsl:when>
  <xsl:when test="substring($url,string-length($url))='\'">
    <xsl:call-template name="bslash-end-count">
      <xsl:with-param name="url"
                      select="substring($url,1,string-length($url)-1)"/>
      <xsl:with-param name="count" select="$count + 1"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$count"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Only URLs in table cells must be escaped (mostly because of multicolumn)
     except for spaces that are always skipped by \nolinkurl{}. Note that
     setting the 'obeyspaces' option to the url package doesn't help.
     -->
<xsl:template name="nolinkurl-output">
  <xsl:param name="url" select="@url"/>
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:variable name="url2">
    <xsl:choose>
      <!-- Behaviour depending on the texlive version -->
      <xsl:when test="number($texlive.version) &gt;= 2009">
        <xsl:call-template name="string-replace">
          <xsl:with-param name="string" select="$url"/>
          <xsl:with-param name="from" select="'\'"/>
          <xsl:with-param name="to" select="'\\'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$url"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="ancestor::entry or ancestor::revision or ancestor::footnote">
    <xsl:call-template name="nolinkurl-escape">
      <xsl:with-param name="url" select="$url2"/>
      <xsl:with-param name="command" select="$command"/>
    </xsl:call-template>
    <!-- FIXME: do something with '&' and revision if needed -->
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="nolinkurl-escape">
      <xsl:with-param name="url" select="$url2"/>
      <xsl:with-param name="chars" select="' '"/>
      <xsl:with-param name="command" select="$command"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Find the first special char position in the string -->
<xsl:template name="find-first">
  <xsl:param name="string"/>
  <xsl:param name="chars" select="'#% '"/>

  <xsl:choose>
  <xsl:when test="$string = ''">
    <xsl:value-of select="0"/>
  </xsl:when>
  <xsl:when test="string-length($chars)=1">
    <xsl:choose>
    <xsl:when test="contains($string, $chars)">
      <xsl:value-of select="string-length(substring-before($string, $chars))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="string-length($string)"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="charset" select="substring($chars, 2)"/>
    <xsl:variable name="char" select="substring($chars, 1, 1)"/>
    <xsl:choose>
    <xsl:when test="contains($string, $char)">
      <xsl:call-template name="find-first">
        <xsl:with-param name="string" select="substring-before($string, $char)"/>
        <xsl:with-param name="chars" select="$charset"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="find-first">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="chars" select="$charset"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
<xsl:template name="nolinkurl-escape">
  <xsl:param name="escchars"/>
  <xsl:param name="url"/>
  <xsl:param name="chars" select="'#% '"/>
  <xsl:param name="command" select="'\nolinkurl'"/>

  <xsl:variable name="len" select="string-length($url)"/>

  <xsl:variable name="pos">
    <xsl:call-template name="find-first">
      <xsl:with-param name="string" select="$url"/>
      <xsl:with-param name="chars" select="$chars"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$pos = $len">
    <xsl:if test="$escchars != ''">
      <xsl:text>\texttt{</xsl:text>
      <xsl:value-of select="$escchars"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:if test="$len != 0">
      <xsl:call-template name="nolinkurl2">
        <xsl:with-param name="url" select="$url"/>
        <xsl:with-param name="command" select="$command"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:when>
  <xsl:when test="$pos = 0">
    <xsl:call-template name="nolinkurl-escape">
      <xsl:with-param name="escchars"
                      select="concat($escchars, '\', substring($url,1,1))"/>
      <xsl:with-param name="url" select="substring($url, 2)"/>
      <xsl:with-param name="chars" select="$chars"/>
      <xsl:with-param name="command" select="$command"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="$escchars != ''">
      <xsl:text>\texttt{</xsl:text>
      <xsl:value-of select="$escchars"/>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:call-template name="nolinkurl2">
      <xsl:with-param name="url" select="substring($url, 1, $pos)"/>
      <xsl:with-param name="command" select="$command"/>
    </xsl:call-template>
    <xsl:call-template name="nolinkurl-escape">
      <xsl:with-param name="escchars"
                      select="concat('\', substring($url,$pos+1,1))"/>
      <xsl:with-param name="url" select="substring($url, $pos+2)"/>
      <xsl:with-param name="chars" select="$chars"/>
      <xsl:with-param name="command" select="$command"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Template for a unit-test:
     <u>
       <nolinkurl>ab%cde%#%fg</nolinkurl>
       <nolinkurl>#ab%cde%#%fg###</nolinkurl>
       <nolinkurl>nothing special</nolinkurl>
       <nolinkurl>nothing\special\</nolinkurl>
       <nolinkurl>nothing\special\\</nolinkurl>
       <entry>
         <nolinkurl>ab%cde%#%fg</nolinkurl>
         <nolinkurl>#%#ab%cde%#%fg###</nolinkurl>
         <nolinkurl>nothing special</nolinkurl>
         <nolinkurl>#########</nolinkurl>
         <nolinkurl>%%%%%%%%%</nolinkurl>
         <nolinkurl>#%#%%#%##</nolinkurl>
       </entry>
     </u>

     Expected:
     \nolinkurl{ab%cde%#%fg}
     \nolinkurl{#ab%cde%#%fg###}
     \nolinkurl{nothing}\texttt{\ }\nolinkurl{special}
     \nolinkurl{nothing\special\ }
     \nolinkurl{nothing\special\\}
     <entry>
       \nolinkurl{ab}\texttt{\%}\nolinkurl{cde}\texttt{\%\#\%}\nolinkurl{fg}
       \texttt{\#\%\#}\nolinkurl{ab}\texttt{\%}\nolinkurl{cde}\texttt{\%\#\%}\nolinkurl{fg}\texttt{\#\#\#}
       \nolinkurl{nothing}\texttt{\ }\nolinkurl{special}
       \texttt{\#\#\#\#\#\#\#\#\#}
       \texttt{\%\%\%\%\%\%\%\%\%}
       \texttt{\#\%\#\%\%\#\%\#\#}
     </entry>

-->
<xsl:template match="nolinkurl">
  <xsl:call-template name="nolinkurl-output">
    <xsl:with-param name="url" select="."/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
