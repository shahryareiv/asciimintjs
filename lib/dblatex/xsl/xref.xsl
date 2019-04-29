<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="xref.hypermarkup" select="0"/>
<xsl:param name="ulink.block.symbol">\textbullet</xsl:param>


<xsl:template match="anchor">
  <xsl:call-template name="label.id">
    <xsl:with-param name="inline" select="1"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="hyperlink.markup">
  <xsl:param name="referrer" select="." />
  <xsl:param name="linkend"/>
  <xsl:param name="text"/>

  <xsl:variable name="targetbook"
                select="key('id',$linkend)/ancestor-or-self::book"/>

  <xsl:variable name="referbook"
                select="$referrer/ancestor-or-self::book"/>

  <xsl:variable name="referrer_i">
    <xsl:apply-templates select="$referbook" mode="booknumber"/>
  </xsl:variable>

  <xsl:variable name="target_i">
    <xsl:apply-templates select="$targetbook" mode="booknumber"/>
  </xsl:variable>

  <!-- The URL is local only if the target is in the referrer book -->
  <xsl:choose>
  <xsl:when test="$referrer_i != $target_i">
    <xsl:text>\href{</xsl:text>
    <xsl:apply-templates select="$targetbook" mode="bookname"/>
    <xsl:value-of select="concat('\#',$linkend)" />
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\hyperlink{</xsl:text>
    <xsl:value-of select="$linkend"/>
  </xsl:otherwise>
  </xsl:choose>
  <!-- The hot text -->
  <xsl:text>}{</xsl:text>
  <xsl:value-of select="$text"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="object.xref.markup2">
  <xsl:param name="purpose" select="'xref'"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="markup">
    <xsl:apply-templates select="." mode="object.xref.markup">
      <xsl:with-param name="purpose" select="$purpose"/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      <xsl:with-param name="referrer" select="$referrer"/>
      <xsl:with-param name="verbose" select="$verbose"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:choose>
    <!-- Wrap with an hyperlink if asked and if it is not already a link -->
    <xsl:when test="$xref.hypermarkup=1 and 
                    not(contains($markup, '\hyperlink{') or
                        contains($markup, '\href{'))">
      <!-- Get the normal markup but replace hot links by counters -->
      <xsl:variable name="text">
        <xsl:call-template name="string-replace">
          <xsl:with-param name="string" select="$markup"/>
          <xsl:with-param name="from" select="'ref{'"/>
          <xsl:with-param name="to" select="'ref*{'"/>
        </xsl:call-template>
      </xsl:variable>
      <!-- Wrap the markup with an hyperlink -->
      <xsl:call-template name="hyperlink.markup">
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$markup"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xref|biblioref" mode="xref.text">
  <xsl:variable name="target" select="key('id',@linkend)[1]"/>
  <xsl:choose>
  <!-- If there is an endterm -->
  <xsl:when test="@endterm">
    <xsl:variable name="etarget" select="key('id',@endterm)[1]"/>
    <xsl:choose>
    <xsl:when test="count($etarget) = 0">
      <xsl:message>
        <xsl:text>Endterm points to nonexistent ID: </xsl:text>
        <xsl:value-of select="@endterm"/>
      </xsl:message>
      <xsl:text>[??]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$etarget" mode="xref.text"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <!-- If an xreflabel has been specified for the target -->
  <xsl:when test="$target/@xreflabel">
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="$target/@xreflabel"/>
    </xsl:call-template>
  </xsl:when>
  <!-- nothing specified -->
  <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template match="xref" name="xref">
  <xsl:variable name="target" select="key('id',@linkend)[1]"/>

  <xsl:call-template name="check.id.unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <xsl:variable name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="count($target)=0">
    <xsl:message>
      <xsl:text>XRef to nonexistent id: </xsl:text>
      <xsl:value-of select="@linkend"/>
    </xsl:message>
    <xsl:text>[?]</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="text">
      <xsl:apply-templates select="." mode="xref.text"/>
    </xsl:variable>

    <!-- how to print it -->
    <xsl:choose>
    <xsl:when test="$text!=''">
      <xsl:call-template name="hyperlink.markup">
        <xsl:with-param name="linkend" select="@linkend"/>
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$target" mode="xref-to">
        <xsl:with-param name="referrer" select="."/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>

  <!-- Add standard page reference? -->
  <xsl:choose>
  <xsl:when test="self::biblioref">
    <!-- no page number for a biblio reference -->
  </xsl:when>
  <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:') 
                  and contains($xrefstyle, 'nopage')">
    <!-- negative xrefstyle in instance turns it off -->
  </xsl:when>
  <xsl:when test="not(starts-with(normalize-space($xrefstyle), 'select:') 
                and (contains($xrefstyle, 'page')
                     or contains($xrefstyle, 'Page')))
                and ( $insert.xref.page.number = 'yes' 
                   or $insert.xref.page.number = '1')
                or (local-name($target) = 'para'
                    and $xrefstyle = ''
                    and $insert.xref.page.number.para = 'yes')">
    <xsl:apply-templates select="$target" mode="page.citation">
      <xsl:with-param name="id" select="@linkend"/>
    </xsl:apply-templates>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Currently no begin, end, units supports, so handle like xref -->
<xsl:template match="biblioref">
  <xsl:call-template name="xref"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="ulink-encode">
  <xsl:param name="escape" select="0"/>

  <!-- messy sharp (#) in newtbl table cells, so escape it -->
  <xsl:call-template name="scape-encode">
    <xsl:with-param name="string">
      <xsl:choose>
      <xsl:when test="$escape != 0 or ancestor::entry or ancestor::revision or
                      ancestor::footnote or ancestor::term">
        <xsl:call-template name="string-replace">
          <xsl:with-param name="string">
            <xsl:call-template name="string-replace">
              <xsl:with-param name="string">
                <xsl:call-template name="string-replace">
                  <xsl:with-param name="string" select="@url"/>
                  <xsl:with-param name="from" select="'%'"/>
                  <xsl:with-param name="to" select="'\%'"/>
                </xsl:call-template>
              </xsl:with-param>
              <xsl:with-param name="from" select="'#'"/>
              <xsl:with-param name="to" select="'\#'"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="from" select="'&amp;'"/>
          <xsl:with-param name="to" select="'\&amp;'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@url"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- Should the URI be shown? @xrefstyle overrides the parameter -->
<xsl:template name="ulink-show">
  <xsl:choose>
    <xsl:when test="starts-with(@xrefstyle, 'url.show')">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:when test="starts-with(@xrefstyle, 'url.hide')">
      <xsl:value-of select="0"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$ulink.show"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Should the URI be in a footnote? @xrefstyle overrides the parameter -->
<xsl:template name="ulink-foot">
  <!-- assume xrefstyle is in the form: "url[.show][{.infoot|.after}]"
       $style extract the optional '.infoot' or '.after' part -->
  <xsl:variable name="style">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="string"
                      select="substring-after(@xrefstyle, 'url')"/>
      <xsl:with-param name="from" select="'.show'"/>
      <xsl:with-param name="to" select="''"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$style = '.infoot'">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:when test="$style = '.after'">
      <xsl:value-of select="0"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$ulink.footnotes"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="ulink.format">
  <xsl:variable name="url">
    <xsl:call-template name="ulink-encode"/>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test=".=''">
    <xsl:text>\url{</xsl:text>
    <xsl:value-of select="$url"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\href{</xsl:text>
    <xsl:value-of select="$url"/>
    <xsl:text>}{</xsl:text>
    <!-- text() within ulink is handled somewhere else -->
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>

    <xsl:variable name="url.show">
      <xsl:call-template name="ulink-show"/>
    </xsl:variable>

    <xsl:variable name="url.foot">
      <xsl:if test="$url.show != 0">
        <xsl:call-template name="ulink-foot"/>
      </xsl:if>
    </xsl:variable>

    <xsl:if test="count(child::node()) != 0
                  and string(.) != @url
                  and $url.show != 0">
      <!-- yes, show the URI -->
      <xsl:choose>
        <xsl:when test="$url.foot != 0 and not(ancestor::footnote)">
          <xsl:text>\footnote{</xsl:text>
          <xsl:text>\url{</xsl:text>
          <!-- Beware URL in a footnote -->
          <xsl:call-template name="ulink-encode">
            <xsl:with-param name="escape" select="1"/>
          </xsl:call-template>
          <xsl:text>}</xsl:text>
          <xsl:text>}</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <!-- Append the URL after the hyperlink -->
          <xsl:text> [</xsl:text>
          <xsl:text>\url{</xsl:text>
          <xsl:value-of select="$url"/>
          <xsl:text>}</xsl:text>
          <xsl:text>]</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>

  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Template that can be overwritten by user to customize the URL displayed as
     a block. The default is the solution sponsored by Freexian -->

<xsl:template name="ulink.block.markup">
  <xsl:text>&#10;&#10;</xsl:text>
  <!-- Put a symbol as a starter --> 
  <xsl:value-of select="$ulink.block.symbol"/>
  <xsl:choose>
  <!-- In sidebar force left-alignment with a fixed space -->
  <xsl:when test="ancestor::sidebar">
    <xsl:text>\enspace</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\space</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="ulink.format"/>
  <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="ulink">
  <xsl:variable name="urlstring">
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="@type='block'">
    <xsl:call-template name="ulink.block.markup"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="ulink.format"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- it now works thanks to "hyperlabel" -->

<xsl:template match="link" mode="xref.text">
  <xsl:choose>
  <xsl:when test=".!=''">
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string">
        <xsl:copy-of select="."/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="@endterm">
    <xsl:variable name="etarget" select="key('id',@endterm)[1]"/>
    <xsl:choose>
    <xsl:when test="count($etarget) = 0">
      <xsl:message>
        <xsl:text>Endterm points to nonexistent ID: </xsl:text>
        <xsl:value-of select="@endterm"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$etarget" mode="xref.text"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template match="link">
  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="linkend" select="@linkend"/>
    <xsl:with-param name="text">
      <xsl:apply-templates select="." mode="xref.text"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- Text of endterm xref must be managed with the text() function to support
     the special latex characters, but things like anchors must be skipped -->

<xsl:template match="*" mode="xref.text">
  <xsl:apply-templates select="text()|*[not(self::anchor)]"/>
</xsl:template>

<xsl:template match="term" mode="xref.text">
  <xsl:variable name="text">
    <xsl:apply-templates mode="xref.text"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($text)"/>
</xsl:template>

<!-- No reference must be made, but the label should be printed, if any -->
<xsl:template match="link" mode="toc.skip">
  <xsl:apply-templates select="." mode="xref.text"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="xref.nolink">
  <xsl:param name="string">
    <xsl:apply-templates select="."/>
  </xsl:param>

  <!-- Get the normal markup but replace hot links by counters -->
  <xsl:variable name="xref.text">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="string" select="$string"/>
      <xsl:with-param name="from" select="'\ref{'"/>
      <xsl:with-param name="to" select="'\ref*{'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Remove an internal hyperlink wrapper (external links seem ok) -->
  <xsl:choose>
    <xsl:when test="contains($xref.text, '\hyperlink{')">
      <xsl:value-of select="substring-before($xref.text,'\hyperlink{')"/>
      <xsl:value-of select="substring-after(substring-after($xref.text,
                                            '\hyperlink{'), '}')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$xref.text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Try to have the label from text mode, else get the reference counter -->
<xsl:template match="xref" mode="toc.skip">
  <xsl:variable name="xref.text">
    <xsl:apply-templates select="." mode="xref.text"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$xref.text != ''">
      <xsl:value-of select="$xref.text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="xref.nolink"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ulink" mode="toc.skip">
  <xsl:choose>
  <xsl:when test=".=''">
    <xsl:value-of select="@url"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- LaTeX chars are scaped. Each / except the :// is mapped to a /\- -->
    <xsl:apply-templates mode="slash.hyphen"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="ulink" mode="xref.text">
  <xsl:apply-templates select="." mode="toc.skip"/>
</xsl:template>


<!--- ==================================================================== -->

<xsl:template match="*" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:param name="refelem" select="local-name(.)"/>
  <xsl:message>
    <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
    <xsl:value-of select="$refelem"/>
    <xsl:text>" (linkend=</xsl:text>
    <xsl:value-of select="(@id|@xml:id)[1]"/>
    <xsl:text>)</xsl:text>
  </xsl:message>
  <xsl:text>[?</xsl:text><xsl:value-of select="$refelem"/><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="step" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Step'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="label.markup"/>
</xsl:template>

<xsl:template match="title" mode="xref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="book" mode="xref-to">
  <xsl:param name="referrer"/>

  <xsl:variable name="text">
    <xsl:text>\emph{</xsl:text>
    <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title" mode="xref"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="bookinfo/title" mode="xref"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}</xsl:text>
  </xsl:variable>

  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="text" select="$text"/>
  </xsl:call-template>
</xsl:template>

<!-- These are elements for which no link text exists, so an xref to one
     uses the xrefstyle attribute if specified, or if not it falls back
     to the container element's link text -->
<xsl:template match="para|phrase|simpara|anchor|quote" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:variable name="context" select="(ancestor::simplesect
                                       |ancestor::section
                                       |ancestor::sect1
                                       |ancestor::sect2
                                       |ancestor::sect3
                                       |ancestor::sect4
                                       |ancestor::sect5
                                       |ancestor::topic
                                       |ancestor::refsection
                                       |ancestor::refsect1
                                       |ancestor::refsect2
                                       |ancestor::refsect3
                                       |ancestor::chapter
                                       |ancestor::appendix
                                       |ancestor::preface
                                       |ancestor::partintro
                                       |ancestor::dedication
                                       |ancestor::acknowledgements
                                       |ancestor::colophon
                                       |ancestor::bibliography
                                       |ancestor::index
                                       |ancestor::glossary
                                       |ancestor::glossentry
                                       |ancestor::listitem
                                       |ancestor::varlistentry)[last()]"/>

  <xsl:choose>
    <xsl:when test="$xrefstyle != ''">
      <xsl:apply-templates select="." mode="object.xref.markup2">
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$verbose != 0">
        <xsl:message>
          <xsl:text>WARNING: xref to &lt;</xsl:text>
          <xsl:value-of select="local-name()"/>
          <xsl:text> id="</xsl:text>
          <xsl:value-of select="@id|@xml:id"/>
          <xsl:text>"&gt; has no generated text. Trying its ancestor elements.</xsl:text>
        </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="$context" mode="xref-to">
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="variablelist|orderedlist|orderedlist|itemizedlist"
              mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="dedication|preface|part|chapter|appendix" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="section|simplesect
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3|refsection" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="figure|example|table" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Equations have two reference counters, one for titled and one
     for untitled equations. So, the cross reference label must be
     different if a title is given or not.
 -->
<xsl:template match="equation" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Make the untitled equation markups different from the titled one.
     Change the context to make the difference.
-->
<xsl:template match="equation[not(child::title)]" mode="object.xref.template">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>

  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'xref-without-title'"/>
    <xsl:with-param name="name">
      <xsl:call-template name="xpath.location"/>
    </xsl:with-param>
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refentry" mode="xref-to">
  <xsl:param name="referrer"/>

  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="text">
      <xsl:apply-templates
                select="(refmeta/refentrytitle|refnamediv/refname[1])[1]"
                mode="xref.text"/>
      <xsl:apply-templates select="refmeta/manvolnum"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refnamediv" mode="xref-to">
  <xsl:param name="referrer"/>

  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="text">
      <xsl:apply-templates select="refname[1]" mode="xref.text"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="varlistentry|term" mode="xref-to">
  <xsl:param name="referrer"/>

  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="text">
      <xsl:choose>
      <xsl:when test="local-name(.)='term'">
        <xsl:apply-templates select="." mode="xref.text"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="term" mode="xref.text"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="biblioentry|bibliomixed" mode="xref-to">
  <xsl:text>\cite{</xsl:text>
  <xsl:call-template name="bibitem.id"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="glossentry" mode="xref-to">
  <xsl:param name="referrer"/>

  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="text">
      <xsl:call-template name="inline.italicseq">
        <xsl:with-param name="content">
          <xsl:apply-templates select="glossterm" mode="xref.text"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="cmdsynopsis" mode="xref-to">
  <xsl:variable name="command" select="(.//command)[1]"/>
  <xsl:apply-templates select="$command" mode="xref"/>
</xsl:template>

<xsl:template match="funcsynopsis" mode="xref-to">
  <xsl:variable name="func" select="(.//function)[1]"/>
  <xsl:apply-templates select="$func" mode="xref"/>
</xsl:template>

<xsl:template match="bibliography|glossary|index" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="reference" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- Xref to sidebar/qandaset -->
<xsl:template match="sidebar" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="qandaset" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="question|answer" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="formalpara" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup2">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- hook to avoid numbered xref for preface sections -->
<xsl:template match="preface/sect1| preface//sect2|
                     preface//sect3| preface//sect4|
                     preface//sect5| preface//section"
              mode="is.autonumber">
  <xsl:value-of select="0"/>
</xsl:template>

<xsl:template match="co" mode="xref-to">
  <xsl:call-template name="coref.link.create">
    <xsl:with-param name="ref" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="circled" select="1"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="olink">
  <xsl:variable name="localinfo" select="@localinfo"/>

  <xsl:choose>
    <!-- olinks resolved by stylesheet and target database -->
    <xsl:when test="@targetdoc or @targetptr" >
      <xsl:variable name="targetdoc.att" select="@targetdoc"/>
      <xsl:variable name="targetptr.att" select="@targetptr"/>

      <xsl:variable name="olink.lang">
        <xsl:call-template name="l10n.language">
          <xsl:with-param name="xref-context" select="true()"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="target.database.filename">
        <xsl:call-template name="select.target.database">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="target.database" 
                    select="document($target.database.filename, /)"/>
    
      <xsl:if test="$olink.debug != 0">
        <xsl:message>
          <xsl:text>Olink debug: root element of target.database is '</xsl:text>
          <xsl:value-of select="local-name($target.database/*[1])"/>
          <xsl:text>'.</xsl:text>
        </xsl:message>
      </xsl:if>

      <xsl:variable name="olink.key">
        <xsl:call-template name="select.olink.key">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:if test="string-length($olink.key) = 0">
        <xsl:message>
          <xsl:text>Error: unresolved olink: </xsl:text>
          <xsl:text>targetdoc/targetptr = '</xsl:text>
          <xsl:value-of select="$targetdoc.att"/>
          <xsl:text>/</xsl:text>
          <xsl:value-of select="$targetptr.att"/>
          <xsl:text>'.</xsl:text>
        </xsl:message>
      </xsl:if>

      <xsl:variable name="href">
        <xsl:call-template name="make.olink.href">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>

      <!-- Olink that points to internal id can be a link -->
      <xsl:variable name="linkend">
        <xsl:call-template name="olink.as.linkend">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="hottext">
        <xsl:call-template name="olink.hottext">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="olink.docname.citation">
        <xsl:call-template name="olink.document.citation">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="olink.page.citation">
        <xsl:call-template name="olink.page.citation">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="linkend" select="$linkend"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$linkend != ''">
          <!-- internal link -->
          <xsl:call-template name="hyperlink.markup">
            <xsl:with-param name="linkend" select="$linkend"/>
            <xsl:with-param name="text" select="$hottext"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$href != ''">
          <!-- link to an external document -->
          <xsl:call-template name="hyperref.format">
            <xsl:with-param name="href" select="$href"/>
            <xsl:with-param name="hottext" select="$hottext"/>
          </xsl:call-template>
          <xsl:copy-of select="$olink.page.citation"/>
          <xsl:copy-of select="$olink.docname.citation"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$hottext"/>
          <xsl:copy-of select="$olink.page.citation"/>
          <xsl:copy-of select="$olink.docname.citation"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- only XSL olink syntax supported -->
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink.as.linkend">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="olink.lang" select="''"/>
  <xsl:param name="target.database" select="NotANode"/>

  <xsl:variable name="targetdoc">
    <xsl:value-of select="substring-before($olink.key, '/')"/>
  </xsl:variable>

  <xsl:variable name="targetptr">
    <xsl:value-of 
       select="substring-before(substring-after($olink.key, '/'), '/')"/>
  </xsl:variable>

  <xsl:variable name="target.lang">
    <xsl:variable name="candidate">
      <xsl:for-each select="$target.database" >
        <xsl:value-of 
                  select="key('targetptr-key', $olink.key)/@lang" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$candidate != ''">
        <xsl:value-of select="$candidate"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$olink.lang"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$current.docid = $targetdoc and 
                $olink.lang = $target.lang">
  <!--
  <xsl:message>targetdoc=<xsl:value-of select="$targetdoc"/></xsl:message>
  <xsl:message>docid=<xsl:value-of select="$current.docid"/></xsl:message>
  <xsl:message>lang=<xsl:value-of select="$target.lang"/></xsl:message>
  <xsl:message>lang=<xsl:value-of select="$olink.lang"/></xsl:message>
  <xsl:message>ptr=<xsl:value-of select="$targetptr"/></xsl:message>
  -->
    <xsl:variable name="targets" select="key('id',$targetptr)"/>
    <xsl:variable name="target" select="$targets[1]"/>
    <xsl:if test="$target">
      <xsl:value-of select="$targetptr"/>
    </xsl:if>
  </xsl:if>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="hyperref.format">
  <xsl:param name="href"/>
  <xsl:param name="hottext"/>
  <xsl:variable name="url" select="substring-before($href, '#')"/>
  <xsl:variable name="name" select="substring-after($href, '#')"/>
  <xsl:text>\hyperref{</xsl:text>
  <xsl:value-of select="$url"/>
  <!-- no specific 'category' -->
  <xsl:text>}{}{</xsl:text>
  <xsl:value-of select="$name"/>
  <xsl:text>}{</xsl:text>
  <xsl:value-of select="$hottext"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="command" mode="xref">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="function" mode="xref">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="page.citation">
  <xsl:param name="id" select="'???'"/>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="template">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="name" select="'page.citation'"/>
        <xsl:with-param name="context" select="'xref'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="link" mode="no.anchor.mode" priority="1">
  <xsl:apply-templates select="." mode="xref.text"/>
</xsl:template>

<!-- Escape tex characters in title markups -->
<xsl:template match="text()" mode="no.anchor.mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="part|chapter|appendix|
                     sect1|sect2|sect3|sect4|sect5|section" mode="label.markup"
                     priority="1">
  <xsl:text>\ref{</xsl:text>
  <xsl:value-of select="(@id|@xml:id)[1]"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="figure|example|table|equation" mode="label.markup"
              priority="1">
  <xsl:text>\ref{</xsl:text>
  <xsl:value-of select="(@id|@xml:id)[1]"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="step" mode="label.markup" priority="1">
  <xsl:text>\ref{</xsl:text>
  <xsl:value-of select="(@id|@xml:id)[1]"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="*" mode="pagenumber.markup">
  <xsl:text>\pageref{</xsl:text>
  <xsl:value-of select="(@id|@xml:id)[1]"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="insert.title.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>
  <xsl:param name="referrer"/>

  <xsl:call-template name="hyperlink.markup">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="linkend" select="(@id|@xml:id)[1]"/>
    <xsl:with-param name="text" select="$title"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="insert.subtitle.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="subtitle"/>

  <xsl:copy-of select="$subtitle"/>
</xsl:template>

<xsl:template match="*" mode="insert.label.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="label"/>

  <xsl:copy-of select="$label"/>
</xsl:template>

<xsl:template match="*" mode="insert.pagenumber.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="pagenumber"/>

  <xsl:copy-of select="$pagenumber"/>
</xsl:template>

<xsl:template match="*" mode="insert.direction.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="direction"/>

  <xsl:copy-of select="$direction"/>
</xsl:template>

<xsl:template match="*" mode="insert.olink.docname.markup">
  <xsl:param name="docname" select="''"/>
  
  <xsl:text>\emph{</xsl:text>
  <xsl:copy-of select="$docname"/>
  <xsl:text>}</xsl:text>
</xsl:template>

</xsl:stylesheet>
