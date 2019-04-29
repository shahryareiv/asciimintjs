<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:dyn="http://exslt.org/dynamic"
                xmlns:saxon="http://icl.com/saxon"
                exclude-result-prefixes="doc dyn saxon"
  >






<!-- ********************************************************************
     Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<doc:reference xmlns="" xml:id="base">
  <info>
    <title>Common » Base Template Reference</title>
    <releaseinfo role="meta">
      $Id
    </releaseinfo>
  </info>
  <!-- * yes, partintro is a valid child of a reference... -->
  <partintro xml:id="partintro">
    <title>Introduction</title>
    <para>This is technical reference documentation for the “base”
      set of common templates in the DocBook XSL Stylesheets.</para>
    <para>This is not intended to be user documentation. It is
      provided for developers writing customization layers for the
      stylesheets.</para>
  </partintro>
</doc:reference>

<!-- ==================================================================== -->
<!-- Establish strip/preserve whitespace rules -->

<xsl:preserve-space elements="*"/>

<xsl:strip-space elements="
abstract affiliation anchor answer appendix area areaset areaspec
artheader article audiodata audioobject author authorblurb authorgroup
beginpage bibliodiv biblioentry bibliography biblioset blockquote book
bookbiblio bookinfo callout calloutlist caption caution chapter
citerefentry cmdsynopsis co collab colophon colspec confgroup
copyright dedication docinfo editor entrytbl epigraph equation
example figure footnote footnoteref formalpara funcprototype
funcsynopsis glossary glossdef glossdiv glossentry glosslist graphicco
group highlights imagedata imageobject imageobjectco important index
indexdiv indexentry indexterm info informalequation informalexample
informalfigure informaltable inlineequation inlinemediaobject
itemizedlist itermset keycombo keywordset legalnotice listitem lot
mediaobject mediaobjectco menuchoice msg msgentry msgexplan msginfo
msgmain msgrel msgset msgsub msgtext note objectinfo
orderedlist othercredit part partintro preface printhistory procedure
programlistingco publisher qandadiv qandaentry qandaset question
refentry reference refmeta refnamediv refsection refsect1 refsect1info refsect2
refsect2info refsect3 refsect3info refsynopsisdiv refsynopsisdivinfo
revhistory revision row sbr screenco screenshot sect1 sect1info sect2
sect2info sect3 sect3info sect4 sect4info sect5 sect5info section
sectioninfo seglistitem segmentedlist seriesinfo set setindex setinfo
shortcut sidebar simplelist simplesect spanspec step subject
subjectset substeps synopfragment table tbody textobject tfoot tgroup
thead tip toc tocchap toclevel1 toclevel2 toclevel3 toclevel4
toclevel5 tocpart varargs variablelist varlistentry videodata
videoobject void warning subjectset

classsynopsis
constructorsynopsis
destructorsynopsis
fieldsynopsis
methodparam
methodsynopsis
ooclass
ooexception
oointerface
simplemsgentry
manvolnum
"/>
<!-- ====================================================================== -->

<doc:template name="is.component" xmlns="">
<refpurpose>Tests if a given node is a component-level element</refpurpose>

<refdescription id="is.component-desc">
<para>This template returns '1' if the specified node is a component
(Chapter, Appendix, etc.), and '0' otherwise.</para>
</refdescription>

<refparameter id="is.component-params">
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node which is to be tested.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="is.component-returns">
<para>This template returns '1' if the specified node is a component
(Chapter, Appendix, etc.), and '0' otherwise.</para>
</refreturn>
</doc:template>

<xsl:template name="is.component">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($node) = 'appendix'
                    or local-name($node) = 'article'
                    or local-name($node) = 'chapter'
                    or local-name($node) = 'preface'
                    or local-name($node) = 'bibliography'
                    or local-name($node) = 'glossary'
                    or local-name($node) = 'index'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="is.section" xmlns="">
<refpurpose>Tests if a given node is a section-level element</refpurpose>

<refdescription id="is.section-desc">
<para>This template returns '1' if the specified node is a section
(Section, Sect1, Sect2, etc.), and '0' otherwise.</para>
</refdescription>

<refparameter id="is.section-params">
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node which is to be tested.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="is.section-returns">
<para>This template returns '1' if the specified node is a section
(Section, Sect1, Sect2, etc.), and '0' otherwise.</para>
</refreturn>
</doc:template>

<xsl:template name="is.section">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($node) = 'section'
                    or local-name($node) = 'sect1'
                    or local-name($node) = 'sect2'
                    or local-name($node) = 'sect3'
                    or local-name($node) = 'sect4'
                    or local-name($node) = 'sect5'
                    or local-name($node) = 'refsect1'
                    or local-name($node) = 'refsect2'
                    or local-name($node) = 'refsect3'
                    or local-name($node) = 'simplesect'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="section.level" xmlns="">
<refpurpose>Returns the hierarchical level of a section</refpurpose>

<refdescription id="section.level-desc">
<para>This template calculates the hierarchical level of a section.
The element <tag>sect1</tag> is at level 1, <tag>sect2</tag> is
at level 2, etc.</para>

<para>Recursive sections are calculated down to the fifth level.</para>
</refdescription>

<refparameter id="section.level-params">
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The section node for which the level should be calculated.
Defaults to the context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="section.level-returns">
<para>The section level, <quote>1</quote>, <quote>2</quote>, etc.
</para>
</refreturn>
</doc:template>

<xsl:template name="section.level">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($node)='sect1'">1</xsl:when>
    <xsl:when test="local-name($node)='sect2'">2</xsl:when>
    <xsl:when test="local-name($node)='sect3'">3</xsl:when>
    <xsl:when test="local-name($node)='sect4'">4</xsl:when>
    <xsl:when test="local-name($node)='sect5'">5</xsl:when>
    <xsl:when test="local-name($node)='section'">
      <xsl:choose>
        <xsl:when test="$node/../../../../../../section">6</xsl:when>
        <xsl:when test="$node/../../../../../section">5</xsl:when>
        <xsl:when test="$node/../../../../section">4</xsl:when>
        <xsl:when test="$node/../../../section">3</xsl:when>
        <xsl:when test="$node/../../section">2</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name($node)='refsect1' or
                    local-name($node)='refsect2' or
                    local-name($node)='refsect3' or
                    local-name($node)='refsection' or
                    local-name($node)='refsynopsisdiv'">
      <xsl:call-template name="refentry.section.level">
        <xsl:with-param name="node" select="$node"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="local-name($node)='simplesect'">
      <xsl:choose>
        <xsl:when test="$node/../../sect1">2</xsl:when>
        <xsl:when test="$node/../../sect2">3</xsl:when>
        <xsl:when test="$node/../../sect3">4</xsl:when>
        <xsl:when test="$node/../../sect4">5</xsl:when>
        <xsl:when test="$node/../../sect5">5</xsl:when>
        <xsl:when test="$node/../../section">
          <xsl:choose>
            <xsl:when test="$node/../../../../../section">5</xsl:when>
            <xsl:when test="$node/../../../../section">4</xsl:when>
            <xsl:when test="$node/../../../section">3</xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template><!-- section.level -->

<doc:template name="qanda.section.level" xmlns="">
<refpurpose>Returns the hierarchical level of a QandASet</refpurpose>

<refdescription id="qanda.section.level-desc">
<para>This template calculates the hierarchical level of a QandASet.
</para>
</refdescription>

<refreturn id="qanda.section.level-returns">
<para>The level, <quote>1</quote>, <quote>2</quote>, etc.
</para>
</refreturn>
</doc:template>

<xsl:template name="qanda.section.level">
  <xsl:variable name="section"
                select="(ancestor::section
                         |ancestor::simplesect
                         |ancestor::sect5
                         |ancestor::sect4
                         |ancestor::sect3
                         |ancestor::sect2
                         |ancestor::sect1
                         |ancestor::refsect3
                         |ancestor::refsect2
                         |ancestor::refsect1)[last()]"/>

  <xsl:choose>
    <xsl:when test="count($section) = '0'">1</xsl:when>
    <xsl:otherwise>
      <xsl:variable name="slevel">
        <xsl:call-template name="section.level">
          <xsl:with-param name="node" select="$section"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$slevel + 1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Finds the total section depth of a section in a refentry -->
<xsl:template name="refentry.section.level">
  <xsl:param name="node" select="."/>

  <xsl:variable name="RElevel">
    <xsl:call-template name="refentry.level">
      <xsl:with-param name="node" select="$node/ancestor::refentry[1]"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="levelinRE">
    <xsl:choose>
      <xsl:when test="local-name($node)='refsynopsisdiv'">1</xsl:when>
      <xsl:when test="local-name($node)='refsect1'">1</xsl:when>
      <xsl:when test="local-name($node)='refsect2'">2</xsl:when>
      <xsl:when test="local-name($node)='refsect3'">3</xsl:when>
      <xsl:when test="local-name($node)='refsection'">
        <xsl:choose>
          <xsl:when test="$node/../../../../../refsection">5</xsl:when>
          <xsl:when test="$node/../../../../refsection">4</xsl:when>
          <xsl:when test="$node/../../../refsection">3</xsl:when>
          <xsl:when test="$node/../../refsection">2</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$levelinRE + $RElevel"/>
</xsl:template>

<!-- Finds the section depth of a refentry -->
<xsl:template name="refentry.level">
  <xsl:param name="node" select="."/>
  <xsl:variable name="container"
                select="($node/ancestor::section |
                        $node/ancestor::sect1 |
                        $node/ancestor::sect2 |
                        $node/ancestor::sect3 |
                        $node/ancestor::sect4 |
                        $node/ancestor::sect5)[last()]"/>

  <xsl:choose>
    <xsl:when test="$container">
      <xsl:variable name="slevel">
        <xsl:call-template name="section.level">
          <xsl:with-param name="node" select="$container"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$slevel + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="qandadiv.section.level">
  <xsl:variable name="section.level">
    <xsl:call-template name="qanda.section.level"/>
  </xsl:variable>
  <xsl:variable name="anc.divs" select="ancestor::qandadiv"/>

  <xsl:value-of select="count($anc.divs) + number($section.level)"/>
</xsl:template>

<xsl:template name="question.answer.label">
  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]
                              /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="label" select="@label"/>

<!--
 (hnr      (hierarchical-number-recursive (normalize "qandadiv") node))

         (parsect  (ancestor-member node (section-element-list)))

         (defnum   (if (and %qanda-inherit-numeration% 
                            %section-autolabel%)
                       (if (node-list-empty? parsect)
                           (section-autolabel-prefix node)
                           (section-autolabel parsect))
                       ""))

         (hnumber  (let loop ((numlist hnr) (number defnum) 
                              (sep (if (equal? defnum "") "" ".")))
                     (if (null? numlist)
                         number
                         (loop (cdr numlist) 
                               (string-append number
                                              sep
                                              (number->string (car numlist)))
                               "."))))
         (cnumber  (child-number (parent node)))
         (number   (string-append hnumber 
                                  (if (equal? hnumber "")
                                      ""
                                      ".")
                                  (number->string cnumber))))
-->

  <xsl:choose>
    <xsl:when test="$deflabel = 'qanda'">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="local-name(.) = 'question'">question</xsl:when>
            <xsl:when test="local-name(.) = 'answer'">answer</xsl:when>
            <xsl:when test="local-name(.) = 'qandadiv'">qandadiv</xsl:when>
            <xsl:otherwise>qandaset</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$deflabel = 'label'">
      <xsl:value-of select="$label"/>
    </xsl:when>
    <xsl:when test="$deflabel = 'number'
                    and local-name(.) = 'question'">
      <xsl:apply-templates select="ancestor::qandaset[1]"
                           mode="number"/>
      <xsl:choose>
        <xsl:when test="ancestor::qandadiv">
          <xsl:apply-templates select="ancestor::qandadiv[1]"
                               mode="number"/>
          <xsl:apply-templates select="ancestor::qandaentry"
                               mode="number"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="ancestor::qandaentry"
                               mode="number"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <!-- nothing -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="qandaset" mode="number">
  <!-- FIXME: -->
</xsl:template>

<xsl:template match="qandadiv" mode="number">
  <xsl:number level="multiple" from="qandaset" format="1."/>
</xsl:template>

<xsl:template match="qandaentry" mode="number">
  <xsl:choose>
    <xsl:when test="ancestor::qandadiv">
      <xsl:number level="single" from="qandadiv" format="1."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="single" from="qandaset" format="1."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="object.id">
  <xsl:param name="object" select="."/>
  <xsl:choose>
    <xsl:when test="$object/@id">
      <xsl:value-of select="$object/@id"/>
    </xsl:when>
    <xsl:when test="$object/@xml:id">
      <xsl:value-of select="$object/@xml:id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($object)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="person.name">
  <!-- Formats a personal name. Handles corpauthor as a special case. -->
  <xsl:param name="node" select="."/>

  <xsl:variable name="style">
    <xsl:choose>
      <xsl:when test="$node/@role">
        <xsl:value-of select="$node/@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'styles'"/>
          <xsl:with-param name="name" select="'person-name'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <!-- the personname element is a specialcase -->
    <xsl:when test="$node/personname">
      <xsl:call-template name="person.name">
        <xsl:with-param name="node" select="$node/personname"/>
      </xsl:call-template>
    </xsl:when>

    <!-- handle corpauthor as a special case...-->
    <!-- * MikeSmith 2007-06: I'm wondering if the person.name template -->
    <!-- * actually ever gets called to handle corpauthor.. maybe -->
    <!-- * we don't actually need to check for corpauthor here. -->
    <xsl:when test="local-name($node)='corpauthor'">
      <xsl:apply-templates select="$node"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:choose>
        <!-- Handle case when personname contains only general markup (DocBook 5.0) -->
        <xsl:when test="$node/self::personname and not($node/firstname or $node/honorific or $node/lineage or $node/othername or $node/surname)">
          <xsl:apply-templates select="$node/node()"/>
        </xsl:when>
        <xsl:when test="$style = 'family-given'">
          <xsl:call-template name="person.name.family-given">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$style = 'last-first'">
          <xsl:call-template name="person.name.last-first">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="person.name.first-last">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="person.name.family-given">
  <xsl:param name="node" select="."/>

  <!-- The family-given style applies a convention for identifying given -->
  <!-- and family names in locales where it may be ambiguous -->
  <xsl:apply-templates select="$node//surname[1]"/>

  <xsl:if test="$node//surname and $node//firstname">
    <xsl:text> </xsl:text>
  </xsl:if>

  <xsl:apply-templates select="$node//firstname[1]"/>

  <xsl:text> [FAMILY Given]</xsl:text>
</xsl:template>

<xsl:template name="person.name.last-first">
  <xsl:param name="node" select="."/>

  <xsl:apply-templates select="$node//surname[1]"/>

  <xsl:if test="$node//surname and $node//firstname">
    <xsl:text>, </xsl:text>
  </xsl:if>

  <xsl:apply-templates select="$node//firstname[1]"/>
</xsl:template>

<xsl:template name="person.name.first-last">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node//honorific">
    <xsl:apply-templates select="$node//honorific[1]"/>
    <xsl:value-of select="$punct.honorific"/>
  </xsl:if>

  <xsl:if test="$node//firstname">
    <xsl:if test="$node//honorific">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//firstname[1]"/>
  </xsl:if>

  <xsl:if test="$node//othername and $author.othername.in.middle != 0">
    <xsl:if test="$node//honorific or $node//firstname">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//othername[1]"/>
  </xsl:if>

  <xsl:if test="$node//surname">
    <xsl:if test="$node//honorific or $node//firstname
                  or ($node//othername and $author.othername.in.middle != 0)">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//surname[1]"/>
  </xsl:if>

  <xsl:if test="$node//lineage">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="$node//lineage[1]"/>
  </xsl:if>
</xsl:template>

<xsl:template name="person.name.list">
  <!-- Return a formatted string representation of the contents of
       the current element. The current element must contain one or
       more AUTHORs, CORPAUTHORs, OTHERCREDITs, and/or EDITORs.

       John Doe
     or
       John Doe and Jane Doe
     or
       John Doe, Jane Doe, and A. Nonymous
  -->
  <xsl:param name="person.list"
             select="author|corpauthor|othercredit|editor"/>
  <xsl:param name="person.count" select="count($person.list)"/>
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count &gt; $person.count"></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="person.name">
        <xsl:with-param name="node" select="$person.list[position()=$count]"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="$person.count = 2 and $count = 1">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'sep2'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$person.count &gt; 2 and $count+1 = $person.count">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'seplast'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$count &lt; $person.count">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'sep'"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="person.name.list">
        <xsl:with-param name="person.list" select="$person.list"/>
        <xsl:with-param name="person.count" select="$person.count"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template><!-- person.name.list -->

<!-- === synopsis ======================================================= -->
<!-- The following definitions match those given in the reference
     documentation for DocBook V3.0
-->

<xsl:variable name="arg.choice.opt.open.str">[</xsl:variable>
<xsl:variable name="arg.choice.opt.close.str">]</xsl:variable>
<xsl:variable name="arg.choice.req.open.str">{</xsl:variable>
<xsl:variable name="arg.choice.req.close.str">}</xsl:variable>
<xsl:variable name="arg.choice.plain.open.str"><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="arg.choice.plain.close.str"><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="arg.choice.def.open.str">[</xsl:variable>
<xsl:variable name="arg.choice.def.close.str">]</xsl:variable>
<xsl:variable name="arg.rep.repeat.str">...</xsl:variable>
<xsl:variable name="arg.rep.norepeat.str"></xsl:variable>
<xsl:variable name="arg.rep.def.str"></xsl:variable>
<xsl:variable name="arg.or.sep"> | </xsl:variable>
<xsl:variable name="cmdsynopsis.hanging.indent">4pi</xsl:variable>

<!-- ====================================================================== -->

<!--
<xsl:template name="xref.g.subst">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target" select="."/>
  <xsl:variable name="subst">%g</xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($string, $subst)">
      <xsl:value-of select="substring-before($string, $subst)"/>
      <xsl:call-template name="gentext.element.name">
        <xsl:with-param name="element.name" select="local-name($target)"/>
      </xsl:call-template>
      <xsl:call-template name="xref.g.subst">
        <xsl:with-param name="string"
                        select="substring-after($string, $subst)"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xref.t.subst">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target" select="."/>
  <xsl:variable name="subst">%t</xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($string, $subst)">
      <xsl:call-template name="xref.g.subst">
        <xsl:with-param name="string"
                        select="substring-before($string, $subst)"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
      <xsl:call-template name="title.xref">
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
      <xsl:call-template name="xref.t.subst">
        <xsl:with-param name="string"
                        select="substring-after($string, $subst)"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="xref.g.subst">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xref.n.subst">
  <xsl:param name="string"></xsl:param>
  <xsl:param name="target" select="."/>
  <xsl:variable name="subst">%n</xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($string, $subst)">
      <xsl:call-template name="xref.t.subst">
        <xsl:with-param name="string"
                        select="substring-before($string, $subst)"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
      <xsl:call-template name="number.xref">
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
      <xsl:call-template name="xref.t.subst">
        <xsl:with-param name="string"
                        select="substring-after($string, $subst)"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="xref.t.subst">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="subst.xref.text">
  <xsl:param name="xref.text"></xsl:param>
  <xsl:param name="target" select="."/>

  <xsl:call-template name="xref.n.subst">
    <xsl:with-param name="string" select="$xref.text"/>
    <xsl:with-param name="target" select="$target"/>
  </xsl:call-template>
</xsl:template>
-->

<!-- ====================================================================== -->

<xsl:template name="filename-basename">
  <!-- We assume all filenames are really URIs and use "/" -->
  <xsl:param name="filename"></xsl:param>
  <xsl:param name="recurse" select="false()"/>

  <xsl:choose>
    <xsl:when test="substring-after($filename, '/') != ''">
      <xsl:call-template name="filename-basename">
        <xsl:with-param name="filename"
                        select="substring-after($filename, '/')"/>
        <xsl:with-param name="recurse" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="filename-extension">
  <xsl:param name="filename"></xsl:param>
  <xsl:param name="recurse" select="false()"/>

  <!-- Make sure we only look at the base name... -->
  <xsl:variable name="basefn">
    <xsl:choose>
      <xsl:when test="$recurse">
        <xsl:value-of select="$filename"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="filename-basename">
          <xsl:with-param name="filename" select="$filename"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="substring-after($basefn, '.') != ''">
      <xsl:call-template name="filename-extension">
        <xsl:with-param name="filename"
                        select="substring-after($basefn, '.')"/>
        <xsl:with-param name="recurse" select="true()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$recurse">
      <xsl:value-of select="$basefn"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="select.mediaobject" xmlns="">
<refpurpose>Selects and processes an appropriate media object from a list</refpurpose>

<refdescription id="select.mediaobject-desc">
<para>This template takes a list of media objects (usually the
children of a mediaobject or inlinemediaobject) and processes
the "right" object.</para>

<para>This template relies on a template named 
"select.mediaobject.index" to determine which object
in the list is appropriate.</para>

<para>If no acceptable object is located, nothing happens.</para>
</refdescription>

<refparameter id="select.mediaobject-params">
<variablelist>
<varlistentry><term>olist</term>
<listitem>
<para>The node list of potential objects to examine.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="select.mediaobject-returns">
<para>Calls &lt;xsl:apply-templates&gt; on the selected object.</para>
</refreturn>
</doc:template>

<xsl:template name="select.mediaobject">
  <xsl:param name="olist"
             select="imageobject|imageobjectco
                     |videoobject|audioobject|textobject"/>
  
  <xsl:variable name="mediaobject.index">
    <xsl:call-template name="select.mediaobject.index">
      <xsl:with-param name="olist" select="$olist"/>
      <xsl:with-param name="count" select="1"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$mediaobject.index != ''">
    <xsl:apply-templates select="$olist[position() = $mediaobject.index]"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="select.mediaobject.index" xmlns="">
<refpurpose>Selects the position of the appropriate media object from a list</refpurpose>

<refdescription id="select.mediaobject.index-desc">
<para>This template takes a list of media objects (usually the
children of a mediaobject or inlinemediaobject) and determines
the "right" object. It returns the position of that object
to be used by the calling template.</para>

<para>If the parameter <parameter>use.role.for.mediaobject</parameter>
is nonzero, then it first checks for an object with
a role attribute of the appropriate value.  It takes the first
of those.  Otherwise, it takes the first acceptable object
through a recursive pass through the list.</para>

<para>This template relies on a template named "is.acceptable.mediaobject"
to determine if a given object is an acceptable graphic. The semantics
of media objects is that the first acceptable graphic should be used.
</para>

<para>If no acceptable object is located, no index is returned.</para>
</refdescription>

<refparameter id="select.mediaobject.index-params">
<variablelist>
<varlistentry><term>olist</term>
<listitem>
<para>The node list of potential objects to examine.</para>
</listitem>
</varlistentry>
<varlistentry><term>count</term>
<listitem>
<para>The position in the list currently being considered by the 
recursive process.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="select.mediaobject.index-returns">
<para>Returns the position in the original list of the selected object.</para>
</refreturn>
</doc:template>

<xsl:template name="select.mediaobject.index">
  <xsl:param name="olist"
             select="imageobject|imageobjectco
                     |videoobject|audioobject|textobject"/>
  <xsl:param name="count">1</xsl:param>

  <xsl:choose>
    <!-- Test for objects preferred by role -->
    <xsl:when test="$use.role.for.mediaobject != 0 
               and $preferred.mediaobject.role != ''
               and $olist[@role = $preferred.mediaobject.role]"> 
      
      <!-- Get the first hit's position index -->
      <xsl:for-each select="$olist">
        <xsl:if test="@role = $preferred.mediaobject.role and
             not(preceding-sibling::*[@role = $preferred.mediaobject.role])"> 
          <xsl:value-of select="position()"/> 
        </xsl:if>
      </xsl:for-each>
    </xsl:when>

    <xsl:when test="$use.role.for.mediaobject != 0 
               and $olist[@role = $stylesheet.result.type]">
      <!-- Get the first hit's position index -->
      <xsl:for-each select="$olist">
        <xsl:if test="@role = $stylesheet.result.type and 
              not(preceding-sibling::*[@role = $stylesheet.result.type])"> 
          <xsl:value-of select="position()"/> 
        </xsl:if>
      </xsl:for-each>
    </xsl:when>
    <!-- Accept 'html' for $stylesheet.result.type = 'xhtml' -->
    <xsl:when test="$use.role.for.mediaobject != 0 
               and $stylesheet.result.type = 'xhtml'
               and $olist[@role = 'html']">
      <!-- Get the first hit's position index -->
      <xsl:for-each select="$olist">
        <xsl:if test="@role = 'html' and 
              not(preceding-sibling::*[@role = 'html'])"> 
          <xsl:value-of select="position()"/> 
        </xsl:if>
      </xsl:for-each>
    </xsl:when>

    <!-- If no selection by role, and there is only one object, use it -->
    <xsl:when test="count($olist) = 1 and $count = 1">
      <xsl:value-of select="$count"/> 
    </xsl:when>

    <xsl:otherwise>
      <!-- Otherwise select first acceptable object -->
      <xsl:if test="$count &lt;= count($olist)">
        <xsl:variable name="object" select="$olist[position()=$count]"/>
    
        <xsl:variable name="useobject">
          <xsl:choose>
            <!-- The phrase is used only when contains TeX Math and output is FO -->
            <xsl:when test="local-name($object)='textobject' and $object/phrase
                            and $object/@role='tex' and $stylesheet.result.type = 'fo'
                            and $tex.math.in.alt != ''">
              <xsl:text>1</xsl:text> 
            </xsl:when>
            <!-- The phrase is never used -->
            <xsl:when test="local-name($object)='textobject' and $object/phrase">
              <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:when test="local-name($object)='textobject'
                            and $object/ancestor::equation ">
            <!-- The first textobject is not a reasonable fallback
                 for equation image -->
              <xsl:text>0</xsl:text>
            </xsl:when>
            <!-- The first textobject is a reasonable fallback -->
            <xsl:when test="local-name($object)='textobject'
                            and $object[not(@role) or @role!='tex']">
              <xsl:text>1</xsl:text>
            </xsl:when>
            <!-- don't use graphic when output is FO, TeX Math is used 
                 and there is math in alt element -->
            <xsl:when test="$object/ancestor::equation and 
                            $object/ancestor::equation/alt[@role='tex']
                            and $stylesheet.result.type = 'fo'
                            and $tex.math.in.alt != ''">
              <xsl:text>0</xsl:text>
            </xsl:when>
            <!-- If there's only one object, use it -->
            <xsl:when test="$count = 1 and count($olist) = 1">
               <xsl:text>1</xsl:text>
            </xsl:when>
            <!-- Otherwise, see if this one is a useable graphic -->
            <xsl:otherwise>
              <xsl:choose>
                <!-- peek inside imageobjectco to simplify the test -->
                <xsl:when test="local-name($object) = 'imageobjectco'">
                  <xsl:call-template name="is.acceptable.mediaobject">
                    <xsl:with-param name="object" select="$object/imageobject"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="is.acceptable.mediaobject">
                    <xsl:with-param name="object" select="$object"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
    
        <xsl:choose>
          <xsl:when test="$useobject='1'">
            <xsl:value-of select="$count"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="select.mediaobject.index">
              <xsl:with-param name="olist" select="$olist"/>
              <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<doc:template name="is.acceptable.mediaobject" xmlns="">
<refpurpose>Returns '1' if the specified media object is recognized</refpurpose>

<refdescription id="is.acceptable.mediaobject-desc">
<para>This template examines a media object and returns '1' if the
object is recognized as a graphic.</para>
</refdescription>

<refparameter id="is.acceptable.mediaobject-params">
<variablelist>
<varlistentry><term>object</term>
<listitem>
<para>The media object to consider.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="is.acceptable.mediaobject-returns">
<para>0 or 1</para>
</refreturn>
</doc:template>

<xsl:template name="is.acceptable.mediaobject">
  <xsl:param name="object"></xsl:param>

  <xsl:variable name="filename">
    <xsl:call-template name="mediaobject.filename">
      <xsl:with-param name="object" select="$object"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ext">
    <xsl:call-template name="filename-extension">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- there will only be one -->
  <xsl:variable name="data" select="$object/videodata
                                    |$object/imagedata
                                    |$object/audiodata"/>

  <xsl:variable name="format" select="$data/@format"/>

  <xsl:variable name="graphic.format">
    <xsl:if test="$format">
      <xsl:call-template name="is.graphic.format">
        <xsl:with-param name="format" select="$format"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="graphic.ext">
    <xsl:if test="$ext">
      <xsl:call-template name="is.graphic.extension">
        <xsl:with-param name="ext" select="$ext"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$use.svg = 0 and $format = 'SVG'">0</xsl:when>
    <xsl:when xmlns:svg="http://www.w3.org/2000/svg"
              test="$use.svg != 0 and $object/svg:*">1</xsl:when>
    <xsl:when test="$graphic.format = '1'">1</xsl:when>
    <xsl:when test="$graphic.ext = '1'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="mediaobject.filename">
  <xsl:param name="object"></xsl:param>

  <xsl:variable name="data" select="$object/videodata
                                    |$object/imagedata
                                    |$object/audiodata
                                    |$object"/>

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="$data[@fileref]">
        <xsl:apply-templates select="$data/@fileref"/>
      </xsl:when>
      <xsl:when test="$data[@entityref]">
        <xsl:value-of select="unparsed-entity-uri($data/@entityref)"/>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="real.ext">
    <xsl:call-template name="filename-extension">
      <xsl:with-param name="filename" select="$filename"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="ext">
    <xsl:choose>
      <xsl:when test="$real.ext != ''">
        <xsl:value-of select="$real.ext"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$graphic.default.extension"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="graphic.ext">
    <xsl:call-template name="is.graphic.extension">
      <xsl:with-param name="ext" select="$ext"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$real.ext = ''">
      <xsl:choose>
        <xsl:when test="$ext != ''">
          <xsl:value-of select="$filename"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$ext"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$filename"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="not($graphic.ext)">
      <xsl:choose>
        <xsl:when test="$graphic.default.extension != ''">
          <xsl:value-of select="$filename"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="$graphic.default.extension"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$filename"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="check.id.unique" xmlns="">
<refpurpose>Warn users about references to non-unique IDs</refpurpose>
<refdescription id="check.id.unique-desc">
<para>If passed an ID in <varname>linkend</varname>,
<function>check.id.unique</function> prints
a warning message to the user if either the ID does not exist or
the ID is not unique.</para>
</refdescription>
</doc:template>

<xsl:template name="check.id.unique">
  <xsl:param name="linkend"></xsl:param>
  <xsl:if test="$linkend != ''">
    <xsl:variable name="targets" select="key('id',$linkend)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:if test="count($targets)=0">
      <xsl:message>
        <xsl:text>Error: no ID for constraint linkend: </xsl:text>
        <xsl:value-of select="$linkend"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
      <!--
      <xsl:message>
        <xsl:text>If the ID exists in your document, did your </xsl:text>
        <xsl:text>XSLT Processor load the DTD?</xsl:text>
      </xsl:message>
      -->
    </xsl:if>

    <xsl:if test="count($targets)>1">
      <xsl:message>
        <xsl:text>Warning: multiple "IDs" for constraint linkend: </xsl:text>
        <xsl:value-of select="$linkend"/>
        <xsl:text>.</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:if>
</xsl:template>

<doc:template name="check.idref.targets" xmlns="">
<refpurpose>Warn users about incorrectly typed references</refpurpose>
<refdescription id="check.idref.targets-desc">
<para>If passed an ID in <varname>linkend</varname>,
<function>check.idref.targets</function> makes sure that the element
pointed to by the link is one of the elements listed in
<varname>element-list</varname> and warns the user otherwise.</para>
</refdescription>
</doc:template>

<xsl:template name="check.idref.targets">
  <xsl:param name="linkend"></xsl:param>
  <xsl:param name="element-list"></xsl:param>
  <xsl:if test="$linkend != ''">
    <xsl:variable name="targets" select="key('id',$linkend)"/>
    <xsl:variable name="target" select="$targets[1]"/>

    <xsl:if test="count($target) &gt; 0">
      <xsl:if test="not(contains(concat(' ', $element-list, ' '), local-name($target)))">
        <xsl:message>
          <xsl:text>Error: linkend (</xsl:text>
          <xsl:value-of select="$linkend"/>
          <xsl:text>) points to "</xsl:text>
          <xsl:value-of select="local-name($target)"/>
          <xsl:text>" not (one of): </xsl:text>
          <xsl:value-of select="$element-list"/>
        </xsl:message>
      </xsl:if>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->
<!-- Procedure Step Numeration -->

<xsl:param name="procedure.step.numeration.formats" select="'1aiAI'"/>

<xsl:template name="procedure.step.numeration">
  <xsl:param name="context" select="."/>
  <xsl:variable name="format.length"
                select="string-length($procedure.step.numeration.formats)"/>
  <xsl:choose>
    <xsl:when test="local-name($context) = 'substeps'">
      <xsl:variable name="ssdepth"
                    select="count($context/ancestor::substeps)"/>
      <xsl:variable name="sstype" select="($ssdepth mod $format.length)+2"/>
      <xsl:choose>
        <xsl:when test="$sstype &gt; $format.length">
          <xsl:value-of select="substring($procedure.step.numeration.formats,1,1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="substring($procedure.step.numeration.formats,$sstype,1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="local-name($context) = 'step'">
      <xsl:variable name="sdepth"
                    select="count($context/ancestor::substeps)"/>
      <xsl:variable name="stype" select="($sdepth mod $format.length)+1"/>
      <xsl:value-of select="substring($procedure.step.numeration.formats,$stype,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected context in procedure.step.numeration: </xsl:text>
        <xsl:value-of select="local-name($context)"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="step" mode="number">
  <xsl:param name="rest" select="''"/>
  <xsl:param name="recursive" select="1"/>
  <xsl:variable name="format">
    <xsl:call-template name="procedure.step.numeration"/>
  </xsl:variable>
  <xsl:variable name="num">
    <xsl:number count="step" format="{$format}"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$recursive != 0 and ancestor::step">
      <xsl:apply-templates select="ancestor::step[1]" mode="number">
        <xsl:with-param name="rest" select="concat('.', $num, $rest)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($num, $rest)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->
<!-- OrderedList Numeration -->
<xsl:template name="output-orderedlist-starting-number">
  <xsl:param name="list"/>
  <xsl:param name="pi-start"/>
  <xsl:choose>
    <xsl:when test="not($list/@continuation = 'continues')">
      <xsl:choose>
        <xsl:when test="@startingnumber">
          <xsl:value-of select="@startingnumber"/>
        </xsl:when>
        <xsl:when test="$pi-start != ''">
          <xsl:value-of select="$pi-start"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="prevlist"
        select="$list/preceding::orderedlist[1]"/>
      <xsl:choose>
        <xsl:when test="count($prevlist) = 0">2</xsl:when>
        <xsl:otherwise>
          <xsl:variable name="prevlength" select="count($prevlist/listitem)"/>
          <xsl:variable name="prevstart">
            <xsl:call-template name="orderedlist-starting-number">
              <xsl:with-param name="list" select="$prevlist"/>
            </xsl:call-template>
          </xsl:variable>
          <xsl:value-of select="$prevstart + $prevlength"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="orderedlist-item-number">
  <!-- context node must be a listitem in an orderedlist -->
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="$node/@override">
      <xsl:value-of select="$node/@override"/>
    </xsl:when>
    <xsl:when test="$node/preceding-sibling::listitem">
      <xsl:variable name="pnum">
        <xsl:call-template name="orderedlist-item-number">
          <xsl:with-param name="node" select="$node/preceding-sibling::listitem[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$pnum + 1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="orderedlist-starting-number">
        <xsl:with-param name="list" select="parent::*"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="next.numeration">
  <xsl:param name="numeration" select="'default'"/>
  <xsl:choose>
    <!-- Change this list if you want to change the order of numerations -->
    <xsl:when test="$numeration = 'arabic'">loweralpha</xsl:when>
    <xsl:when test="$numeration = 'loweralpha'">lowerroman</xsl:when>
    <xsl:when test="$numeration = 'lowerroman'">upperalpha</xsl:when>
    <xsl:when test="$numeration = 'upperalpha'">upperroman</xsl:when>
    <xsl:when test="$numeration = 'upperroman'">arabic</xsl:when>
    <xsl:otherwise>arabic</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="list.numeration">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="$node/@numeration">
      <xsl:value-of select="$node/@numeration"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$node/ancestor::orderedlist">
          <xsl:call-template name="next.numeration">
            <xsl:with-param name="numeration">
              <xsl:call-template name="list.numeration">
                <xsl:with-param name="node" select="$node/ancestor::orderedlist[1]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="next.numeration"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->
<!-- ItemizedList "Numeration" -->

<xsl:template name="next.itemsymbol">
  <xsl:param name="itemsymbol" select="'default'"/>
  <xsl:choose>
    <!-- Change this list if you want to change the order of symbols -->
    <xsl:when test="$itemsymbol = 'disc'">circle</xsl:when>
    <xsl:when test="$itemsymbol = 'circle'">square</xsl:when>
    <xsl:otherwise>disc</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="list.itemsymbol">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="@override">
      <xsl:value-of select="@override"/>
    </xsl:when>
    <xsl:when test="$node/@mark">
      <xsl:value-of select="$node/@mark"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$node/ancestor::itemizedlist">
          <xsl:call-template name="next.itemsymbol">
            <xsl:with-param name="itemsymbol">
              <xsl:call-template name="list.itemsymbol">
                <xsl:with-param name="node" select="$node/ancestor::itemizedlist[1]"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="next.itemsymbol"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="copyright.years" xmlns="">
<refpurpose>Print a set of years with collapsed ranges</refpurpose>

<refdescription id="copyright.years-desc">
<para>This template prints a list of year elements with consecutive
years printed as a range. In other words:</para>

<screen><![CDATA[<year>1992</year>
<year>1993</year>
<year>1994</year>]]></screen>

<para>is printed <quote>1992-1994</quote>, whereas:</para>

<screen><![CDATA[<year>1992</year>
<year>1994</year>]]></screen>

<para>is printed <quote>1992, 1994</quote>.</para>

<para>This template assumes that all the year elements contain only
decimal year numbers, that the elements are sorted in increasing
numerical order, that there are no duplicates, and that all the years
are expressed in full <quote>century+year</quote>
(<quote>1999</quote> not <quote>99</quote>) notation.</para>
</refdescription>

<refparameter id="copyright.years-params">
<variablelist>
<varlistentry><term>years</term>
<listitem>
<para>The initial set of year elements.</para>
</listitem>
</varlistentry>
<varlistentry><term>print.ranges</term>
<listitem>
<para>If non-zero, multi-year ranges are collapsed. If zero, all years
are printed discretely.</para>
</listitem>
</varlistentry>
<varlistentry><term>single.year.ranges</term>
<listitem>
<para>If non-zero, two consecutive years will be printed as a range,
otherwise, they will be printed discretely. In other words, a single
year range is <quote>1991-1992</quote> but discretely it's
<quote>1991, 1992</quote>.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn id="copyright.years-returns">
<para>This template returns the formatted list of years.</para>
</refreturn>
</doc:template>

<xsl:template name="copyright.years">
  <xsl:param name="years"/>
  <xsl:param name="print.ranges" select="1"/>
  <xsl:param name="single.year.ranges" select="0"/>
  <xsl:param name="firstyear" select="0"/>
  <xsl:param name="nextyear" select="0"/>

  <!--
  <xsl:message terminate="no">
    <xsl:text>CY: </xsl:text>
    <xsl:value-of select="count($years)"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$firstyear"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$nextyear"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$print.ranges"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$single.year.ranges"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="$years[1]"/>
    <xsl:text>)</xsl:text>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$print.ranges = 0 and count($years) &gt; 0">
      <xsl:choose>
        <xsl:when test="count($years) = 1">
          <xsl:apply-templates select="$years[1]" mode="titlepage.mode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$years[1]" mode="titlepage.mode"/>
          <xsl:text>, </xsl:text>
          <xsl:call-template name="copyright.years">
            <xsl:with-param name="years"
                            select="$years[position() &gt; 1]"/>
            <xsl:with-param name="print.ranges" select="$print.ranges"/>
            <xsl:with-param name="single.year.ranges"
                            select="$single.year.ranges"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="count($years) = 0">
      <xsl:variable name="lastyear" select="$nextyear - 1"/>
      <xsl:choose>
        <xsl:when test="$firstyear = 0">
          <!-- there weren't any years at all -->
        </xsl:when>
        <xsl:when test="$firstyear = $lastyear">
          <xsl:value-of select="$firstyear"/>
        </xsl:when>
        <xsl:when test="$single.year.ranges = 0
                        and $lastyear = $firstyear + 1">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$lastyear"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$firstyear"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="$lastyear"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$firstyear = 0">
      <xsl:call-template name="copyright.years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$years[1]"/>
        <xsl:with-param name="nextyear" select="$years[1] + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$nextyear = $years[1]">
      <xsl:call-template name="copyright.years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$firstyear"/>
        <xsl:with-param name="nextyear" select="$nextyear + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- we have years left, but they aren't in the current range -->
      <xsl:choose>
        <xsl:when test="$nextyear = $firstyear + 1">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test="$single.year.ranges = 0
                        and $nextyear = $firstyear + 2">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$nextyear - 1"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$firstyear"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="$nextyear - 1"/>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="copyright.years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$years[1]"/>
        <xsl:with-param name="nextyear" select="$years[1] + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:template name="find.path.params" xmlns="">
<refpurpose>Search in a table for the "best" match for the node</refpurpose>

<refdescription id="find.path.params-desc">
<para>This template searches in a table for the value that most-closely
(in the typical best-match sense of XSLT) matches the current (element)
node location.</para>
</refdescription>
</doc:template>

<xsl:template name="find.path.params">
  <xsl:param name="node" select="."/>
  <xsl:param name="table" select="''"/>
  <xsl:param name="location">
    <xsl:call-template name="xpath.location">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:variable name="value">
    <xsl:call-template name="lookup.key">
      <xsl:with-param name="key" select="$location"/>
      <xsl:with-param name="table" select="$table"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$value != ''">
      <xsl:value-of select="$value"/>
    </xsl:when>
    <xsl:when test="contains($location, '/')">
      <xsl:call-template name="find.path.params">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="table" select="$table"/>
        <xsl:with-param name="location" select="substring-after($location, '/')"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="relative-uri">
  <xsl:param name="filename" select="."/>
  <xsl:param name="destdir" select="''"/>
  
  <xsl:variable name="srcurl">
    <xsl:call-template name="strippath">
      <xsl:with-param name="filename">
        <xsl:call-template name="xml.base.dirs">
          <xsl:with-param name="base.elem" 
                          select="$filename/ancestor-or-self::*
                                   [@xml:base != ''][1]"/>
        </xsl:call-template>
        <xsl:value-of select="$filename"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="srcurl.trimmed">
    <xsl:call-template name="trim.common.uri.paths">
      <xsl:with-param name="uriA" select="$srcurl"/>
      <xsl:with-param name="uriB" select="$destdir"/>
      <xsl:with-param name="return" select="'A'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="destdir.trimmed">
    <xsl:call-template name="trim.common.uri.paths">
      <xsl:with-param name="uriA" select="$srcurl"/>
      <xsl:with-param name="uriB" select="$destdir"/>
      <xsl:with-param name="return" select="'B'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="depth">
    <xsl:call-template name="count.uri.path.depth">
      <xsl:with-param name="filename" select="$destdir.trimmed"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:call-template name="copy-string">
    <xsl:with-param name="string" select="'../'"/>
    <xsl:with-param name="count" select="$depth"/>
  </xsl:call-template>
  <xsl:value-of select="$srcurl.trimmed"/>

</xsl:template>

<!-- ===================================== -->

<xsl:template name="xml.base.dirs">
  <xsl:param name="base.elem" select="NONODE"/>

  <!-- Recursively resolve xml:base attributes, up to a 
       full path with : in uri -->
  <xsl:if test="$base.elem/ancestor::*[@xml:base != ''] and
                not(contains($base.elem/@xml:base, ':'))">
    <xsl:call-template name="xml.base.dirs">
      <xsl:with-param name="base.elem" 
                      select="$base.elem/ancestor::*[@xml:base != ''][1]"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:call-template name="getdir">
    <xsl:with-param name="filename" select="$base.elem/@xml:base"/>
  </xsl:call-template>

</xsl:template>

<!-- ===================================== -->

<xsl:template name="strippath">
  <xsl:param name="filename" select="''"/>
  <xsl:choose>
    <!-- Leading .. are not eliminated -->
    <xsl:when test="starts-with($filename, '../')">
      <xsl:value-of select="'../'"/>
      <xsl:call-template name="strippath">
        <xsl:with-param name="filename" select="substring-after($filename, '../')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="contains($filename, '/../')">
      <xsl:call-template name="strippath">
        <xsl:with-param name="filename">
          <xsl:call-template name="getdir">
            <xsl:with-param name="filename" select="substring-before($filename, '/../')"/>
          </xsl:call-template>
          <xsl:value-of select="substring-after($filename, '/../')"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ===================================== -->

<xsl:template name="getdir">
  <xsl:param name="filename" select="''"/>
  <xsl:if test="contains($filename, '/')">
    <xsl:value-of select="substring-before($filename, '/')"/>
    <xsl:text>/</xsl:text>
    <xsl:call-template name="getdir">
      <xsl:with-param name="filename" select="substring-after($filename, '/')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ===================================== -->

<doc:template name="string.upper" xmlns="">
<refpurpose>Converts a string to all uppercase letters</refpurpose>

<refdescription id="string.upper-desc">
<para>Given a string, this template does a language-aware conversion
of that string to all uppercase letters, based on the values of the
<literal>lowercase.alpha</literal> and
<literal>uppercase.alpha</literal> gentext keys for the current
locale. It affects only those characters found in the values of
<literal>lowercase.alpha</literal> and
<literal>uppercase.alpha</literal>. All other characters are left
unchanged.</para>
</refdescription>

<refparameter id="string.upper-params">
<variablelist>
<varlistentry><term>string</term>
<listitem>
<para>The string to convert to uppercase.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>
</doc:template>
<xsl:template name="string.upper">
  <xsl:param name="string" select="''"/>
  <xsl:variable name="lowercase.alpha">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'lowercase.alpha'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="uppercase.alpha">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'uppercase.alpha'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="translate($string,$lowercase.alpha,$uppercase.alpha)"/>
</xsl:template>

<!-- ===================================== -->

<doc:template name="string.lower" xmlns="">
<refpurpose>Converts a string to all lowercase letters</refpurpose>

<refdescription id="string.lower-desc">
<para>Given a string, this template does a language-aware conversion
of that string to all lowercase letters, based on the values of the
<literal>uppercase.alpha</literal> and
<literal>lowercase.alpha</literal> gentext keys for the current
locale. It affects only those characters found in the values of
<literal>uppercase.alpha</literal> and
<literal>lowercase.alpha</literal>. All other characters are left
unchanged.</para>
</refdescription>

<refparameter id="string.lower-params">
<variablelist>
<varlistentry><term>string</term>
<listitem>
<para>The string to convert to lowercase.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>
</doc:template>
<xsl:template name="string.lower">
  <xsl:param name="string" select="''"/>
  <xsl:variable name="uppercase.alpha">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'uppercase.alpha'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="lowercase.alpha">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'lowercase.alpha'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="translate($string,$uppercase.alpha,$lowercase.alpha)"/>
</xsl:template>

<!-- ===================================== -->

<doc:template name="select.choice.separator" xmlns="">
  <refpurpose>Returns localized choice separator</refpurpose>
  <refdescription id="select.choice.separator-desc">
    <para>This template enables auto-generation of an appropriate
    localized "choice" separator (for example, "and" or "or") before
    the final item in an inline list (though it could also be useful
    for generating choice separators for non-inline lists).</para>
    <para>It currently works by evaluating a processing instruction
    (PI) of the form &lt;?dbchoice&#xa0;choice="foo"?> :
    <itemizedlist>
      <listitem>
        <simpara>if the value of the <tag>choice</tag>
        pseudo-attribute is "and" or "or", returns a localized "and"
        or "or"</simpara>
      </listitem>
      <listitem>
        <simpara>otherwise returns the literal value of the
        <tag>choice</tag> pseudo-attribute</simpara>
      </listitem>
    </itemizedlist>
    The latter is provided only as a temporary workaround because the
    locale files do not currently have translations for the word
    <wordasword>or</wordasword>. So if you want to generate a a
    logical "or" separator in French (for example), you currently need
    to do this:
    <literallayout>&lt;?dbchoice choice="ou"?></literallayout>
    </para>
    <warning>
      <para>The <tag>dbchoice</tag> processing instruction is
      an unfortunate hack; support for it may disappear in the future
      (particularly if and when a more appropriate means for marking
      up "choice" lists becomes available in DocBook).</para>
    </warning>
  </refdescription>
</doc:template>
<xsl:template name="select.choice.separator">
  <xsl:variable name="choice">
    <xsl:call-template name="pi.dbchoice_choice"/>
  </xsl:variable>
  <xsl:choose>
    <!-- if value of $choice is "and" or "or", translate to equivalent in -->
    <!-- current locale -->
    <xsl:when test="$choice = 'and' or $choice = 'or'">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="$choice"/>
      </xsl:call-template>
    </xsl:when>
    <!--  otherwise, just output value of $choice, whatever it is -->
    <xsl:otherwise>
      <xsl:value-of select="$choice"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ===================================== -->

<doc:template name="evaluate.info.profile" xmlns="">
  <refpurpose>Evaluates an info profile</refpurpose>
  <refdescription id="evaluate.info.profile-desc">
    <para>This template evaluates an "info profile" matching the XPath
    expression given by the <parameter>profile</parameter>
    parameter. It relies on the XSLT <function>evaluate()</function>
    extension function.</para>

    <para>The value of the <parameter>profile</parameter> parameter
    can include the literal string <literal>$info</literal>. If found
    in the value of the <parameter>profile</parameter> parameter, the
    literal string <literal>$info</literal> string is replaced with
    the value of the <parameter>info</parameter> parameter, which
    should be a set of <replaceable>*info</replaceable> nodes; the
    expression is then evaluated using the XSLT
    <function>evaluate()</function> extension function.</para>
  </refdescription>
  <refparameter id="evaluate.info.profile-params">
    <variablelist>
       <varlistentry>
        <term>profile</term>
        <listitem>
          <para>A string representing an XPath expression </para>
        </listitem>
      </varlistentry>
       <varlistentry>
        <term>info</term>
        <listitem>
          <para>A set of *info nodes</para>
        </listitem>
      </varlistentry>
    </variablelist>
  </refparameter>

  <refreturn id="evaluate.info.profile-returns">
    <para>Returns a node (the result of evaluating the
    <parameter>profile</parameter> parameter)</para>
  </refreturn>
</doc:template>
  <xsl:template name="evaluate.info.profile">
    <xsl:param name="profile"/>
    <xsl:param name="info"/>
    <xsl:choose>
      <!-- * xsltproc and Xalan both support dyn:evaluate() -->
      <xsl:when test="function-available('dyn:evaluate')">
        <xsl:apply-templates
            select="dyn:evaluate($profile)" mode="get.refentry.metadata"/>
      </xsl:when>
      <!-- * Saxon has its own evaluate() & doesn't support dyn:evaluate() -->
      <xsl:when test="function-available('saxon:evaluate')">
        <xsl:apply-templates
            select="saxon:evaluate($profile)" mode="get.refentry.metadata"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
Error: The "info profiling" mechanism currently requires an XSLT
engine that supports the evaluate() XSLT extension function. Your XSLT
engine does not support it.
</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->


<xsl:template match="*" mode="object.title.template">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'title'"/>
    <xsl:with-param name="name">
      <xsl:call-template name="xpath.location"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter" mode="object.title.template">
  <xsl:choose>
    <xsl:when test="string($chapter.autolabel) != 0">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="appendix" mode="object.title.template">
  <xsl:choose>
    <xsl:when test="string($appendix.autolabel) != 0">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="part" mode="object.title.template">
  <xsl:choose>
    <xsl:when test="string($part.autolabel) != 0">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="section|sect1|sect2|sect3|sect4|sect5|simplesect
                     |bridgehead"
              mode="object.title.template">
  <xsl:variable name="is.numbered">
    <xsl:call-template name="label.this.section"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$is.numbered != 0">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-numbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title-unnumbered'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="procedure" mode="object.title.template">
  <xsl:choose>
    <xsl:when test="$formal.procedures != 0 and title">
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
          <xsl:text>.formal</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.template">
        <xsl:with-param name="context" select="'title'"/>
        <xsl:with-param name="name">
          <xsl:call-template name="xpath.location"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="object.subtitle.template">
  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="'subtitle'"/>
    <xsl:with-param name="name">
      <xsl:call-template name="xpath.location"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="is.autonumber">
  <xsl:value-of select="'0'"/>
</xsl:template>

<xsl:template match="section|sect1|sect2|sect3|sect4|sect5" 
              mode="is.autonumber">
  <xsl:call-template name="label.this.section"/>
</xsl:template>

<xsl:template match="figure|example|table|equation" mode="is.autonumber">
  <xsl:value-of select="'1'"/>
</xsl:template>

<xsl:template match="appendix" mode="is.autonumber">
  <xsl:value-of select="$appendix.autolabel"/>
</xsl:template>

<xsl:template match="chapter" mode="is.autonumber">
  <xsl:value-of select="$chapter.autolabel"/>
</xsl:template>

<xsl:template match="part" mode="is.autonumber">
  <xsl:value-of select="$part.autolabel"/>
</xsl:template>

<xsl:template match="preface" mode="is.autonumber">
  <xsl:value-of select="$preface.autolabel"/>
</xsl:template>

<xsl:template match="question|answer" mode="is.autonumber">
  <xsl:choose>
    <xsl:when test="$qanda.defaultlabel = 'number'
                    and not(label)">
      <xsl:value-of select="'1'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'0'"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="qandadiv" mode="is.autonumber">
  <xsl:value-of select="$qandadiv.autolabel"/>
</xsl:template>

<xsl:template match="bridgehead" mode="is.autonumber">
  <xsl:value-of select="$section.autolabel"/>
</xsl:template>

<xsl:template match="*" mode="object.xref.template">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>

  <!-- Is autonumbering on? -->
  <xsl:variable name="autonumber">
    <xsl:apply-templates select="." mode="is.autonumber"/>
  </xsl:variable>

  <xsl:variable name="number-and-title-template">
    <xsl:call-template name="gentext.template.exists">
      <xsl:with-param name="context" select="'xref-number-and-title'"/>
      <xsl:with-param name="name">
        <xsl:call-template name="xpath.location"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number-template">
    <xsl:call-template name="gentext.template.exists">
      <xsl:with-param name="context" select="'xref-number'"/>
      <xsl:with-param name="name">
        <xsl:call-template name="xpath.location"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="context">
    <xsl:choose>
      <xsl:when test="string($autonumber) != 0 
                      and $number-and-title-template != 0
                      and $xref.with.number.and.title != 0">
         <xsl:value-of select="'xref-number-and-title'"/>
      </xsl:when>
      <xsl:when test="string($autonumber) != 0 
                      and $number-template != 0">
         <xsl:value-of select="'xref-number'"/>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="'xref'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="gentext.template">
    <xsl:with-param name="context" select="$context"/>
    <xsl:with-param name="name">
      <xsl:call-template name="xpath.location"/>
    </xsl:with-param>
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:call-template>

</xsl:template>


<!-- ============================================================ -->

<xsl:template match="*" mode="object.title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="template">
    <xsl:apply-templates select="." mode="object.title.template"/>
  </xsl:variable>

<!--
  <xsl:message>
    <xsl:text>object.title.markup: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text>: </xsl:text>
    <xsl:value-of select="$template"/>
  </xsl:message>
-->

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
    <xsl:with-param name="template" select="$template"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" mode="object.title.markup.textonly">
  <xsl:variable name="title">
    <xsl:apply-templates select="." mode="object.title.markup"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($title)"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="object.titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <!-- Just for consistency in template naming -->

  <xsl:apply-templates select="." mode="titleabbrev.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="object.subtitle.markup">
  <xsl:variable name="template">
    <xsl:apply-templates select="." mode="object.subtitle.template"/>
  </xsl:variable>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="template" select="$template"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="object.xref.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="template">
    <xsl:choose>
      <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:')">
        <xsl:call-template name="make.gentext.template">
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="starts-with(normalize-space($xrefstyle), 'template:')">
        <xsl:value-of select="substring-after(normalize-space($xrefstyle), 'template:')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="object.xref.template">
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

<!-- 
  <xsl:message>
    <xsl:text>object.xref.markup: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text>(</xsl:text>
    <xsl:value-of select="$xrefstyle"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$purpose"/>
    <xsl:text>)</xsl:text>
    <xsl:text>: [</xsl:text>
    <xsl:value-of select="$template"/>
    <xsl:text>]</xsl:text>
  </xsl:message>
-->

  <xsl:if test="$template = '' and $verbose != 0">
    <xsl:message>
      <xsl:text>object.xref.markup: empty xref template</xsl:text>
      <xsl:text> for linkend="</xsl:text>
      <xsl:value-of select="@id|@xml:id"/>
      <xsl:text>" and @xrefstyle="</xsl:text>
      <xsl:value-of select="$xrefstyle"/>
      <xsl:text>"</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="template" select="$template"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="listitem" mode="object.xref.markup">
  <xsl:param name="verbose" select="1"/>

  <xsl:choose>
    <xsl:when test="parent::orderedlist">
      <xsl:variable name="template">
        <xsl:apply-templates select="." mode="object.xref.template"/>
      </xsl:variable>
      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template" select="$template"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$verbose != 0">
      <xsl:message>
        <xsl:text>Xref is only supported to listitems in an</xsl:text>
        <xsl:text> orderedlist: </xsl:text>
        <xsl:value-of select="@id|@xml:id"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="question" mode="object.xref.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*[@defaultlabel]">
        <xsl:value-of select="(ancestor-or-self::*[@defaultlabel])[last()]
                              /@defaultlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="template">
    <xsl:choose>
      <!-- This avoids double Q: Q: in xref when defaultlabel=qanda -->
      <xsl:when test="$deflabel = 'qanda' and not(label)">%n</xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="object.xref.template">
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="substitute-markup">
    <xsl:with-param name="purpose" select="$purpose"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="template" select="$template"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="substitute-markup">
  <xsl:param name="template" select="''"/>
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:param name="title" select="''"/>
  <xsl:param name="subtitle" select="''"/>
  <xsl:param name="docname" select="''"/>
  <xsl:param name="label" select="''"/>
  <xsl:param name="pagenumber" select="''"/>
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="verbose"/>

  <xsl:choose>
    <xsl:when test="contains($template, '%')">
      <xsl:call-template name="scape">
        <xsl:with-param name="string" select="substring-before($template, '%')"/>
      </xsl:call-template>
      <xsl:variable name="candidate"
             select="substring(substring-after($template, '%'), 1, 1)"/>
      <xsl:choose>
        <xsl:when test="$candidate = 't'">
          <xsl:apply-templates select="." mode="insert.title.markup">
            <xsl:with-param name="referrer" select="$referrer"/>
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="title">
              <xsl:choose>
                <xsl:when test="$title != ''">
                  <xsl:copy-of select="$title"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="title.markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                    <xsl:with-param name="verbose" select="$verbose"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 's'">
          <xsl:apply-templates select="." mode="insert.subtitle.markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="subtitle">
              <xsl:choose>
                <xsl:when test="$subtitle != ''">
                  <xsl:copy-of select="$subtitle"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="subtitle.markup">
                    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
                  </xsl:apply-templates>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'n'">
          <xsl:apply-templates select="." mode="insert.label.markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="label">
              <xsl:choose>
                <xsl:when test="$label != ''">
                  <xsl:copy-of select="$label"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="label.markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'p'">
          <xsl:apply-templates select="." mode="insert.pagenumber.markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="pagenumber">
              <xsl:choose>
                <xsl:when test="$pagenumber != ''">
                  <xsl:copy-of select="$pagenumber"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="pagenumber.markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'o'">
          <!-- olink target document title -->
          <xsl:apply-templates select="." mode="insert.olink.docname.markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="docname">
              <xsl:choose>
                <xsl:when test="$docname != ''">
                  <xsl:copy-of select="$docname"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:apply-templates select="." mode="olink.docname.markup"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = 'd'">
          <xsl:apply-templates select="." mode="insert.direction.markup">
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="direction">
              <xsl:choose>
                <xsl:when test="$referrer">
                  <xsl:variable name="referent-is-below">
                    <xsl:for-each select="preceding::xref">
                      <xsl:if test="generate-id(.) = generate-id($referrer)">1</xsl:if>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:choose>
                    <xsl:when test="$referent-is-below = ''">
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'above'"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="gentext">
                        <xsl:with-param name="key" select="'below'"/>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>Attempt to use %d in gentext with no referrer!</xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:apply-templates>
        </xsl:when>
        <xsl:when test="$candidate = '%' ">
          <xsl:text>%</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>%</xsl:text><xsl:value-of select="$candidate"/>
        </xsl:otherwise>
      </xsl:choose>
      <!-- recurse with the rest of the template string -->
      <xsl:variable name="rest"
            select="substring($template,
            string-length(substring-before($template, '%'))+3)"/>
      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template" select="$rest"/>
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="title" select="$title"/>
        <xsl:with-param name="subtitle" select="$subtitle"/>
        <xsl:with-param name="docname" select="$docname"/>
        <xsl:with-param name="label" select="$label"/>
        <xsl:with-param name="pagenumber" select="$pagenumber"/>
        <xsl:with-param name="purpose" select="$purpose"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="scape">
        <xsl:with-param name="string" select="$template"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="make.gentext.template">
  <xsl:param name="xrefstyle" select="''"/>
  <xsl:param name="purpose"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>
  <xsl:param name="target.elem" select="local-name(.)"/>

  <!-- parse xrefstyle to get parts -->
  <xsl:variable name="parts"
      select="substring-after(normalize-space($xrefstyle), 'select:')"/>

  <xsl:variable name="labeltype">
    <xsl:choose>
      <xsl:when test="contains($parts, 'labelnumber')">
         <xsl:text>labelnumber</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'labelname')">
         <xsl:text>labelname</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'label')">
         <xsl:text>label</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="titletype">
    <xsl:choose>
      <xsl:when test="contains($parts, 'quotedtitle')">
         <xsl:text>quotedtitle</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'title')">
         <xsl:text>title</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="pagetype">
    <xsl:choose>
      <xsl:when test="$insert.olink.page.number = 'no' and
                      local-name($referrer) = 'olink'">
        <!-- suppress page numbers -->
      </xsl:when>
      <xsl:when test="$insert.xref.page.number = 'no' and
                      local-name($referrer) != 'olink'">
        <!-- suppress page numbers -->
      </xsl:when>
      <xsl:when test="contains($parts, 'nopage')">
         <xsl:text>nopage</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'pagenumber')">
         <xsl:text>pagenumber</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'pageabbrev')">
         <xsl:text>pageabbrev</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'Page')">
         <xsl:text>Page</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'page')">
         <xsl:text>page</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="docnametype">
    <xsl:choose>
      <xsl:when test="($olink.doctitle = 0 or
                       $olink.doctitle = 'no') and
                      local-name($referrer) = 'olink'">
        <!-- suppress docname -->
      </xsl:when>
      <xsl:when test="contains($parts, 'nodocname')">
         <xsl:text>nodocname</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'docnamelong')">
         <xsl:text>docnamelong</xsl:text>
      </xsl:when>
      <xsl:when test="contains($parts, 'docname')">
         <xsl:text>docname</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$labeltype != ''">
    <xsl:choose>
      <xsl:when test="$labeltype = 'labelname'">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key">
            <xsl:choose>
              <xsl:when test="local-name($referrer) = 'olink'">
                <xsl:value-of select="$target.elem"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="local-name(.)"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$labeltype = 'labelnumber'">
        <xsl:text>%n</xsl:text>
      </xsl:when>
      <xsl:when test="$labeltype = 'label'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref-number'"/>
          <xsl:with-param name="name">
            <xsl:choose>
              <xsl:when test="local-name($referrer) = 'olink'">
                <xsl:value-of select="$target.elem"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="xpath.location"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
          <xsl:with-param name="purpose" select="$purpose"/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          <xsl:with-param name="referrer" select="$referrer"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$titletype != ''">
        <xsl:value-of select="$xref.label-title.separator"/>
      </xsl:when>
      <xsl:when test="$pagetype != ''">
        <xsl:value-of select="$xref.label-page.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>

  <xsl:if test="$titletype != ''">
    <xsl:choose>
      <xsl:when test="$titletype = 'title'">
        <xsl:text>%t</xsl:text>
      </xsl:when>
      <xsl:when test="$titletype = 'quotedtitle'">
        <xsl:call-template name="gentext.dingbat">
          <xsl:with-param name="dingbat" select="'startquote'"/>
        </xsl:call-template>
        <xsl:text>%t</xsl:text>
        <xsl:call-template name="gentext.dingbat">
          <xsl:with-param name="dingbat" select="'endquote'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

    <xsl:choose>
      <xsl:when test="$pagetype != '' and $pagetype != 'nopage'">
        <xsl:value-of select="$xref.title-page.separator"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
  
  <!-- special case: use regular xref template if just turning off page -->
  <xsl:if test="($pagetype = 'nopage' or $docnametype = 'nodocname')
                  and local-name($referrer) != 'olink'
                  and $labeltype = '' 
                  and $titletype = ''">
    <xsl:apply-templates select="." mode="object.xref.template">
      <xsl:with-param name="purpose" select="$purpose"/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:if>

  <xsl:if test="$pagetype != ''">
    <xsl:choose>
      <xsl:when test="$pagetype = 'page'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'page'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'Page'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'Page'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'pageabbrev'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'pageabbrev'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$pagetype = 'pagenumber'">
        <xsl:text>%p</xsl:text>
      </xsl:when>
    </xsl:choose>

  </xsl:if>

  <!-- Add reference to other document title -->
  <xsl:if test="$docnametype != '' and local-name($referrer) = 'olink'">
    <!-- Any separator should be in the gentext template -->
    <xsl:choose>
      <xsl:when test="$docnametype = 'docnamelong'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'docnamelong'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$docnametype = 'docname'">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="name" select="'docname'"/>
        </xsl:call-template>
      </xsl:when>
    </xsl:choose>

  </xsl:if>
  
</xsl:template>



<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     This file contains localization templates (for internationalization)
     ******************************************************************** -->

<xsl:param name="l10n.xml" select="document('../common/l10n.xml')"/>
<xsl:param name="local.l10n.xml" select="document('')"/>

<xsl:template name="l10n.language">
  <xsl:param name="target" select="."/>
  <xsl:param name="xref-context" select="false()"/>

  <xsl:variable name="mc-language">
    <xsl:choose>
      <xsl:when test="$l10n.gentext.language != ''">
        <xsl:value-of select="$l10n.gentext.language"/>
      </xsl:when>

      <xsl:when test="$xref-context or $l10n.gentext.use.xref.language != 0">
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$target/ancestor-or-self::*
                              [@lang or @xml:lang][1]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>
        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$target/ancestor-or-self::*
                              [@lang or @xml:lang][1]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>

        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="language" select="translate($mc-language,
                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                        'abcdefghijklmnopqrstuvwxyz')"/>

  <xsl:variable name="adjusted.language">
    <xsl:choose>
      <xsl:when test="contains($language,'-')">
        <xsl:value-of select="substring-before($language,'-')"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="substring-after($language,'-')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$l10n.xml/l:i18n/l:l10n[@language=$adjusted.language]">
      <xsl:value-of select="$adjusted.language"/>
    </xsl:when>
    <!-- try just the lang code without country -->
    <xsl:when test="$l10n.xml/l:i18n/l:l10n[@language=substring-before($adjusted.language,'_')]">
      <xsl:value-of select="substring-before($adjusted.language,'_')"/>
    </xsl:when>
    <!-- or use the default -->
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No localization exists for "</xsl:text>
        <xsl:value-of select="$adjusted.language"/>
        <xsl:text>" or "</xsl:text>
        <xsl:value-of select="substring-before($adjusted.language,'_')"/>
        <xsl:text>". Using default "</xsl:text>
        <xsl:value-of select="$l10n.gentext.default.language"/>
        <xsl:text>".</xsl:text>
      </xsl:message>
      <xsl:value-of select="$l10n.gentext.default.language"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="language.attribute">
  <xsl:param name="node" select="."/>

  <xsl:variable name="language">
    <xsl:choose>
      <xsl:when test="$l10n.gentext.language != ''">
        <xsl:value-of select="$l10n.gentext.language"/>
      </xsl:when>

      <xsl:otherwise>
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$node/ancestor-or-self::*
                              [@lang or @xml:lang][1]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>

        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$language != ''">
    <xsl:attribute name="lang">
      <xsl:choose>
        <xsl:when test="$l10n.lang.value.rfc.compliant != 0">
          <xsl:value-of select="translate($language, '_', '-')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$language"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:if>

  <!-- FIXME: This is sort of hack, but it was the easiest way to add at least partial support for dir attribute -->
  <xsl:copy-of select="ancestor-or-self::*[@dir][1]/@dir"/>
</xsl:template>

<xsl:template name="gentext">
  <xsl:param name="key" select="local-name(.)"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:variable name="local.l10n.gentext"
                select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang]/l:gentext[@key=$key])[1]"/>

  <xsl:variable name="l10n.gentext"
                select="($l10n.xml/l:i18n/l:l10n[@language=$lang]/l:gentext[@key=$key])[1]"/>

  <xsl:call-template name="scape">
  <xsl:with-param name="string">
  <xsl:choose>
    <xsl:when test="$local.l10n.gentext">
      <xsl:value-of select="$local.l10n.gentext/@text"/>
    </xsl:when>
    <xsl:when test="$l10n.gentext">
      <xsl:value-of select="$l10n.gentext/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No "</xsl:text>
        <xsl:value-of select="$lang"/>
        <xsl:text>" localization of "</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>" exists</xsl:text>
        <xsl:choose>
          <xsl:when test="$lang = 'en'">
             <xsl:text>.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
             <xsl:text>; using "en".</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:message>

      <xsl:value-of select="($l10n.xml/l:i18n/l:l10n[@language='en']/l:gentext[@key=$key])[1]/@text"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.element.name">
  <xsl:param name="element.name" select="local-name(.)"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="$element.name"/>
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.space">
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template name="gentext.edited.by">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Editedby'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.by">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'by'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.dingbat">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:variable name="local.l10n.dingbat"
                select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang]/l:dingbat[@key=$dingbat])[1]"/>

  <xsl:variable name="l10n.dingbat"
                select="($l10n.xml/l:i18n/l:l10n[@language=$lang]/l:dingbat[@key=$dingbat])[1]"/>

  <xsl:variable name="text">
  <xsl:choose>
    <xsl:when test="$local.l10n.dingbat">
      <xsl:value-of select="$local.l10n.dingbat/@text"/>
    </xsl:when>
    <xsl:when test="$l10n.dingbat">
      <xsl:value-of select="$l10n.dingbat/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No "</xsl:text>
        <xsl:value-of select="$lang"/>
        <xsl:text>" localization of dingbat </xsl:text>
        <xsl:value-of select="$dingbat"/>
        <xsl:text> exists; using "en".</xsl:text>
      </xsl:message>

      <xsl:value-of select="($l10n.xml/l:i18n/l:l10n[@language='en']/l:dingbat[@key=$dingbat])[1]/@text"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="scape">
    <xsl:with-param name="string" select="$text"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.startquote">
  <xsl:call-template name="gentext.dingbat">
    <xsl:with-param name="dingbat">startquote</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.endquote">
  <xsl:call-template name="gentext.dingbat">
    <xsl:with-param name="dingbat">endquote</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.nestedstartquote">
  <xsl:call-template name="gentext.dingbat">
    <xsl:with-param name="dingbat">nestedstartquote</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.nestedendquote">
  <xsl:call-template name="gentext.dingbat">
    <xsl:with-param name="dingbat">nestedendquote</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.nav.prev">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'nav-prev'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.nav.next">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'nav-next'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.nav.home">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'nav-home'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="gentext.nav.up">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'nav-up'"/>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="gentext.template">
  <xsl:param name="context" select="'default'"/>
  <xsl:param name="name" select="'default'"/>
  <xsl:param name="origname" select="$name"/>
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="local.localization.node"
                select="($local.l10n.xml//l:i18n/l:l10n[@language=$lang])[1]"/>

  <xsl:variable name="localization.node"
                select="($l10n.xml/l:i18n/l:l10n[@language=$lang])[1]"/>

  <xsl:if test="count($localization.node) = 0
                and count($local.localization.node) = 0
                and $verbose != 0">
    <xsl:message>
      <xsl:text>No "</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>" localization exists.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="local.context.node"
                select="$local.localization.node/l:context[@name=$context]"/>

  <xsl:variable name="context.node"
                select="$localization.node/l:context[@name=$context]"/>

  <xsl:if test="count($context.node) = 0
                and count($local.context.node) = 0
                and $verbose != 0">
    <xsl:message>
      <xsl:text>No context named "</xsl:text>
      <xsl:value-of select="$context"/>
      <xsl:text>" exists in the "</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>" localization.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="local.template.node"
                select="($local.context.node/l:template[@name=$name
                                                        and @style
                                                        and @style=$xrefstyle]
                        |$local.context.node/l:template[@name=$name
                                                        and not(@style)])[1]"/>

  <xsl:variable name="template.node"
                select="($context.node/l:template[@name=$name
                                                  and @style
                                                  and @style=$xrefstyle]
                        |$context.node/l:template[@name=$name
                                                  and not(@style)])[1]"/>

  <xsl:choose>
    <xsl:when test="$local.template.node/@text">
      <xsl:value-of select="$local.template.node/@text"/>
    </xsl:when>
    <xsl:when test="$template.node/@text">
      <xsl:value-of select="$template.node/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="contains($name, '/')">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="name" select="substring-after($name, '/')"/>
            <xsl:with-param name="origname" select="$origname"/>
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="referrer" select="$referrer"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="verbose" select="$verbose"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$verbose = 0">
          <!-- silence -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No template for "</xsl:text>
            <xsl:value-of select="$origname"/>
            <xsl:text>" (or any of its leaves) exists
in the context named "</xsl:text>
            <xsl:value-of select="$context"/>
            <xsl:text>" in the "</xsl:text>
            <xsl:value-of select="$lang"/>
            <xsl:text>" localization.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- silently test if a gentext template exists -->

<xsl:template name="gentext.template.exists">
  <xsl:param name="context" select="'default'"/>
  <xsl:param name="name" select="'default'"/>
  <xsl:param name="origname" select="$name"/>
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:variable name="template">
    <xsl:call-template name="gentext.template">
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="name" select="$name"/>
      <xsl:with-param name="origname" select="$origname"/>
      <xsl:with-param name="purpose" select="$purpose"/>
      <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      <xsl:with-param name="referrer" select="$referrer"/>
      <xsl:with-param name="lang" select="$lang"/>
      <xsl:with-param name="verbose" select="0"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="string-length($template) != 0">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- label markup -->

<doc:mode mode="label.markup" xmlns="">
<refpurpose>Provides access to element labels</refpurpose>
<refdescription id="label.markup-desc">
<para>Processing an element in the
<literal role="mode">label.markup</literal> mode produces the
element label.</para>
<para>Trailing punctuation is not added to the label.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="intralabel.punctuation">
  <xsl:text>.</xsl:text>
</xsl:template>

<xsl:template match="*" mode="label.markup">
  <xsl:param name="verbose" select="1"/>
  <xsl:if test="$verbose">
    <xsl:message>
      <xsl:text>Request for label of unexpected element: </xsl:text>
      <xsl:value-of select="local-name(.)"/>
    </xsl:message>
  </xsl:if>
</xsl:template>

<xsl:template match="set|book" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="part" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($part.autolabel) != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$part.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number from="book" count="part" format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="partintro" mode="label.markup">
  <!-- no label -->
</xsl:template>

<xsl:template match="preface" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($preface.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::part" 
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::part" 
                               mode="intralabel.punctuation"/>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$preface.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::part">
          <xsl:number from="part" count="preface" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="book" count="preface" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="chapter" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($chapter.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::part" 
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::part" 
                               mode="intralabel.punctuation"/>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$chapter.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::part">
          <xsl:number from="part" count="chapter" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="book" count="chapter" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="appendix" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($appendix.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::part" 
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::part" 
                               mode="intralabel.punctuation"/>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$appendix.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::part">
          <xsl:number from="part" count="appendix" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="book|article"
                      count="appendix" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="article" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="dedication|colophon" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="reference" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="string($reference.autolabel) != 0">
      <xsl:if test="$component.label.includes.part.label != 0 and
                      ancestor::part">
        <xsl:variable name="part.label">
          <xsl:apply-templates select="ancestor::part" 
                               mode="label.markup"/>
        </xsl:variable>
        <xsl:if test="$part.label != ''">
          <xsl:value-of select="$part.label"/>
          <xsl:apply-templates select="ancestor::part" 
                               mode="intralabel.punctuation"/>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$reference.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="$label.from.part != 0 and ancestor::part">
          <xsl:number from="part" count="reference" format="{$format}" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number from="book" count="reference" format="{$format}" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="refentry" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="section" mode="label.markup">
  <!-- if this is a nested section, label the parent -->
  <xsl:if test="local-name(..) = 'section'">
    <xsl:variable name="parent.section.label">
      <xsl:call-template name="label.this.section">
        <xsl:with-param name="section" select=".."/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:if test="$parent.section.label != '0'">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
    </xsl:if>
  </xsl:if>

  <!-- if the parent is a component, maybe label that too -->
  <xsl:variable name="parent.is.component">
    <xsl:call-template name="is.component">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <!-- does this section get labelled? -->
  <xsl:variable name="label">
    <xsl:call-template name="label.this.section">
      <xsl:with-param name="section" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$section.label.includes.component.label != 0
                and $parent.is.component != 0">
    <xsl:variable name="parent.label">
      <xsl:apply-templates select=".." mode="label.markup"/>
    </xsl:variable>
    <xsl:if test="$parent.label != ''">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
    </xsl:if>
  </xsl:if>

<!--
  <xsl:message>
    test: <xsl:value-of select="$label"/>, <xsl:number count="section"/>
  </xsl:message>
-->

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label != 0">      
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number format="{$format}" count="section"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="sect1" mode="label.markup">
  <!-- if the parent is a component, maybe label that too -->
  <xsl:variable name="parent.is.component">
    <xsl:call-template name="is.component">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="component.label">
    <xsl:if test="$section.label.includes.component.label != 0
                  and $parent.is.component != 0">
      <xsl:variable name="parent.label">
        <xsl:apply-templates select=".." mode="label.markup"/>
      </xsl:variable>
      <xsl:if test="$parent.label != ''">
        <xsl:apply-templates select=".." mode="label.markup"/>
        <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
      </xsl:if>
    </xsl:if>
  </xsl:variable>


  <xsl:variable name="is.numbered">
    <xsl:call-template name="label.this.section"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$is.numbered != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:copy-of select="$component.label"/>
      <xsl:number format="{$format}" count="sect1"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="sect2|sect3|sect4|sect5" mode="label.markup">
  <!-- label the parent -->
  <xsl:variable name="parent.section.label">
    <xsl:call-template name="label.this.section">
      <xsl:with-param name="section" select=".."/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$parent.section.label != '0'">
    <xsl:apply-templates select=".." mode="label.markup"/>
    <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
  </xsl:if>

  <xsl:variable name="is.numbered">
    <xsl:call-template name="label.this.section"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$is.numbered != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="local-name(.) = 'sect2'">
          <xsl:number format="{$format}" count="sect2"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect3'">
          <xsl:number format="{$format}" count="sect3"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect4'">
          <xsl:number format="{$format}" count="sect4"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect5'">
          <xsl:number format="{$format}" count="sect5"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>label.markup: this can't happen!</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="bridgehead" mode="label.markup">
  <!-- FIXME: could we do a better job here? -->
  <xsl:variable name="contsec"
                select="(ancestor::section
                         |ancestor::simplesect
                         |ancestor::sect1
                         |ancestor::sect2
                         |ancestor::sect3
                         |ancestor::sect4
                         |ancestor::sect5
                         |ancestor::refsect1
                         |ancestor::refsect2
                         |ancestor::refsect3
                         |ancestor::chapter
                         |ancestor::appendix
                         |ancestor::preface)[last()]"/>

  <xsl:apply-templates select="$contsec" mode="label.markup"/>
</xsl:template>

<xsl:template match="refsect1" mode="label.markup">
  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$section.autolabel != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number count="refsect1" format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="refsect2|refsect3" mode="label.markup">
  <!-- label the parent -->
  <xsl:variable name="parent.label">
    <xsl:apply-templates select=".." mode="label.markup"/>
  </xsl:variable>
  <xsl:if test="$parent.label != ''">
    <xsl:apply-templates select=".." mode="label.markup"/>
    <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$section.autolabel != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="local-name(.) = 'refsect2'">
          <xsl:number count="refsect2" format="{$format}"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="refsect3" format="{$format}"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="simplesect" mode="label.markup">
  <!-- if this is a nested section, label the parent -->
  <xsl:if test="local-name(..) = 'section'
                or local-name(..) = 'sect1'
                or local-name(..) = 'sect2'
                or local-name(..) = 'sect3'
                or local-name(..) = 'sect4'
                or local-name(..) = 'sect5'">
    <xsl:variable name="parent.section.label">
      <xsl:apply-templates select=".." mode="label.markup"/>
    </xsl:variable>
    <xsl:if test="$parent.section.label != ''">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
    </xsl:if>
  </xsl:if>

  <!-- if the parent is a component, maybe label that too -->
  <xsl:variable name="parent.is.component">
    <xsl:call-template name="is.component">
      <xsl:with-param name="node" select=".."/>
    </xsl:call-template>
  </xsl:variable>

  <!-- does this section get labelled? -->
  <xsl:variable name="label">
    <xsl:call-template name="label.this.section">
      <xsl:with-param name="section" select="."/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$section.label.includes.component.label != 0
                and $parent.is.component != 0">
    <xsl:variable name="parent.label">
      <xsl:apply-templates select=".." mode="label.markup"/>
    </xsl:variable>
    <xsl:if test="$parent.label != ''">
      <xsl:apply-templates select=".." mode="label.markup"/>
      <xsl:apply-templates select=".." mode="intralabel.punctuation"/>
    </xsl:if>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$label != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$section.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:number format="{$format}" count="simplesect"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="qandadiv" mode="label.markup">
  <xsl:variable name="lparent" select="(ancestor::set
                                       |ancestor::book
                                       |ancestor::chapter
                                       |ancestor::appendix
                                       |ancestor::preface
                                       |ancestor::section
                                       |ancestor::simplesect
                                       |ancestor::sect1
                                       |ancestor::sect2
                                       |ancestor::sect3
                                       |ancestor::sect4
                                       |ancestor::sect5
                                       |ancestor::refsect1
                                       |ancestor::refsect2
                                       |ancestor::refsect3)[last()]"/>

  <xsl:variable name="lparent.prefix">
    <xsl:apply-templates select="$lparent" mode="label.markup"/>
  </xsl:variable>

  <xsl:variable name="prefix">
    <xsl:if test="$qanda.inherit.numeration != 0">
      <xsl:if test="$lparent.prefix != ''">
        <xsl:apply-templates select="$lparent" mode="label.markup"/>
        <xsl:apply-templates select="$lparent" mode="intralabel.punctuation"/>
      </xsl:if>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$qandadiv.autolabel != 0">
      <xsl:variable name="format">
        <xsl:call-template name="autolabel.format">
          <xsl:with-param name="format" select="$qandadiv.autolabel"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$prefix"/>
      <xsl:number level="multiple" count="qandadiv" format="{$format}"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="question|answer" mode="label.markup">
  <xsl:variable name="lparent" select="(ancestor::set
                                       |ancestor::book
                                       |ancestor::chapter
                                       |ancestor::appendix
                                       |ancestor::preface
                                       |ancestor::section
                                       |ancestor::simplesect
                                       |ancestor::sect1
                                       |ancestor::sect2
                                       |ancestor::sect3
                                       |ancestor::sect4
                                       |ancestor::sect5
                                       |ancestor::refsect1
                                       |ancestor::refsect2
                                       |ancestor::refsect3)[last()]"/>

  <xsl:variable name="lparent.prefix">
    <xsl:apply-templates select="$lparent" mode="label.markup"/>
  </xsl:variable>

  <xsl:variable name="prefix">
    <xsl:if test="$qanda.inherit.numeration != 0">
      <xsl:choose>
        <xsl:when test="ancestor::qandadiv">
          <xsl:apply-templates select="ancestor::qandadiv[1]" mode="label.markup"/>
          <xsl:apply-templates select="ancestor::qandadiv[1]"
                               mode="intralabel.punctuation"/>
        </xsl:when>
        <xsl:when test="$lparent.prefix != ''">
          <xsl:apply-templates select="$lparent" mode="label.markup"/>
          <xsl:apply-templates select="$lparent" mode="intralabel.punctuation"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="inhlabel"
                select="ancestor-or-self::qandaset/@defaultlabel[1]"/>

  <xsl:variable name="deflabel">
    <xsl:choose>
      <xsl:when test="$inhlabel != ''">
        <xsl:value-of select="$inhlabel"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$qanda.defaultlabel"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="label" select="label"/>

  <xsl:choose>
    <xsl:when test="count($label)>0">
      <xsl:apply-templates select="$label"/>
    </xsl:when>

    <xsl:when test="$deflabel = 'qanda' and local-name(.) = 'question'">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Question'"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="$deflabel = 'qanda' and local-name(.) = 'answer'">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Answer'"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="$deflabel = 'number' and local-name(.) = 'question'">
      <xsl:value-of select="$prefix"/>
      <xsl:number level="multiple" count="qandaentry" format="1"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="bibliography|glossary|
                     qandaset|index|setindex" mode="label.markup">
  <xsl:if test="@label">
    <xsl:value-of select="@label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="figure|table|example" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
            <xsl:apply-templates select="$pchap" mode="intralabel.punctuation"/>
          <xsl:number format="1" from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="1" from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="procedure" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:when test="$formal.procedures = 0">
      <!-- No label -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count($pchap)>0">
          <xsl:if test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
            <xsl:apply-templates select="$pchap" mode="intralabel.punctuation"/>
          </xsl:if>
          <xsl:number count="procedure[title]" format="1" 
                      from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number count="procedure[title]" format="1" 
                      from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="equation" mode="label.markup">
  <xsl:variable name="pchap"
                select="ancestor::chapter
                        |ancestor::appendix
                        |ancestor::article[ancestor::book]"/>

  <xsl:variable name="prefix">
    <xsl:if test="count($pchap) &gt; 0">
      <xsl:apply-templates select="$pchap" mode="label.markup"/>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="@label">
      <xsl:value-of select="@label"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="count($pchap)>0">
          <xsl:if test="$prefix != ''">
            <xsl:apply-templates select="$pchap" mode="label.markup"/>
            <xsl:apply-templates select="$pchap" mode="intralabel.punctuation"/>
          </xsl:if>
          <xsl:number format="1" count="equation[title or info/title]" 
                from="chapter|appendix" level="any"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:number format="1" count="equation[title or info/title]" 
                from="book|article" level="any"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="orderedlist/listitem" mode="label.markup">
  <xsl:variable name="numeration">
    <xsl:call-template name="list.numeration">
      <xsl:with-param name="node" select="parent::orderedlist"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:choose>
      <xsl:when test="$numeration='arabic'">1</xsl:when>
      <xsl:when test="$numeration='loweralpha'">a</xsl:when>
      <xsl:when test="$numeration='lowerroman'">i</xsl:when>
      <xsl:when test="$numeration='upperalpha'">A</xsl:when>
      <xsl:when test="$numeration='upperroman'">I</xsl:when>
      <!-- What!? This should never happen -->
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Unexpected numeration: </xsl:text>
          <xsl:value-of select="$numeration"/>
        </xsl:message>
        <xsl:value-of select="1."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="item-number">
    <xsl:call-template name="orderedlist-item-number"/>
  </xsl:variable>

  <xsl:number value="$item-number" format="{$type}"/>
</xsl:template>

<xsl:template match="abstract" mode="label.markup">
  <!-- nop -->
</xsl:template>

<xsl:template match="sidebar" mode="label.markup">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="label.this.section">
  <xsl:param name="section" select="."/>

  <xsl:variable name="level">
    <xsl:call-template name="section.level"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$level &lt;= $section.autolabel.max.depth">      
      <xsl:value-of select="$section.autolabel"/>
    </xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<doc:template name="label.this.section" xmlns="">
<refpurpose>Returns true if $section should be labelled</refpurpose>
<refdescription id="label.this.section-desc">
<para>Returns true if the specified section should be labelled.
By default, this template returns zero unless 
the section level is less than or equal to the value of the
<literal>$section.autolabel.max.depth</literal> parameter, in
which case it returns
<literal>$section.autolabel</literal>.
Custom stylesheets may override it to get more selective behavior.</para>
</refdescription>
</doc:template>

<!-- ============================================================ -->

<xsl:template name="default.autolabel.format">
  <xsl:param name="context" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($context) = 'appendix'">
      <xsl:value-of select="'A'"/>
    </xsl:when>
    <xsl:when test="local-name($context) = 'part'">
      <xsl:value-of select="'I'"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>  
</xsl:template>
  
<xsl:template name="autolabel.format">
  <xsl:param name="context" select="."/>
  <xsl:param name="format"/>

  <xsl:choose>
    <xsl:when test="string($format) != 0">
      <xsl:choose>
        <xsl:when test="string($format)='arabic' or $format='1'">1</xsl:when>
        <xsl:when test="$format='loweralpha' or $format='a'">
          <xsl:value-of select="'a'"/>
        </xsl:when>
        <xsl:when test="$format='lowerroman' or $format='i'">
          <xsl:value-of select="'i'"/>
        </xsl:when>
        <xsl:when test="$format='upperalpha' or $format='A'">
          <xsl:value-of select="'A'"/>
        </xsl:when>
        <xsl:when test="$format='upperroman' or $format='I'">
          <xsl:value-of select="'I'"/>
        </xsl:when>      
  <xsl:when test="$format='arabicindic' or $format='&#x661;'">
    <xsl:value-of select="'&#x661;'"/>
  </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Unexpected </xsl:text><xsl:value-of select="local-name(.)"/><xsl:text>.autolabel value: </xsl:text>
            <xsl:value-of select="$format"/><xsl:text>; using default.</xsl:text>
          </xsl:message>
          <xsl:call-template name="default.autolabel.format"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<doc:template name="autolabel.format" xmlns="">
<refpurpose>Returns format for autolabel parameters</refpurpose>
<refdescription id="autolabel.format-desc">
<para>Returns format passed as parameter if non zero. Supported
  format are 'arabic' or '1', 'loweralpha' or 'a', 'lowerroman' or 'i', 
  'upperlapha' or 'A', 'upperroman' or 'I', 'arabicindic' or '&#x661;'.
  If its not one of these then 
  returns the default format.</para>
</refdescription>
</doc:template>

<!-- ============================================================ -->

</xsl:stylesheet>
<?xml version="1.0" encoding="ASCII"?>
<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     This module implements DTD-independent functions

     ******************************************************************** -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- Only an excerpt of the original file -->

<xsl:template name="dot.count">
  <!-- Returns the number of "." characters in a string -->
  <xsl:param name="string"/>
  <xsl:param name="count" select="0"/>
  <xsl:choose>
    <xsl:when test="contains($string, '.')">
      <xsl:call-template name="dot.count">
        <xsl:with-param name="string" select="substring-after($string, '.')"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="pi-attribute">
  <xsl:param name="pis" select="processing-instruction('BOGUS_PI')"/>
  <xsl:param name="attribute">filename</xsl:param>
  <xsl:param name="count">1</xsl:param>

  <xsl:choose>
    <xsl:when test="$count&gt;count($pis)">
      <!-- not found -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pi">
        <xsl:value-of select="$pis[$count]"/>
      </xsl:variable>
      <xsl:variable name="pivalue">
        <xsl:value-of select="concat(' ', normalize-space($pi))"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="contains($pivalue,concat(' ', $attribute, '='))">
          <xsl:variable name="rest"
               select="substring-after($pivalue,concat(' ', $attribute,'='))"/>
          <xsl:variable name="quote" select="substring($rest,1,1)"/>
          <xsl:value-of select="substring-before(substring($rest,2),$quote)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="$pis"/>
            <xsl:with-param name="attribute" select="$attribute"/>
            <xsl:with-param name="count" select="$count + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="xpath.location">
  <xsl:param name="node" select="."/>
  <xsl:param name="path" select="''"/>

  <xsl:variable name="next.path">
    <xsl:value-of select="local-name($node)"/>
    <xsl:if test="$path != ''">/</xsl:if>
    <xsl:value-of select="$path"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$node/parent::*">
      <xsl:call-template name="xpath.location">
        <xsl:with-param name="node" select="$node/parent::*"/>
        <xsl:with-param name="path" select="$next.path"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$next.path"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="count.uri.path.depth">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="count" select="0"/>

  <xsl:choose>
    <xsl:when test="contains($filename, '/')">
      <xsl:call-template name="count.uri.path.depth">
        <xsl:with-param name="filename"
                        select="substring-after($filename, '/')"/>
        <xsl:with-param name="count" select="$count + 1"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$count"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trim.common.uri.paths">
  <xsl:param name="uriA" select="''"/>
  <xsl:param name="uriB" select="''"/>
  <xsl:param name="return" select="'A'"/>

  <xsl:choose>
    <xsl:when test="contains($uriA, '/') and contains($uriB, '/')                     and substring-before($uriA, '/') = substring-before($uriB, '/')">
      <xsl:call-template name="trim.common.uri.paths">
        <xsl:with-param name="uriA" select="substring-after($uriA, '/')"/>
        <xsl:with-param name="uriB" select="substring-after($uriB, '/')"/>
        <xsl:with-param name="return" select="$return"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$return = 'A'">
          <xsl:value-of select="$uriA"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$uriB"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="copy-string">
  <!-- returns 'count' copies of 'string' -->
  <xsl:param name="string"/>
  <xsl:param name="count" select="0"/>
  <xsl:param name="result"/>

  <xsl:choose>
    <xsl:when test="$count&gt;0">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="count" select="$count - 1"/>
        <xsl:with-param name="result">
          <xsl:value-of select="$result"/>
          <xsl:value-of select="$string"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$result"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################
    This stylesheet contains some missing parameters and templates used by the
    other common stylesheets. They are provided to have saxon working.
    -->

<xsl:param name="stylesheet.result.type" select="'pdf'"/>
<xsl:param name="l10n.lang.value.rfc.compliant"/>
<xsl:param name="use.role.for.mediaobject" select="1"/>
<xsl:param name="preferred.mediaobject.role"/>
<xsl:param name="use.svg" select="1"/>
<xsl:param name="current.dir"/>
<xsl:param name="formal.procedures" select="1"/>
<xsl:param name="reference.autolabel">I</xsl:param>
<xsl:param name="use.role.as.xrefstyle" select="1"/>

<xsl:template name="is.graphic.format">
</xsl:template>
<xsl:template name="olink.outline">
</xsl:template>
<xsl:template name="is.graphic.extension">
</xsl:template>
<xsl:template name="orderedlist-starting-number">
</xsl:template>
<xsl:template name="xref.xreflabel">
</xsl:template>
<xsl:template name="lookup.key">
</xsl:template>
<xsl:template name="pi.dbchoice_choice">
</xsl:template>
<xsl:template name="systemIdToBaseURI">
</xsl:template>


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



<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="textdata.default.encoding">iso-8859-1</xsl:param>
<xsl:param name="current.dir">.</xsl:param>

<!-- * This stylesheet is derivated from the insertfile.xsl stylesheet from
     * the DocBook Project (thanks Michael). It makes a listing tree of the
     * external text files referenced in the document, with each reference
     * replaced with corresponding Xinclude instance.
     * 
     *   <textobject><textdata fileref="foo.txt">
     *   <imagedata format="linespecific" fileref="foo.txt">
     *   <inlinegraphic format="linespecific" fileref="foo.txt">
     *
     * Those become in the result tree:
     *
     *   <listing type="textdata">
     *     <xi:include href="foo.txt" parse="text"/></listing>
     *   <listing type="imagedata">
     *     <xi:include href="foo.txt" parse="text"/></listing>
     *   <listing type="inlinegraphic">
     *     <xi:include href="foo.txt" parse="text"/></listing>
     *
     * It also works as expected with entityref in place of fileref,
     * and copies over the value of the <textdata> encoding attribute (if
     * found). It is basically intended as an alternative to using the
     * DocBook XSLT Java insertfile() extension.
-->

<!-- ==================================================================== -->

<xsl:template name="string-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:choose>
    <xsl:when test="contains($string,$from)">
      <xsl:value-of select="substring-before($string,$from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="string-replace">
        <xsl:with-param name="string" select="substring-after($string,$from)"/>
        <xsl:with-param name="from" select="$from"/>
        <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="get.external.filename">
  <xsl:variable name="filename">
  <xsl:choose>
    <xsl:when test="@entityref">
      <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@fileref"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:variable name="absfilename">
    <xsl:choose>
    <xsl:when test="starts-with($filename, '/') or
                    contains($filename, ':')">
      <!-- it has absolute path or a uri scheme so it is an absolute uri -->
      <xsl:value-of select="$filename"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$current.dir"/>
      <xsl:text>/</xsl:text>
      <xsl:value-of select="$filename"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- get a valid URI -->
  <xsl:call-template name="string-replace">
    <xsl:with-param name="string" select="$absfilename"/>
    <xsl:with-param name="from" select="' '"/>
    <xsl:with-param name="to" select="'%20'"/>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
 
<xsl:template match="textdata|
                    imagedata[@format='linespecific']|
                    inlinegraphic[@format='linespecific']" mode="lstid">
 <xsl:number from="/"
             level="any"
             format="1"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="textobject[child::textdata[@entityref|@fileref]]">
  <xsl:apply-templates select="textdata"/>
</xsl:template>

<xsl:template match="textdata[@entityref|@fileref]">
  <xsl:variable name="filename">
    <xsl:call-template name="get.external.filename"/>
  </xsl:variable>
  <xsl:variable name="encoding">
    <xsl:choose>
      <xsl:when test="@encoding">
        <xsl:value-of select="@encoding"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$textdata.default.encoding"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="lstid">
    <xsl:apply-templates select="." mode="lstid"/>
  </xsl:variable>
  <listing type="textdata" lstid="{$lstid}">
    <xsl:element name="xi:include">
      <xsl:attribute name="href">
        <xsl:value-of select="$filename"/>
      </xsl:attribute>
      <xsl:attribute name="parse">text</xsl:attribute>
      <xsl:attribute name="encoding">
        <xsl:value-of select="$encoding"/>
      </xsl:attribute>
    </xsl:element>
  </listing>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template
    match="inlinemediaobject
           [child::imageobject
           [child::imagedata
           [@format = 'linespecific' and
           (@entityref|@fileref)]]]">
  <xsl:apply-templates select="imageobject/imagedata"/>
</xsl:template>

<xsl:template match="imagedata
                     [@format = 'linespecific' and
                     (@entityref|@fileref)]">
  <xsl:variable name="filename">
    <xsl:call-template name="get.external.filename"/>
  </xsl:variable>
  <xsl:variable name="lstid">
    <xsl:apply-templates select="." mode="lstid"/>
  </xsl:variable>
  <listing type="imagedata"  lstid="{$lstid}">
    <xsl:element name="xi:include">
      <xsl:attribute name="href">
        <xsl:value-of select="$filename"/>
      </xsl:attribute>
      <xsl:attribute name="parse">text</xsl:attribute>
      <xsl:attribute name="encoding">
        <xsl:value-of select="$textdata.default.encoding"/>
      </xsl:attribute>
    </xsl:element>
  </listing>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="inlinegraphic
                     [@format = 'linespecific' and
                     (@entityref|@fileref)]">
  <xsl:variable name="filename">
    <xsl:call-template name="get.external.filename"/>
  </xsl:variable>
  <xsl:variable name="lstid">
    <xsl:apply-templates select="." mode="lstid"/>
  </xsl:variable>
  <listing type="inlinegraphic" lstid="{$lstid}">
    <xsl:element name="xi:include">
      <xsl:attribute name="href">
        <xsl:value-of select="$filename"/>
      </xsl:attribute>
      <xsl:attribute name="parse">text</xsl:attribute>
      <xsl:attribute name="encoding">
        <xsl:value-of select="$textdata.default.encoding"/>
      </xsl:attribute>
    </xsl:element>
  </listing>
</xsl:template>

<!-- ==================================================================== -->

<!-- browse the tree -->
<xsl:template match="node() | @*">
  <xsl:apply-templates select="@* | node()"/>
</xsl:template>

<xsl:template match="/">
  <listings xmlns:xi="http://www.w3.org/2001/XInclude">
  <xsl:apply-templates/>
  </listings>
</xsl:template>



<!-- Create keys for quickly looking up olink targets -->
<xsl:key name="targetdoc-key" match="document" use="@targetdoc" />
<xsl:key name="targetptr-key"  match="div|obj"
         use="concat(ancestor::document/@targetdoc, '/',
                     @targetptr, '/', ancestor::document/@lang)" />

<!-- Return filename of database -->
<xsl:template name="select.target.database">
  <xsl:param name="targetdoc.att" select="''"/>
  <xsl:param name="targetptr.att" select="''"/>
  <xsl:param name="olink.lang" select="''"/>

  <!-- use root's xml:base if exists -->
  <xsl:variable name="xml.base" select="/*/@xml:base"/>

  <!-- This selection can be customized if needed -->
  <xsl:variable name="target.database.filename">
    <xsl:choose>
      <xsl:when test="$xml.base != '' and
                   not(starts-with($target.database.document, 'file:/')) and
                   not(starts-with($target.database.document, '/'))">
        <xsl:call-template name="systemIdToBaseURI">
          <xsl:with-param name="systemId" select="$xml.base"/>
        </xsl:call-template>
        <xsl:value-of select="$target.database.document"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$target.database.document"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="target.database" 
      select="document($target.database.filename,/)"/>

  <xsl:choose>
    <!-- Was the database document parameter not set? -->
    <xsl:when test="$target.database.document = ''">
      <xsl:message>
        <xsl:text>Olinks not processed: must specify a </xsl:text>
        <xsl:text>$target.database.document parameter&#10;</xsl:text>
        <xsl:text>when using olinks with targetdoc </xsl:text>
        <xsl:text>and targetptr attributes.</xsl:text>
      </xsl:message>
    </xsl:when>
    <!-- Did it not open? Should be a targetset element -->
    <xsl:when test="not($target.database/*)">
      <xsl:message>
        <xsl:text>Olink error: could not open target database '</xsl:text>
        <xsl:value-of select="$target.database.filename"/>
        <xsl:text>'.</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$target.database.filename"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="select.olink.key">
  <xsl:param name="targetdoc.att" select="''"/>
  <xsl:param name="targetptr.att" select="''"/>
  <xsl:param name="olink.lang" select="''"/>
  <xsl:param name="target.database"/>

  <xsl:if test="$target.database/*">
    <xsl:variable name="olink.fallback.sequence">
      <xsl:call-template name="select.olink.lang.fallback">
        <xsl:with-param name="olink.lang" select="$olink.lang"/>
      </xsl:call-template>
    </xsl:variable>
  
    <!-- Recurse through the languages until you find a match -->
    <xsl:call-template name="select.olink.key.in.lang">
      <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
      <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
      <xsl:with-param name="target.database" select="$target.database"/>
      <xsl:with-param name="fallback.index" select="1"/>
      <xsl:with-param name="olink.fallback.sequence"
                      select="$olink.fallback.sequence"/>
    </xsl:call-template>
  </xsl:if>
  
</xsl:template>

<!-- Locate olink key in a particular language -->
<xsl:template name="select.olink.key.in.lang">
  <xsl:param name="targetdoc.att" select="''"/>
  <xsl:param name="targetptr.att" select="''"/>
  <xsl:param name="olink.lang" select="''"/>
  <xsl:param name="target.database"/>
  <xsl:param name="fallback.index" select="1"/>
  <xsl:param name="olink.fallback.sequence" select="''"/>
  
  <xsl:variable name="target.lang">
    <xsl:call-template name="select.target.lang">
      <xsl:with-param name="fallback.index" select="$fallback.index"/>
      <xsl:with-param name="olink.fallback.sequence"
                      select="$olink.fallback.sequence"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$olink.debug != 0">
    <xsl:message><xsl:text>Olink debug: cases for targetdoc='</xsl:text>
      <xsl:value-of select="$targetdoc.att"/>
      <xsl:text>' and targetptr='</xsl:text>
      <xsl:value-of select="$targetptr.att"/>
      <xsl:text>' in language '</xsl:text>
      <xsl:value-of select="$target.lang"/>
      <xsl:text>'.</xsl:text>
    </xsl:message>
  </xsl:if>

  <!-- Customize these cases if you want different selection logic -->
  <xsl:variable name="CaseA">
    <!-- targetdoc.att = not blank
         targetptr.att = not blank
    -->
    <xsl:if test="$targetdoc.att != '' and
                  $targetptr.att != ''">
      <xsl:for-each select="$target.database">
        <xsl:variable name="key" 
                      select="concat($targetdoc.att, '/', 
                                     $targetptr.att, '/',
                                     $target.lang)"/>
        <xsl:choose>
          <xsl:when test="key('targetptr-key', $key)/@href != ''">
            <xsl:value-of select="$key"/>
            <xsl:if test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseA matched.</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$olink.debug != 0">
            <xsl:message>Olink debug: CaseA NOT matched</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="CaseB">
    <!-- targetdoc.att = not blank
         targetptr.att = not blank
         prefer.internal.olink = not zero
         current.docid = not blank 
    -->
    <xsl:if test="$targetdoc.att != '' and
                  $targetptr.att != '' and
                  $current.docid != '' and
                  $prefer.internal.olink != 0">
      <xsl:for-each select="$target.database">
        <xsl:variable name="key" 
                      select="concat($current.docid, '/', 
                                     $targetptr.att, '/',
                                     $target.lang)"/>
        <xsl:choose>
          <xsl:when test="key('targetptr-key', $key)/@href != ''">
            <xsl:value-of select="$key"/>
            <xsl:if test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseB matched.</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$olink.debug != 0">
            <xsl:message>Olink debug: CaseB NOT matched</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="CaseC">
    <!-- targetdoc.att = blank
         targetptr.att = not blank
         current.docid = not blank 
    -->
    <xsl:if test="string-length($targetdoc.att) = 0 and
                  $targetptr.att != '' and
                  $current.docid != ''">
      <!-- Must use a for-each to change context for keys to work -->
      <xsl:for-each select="$target.database">
        <xsl:variable name="key" 
                      select="concat($current.docid, '/', 
                                     $targetptr.att, '/',
                                     $target.lang)"/>
        <xsl:choose>
          <xsl:when test="key('targetptr-key', $key)/@href != ''">
            <xsl:value-of select="$key"/>
            <xsl:if test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseC matched.</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$olink.debug != 0">
            <xsl:message>Olink debug: CaseC NOT matched.</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="CaseD">
    <!-- targetdoc.att = blank
         targetptr.att = not blank
         current.docid = blank 
    -->
    <!-- This is possible if only one document in the database -->
    <xsl:if test="string-length($targetdoc.att) = 0 and
                  $targetptr.att != '' and
                  string-length($current.docid) = 0 and
                  count($target.database//document) = 1">
      <xsl:for-each select="$target.database">
        <xsl:variable name="key" 
                      select="concat(.//document/@targetdoc, '/', 
                                     $targetptr.att, '/',
                                     $target.lang)"/>
        <xsl:choose>
          <xsl:when test="key('targetptr-key', $key)/@href != ''">
            <xsl:value-of select="$key"/>
            <xsl:if test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseD matched.</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$olink.debug != 0">
            <xsl:message>Olink debug: CaseD NOT matched</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="CaseE">
    <!-- targetdoc.att = not blank
         targetptr.att = blank
    -->
    <xsl:if test="$targetdoc.att != '' and
                  string-length($targetptr.att) = 0">

      <!-- Try the document's root element id -->
      <xsl:variable name="rootid">
        <xsl:choose>
          <xsl:when test="$target.lang != ''">
            <xsl:value-of select="$target.database//document[@targetdoc = $targetdoc.att and @lang = $target.lang]/*[1]/@targetptr"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$target.database//document[@targetdoc = $targetdoc.att and not(@lang)]/*[1]/@targetptr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:for-each select="$target.database">
        <xsl:variable name="key" 
                      select="concat($targetdoc.att, '/', 
                                     $rootid, '/',
                                     $target.lang)"/>
        <xsl:choose>
          <xsl:when test="key('targetptr-key', $key)/@href != ''">
            <xsl:value-of select="$key"/>
            <xsl:if test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseE matched.</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$olink.debug != 0">
            <xsl:message>Olink debug: CaseE NOT matched.</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="CaseF">
    <!-- targetdoc.att = not blank
         targetptr.att = blank
         prefer.internal.olink = not zero
         current.docid = not blank 
    -->
    <xsl:if test="$targetdoc.att != '' and
                  string-length($targetptr.att) = 0 and
                  $current.docid != '' and
                  $prefer.internal.olink != 0">
      <!-- Try the document's root element id -->
      <xsl:variable name="rootid">
        <xsl:choose>
          <xsl:when test="$target.lang != ''">
            <xsl:value-of select="$target.database//document[@targetdoc = $current.docid and @lang = $target.lang]/*[1]/@targetptr"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$target.database//document[@targetdoc = $current.docid and not(@lang)]/*[1]/@targetptr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:for-each select="$target.database">
        <xsl:variable name="key" 
                      select="concat($current.docid, '/', 
                                     $rootid, '/',
                                     $target.lang)"/>
        <xsl:choose>
          <xsl:when test="key('targetptr-key', $key)/@href != ''">
            <xsl:value-of select="$key"/>
            <xsl:if test="$olink.debug != 0">
              <xsl:message>Olink debug: CaseF matched.</xsl:message>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$olink.debug != 0">
            <xsl:message>Olink debug: CaseF NOT matched.</xsl:message>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:variable>

  <!-- Now select the best match. Customize the order if needed -->
  <xsl:variable name="selected.key">
    <xsl:choose>
      <xsl:when test="$CaseB != ''">
        <xsl:value-of select="$CaseB"/>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: CaseB key is the final selection: </xsl:text>
            <xsl:value-of select="$CaseB"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$CaseA != ''">
        <xsl:value-of select="$CaseA"/>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: CaseA key is the final selection: </xsl:text>
            <xsl:value-of select="$CaseA"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$CaseC != ''">
        <xsl:value-of select="$CaseC"/>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: CaseC key is the final selection: </xsl:text>
            <xsl:value-of select="$CaseC"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$CaseD != ''">
        <xsl:value-of select="$CaseD"/>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: CaseD key is the final selection: </xsl:text>
            <xsl:value-of select="$CaseD"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$CaseF != ''">
        <xsl:value-of select="$CaseF"/>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: CaseF key is the final selection: </xsl:text>
            <xsl:value-of select="$CaseF"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:when test="$CaseE != ''">
        <xsl:value-of select="$CaseE"/>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: CaseE key is the final selection: </xsl:text>
            <xsl:value-of select="$CaseE"/>
          </xsl:message>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="$olink.debug != 0">
          <xsl:message>
            <xsl:text>Olink debug: No case matched for lang '</xsl:text>
            <xsl:value-of select="$target.lang"/>
            <xsl:text>'.</xsl:text>
          </xsl:message>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$selected.key != ''">
      <xsl:value-of select="$selected.key"/>
    </xsl:when>
    <xsl:when test="string-length($selected.key) = 0 and 
                    string-length($target.lang) = 0">
      <!-- No match on last try, and we are done -->
    </xsl:when>
    <xsl:otherwise>
      <!-- Recurse through next language -->
      <xsl:call-template name="select.olink.key.in.lang">
        <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
        <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
        <xsl:with-param name="olink.lang" select="$olink.lang"/>
        <xsl:with-param name="target.database" select="$target.database"/>
        <xsl:with-param name="fallback.index" select="$fallback.index + 1"/>
        <xsl:with-param name="olink.fallback.sequence"
                        select="$olink.fallback.sequence"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="select.target.lang">
  <xsl:param name="fallback.index" select="1"/>
  <xsl:param name="olink.fallback.sequence" select="''"/>

  <!-- recurse backwards to find the lang matching the index -->
  <xsl:variable name="firstlang" 
                select="substring-before($olink.fallback.sequence, ' ')"/>
  <xsl:variable name="rest" 
                select="substring-after($olink.fallback.sequence, ' ')"/>
  <xsl:choose>
    <xsl:when test="$fallback.index = 1">
      <xsl:value-of select="$firstlang"/>
    </xsl:when>
    <xsl:when test="$fallback.index &gt; 1">
      <xsl:call-template name="select.target.lang">
        <xsl:with-param name="fallback.index" select="$fallback.index - 1"/>
        <xsl:with-param name="olink.fallback.sequence"
                        select="$rest"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="select.olink.lang.fallback">
  <xsl:param name="olink.lang" select="''"/>

  <!-- Prefer language of the olink element -->
  <xsl:value-of select="concat(normalize-space(concat($olink.lang, ' ', 
                        $olink.lang.fallback.sequence)), ' ')"/>
</xsl:template>

<!-- Returns the complete olink href value if found -->
<xsl:template name="make.olink.href">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="target.database"/>

  <xsl:if test="$olink.key != ''">
    <xsl:variable name="target.href" >
      <xsl:for-each select="$target.database" >
        <xsl:value-of select="key('targetptr-key', $olink.key)/@href" />
      </xsl:for-each>
    </xsl:variable>
  
    <xsl:variable name="targetdoc">
      <xsl:value-of select="substring-before($olink.key, '/')"/>
    </xsl:variable>
  
    <!-- Does the target database use a sitemap? -->
    <xsl:variable name="use.sitemap">
      <xsl:choose>
        <xsl:when test="$target.database//sitemap">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
  
    <!-- Get the baseuri for this targetptr -->
    <xsl:variable name="baseuri" >
      <xsl:choose>
        <!-- Does the database use a sitemap? -->
        <xsl:when test="$use.sitemap != 0" >
          <xsl:choose>
            <!-- Was current.docid parameter set? -->
            <xsl:when test="$current.docid != ''">
              <!-- Was it found in the database? -->
              <xsl:variable name="currentdoc.key" >
                <xsl:for-each select="$target.database" >
                  <xsl:value-of select="key('targetdoc-key',
                                        $current.docid)/@targetdoc" />
                </xsl:for-each>
              </xsl:variable>
              <xsl:choose>
                <xsl:when test="$currentdoc.key != ''">
                  <xsl:for-each select="$target.database" >
                    <xsl:call-template name="targetpath" >
                      <xsl:with-param name="dirnode" 
                          select="key('targetdoc-key', $current.docid)/parent::dir"/>
                      <xsl:with-param name="targetdoc" select="$targetdoc"/>
                    </xsl:call-template>
                  </xsl:for-each >
                </xsl:when>
                <xsl:otherwise>
                  <xsl:message>
                    <xsl:text>Olink error: cannot compute relative </xsl:text>
                    <xsl:text>sitemap path because $current.docid '</xsl:text>
                    <xsl:value-of select="$current.docid"/>
                    <xsl:text>' not found in target database.</xsl:text>
                  </xsl:message>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message>
                <xsl:text>Olink warning: cannot compute relative </xsl:text>
                <xsl:text>sitemap path without $current.docid parameter</xsl:text>
              </xsl:message>
            </xsl:otherwise>
          </xsl:choose> 
          <!-- In either case, add baseuri from its document entry-->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database" >
              <xsl:value-of select="key('targetdoc-key', $targetdoc)/@baseuri" />
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''" >
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:when>
        <!-- No database sitemap in use -->
        <xsl:otherwise>
          <!-- Just use any baseuri from its document entry -->
          <xsl:variable name="docbaseuri">
            <xsl:for-each select="$target.database" >
              <xsl:value-of select="key('targetdoc-key', $targetdoc)/@baseuri" />
            </xsl:for-each>
          </xsl:variable>
          <xsl:if test="$docbaseuri != ''" >
            <xsl:value-of select="$docbaseuri"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <!-- Form the href information -->
    <xsl:if test="$baseuri != ''">
      <xsl:value-of select="$baseuri"/>
      <xsl:if test="substring($target.href,1,1) != '#'">
        <!--xsl:text>/</xsl:text-->
      </xsl:if>
    </xsl:if>
    <!-- optionally turn off frag for PDF references -->
    <xsl:if test="not($insert.olink.pdf.frag = 0 and
          translate(substring($baseuri, string-length($baseuri) - 3),
                    'PDF', 'pdf') = '.pdf'
          and starts-with($target.href, '#') )">
      <xsl:value-of select="$target.href"/>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Computes the href of the object containing the olink element -->
<xsl:template name="olink.from.uri">
  <xsl:param name="target.database"/>
  <xsl:param name="object" select="NotAnElement"/>
  <xsl:param name="object.targetdoc" select="$current.docid"/>
  <xsl:param name="object.lang" 
           select="concat($object/ancestor::*[last()]/@lang,
                          $object/ancestor::*[last()]/@xml:lang)"/>

  <xsl:variable name="parent.id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$object"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Get the olink key for the parent of olink element -->
  <xsl:variable name="from.key">
    <xsl:call-template name="select.olink.key">
      <xsl:with-param name="targetdoc.att" select="$object.targetdoc"/>
      <xsl:with-param name="targetptr.att" select="$parent.id"/>
      <xsl:with-param name="olink.lang" select="$object.lang"/>
      <xsl:with-param name="target.database" select="$target.database"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="from.olink.href">
    <xsl:for-each select="$target.database" >
      <xsl:value-of select="key('targetptr-key', $from.key)/@href" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:choose>
    <!-- we found the olink object -->
    <xsl:when test="$from.olink.href != ''">
      <xsl:value-of select="$from.olink.href"/>
    </xsl:when>
    <xsl:when test="not($object/parent::*)">
      <xsl:value-of select="$from.olink.href"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- recurse upward in current document -->
      <xsl:call-template name="olink.from.uri">
        <xsl:with-param name="target.database" select="$target.database"/>
        <xsl:with-param name="object" select="$object/parent::*"/>
        <xsl:with-param name="object.targetdoc" select="$object.targetdoc"/>
        <xsl:with-param name="object.lang" select="$object.lang"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="olink.hottext">
  <xsl:param name="target.database"/>
  <xsl:param name="olink.lang" select="''"/>
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="referrer" select="."/>
  <xsl:param name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <!-- If it has elements or text (not just PI or comment) -->
    <xsl:when test="child::text() or child::*">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="$olink.key != ''">
      <!-- Get the xref text for this record -->
      <xsl:variable name="xref.text" >
        <xsl:for-each select="$target.database" >
          <xsl:call-template name="insert.targetdb.data">
            <xsl:with-param name="data"
                  select="key('targetptr-key', $olink.key)/xreftext/node()" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="xref.number" >
        <xsl:for-each select="$target.database" >
          <xsl:value-of select="key('targetptr-key', $olink.key)/@number" />
        </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="target.elem" >
        <xsl:for-each select="$target.database" >
          <xsl:value-of select="key('targetptr-key', $olink.key)/@element" />
        </xsl:for-each>
      </xsl:variable>

      <xsl:variable name="lang">
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

      <xsl:variable name="targetdoc">
        <xsl:value-of select="substring-before($olink.key, '/')"/>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$xrefstyle != '' and
                        starts-with(normalize-space($xrefstyle), 'select:') and
                        (contains($xrefstyle, 'nodocname') or
                        contains($xrefstyle, 'nopage')) and
                        not(contains($xrefstyle, 'title')) and
                        not(contains($xrefstyle, 'label'))"> 
          <xsl:copy-of select="$xref.text"/>
        </xsl:when>
        <xsl:when test="$xrefstyle != ''">
          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>xrefstyle is '</xsl:text>
              <xsl:value-of select="$xrefstyle"/>
              <xsl:text>'.</xsl:text>
            </xsl:message>
          </xsl:if>
          <xsl:variable name="template">
            <xsl:choose>
              <xsl:when test="starts-with(normalize-space($xrefstyle),
                                          'select:')">
                <xsl:call-template name="make.gentext.template">
                  <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
                  <xsl:with-param name="purpose" select="'olink'"/>
                  <xsl:with-param name="referrer" select="."/>
                  <xsl:with-param name="target.elem" select="$target.elem"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:when test="starts-with(normalize-space($xrefstyle),
                                          'template:')">
                <xsl:value-of select="substring-after(
                                 normalize-space($xrefstyle), 'template:')"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- Look for Gentext template with @style attribute -->
                <!-- Must compare to no style value because gentext.template
                     falls back to no style -->

                <xsl:variable name="xref-context">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'xref'"/>
                    <xsl:with-param name="name" select="$target.elem"/>
                    <xsl:with-param name="lang" select="$lang"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="styled-xref-context">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'xref'"/>
                    <xsl:with-param name="name" select="$target.elem"/>
                    <xsl:with-param name="lang" select="$lang"/>
                    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="xref-number-context">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'xref-number'"/>
                    <xsl:with-param name="name" select="$target.elem"/>
                    <xsl:with-param name="lang" select="$lang"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="styled-xref-number-context">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" select="'xref-number'"/>
                    <xsl:with-param name="name" select="$target.elem"/>
                    <xsl:with-param name="lang" select="$lang"/>
                    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="xref-number-and-title-context">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" 
                                    select="'xref-number-and-title'"/>
                    <xsl:with-param name="name" select="$target.elem"/>
                    <xsl:with-param name="lang" select="$lang"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="styled-xref-number-and-title-context">
                  <xsl:call-template name="gentext.template">
                    <xsl:with-param name="context" 
                                    select="'xref-number-and-title'"/>
                    <xsl:with-param name="name" select="$target.elem"/>
                    <xsl:with-param name="lang" select="$lang"/>
                    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:choose>
                  <xsl:when test="$xref-number-and-title-context != 
                                 $styled-xref-number-and-title-context and
                                 $xref.number != '' and
                                 $xref.with.number.and.title != 0">
                    <xsl:value-of 
                            select="$styled-xref-number-and-title-context"/>
                  </xsl:when>
                  <xsl:when test="$xref-number-context != 
                                 $styled-xref-number-context and
                                 $xref.number != ''">
                    <xsl:value-of select="$styled-xref-number-context"/>
                  </xsl:when>
                  <xsl:when test="$xref-context != $styled-xref-context">
                    <xsl:value-of select="$styled-xref-context"/>
                  </xsl:when>
                  <xsl:when test="$xref-number-and-title-context != '' and
                                 $xref.number != '' and
                                 $xref.with.number.and.title != 0">
                    <xsl:value-of 
                            select="$xref-number-and-title-context"/>
                    <xsl:if test="$olink.debug">
                      <xsl:message>
                        <xsl:text>Olink error: no gentext template</xsl:text>
                        <xsl:text> exists for xrefstyle '</xsl:text>
                        <xsl:value-of select="$xrefstyle"/>
                        <xsl:text>' for element '</xsl:text>
                        <xsl:value-of select="$target.elem"/>
                        <xsl:text>' in language '</xsl:text>
                        <xsl:value-of select="$lang"/>
                        <xsl:text>' in context 'xref-number-and-title</xsl:text>
                        <xsl:text>'. Using template without @style.</xsl:text>
                      </xsl:message>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="$xref-number-context != '' and
                                 $xref.number != ''">
                    <xsl:value-of select="$xref-number-context"/>
                    <xsl:if test="$olink.debug">
                      <xsl:message>
                        <xsl:text>Olink error: no gentext template</xsl:text>
                        <xsl:text> exists for xrefstyle '</xsl:text>
                        <xsl:value-of select="$xrefstyle"/>
                        <xsl:text>' for element '</xsl:text>
                        <xsl:value-of select="$target.elem"/>
                        <xsl:text>' in language '</xsl:text>
                        <xsl:value-of select="$lang"/>
                        <xsl:text>' in context 'xref-number</xsl:text>
                        <xsl:text>'. Using template without @style.</xsl:text>
                      </xsl:message>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="$xref-context != ''">
                    <xsl:value-of select="$xref-context"/>
                    <xsl:if test="$olink.debug">
                      <xsl:message>
                        <xsl:text>Olink error: no gentext template</xsl:text>
                        <xsl:text> exists for xrefstyle '</xsl:text>
                        <xsl:value-of select="$xrefstyle"/>
                        <xsl:text>' for element '</xsl:text>
                        <xsl:value-of select="$target.elem"/>
                        <xsl:text>' in language '</xsl:text>
                        <xsl:value-of select="$lang"/>
                        <xsl:text>' in context 'xref</xsl:text>
                        <xsl:text>'. Using template without @style.</xsl:text>
                      </xsl:message>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:message>
                      <xsl:text>Olink error: no gentext template</xsl:text>
                      <xsl:text> exists for xrefstyle '</xsl:text>
                      <xsl:value-of select="$xrefstyle"/>
                      <xsl:text>' for element '</xsl:text>
                      <xsl:value-of select="$target.elem"/>
                      <xsl:text>' in language '</xsl:text>
                      <xsl:value-of select="$lang"/>
                      <xsl:text>'. Trying '%t'.</xsl:text>
                    </xsl:message>
                    <xsl:value-of select="'%t'"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>

          <xsl:if test="$olink.debug != 0">
            <xsl:message>
              <xsl:text>Olink debug: xrefstyle template is '</xsl:text>
              <xsl:value-of select="$template"/>
              <xsl:text>'.</xsl:text>
            </xsl:message>
          </xsl:if>

          <xsl:call-template name="substitute-markup">
            <xsl:with-param name="template" select="$template"/>
            <xsl:with-param name="title">
              <xsl:for-each select="$target.database" >
                <xsl:call-template name="insert.targetdb.data">
                  <xsl:with-param name="data"
                                  select="key('targetptr-key', $olink.key)/ttl" />
                </xsl:call-template>
              </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="label">
              <xsl:for-each select="$target.database" >
                <xsl:value-of 
                        select="key('targetptr-key', $olink.key)/@number" />
              </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="pagenumber">
              <xsl:for-each select="$target.database" >
                <xsl:value-of 
                        select="key('targetptr-key', $olink.key)/@page" />
              </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="docname">
              <xsl:for-each select="$target.database" >
                <xsl:call-template name="insert.targetdb.data">
                  <xsl:with-param name="data"
                       select="key('targetdoc-key', $targetdoc)/div[1]/ttl" />
                </xsl:call-template>
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="$use.local.olink.style != 0">

          <xsl:variable name="template">
            <xsl:call-template name="gentext.template">
              <xsl:with-param name="context" select="'xref'"/>
              <xsl:with-param name="name" select="$target.elem"/>
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
          </xsl:variable>

          <xsl:call-template name="substitute-markup">
            <xsl:with-param name="template" select="$template"/>
            <xsl:with-param name="title">
              <xsl:for-each select="$target.database" >
                <xsl:call-template name="insert.targetdb.data">
                  <xsl:with-param name="data"
                                  select="key('targetptr-key', $olink.key)/ttl" />
                </xsl:call-template>
              </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="label">
              <xsl:for-each select="$target.database" >
                <xsl:value-of 
                          select="key('targetptr-key', $olink.key)/@number" />
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$xref.text !=''">
          <xsl:copy-of select="$xref.text"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Olink error: no generated text for </xsl:text>
            <xsl:text>targetdoc/targetptr/lang = '</xsl:text>
            <xsl:value-of select="$olink.key"/>
            <xsl:text>'.</xsl:text>
          </xsl:message>
          <xsl:text>????</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="@targetdoc != '' or @targetptr != ''">
      <xsl:if test="$olink.key != ''">
        <xsl:message>
          <xsl:text>Olink error: no generated text for </xsl:text>
          <xsl:text>targetdoc/targetptr/lang = '</xsl:text>
          <xsl:value-of select="$olink.key"/>
          <xsl:text>'.</xsl:text>
        </xsl:message>
      </xsl:if>
      <xsl:text>????</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- old style olink -->
      <xsl:call-template name="olink.outline">
        <xsl:with-param name="outline.base.uri"
                        select="unparsed-entity-uri(@targetdocent)"/>
        <xsl:with-param name="localinfo" select="@localinfo"/>
        <xsl:with-param name="return" select="'xreftext'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="insert.targetdb.data">
  <xsl:param name="data"/>
  <!-- Apply the node template even if it's a text() node,
       at least to perform the tex escaping -->
  <xsl:apply-templates select="$data"/>
</xsl:template>

<!-- Translate HTML target.db formatting to dblatex equivalent -->
<xsl:template match="xreftext//i">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<!-- Called through insert.targetdb.data template -->
<xsl:template match="ttl">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="*" mode="olink.docname.markup">
  <!-- No-op for now -->
</xsl:template>

<xsl:template name="targetpath">
  <xsl:param name="dirnode" />
  <xsl:param name="targetdoc" select="''"/>

<!-- 
<xsl:message>dirnode is <xsl:value-of select="$dirnode/@name"/></xsl:message>
<xsl:message>targetdoc is <xsl:value-of select="$targetdoc"/></xsl:message>
-->
  <!-- recursive template generates path to olink target directory -->
  <xsl:choose>
    <!-- Have we arrived at the final path step? -->
    <xsl:when test="$dirnode/child::document[@targetdoc = $targetdoc]">
      <!-- We are done -->
    </xsl:when>
    <!-- Have we reached the top without a match? -->
    <xsl:when test="local-name($dirnode) != 'dir'" >
        <xsl:message>Olink error: cannot locate targetdoc <xsl:value-of select="$targetdoc"/> in sitemap</xsl:message>
    </xsl:when>
    <!-- Is the target in a descendant? -->
    <xsl:when test="$dirnode/descendant::document/@targetdoc = $targetdoc">
      <xsl:variable name="step" select="$dirnode/child::dir[descendant::document/@targetdoc = $targetdoc]"/>
      <xsl:if test = "$step">
        <xsl:value-of select="$step/@name"/>
        <xsl:text>/</xsl:text>
      </xsl:if>
      <!-- Now recurse with the child -->
      <xsl:call-template name="targetpath" >
        <xsl:with-param name="dirnode" select="$step"/>
        <xsl:with-param name="targetdoc" select="$targetdoc"/>
      </xsl:call-template>
    </xsl:when>
    <!-- Otherwise we need to move up a step -->
    <xsl:otherwise>
      <xsl:if test="$dirnode/parent::dir">
        <xsl:text>../</xsl:text>
      </xsl:if>
      <xsl:call-template name="targetpath" >
        <xsl:with-param name="dirnode" select="$dirnode/parent::*"/>
        <xsl:with-param name="targetdoc" select="$targetdoc"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink.page.citation">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="olink.lang" select="'en'"/>
  <xsl:param name="target.database"/>
  <xsl:param name="linkend" select="''"/>
  <xsl:param name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="targetdoc">
    <xsl:value-of select="substring-before($olink.key, '/')"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$linkend != ''">
      <xsl:call-template name="xref.page.citation">
        <xsl:with-param name="linkend" select="$linkend"/>
        <xsl:with-param name="target" select="key('id', $linkend)"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="not(starts-with(normalize-space($xrefstyle),
                        'select:') 
                and (contains($xrefstyle, 'page')
                     or contains($xrefstyle, 'Page')))
                and $current.docid != '' 
                and $current.docid != $targetdoc
                and $insert.olink.page.number = 'yes' ">
  
      <xsl:variable name="page-number">
        <xsl:for-each select="$target.database" >
          <xsl:value-of 
                 select="key('targetptr-key', $olink.key)/@page" />
        </xsl:for-each>
      </xsl:variable>
  
      <xsl:if test="$page-number != ''">
        <xsl:call-template name="substitute-markup">
          <xsl:with-param name="template">
            <xsl:call-template name="gentext.template">
              <xsl:with-param name="name" select="'olink.page.citation'"/>
              <xsl:with-param name="context" select="'xref'"/>
              <xsl:with-param name="lang" select="$olink.lang"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="pagenumber" select="$page-number"/>
        </xsl:call-template>
      </xsl:if>
  
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink.document.citation">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="olink.lang" select="'en'"/>
  <xsl:param name="target.database"/>
  <xsl:param name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="page">
    <xsl:for-each select="$target.database" >
      <xsl:value-of 
             select="key('targetptr-key', $olink.key)/@page" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="targetdoc">
    <xsl:value-of select="substring-before($olink.key, '/')"/>
  </xsl:variable>

  <xsl:variable name="targetptr">
    <xsl:value-of 
          select="substring-before(substring-after($olink.key, '/'), '/')"/>
  </xsl:variable>

  <!-- Don't add docname if pointing to root element -->
  <xsl:variable name="rootptr">
    <xsl:for-each select="$target.database" >
      <xsl:value-of 
             select="key('targetdoc-key', $targetdoc)/div[1]/@targetptr" />
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="docname">
    <xsl:for-each select="$target.database" >
      <xsl:call-template name="insert.targetdb.data">
        <xsl:with-param name="data"
             select="key('targetdoc-key', $targetdoc)/div[1]/ttl" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:variable>


  <xsl:if test="not(starts-with(normalize-space($xrefstyle), 'select:') 
              and (contains($xrefstyle, 'docname')))
              and ($olink.doctitle = 'yes' or $olink.doctitle = '1')
              and $current.docid != '' 
              and $rootptr != $targetptr
              and $current.docid != $targetdoc
              and $docname != ''">
    <xsl:call-template name="substitute-markup">
      <xsl:with-param name="template">
        <xsl:call-template name="gentext.template">
          <xsl:with-param name="name" select="'olink.document.citation'"/>
          <xsl:with-param name="context" select="'xref'"/>
          <xsl:with-param name="lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:with-param>
      <xsl:with-param name="docname" select="$docname"/>
      <xsl:with-param name="pagenumber" select="$page"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="xref.page.citation">
  <!-- Determine if this xref should have a page citation.
       Context node is the xref or local olink element -->
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="target" select="key('id', $linkend)"/>
  <xsl:param name="xrefstyle">
    <xsl:choose>
      <xsl:when test="@role and not(@xrefstyle) 
                      and $use.role.as.xrefstyle != 0">
        <xsl:value-of select="@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@xrefstyle"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:if test="not(starts-with(normalize-space($xrefstyle),'select:')
                    and (contains($xrefstyle, 'page')
                         or contains($xrefstyle, 'Page')))
                and ( $insert.xref.page.number = 'yes' 
                   or $insert.xref.page.number = '1')
                or local-name($target) = 'para'">
    <xsl:apply-templates select="$target" mode="page.citation">
      <xsl:with-param name="id" select="$linkend"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>



<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- subtitle markup -->

<doc:mode mode="subtitle.markup" xmlns="">
<refpurpose>Provides access to element subtitles</refpurpose>
<refdescription id="subtitle.markup-desc">
<para>Processing an element in the
<literal role="mode">subtitle.markup</literal> mode produces the
subtitle of the element.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="subtitle.markup">
  <xsl:message>
    <xsl:text>Request for subtitle of unexpected element: </xsl:text>
    <xsl:value-of select="local-name(.)"/>
  </xsl:message>
  <xsl:text>???SUBTITLE???</xsl:text>
</xsl:template>

<xsl:template match="subtitle" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="set" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(setinfo/subtitle|info/subtitle|subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="book" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(bookinfo/subtitle|info/subtitle|subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="part" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(partinfo/subtitle
                                |docinfo/subtitle
                                |info/subtitle
                                |subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(docinfo/subtitle
                                |info/subtitle
                                |prefaceinfo/subtitle
                                |chapterinfo/subtitle
                                |appendixinfo/subtitle
                                |subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="article" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(artheader/subtitle
                                |articleinfo/subtitle
                                |info/subtitle
                                |subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="dedication|colophon" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(subtitle|info/subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="reference" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(referenceinfo/subtitle
                                |docinfo/subtitle
                                |info/subtitle
                                |subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="qandaset" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(blockinfo/subtitle|info/subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="refentry" mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(refentryinfo/subtitle
                                |info/subtitle
                                |docinfo/subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="section
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3
                     |simplesect"
              mode="subtitle.markup">
  <xsl:param name="allow-anchors" select="'0'"/>
  <xsl:apply-templates select="(info/subtitle
                                |sectioninfo/subtitle
                                |sect1info/subtitle
                                |sect2info/subtitle
                                |sect3info/subtitle
                                |sect4info/subtitle
                                |sect5info/subtitle
                                |refsect1info/subtitle
                                |refsect2info/subtitle
                                |refsect3info/subtitle
                                |subtitle)[1]"
                       mode="subtitle.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>



<!-- ********************************************************************
     $Id
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- title markup -->

<doc:mode mode="title.markup" xmlns="">
<refpurpose>Provides access to element titles</refpurpose>
<refdescription id="title.markup-desc">
<para>Processing an element in the
<literal role="mode">title.markup</literal> mode produces the
title of the element. This does not include the label.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>
  <xsl:choose>
    <!-- * FIXME: this should handle other *info elements as well -->
    <!-- * but this is good enough for now. -->
    <xsl:when test="title|info/title">
      <xsl:apply-templates select="title[1]|info/title[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="local-name(.) = 'partintro'">
      <!-- partintro's don't have titles, use the parent (part or reference)
           title instead. -->
      <xsl:apply-templates select="parent::*" mode="title.markup"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$verbose != 0">
        <xsl:message>
          <xsl:text>Request for title of element with no title: </xsl:text>
          <xsl:value-of select="local-name(.)"/>
          <xsl:choose>
            <xsl:when test="@id">
              <xsl:text> (id="</xsl:text>
              <xsl:value-of select="@id"/>
              <xsl:text>")</xsl:text>
            </xsl:when>
            <xsl:when test="@xml:id">
              <xsl:text> (xml:id="</xsl:text>
              <xsl:value-of select="@xml:id"/>
              <xsl:text>")</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:message>
      </xsl:if>
      <xsl:text>???TITLE???</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="title" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- only occurs in HTML Tables! -->
<xsl:template match="caption" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="set" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(setinfo/title|info/title|title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="book" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(bookinfo/title|info/title|title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="part" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(partinfo/title|info/title|docinfo/title|title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="preface|chapter|appendix" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

<!--
  <xsl:message>
    <xsl:value-of select="local-name(.)"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$allow-anchors"/>
  </xsl:message>
-->

  <xsl:variable name="title" select="(docinfo/title
                                      |info/title
                                      |prefaceinfo/title
                                      |chapterinfo/title
                                      |appendixinfo/title
                                      |title)[1]"/>
  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="dedication" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="(title|info/title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Dedication'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="colophon" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="(title|info/title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Colophon'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="article" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(artheader/title
                                      |articleinfo/title
                                      |info/title
                                      |title)[1]"/>

  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="reference" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(referenceinfo/title|docinfo/title|info/title|title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="refentry" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="refmeta" select=".//refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//refname"/>
  <xsl:variable name="refdesc" select="$refnamediv//refdescriptor"/>

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="$refentrytitle">
        <xsl:apply-templates select="$refentrytitle[1]" mode="title.markup"/>
      </xsl:when>
      <xsl:when test="$refdesc">
        <xsl:apply-templates select="$refdesc" mode="title.markup"/>
      </xsl:when>
      <xsl:when test="$refname">
        <xsl:apply-templates select="$refname[1]" mode="title.markup"/>
      </xsl:when>
      <xsl:otherwise>REFENTRY WITHOUT TITLE???</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:copy-of select="$title"/>
</xsl:template>

<xsl:template match="refentrytitle|refname|refdescriptor" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="section
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3|refsection
                     |simplesect"
              mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(info/title
                                      |sectioninfo/title
                                      |sect1info/title
                                      |sect2info/title
                                      |sect3info/title
                                      |sect4info/title
                                      |sect5info/title
                                      |refsect1info/title
                                      |refsect2info/title
                                      |refsect3info/title
                                      |refsectioninfo/title
                                      |title)[1]"/>

  <xsl:apply-templates select="$title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="bridgehead" mode="title.markup">
  <xsl:apply-templates mode="title.markup"/>
</xsl:template>

<xsl:template match="refsynopsisdiv" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="bibliography" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(bibliographyinfo/title|info/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Bibliography'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossary" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(glossaryinfo/title|info/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.element.name">
        <xsl:with-param name="element.name" select="local-name(.)"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossdiv" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(info/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>ERROR: glossdiv missing its required title</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossentry" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="glossterm" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="glossterm" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="index" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(indexinfo/title|info/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Index'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="setindex" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(setindexinfo/title|info/title|title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'SetIndex'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure|example|equation" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="title|info/title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="table" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(title|caption)[1]" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="procedure" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="task" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="title" mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="sidebar" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:apply-templates select="(info/title|sidebarinfo/title|title)[1]"
                       mode="title.markup">
    <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="abstract" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="title|info/title">
      <xsl:apply-templates select="(title|info/title)[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Abstract'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="caution|tip|warning|important|note" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(title|info/title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="local-name(.)='note'">Note</xsl:when>
            <xsl:when test="local-name(.)='important'">Important</xsl:when>
            <xsl:when test="local-name(.)='caution'">Caution</xsl:when>
            <xsl:when test="local-name(.)='warning'">Warning</xsl:when>
            <xsl:when test="local-name(.)='tip'">Tip</xsl:when>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="question" mode="title.markup">
  <!-- questions don't have titles -->
  <xsl:text>Question</xsl:text>
</xsl:template>

<xsl:template match="answer" mode="title.markup">
  <!-- answers don't have titles -->
  <xsl:text>Answer</xsl:text>
</xsl:template>

<xsl:template match="qandaentry" mode="title.markup">
  <!-- qandaentrys are represented by the first question in them -->
  <xsl:text>Question</xsl:text>
</xsl:template>

<xsl:template match="qandaset" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:variable name="title" select="(info/title|
                                      blockinfo/title|
                                      title)[1]"/>
  <xsl:choose>
    <xsl:when test="$title">
      <xsl:apply-templates select="$title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'QandASet'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="legalnotice" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:choose>
    <xsl:when test="title">
      <xsl:apply-templates select="title" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'LegalNotice'"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:choose>
    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="book|preface|chapter|appendix" mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="titleabbrev" select="(docinfo/titleabbrev
                                           |bookinfo/titleabbrev
                                           |info/titleabbrev
                                           |prefaceinfo/titleabbrev
                                           |chapterinfo/titleabbrev
                                           |appendixinfo/titleabbrev
                                           |titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="article" mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="titleabbrev" select="(artheader/titleabbrev
                                           |articleinfo/titleabbrev
                                           |info/titleabbrev
                                           |titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="section
                     |sect1|sect2|sect3|sect4|sect5
                     |refsect1|refsect2|refsect3
                     |simplesect"
              mode="titleabbrev.markup">
  <xsl:param name="allow-anchors" select="0"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:variable name="titleabbrev" select="(info/titleabbrev
                                            |sectioninfo/titleabbrev
                                            |sect1info/titleabbrev
                                            |sect2info/titleabbrev
                                            |sect3info/titleabbrev
                                            |sect4info/titleabbrev
                                            |sect5info/titleabbrev
                                            |refsect1info/titleabbrev
                                            |refsect2info/titleabbrev
                                            |refsect3info/titleabbrev
                                            |titleabbrev)[1]"/>

  <xsl:choose>
    <xsl:when test="$titleabbrev">
      <xsl:apply-templates select="$titleabbrev" mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="title.markup">
        <xsl:with-param name="allow-anchors" select="$allow-anchors"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="titleabbrev" mode="title.markup">
  <xsl:param name="allow-anchors" select="0"/>

  <xsl:choose>
    <xsl:when test="$allow-anchors != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="no.anchor.mode">
  <!-- Switch to normal mode if no links -->
  <xsl:choose>
    <xsl:when test="descendant-or-self::footnote or
                    descendant-or-self::anchor or
                    descendant-or-self::ulink or
                    descendant-or-self::link or
                    descendant-or-self::olink or
                    descendant-or-self::xref or
                    descendant-or-self::indexterm">

      <xsl:apply-templates mode="no.anchor.mode"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="footnote" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="anchor" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="ulink" mode="no.anchor.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="link" mode="no.anchor.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="olink" mode="no.anchor.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="indexterm" mode="no.anchor.mode">
  <!-- nop, suppressed -->
</xsl:template>

<xsl:template match="xref" mode="no.anchor.mode">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="refelem" select="local-name($target)"/>
  
  <xsl:call-template name="check.id.unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="count($target) = 0">
      <xsl:message>
        <xsl:text>XRef to nonexistent id: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>

    <xsl:when test="@endterm">
      <xsl:variable name="etargets" select="key('id',@endterm)"/>
      <xsl:variable name="etarget" select="$etargets[1]"/>
      <xsl:choose>
        <xsl:when test="count($etarget) = 0">
          <xsl:message>
            <xsl:value-of select="count($etargets)"/>
            <xsl:text>Endterm points to nonexistent ID: </xsl:text>
            <xsl:value-of select="@endterm"/>
          </xsl:message>
          <xsl:text>???</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$etarget" mode="endterm"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <xsl:call-template name="xref.xreflabel">
        <xsl:with-param name="target" select="$target"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates select="$target" mode="xref-to-prefix"/>

      <xsl:apply-templates select="$target" mode="xref-to">
        <xsl:with-param name="referrer" select="."/>
        <xsl:with-param name="xrefstyle">
          <xsl:choose>
            <xsl:when test="@role and not(@xrefstyle) and $use.role.as.xrefstyle != 0">
              <xsl:value-of select="@role"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@xrefstyle"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:apply-templates>

      <xsl:apply-templates select="$target" mode="xref-to-suffix"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->














<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- it only works for bookinfo/abstract. Within chapters, etc. it puts the
     abstract in a separate page.
  -->

<xsl:template match="abstract">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% -------- &#10;</xsl:text>
  <xsl:text>% Abstract &#10;</xsl:text>
  <xsl:text>% -------- &#10;</xsl:text>
  <xsl:if test="title">
    <xsl:text>\let\savabstractname=\abstractname&#10;</xsl:text>
    <xsl:text>\def\abstractname{</xsl:text>
    <xsl:apply-templates select="title"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:text>\begin{abstract}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>&#10;\end{abstract}&#10;</xsl:text>
  <xsl:if test="title">
    <xsl:text>\let\abstractname=\savabstractname&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="abstract/title">
  <xsl:apply-templates/>
</xsl:template>

<!-- Just render the content -->
<xsl:template match="highlights">
  <xsl:apply-templates/>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:param name="figure.note"/>
<xsl:param name="figure.tip"/>
<xsl:param name="figure.important">warning</xsl:param>
<xsl:param name="figure.warning">warning</xsl:param>
<xsl:param name="figure.caution">warning</xsl:param>

<xsl:template match="note|important|warning|caution|tip">
  <xsl:text>\begin{DBKadmonition}{</xsl:text>
  <xsl:call-template name="admon.graphic"/><xsl:text>}{</xsl:text>
  <xsl:choose> 
    <xsl:when test="title">
      <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="title"/></xsl:call-template>
    </xsl:when> 
    <xsl:otherwise>
      <xsl:call-template name="gentext.element.name"/>
    </xsl:otherwise> 
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{DBKadmonition}&#10;</xsl:text>
</xsl:template>

<xsl:template match="note/title|important/title|
                     warning/title|caution/title|tip/title"/>

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>
  <xsl:choose>
    <xsl:when test="name($node)='warning'">
      <xsl:value-of select="$figure.warning"/>
    </xsl:when>
    <xsl:when test="name($node)='caution'">
      <xsl:value-of select="$figure.caution"/>
    </xsl:when>
    <xsl:when test="name($node)='important'">
      <xsl:value-of select="$figure.important"/>
    </xsl:when>
    <xsl:when test="name($node)='note'">
      <xsl:value-of select="$figure.note"/>
    </xsl:when>
    <xsl:when test="name($node)='tip'">
      <xsl:value-of select="$figure.tip"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<!-- Annotation support mostly taken from the DocBook Project stylesheets. Only
     The inlined output and the annotation content output are different (use
     of attachfile macros, and latex file output). -->

<xsl:param name="annotation.support" select="'0'"/>

<xsl:key name="gid" match="*" use="generate-id()"/>

<!-- Content of the annotation file -->
<xsl:template match="annotation" mode="write">
  <xsl:text>\documentclass</xsl:text>
  <xsl:if test="$latex.class.options!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$latex.class.options"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>{article}&#10;</xsl:text>
  <xsl:text>\usepackage[T1]{fontenc}&#10;</xsl:text>
  <xsl:text>\usepackage[latin1]{inputenc}&#10;</xsl:text>

  <xsl:call-template name="font.setup"/>
  <xsl:text>\usepackage[hyperlink]{</xsl:text>
  <xsl:value-of select="$latex.style"/>
  <xsl:text>}&#10;</xsl:text>

  <xsl:call-template name="citation.setup"/>
  <xsl:call-template name="lang.setup"/>

  <xsl:text>\pagestyle{empty}&#10;</xsl:text>

  <xsl:text>\begin{document}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{document}&#10;</xsl:text>
</xsl:template>

<!-- Build the annotation latex file -->
<xsl:template match="annotation" mode="build.texfile">
  <xsl:call-template name="write.text.chunk">
    <xsl:with-param name="filename">
      <xsl:text>annot_</xsl:text>
      <xsl:value-of select="generate-id()"/>
      <xsl:text>.rtex</xsl:text>
    </xsl:with-param>
    <xsl:with-param name="method" select="'text'"/>
    <xsl:with-param name="content">
      <xsl:apply-templates select="." mode="write"/>
    </xsl:with-param>
    <xsl:with-param name="encoding" select="$chunker.output.encoding"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="annotation"/>

<!-- Show the annotations (if any) related to this element -->
<xsl:template match="*" mode="annotation.links">
  <xsl:if test="$annotation.support != '0'">
  <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
  <!-- do any annotations apply to the context node? -->

  <xsl:variable name="aids">
    <xsl:if test="$id!=''">
      <xsl:for-each select="//annotation">
        <xsl:if test="contains(concat(' ',@annotates,' '),concat(' ',$id,' '))">
          <xsl:value-of select="generate-id()"/>
          <xsl:text> </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:if test="normalize-space(@annotations) != ''">
      <xsl:call-template name="annotations-pointed-to">
        <xsl:with-param name="annotations"
                        select="normalize-space(@annotations)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:if test="$aids != ''">
    <xsl:call-template name="apply-annotations-by-gid">
      <xsl:with-param name="gids" select="normalize-space($aids)"/>
    </xsl:call-template>
  </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="annotations-pointed-to">
  <xsl:param name="annotations"/>
  <xsl:choose>
    <xsl:when test="contains($annotations, ' ')">
      <xsl:variable name='a'
                    select="key('id', substring-before($annotations, ' '))"/>
      <xsl:if test="$a">
        <xsl:value-of select="generate-id($a)"/>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:call-template name="annotations-pointed-to">
        <xsl:with-param name="annotations"
                        select="substring-after($annotations, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name='a'
                    select="key('id', $annotations)"/>
      <xsl:if test="$a">
        <xsl:value-of select="generate-id($a)"/>
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="apply-annotations-by-gid">
  <xsl:param name="gids"/>

  <xsl:choose>
    <xsl:when test="contains($gids, ' ')">
      <xsl:variable name="gid" select="substring-before($gids, ' ')"/>
      <xsl:apply-templates select="key('gid', $gid)"
                           mode="annotation-inline"/>
      <xsl:call-template name="apply-annotations-by-gid">
        <xsl:with-param name="gids" select="substring-after($gids, ' ')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="key('gid', $gids)"
                           mode="annotation-inline"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="annotation" mode="annotation-inline">
  <xsl:text>\attachfile</xsl:text>
  <xsl:if test="title">
    <xsl:text>[</xsl:text>
    <xsl:text>subject={</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="title"/>
    </xsl:call-template>
    <xsl:text>}]</xsl:text>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:text>annot_</xsl:text>
  <xsl:value-of select="generate-id()"/>
  <xsl:text>.pdf</xsl:text>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>


<!-- load the needed package, and build the annotation files -->
<xsl:template name="annotation.setup">
  <xsl:if test="$annotation.support != '0' and .//annotation">
    <xsl:text>\usepackage{attachfile}&#10;</xsl:text>
    <xsl:apply-templates select=".//annotation" mode="build.texfile"/>
  </xsl:if>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="appendix">
  <xsl:if test="not (preceding-sibling::appendix)">
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>% Appendixes start here&#10;</xsl:text>
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>\begin{appendices}&#10;</xsl:text>
  </xsl:if>
  <xsl:call-template name="makeheading">
    <!-- raise to the highest existing book section level (part or chapter) -->
    <xsl:with-param name="level">
      <xsl:choose>
      <xsl:when test="preceding-sibling::part or
                      following-sibling::part">-1</xsl:when>
      <xsl:when test="parent::book or parent::part">0</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>

  <xsl:if test="not (following-sibling::appendix)">
    <xsl:text>&#10;\end{appendices}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="appendix/title"></xsl:template>
<xsl:template match="appendix/titleabbrev"></xsl:template>
<xsl:template match="appendix/subtitle"></xsl:template>
<xsl:template match="appendix/docinfo|appendixinfo"></xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="bibliography.tocdepth">5</xsl:param>
<xsl:param name="bibliography.numbered">1</xsl:param>
<xsl:param name="biblioentry.numbered" select="0"/>

<!-- ################
     # biblio setup #
     ################ -->

<xsl:template name="biblio.setup">
  <xsl:if test="$latex.biblio.style!='' and //bibliography">
    <xsl:text>\bibliographystyle{</xsl:text>
    <xsl:value-of select="$latex.biblio.style"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- ##################
     # biblio section #
     ################## -->

<xsl:template name="biblio.insert.title">
  <xsl:param name="level" select="0"/>

  <xsl:variable name="title.node" select="(title|bibliographyinfo/title)[1]"/>
  <xsl:variable name="title.text">
    <xsl:choose>
    <xsl:when test="ancestor::article">
      <xsl:text>\refname</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\bibname</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="self::bibliography and number($bibliography.numbered) = 0">
    <!-- The unumbered section is only for the top level bibliography heading -->
    <xsl:call-template name="section.unnumbered.begin">
      <xsl:with-param name="tocdepth" select="number($bibliography.tocdepth)"/>
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title.text"/>
      <xsl:with-param name="titlenode" select="$title.node"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="$title.node">
    <!-- Numbered section from a <title> node -->
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="allnum" select="'1'"/>
      <xsl:with-param name="title" select="$title.node"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <!-- Numbered section from a generated title -->
    <xsl:call-template name="maketitle">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="allnum" select="'1'"/>
      <xsl:with-param name="title" select="$title.text"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="biblio.section.end">
  <xsl:if test="self::bibliography and number($bibliography.numbered) = 0">
    <!-- Only the unumbered section requires to restore section counters -->
    <xsl:call-template name="section.unnumbered.end">
      <xsl:with-param name="tocdepth" select="number($bibliography.tocdepth)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- we can have a list of entries to process, or a bibtex file -->
<xsl:template name="biblioentry.process">
  <xsl:param name="level"/>
  <xsl:choose>
  <xsl:when test="count(bibioentry|bibliomixed)=1 and
                  bibliomixed[processing-instruction('bibtex')]">
    <xsl:call-template name="bibtex.process">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="bibentries.process">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="bibentries.process">
  <xsl:param name="level"/>

  <xsl:text>\begin{btSect}{}&#10;</xsl:text>

  <!-- display the heading -->
  <xsl:if test="$level &gt;= 0">
    <xsl:call-template name="biblio.insert.title">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:text>\begin{bibgroup}&#10;</xsl:text>
  <xsl:text>\begin{thebibliography}{</xsl:text>
  <xsl:value-of select="$latex.bibwidelabel"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:if test="biblioentry">
    <xsl:choose>
    <xsl:when test="$latex.biblio.output ='cited'">
      <xsl:apply-templates select="biblioentry" mode="bibliography.cited">
        <xsl:sort select="./abbrev"/>
        <xsl:sort select="./@xreflabel"/>
        <xsl:sort select="./@id"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="biblioentry">
        <xsl:sort select="./abbrev"/>
        <xsl:sort select="./@xreflabel"/>
        <xsl:sort select="./@id"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:if test="bibliomixed">
    <xsl:apply-templates select="bibliomixed"/>
  </xsl:if>
  <xsl:text>&#10;\end{thebibliography}&#10;</xsl:text>
  <xsl:text>\end{bibgroup}&#10;</xsl:text>
  <xsl:if test="$level &gt;= 0">
    <xsl:call-template name="biblio.section.end"/>
  </xsl:if>
  <xsl:text>\end{btSect}&#10;</xsl:text>
</xsl:template>


<!-- ################
     # bibtex files #
     ################ -->

<xsl:template name="bibtex.process">
  <xsl:param name="level"/>
  <xsl:variable name="pi"
                select="bibliomixed/processing-instruction('bibtex')"/>

  <!-- take all the details from the bibtex PI -->
  <xsl:variable name="bibfiles">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="$pi"/>
      <xsl:with-param name="attribute" select="'bibfiles'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="bibstyle">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="$pi"/>
      <xsl:with-param name="attribute" select="'bibstyle'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="print">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="$pi"/>
      <xsl:with-param name="attribute" select="'mode'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:text>\begin{btSect}</xsl:text>

  <!-- specific style to apply? -->
  <xsl:if test="$bibstyle!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$bibstyle"/>
    <xsl:text>]</xsl:text>
  </xsl:if>

  <!-- the bibtex files to use (fallback to global parameter) -->
  <xsl:text>{</xsl:text>
  <xsl:choose>
  <xsl:when test="$bibfiles!=''">
    <xsl:value-of select="$bibfiles"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$latex.bibfiles"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>

  <!-- display the heading -->
  <xsl:if test="$level &gt;= 0">
    <xsl:call-template name="biblio.insert.title">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:if>

  <!-- things before the entries -->
  <xsl:apply-templates select="*[not(self::bibliomixed)]"/>

  <!-- the entries to show depend on the print mode -->
  <xsl:choose>
  <xsl:when test="$print='cited'">
    <xsl:text>\btPrintCited&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$print='notcited'">
    <xsl:text>\btPrintNotCited&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$print='all'">
    <xsl:text>\btPrintAll&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$latex.biblio.output='cited'">
    <xsl:text>\btPrintCited&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$latex.biblio.output='notcited'">
    <xsl:text>\btPrintNotCited&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\btPrintAll&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <xsl:if test="$level &gt;= 0">
    <xsl:call-template name="biblio.section.end"/>
  </xsl:if>

  <xsl:text>\end{btSect}&#10;</xsl:text>
</xsl:template>


<!-- ################
     # bibliography #
     ################ -->

<xsl:template match="bibliography">
  <!--
  <xsl:message>Processing Bibliography</xsl:message>
  <xsl:message><xsl:text>Output Mode: </xsl:text>
    <xsl:value-of select="$latex.biblio.output"/>
  </xsl:message>
  -->
  <xsl:text>% ------------------------------------------- &#10;</xsl:text>
  <xsl:text>% Bibliography&#10;</xsl:text>
  <xsl:text>% ------------------------------------------- &#10;</xsl:text>

  <!-- get the section level -->
  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level"/>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="biblioentry|bibliomixed">
    <!-- process the entries -->
    <xsl:call-template name="biblioentry.process">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <!-- no entries here, only a section block -->
    <xsl:call-template name="biblio.insert.title">
      <xsl:with-param name="level" select="$level"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="bibliodiv"/> 

  <!-- close the opened section block -->
  <xsl:if test="not(biblioentry|bibliomixed)">
    <xsl:call-template name="biblio.section.end"/>
  </xsl:if>
</xsl:template>

<xsl:template match="bibliography/title"/>
<xsl:template match="bibliography/subtitle"/>
<xsl:template match="bibliography/titleabbrev"/>

<!-- ###############
     #  bibliodiv  #
     ############### -->

<xsl:template match="bibliodiv">
  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="parent::bibliography"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="biblioentry.process">
    <xsl:with-param name="level" select="$level+1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="bibliodiv/title"/>

<!-- ###############
     #  bibliolist #
     ############### -->

<xsl:template match="bibliolist">
  <xsl:call-template name="biblioentry.process">
    <xsl:with-param name="level" select="'-1'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="bibliodiv/title"/>

<!-- ###############
     # biblioentry #
     ############### -->

<xsl:template match="biblioentry" mode="bibliography.cited">
  <xsl:param name="bibid" select="@id"/>
  <xsl:param name="ab">
    <xsl:call-template name="bibitem.label"/>
  </xsl:param>
  <xsl:variable name="nx" select="//xref[@linkend=$bibid]"/>
  <xsl:variable name="nc" select="//citation[text()=$ab]"/>
  <xsl:if test="count($nx) &gt; 0 or count($nc) &gt; 0">
    <xsl:call-template name="biblioentry.output"/>
  </xsl:if>
</xsl:template>

<xsl:template match="biblioentry" mode="bibliography.all">
  <xsl:call-template name="biblioentry.output"/>
</xsl:template>

<xsl:template match="biblioentry">
  <xsl:call-template name="biblioentry.output"/>
</xsl:template>

<xsl:template match="biblioentry/title">
  <xsl:text>\emph{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- biblioentry engine -->

<xsl:template name="bibitem.label">
  <xsl:choose>
  <xsl:when test="@xreflabel">
    <xsl:value-of select="normalize-space(@xreflabel)"/> 
  </xsl:when>
  <xsl:when test="abbrev">
    <xsl:apply-templates select="abbrev" mode="biblio.label.mode"/> 
  </xsl:when>
  <xsl:when test="@id">
    <xsl:value-of select="normalize-space(@id)"/> 
  </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- The biblio entry ID must follow the label, to match citation text -->
<xsl:template name="bibitem.id">
  <xsl:choose>
  <xsl:when test="@xreflabel">
    <xsl:value-of select="normalize-space(@xreflabel)"/> 
  </xsl:when>
  <xsl:when test="abbrev">
    <xsl:apply-templates select="abbrev" mode="biblio.label.mode"/> 
  </xsl:when>
  <xsl:when test="@id">
    <xsl:value-of select="normalize-space(@id)"/> 
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="generate-id()"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="abbrev" mode="biblio.label.mode"> 
  <xsl:value-of select="."/>
</xsl:template>


<xsl:template name="bibitem">
  <xsl:variable name="tag">
    <xsl:call-template name="bibitem.label"/>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>\bibitem</xsl:text>
  <xsl:if test="$tag != '' and $biblioentry.numbered = 0">
    <xsl:text>[</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="$tag"/>
    </xsl:call-template>
    <xsl:text>]</xsl:text> 
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:call-template name="bibitem.id"/>
  <xsl:text>}</xsl:text>
  <!-- Add labels, in case of xrefs to here -->
  <xsl:call-template name="label.id">
    <xsl:with-param name="inline" select="1"/>
  </xsl:call-template>
  <xsl:text>&#10;</xsl:text> 
</xsl:template>

<xsl:template name="biblioentry.output">
  <xsl:call-template name="bibitem"/>
  <!-- first, biblioentry information (if any) -->
  <xsl:variable name="data" select="subtitle|
                                    volumenum|
                                    edition|
                                    address|
                                    copyright|
                                    publisher|
                                    date|
                                    pubdate|
                                    pagenums|
                                    isbn|
                                    issn|
                                    biblioid|
                                    releaseinfo|
                                    pubsnumber"/>
  <xsl:apply-templates select="author|authorgroup" mode="bibliography.mode"/>
  <xsl:if test="title">
    <xsl:if test="author|authorgroup">
      <xsl:value-of select="$biblioentry.item.separator"/>
    </xsl:if>
    <xsl:apply-templates select="title"/>
  </xsl:if>
  <xsl:if test="$data">
    <xsl:for-each select="$data">
      <xsl:value-of select="$biblioentry.item.separator"/>
      <xsl:apply-templates select="." mode="bibliography.mode"/> 
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </xsl:if>
  <!-- then, biblioset information (if any) -->
  <xsl:for-each select="biblioset">
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:apply-templates select="." mode="bibliography.mode"/>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="bibliomixed">
  <xsl:call-template name="bibitem"/>
  <xsl:apply-templates select="." mode="bibliography.mode"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- Text in bibliomixed/bibliomset must be processed as normal (scaped) -->
<xsl:template match="text()" mode="bibliography.mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- by default no specific behaviour -->
<xsl:template match="*" mode="bibliography.mode">
  <xsl:apply-templates mode="bibliography.mode"/>
</xsl:template>

<!-- want hot links -->
<xsl:template match="ulink" mode="bibliography.mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- abbrev not displayed  -->
<xsl:template match="abbrev" mode="bibliography.mode"/>

<!-- want latex label anchors -->
<xsl:template match="anchor" mode="bibliography.mode">
  <xsl:apply-templates select="."/>
</xsl:template>


<xsl:template match="biblioset" mode="bibliography.mode">
  <xsl:if test="author|authorgroup">
    <xsl:apply-templates select="author|authorgroup" mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </xsl:if>
  <xsl:apply-templates select="title|citetitle" mode="bibliography.mode"/>
  <xsl:for-each select="subtitle|
                        volumenum|
                        edition|
                        address|
                        copyright|
                        publisher|
                        date|
                        pubdate|
                        pagenums|
                        isbn|
                        issn|
                        biblioid|
                        pubsnumber">
    <xsl:value-of select="$biblioentry.item.separator"/>
    <xsl:apply-templates select="." mode="bibliography.mode"/> 
  </xsl:for-each>
  <xsl:text>.</xsl:text>
</xsl:template>

<xsl:template match="biblioset/title|biblioset/citetitle" 
              mode="bibliography.mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat">ldquo</xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates/>
      <xsl:call-template name="dingbat">
        <xsl:with-param name="dingbat">rdquo</xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Biblioid depends on its class -->
<xsl:template match="biblioid" mode="bibliography.mode">
  <xsl:choose>
    <xsl:when test="@class='doi'">
      <xsl:text>DOI</xsl:text>
    </xsl:when>
    <xsl:when test="@class='isbn'">
      <xsl:text>ISBN</xsl:text>
    </xsl:when>
    <xsl:when test="@class='issn'">
      <xsl:text>ISSN</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>The biblioid class '</xsl:text>
        <xsl:value-of select="@class"/>
        <xsl:text>' not supported!</xsl:text>
      </xsl:message>
      <xsl:value-of select="@class"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="author" mode="bibliography.mode">
  <xsl:variable name="authorsstring">
    <xsl:call-template name="person.name"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($authorsstring)"/>
</xsl:template>

<xsl:template match="authorgroup" mode="bibliography.mode">
  <xsl:variable name="authorsstring">
    <xsl:call-template name="person.name.list"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($authorsstring)"/>
</xsl:template>

<xsl:template match="editor" mode="bibliography.mode">
  <xsl:call-template name="person.name"/>
  <xsl:value-of select="$biblioentry.item.separator"/>
</xsl:template>

<xsl:template match="copyright" mode="bibliography.mode">
  <xsl:call-template name="gentext.element.name"/>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat">copyright</xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:apply-templates select="year" mode="bibliography.mode"/>
  <xsl:if test="holder">
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="holder" mode="bibliography.mode"/>
  </xsl:if>
</xsl:template>

<xsl:template match="year" mode="bibliography.mode">
  <xsl:apply-templates/>
  <xsl:if test="position()!=last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="publisher" mode="bibliography.mode">
  <xsl:apply-templates select="publishername" mode="bibliography.mode"/>
  <xsl:for-each select="address">
    <xsl:value-of select="$biblioentry.item.separator"/>
    <xsl:apply-templates select="." mode="bibliography.mode"/>
  </xsl:for-each>
</xsl:template>


<!-- to manage entities correctly (such as &amp;) -->
<xsl:template match="subtitle|volumenum|edition|
                     date|pubdate|pagenums|isbn|issn|
                     holder|publishername|releaseinfo|address"
              mode="bibliography.mode">
  <xsl:apply-templates/>
</xsl:template>

<!-- suppressed things -->
<xsl:template match="printhistory" mode="bibliography.mode"/>
<xsl:template match="abstract" mode="bibliography.mode"/>
<xsl:template match="authorblurb" mode="bibliography.mode"/>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:template match="bridgehead">
  <xsl:param name="renderas" select="@renderas"/>
  <xsl:choose>
    <xsl:when test="$renderas='sect1' or $renderas='sect2' or $renderas='sect3'">
      <xsl:text>&#10;\</xsl:text>
      <xsl:if test="$renderas='sect2'"><xsl:text>sub</xsl:text></xsl:if>
      <xsl:if test="$renderas='sect3'"><xsl:text>subsub</xsl:text></xsl:if>
      <xsl:text>section*{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
      <xsl:call-template name="label.id"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>&#10;\paragraph*{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
      <xsl:call-template name="label.id"/>
      <xsl:text>&#10;&#10;\noindent&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>




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




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="chapter">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% ------- &#10;</xsl:text>
  <xsl:text>% Chapter &#10;</xsl:text>
  <xsl:text>% ------- &#10;</xsl:text>
  <xsl:call-template name="mapheading"/>
  <xsl:apply-templates/>
</xsl:template>

<!-- An empty label specifies an unnumbered chapter -->
<xsl:template match="chapter[@label and @label='']">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% ------------------ &#10;</xsl:text>
  <xsl:text>% Unnumbered Chapter &#10;</xsl:text>
  <xsl:text>% ------------------ &#10;</xsl:text>
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="$toc.section.depth + 1"/>
    <xsl:with-param name="level" select="0"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="chapter/title"/>
<xsl:template match="chapter/titleabbrev"/>
<xsl:template match="chapter/subtitle"/>
<xsl:template match="chapterinfo/pubdate"/>
<xsl:template match="chapter/docinfo|chapterinfo">
  <xsl:apply-templates/>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<!-- All of this is taken from the DocBook Project chunker.xsl file, with some
     parts stripped (saxon, xalan support). We assume that exsl:document()
     is supported by any XSLT now. Moreover only text file output are supported
     here. -->

<xsl:param name="chunker.output.method" select="'text'"/>
<xsl:param name="chunker.output.encoding" select="'UTF-8'"/>
<xsl:param name="chunker.output.indent" select="'no'"/>
<xsl:param name="chunker.output.omit-xml-declaration" select="'no'"/>
<xsl:param name="chunker.output.standalone" select="'no'"/>
<xsl:param name="chunker.output.doctype-public" select="''"/>
<xsl:param name="chunker.output.doctype-system" select="''"/>
<xsl:param name="chunker.output.media-type" select="''"/>
<xsl:param name="chunker.output.cdata-section-elements" select="''"/>


<xsl:template name="write.chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="$output.quietly"/>

  <xsl:param name="method" select="$chunker.output.method"/>
  <xsl:param name="encoding" select="$chunker.output.encoding"/>
  <xsl:param name="indent" select="$chunker.output.indent"/>
  <xsl:param name="omit-xml-declaration"
             select="$chunker.output.omit-xml-declaration"/>
  <xsl:param name="standalone" select="$chunker.output.standalone"/>
  <xsl:param name="doctype-public" select="$chunker.output.doctype-public"/>
  <xsl:param name="doctype-system" select="$chunker.output.doctype-system"/>
  <xsl:param name="media-type" select="$chunker.output.media-type"/>
  <xsl:param name="cdata-section-elements"
             select="$chunker.output.cdata-section-elements"/>

  <xsl:param name="content"/>

  <xsl:if test="$quiet = 0">
    <xsl:message>
      <xsl:text>Writing </xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:if test="name(.) != ''">
        <xsl:text> for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id or @xml:id">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="(@id|@xml:id)[1]"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:message>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="element-available('exsl:document')">
      <xsl:choose>
        <!-- Handle the permutations ... -->
        <xsl:when test="$media-type != ''">
          <xsl:choose>
            <xsl:when test="$doctype-public != '' and $doctype-system != ''">
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             media-type="{$media-type}"
                             doctype-public="{$doctype-public}"
                             doctype-system="{$doctype-system}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:when>
            <xsl:when test="$doctype-public != '' and $doctype-system = ''">
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             media-type="{$media-type}"
                             doctype-public="{$doctype-public}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:when>
            <xsl:when test="$doctype-public = '' and $doctype-system != ''">
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             media-type="{$media-type}"
                             doctype-system="{$doctype-system}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:when>
            <xsl:otherwise><!-- $doctype-public = '' and $doctype-system = ''"> -->
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             media-type="{$media-type}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="$doctype-public != '' and $doctype-system != ''">
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             doctype-public="{$doctype-public}"
                             doctype-system="{$doctype-system}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:when>
            <xsl:when test="$doctype-public != '' and $doctype-system = ''">
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             doctype-public="{$doctype-public}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:when>
            <xsl:when test="$doctype-public = '' and $doctype-system != ''">
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             doctype-system="{$doctype-system}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:when>
            <xsl:otherwise><!-- $doctype-public = '' and $doctype-system = ''"> -->
              <exsl:document href="{$filename}"
                             method="{$method}"
                             encoding="{$encoding}"
                             indent="{$indent}"
                             omit-xml-declaration="{$omit-xml-declaration}"
                             cdata-section-elements="{$cdata-section-elements}"
                             standalone="{$standalone}">
                <xsl:copy-of select="$content"/>
              </exsl:document>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <!-- it doesn't matter since we won't be making chunks... -->
      <xsl:message terminate="yes">
        <xsl:text>Can't make chunks with </xsl:text>
        <xsl:value-of select="system-property('xsl:vendor')"/>
        <xsl:text>'s processor.</xsl:text>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="write.text.chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="0"/>
  <xsl:param name="method" select="'text'"/>
  <xsl:param name="encoding" select="$chunker.output.encoding"/>
  <xsl:param name="media-type" select="$chunker.output.media-type"/>
  <xsl:param name="content"/>

  <xsl:call-template name="write.chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="quiet" select="$quiet"/>
    <xsl:with-param name="method" select="$method"/>
    <xsl:with-param name="encoding" select="$encoding"/>
    <xsl:with-param name="indent" select="'no'"/>
    <xsl:with-param name="omit-xml-declaration" select="'no'"/>
    <xsl:with-param name="standalone" select="'no'"/>
    <xsl:with-param name="doctype-public"/>
    <xsl:with-param name="doctype-system"/>
    <xsl:with-param name="media-type" select="$media-type"/>
    <xsl:with-param name="cdata-section-elements"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:param name="citation.natbib.use" select="'0'"/>
<xsl:param name="citation.natbib.options"/>
<xsl:param name="citation.default.style"/>


<!-- Loads the natbib package if required -->
<xsl:template name="citation.setup">
  <xsl:if test="$citation.natbib.use!='0'">
    <xsl:text>\usepackage</xsl:text>
    <xsl:if test="$citation.natbib.options!=''">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$citation.natbib.options"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{natbib}&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Parses a cite macro like \citep[...][...] so that the bracket contents
     are converted safely to latex strings. Special care about the optional
     enclosing curly braces telling to use this content block [{...}] so that
     you can put some '[...]' in it. -->

<xsl:template name="cite-parse">
  <xsl:param name="macro"/>

  <xsl:variable name="brackets">
    <xsl:choose>
    <xsl:when test="contains($macro,'[{') and
                    contains(substring-after($macro,'[{'),'}]')">
      <xsl:value-of select="'[{ }]'"/>
    </xsl:when>
    <xsl:when test="contains($macro,'[') and
                    contains(substring-after($macro,'['),']')">
      <xsl:value-of select="'[ ]'"/>
    </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$brackets!=''">
    <xsl:variable name="bs" select="substring-before($brackets,' ')"/>
    <xsl:variable name="be" select="substring-after($brackets,' ')"/>
    <xsl:variable name="opt"
                  select="substring-before(substring-after($macro,$bs),$be)"/>
    <xsl:value-of select="substring-before($macro,$bs)"/>
    <xsl:value-of select="$bs"/>
    <!-- escape brackets content -->
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="$opt"/>
    </xsl:call-template>
    <xsl:value-of select="$be"/>
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro"
                      select="substring-after($macro,concat($bs,$opt,$be))"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$macro"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Format a specific citation style from @role, a PI, or the default style.
     The citation styles are disabled if natbib is not used -->

<xsl:template match="citation" mode="cite-style">
  <!-- maybe a citation style from PI -->
  <xsl:variable name="pi">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="processing-instruction('dblatex')"/>
      <xsl:with-param name="attribute" select="'citestyle'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$citation.natbib.use='0'">
    <xsl:text>\cite</xsl:text>
  </xsl:when>
  <xsl:when test="@role and (starts-with(@role,'\cite') or
                             starts-with(@role,'\Cite'))">
    <!-- a natbib citation style from @role -->
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro" select="@role"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="starts-with($pi,'\cite') or starts-with($pi,'\Cite')">
    <!-- a natbib citation style from PI -->
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro" select="$pi"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="$citation.default.style!=''">
    <!-- the default natbib citation style -->
    <xsl:call-template name="cite-parse">
      <xsl:with-param name="macro" select="$citation.default.style"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\cite</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="citation">
  <xsl:apply-templates select="." mode="cite-style"/>
  <xsl:text>{</xsl:text>
  <!-- we take the raw text: we don't want that "_" becomes "\_" -->
  <xsl:value-of select="."/>
  <xsl:text>}</xsl:text>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="classsynopsis
                     |fieldsynopsis
                     |methodsynopsis
                     |constructorsynopsis
                     |destructorsynopsis">
  <xsl:call-template name="output.verbatim">
    <xsl:with-param name="content">
      <xsl:apply-templates select="." mode="content"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="classsynopsis
                     |fieldsynopsis
                     |methodsynopsis
                     |constructorsynopsis
                     |destructorsynopsis" mode="save.verbatim">
  <xsl:call-template name="save.verbatim">
    <xsl:with-param name="content">
      <xsl:apply-templates select="." mode="content"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<xsl:template match="classsynopsis
                     |fieldsynopsis
                     |methodsynopsis
                     |constructorsynopsis
                     |destructorsynopsis" mode="content">
  <xsl:param name="language">
    <xsl:choose>
    <xsl:when test="@language">
      <xsl:value-of select="@language"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$classsynopsis.default.language"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$language='java'">
      <xsl:apply-templates select="." mode="java"/></xsl:when>
    <xsl:when test="$language='perl'">
      <xsl:apply-templates select="." mode="perl"/></xsl:when>
    <xsl:when test="$language='idl'">
      <xsl:apply-templates select="." mode="idl"/></xsl:when>
    <xsl:when test="$language='cpp'">
      <xsl:apply-templates select="." mode="cpp"/></xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unrecognized language on classsynopsis: </xsl:text>
        <xsl:value-of select="$language"/>
      </xsl:message>
      <xsl:apply-templates select="." mode="content">
        <xsl:with-param name="language"
           select="$classsynopsis.default.language"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ########
     # Java #
     ######## -->

<xsl:template match="classsynopsis" mode="java">
  <xsl:apply-templates select="ooclass[1]" mode="java"/>
  <xsl:if test="ooclass[position() &gt; 1]">
    <xsl:text> extends</xsl:text>
    <xsl:apply-templates select="ooclass[position() &gt; 1]" mode="java"/>
    <xsl:if test="oointerface|ooexception">
      <xsl:text>&#10;    </xsl:text>
    </xsl:if>
  </xsl:if>
  <xsl:if test="oointerface">
    <xsl:text>implements</xsl:text>
    <xsl:apply-templates select="oointerface" mode="java"/>
    <xsl:if test="ooexception">
      <xsl:text>&#10;    </xsl:text>
    </xsl:if>
  </xsl:if>
  <xsl:if test="ooexception">
    <xsl:text>throws</xsl:text>
    <xsl:apply-templates select="ooexception" mode="java"/>
  </xsl:if>
  <xsl:text> {&#10;</xsl:text>
  <xsl:apply-templates select="constructorsynopsis
                               |destructorsynopsis
                               |fieldsynopsis
                               |methodsynopsis
                               |classsynopsisinfo" mode="java"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="classsynopsisinfo" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="ooclass|oointerface|ooexception" mode="java">
  <xsl:choose>
  <xsl:when test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text> </xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="modifier" mode="java">
  <xsl:apply-templates mode="java"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="classname" mode="java">
  <xsl:if test="name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="interfacename" mode="java">
  <xsl:if test="name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="exceptionname" mode="java">
  <xsl:if test="name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="fieldsynopsis" mode="java">
  <xsl:text>  </xsl:text>
  <xsl:apply-templates mode="java"/>
  <xsl:text>;&#10;</xsl:text>
</xsl:template>

<xsl:template match="type" mode="java">
  <xsl:apply-templates mode="java"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="varname" mode="java">
  <xsl:apply-templates mode="java"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="initializer" mode="java">
  <xsl:text>= </xsl:text>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="void" mode="java">
  <xsl:text>void </xsl:text>
</xsl:template>

<xsl:template match="methodname" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="methodparam" mode="java">
  <xsl:param name="indent">0</xsl:param>
  <xsl:if test="preceding-sibling::methodparam">
    <xsl:text>,&#10;</xsl:text>
    <xsl:if test="$indent &gt; 0">
      <xsl:call-template name="copy-string">
        <xsl:with-param name="string" select="' '"/>
        <xsl:with-param name="count" select="$indent + 1"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template match="parameter" mode="java">
  <xsl:apply-templates mode="java"/>
</xsl:template>

<xsl:template mode="java"
  match="constructorsynopsis|destructorsynopsis|methodsynopsis">
  <xsl:variable name="modifiers" select="modifier"/>
  <xsl:variable name="notmod" select="*[name(.) != 'modifier']"/>
  <xsl:variable name="decl">
    <xsl:text>  </xsl:text>
    <xsl:apply-templates select="$modifiers" mode="java"/>

    <!-- type -->
    <xsl:if test="name($notmod[1]) != 'methodname'">
      <xsl:apply-templates select="$notmod[1]" mode="java"/>
    </xsl:if>

    <xsl:apply-templates select="methodname" mode="java"/>
  </xsl:variable>

  <xsl:copy-of select="$decl"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="methodparam" mode="java">
    <xsl:with-param name="indent" select="string-length($decl)"/>
  </xsl:apply-templates>
  <xsl:text>)</xsl:text>
  <xsl:if test="exceptionname">
    <xsl:text>&#10;    throws </xsl:text>
    <xsl:apply-templates select="exceptionname" mode="java"/>
  </xsl:if>
  <xsl:text>;&#10;</xsl:text>
</xsl:template>

<xsl:template match="ooclass|oointerface|ooexception" mode="java">
  <xsl:choose>
  <xsl:when test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text> </xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates mode="java"/>
</xsl:template>


<!-- #########
     #  C++  #
     ######### -->

<xsl:template match="classsynopsis" mode="cpp">
  <xsl:apply-templates select="ooclass[1]" mode="cpp"/>
  <xsl:if test="ooclass[position() &gt; 1]">
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="ooclass[position() &gt; 1]" mode="cpp"/>
    <xsl:if test="oointerface|ooexception">
      <xsl:text>&#10;    </xsl:text>
    </xsl:if>
  </xsl:if>
  <xsl:if test="oointerface">
    <xsl:text> implements</xsl:text>
    <xsl:apply-templates select="oointerface" mode="cpp"/>
    <xsl:if test="ooexception">
      <xsl:text>&#10;    </xsl:text>
    </xsl:if>
  </xsl:if>
  <xsl:if test="ooexception">
    <xsl:text> throws </xsl:text>
    <xsl:apply-templates select="ooexception" mode="cpp"/>
  </xsl:if>
  <xsl:text> {&#10;&#10;</xsl:text>
  <xsl:apply-templates select="constructorsynopsis
                              |destructorsynopsis
                              |fieldsynopsis
                              |methodsynopsis
                              |classsynopsisinfo" mode="cpp"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="classsynopsisinfo" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="ooclass|oointerface|ooexception" mode="cpp">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="modifier" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="classname" mode="cpp">
  <xsl:if test="name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="interfacename" mode="cpp">
  <xsl:if test="name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>

  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="exceptionname" mode="cpp">
  <xsl:if test="name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="fieldsynopsis" mode="cpp">
  <xsl:text>  </xsl:text>
  <xsl:apply-templates mode="cpp"/>
  <xsl:text>;&#10;</xsl:text>
</xsl:template>

<xsl:template match="type" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="varname" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="initializer" mode="cpp">
  <xsl:text> = </xsl:text>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="void" mode="cpp">
  <xsl:text>void </xsl:text>
</xsl:template>

<xsl:template match="methodname" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="methodparam" mode="cpp">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template match="parameter" mode="cpp">
  <xsl:apply-templates mode="cpp"/>
</xsl:template>

<xsl:template mode="cpp"
  match="constructorsynopsis|destructorsynopsis|methodsynopsis">
  <xsl:variable name="modifiers" select="modifier"/>
  <xsl:variable name="notmod" select="*[name(.) != 'modifier']"/>
  <xsl:variable name="type">
  </xsl:variable>

  <xsl:text>  </xsl:text>
  <xsl:apply-templates select="$modifiers" mode="cpp"/>

  <!-- type -->
  <xsl:if test="name($notmod[1]) != 'methodname'">
    <xsl:apply-templates select="$notmod[1]" mode="cpp"/>
  </xsl:if>

  <xsl:apply-templates select="methodname" mode="cpp"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="methodparam" mode="cpp"/>
  <xsl:text>)</xsl:text>
  <xsl:if test="exceptionname">
    <xsl:text>&#10;    throws </xsl:text>
    <xsl:apply-templates select="exceptionname" mode="cpp"/>
  </xsl:if>
  <xsl:text>;&#10;</xsl:text>
</xsl:template>


<!-- ########
     # Perl #
     ######## -->

<xsl:template match="classsynopsis" mode="perl">
  <xsl:text>package </xsl:text>
  <xsl:apply-templates select="ooclass[1]" mode="perl"/>
  <xsl:text>;&#10;</xsl:text>

  <xsl:if test="ooclass[position() &gt; 1]">
    <xsl:text>@ISA = (</xsl:text>
    <xsl:apply-templates select="ooclass[position() &gt; 1]" mode="perl"/>
    <xsl:text>);&#10;&#10;</xsl:text>
  </xsl:if>

  <xsl:apply-templates select="constructorsynopsis
                              |destructorsynopsis
                              |fieldsynopsis
                              |methodsynopsis
                              |classsynopsisinfo" mode="perl"/>
</xsl:template>

<xsl:template match="classsynopsisinfo" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="ooclass|oointerface|ooexception" mode="perl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="modifier" mode="perl">
  <xsl:apply-templates mode="perl"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="classname" mode="perl">
  <xsl:if test="name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="interfacename" mode="perl">
  <xsl:if test="name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="exceptionname" mode="perl">
  <xsl:if test="name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="fieldsynopsis" mode="perl">
  <xsl:apply-templates mode="perl"/>
  <xsl:text>;&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="type" mode="perl">
  <xsl:apply-templates mode="perl"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="varname" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="initializer" mode="perl">
  <xsl:text> = </xsl:text>
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="void" mode="perl">
  <xsl:text>void </xsl:text>
</xsl:template>

<xsl:template match="methodname" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template match="methodparam" mode="perl">
  <xsl:text>  my $</xsl:text>
  <xsl:apply-templates mode="perl"/>
  <xsl:text> = shift;&#10;</xsl:text>
</xsl:template>

<xsl:template match="parameter" mode="perl">
  <xsl:apply-templates mode="perl"/>
</xsl:template>

<xsl:template mode="perl"
  match="constructorsynopsis|destructorsynopsis|methodsynopsis">
  <xsl:variable name="modifiers" select="modifier"/>
  <xsl:variable name="notmod" select="*[name(.) != 'modifier']"/>
  <xsl:variable name="type"> </xsl:variable>

  <xsl:text>sub </xsl:text>
  <xsl:apply-templates select="methodname" mode="perl"/>
  <xsl:text> {</xsl:text>
  <xsl:if test="methodparam">
    <xsl:text>&#10;  my $this = shift;&#10;</xsl:text>
    <xsl:apply-templates select="methodparam" mode="perl"/>
  </xsl:if>
  <xsl:text> ... </xsl:text>
  <xsl:if test="methodparam">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>}&#10;&#10;</xsl:text>
</xsl:template>


<!-- ########
     # IDL  #
     ######## -->

<xsl:template match="classsynopsisinfo" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="ooclass|oointerface|ooexception" mode="idl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="modifier" mode="idl">
  <xsl:apply-templates mode="idl"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="classname" mode="idl">
  <xsl:if test="name(preceding-sibling::*[1]) = 'classname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="interfacename" mode="idl">
  <xsl:if test="name(preceding-sibling::*[1]) = 'interfacename'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="exceptionname" mode="idl">
  <xsl:if test="name(preceding-sibling::*[1]) = 'exceptionname'">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="fieldsynopsis" mode="idl">
  <xsl:text>  </xsl:text>
  <xsl:apply-templates mode="idl"/>
  <xsl:text>;</xsl:text>
</xsl:template>

<xsl:template match="type" mode="idl">
  <xsl:apply-templates mode="idl"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="varname" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="initializer" mode="idl">
  <xsl:text> = </xsl:text>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="void" mode="idl">
  <xsl:text>void </xsl:text>
</xsl:template>

<xsl:template match="methodname" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="methodparam" mode="idl">
  <xsl:if test="position() &gt; 1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template match="parameter" mode="idl">
  <xsl:apply-templates mode="idl"/>
</xsl:template>

<xsl:template mode="idl"
  match="constructorsynopsis|destructorsynopsis|methodsynopsis">
  <xsl:variable name="modifiers" select="modifier"/>
  <xsl:variable name="notmod" select="*[name(.) != 'modifier']"/>
  <xsl:variable name="type">
  </xsl:variable>
  
  <xsl:text>  </xsl:text>
  <xsl:apply-templates select="$modifiers" mode="idl"/>

  <!-- type -->
  <xsl:if test="name($notmod[1]) != 'methodname'">
    <xsl:apply-templates select="$notmod[1]" mode="idl"/>
  </xsl:if>

  <xsl:apply-templates select="methodname" mode="idl"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="methodparam" mode="idl"/>
  <xsl:text>)</xsl:text>
  <xsl:if test="exceptionname">
    <xsl:text>&#10;    raises(</xsl:text>
    <xsl:apply-templates select="exceptionname" mode="idl"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
  <xsl:text>;</xsl:text>
  
</xsl:template>






<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Convert hexadecimal format to decimal -->
<xsl:template name="hex-to-int">
  <xsl:param name="hex" select="'0'"/>

  <xsl:choose>
  <xsl:when test="string-length($hex)=1">
    <xsl:call-template name="char-to-int">
      <xsl:with-param name="char" select="$hex"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="low.int">
      <xsl:call-template name="char-to-int">
        <xsl:with-param name="char"
                        select="substring($hex, string-length($hex))"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="high.int">
      <xsl:call-template name="hex-to-int">
        <xsl:with-param name="hex"
                        select="substring($hex, 1, string-length($hex)-1)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$low.int + 16*$high.int"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="char-to-int">
  <xsl:param name="char" select="'0'"/>
  <xsl:variable name="c">
    <xsl:value-of select="translate($char, 'abcdef', 'ABCDEF')"/>
  </xsl:variable>

  <xsl:value-of select="string-length(substring-before('0123456789ABCDEF',
                                      $c))"/>
</xsl:template>

<!-- Convert xxyyzz to rate(xx),rate(yy),rate(zz) -->
<xsl:template name="hex-to-rgb">
  <xsl:param name="hex" select="'0'"/>
  <xsl:choose>
  <xsl:when test="string-length($hex) &lt;= 2">
    <xsl:call-template name="hex-to-rate">
      <xsl:with-param name="hex" select="$hex"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="right">
      <xsl:call-template name="hex-to-rate">
        <xsl:with-param name="hex"
                        select="substring($hex, string-length($hex)-1)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="left">
      <xsl:call-template name="hex-to-rgb">
        <xsl:with-param name="hex"
                        select="substring($hex, 1, string-length($hex)-2)"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$left"/>
    <xsl:text>,</xsl:text>
    <xsl:value-of select="$right"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Convert 0xCC to 0.8 = 204/255 -->
<xsl:template name="hex-to-rate">
  <xsl:param name="hex" select="'0'"/>
  <xsl:variable name="int">
    <xsl:call-template name="hex-to-int">
      <xsl:with-param name="hex" select="$hex"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="round(($int * 100) div 255) div 100"/>
</xsl:template>


<!-- Convert color to a proper latex format:
     #xxyyzz   => [rgb]{u,v,w}
     #xaxaxa   => [gray]{u}
     xxx       => {xxx}
     {xxx}     => {xxx}
     [aa]{xxx} => [aa]{xxx}
-->
<xsl:template name="get-color">
  <xsl:param name="color"/>
  <xsl:choose>
  <xsl:when test="starts-with($color, '#')">
    <xsl:variable name="fullcolor"
                  select="concat('000000', substring-after($color, '#'))"/>
    <xsl:variable name="rcolor"
                  select="substring($fullcolor, string-length($fullcolor)-5)"/>
    <xsl:variable name="r" select="substring($rcolor,1,2)"/>
    <xsl:variable name="g" select="substring($rcolor,3,2)"/>
    <xsl:variable name="b" select="substring($rcolor,5,2)"/>
    <xsl:choose>
    <xsl:when test="$r=$g and $g=$b">
      <xsl:text>[gray]{</xsl:text>
      <xsl:call-template name="hex-to-rate">
        <xsl:with-param name="hex" select="$r"/>
      </xsl:call-template>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>[rgb]{</xsl:text>
      <xsl:call-template name="hex-to-rgb">
        <xsl:with-param name="hex" select="$rcolor"/>
      </xsl:call-template>
      <xsl:text>}</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="starts-with($color, '[') or starts-with($color, '{')">
    <xsl:value-of select="$color"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$color"/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Just for a unit-test like that:
     <u>
       <rgb>CCFFEE</rgb>
       <rgb>DD7E67</rgb>
       <rgb>7A33</rgb>
       <color>#d5</color>
       <color>#7A33</color>
       <color>#3a7a33</color>
       <color>#3a3a3a</color>
       <color>#cccccc</color>
       <color>red</color>
       <color>{blue}</color>
       <color>[gray]{0.8}</color>
     </u>
-->
<xsl:template match="rgb">
  <xsl:call-template name="hex-to-rgb">
    <xsl:with-param name="hex" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="color">
  <xsl:call-template name="get-color">
    <xsl:with-param name="color" select="."/>
  </xsl:call-template>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="preface.tocdepth">0</xsl:param>
<xsl:param name="dedication.tocdepth">0</xsl:param>
<xsl:param name="colophon.tocdepth">0</xsl:param>
<xsl:param name="beginpage.as.pagebreak" select="1"/>


<xsl:template match="colophon">
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="number($colophon.tocdepth)"/>
    <xsl:with-param name="title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Colophon'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="dedication">
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="number($dedication.tocdepth)"/>
    <xsl:with-param name="title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Dedication'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="preface">
  <xsl:call-template name="section.unnumbered">
    <xsl:with-param name="tocdepth" select="number($preface.tocdepth)"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="section.unnumbered">
  <xsl:param name="tocdepth" select="0"/>
  <xsl:param name="level" select="'0'"/>
  <xsl:param name="titlenode" select="(title|info/title)[1]"/>
  <xsl:param name="title"/>

  <xsl:call-template name="section.unnumbered.begin">
    <xsl:with-param name="tocdepth" select="$tocdepth"/>
    <xsl:with-param name="level" select="$level"/>
    <xsl:with-param name="titlenode" select="$titlenode"/>
    <xsl:with-param name="title" select="$title"/>
  </xsl:call-template>

  <xsl:apply-templates select="." mode="section.body"/>

  <xsl:call-template name="section.unnumbered.end">
    <xsl:with-param name="tocdepth" select="$tocdepth"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="section.unnumbered.begin">
  <xsl:param name="tocdepth" select="0"/>
  <xsl:param name="level" select="'0'"/>
  <xsl:param name="titlenode" select="title"/>
  <xsl:param name="title"/>
  <xsl:choose>
  <xsl:when test="number($tocdepth) = -1">
    <xsl:call-template name="mapheading"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- don't use starred headings, but rely on counters instead -->
    <xsl:text>\setcounter{secnumdepth}{-1}&#10;</xsl:text>
    <xsl:if test="$tocdepth &lt;= $toc.section.depth">
      <xsl:call-template name="set-tocdepth">
        <xsl:with-param name="depth" select="$tocdepth - 1"/>
      </xsl:call-template>
    </xsl:if>
    <!-- those sections have optional title -->
    <xsl:choose>
      <xsl:when test="$titlenode">
        <xsl:call-template name="makeheading">
          <xsl:with-param name="level" select="$level"/>
          <xsl:with-param name="allnum" select="'1'"/>
          <xsl:with-param name="title" select="$titlenode"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="maketitle">
          <xsl:with-param name="level" select="$level"/>
          <xsl:with-param name="allnum" select="'1'"/>
          <xsl:with-param name="title" select="$title"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="section.unnumbered.end">
  <xsl:param name="tocdepth" select="0"/>
  <xsl:if test="number($tocdepth) &gt; -1">
    <!-- restore the initial counters -->
    <xsl:text>\setcounter{secnumdepth}{</xsl:text>
    <xsl:value-of select="$doc.section.depth"/>
    <xsl:text>}&#10;</xsl:text>
    <xsl:if test="$tocdepth &lt;= $toc.section.depth">
      <xsl:call-template name="set-tocdepth">
        <xsl:with-param name="depth" select="$toc.section.depth"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- By default the (unumbered) section body just processes children -->
<xsl:template match="*" mode="section.body">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="dedication/title"></xsl:template>
<xsl:template match="dedication/subtitle"></xsl:template>
<xsl:template match="dedication/titleabbrev"></xsl:template>
<xsl:template match="colophon/title"></xsl:template>
<xsl:template match="preface/title"></xsl:template>
<xsl:template match="preface/titleabbrev"></xsl:template>
<xsl:template match="preface/subtitle"></xsl:template>
<xsl:template match="preface/docinfo|prefaceinfo"></xsl:template>

<!-- preface sect{1-5} mapped like sections -->

<xsl:template match="preface//sect1|
                     preface//sect2|
                     preface//sect3|
                     preface//sect4|
                     preface//sect5">
  <xsl:choose>
  <xsl:when test="number($preface.tocdepth) = -1">
    <xsl:call-template name="makeheading">
      <xsl:with-param name="name" select="local-name(.)"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="makeheading">
      <xsl:with-param name="name" select="local-name(.)"/>
      <xsl:with-param name="allnum" select="'1'"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="preface//section">
  <xsl:variable name="allnum">
    <xsl:choose>
    <xsl:when test="number($preface.tocdepth) = -1">0</xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="makeheading">
    <xsl:with-param name="level" select="count(ancestor::section)+1"/>
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<!-- don't know where to put it -->
<xsl:template match="beginpage">
  <xsl:if test="$beginpage.as.pagebreak=1">
    <xsl:choose>
    <xsl:when test="@pagenum != ''">
      <xsl:message>Cannot start a new page at a specific page number</xsl:message>
    </xsl:when>
    <xsl:when test="@role = 'openright'">
      <xsl:text>\cleardoublepage&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>\clearpage&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template name="dingbat">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:call-template name="dingbat.characters">
    <xsl:with-param name="dingbat" select="$dingbat"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="dingbat.characters">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:choose>
    <xsl:when test="$dingbat='bullet'"> $\bullet$ </xsl:when>
    <!-- \textnormal to prevent from latex/3420 bug in bold environment -->
    <xsl:when test="$dingbat='copyright'">\textnormal{\copyright}</xsl:when>
    <xsl:when test="$dingbat='registered'">\textnormal{\textregistered}</xsl:when>
    <xsl:when test="$dingbat='trademark'">\texttrademark{}</xsl:when>
    <xsl:when test="$dingbat='nbsp'">&#x00A0;</xsl:when>
    <xsl:when test="$dingbat='ldquo'">"</xsl:when>
    <xsl:when test="$dingbat='rdquo'">"</xsl:when>
    <xsl:when test="$dingbat='lsquo'">'</xsl:when>
    <xsl:when test="$dingbat='rsquo'">'</xsl:when>
    <xsl:when test="$dingbat='em-dash'">&#x2014;</xsl:when>
    <xsl:when test="$dingbat='mdash'">&#x2014;</xsl:when>
    <xsl:when test="$dingbat='en-dash'">&#x2013;</xsl:when>
    <xsl:when test="$dingbat='ndash'">&#x2013;</xsl:when>
    <xsl:otherwise>
      <xsl:text> [dingbat?] </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:output method="text" encoding="UTF-8" indent="yes"/>

<!-- <xsl:include href="common/misc.xsl"/>
<xsl:include href="common/l10n.xsl"/>
<xsl:include href="common/common.xsl"/>
<xsl:include href="common/gentext.xsl"/>
<xsl:include href="common/labels.xsl"/>
<xsl:include href="common/olink.xsl"/>
<xsl:include href="common/lib.xsl"/>
<xsl:include href="common/titles.xsl"/> -->
<!-- <xsl:include href="chapter.xsl"/>
<xsl:include href="bridgehead.xsl"/>
<xsl:include href="color.xsl"/>
<xsl:include href="newtbl.xsl"/>
<xsl:include href="htmltbl.xsl"/>
<xsl:include href="tablen.xsl"/>
<xsl:include href="admon.xsl"/>
<xsl:include href="revision.xsl"/>
<xsl:include href="legalnotice.xsl"/>
<xsl:include href="example.xsl"/>
<xsl:include href="inlined.xsl"/>
<xsl:include href="url.xsl"/>
<xsl:include href="format.xsl"/>
<xsl:include href="verbatim.xsl"/>
<xsl:include href="verbatimco.xsl"/>
<xsl:include href="refentry.xsl"/>
<xsl:include href="biblio.xsl"/>
<xsl:include href="index.xsl"/>
<xsl:include href="footnote.xsl"/>
<xsl:include href="procedure.xsl"/>
<xsl:include href="lists.xsl"/>
<xsl:include href="xref.xsl"/>
<xsl:include href="lang.xsl"/>
<xsl:include href="set.xsl"/>
<xsl:include href="pagesetup.xsl"/>
<xsl:include href="pdfmeta.xsl"/>
<xsl:include href="preamble.xsl"/>
<xsl:include href="main.xsl"/>
<xsl:include href="version.xsl"/>
<xsl:include href="param.xsl"/>
<xsl:include href="citation.xsl"/>
<xsl:include href="graphic.xsl"/>
<xsl:include href="equation.xsl"/>
<xsl:include href="figure.xsl"/>
<xsl:include href="mediaobject.xsl"/>
<xsl:include href="mediaobjectco.xsl"/>
<xsl:include href="callout.xsl"/>
<xsl:include href="sections.xsl"/>
<xsl:include href="labelid.xsl"/>
<xsl:include href="sgmltag.xsl"/>
<xsl:include href="msgset.xsl"/>
<xsl:include href="part.xsl"/>
<xsl:include href="appendix.xsl"/>
<xsl:include href="abstract.xsl"/>
<xsl:include href="email.xsl"/>
<xsl:include href="toc_lot.xsl"/>
<xsl:include href="dingbat.xsl"/>
<xsl:include href="component.xsl"/>
<xsl:include href="keyword.xsl"/>
<xsl:include href="glossary.xsl"/>
<xsl:include href="synopsis.xsl"/>
<xsl:include href="classsynopsis.xsl"/>
<xsl:include href="qandaset.xsl"/>
<xsl:include href="quote.xsl"/>
<xsl:include href="sidebar.xsl"/>
<xsl:include href="annotation.xsl"/>
<xsl:include href="chunker.xsl"/>
<xsl:include href="docbookng.xsl"/>
<xsl:include href="para.xsl"/>
<xsl:include href="scape.xsl"/>
<xsl:include href="pi.xsl"/> -->

<!-- <xsl:include href="errors.xsl"/> -->

<xsl:key name="id" match="*" use="@id|@xml:id"/>

<xsl:strip-space elements="book article articleinfo chapter"/>


<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:template match="info"/>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="email">
  <xsl:text>\href{mailto:</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>}{</xsl:text>
  <xsl:call-template name="hyphen-encode">
    <xsl:with-param name="string">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="tex.math.in.alt" select="'latex'"/>
<xsl:param name="alt.use" select="0"/>
<xsl:param name="equation.default.position">[H]</xsl:param>


<xsl:template match="inlineequation|informalequation" name="equation">
  <xsl:choose>
  <xsl:when test="alt and $tex.math.in.alt='latex'">
    <xsl:apply-templates select="alt" mode="latex"/>
  </xsl:when>
  <xsl:when test="alt and (count(child::*)=1 or $alt.use='1')">
    <!-- alt is simply some text -->
    <xsl:apply-templates select="alt"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="*[not(self::alt)]"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="equation">
  <xsl:variable name="delim">
    <xsl:if test="descendant::alt/processing-instruction('texmath')">
      <xsl:call-template name="pi-attribute">
        <xsl:with-param name="pis"
                   select="descendant::alt/processing-instruction('texmath')"/>
        <xsl:with-param name="attribute" select="'delimiters'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="title">
    <xsl:text>&#10;\begin{dbequation}</xsl:text>
    <!-- float placement preference -->
    <xsl:choose>
      <xsl:when test="@floatstyle != ''">
        <xsl:value-of select="@floatstyle"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$equation.default.position"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="equation"/>
    <xsl:text>&#10;\caption{</xsl:text>
    <xsl:call-template name="normalize-scape">
       <xsl:with-param name="string" select="title"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
    <xsl:call-template name="label.id"/>
    <xsl:text>&#10;\end{dbequation}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$delim='user'">
    <!-- The user provide its own environment -->
    <xsl:call-template name="equation"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- This is an actual LaTeX equation -->
    <xsl:text>&#10;\begin{equation}&#10;</xsl:text>
    <xsl:call-template name="label.id"/>
    <xsl:call-template name="equation"/>
    <xsl:text>&#10;\end{equation}&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="alt|mathphrase">
  <xsl:apply-templates/>
</xsl:template>
<xsl:template match="equation/title"/>

<!-- Direct copy of the content -->

<xsl:template match="alt" mode="latex">
  <xsl:variable name="delim">
    <xsl:if test="processing-instruction('texmath')">
      <xsl:call-template name="pi-attribute">
        <xsl:with-param name="pis"
                   select="processing-instruction('texmath')"/>
        <xsl:with-param name="attribute" select="'delimiters'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="tex">
    <xsl:variable name="text" select="normalize-space(.)"/>
    <xsl:variable name="len" select="string-length($text)"/>
    <xsl:choose>
    <xsl:when test="$delim='user'">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:when test="ancestor::equation[not(child::title)]">
      <!-- Remove any math mode in an equation environment -->
      <xsl:choose>
      <xsl:when test="starts-with($text,'$') and
                      substring($text,$len,$len)='$'">
        <xsl:copy-of select="substring($text, 2, $len - 2)"/>
      </xsl:when>
      <xsl:when test="(starts-with($text,'\[') and
                       substring($text,$len - 1,$len)='\]') or
                      (starts-with($text,'\(') and
                       substring($text,$len - 1,$len)='\)')">
        <xsl:copy-of select="substring($text, 3, $len - 4)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="."/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- Test to be DB5 compatible, where <alt> can be in other elements -->
    <xsl:when test="ancestor::equation or
                    ancestor::informalequation or
                    ancestor::inlineequation">
      <!-- Keep the specified math mode... -->
      <xsl:choose>
      <xsl:when test="(starts-with($text,'\[') and
                       substring($text,$len - 1,$len)='\]') or
                      (starts-with($text,'\(') and
                       substring($text,$len - 1,$len)='\)') or
                      (starts-with($text,'$') and
                       substring($text,$len,$len)='$')">
        <xsl:copy-of select="$text"/>
      </xsl:when>
      <!-- ...Or wrap in default math mode -->
      <xsl:otherwise>
        <xsl:copy-of select="concat('$', $text, '$')"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>
  <!-- Encode it properly -->
  <xsl:call-template name="scape-encode">
    <xsl:with-param name="string" select="$tex"/>
  </xsl:call-template>
</xsl:template>




<xsl:template match="*">
  <xsl:message>
    <xsl:text>No template matches </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:if test="parent::*">
      <xsl:text> in </xsl:text>
      <xsl:value-of select="name(parent::*)"/>
    </xsl:if>
    <xsl:text>.</xsl:text>
  </xsl:message>

  <xsl:text>% &lt;</xsl:text>
  <xsl:value-of select="name(.)"/>
  <xsl:text>&gt;&#10;</xsl:text>
  <xsl:apply-templates/> 
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="example.default.position">[H]</xsl:param>
<xsl:param name="example.float.type">none</xsl:param>


<xsl:template match="example">
  <xsl:choose>
    <xsl:when test="@floatstyle='none' or
                   (not(@floatstyle) and $example.float.type='none')">
      <xsl:apply-templates select="." mode="block"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="float"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="example" mode="block">
  <xsl:text>&#10;\begin{longfloat}{example}{</xsl:text>
  <!-- caption -->
  <xsl:apply-templates select="title"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>&#10;\end{longfloat}&#10;</xsl:text>
</xsl:template>

<xsl:template match="example" mode="float">
  <xsl:text>&#10;\begin{example}</xsl:text>
  <!-- float placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$example.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <!-- caption -->
  <xsl:apply-templates select="title"/>
  <xsl:text>&#10;\end{example}&#10;</xsl:text>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="example/title">
  <xsl:text>\caption</xsl:text>
  <xsl:apply-templates select="." mode="format.title"/>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="parent::example"/>
  </xsl:call-template>
</xsl:template>


<?xml version='1.0' encoding="iso-8859-1"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY t1 "&#x370;t">
<!ENTITY t2 "&#x371;t">
<!ENTITY u1 "&#x370;u">
<!ENTITY u2 "&#x371;u">
<!ENTITY v1 "&#x370;u">
<!ENTITY v2 "&#x371;u">
<!ENTITY h1 "&#x370;h">
<!ENTITY h2 "&#x371;h">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- These templates boost the text processing but needs some post-parsing
     to escape the TeX characters and do the encoding. -->

<!-- use Reserved Unicode characters as delimiters -->
<xsl:template name="scape" >
  <xsl:param name="string"/>
  <xsl:text>&t1;</xsl:text>
  <xsl:value-of select="$string"/>
  <xsl:text>&t2;</xsl:text>
</xsl:template>

<!-- tag the text for post-processing -->
<xsl:template match="text()">
  <xsl:text>&t1;</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>&t2;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="latex.programlisting">
  <xsl:param name="probe" select="0"/>
  <xsl:if test="$probe = 0">
    <xsl:text>&v1;</xsl:text>
    <xsl:value-of select="."/> 
    <xsl:text>&v2;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="text()" mode="latex.verbatim">
  <xsl:text>&v1;</xsl:text>
  <xsl:value-of select="."/> 
  <xsl:text>&v2;</xsl:text>
</xsl:template>

<!-- specific handling depending on the context -->
<xsl:template match="text()[ancestor::ulink]">
  <!-- LaTeX chars are scaped. Each / except the :// is mapped to a /\- -->
  <xsl:apply-templates select="." mode="slash.hyphen"/>
</xsl:template>

<!-- replace some text in a string *as if* the string is already escaped.
     Here it ends to inserting raw text between tags. -->
<xsl:template name="scape-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:call-template name="string-replace">
    <xsl:with-param name="string" select="$string"/>
    <xsl:with-param name="from" select="$from"/>
    <xsl:with-param name="to" select="concat('&t2;',$to,'&t1;')"/>
  </xsl:call-template>
</xsl:template>

<!-- just ask for encoding -->
<xsl:template name="scape-encode" >
  <xsl:param name="string"/>
  <xsl:text>&u1;</xsl:text>
  <xsl:value-of select="$string"/>
  <xsl:text>&u2;</xsl:text>
</xsl:template>

<!-- ask for hyphenating -->
<xsl:template name="hyphen-encode" >
  <xsl:param name="string"/>
  <xsl:text>&h1;</xsl:text>
  <xsl:value-of select="$string"/>
  <xsl:text>&h2;</xsl:text>
</xsl:template>

<!-- specific behaviour for MML -->
<xsl:template match="m:*/text()">
  <xsl:call-template name="mmltext"/>
</xsl:template>

<xsl:template name="normalize-scape" >
  <xsl:param name="string"/>
  <xsl:call-template name="scape">
    <xsl:with-param name="string">
      <xsl:value-of select="normalize-space($string)"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Figure parameters -->
<xsl:param name="figure.title.top">0</xsl:param>
<xsl:param name="figure.anchor.top" select="$figure.title.top"/>
<xsl:param name="figure.default.position">[htbp]</xsl:param>


<xsl:template match="figure">
  <xsl:text>\begin{figure}</xsl:text>
  <!-- figure placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:when test="not(@float) or (@float and @float='0')">
      <xsl:text>[H]</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$figure.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>

  <!-- title caption before the image -->
  <xsl:apply-templates select="." mode="caption.and.label">
    <xsl:with-param name="position.top" select="1"/>
  </xsl:apply-templates>

  <!-- <xsl:text>&#10;\centering&#10;</xsl:text> -->
  <xsl:text>&#10;\begin{center}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>&#10;\end{center}&#10;</xsl:text>

  <!-- title caption after the image -->
  <xsl:apply-templates select="." mode="caption.and.label">
    <xsl:with-param name="position.top" select="0"/>
  </xsl:apply-templates>
  <xsl:text>\end{figure}&#10;</xsl:text>
</xsl:template>


<xsl:template match="informalfigure">
  <xsl:text>&#10;\begin{center}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;\end{center}&#10;</xsl:text>
</xsl:template>


<!-- Caption and label must be handled at the same time because \caption
     increments the label counter and puts an anchor. Therefore putting a
     label *before* the related caption needs to manipulate the counters
     
     Limitation: it is not possible to put a caption on the top, and the
     label anchor at the bottom. The first caption anchor at the top prevails.
     Putting a label before the caption is possible because the
     duplicated label name when \caption is called is ignored
     (see latex warnings) -->

<xsl:template match="figure" mode="caption.and.label">
  <xsl:param name="position.top"/>

  <xsl:choose>
  <xsl:when test="$figure.title.top='1'">

    <xsl:if test="$position.top='1'">
      <xsl:text>\caption</xsl:text>
      <xsl:apply-templates select="title" mode="format.title"/>
    </xsl:if>

    <xsl:if test="$figure.anchor.top=$position.top">
      <xsl:call-template name="label.id">
        <xsl:with-param name="object" select="."/>
      </xsl:call-template>
    </xsl:if>

  </xsl:when>
  <xsl:when test="$figure.title.top='0'">

    <xsl:choose>
    <xsl:when test="$position.top='1'">
      <xsl:if test="$figure.anchor.top='1'">
        <xsl:text>\refstepcounter{figure}</xsl:text>
        <xsl:call-template name="label.id">
          <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="$figure.anchor.top='1'">
        <xsl:text>\addtocounter{figure}{-1}</xsl:text>
      </xsl:if>

      <xsl:text>\caption</xsl:text>
      <xsl:apply-templates select="title" mode="format.title"/>

      <xsl:if test="$figure.anchor.top='0'">
        <xsl:call-template name="label.id">
          <xsl:with-param name="object" select="."/>
        </xsl:call-template>
      </xsl:if>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  </xsl:choose>
</xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:template match="footnote">
  <xsl:choose>
  <!-- in forbidden areas, only put the footnotemark. footnotetext will
       follow in the next possible area (foottext mode) -->
  <xsl:when test="ancestor::term|
                  ancestor::title">
    <xsl:text>\footnotemark{}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\footnote{</xsl:text>
    <xsl:call-template name="label.id">
      <xsl:with-param name="inline" select="1"/>
    </xsl:call-template>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Table cells are forbidden for footnotes -->
<xsl:template match="footnote[ancestor::entry]">
  <xsl:text>\footnotemark{}</xsl:text>
</xsl:template>

<xsl:template match="footnoteref">
  <!-- Works only with footmisc -->
  <xsl:text>\footref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- display the text of the footnotes contained in this element -->
<xsl:template match="*" mode="foottext">
  <xsl:variable name="foot" select="descendant::footnote"/>
  <xsl:if test="count($foot)&gt;0">
    <xsl:text>\addtocounter{footnote}{-</xsl:text>
    <xsl:value-of select="count($foot)"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select="$foot" mode="foottext"/>
  </xsl:if>
</xsl:template>

<xsl:template match="footnote" mode="foottext">
  <xsl:text>\stepcounter{footnote}&#10;</xsl:text>
  <xsl:text>\footnotetext{</xsl:text>
  <xsl:apply-templates/>
  <xsl:call-template name="label.id"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- in a programlisting do as normal but in tex-escaped pattern -->
<xsl:template match="footnote" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.embed">
    <xsl:with-param name="co-taging" select="$co-tagin"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>


<xsl:template match="*" mode="toc.skip">
  <xsl:apply-templates mode="toc.skip"/>
</xsl:template>

<!-- escape characters as usual -->
<xsl:template match="text()" mode="toc.skip">
  <xsl:apply-templates select="."/>
</xsl:template>

<!-- in this mode the footnotes must vanish -->
<xsl:template match="footnote" mode="toc.skip"/>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template name="scape" >
  <xsl:param name="string"/>
  <xsl:call-template name="tex-format">
    <xsl:with-param name="string" select="$string"/>
  </xsl:call-template>
</xsl:template>


<!-- Text format template -->

<xsl:template name="tex-format">
  <xsl:param name="string"/>
  <xsl:call-template name="special-replace">
    <xsl:with-param name="i">1</xsl:with-param>
    <xsl:with-param name="mapfile" select="document('texmap.xml')"/>
    <xsl:with-param name="string" select="$string"/>
  </xsl:call-template>
</xsl:template>


<!-- Special character replacement engine -->

<xsl:template name="special-replace">
  <xsl:param name="i"/>
  <xsl:param name="mapfile"/>
  <xsl:param name="string"/>
  <xsl:choose>
  <xsl:when test="($mapfile/mapping/map[position()=$i])[1]">
    <xsl:variable name="map" select="($mapfile/mapping/map[position()=$i])[1]"/>
    <xsl:call-template name="string-replace">
      <xsl:with-param name="to">
        <xsl:value-of select="$map/@text"/></xsl:with-param>
      <xsl:with-param name="from">
        <xsl:value-of select="$map/@key"/></xsl:with-param>
      <xsl:with-param name="string">
        <xsl:call-template name="special-replace">
          <xsl:with-param name="i" select="$i+1"/>
          <xsl:with-param name="mapfile" select="$mapfile"/>
          <xsl:with-param name="string" select="$string"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$string"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- map section to latex -->

<xsl:template name="sec-map">
  <xsl:param name="keyword"/>
  <xsl:param name="name" select="local-name(.)"/>
  <xsl:variable name="mapfile" select="document('secmap.xml')"/>
  <xsl:variable name="to" select="($mapfile/mapping/map[@key=$keyword])[1]/@text"/>
  <xsl:if test="$to=''">
    <xsl:message>*** No mapping for <xsl:value-of select="$keyword"/></xsl:message>
  </xsl:if>
  <xsl:value-of select="$to"/>
</xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="glossary.tocdepth">5</xsl:param>
<xsl:param name="glossary.numbered">1</xsl:param>

<!-- ############
     # glossary #
     ############ -->

<xsl:template match="glossary">
  <xsl:text>% --------	&#10;</xsl:text>
  <xsl:text>% GLOSSARY	&#10;</xsl:text>
  <xsl:text>% --------	&#10;</xsl:text>

  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level"/>
  </xsl:variable>

  <xsl:variable name="title.text">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Glossary'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$glossary.numbered = '0'">
    <!-- Unumbered section (but in TOC) -->
    <xsl:call-template name="section.unnumbered">
      <xsl:with-param name="tocdepth" select="number($glossary.tocdepth)"/>
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title.text"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="title">
    <!-- Numbered section from a <title> node -->
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="allnum" select="'1'"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="section.body"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- Numbered section from a generated title -->
    <xsl:call-template name="maketitle">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title.text"/>
    </xsl:call-template>
    <xsl:apply-templates select="." mode="section.body"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossary" mode="section.body">
  <xsl:variable name="divs" select="glossdiv"/>
  <xsl:variable name="entries" select="glossentry"/>
  <xsl:variable name="preamble" select="*[not(self::title
                                          or self::subtitle
                                          or self::glossdiv
                                          or self::glossentry)]"/>
  <xsl:if test="$preamble">
    <xsl:apply-templates select="$preamble"/>
  </xsl:if>

  <xsl:if test="$entries">
    <xsl:text>&#10;\noindent&#10;</xsl:text>
    <xsl:text>\begin{description}&#10;</xsl:text>
    <xsl:apply-templates select="$entries"/>
    <xsl:text>&#10;\end{description}&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="$divs">
    <xsl:apply-templates select="$divs"/>
  </xsl:if>
</xsl:template>

<xsl:template match="glossary/glossaryinfo"/>
<xsl:template match="glossary/title"/>
<xsl:template match="glossary/subtitle"/>
<xsl:template match="glossary/titleabbrev"/>


<!-- ############
     # glossdiv #
     ############ -->

<xsl:template match="glossdiv">
  <!-- find the appropriate section level -->
  <xsl:variable name="l">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="parent::glossary"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:call-template name="map.sect.level">
    <xsl:with-param name="level" select="$l+1"/>
  </xsl:call-template>
  <xsl:text>{</xsl:text>
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="title"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id"/>

  <!-- display the stuff before the entries -->
  <xsl:apply-templates select="*[not(self::glossentry)]"/>
  
  <!-- now, display the description list -->
  <xsl:text>&#10;\noindent&#10;</xsl:text>
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates select="glossentry"/>
  <xsl:text>&#10;\end{description}&#10;</xsl:text>
</xsl:template>


<!-- #############
     # glosslist #
     ############# -->

<xsl:template match="glossdiv/title" />

<xsl:template match="glosslist">
  <xsl:text>&#10;\noindent&#10;</xsl:text>
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;\end{description}&#10;</xsl:text>
</xsl:template>

<xsl:template match="glosslist/title" />
<xsl:template match="glosslist/blockinfo" />


<!-- ##############
     # glossentry #
     ############## -->

<xsl:template match="glossentry">
  <xsl:apply-templates select="*[not(self::glosssee or self::glossdef)]"/>
  <xsl:apply-templates select="glosssee|glossdef"/>
  <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="glossentry/glossterm">
  <xsl:text>\item[</xsl:text>
  <xsl:if test="../@id or ../@xml:id">
    <xsl:text>\hypertarget{</xsl:text>
    <xsl:value-of select="(../@id|../@xml:id)[1]"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:variable name="term">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($term)"/>
  <xsl:text>}]~ </xsl:text>
</xsl:template>

<xsl:template match="glossentry/acronym">
  <xsl:text> (\texttt{</xsl:text><xsl:apply-templates/><xsl:text>}) </xsl:text>
</xsl:template>
  
<xsl:template match="glossentry/abbrev">
  <xsl:text> [ </xsl:text><xsl:apply-templates/><xsl:text> ] </xsl:text> 
</xsl:template>

<!-- not printed -->
<xsl:template match="glossentry/revhistory"/>
  
<xsl:template match="glossentry/glossdef">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::glossseealso)]"/>
  <xsl:apply-templates select="glossseealso"/>
</xsl:template>

<xsl:template match="glossseealso|glosssee">
  <xsl:variable name="oterm" select="@otherterm"/>
  <xsl:variable name="targets" select="//node()[@id=$oterm or @xml:id=$oterm]"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:text> </xsl:text>
  <xsl:if test="position()=1">
    <xsl:if test="self::glosssee">
      <xsl:text>&#10;&#10;</xsl:text>
    </xsl:if>
    <xsl:call-template name="gentext.element.name"/>
    <xsl:call-template name="gentext.space"/>
  </xsl:if>
  <xsl:text>"</xsl:text>
  <xsl:choose>
    <xsl:when test="@otherterm">
      <xsl:call-template name="hyperlink.markup">
        <xsl:with-param name="linkend" select="@otherterm"/>
        <xsl:with-param name="text">
          <xsl:choose>
          <xsl:when test="$text!=''">
            <xsl:value-of select="$text"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$target" mode="xref"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>"</xsl:text>

  <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:text>.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>, </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="glossentry" mode="xref">
  <xsl:apply-templates select="./glossterm" mode="xref"/>
</xsl:template>

<xsl:template match="glossterm" mode="xref">
  <xsl:apply-templates/>
</xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="screenshot">
  <xsl:if test="not(parent::figure)">
    <xsl:text>&#10;\begin{center}&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="not(parent::figure)">
    <xsl:text>&#10;\end{center}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="screeninfo"/>

<xsl:template match="inlinegraphic|graphic">
  <xsl:choose>
  <xsl:when test="$imagedata.file.check='1'">
    <xsl:variable name="filename">
      <xsl:apply-templates select="." mode="filename.get"/>
    </xsl:variable>
    <xsl:text>\imgexists{</xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="imagedata"/>
    <xsl:text>}{[</xsl:text>
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="$filename"/>
    </xsl:call-template>
    <xsl:text> not found]}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="imagedata"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<?xml version='1.0' encoding="utf-8" ?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="doc exsl" version='1.0'>

<xsl:param name="default.table.rules">none</xsl:param>



<xsl:template match="table|informaltable" mode="htmlTable">
  <xsl:param name="tabletype">tabular</xsl:param>
  <xsl:param name="tablewidth">\linewidth-2\tabcolsep</xsl:param>
  <xsl:param name="tableframe">all</xsl:param>

  <xsl:variable name="numcols">
    <xsl:call-template name="widest-html-row">
      <xsl:with-param name="rows" select=".//tr"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Get the specified table width -->
  <xsl:variable name="table.width">
    <xsl:call-template name="table.width">
      <xsl:with-param name="fullwidth" select="$tablewidth"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Find the table width -->
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="not(contains($table.width,'auto'))">
        <xsl:value-of select="$table.width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="table.width">
          <xsl:with-param name="fullwidth" select="$tablewidth"/>
          <xsl:with-param name="exclude" select="'auto'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Now the frame style -->
  <xsl:variable name="frame">
    <xsl:choose>
      <xsl:when test="@frame">
        <xsl:call-template name="cals.frame">
          <xsl:with-param name="frame" select="@frame"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$tableframe"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="colspec">
    <xsl:choose>
    <xsl:when test="colgroup or col">
      <xsl:apply-templates select="(colgroup|col)[1]"
                           mode="make.colspec">
        <xsl:with-param name="colnum" select="1"/>
        <xsl:with-param name="colmax" select="$numcols"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="make.colspec.default">
        <xsl:with-param name="colnum" select="1"/>
        <xsl:with-param name="colmax" select="$numcols"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Build the <row>s from the <tr>s -->
  <xsl:variable name="rows-head" select="tr[child::th]"/>
  <xsl:variable name="rows-body" select="tr[not(child::th)]"/>

  <xsl:variable name="rows">
    <!-- First the header -->
    <xsl:choose>
    <xsl:when test="thead">
      <xsl:apply-templates select="thead" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$rows-head[1]" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
        <xsl:with-param name="rownum" select="1"/>
        <xsl:with-param name="context" select="'thead'"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>

    <!-- Then the body -->
    <xsl:choose>
    <xsl:when test="tbody">
      <xsl:apply-templates select="tbody" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$rows-body[1]" mode="htmlTable">
        <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
        <xsl:with-param name="rownum" select="count($rows-head) +
                                              count(thead/*) + 1"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates select="tfoot/tr[1]" mode="htmlTable">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      <xsl:with-param name="rownum" select="count(.//tr[not(parent::tfoot)])+1"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- Complete the colspecs @width from the fully expended <row>s -->
  <xsl:variable name="colspec2">
    <xsl:call-template name="build.colwidth">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      <xsl:with-param name="rows" select="exsl:node-set($rows)"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- TIP: to check the built RTF elements, uncomment and call testtbl.xsl 
  <xsl:copy-of select="exsl:node-set($colspec2)"/>
  <xsl:copy-of select="exsl:node-set($rows)"/>
  -->

  <xsl:variable name="t.rows" select="exsl:node-set($rows)"/>

  <xsl:text>\begingroup%&#10;</xsl:text>

  <!-- Set cellpadding, but only on columns -->
  <xsl:if test="@cellpadding">
    <xsl:text>\setlength{\tabcolsep}{</xsl:text>
    <xsl:choose>
    <xsl:when test="contains(@cellpadding, '%')">
      <xsl:value-of
          select="number(substring-before(@cellpadding,'%')) div 100"/>
      <xsl:text>\linewidth</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@cellpadding"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}%&#10;</xsl:text>
  </xsl:if>

  <xsl:text>\setlength{\tablewidth}{</xsl:text>
  <xsl:value-of select="$width"/>
  <xsl:text>}%&#10;</xsl:text>

  <xsl:if test="$tabletype != 'tabularx'">
    <xsl:call-template name="tbl.sizes">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$tabletype = 'tabularx'">
    <xsl:call-template name="tbl.valign.x">
      <xsl:with-param name="valign" select="@valign"/>
    </xsl:call-template>
  </xsl:if>
  
  <!-- Translate the table to latex -->

  <!-- Start the table declaration -->
  <xsl:call-template name="tbl.begin">
    <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="width" select="$width"/>
  </xsl:call-template>

  <!-- Need a top line? -->
  <xsl:if test="$frame = 'all' or $frame = 'top' or $frame = 'topbot'">
    <xsl:text>\hline</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>

  <!-- First, the head rows -->
  <xsl:variable name="headrows">
    <xsl:apply-templates select="$t.rows/*[@type='thead']"
                         mode="htmlTable">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
      <xsl:with-param name="context" select="'thead'"/>
      <xsl:with-param name="frame" select="$frame"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:apply-templates select="." mode="newtbl.endhead">
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="headrows" select="$headrows"/>
  </xsl:apply-templates>

  <!-- Then, the body rows -->
  <xsl:apply-templates select="$t.rows/*[@type!='thead']"
                       mode="htmlTable">
    <xsl:with-param name="colspec" select="exsl:node-set($colspec2)"/>
    <xsl:with-param name="context" select="'tbody'"/>
    <xsl:with-param name="frame" select="$frame"/>
  </xsl:apply-templates>

  <!-- Need a bottom line? -->
  <xsl:if test="$frame = 'all' or $frame = 'bottom' or $frame = 'topbot'">
    <xsl:text>\hline</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:text>\end{</xsl:text>
  <xsl:value-of select="$tabletype"/>
  <xsl:text>}\endgroup%&#10;</xsl:text>

</xsl:template>


<!-- Build the latex row from the <row> element -->
<xsl:template match="row" mode="htmlTable">
  <xsl:param name="colspec"/>
  <xsl:param name="context"/>
  <xsl:param name="frame"/>

  <xsl:apply-templates mode="newtbl">
    <xsl:with-param name="colspec" select="$colspec"/>
    <xsl:with-param name="context" select="$context"/>
    <xsl:with-param name="frame" select="$frame"/>
    <xsl:with-param name="rownum" select="@rownum"/>
  </xsl:apply-templates>

  <!-- End this row -->
  <xsl:text>\tabularnewline&#10;</xsl:text>
  
  <!-- Now process rowseps only if not the last row -->
  <xsl:if test="@rowsep=1">
    <xsl:choose>
    <xsl:when test="$newtbl.use.hhline='1'">
      <xsl:call-template name="hhline.build">
        <xsl:with-param name="entries" select="."/>
        <xsl:with-param name="rownum" select="@rownum"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="clines.build">
        <xsl:with-param name="entries" select="."/>
        <xsl:with-param name="rownum" select="@rownum"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>


<xsl:template match="thead" mode="htmlTable">
  <xsl:param name="colspec"/>
  <xsl:apply-templates select="tr[1]" mode="htmlTable">
    <xsl:with-param name="colspec" select="$colspec"/>
    <xsl:with-param name="rownum" select="1"/>
  </xsl:apply-templates>
</xsl:template>


<xsl:template match="tbody" mode="htmlTable">
  <xsl:param name="colspec"/>
  <xsl:apply-templates select="tr[1]" mode="htmlTable">
    <xsl:with-param name="colspec" select="$colspec"/>
    <xsl:with-param name="rownum"
                    select="count(preceding-sibling::*[self::tbody or
                                                       self::thead]/*)+1"/>
  </xsl:apply-templates>
</xsl:template>


<!-- Build an intermediate <row> element from a <tr> only if the row
     has the required 'context'
  -->
<xsl:template match="tr" mode="htmlTable">
  <xsl:param name="rownum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="oldentries"><nop/></xsl:param>
  <xsl:param name="context"/>

  <xsl:variable name="type">
    <xsl:choose>
    <xsl:when test="parent::thead">thead</xsl:when>
    <xsl:when test="parent::tbody">tbody</xsl:when>
    <xsl:when test="parent::tfoot">tfoot</xsl:when>
    <!-- 'tr' contain 'th' and is not in a t* group -->
    <xsl:when test="th">thead</xsl:when>
    <xsl:otherwise>tbody</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$context='' or $type=$context">
    <xsl:variable name="entries">
      <xsl:apply-templates select="(td|th)[1]" mode="htmlTable">
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colnum" select="1"/>
        <xsl:with-param name="entries" select="exsl:node-set($oldentries)"/>
      </xsl:apply-templates>
    </xsl:variable>

    <row type='{$type}' rownum='{$rownum}'>
      <xsl:call-template name="html.table.row.rules"/>
      <xsl:copy-of select="$entries"/>
    </row>

    <xsl:apply-templates select="following-sibling::tr[1]" mode="htmlTable">
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="rownum" select="$rownum + 1"/>
      <xsl:with-param name="oldentries" select="$entries"/>
      <xsl:with-param name="context" select="$context"/>
    </xsl:apply-templates>
  </xsl:if>

</xsl:template>

<!-- ==================================================================== -->

<!-- This template writes rowsep equivalant for html tables -->
<xsl:template name="html.table.row.rules">
  <xsl:variable name="border" 
                select="(ancestor::table |
                         ancestor::informaltable)[last()]/@border"/>
  <xsl:variable name="table.rules"
                select="(ancestor::table |
                         ancestor::informaltable)[last()]/@rules"/>

  <xsl:variable name="rules">
    <xsl:choose>
      <xsl:when test="$table.rules != ''">
        <xsl:value-of select="$table.rules"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) != 0">
        <xsl:value-of select="'all'"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) = 0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:when test="$default.table.rules != ''">
        <xsl:value-of select="$default.table.rules"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>

    <xsl:when test="$rules = 'none'">
      <xsl:attribute name="rowsep">0</xsl:attribute>
    </xsl:when>

    <xsl:when test="$rules = 'cols'">
      <xsl:attribute name="rowsep">0</xsl:attribute>
    </xsl:when>

    <!-- If not the last row, add border below -->
    <xsl:when test="$rules = 'rows' or $rules = 'all'">
      <xsl:variable name="rowborder">
        <xsl:choose>
          <!-- If in thead and tbody has rows, add border -->
          <xsl:when test="parent::thead/
                          following-sibling::tbody/tr">1</xsl:when>
          <!-- If in tbody and tfoot has rows, add border -->
          <xsl:when test="parent::tbody/
                          following-sibling::tfoot/tr">1</xsl:when>
          <!-- If in thead and table has body rows, add border -->
          <xsl:when test="parent::thead/
                          following-sibling::tr">1</xsl:when>
          <xsl:when test="parent::tbody/
                          preceding-sibling::tfoot/tr">1</xsl:when>
          <xsl:when test="preceding-sibling::tfoot/tr">1</xsl:when>
          <!-- If following rows, but not rowspan reaches last row -->
          <xsl:when test="following-sibling::tr and
             not(@rowspan = count(following-sibling::tr) + 1)">1</xsl:when>
          <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:if test="$rowborder = 1">
        <xsl:attribute name="rowsep">1</xsl:attribute>
      </xsl:if>
    </xsl:when>

    <!-- rules only between 'thead' and 'tbody', or 'tbody' and 'tfoot' -->
    <xsl:when test="$rules = 'groups' and parent::thead 
                    and not(following-sibling::tr)">
      <xsl:attribute name="rowsep">1</xsl:attribute>
    </xsl:when>
    <xsl:when test="$rules = 'groups' and parent::tfoot 
                    and not(preceding-sibling::tr)">
      <xsl:attribute name="rowsep">1</xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template name="html.table.column.rules">
  <xsl:param name="colnum"/>
  <xsl:param name="colmax"/>

  <xsl:variable name="border" 
                select="(ancestor-or-self::table |
                         ancestor-or-self::informaltable)[last()]/@border"/>
  <xsl:variable name="table.rules"
                select="(ancestor-or-self::table |
                         ancestor-or-self::informaltable)[last()]/@rules"/>

  <xsl:variable name="rules">
    <xsl:choose>
      <xsl:when test="$table.rules != ''">
        <xsl:value-of select="$table.rules"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) != 0">
        <xsl:value-of select="'all'"/>
      </xsl:when>
      <xsl:when test="$border != '' and number($border) = 0">
        <xsl:value-of select="'none'"/>
      </xsl:when>
      <xsl:when test="$default.table.rules != ''">
        <xsl:value-of select="$default.table.rules"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$rules = 'none'">
      <xsl:attribute name="colsep">0</xsl:attribute>
    </xsl:when>
    <xsl:when test="$rules = 'rows'">
      <xsl:attribute name="colsep">0</xsl:attribute>
    </xsl:when>
    <xsl:when test="$rules = 'groups'">
      <xsl:attribute name="colsep">0</xsl:attribute>
    </xsl:when>
    <!-- If not the last column, add border after -->
    <xsl:when test="($rules = 'cols' or $rules = 'all') and
                    ($colnum &lt; $colmax)">
      <xsl:attribute name="colsep">1</xsl:attribute>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="td|th" mode="htmlTable">
  <xsl:param name="rownum"/>
  <xsl:param name="colnum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="entries"/>

  <xsl:variable name="cols" select="count($colspec/*)"/>
 
  <xsl:if test="$colnum &lt;= $cols">

    <xsl:variable name="entry"
                  select="$entries/*[self::entry or self::entrytbl]
                                    [@colstart=$colnum and
                                     @rowend &gt;= $rownum]"/>

    <!-- Do we have an existing entry element from a previous row that -->
    <!-- should be copied into this row? -->
    <xsl:choose><xsl:when test="$entry">
      <!-- Just copy this entry then -->
      <xsl:copy-of select="$entry"/>

      <!-- Process the next column using this current entry -->
      <xsl:apply-templates mode="htmlTable" select=".">
        <xsl:with-param name="colnum" 
                        select="$entries/entry[@colstart=$colnum]/@colend + 1"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="entries" select="$entries"/>
      </xsl:apply-templates>
    </xsl:when><xsl:otherwise>

      <xsl:variable name="colstart" select="$colnum"/>

      <xsl:variable name="colend">
        <xsl:choose>
        <xsl:when test="@colspan">
          <xsl:value-of select="@colspan + $colnum -1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$colnum"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rowend">
        <xsl:choose>
        <xsl:when test="@rowspan">
          <xsl:value-of select="@rowspan + $rownum -1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$rownum"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="rowcolor" select="parent::tr/@bgcolor"/>

      <xsl:variable name="col" select="$colspec/colspec[@colnum=$colstart]"/>

      <xsl:variable name="bgcolor">
        <xsl:choose>
          <xsl:when test="$rowcolor != ''">
            <xsl:value-of select="$rowcolor"/>
          </xsl:when>
          <xsl:when test="$col/@bgcolor">
            <xsl:value-of select="$col/@bgcolor"/>
          </xsl:when>
          <xsl:when test="ancestor::*[@bgcolor]">
            <xsl:value-of select="ancestor::*[@bgcolor][last()]/@bgcolor"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="valign">
        <xsl:choose>
          <xsl:when test="../@valign">
            <xsl:value-of select="../@valign"/>
          </xsl:when>
          <xsl:when test="$col/@valign">
            <xsl:value-of select="$col/@valign"/>
          </xsl:when>
          <xsl:when test="ancestor::*[@valign]">
            <xsl:value-of select="ancestor::*[@valign][last()]/@valign"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="align">
        <xsl:choose>
          <xsl:when test="../@align">
            <xsl:value-of select="../@align"/>
          </xsl:when>
          <xsl:when test="$col/@align">
            <xsl:value-of select="$col/@align"/>
          </xsl:when>
          <xsl:when test="ancestor::*[@align]">
            <xsl:value-of select="ancestor::*[@align][last()]/@align"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <entry>
        <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
        <xsl:attribute name="colstart">
          <xsl:value-of select="$colstart"/>
        </xsl:attribute>
        <xsl:attribute name="colend">
          <xsl:value-of select="$colend"/>
        </xsl:attribute>
        <xsl:attribute name="rowstart">
          <xsl:value-of select="$rownum"/>
        </xsl:attribute>
        <xsl:attribute name="rowend">
          <xsl:value-of select="$rowend"/>
        </xsl:attribute>
        <xsl:if test="$rowend &gt; $rownum">
          <xsl:attribute name="morerows">
            <xsl:value-of select="$rowend - $rownum"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="$col/@colsep = 1">
          <xsl:attribute name="colsep">
            <xsl:value-of select="1"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@bgcolor) and $bgcolor != ''">
          <xsl:attribute name="bgcolor">
            <xsl:value-of select="$bgcolor"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@valign) and $valign != ''">
          <xsl:attribute name="valign">
            <xsl:value-of select="$valign"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:if test="not(@align) and $align != ''">
          <xsl:attribute name="align">
            <xsl:value-of select="$align"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:element name="output">
          <xsl:apply-templates select="." mode="output"/>
        </xsl:element>
      </entry>

      <xsl:choose>
      <xsl:when test="following-sibling::*[self::td or self::th]">

        <xsl:apply-templates
              select="following-sibling::*[self::td or self::th][1]"
              mode="htmlTable">
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="colnum" select="$colend + 1"/>
          <xsl:with-param name="entries" select="$entries"/>
        </xsl:apply-templates>

      </xsl:when>
      <xsl:when test="$colend &lt; $cols">
        <!-- Create more blank entries to pad the row -->
        <xsl:call-template name="tbl.blankentry">
          <xsl:with-param name="colnum" select="$colend + 1"/>
          <xsl:with-param name="colend" select="$cols"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="entries" select="$entries"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
        </xsl:call-template>

      </xsl:when>
      </xsl:choose>
    </xsl:otherwise></xsl:choose>
  </xsl:if>
</xsl:template>

<!-- Process the entry content, and remove spurious empty lines -->
<xsl:template match="td|th" mode="output">
  <xsl:call-template name="normalize-border">
    <xsl:with-param name="string">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="tr" mode="span">
  <xsl:param name="currow"/>
  <xsl:variable name="tr.pos" select="position()"/>
  <xsl:variable name="spantds" select="td[@rowspan][$tr.pos + @rowspan &gt; 
                                                    $currow]"/>
  <xsl:if test="$spantds">
    <span rownum="{$currow}" p="{$tr.pos}">
      <xsl:attribute name="value">
        <xsl:value-of
        select="sum($spantds/@colspan)+count($spantds[not(@colspan)])"/>
      </xsl:attribute>
    </span>
  </xsl:if>
</xsl:template>


<xsl:template name="widest-html-row">
  <xsl:param name="rows" select="''"/>
  <xsl:param name="count" select="0"/>
  <xsl:param name="currow" select="1"/>
  <xsl:variable name="row" select="$rows[position()=$currow]"/>
  <xsl:choose>
    <xsl:when test="not($row)">
      <xsl:value-of select="$count"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="count1" select="count($row/*[not(@colspan)])"/>
      <xsl:variable name="count2" select="sum($row/*/@colspan)"/>
      <xsl:variable name="countn" select="$count1 + $count2"/>

      <!-- retrieve the previous <td>s that contain a @rowspan
           that span over the current row -->
      <xsl:variable name="spantds">
        <xsl:apply-templates
             select="$rows[position() &lt; $currow]"
             mode="span">
          <xsl:with-param name="currow" select="$currow"/>
        </xsl:apply-templates>
      </xsl:variable>

      <!-- get the additional columns implied by the upward spanning <td> -->
      <xsl:variable name="addcols"
                    select="sum(exsl:node-set($spantds)/*/@value)"/>

      <!-- TIP: uncomment to debug the column count algorithm
      <foo> <xsl:copy-of select="$spantds"/> </foo>

      <xsl:message>
        <xsl:text>p=</xsl:text><xsl:value-of select="$currow"/>
        <xsl:text> c=</xsl:text><xsl:value-of select="$count"/>
        <xsl:text> s=</xsl:text><xsl:value-of select="$addcols"/>
      </xsl:message>
      -->

      <xsl:choose>
        <xsl:when test="$count &gt; ($countn + $addcols)">
          <xsl:call-template name="widest-html-row">
            <xsl:with-param name="rows" select="$rows"/>
            <xsl:with-param name="count" select="$count"/>
            <xsl:with-param name="currow" select="$currow + 1"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="widest-html-row">
            <xsl:with-param name="rows" select="$rows"/>
            <xsl:with-param name="count" select="$countn + $addcols"/>
            <xsl:with-param name="currow" select="$currow + 1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="build.colwidth">
  <xsl:param name="colspec"/>
  <xsl:param name="rows"/>

  <xsl:for-each select="$colspec/*">
    <xsl:variable name="pos" select="position()"/>
    <xsl:variable name="colentries"
                  select="$rows/row/entry[@colstart &lt;= $pos and
                                          @colend &gt;= $pos][@width]"/>

    <xsl:variable name="pct">
      <xsl:call-template name="max.percent">
        <xsl:with-param name="entries" select="$colentries"/>
        <xsl:with-param name="maxpct">
          <xsl:choose>
          <xsl:when test="substring(@width,string-length(@width))='%'">
            <xsl:value-of select="number(substring-before(@width, '%'))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="fixed">
      <xsl:call-template name="max.value">
        <xsl:with-param name="entries" select="$colentries"/>
        <xsl:with-param name="maxval">
          <xsl:choose>
          <xsl:when test="string(number(@width))!='NaN'">
            <xsl:value-of select="number(@width)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="star">
      <xsl:choose>
      <xsl:when test="substring(@width,string-length(@width))='*'">
        <xsl:value-of select="number(substring-before(@width, '*'))"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- '0*' is allowed and meaningfull, so use a negative number to
             signify a missing star -->
        <xsl:value-of select="-1"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!--
    <xsl:message>
      <xsl:value-of select="$pos"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="count($colentries)"/>
      <xsl:text> pct=</xsl:text><xsl:value-of select="$pct"/>
      <xsl:text> val=</xsl:text><xsl:value-of select="$fixed"/>
      <xsl:text> star=</xsl:text><xsl:value-of select="$star"/>
    </xsl:message>
    -->

    <xsl:copy>
      <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>

      <!-- Now, make precedences between the found width types -->
      <xsl:choose>
      <!-- the special form "0*" means to use the column's content width -->
      <xsl:when test="$star = 0">
        <xsl:attribute name="autowidth">1</xsl:attribute>
        <!-- set a star to reserve some default space for the column -->
        <xsl:attribute name="colwidth">
          <xsl:text>\newtblstarfactor</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="star">
          <xsl:value-of select="1"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$star &gt; 0">
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$star"/>
          <xsl:text>\newtblstarfactor</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="star">
          <xsl:value-of select="$star"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$pct &gt; 0">
        <xsl:variable name="width">
          <xsl:value-of select="$pct div 100"/>
          <xsl:text>\tablewidth</xsl:text>
        </xsl:variable>
        <xsl:attribute name="fixedwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:when test="$fixed &gt; 0">
        <!-- the width is expressed in 'px' bus is seen as 'pt' for tex -->
        <xsl:variable name="width">
          <xsl:value-of select="$fixed"/>
          <xsl:text>pt</xsl:text>
        </xsl:variable>
        <xsl:attribute name="fixedwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
        <xsl:attribute name="colwidth">
          <xsl:value-of select="$width"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <!-- no width specified: equivalent to a '*' -->
        <xsl:attribute name="colwidth">
          <xsl:text>\newtblstarfactor</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="star">1</xsl:attribute>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:for-each>
</xsl:template>


<!-- Find the maximum width expressed in percentage in column entries -->
<xsl:template name="max.percent">
  <xsl:param name="entries"/>
  <xsl:param name="maxpct" select="0"/>

  <xsl:choose>
  <xsl:when test="$entries">
    <xsl:variable name="width" select="$entries[1]/@width"/>

    <xsl:variable name="newpct">
      <xsl:choose>
      <xsl:when test="substring($width,string-length($width))='%'">
        <xsl:variable name="pct"
                      select="number(substring-before($width, '%'))"/>
        <xsl:choose>
        <xsl:when test="$pct &gt; $maxpct">
          <xsl:value-of select="$pct"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$maxpct"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$maxpct"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="max.percent">
      <xsl:with-param name="maxpct" select="$newpct"/>
      <xsl:with-param name="entries" select="$entries[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$maxpct"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Find the maximum width expressed in numbers in column entries -->
<xsl:template name="max.value">
  <xsl:param name="entries"/>
  <xsl:param name="maxval" select="0"/>

  <xsl:choose>
  <xsl:when test="$entries">
    <xsl:variable name="width" select="$entries[1]/@width"/>

    <xsl:variable name="newval">
      <xsl:choose>
      <xsl:when test="string(number($width))!='NaN'">
        <xsl:variable name="val" select="number($width)"/>
        <xsl:choose>
        <xsl:when test="$val &gt; $maxval">
          <xsl:value-of select="$val"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$maxval"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$maxval"/>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="max.value">
      <xsl:with-param name="maxval" select="$newval"/>
      <xsl:with-param name="entries" select="$entries[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$maxval"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Build empty default <colspec>s elements.
-->
<xsl:template name="make.colspec.default">
  <xsl:param name="colmax"/>
  <xsl:param name="colnum"/>

  <xsl:if test="$colnum &lt;= $colmax">
    <colspec>
      <xsl:attribute name="colnum">
        <xsl:value-of select="$colnum"/>
      </xsl:attribute>
      <xsl:call-template name="html.table.column.rules">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:call-template>
    </colspec>

    <xsl:call-template name="make.colspec.default">
      <xsl:with-param name="colnum" select="$colnum + 1"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<!-- Build the equivalent <colspec>s elements from <colgroup>s and <col>s
     and use default colspec for undefined <col>s in order to have a colspec
     per actual column.
-->

<xsl:template match="colgroup" mode="make.colspec">
  <xsl:param name="done" select="0"/>
  <xsl:param name="colnum"/>
  <xsl:param name="colmax"/>

  <xsl:choose>
  <xsl:when test="col">
    <!-- the spec are handled by <col>s -->
    <xsl:apply-templates select="col[1]" mode="make.colspec">
      <xsl:with-param name="colnum" select="$colnum"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>

    <xsl:variable name="span">
      <xsl:choose>
        <xsl:when test="@span">
          <xsl:value-of select="@span"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
    <xsl:when test="$done &lt; $span">
      <!-- bgcolor specified via a PI -->
      <xsl:variable name="bgcolor">
        <xsl:if test="processing-instruction('dblatex')">
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis"
                            select="processing-instruction('dblatex')"/>
            <xsl:with-param name="attribute" select="'bgcolor'"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:variable>

      <colspec>
        <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
        <xsl:attribute name="colnum">
          <xsl:value-of select="$colnum"/>
        </xsl:attribute>
        <xsl:if test="$bgcolor != ''">
          <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:call-template name="html.table.column.rules">
          <xsl:with-param name="colnum" select="$colnum"/>
          <xsl:with-param name="colmax" select="$colmax"/>
        </xsl:call-template>
      </colspec>

      <xsl:apply-templates select="." mode="make.colspec">
        <xsl:with-param name="done" select="$done + 1"/>
        <xsl:with-param name="colnum" select="$colnum + 1"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="following-sibling::*[self::colgroup or self::col]">
      <xsl:apply-templates select="following-sibling::*[self::colgroup or
                                                        self::col][1]"
                           mode="make.colspec">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:apply-templates>
    </xsl:when>
    <!-- build empty default <colspec>s for missing columns -->
    <xsl:when test="$colnum &lt;= $colmax">
      <xsl:call-template name="make.colspec.default">
        <xsl:with-param name="colmax" select="$colmax"/>
        <xsl:with-param name="colnum" select="$colnum"/>
      </xsl:call-template>
    </xsl:when>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="col" mode="make.colspec">
  <xsl:param name="done" select="0"/>
  <xsl:param name="colnum"/>
  <xsl:param name="colmax"/>

  <!--
  <xsl:message>
    <xsl:text>p=</xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="generate-id()"/>
    <xsl:text> r=</xsl:text>
    <xsl:value-of select="$colnum"/>
  </xsl:message>
  -->

  <xsl:variable name="span">
    <xsl:choose>
      <xsl:when test="@span">
        <xsl:value-of select="@span"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
  <!-- clone the same <colspec> span times -->
  <xsl:when test="$done &lt; $span">
    <!-- bgcolor specified via a PI or a colgroup parent PI -->
    <xsl:variable name="bgcolor">
      <xsl:choose>
      <xsl:when test="processing-instruction('dblatex')">
        <xsl:call-template name="pi-attribute">
          <xsl:with-param name="pis"
                          select="processing-instruction('dblatex')"/>
          <xsl:with-param name="attribute" select="'bgcolor'"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="../processing-instruction('dblatex')">
        <xsl:call-template name="pi-attribute">
          <xsl:with-param name="pis"
                          select="../processing-instruction('dblatex')"/>
          <xsl:with-param name="attribute" select="'bgcolor'"/>
        </xsl:call-template>
      </xsl:when>
      </xsl:choose>
    </xsl:variable>

    <colspec>
      <xsl:for-each select="parent::colgroup/@*"><xsl:copy/></xsl:for-each>
      <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
      <xsl:attribute name="colnum">
        <xsl:value-of select="$colnum"/>
      </xsl:attribute>
      <xsl:if test="$bgcolor != ''">
        <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="html.table.column.rules">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="colmax" select="$colmax"/>
      </xsl:call-template>
    </colspec>

    <xsl:apply-templates select="." mode="make.colspec">
      <xsl:with-param name="done" select="$done + 1"/>
      <xsl:with-param name="colnum" select="$colnum + 1"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <!-- process the next following <col*> -->
  <xsl:when test="following-sibling::*[self::colgroup or self::col]">
    <xsl:apply-templates
        select="following-sibling::*[self::col or self::colgroup][1]"
        mode="make.colspec">
      <xsl:with-param name="colnum" select="$colnum"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <!-- if <col> is a <colgroup> child, process the next <col*> at the parent
       level -->
  <xsl:when test="parent::colgroup[following-sibling::*[self::colgroup or
                                                        self::col]]">
    <xsl:apply-templates select="parent::colgroup/
                                 following-sibling::*[self::col or
                                                      self::colgroup][1]"
                         mode="make.colspec">
      <xsl:with-param name="colnum" select="$colnum"/>
      <xsl:with-param name="colmax" select="$colmax"/>
    </xsl:apply-templates>
  </xsl:when>
  <!-- build empty default <colspec>s for missing columns -->
  <xsl:when test="$colnum &lt;= $colmax">
    <xsl:call-template name="make.colspec.default">
      <xsl:with-param name="colmax" select="$colmax"/>
      <xsl:with-param name="colnum" select="$colnum"/>
    </xsl:call-template>
  </xsl:when>
  </xsl:choose>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="index.tocdepth">5</xsl:param>
<xsl:param name="index.numbered">1</xsl:param>


<xsl:template name="index.print">
  <xsl:param name="node" select="."/>
  <!-- actual sorting entry -->
  <xsl:if test="$node/@sortas">
    <xsl:call-template name="scape.index">
      <xsl:with-param name="string" select="$node/@sortas"/>
    </xsl:call-template>
    <xsl:text>@{</xsl:text>
  </xsl:if>
  <!-- entry display -->
  <xsl:call-template name="scape.index">
    <xsl:with-param name="string" select="$node"/>
  </xsl:call-template>
  <xsl:if test="$node/@sortas">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="indexterm">
  <xsl:param name="close" select="''"/>
  <xsl:text>\index{</xsl:text>
  <xsl:call-template name="index.print">
    <xsl:with-param name="node" select="./primary"/>
  </xsl:call-template>
  <xsl:if test="./secondary">
    <xsl:text>!</xsl:text>
    <xsl:call-template name="index.print">
      <xsl:with-param name="node" select="./secondary"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:if test="./tertiary">
    <xsl:text>!</xsl:text>
    <xsl:call-template name="index.print">
      <xsl:with-param name="node" select="./tertiary"/>
    </xsl:call-template>
  </xsl:if>
  <xsl:if test="./see">
    <xsl:text>|see{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="./see"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:if test="./seealso">
    <xsl:text>|see{</xsl:text>
    <xsl:call-template name="normalize-scape">
      <xsl:with-param name="string" select="./seealso"/>
    </xsl:call-template>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <!-- page range opening/close -->
  <xsl:choose>
  <xsl:when test="$close!=''">
    <xsl:value-of select="$close"/>
  </xsl:when>
  <xsl:when test="@class='startofrange'">
    <!-- sanity check: only open range if related close is found -->
    <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
    <xsl:choose>
    <xsl:when test="//indexterm[@class='endofrange' and @startref=$id]">
      <xsl:text>|(</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
      <xsl:text>Error: cannot find indexterm[@startref='</xsl:text>
      <xsl:value-of select="$id"/>
      <xsl:text>'] end of range</xsl:text>
      </xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  </xsl:choose>
  <xsl:text>}</xsl:text>
  <!-- don't want to be stuck to the next para -->
  <xsl:if test="following-sibling::*[1][self::para or self::formalpara or
                                        self::simpara]">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- simply duplicate the referenced starting range indexterm, and close the
     range -->

<xsl:template match="indexterm[@class='endofrange']">
  <xsl:variable name="id" select="@startref"/>
  <xsl:apply-templates select="//indexterm[@class='startofrange' and 
                                           (@id=$id or @xml:id=$id)]">
    <xsl:with-param name="close" select="'|)'"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="primary|secondary|tertiary|see|seealso"/>
<xsl:template match="indexentry"/>
<xsl:template match="primaryie|secondaryie|tertiaryie|seeie|seealsoie"/>


<!-- in a programlisting -->
<xsl:template match="indexterm" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.embed">
    <xsl:with-param name="co-taging" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>


<!-- ignore index entries in TOC -->
<xsl:template match="indexterm" mode="toc.skip"/>

 
<!-- todo -->
<xsl:template match="index|setindex">
<!--
  <xsl:call-template name="label.id"/>
  <xsl:text>\printindex&#10;</xsl:text>
  -->
</xsl:template>


<xsl:template name="printindex">
  <xsl:if test="number($index.numbered) = 0">
    <xsl:text>\setcounter{secnumdepth}{-1}&#10;</xsl:text>
    <xsl:call-template name="set-tocdepth">
      <xsl:with-param name="depth" select="number($index.tocdepth) - 1"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:text>\printindex&#10;</xsl:text>

  <xsl:if test="number($index.numbered) = 0">
    <xsl:call-template name="section.unnumbered.end">
      <xsl:with-param name="tocdepth" select="number($index.tocdepth)"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="index/title"></xsl:template>
<xsl:template match="index/subtitle"></xsl:template>
<xsl:template match="index/titleabbrev"></xsl:template>

<xsl:template match="indexdiv">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="indexdiv/title">
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select=".."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="itermset">
  <xsl:apply-templates/>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="filename.as.url">1</xsl:param>
<xsl:param name="hyphenation.format">monoseq,sansseq</xsl:param>
<xsl:param name="hyphenation.setup"/>
<xsl:param name="monoseq.small">0</xsl:param>


<xsl:template name="inline.setup">
  <xsl:if test="$hyphenation.format='nohyphen' or
                contains($hyphenation.setup,'sloppy')">
    <xsl:text>\sloppy&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- Use the dblatex hyphenation only if enabled for this format.
     If no format is specified, the check is done on the calling
     element name
-->
<xsl:template name="inline.hyphenate">
  <xsl:param name="string"/>
  <xsl:param name="format" select="local-name()"/>
  <xsl:choose>
  <xsl:when test="contains($hyphenation.format, $format)">
    <xsl:call-template name="hyphen-encode">
      <xsl:with-param name="string" select="$string"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:copy-of select="$string"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.boldseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\textbf{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.italicseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\emph{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- Cela prend plus de temps que la version qui suit... Bizarre.
<xsl:template name="inline.monoseq">
  <xsl:text>\texttt{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:text>\texttt{\emph{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}}</xsl:text>
</xsl:template>
-->

<xsl:template name="inline.sansseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\textsf{</xsl:text>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'sansseq'"/>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline.boldmonoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>{\ttfamily\bfseries{</xsl:text>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'boldmonoseq'"/>
  </xsl:call-template>
  <xsl:text>}}</xsl:text>
</xsl:template>

<xsl:template name="inline.superscriptseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>$^{\text{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}}$</xsl:text>
</xsl:template>

<xsl:template name="inline.subscriptseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>$_{\text{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}}$</xsl:text>
</xsl:template>

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\texttt{</xsl:text>
  <xsl:if test="not($monoseq.small = '0')">
    <xsl:text>\small{</xsl:text>
  </xsl:if>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'monoseq'"/>
  </xsl:call-template>
  <xsl:if test="not($monoseq.small = '0')">
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template name="inline.italicmonoseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\texttt{\emph{\small{</xsl:text>
  <xsl:call-template name="inline.hyphenate">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="format" select="'monoseq'"/>
  </xsl:call-template>
  <xsl:text>}}}</xsl:text>
</xsl:template>

<xsl:template name="inline.underlineseq">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>
  <xsl:text>\underline{</xsl:text>
  <xsl:copy-of select="$content"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- ==================================================================== -->
<!-- some special cases -->

<xsl:template match="author|editor|othercredit|personname">
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="authorinitials">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="authorgroup">
  <xsl:variable name="string">
    <xsl:call-template name="person.name.list"/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($string)"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="accel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="action">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="application">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="classname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="code">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="exceptionname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="interfacename">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="methodname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="command">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="computeroutput">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="constant">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="database">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="errorcode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="errorname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="errortype">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="envar">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="filename">
  <xsl:choose>
  <!-- \Url cannot stand in a section heading -->
  <xsl:when test="$filename.as.url='1' and
                  not(ancestor::title or ancestor::refentrytitle)">
    <!-- Guess hyperref is always used now. -->
    <xsl:apply-templates mode="nolinkurl"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="inline.monoseq"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- By default propagate the mode -->
<xsl:template match="*" mode="nolinkurl">
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:apply-templates mode="nolinkurl">
    <xsl:with-param name="command" select="$command"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="text()" mode="nolinkurl">
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:call-template name="nolinkurl-output">
    <xsl:with-param name="url" select="."/>
    <xsl:with-param name="command" select="$command"/>
  </xsl:call-template>
</xsl:template>

<!-- Come back to inline.monoseq for templates where nolinkurl cannot apply -->
<xsl:template match="subscript|superscript" mode="nolinkurl">
  <xsl:call-template name="inline.monoseq">
    <xsl:with-param name="content">
      <xsl:apply-templates select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="replaceable" mode="nolinkurl">
  <xsl:param name="command" select="'\nolinkurl'"/>
  <xsl:call-template name="inline.italicmonoseq">
    <xsl:with-param name="content">
      <xsl:apply-templates mode="nolinkurl">
        <xsl:with-param name="command" select="$command"/>
      </xsl:apply-templates>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="indexterm" mode="nolinkurl">
  <xsl:apply-templates select="."/>
</xsl:template>


<xsl:template match="function">
  <xsl:choose>
    <xsl:when test="$function.parens != '0'
                    or parameter or function or replaceable"> 
      <xsl:variable name="nodes" select="text()|*"/>
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:apply-templates select="$nodes[1]"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="$nodes[position()>1]"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.monoseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="function/parameter" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="function/replaceable" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="replaceable" priority="1">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="guibutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guiicon">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guilabel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guimenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guimenuitem">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="guisubmenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="hardware">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="interface">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="interfacedefinition">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="keycap">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="keycode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="keysym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="literal">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="medialabel">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="mousebutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="option">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="package">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="parameter">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="property">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="prompt">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="returnvalue">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="shortcut">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="structfield">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="structname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="symbol">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="systemitem">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="token">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="type">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="uri">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="userinput">
  <xsl:call-template name="inline.boldmonoseq"/>
</xsl:template>

<xsl:template match="abbrev">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="acronym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="citerefentry">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="citetitle">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="emphasis">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="emphasis[@role='bold' or @role='strong']">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="emphasis[@role='underline']">
  <xsl:call-template name="inline.underlineseq"/>
</xsl:template>

<xsl:template match="errortext">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="firstname|surname|honorific|othername|lineage">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="foreignphrase">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="markup">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="phrase">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="quote">
  <xsl:variable name="depth">
    <xsl:call-template name="dot.count">
      <xsl:with-param name="string">
        <xsl:number level="multiple"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$depth mod 2 = 0">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.nestedstartquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.nestedendquote"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="varname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="wordasword">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="lineannotation">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="superscript">
  <xsl:call-template name="inline.superscriptseq"/>
</xsl:template>

<xsl:template match="subscript">
  <xsl:call-template name="inline.subscriptseq"/>
</xsl:template>

<xsl:template match="trademark">
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat">trademark</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="trademark[@class='copyright' or
                               @class='registered']">
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat" select="@class"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="trademark[@class='service']">
  <xsl:call-template name="inline.charseq"/>
  <xsl:call-template name="inline.superscriptseq">
    <xsl:with-param name="content" select="'SM'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="firstterm|glossterm">
  <xsl:variable name="termtext">
    <xsl:call-template name="inline.italicseq"/>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="@linkend">
    <xsl:call-template name="hyperlink.markup">
      <xsl:with-param name="linkend" select="@linkend"/>
      <xsl:with-param name="text" select="$termtext"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:when test="$glossterm.auto.link != 0">
    <xsl:variable name="term">
      <xsl:choose>
        <xsl:when test="@baseform">
          <xsl:value-of select="normalize-space(@baseform)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="glossentry"
       select="(//glossentry[normalize-space(glossterm)=$term or
                             normalize-space(glossterm/@baseform)=$term][@id])[1]"/>
    <xsl:choose>
    <xsl:when test="$glossentry">
      <xsl:call-template name="hyperlink.markup">
        <xsl:with-param name="linkend" select="$glossentry/@id"/>
        <xsl:with-param name="text" select="$termtext"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Error: no ID glossentry for glossterm: </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>.</xsl:text>
      </xsl:message>
      <xsl:value-of select="$termtext"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$termtext"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"></xsl:when>
      <xsl:otherwise>-</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="./*">
    <xsl:if test="position()>1"><xsl:value-of select="$joinchar"/></xsl:if>
    <xsl:apply-templates/>
  </xsl:for-each>
</xsl:template>

<xsl:strip-space elements="menuchoice shortcut"/>

<xsl:template match="menuchoice">
  <xsl:variable name="shortcut" select="./shortcut"/>
  <!-- print the menuchoice tree -->
  <xsl:for-each select="*[not(self::shortcut)]">
    <xsl:if test="position() > 1">
      <xsl:choose>
        <xsl:when test="self::guimenuitem or self::guisubmenu">
          <xsl:text>\hspace{2pt}\ensuremath{\to{}}</xsl:text>
        </xsl:when>
        <xsl:otherwise>+</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
  <!-- now, the shortcut if any -->
  <xsl:if test="$shortcut">
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="$shortcut"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="jobtitle|corpauthor|orgname|orgdiv">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="optional">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:call-template name="inline.charseq"/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="comment|remark">
  <xsl:if test="$show.comments != 0">
    <xsl:text>\comment</xsl:text>
    <xsl:if test="@role">
      <xsl:text>[title={</xsl:text>
      <xsl:value-of select="@role"/>
      <xsl:text>}]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:variable name="string">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($string)"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="productname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="productnumber">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="pob|street|city|state|postcode|country|phone|fax|otheraddr">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->
<!-- inline elements in program listings -->

<xsl:template name="verbatim.boldseq">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>
  <xsl:param name="style" select="'b'"/>
  <xsl:param name="content"/>

  <xsl:call-template name="verbatim.format">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
    <xsl:with-param name="style" select="'b'"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="userinput" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.boldseq">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="emphasis" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:variable name="style">
    <xsl:choose>
    <xsl:when test="@role='bold' or @role='strong'">
      <xsl:value-of select="'b'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'i'"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="verbatim.format">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
    <xsl:with-param name="style" select="$style"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="replaceable" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:call-template name="verbatim.format">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
    <xsl:with-param name="style" select="'i'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="optional" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;:'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates mode="latex.programlisting">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:apply-templates>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<!-- keywords are not displayed but become index entries -->

<xsl:template match="keywordset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="subjectset"/>

<xsl:template match="keyword">
  <xsl:text>\index{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Title parameters -->
<xsl:param name="titleabbrev.in.toc">1</xsl:param>


<xsl:template name="mapheading">
  <xsl:call-template name="makeheading">
    <xsl:with-param name="command">
      <xsl:call-template name="sec-map">
        <xsl:with-param name="keyword" select="local-name(.)"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="makeheading">
  <xsl:param name="num" select="'1'"/>
  <xsl:param name="allnum" select="'0'"/>
  <xsl:param name="level"/>
  <xsl:param name="name"/>
  <xsl:param name="command"/>
  <!-- Title must be a node -->
  <xsl:param name="title" select="(title|info/title)[1]"/>

  <xsl:variable name="rcommand">
    <xsl:choose>
    <xsl:when test="$command=''">
      <xsl:call-template name="map.sect.level">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="allnum" select="$allnum"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$command"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Force section number counter if required. No consistency checked -->
  <xsl:if test="@label and @label!=''">
    <xsl:choose>
    <xsl:when test="string(number(@label))='NaN' or floor(@label)!=@label">
      <xsl:message>
      <xsl:text>Warning: only an integer in @label can be processed: '</xsl:text>
      <xsl:value-of select="@label"/>
      <xsl:text>'</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <!-- The counter name is the same than the command -->
      <xsl:text>\setcounter{</xsl:text>
      <xsl:value-of select="substring-after($rcommand, '\')"/>
      <xsl:text>}{</xsl:text>
      <xsl:value-of select="number(@label)-1"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:value-of select="$rcommand"/>
  <xsl:apply-templates select="$title" mode="format.title">
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:apply-templates>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates select="$title" mode="foottext"/>
</xsl:template>

<!-- Make a section heading from a title string. It gives something like:
     \section{title string}\label{label.id}
     -->
<xsl:template name="maketitle">
  <xsl:param name="num" select="'1'"/>
  <xsl:param name="allnum" select="'0'"/>
  <xsl:param name="level"/>
  <xsl:param name="name"/>
  <xsl:param name="command"/>
  <xsl:param name="title"/>

  <xsl:variable name="rcommand">
    <xsl:choose>
    <xsl:when test="$command=''">
      <xsl:call-template name="map.sect.level">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="level" select="$level"/>
        <xsl:with-param name="num" select="$num"/>
        <xsl:with-param name="allnum" select="$allnum"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$command"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$rcommand"/>
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$title"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id"/>
</xsl:template>


<xsl:template name="label.id">
  <xsl:param name="object" select="."/>
  <xsl:param name="string" select="''"/>
  <xsl:param name="inline" select="0"/>
  <!-- object.id cannot be used since it always provides an id -->
  <xsl:variable name="id">
    <xsl:choose>
      <xsl:when test="$object/@id">
        <xsl:value-of select="$object/@id"/>
      </xsl:when>
      <xsl:when test="$object/@xml:id">
        <xsl:value-of select="$object/@xml:id"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$string"/>
  <xsl:if test="$id!=''">
    <xsl:text>\label{</xsl:text>
    <xsl:value-of select="normalize-space($id)"/>
    <xsl:text>}</xsl:text>
    <!-- beware, hyperlabel is docbook specific -->
    <xsl:text>\hyperlabel{</xsl:text>
    <xsl:value-of select="normalize-space($id)"/>
    <xsl:text>}</xsl:text>
    <xsl:if test="$inline=0">
      <xsl:text>%&#10;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Make the title part of a section heading from a title node.
     It gives something like:
     [{string in TOC}]{heading string}
     -->
<xsl:template match="title|table/caption" mode="format.title">
  <xsl:param name="allnum" select="'0'"/>
  <xsl:apply-templates select="." mode="toc">
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:apply-templates>
  <xsl:text>{</xsl:text> 
  <!-- should be normalized, but it is done by post processing -->
  <xsl:apply-templates select="." mode="content"/>
  <xsl:text>}&#10;</xsl:text> 
</xsl:template>

<!-- optionally the TOC entry text can be different from the actual
     title if the title contains unsupported things like hot links
     or graphics, or if some titleabbrev is provided and should be used
     for the TOC.
 -->
<xsl:template match="title|table/caption" mode="toc">
  <xsl:param name="allnum" select="0"/>
  <xsl:param name="pre" select="'[{'"/>
  <xsl:param name="post" select="'}]'"/>

  <!-- Use the titleabbrev for the TOC (if possible) -->
  <xsl:variable name="abbrev">
    <xsl:if test="$titleabbrev.in.toc='1'">
      <xsl:apply-templates
        mode="toc.skip"
        select="(../titleabbrev
                |../sect1info/titleabbrev
                |../sect2info/titleabbrev
                |../sect3info/titleabbrev
                |../sect4info/titleabbrev
                |../sect5info/titleabbrev
                |../sectioninfo/titleabbrev
                |../chapterinfo/titleabbrev
                |../partinfo/titleabbrev
                |../refsect1info/titleabbrev
                |../refsect2info/titleabbrev
                |../refsect3info/titleabbrev
                |../refsectioninfo/titleabbrev
                |../referenceinfo/titleabbrev
                )[1]"/>
    </xsl:if>
  </xsl:variable>

  <!-- Nothing in the TOC for unnumbered sections -->
  <xsl:variable name="unnumbered"
                select="parent::refsect1
                       |parent::refsect2
                       |parent::refsect3
                       |parent::refsection
                       |ancestor::preface
                       |parent::colophon
                       |parent::dedication"/>

  <xsl:if test="($allnum=1 or not($unnumbered)) and
                ($abbrev!='' or
                (descendant::footnote|
                 descendant::xref|
                 descendant::link|
                 descendant::ulink|
                 descendant::anchor|
                 descendant::glossterm[@linkend]|
                 descendant::inlinegraphic|
                 descendant::inlinemediaobject) or
                 (descendant::glossterm and $glossterm.auto.link != 0))">
    <xsl:value-of select="$pre"/> 
    <xsl:choose>
    <xsl:when test="$abbrev!=''">
      <!-- The TOC contains the titleabbrev content -->
      <xsl:value-of select="normalize-space($abbrev)"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- The TOC contains the toc-safe title -->
      <xsl:variable name="s">
        <xsl:apply-templates mode="toc.skip"/>
      </xsl:variable>
      <xsl:value-of select="normalize-space($s)"/>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$post"/> 
  </xsl:if>
</xsl:template>

<xsl:template match="title|table/caption" mode="content">
  <xsl:apply-templates/>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<!-- FO like parameters. Used only with XeTeX backend -->
<xsl:param name="body.font.family">DejaVu Serif</xsl:param>
<xsl:param name="sans.font.family">DejaVu Sans</xsl:param>
<xsl:param name="monospace.font.family">DejaVu Sans Mono</xsl:param>


<xsl:param name="latex.encoding">latin1</xsl:param>
<xsl:param name="latex.engine.options"/>
<xsl:param name="korean.package">CJK</xsl:param>
<xsl:param name="cjk.font">cyberbit</xsl:param>
<xsl:param name="xetex.font">
  <xsl:value-of select="concat('\setmainfont{',$body.font.family,'}&#10;')"/>
  <xsl:value-of select="concat('\setsansfont{',$sans.font.family,'}&#10;')"/>
  <xsl:value-of
       select="concat('\setmonofont{',$monospace.font.family,'}&#10;')"/>
</xsl:param>


<xsl:template name="babel.setup">
  <!-- babel use? -->
  <xsl:if test="$latex.babel.use='1'">
    <xsl:variable name="babel">
      <xsl:call-template name="babel.language">
        <xsl:with-param name="lang">
          <xsl:call-template name="l10n.language">
            <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
            <xsl:with-param name="xref-context" select="true()"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$babel!=''">
      <xsl:text>\usepackage[</xsl:text>
      <xsl:value-of select="$babel"/>
      <xsl:text>]{babel}&#10;</xsl:text>
      <xsl:text>\usepackage{cmap}&#10;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="lang.setup">
  <!-- first find the language actually set -->
  <xsl:variable name="lang">
    <xsl:call-template name="l10n.language">
      <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
      <xsl:with-param name="xref-context" select="true()"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- locale setup for docbook -->
  <xsl:if test="$lang!='' and $lang!='en'">
    <xsl:text>\setuplocale{</xsl:text>
    <xsl:value-of select="substring($lang, 1, 2)"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>

  <!-- some extra babel setup -->
  <xsl:if test="$latex.babel.use='1'">
    <xsl:variable name="babel">
      <xsl:call-template name="babel.language">
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="$babel!=''">
      <xsl:text>\setupbabel{</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>}&#10;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>


<xsl:template name="babel.language">
  <xsl:param name="lang" select="'en'"/>

  <!-- select the corresponding babel language -->
  <xsl:choose>
    <xsl:when test="$latex.babel.language!=''">
      <xsl:value-of select="$latex.babel.language"/>
    </xsl:when>
    <xsl:when test="starts-with($lang,'af')">afrikaans</xsl:when>
    <xsl:when test="starts-with($lang,'br')">breton</xsl:when>
    <xsl:when test="starts-with($lang,'ca')">catalan</xsl:when>
    <xsl:when test="starts-with($lang,'cs')">czech</xsl:when>
    <xsl:when test="starts-with($lang,'cy')">welsh</xsl:when>
    <xsl:when test="starts-with($lang,'da')">danish</xsl:when>
    <xsl:when test="starts-with($lang,'de')">ngerman</xsl:when>
    <xsl:when test="starts-with($lang,'el')">greek</xsl:when>
    <xsl:when test="starts-with($lang,'en')">
      <xsl:choose>
        <xsl:when test="starts-with($lang,'en-CA')">canadian</xsl:when>
        <xsl:when test="starts-with($lang,'en-GB')">british</xsl:when>
        <xsl:when test="starts-with($lang,'en-US')">USenglish</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="starts-with($lang,'eo')">esperanto</xsl:when>
    <xsl:when test="starts-with($lang,'es')">spanish</xsl:when>
    <xsl:when test="starts-with($lang,'et')">estonian</xsl:when>
    <xsl:when test="starts-with($lang,'fi')">finnish</xsl:when>
    <xsl:when test="starts-with($lang,'fr')">french</xsl:when>
    <xsl:when test="starts-with($lang,'ga')">irish</xsl:when>
    <xsl:when test="starts-with($lang,'gd')">scottish</xsl:when>
    <xsl:when test="starts-with($lang,'gl')">galician</xsl:when>
    <xsl:when test="starts-with($lang,'he')">hebrew</xsl:when>
    <xsl:when test="starts-with($lang,'hr')">croatian</xsl:when>
    <xsl:when test="starts-with($lang,'hu')">hungarian</xsl:when>
    <xsl:when test="starts-with($lang,'id')">bahasa</xsl:when>
    <xsl:when test="starts-with($lang,'it')">italian</xsl:when>
    <xsl:when test="starts-with($lang,'nb')">norsk</xsl:when>
    <xsl:when test="starts-with($lang,'nl')">dutch</xsl:when>
    <xsl:when test="starts-with($lang,'nn')">norsk</xsl:when>
    <xsl:when test="starts-with($lang,'pl')">polish</xsl:when>
    <xsl:when test="starts-with($lang,'pt')">
      <xsl:choose>
        <xsl:when test="starts-with($lang,'pt_br')">brazil</xsl:when>
        <xsl:otherwise>portuges</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="starts-with($lang,'ro')">romanian</xsl:when>
    <xsl:when test="starts-with($lang,'ru')">russian</xsl:when>
    <xsl:when test="starts-with($lang,'sk')">slovak</xsl:when>
    <xsl:when test="starts-with($lang,'sl')">slovene</xsl:when>
    <xsl:when test="starts-with($lang,'sv')">swedish</xsl:when>
    <xsl:when test="starts-with($lang,'tr')">turkish</xsl:when>
    <xsl:when test="starts-with($lang,'uk')">ukrainian</xsl:when>
  </xsl:choose>
</xsl:template>


<xsl:template name="lang.document.begin">
  <xsl:param name="lang"/>
  <xsl:if test="starts-with($lang,'zh') or
                starts-with($lang,'ja') or
                (starts-with($lang,'ko') and $korean.package='CJK')">
    <xsl:text>\begin{CJK}{UTF8}{</xsl:text>
    <xsl:value-of select="$cjk.font"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="lang.document.end">
  <xsl:param name="lang"/>
  <xsl:if test="starts-with($lang,'zh') or
                starts-with($lang,'ja') or
                (starts-with($lang,'ko') and $korean.package='CJK')">
    <xsl:text>\clearpage&#10;</xsl:text>
    <xsl:text>\end{CJK}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- #############
     # Encodings #
     ############# -->
<!-- Encodings are put with langs since the locale has impact on the encoding
     to use -->

<xsl:template name="lang-in-unicode">
  <xsl:param name="lang"/>
  <xsl:choose>
    <xsl:when test="starts-with($lang,'zh')">1</xsl:when>
    <xsl:when test="starts-with($lang,'ko')">1</xsl:when>
    <xsl:when test="starts-with($lang,'ja')">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This template should not be there, but currently only encoding needs it -->
<xsl:template name="py.params.set">
  <xsl:variable name="lang">
    <xsl:call-template name="l10n.language">
      <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
      <xsl:with-param name="xref-context" select="true()"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="use-unicode">
    <xsl:call-template name="lang-in-unicode">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:text>%%&lt;params&gt;&#10;</xsl:text>
  <xsl:text>%% document.language </xsl:text>
  <xsl:value-of select="$lang"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:if test="$use-unicode='1' or $latex.encoding='utf8'">
    <xsl:text>%% latex.encoding utf8&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$latex.engine.options != ''">
    <xsl:text>%% latex.engine.options </xsl:text>
    <xsl:value-of select="$latex.engine.options"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$latex.index.tool != ''">
    <xsl:text>%% latex.index.tool </xsl:text>
    <xsl:value-of select="$latex.index.tool"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$latex.index.language != ''">
    <xsl:text>%% latex.index.language </xsl:text>
    <xsl:value-of select="$latex.index.language"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>%%&lt;/params&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template name="encode.before.style">
  <xsl:param name="lang"/>
  <xsl:variable name="use-unicode">
    <xsl:call-template name="lang-in-unicode">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- XeTeX preamble to handle fonts -->
  <xsl:text>\IfFileExists{ifxetex.sty}{%
    \usepackage{ifxetex}%
  }{%
    \newif\ifxetex
    \xetexfalse
  }
  </xsl:text>
  <xsl:text>\ifxetex&#10;</xsl:text>
  <xsl:text>\usepackage{fontspec}&#10;</xsl:text>
  <xsl:text>\usepackage{xltxtra}&#10;</xsl:text>
  <!-- To support TeX ligatures -->
  <xsl:text>\defaultfontfeatures{Mapping=tex-text}&#10;</xsl:text>
  <xsl:value-of select="$xetex.font"/>
  <xsl:text>\else&#10;</xsl:text>

  <!-- Standard latex font setup -->
  <xsl:choose>
  <xsl:when test="$use-unicode='1'">
    <!-- Required to have listings in such environment -->
    <xsl:text>\usepackage{ucs}&#10;</xsl:text>
    <xsl:text>\def\hyperparamadd{unicode=true}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$latex.encoding='latin1'">
    <xsl:text>\usepackage[T1]{fontenc}&#10;</xsl:text>
    <xsl:text>\usepackage[latin1]{inputenc}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$latex.encoding='utf8'">
    <xsl:text>\usepackage[T2A,T2D,T1]{fontenc}&#10;</xsl:text>
    <xsl:text>\usepackage{ucs}&#10;</xsl:text>
    <xsl:text>\usepackage[utf8x]{inputenc}&#10;</xsl:text>
    <xsl:text>\def\hyperparamadd{unicode=true}&#10;</xsl:text>
  </xsl:when>
  </xsl:choose>

  <xsl:text>\fi&#10;</xsl:text>
</xsl:template>

<xsl:template name="encode.after.style">
  <xsl:param name="lang"/>
  <xsl:variable name="use-unicode">
    <xsl:call-template name="lang-in-unicode">
      <xsl:with-param name="lang" select="$lang"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
  <xsl:when test="$use-unicode='1' or $latex.encoding='utf8'">
    <xsl:text>\lstset{inputencoding=utf8x, extendedchars=true}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$latex.encoding='latin1' and $latex.unicode.use!='0'">
    <!-- Use the UTF-8 Passivetex support if required -->
    <xsl:text>\usepackage{unicode}&#10;</xsl:text>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- Font setup, used by annotation files embedded in main files -->
<xsl:template name="font.setup">
  <xsl:param name="lang"/>
  <xsl:call-template name="encode.before.style">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:call-template name="encode.after.style">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
</xsl:template>


<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:import href="docbook.xsl"/>
<xsl:import href="mathml2/mathml.xsl"/>


<xsl:template name="apply-templates">
  <xsl:apply-imports/>
  <xsl:apply-templates select="." mode="annotation.links"/>
</xsl:template>

<xsl:template match="*[not(self::indexterm or
                           self::calloutlist or
                           self::programlisting or
                           self::screen or
                           self::book or
                           self::article)]">
  <xsl:call-template name="apply-templates"/>
</xsl:template>

<xsl:template match="*[@revisionflag]">
  <xsl:choose>
    <xsl:when test="local-name(.) = 'para'
                    or local-name(.) = 'simpara'
                    or local-name(.) = 'formalpara'
                    or local-name(.) = 'section'
                    or local-name(.) = 'sect1'
                    or local-name(.) = 'sect2'
                    or local-name(.) = 'sect3'
                    or local-name(.) = 'sect4'
                    or local-name(.) = 'sect5'
                    or local-name(.) = 'chapter'
                    or local-name(.) = 'preface'
                    or local-name(.) = 'itemizedlist'
                    or local-name(.) = 'varlistentry'
                    or local-name(.) = 'glossary'
                    or local-name(.) = 'bibliography'
                    or local-name(.) = 'appendix'">
      <xsl:text>&#10;\cbstart{}</xsl:text>
      <xsl:call-template name="apply-templates"/>
      <xsl:text>\cbend{}&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="local-name(.) = 'phrase'
                    or local-name(.) = 'ulink'
                    or local-name(.) = 'filename'
                    or local-name(.) = 'literal'
                    or local-name(.) = 'member'
                    or local-name(.) = 'glossterm'
                    or local-name(.) = 'sgmltag'
                    or local-name(.) = 'quote'
                    or local-name(.) = 'emphasis'
                    or local-name(.) = 'command'
                    or local-name(.) = 'xref'">
      <xsl:text>\cbstart{}</xsl:text>
      <xsl:call-template name="apply-templates"/>
      <xsl:text>\cbend{}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Revisionflag on unexpected element: </xsl:text>
        <xsl:value-of select="local-name(.)"/>
        <xsl:text> (Assuming block)</xsl:text>
      </xsl:message>
      <xsl:text>&#10;\cbstart{}</xsl:text>
      <xsl:call-template name="apply-templates"/>
      <xsl:text>\cbend{}&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version='1.0'>

<!--############################################################################
    Stylesheet XML DocBook -> LaTeX 
    ############################################################################ -->

<!-- Import common definitions, overloaded by fastests templates to produce body
     text. -->

<xsl:import href="latex_book.xsl"/>
<xsl:import href="fasttext.xsl"/>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="legalnotice">
  <xsl:text>\def\DBKlegaltitle{</xsl:text>
  <xsl:apply-templates select="title"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:text>\begin{DBKlegalnotice}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>\end{DBKlegalnotice}&#10;</xsl:text>
</xsl:template>

<xsl:template match="legalnotice/title">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="print.legalnotice">
  <xsl:param name="nodes" select="."/>
  <xsl:if test="$nodes">
    <xsl:text>&#10;%% Legalnotices&#10;</xsl:text>
    <!-- beware, save verbatim since we use a command -->
    <xsl:apply-templates select="$nodes" mode="save.verbatim"/>
    <xsl:text>\def\DBKlegalblock{&#10;</xsl:text>
    <xsl:apply-templates select="$nodes"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Lists parameters -->
<xsl:param name="seg.item.separator">, </xsl:param>
<xsl:param name="variablelist.term.separator">, </xsl:param>
<xsl:param name="term.breakline">0</xsl:param>


<xsl:template match="variablelist/title|
                     orderedlist/title | itemizedlist/title | simplelist/title">
  <xsl:text>&#10;{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select=".."/>
  </xsl:call-template>
  <!-- Ask to latex to let the title with its list -->
  <xsl:text>\nopagebreak&#10;</xsl:text>
</xsl:template>

<!-- In latex, the list nesting depth is limited. The depths are checked in
     order to prevent from compilation crash. If the depth is correct
     the templates that actually do the work are called.
 -->
<xsl:template match="itemizedlist|orderedlist|variablelist">
  <xsl:variable name="ditem" select="count(ancestor-or-self::itemizedlist)"/>
  <xsl:variable name="dorder" select="count(ancestor-or-self::orderedlist)"/>
  <xsl:variable name="dvar" select="count(ancestor-or-self::variablelist)"/>
  <xsl:choose>
  <xsl:when test="$ditem &gt; 4">
    <xsl:message>*** Error: itemizedlist too deeply nested (&gt; 4)</xsl:message>
    <xsl:text>[Error: itemizedlist too deeply nested]</xsl:text>
  </xsl:when>
  <xsl:when test="$dorder &gt; 4">
    <xsl:message>*** Error: orderedlist too deeply nested (&gt; 4)</xsl:message>
    <xsl:text>[Error: orderedlist too deeply nested]</xsl:text>
  </xsl:when>
  <xsl:when test="($ditem+$dorder+$dvar) &gt; 6">
    <xsl:message>*** Error: lists too deeply nested (&gt; 6)</xsl:message>
    <xsl:text>[Error: lists too deeply nested]</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!-- Ok, can print the list -->
    <xsl:apply-templates select="." mode="print"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="itemizedlist" mode="print">
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="*[not(self::title or
                                     self::titleabbrev or
                                     self::listitem)]"/>
  <xsl:text>\begin{itemize}</xsl:text>
  <!-- Process the option -->
  <xsl:call-template name="opt.group">
    <xsl:with-param name="opts" select="@spacing"/>
    <xsl:with-param name="mode" select="'enumitem'"/>
  </xsl:call-template>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="listitem"/>
  <xsl:text>\end{itemize}&#10;</xsl:text>
</xsl:template>

<xsl:template match="orderedlist" mode="print">
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="*[not(self::title or
                                     self::titleabbrev or
                                     self::listitem)]"/>
  <xsl:text>\begin{enumerate}</xsl:text>
  <!-- Process the options -->
  <xsl:call-template name="opt.group">
    <xsl:with-param name="opts" select="@numeration|@continuation|@spacing"/>
    <xsl:with-param name="mode" select="'enumitem'"/>
  </xsl:call-template>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="listitem"/>
  <xsl:text>\end{enumerate}&#10;</xsl:text>
</xsl:template>

<xsl:template match="variablelist" mode="print">
  <xsl:apply-templates select="title"/>
  <xsl:apply-templates select="*[not(self::title or
                                     self::titleabbrev or
                                     self::varlistentry)]"/>
  <xsl:text>&#10;\noindent&#10;</xsl:text> 
  <xsl:text>\begin{description}&#10;</xsl:text>
  <xsl:apply-templates select="varlistentry"/>
  <xsl:text>\end{description}&#10;</xsl:text>
</xsl:template>

<xsl:template match="listitem">
  <!-- Add {} to avoid some mess with following square brackets [...] -->
  <xsl:text>&#10;\item{}</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="varlistentry">
  <xsl:text>\item[{</xsl:text>
  <xsl:apply-templates select="term"/>
  <xsl:text>}] </xsl:text>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="."/>
  </xsl:call-template>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="term"/>
  </xsl:call-template>
  <xsl:apply-templates select="term" mode="foottext"/>
  <xsl:apply-templates select="listitem"/>
</xsl:template>

<xsl:template match="varlistentry/term">
  <xsl:apply-templates/>
  <xsl:if test="position()!=last()">
    <xsl:value-of select="$variablelist.term.separator"/>
  </xsl:if>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <xsl:choose>
  <!-- add a space to force linebreaks for immediate following lists -->
  <xsl:when test="child::*[1][self::itemizedlist or
                              self::orderedlist or
                              self::variablelist][not(child::title)]">
    <xsl:text>~</xsl:text>
  </xsl:when>
  <!-- add a space to force linebreaks for immediate following listings -->
  <xsl:when test="child::*[1][self::programlisting][not(child::title)]">
    <xsl:text>~</xsl:text>
  </xsl:when>
  <!-- add a space to avoid the term be centered -->
  <xsl:when test="child::*[not(self::indexterm)][1][self::figure]">
    <xsl:text>~ </xsl:text>
  </xsl:when>
  <!-- force linebreak after the term. The space is to avoid side effect
       with immediate following brackets [...]-->
  <xsl:when test="$term.breakline='1'">
    <xsl:text>\hspace{0em}\\~&#10;</xsl:text>
  </xsl:when>
  </xsl:choose>
  <xsl:apply-templates/>
</xsl:template>


<!-- ################
     # List Options #
     ################ -->

<!-- Process a group of options (reusable) -->
<xsl:template name="opt.group">
  <xsl:param name="opts"/>
  <xsl:param name="mode" select="'opt'"/>
  <xsl:param name="left" select="'['"/>
  <xsl:param name="right" select="']'"/>

  <xsl:variable name="result">
    <xsl:for-each select="$opts">
      <xsl:variable name="str">
        <xsl:apply-templates select="." mode="enumitem"/>
      </xsl:variable>
      <!-- Put a separator only if something really printed -->
      <xsl:if test="$str!='' and position()!=1">
        <xsl:text>,</xsl:text>
      </xsl:if>
      <xsl:value-of select="$str"/>
    </xsl:for-each>
  </xsl:variable>

  <xsl:if test="$result != ''">
    <xsl:value-of select="$left"/>
    <!-- Remove spurious first comma -->
    <xsl:choose>
      <xsl:when test="starts-with($result, ',')">
        <xsl:value-of select="substring-after($result, ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$right"/>
  </xsl:if>
</xsl:template>

<xsl:template match="@numeration" mode="enumitem">
  <xsl:text>label=</xsl:text>
  <xsl:choose>
    <xsl:when test=".='arabic'">\arabic*.</xsl:when>
    <xsl:when test=".='upperalpha'">\Alph*.</xsl:when>
    <xsl:when test=".='loweralpha'">\alph*.</xsl:when>
    <xsl:when test=".='upperroman'">\Roman*.</xsl:when>
    <xsl:when test=".='lowerroman'">\roman*.</xsl:when>
    <xsl:otherwise>\arabic*.</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@continuation" mode="enumitem">
  <xsl:if test=". = 'continues'">
    <xsl:text>resume</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="@spacing" mode="enumitem">
  <xsl:if test=". = 'compact'">
    <xsl:text>itemsep=0pt</xsl:text>
  </xsl:if>
</xsl:template>


<!-- ##############
     # Simplelist #
     ############## -->

<xsl:template name="tabular.string">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="i" select="1"/>
  <xsl:if test="$i &lt;= $cols">
    <xsl:text>l</xsl:text>
    <xsl:call-template name="tabular.string">
      <xsl:with-param name="i" select="$i+1"/>
      <xsl:with-param name="cols" select="$cols"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="member">
  <!-- Put in a group to protect each member from side effects (esp. \\) -->
  <xsl:text>{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>


<!-- Inline simplelist is a comma separated list of items -->

<xsl:template match="simplelist[@type='inline']">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member">
  <xsl:apply-templates/>
  <xsl:if test="position()!=last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>


<!-- Horizontal simplelist, is actually a tabular -->

<xsl:template match="simplelist[@type='horiz']">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;\begin{tabular*}{\linewidth}{</xsl:text>
  <xsl:call-template name="tabular.string">
    <xsl:with-param name="cols" select="$cols"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text> 
  <xsl:for-each select="member">
    <xsl:apply-templates select="."/>
    <xsl:choose>
    <xsl:when test="position()=last()">
      <xsl:text> \\&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="position() mod $cols">
      <xsl:text> &amp; </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> \\&#10;</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;\end{tabular*}&#10;</xsl:text>
</xsl:template>

<!-- Vertical simplelist, a tabular too -->

<xsl:template match="simplelist|simplelist[@type='vert']">
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;\begin{tabular*}{\linewidth}{</xsl:text>
  <xsl:call-template name="tabular.string">
    <xsl:with-param name="cols" select="$cols"/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text> 

  <!-- recusively display each row -->
  <xsl:call-template name="simplelist.vert.row">
    <xsl:with-param name="rows" select="floor((count(member)+$cols - 1) div $cols)"/>
  </xsl:call-template>
  <xsl:text>&#10;\end{tabular*}&#10;</xsl:text>
</xsl:template>

<xsl:template name="simplelist.vert.row">
  <xsl:param name="cell">0</xsl:param>
  <xsl:param name="rows"/>
  <xsl:if test="$cell &lt; $rows">
    <xsl:for-each select="member[((position()-1) mod $rows) = $cell]">
      <xsl:apply-templates select="."/>
      <xsl:if test="position()!=last()">
        <xsl:text> &amp; </xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text> \\&#10;</xsl:text> 
    <xsl:call-template name="simplelist.vert.row">
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- Segmentedlist stuff -->

<xsl:template match="segmentedlist">
  <xsl:text>\noindent </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="segmentedlist/title">
  <xsl:text>{\bf </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}\\&#10;</xsl:text>
</xsl:template>

<xsl:template match="segtitle">
</xsl:template>

<xsl:template match="segtitle" mode="segtitle-in-seg">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="seglistitem">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::seglistitem">
    <xsl:text> \\</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- We trust in the right count of segtitle declarations -->

<xsl:template match="seg">
  <xsl:variable name="segnum" select="count(preceding-sibling::seg)+1"/>
  <xsl:variable name="seglist" select="ancestor::segmentedlist"/>
  <xsl:variable name="segtitles" select="$seglist/segtitle"/>

  <!--
     Note: segtitle is only going to be the right thing in a well formed
     SegmentedList.  If there are too many Segs or too few SegTitles,
     you'll get something odd...maybe an error
  -->

  <xsl:text>\emph{</xsl:text>
  <xsl:apply-templates select="$segtitles[$segnum=position()]"
                       mode="segtitle-in-seg"/>
  <xsl:text>:} </xsl:text>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::seg">
    <xsl:value-of select="$seg.item.separator"/>
  </xsl:if>
</xsl:template>




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





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Mediaobject/imagedata parameters -->
<xsl:param name="mediaobject.caption.style">\slshape</xsl:param>
<xsl:param name="imagedata.default.scale">pagebound</xsl:param>
<xsl:param name="imagedata.file.check">1</xsl:param>
<xsl:param name="imagedata.boxed">0</xsl:param>
<xsl:param name="keep.relative.image.uris" select="0"/>


<!-- Simple mediaobject selection using @role -->
<xsl:template name="mediaobject.select.idx">
  <xsl:param name="olist" select="imageobject|imageobjectco"/>
  <xsl:param name="role" select="'dblatex'"/>
  <xsl:choose>
  <xsl:when test="$olist[@role=$role]">
    <xsl:value-of select="count($olist[@role=$role][1]/preceding-sibling::*) -
                          count($olist[1]/preceding-sibling::*) + 1"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="1"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Initial image macro setting, depending on the parameter value -->
<xsl:template name="opt.extract">
  <xsl:param name="optgroup"/>
  <xsl:param name="opt"/>
  <xsl:if test="contains($optgroup,$opt)">
    <xsl:variable name="s" select="substring-after($optgroup,$opt)"/>
    <xsl:choose>
    <xsl:when test="contains($s,',')">
      <xsl:value-of select="normalize-space(substring-before($s,','))"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($s)"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template name="image.setup">
  <xsl:variable name="maxwidth">
    <xsl:call-template name="opt.extract">
      <xsl:with-param name="optgroup" select="$imagedata.default.scale"/>
      <xsl:with-param name="opt" select="'maxwidth='"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="maxheight">
    <xsl:call-template name="opt.extract">
      <xsl:with-param name="optgroup" select="$imagedata.default.scale"/>
      <xsl:with-param name="opt" select="'maxheight='"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$maxwidth!=''">
    <xsl:text>\def\imgmaxwidth{</xsl:text>
    <xsl:value-of select="$maxwidth"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$maxheight!=''">
    <xsl:text>\def\imgmaxheight{</xsl:text>
    <xsl:value-of select="$maxheight"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="image.autosize">
  <xsl:choose>
  <xsl:when test="$imagedata.default.scale='pagebound' or
                  contains($imagedata.default.scale,'maxwidth=') or
                  contains($imagedata.default.scale,'maxheight=')">
    <xsl:value-of select="1"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="0"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="videoobject">
  <xsl:apply-templates select="videodata"/>
</xsl:template>

<xsl:template match="audioobject">
  <xsl:apply-templates select="audiodata"/>
</xsl:template>

<xsl:template match="textobject">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="mediaobject/caption">
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$mediaobject.caption.style"/>
  <xsl:text> </xsl:text>
  <!-- Apply templates to render captions elements -->
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="mediaobject/caption" mode="subfigure">
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$mediaobject.caption.style"/>
  <xsl:text> </xsl:text>
  <!-- In subfigures, cannot have several paragraphs, so just take
       the text and normalize it (no \par in it)
       -->
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="mediaobject|inlinemediaobject">
  <xsl:variable name="figcount"
                select="count(ancestor::figure/mediaobject[imageobject])"/>
  <!--
  within a figure don't put each mediaobject into a separate paragraph, 
  to let the subfigures correctly displayed.
  -->
  <xsl:if test="self::mediaobject and not(parent::figure)">
    <xsl:text>&#10;\noindent</xsl:text>
    <xsl:text>\begin{minipage}[c]{\linewidth}&#10;</xsl:text>
    <xsl:text>\begin{center}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="self::inlinemediaobject">
    <xsl:text>\noindent</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="imageobject|imageobjectco">
      <xsl:variable name="idx">
        <xsl:call-template name="mediaobject.select.idx"/>
      </xsl:variable>
      <xsl:variable name="img"
                    select="(imageobject|imageobjectco)[position()=$idx]"/>

      <xsl:if test="$imagedata.file.check='1'">
        <xsl:text>\imgexists{</xsl:text>
        <xsl:apply-templates
            select="$img/descendant::imagedata"
            mode="filename.get"/>
        <xsl:text>}{</xsl:text>
      </xsl:if>
      <xsl:apply-templates select="$img"/>
      <xsl:if test="$imagedata.file.check='1'">
        <xsl:text>}{</xsl:text>
        <xsl:apply-templates select="textobject[1]"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="textobject[1]"/>
    </xsl:otherwise>
  </xsl:choose>
  <!-- print the caption if not in a float, or is single -->
  <xsl:if test="caption and ($figcount &lt;= 1)">
    <xsl:text>\begin{center}&#10;</xsl:text>
    <xsl:apply-templates select="caption"/>
    <xsl:text>\end{center}&#10;</xsl:text>
  </xsl:if> 
  <xsl:if test="self::mediaobject and not(parent::figure)">
    <xsl:text>\end{center}&#10;</xsl:text>
    <xsl:text>\end{minipage}&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="imageobject">
  <xsl:variable name="figcount"
                select="count(ancestor::figure/mediaobject[imageobject])"/>
  <xsl:if test="$figcount &gt; 1">
    <!-- space before subfigure to prevent from strange behaviour with other
         subfigures unless forced by @role -->
    <xsl:if test="not(ancestor::figure/@role='flow.inline')">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:text>\subfigure</xsl:text>
    <xsl:if test="../caption">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="../caption" mode="subfigure"/>
      <xsl:text>][</xsl:text>
      <xsl:apply-templates select="../caption"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
  </xsl:if>
  <xsl:if test="$imagedata.boxed = '1'">
    <xsl:text>\fbox{</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="imagedata"/>
  <xsl:if test="$imagedata.boxed = '1'">
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:if test="$figcount &gt; 1">
    <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template name="unit.eval">
  <xsl:param name="length"/>
  <xsl:param name="prop" select="''"/>
  <xsl:choose>
  <!-- percentage of something -->
  <xsl:when test="contains($length, '%') and substring-after($length, '%')=''">
    <xsl:value-of select="number(substring-before($length, '%')) div 100"/>
    <xsl:value-of select="$prop"/>
  </xsl:when>
  <!-- pixel unit is not handled -->
  <xsl:when test="contains($length, 'px') and substring-after($length, 'px')=''">
    <xsl:message>Pixel unit not handled (replaced by pt)</xsl:message>
    <xsl:value-of select="number(substring-before($length, 'px'))"/>
    <xsl:text>pt</xsl:text>
  </xsl:when>
  <!-- no unit provided means pixel -->
  <xsl:when test="$length and (number($length)=$length)">
    <xsl:message>Pixel unit not handled (replaced by pt)</xsl:message>
    <xsl:value-of select="$length"/>
    <xsl:text>pt</xsl:text>
  </xsl:when>
  <!-- hope the unit is handled -->
  <xsl:otherwise>
    <xsl:value-of select="$length"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="image.default.set">
  <xsl:variable name="auto">
    <xsl:call-template name="image.autosize"/>
  </xsl:variable>
  <xsl:choose>
  <xsl:when test="$auto=1">
    <!-- use the natural size up to the specified boundaries -->
    <xsl:text>width=\imgwidth,height=\imgheight,keepaspectratio=true</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!-- put the parameter value as is -->
    <xsl:value-of select="$imagedata.default.scale"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- the latex macro to use to include a graphic depends on the environment -->
<xsl:template name="graphic.begin.get">
  <xsl:choose>
  <xsl:when test="ancestor::imageobjectco">
    <xsl:apply-templates select="ancestor::imageobjectco" mode="graphic.begin"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\includegraphics</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="graphic.end.get">
  <xsl:if test="ancestor::imageobjectco">
    <xsl:apply-templates select="ancestor::imageobjectco" mode="graphic.end"/>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<!-- Image filename to use -->
<xsl:template match="imagedata|graphic|inlinegraphic" mode="filename.get">
  <xsl:choose>
  <xsl:when test="@entityref">
    <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
  </xsl:when>
  <xsl:when test="@fileref">
    <xsl:apply-templates select="@fileref"/>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- Resolve xml:base attributes (taken from the DocBook Project) -->
<xsl:template match="@fileref">
  <!-- need a check for absolute urls -->
  <xsl:choose>
    <xsl:when test="contains(., ':') or starts-with(.,'/')">
      <!-- it has a uri scheme or starts with '/', so it is an absolute uri -->
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:when test="$keep.relative.image.uris != 0">
      <!-- leave it alone -->
      <xsl:value-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <!-- its a relative uri -->
      <xsl:call-template name="relative-uri">
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Process an imagedata -->

<xsl:template match="imagedata" name="imagedata">
  <xsl:variable name="graphic.begin">
    <xsl:call-template name="graphic.begin.get"/>
  </xsl:variable>
  <xsl:variable name="graphic.end">
    <xsl:call-template name="graphic.end.get"/>
  </xsl:variable>
  <xsl:variable name="piangle">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="../processing-instruction('dblatex')"/>
      <xsl:with-param name="attribute" select="'angle'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="filename">
    <xsl:apply-templates select="." mode="filename.get"/>
  </xsl:variable>
  <xsl:variable name="width">
    <xsl:call-template name="unit.eval">
      <xsl:with-param name="length" select="@width"/>
      <xsl:with-param name="prop" select="'\linewidth'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="depth">
    <xsl:call-template name="unit.eval">
      <xsl:with-param name="length" select="@depth"/>
      <xsl:with-param name="prop" select="'\textheight'"/>
    </xsl:call-template>
  </xsl:variable>
  <!-- viewport is valid only if there's some viewport spec, and content or
       scale. TDG says that viewport spec without content/scale and scalefit=0
       is ignored. -->
  <xsl:variable name="viewport">
    <xsl:choose>
    <xsl:when test="(@width or @depth) and
                    (@contentwidth or @contentdepth or @scale or
                    (@scalefit and @scalefit='0'))">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="0"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- check if some percentage is applied to the content -->
  <xsl:variable name="widthperct">
    <xsl:choose>
    <xsl:when test="@contentwidth and contains(@contentwidth, '%') and
                    substring-after(@contentwidth, '%')=''">
      <xsl:value-of select="number(substring-before(@contentwidth, '%'))
                            div 100"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="0"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="depthperct">
    <xsl:choose>
    <xsl:when test="@contentdepth and contains(@contentdepth, '%') and
                    substring-after(@contentdepth, '%')=''">
      <xsl:value-of select="number(substring-before(@contentdepth, '%'))
                            div 100"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="0"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>{</xsl:text>
  <xsl:if test="$viewport=1">
    <xsl:text>\begin{minipage}[c]</xsl:text>
    <xsl:if test="@depth">
      <!-- depth -->
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$depth"/>
      <xsl:text>]</xsl:text>
      <xsl:text>[</xsl:text>
      <!-- vertical alignment (meaningfull only with depth) -->
      <xsl:choose>
      <xsl:when test="@valign='bottom'">
        <xsl:text>b</xsl:text>
      </xsl:when>
      <xsl:when test="@valign='middle'">
        <xsl:text>c</xsl:text>
      </xsl:when>
      <xsl:when test="@valign='top'">
        <xsl:text>t</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>c</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <!-- width -->
    <xsl:text>{</xsl:text>
    <xsl:choose>
    <xsl:when test="@width">
      <xsl:value-of select="$width"/>
    </xsl:when>
    <xsl:when test="ancestor::mediaobject">
      <xsl:text>\linewidth</xsl:text>
    </xsl:when>
    <!-- TODO: inline viewport area should be as wide as the graphic -->
    <!--  <xsl:text>\figwidth</xsl:text> -->
    <xsl:otherwise>
      <xsl:text>\linewidth</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <!-- horizontal alignment -->
  <xsl:choose>
  <xsl:when test="@align='center'">
    <xsl:text>\centering </xsl:text>
  </xsl:when>
  <xsl:when test="@align='left'">
    <xsl:text>\raggedright </xsl:text>
  </xsl:when>
  <xsl:when test="@align='right'">
    <xsl:text>\raggedleft </xsl:text>
  </xsl:when>
  </xsl:choose>

  <!-- find out the natural image size -->
  <xsl:variable name="auto">
    <xsl:call-template name="image.autosize"/>
  </xsl:variable>
  <xsl:if test="$auto=1 or $widthperct!=0 or $depthperct!=0">
    <xsl:text>\imgevalsize{</xsl:text>
    <xsl:value-of select="$filename"/>
    <xsl:text>}</xsl:text>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$graphic.begin"/>
  <xsl:text>[</xsl:text>
  <!-- TDG says that content, scale and scalefit are mutually exclusive -->
  <xsl:choose>
    <!-- content area spec -->
    <xsl:when test="@contentwidth or @contentdepth"> 
      <xsl:choose>
      <!-- special case where both content percentages are the same -->
      <xsl:when test="$widthperct!=0 and $widthperct=$depthperct">
        <xsl:text>scale=</xsl:text>
        <xsl:value-of select="$widthperct"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@contentwidth">
          <xsl:text>width=</xsl:text>
          <xsl:call-template name="unit.eval">
            <xsl:with-param name="length" select="@contentwidth"/>
            <xsl:with-param name="prop" select="'\imgrwidth'"/>
          </xsl:call-template>
          <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:if test="@contentdepth">
          <xsl:text>height=</xsl:text>
          <xsl:call-template name="unit.eval">
            <xsl:with-param name="length" select="@contentdepth"/>
            <xsl:with-param name="prop" select="'\imgrheight'"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <!-- scaling -->
    <xsl:when test="@scale"> 
      <xsl:text>scale=</xsl:text>
      <xsl:value-of select="number(@scale) div 100"/>
    </xsl:when>
    <!-- only viewport area spec with scalefit -->
    <xsl:when test="(not(@scalefit) or @scalefit='1') and (@width or @depth)">
      <xsl:if test="@width">
        <xsl:text>width=</xsl:text>
        <xsl:value-of select="$width"/>
        <xsl:text>,</xsl:text>
      </xsl:if>
      <xsl:if test="@depth">
        <xsl:text>height=</xsl:text>
        <xsl:value-of select="$depth"/>
        <xsl:text>,</xsl:text>
      </xsl:if>
      <!-- TDG says that scale to fit cannot be anamorphic -->
      <xsl:text>keepaspectratio=true</xsl:text>
    </xsl:when>
    <!-- default scaling (if any) -->
    <xsl:otherwise>
      <xsl:call-template name="image.default.set"/>
    </xsl:otherwise>
  </xsl:choose>
  <!-- rotate the image? -->
  <xsl:choose>
  <xsl:when test="@format = 'PRN'">
    <xsl:text>,angle=270</xsl:text>
  </xsl:when>
  <xsl:when test="$piangle != ''">
    <xsl:text>,angle=</xsl:text>
    <xsl:value-of select="$piangle"/>
  </xsl:when>
  </xsl:choose>
  <xsl:text>]{</xsl:text>
  <xsl:value-of select="$filename"/>
  <xsl:text>}</xsl:text>
  <xsl:value-of select="$graphic.end"/>
  <xsl:text>}</xsl:text>
  <xsl:if test="$viewport=1">
    <xsl:text>\end{minipage}&#10;</xsl:text>
  </xsl:if>
  <xsl:text>}</xsl:text>
</xsl:template>






<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:param name="imageobjectco.hide" select="0"/>

<xsl:template match="mediaobjectco">
  <xsl:if test="not(parent::figure)">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>\begin{minipage}{\linewidth}&#10;</xsl:text>
    <xsl:text>\begin{center}&#10;</xsl:text>
  </xsl:if>
  <!-- Forget the textobject -->
  <xsl:apply-templates select="imageobjectco[1]"/>
  <xsl:if test="not(parent::figure)">
    <xsl:text>\end{center}&#10;</xsl:text>
    <xsl:text>\end{minipage}&#10;</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="imageobjectco">
  <!-- Do as if we could have several imageobjects (DocBook 5) -->
  <xsl:variable name="idx">
    <xsl:call-template name="mediaobject.select.idx"/>
  </xsl:variable>
  <xsl:apply-templates select="imageobject[position()=$idx]"/>
  <xsl:apply-templates select="calloutlist"/>
</xsl:template>

<xsl:template match="imageobjectco" mode="graphic.begin">
  <xsl:text>\begin{overpic}</xsl:text>
</xsl:template>

<xsl:template match="imageobjectco" mode="graphic.end">
  <xsl:text>&#10;\picfactoreval</xsl:text>
  <xsl:apply-templates select="areaspec//area" mode="graphic"/>
  <xsl:text>\end{overpic}</xsl:text>
</xsl:template>

<!-- Cut a coord of the form "x,y" and gives x or y -->
<xsl:template name="coord.get">
  <xsl:param name="axe"/>
  <xsl:param name="def"/>
  <xsl:param name="xy"/>

  <xsl:choose>
  <xsl:when test="contains($xy, ',')">
    <xsl:choose>
    <xsl:when test="$axe='x'">
      <xsl:value-of select="substring-before($xy, ',')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring-after($xy, ',')"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="$axe=$def">
      <xsl:value-of select="$xy"/>
    </xsl:if>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Check the validity or a coordinate -->
<xsl:template name="coord.check">
  <xsl:param name="x"/>
  <xsl:if test="$x!=''">
    <xsl:choose>
    <xsl:when test="string(number($x))='NaN'">
      <xsl:message>
        <xsl:text>*** Error: </xsl:text>
        <xsl:value-of select="$x"/>
        <xsl:text>: invalid calspair coordinate</xsl:text>
      </xsl:message>
      <xsl:value-of select='1'/>
    </xsl:when>
    <xsl:when test="number($x)&gt;10000">
      <xsl:message>
        <xsl:text>*** Error: </xsl:text>
        <xsl:value-of select="$x"/>
        <xsl:text>: calspair out of range</xsl:text>
      </xsl:message>
      <xsl:value-of select='1'/>
    </xsl:when>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- Put the callout mark on the graphic, according to the caspair
     coordinates -->

<xsl:template match="area" mode="graphic">
  <xsl:variable name="x1y1">
    <xsl:value-of select="substring-before(@coords, ' ')"/>
  </xsl:variable>
  <xsl:variable name="x2y2">
    <xsl:value-of select="substring-after(@coords, ' ')"/>
  </xsl:variable>

  <!-- coordinates -->
  <xsl:variable name="x1">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x1y1"/>
      <xsl:with-param name="axe" select="'x'"/>
      <xsl:with-param name="def" select="'x'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="y1">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x1y1"/>
      <xsl:with-param name="axe" select="'y'"/>
      <xsl:with-param name="def" select="'x'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="x2">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x2y2"/>
      <xsl:with-param name="axe" select="'x'"/>
      <xsl:with-param name="def" select="'y'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="y2">
    <xsl:call-template name="coord.get">
      <xsl:with-param name="xy" select="$x2y2"/>
      <xsl:with-param name="axe" select="'y'"/>
      <xsl:with-param name="def" select="'y'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- consistency check of @coords -->
  <xsl:variable name="coord.error">
    <xsl:if test="$x1y1='' or $x2y2=''">
      <xsl:message>
        <xsl:text>*** Error: </xsl:text>
        <xsl:value-of select="@coords"/>
        <xsl:text>: invalid calspair</xsl:text>
      </xsl:message>
      <xsl:value-of select="'1'"/>
    </xsl:if>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$x1"/>
    </xsl:call-template>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$y1"/>
    </xsl:call-template>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$x2"/>
    </xsl:call-template>
    <xsl:call-template name="coord.check">
      <xsl:with-param name="x" select="$y2"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="$coord.error=''">
    <xsl:text>\calspair{</xsl:text>

    <!-- choose horizontal coordinate -->
    <xsl:choose>
      <xsl:when test="$x1 != '' and $x2 != ''">
        <xsl:value-of select="(number($x1)+number($x2)) div 200"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number(concat($x1, $x2)) div 100"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}{</xsl:text>
    <!-- choose vertical coordinate -->
    <xsl:choose>
      <xsl:when test="$y1 != '' and $y2 != ''">
        <xsl:value-of select="(number($y1)+number($y2)) div 200"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="number(concat($y1, $y2)) div 100"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>}{</xsl:text>
    <!-- callout markup in the image. No tex escape sequence needed here -->
    <xsl:apply-templates select="." mode="latex.programlisting">
      <xsl:with-param name="co-tagin" select="''"/>
      <xsl:with-param name="co-tagout" select="''"/>
      <xsl:with-param name="co-hide" select="$imageobjectco.hide"/>
    </xsl:apply-templates>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>
  



<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="msg">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgmain">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgmain/title|msgsub/title|msgrel/title">
  <xsl:text>{\textbf{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}} </xsl:text>
</xsl:template>

<xsl:template match="msgsub">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgrel">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msgtext">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msginfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="msglevel|msgorig|msgaud">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>\textbf{</xsl:text>
  <xsl:call-template name="gentext.element.name"/>
  <xsl:text>: </xsl:text>
  <xsl:text>} </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="msgexplan">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:output method="text" encoding="UTF-8" indent="yes"/>

<!-- <xsl:include href="fasttext.xsl"/>

<xsl:include href="common/misc.xsl"/>
<xsl:include href="common/l10n.xsl"/>
<xsl:include href="common/common.xsl"/>
<xsl:include href="common/gentext.xsl"/>
<xsl:include href="common/labels.xsl"/>
<xsl:include href="common/olink.xsl"/>
<xsl:include href="common/lib.xsl"/>
<xsl:include href="common/titles.xsl"/>
<xsl:include href="chapter.xsl"/>
<xsl:include href="bridgehead.xsl"/>
<xsl:include href="color.xsl"/>
<xsl:include href="newtbl.xsl"/>
<xsl:include href="htmltbl.xsl"/>
<xsl:include href="tablen.xsl"/>
<xsl:include href="admon.xsl"/>
<xsl:include href="revision.xsl"/>
<xsl:include href="legalnotice.xsl"/>
<xsl:include href="example.xsl"/>
<xsl:include href="inlined.xsl"/>
<xsl:include href="url.xsl"/>
<xsl:include href="format.xsl"/>
<xsl:include href="verbatim.xsl"/>
<xsl:include href="verbatimco.xsl"/>
<xsl:include href="refentry.xsl"/>
<xsl:include href="biblio.xsl"/>
<xsl:include href="index.xsl"/>
<xsl:include href="footnote.xsl"/>
<xsl:include href="procedure.xsl"/>
<xsl:include href="lists.xsl"/>
<xsl:include href="xref.xsl"/>
<xsl:include href="lang.xsl"/>
<xsl:include href="set.xsl"/>
<xsl:include href="pagesetup.xsl"/>
<xsl:include href="pdfmeta.xsl"/>
<xsl:include href="preamble.xsl"/>
<xsl:include href="main.xsl"/>
<xsl:include href="version.xsl"/>
<xsl:include href="param.xsl"/>
<xsl:include href="citation.xsl"/>
<xsl:include href="graphic.xsl"/>
<xsl:include href="equation.xsl"/>
<xsl:include href="figure.xsl"/>
<xsl:include href="mediaobject.xsl"/>
<xsl:include href="mediaobjectco.xsl"/>
<xsl:include href="callout.xsl"/>
<xsl:include href="sections.xsl"/>
<xsl:include href="labelid.xsl"/>
<xsl:include href="sgmltag.xsl"/>
<xsl:include href="msgset.xsl"/>
<xsl:include href="part.xsl"/>
<xsl:include href="appendix.xsl"/>
<xsl:include href="abstract.xsl"/>
<xsl:include href="email.xsl"/>
<xsl:include href="toc_lot.xsl"/>
<xsl:include href="dingbat.xsl"/>
<xsl:include href="component.xsl"/>
<xsl:include href="keyword.xsl"/>
<xsl:include href="glossary.xsl"/>
<xsl:include href="synopsis.xsl"/>
<xsl:include href="classsynopsis.xsl"/>
<xsl:include href="qandaset.xsl"/>
<xsl:include href="quote.xsl"/>
<xsl:include href="sidebar.xsl"/>
<xsl:include href="annotation.xsl"/>
<xsl:include href="chunker.xsl"/>
<xsl:include href="docbookng.xsl"/>
<xsl:include href="para.xsl"/>
<xsl:include href="scape.xsl"/>
<xsl:include href="pi.xsl"/>

<xsl:include href="errors.xsl"/> -->

<xsl:key name="id" match="*" use="@id|@xml:id"/>

<xsl:strip-space elements="book article articleinfo chapter"/>


<?xml version='1.0' encoding="utf-8" ?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
    xmlns:exsl="http://exslt.org/common"
    exclude-result-prefixes="doc exsl" version='1.0'>
  
<!--==================== newtbl table handling ========================-->
<!--=                                                                 =-->
<!--= Copyright (C) 2004-2006 Vistair Systems Ltd (www.vistair.com)   =-->
<!--=                                                                 =-->
<!--= Released under the GNU General Public Licence (GPL)             =-->
<!--= (Commercial and other licences by arrangement)                  =-->
<!--=                                                                 =-->
<!--= Release 23/04/2006 by DCRH                                      =-->
<!--=                                                                 =-->
<!--= Email david@vistair.com with bugs, comments etc                 =-->
<!--=                                                                 =-->
<!--===================================================================-->

<!-- Step though each column, generating a colspec entry for it. If a  -->
<!-- colspec was given in the xml, then use it, otherwise generate a -->
<!-- default one -->
<xsl:template name="tbl.defcolspec">
  <xsl:param name="colnum" select="1"/>
  <xsl:param name="colspec"/>
  <xsl:param name="align"/>
  <xsl:param name="rowsep"/>
  <xsl:param name="colsep"/>
  <xsl:param name="cols"/>
  <xsl:param name="autowidth"/>
  
  <xsl:if test="$colnum &lt;= $cols">
    <xsl:choose>
      <xsl:when test="$colspec/colspec[@colnum = $colnum]">
        <xsl:copy-of select="$colspec/colspec[@colnum = $colnum]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="natwidth">
          <xsl:call-template name="natural-width">
            <xsl:with-param name="autowidth" select="$autowidth"/>
            <xsl:with-param name="colnum" select="$colnum"/>
          </xsl:call-template>
        </xsl:variable>
 
        <colspec colnum='{$colnum}' align='{$align}' star='1'
                 rowsep='{$rowsep}' colsep='{$colsep}' 
                 colwidth='\newtblstarfactor'>
          <xsl:if test="$natwidth = 1">
            <xsl:attribute name="autowidth">1</xsl:attribute>
          </xsl:if>
        </colspec>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="tbl.defcolspec">
      <xsl:with-param name="colnum" select="$colnum + 1"/>
      <xsl:with-param name="align" select="$align"/>
      <xsl:with-param name="rowsep" select="$rowsep"/>
      <xsl:with-param name="colsep" select="$colsep"/>
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="autowidth" select="$autowidth"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>



<!-- replace-string function as XSLT doesn't have one built in. -->
<xsl:template name="replace-string">
  <xsl:param name="text"/>
  <xsl:param name="replace"/>
  <xsl:param name="with"/>
  <xsl:choose>
    <xsl:when test="contains($text,$replace)">
      <xsl:value-of select="substring-before($text,$replace)"/>
      <xsl:value-of select="$with"/>
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text"
                        select="substring-after($text,$replace)"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This template extracts the fixed part of a colwidth specification.
     It should be able to do this:
     a+b+c+d*+e+f -> a+b+c+e+f
     a+b+c+d*     -> a+b+c
     d*+e+f       -> e+f      
-->
<xsl:template name="colfixed.get">
  <xsl:param name="width" select="@colwidth"/>
  <xsl:param name="stared" select="'0'"/>
  
  <xsl:choose>
    <xsl:when test="contains($width, '*')">
      <xsl:variable name="after"
                    select="substring-after(substring-after($width, '*'), '+')"/>
      <xsl:if test="contains(substring-before($width, '*'), '+')">
        <xsl:call-template name="colfixed.get">
          <xsl:with-param name="width" select="substring-before($width, '*')"/>
          <xsl:with-param name="stared" select="'1'"/>
        </xsl:call-template>
        <xsl:if test="$after!=''">
          <xsl:text>+</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:value-of select="$after"/>
    </xsl:when>
    <xsl:when test="$stared='1'">
      <xsl:value-of select="substring-before($width, '+')"/>
      <xsl:if test="contains(substring-after($width, '+'), '+')">
        <xsl:text>+</xsl:text>
        <xsl:call-template name="colfixed.get">
          <xsl:with-param name="width" select="substring-after($width, '+')"/>
          <xsl:with-param name="stared" select="'1'"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$width"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="colstar.get">
  <xsl:param name="width"/>
  <xsl:choose>
    <xsl:when test="contains($width, '+')">
      <xsl:call-template name="colstar.get">
        <xsl:with-param name="width" select="substring-after($width, '+')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="string(number($width))='NaN'">1</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="number($width)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Evaluate from the autowidth statement if the current column width
     is its natural size determined by the column cells contents -->
<xsl:template name="natural-width">
  <xsl:param name="autowidth"/>
  <xsl:param name="colnum" select="1"/>

  <xsl:choose>
  <xsl:when test="not(string(@colwidth)) and 
                  (contains($autowidth,'default') or
                   contains($autowidth,'all'))">1</xsl:when>
  <xsl:when test="contains(@colwidth,'*') and
                  contains($autowidth,'all')">1</xsl:when>
  <xsl:when test="contains(concat($autowidth,' '),concat(' ',$colnum,' ')) and
                  contains($autowidth,'column')">1</xsl:when>
  <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Ensure each column has a colspec and each colspec has a valid column -->
<!-- number, width, alignment, colsep, rowsep -->
<xsl:template match="colspec" mode="newtbl">
  <xsl:param name="colnum" select="1"/>
  <xsl:param name="align"/>
  <xsl:param name="colsep"/>
  <xsl:param name="rowsep"/>
  <xsl:param name="autowidth"/>

  <xsl:variable name="natwidth">
    <xsl:call-template name="natural-width">
      <xsl:with-param name="autowidth" select="$autowidth"/>
      <xsl:with-param name="colnum">
         <xsl:choose><xsl:when test="@colnum">
           <xsl:value-of select="@colnum"/>
         </xsl:when>
         <xsl:otherwise>
           <xsl:value-of select="$colnum"/>
         </xsl:otherwise></xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:copy>
    <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
    <xsl:if test="$natwidth = 1">
      <xsl:attribute name="autowidth">1</xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@colnum)">
      <xsl:attribute name="colnum"><xsl:value-of select="$colnum"/>
      </xsl:attribute>
    </xsl:if>
    <!-- Find out if the column width contains fixed width -->
    <xsl:variable name="fixed">
      <xsl:call-template name="colfixed.get"/>
    </xsl:variable>
    
    <xsl:if test="$fixed!=''">
      <xsl:attribute name="fixedwidth">
        <xsl:value-of select="$fixed"/>
      </xsl:attribute>
    </xsl:if>
    <!-- Replace '*' with our to-be-computed factor -->
    <xsl:if test="contains(@colwidth,'*')">
      <xsl:attribute name="colwidth">
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text" select="@colwidth"/>
          <xsl:with-param name="replace">*</xsl:with-param>
          <xsl:with-param name="with">\newtblstarfactor</xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="star">
        <xsl:call-template name="colstar.get">
          <xsl:with-param name="width" select="substring-before(@colwidth, '*')"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:if>
    <!-- No colwidth specified? Assume '*' -->
    <xsl:if test="not(string(@colwidth))">
      <xsl:attribute name="colwidth">\newtblstarfactor</xsl:attribute>
      <xsl:attribute name="star">1</xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@align)">
      <xsl:attribute name="align"><xsl:value-of select="$align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@rowsep)">
      <xsl:attribute name="rowsep"><xsl:value-of select="$rowsep"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="not(@colsep)">
      <xsl:attribute name="colsep"><xsl:value-of select="$colsep"/>
      </xsl:attribute>
    </xsl:if>
    <!-- bgcolor specified via a PI -->
    <xsl:if test="processing-instruction('dblatex')">
      <xsl:variable name="bgcolor">
        <xsl:call-template name="pi-attribute">
          <xsl:with-param name="pis" select="processing-instruction('dblatex')"/>
          <xsl:with-param name="attribute" select="'bgcolor'"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test="$bgcolor != ''">
        <xsl:attribute name="bgcolor"><xsl:value-of select="$bgcolor"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:if>

  </xsl:copy>
  
  <xsl:variable name="nextcolnum">
    <xsl:choose>
      <xsl:when test="@colnum"><xsl:value-of select="@colnum + 1"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$colnum + 1"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:apply-templates mode="newtbl"
                       select="following-sibling::colspec[1]">
    <xsl:with-param name="colnum" select="$nextcolnum"/>
    <xsl:with-param name="align" select="$align"/>
    <xsl:with-param name="colsep" select="$colsep"/>
    <xsl:with-param name="rowsep" select="$rowsep"/>
    <xsl:with-param name="autowidth" select="$autowidth"/>
  </xsl:apply-templates>
</xsl:template>



<!-- Generate a complete set of colspecs for each column in the table -->
<xsl:template name="tbl.colspec">
  <xsl:param name="autowidth"/>
  <xsl:param name="align"/>
  <xsl:param name="rowsep"/>
  <xsl:param name="colsep"/>
  <xsl:param name="cols"/>
  
  <!-- First, get the colspecs that have been specified -->
  <xsl:variable name="givencolspec">
    <xsl:apply-templates mode="newtbl" select="colspec[1]">
      <xsl:with-param name="align" select="$align"/>
      <xsl:with-param name="rowsep" select="$rowsep"/>
      <xsl:with-param name="colsep" select="$colsep"/>
      <xsl:with-param name="autowidth" select="$autowidth"/>
    </xsl:apply-templates>
  </xsl:variable>
  
  <!-- Now generate colspecs for each missing column -->
  <xsl:call-template name="tbl.defcolspec">
    <xsl:with-param name="colspec" select="exsl:node-set($givencolspec)"/>
    <xsl:with-param name="cols" select="$cols"/>
    <xsl:with-param name="align" select="$align"/>
    <xsl:with-param name="rowsep" select="$rowsep"/>
    <xsl:with-param name="colsep" select="$colsep"/>
    <xsl:with-param name="autowidth" select="$autowidth"/>
  </xsl:call-template>
</xsl:template>



<!-- Create a blank entry element. We check the 'entries' node-set -->
<!-- to see if we should copy an entry from the row above instead -->
<xsl:template name="tbl.blankentry">
  <xsl:param name="colnum"/>
  <xsl:param name="colend"/>
  <xsl:param name="rownum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="entries"/>
  <xsl:param name="rowcolor"/>
  
  <xsl:if test="$colnum &lt;= $colend">
    <xsl:variable name="entry"
                  select="$entries/*[self::entry or self::entrytbl]
                                    [@colstart=$colnum and @rowend &gt;= $rownum]"/>
    <xsl:choose>
      <xsl:when test="$entry">
        <!-- Just copy this entry then -->
        <xsl:copy-of select="$entry"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="bgcolor">
          <xsl:choose>
          <xsl:when test="$rowcolor != ''">
            <xsl:value-of select="$rowcolor"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$colspec/colspec[@colnum=$colnum]/@bgcolor"/>
          </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- No rowspan entry found from the row above, so create a blank -->
        <entry colstart='{$colnum}' colend='{$colnum}' 
               rowstart='{$rownum}' rowend='{$rownum}'
               colsep='{$colspec/colspec[@colnum=$colnum]/@colsep}'
               defrowsep='{$colspec/colspec[@colnum=$colnum]/@rowsep}'
               align='{$colspec/colspec[@colnum=$colnum]/@align}'
               bgcolor='{$bgcolor}'/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="nextcol">
      <xsl:choose>
        <xsl:when test="$entry">
          <xsl:value-of select="$entry/@colend"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$colnum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="tbl.blankentry">
      <xsl:with-param name="colnum" select="$nextcol + 1"/>
      <xsl:with-param name="colend" select="$colend"/>
      <xsl:with-param name="rownum" select="$rownum"/>
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="rowcolor" select="$rowcolor"/>
      <xsl:with-param name="entries" select="$entries"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- Check the entry column range is valid -->
<xsl:template name="check-colrange">
  <xsl:param name="colnum"/>
  <xsl:param name="rownum"/>
  <xsl:param name="colend"/>
  <xsl:param name="colstart"/>

  <xsl:variable name="msg">
    <xsl:text>Invalid table entry row=</xsl:text>
    <xsl:value-of select="$rownum"/>
    <xsl:text>/column=</xsl:text>
    <xsl:value-of select="$colnum"/>
  </xsl:variable>
  <xsl:if test="string(number($colend))='NaN'">
    <xsl:message terminate="yes">
      <xsl:value-of select="$msg"/>
      <xsl:text> (@colend)</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:if test="string(number($colstart))='NaN'">
    <xsl:message terminate="yes">
      <xsl:value-of select="$msg"/>
      <xsl:text> (@colstart)</xsl:text>
    </xsl:message>
  </xsl:if>
</xsl:template>


<!-- Returns a RTF of entry elements. rowsep, colsep and align are all -->
<!-- extracted from spanspec/colspec as required -->
<!-- Skipped columns have blank entry elements created -->
<!-- Existing entry elements in the given entries node-set are checked to -->
<!-- see if they should extend into this row and are copied if so -->
<!-- Each element is given additional attributes: -->
<!-- rowstart = The top row number of the table this entry -->
<!-- rowend = The bottom row number of the table this entry -->
<!-- colstart = The starting column number of this entry -->
<!-- colend = The ending column number of this entry -->
<!-- defrowsep = The default rowsep value inherited from the entry's span -->
<!--     or colspec -->
<xsl:template match="entry|entrytbl" mode="newtbl.buildentries">
  <xsl:param name="colnum"/>
  <xsl:param name="rownum"/>
  <xsl:param name="colspec"/>
  <xsl:param name="spanspec"/>
  <xsl:param name="frame"/>
  <xsl:param name="rowcolor"/>
  <xsl:param name="entries"/>
  <xsl:param name="tabletype"/>

  <xsl:variable name="cols" select="count($colspec/*)"/>
 
  <xsl:if test="$colnum &lt;= $cols">

    <xsl:variable name="entry"
        select="$entries/*[self::entry or self::entrytbl]
                                [@colstart=$colnum and @rowend &gt;= $rownum]"/>
    <!-- Do we have an existing entry element from a previous row that -->
    <!-- should be copied into this row? -->
    <xsl:choose><xsl:when test="$entry">
      <!-- Just copy this entry then -->
      <xsl:copy-of select="$entry"/>

      <!-- Process the next column using this current entry -->
      <xsl:apply-templates mode="newtbl.buildentries" select=".">
        <xsl:with-param name="colnum" 
                        select="$entries/entry[@colstart=$colnum]/@colend + 1"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="rowcolor" select="$rowcolor"/>
        <xsl:with-param name="entries" select="$entries"/>
        <xsl:with-param name="tabletype" select="$tabletype"/>
      </xsl:apply-templates>
      </xsl:when><xsl:otherwise>
      <!-- Get any span for this entry -->
      <xsl:variable name="span">
        <xsl:if test="@spanname and $spanspec[@spanname=current()/@spanname]">
          <xsl:copy-of select="$spanspec[@spanname=current()/@spanname]"/>
        </xsl:if>
      </xsl:variable>
      
      <!-- Get the starting column number for this cell -->
      <xsl:variable name="colstart">
        <xsl:choose>
          <!-- Check colname first -->
          <xsl:when test="$colspec/colspec[@colname=current()/@colname]">
            <xsl:value-of
                select="$colspec/colspec[@colname=current()/@colname]/@colnum"/>
          </xsl:when>
          <!-- Now check span -->
          <xsl:when test="exsl:node-set($span)/spanspec/@namest">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  exsl:node-set($span)/spanspec/@namest]/@colnum"/>
          </xsl:when>
          <!-- Now check namest attribute -->
          <xsl:when test="@namest">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  current()/@namest]/@colnum"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$colnum"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Get the ending column number for this cell -->
      <xsl:variable name="colend">
        <xsl:choose>
          <!-- Check span -->
          <xsl:when test="exsl:node-set($span)/spanspec/@nameend">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  exsl:node-set($span)/spanspec/@nameend]/@colnum"/>
          </xsl:when>
          <!-- Check nameend attribute -->
          <xsl:when test="@nameend">
            <xsl:value-of select="$colspec/colspec[@colname=
                                  current()/@nameend]/@colnum"/>
          </xsl:when>
          <!-- Otherwise end == start -->
          <xsl:otherwise>
            <xsl:value-of select="$colstart"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Check column consistency -->
      <xsl:call-template name="check-colrange">
        <xsl:with-param name="colnum" select="$colnum"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colstart" select="$colstart"/>
        <xsl:with-param name="colend" select="$colend"/>
      </xsl:call-template>

      <!-- No offset between column and cell content for entrytbl -->
      <xsl:variable name="coloff">
        <xsl:choose>
          <xsl:when test="self::entrytbl">0</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Does this entry want to start at a later column? -->
      <xsl:if test="$colnum &lt; $colstart">
        <!-- If so, create some blank entries to fill in the gap -->
        <xsl:call-template name="tbl.blankentry">
          <xsl:with-param name="colnum" select="$colnum"/>
          <xsl:with-param name="colend" select="$colstart - 1"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
          <xsl:with-param name="entries" select="$entries"/>
        </xsl:call-template>
      </xsl:if>
      
      <!-- Get the colsep override from this entry or its span -->
      <xsl:variable name="colsep">
        <xsl:choose>
          <!-- Entry element override -->
          <xsl:when test="@colsep"><xsl:value-of select="@colsep"/></xsl:when>
          <!-- Then any span present -->
          <xsl:when test="exsl:node-set($span)/spanspec/@colsep">
            <xsl:value-of select="exsl:node-set($span)/spanspec/@colsep"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise take from colspec -->
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@colsep"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Get the default rowsep for this entry -->
      <xsl:variable name="defrowsep">
        <xsl:choose>
          <!-- Check any span present -->
          <xsl:when test="exsl:node-set($span)/spanspec/@rowsep">
            <xsl:value-of select="exsl:node-set($span)/spanspec/@rowsep"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise take from colspec -->
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@rowsep"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Generate cell alignment -->
      <xsl:variable name="align">
        <xsl:choose>
          <!-- Entry element attribute first -->
          <xsl:when test="string(@align)">
            <xsl:value-of select="@align"/>
          </xsl:when>
          <!-- Then any span present -->
          <xsl:when test="exsl:node-set($span)/spanspec/@align">
            <xsl:value-of select="exsl:node-set($span)/spanspec/@align"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Otherwise take from colspec -->
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@align"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Vertical cell alignment -->
      <xsl:variable name="valign">
        <xsl:choose>
          <!-- Entry element attribute first -->
          <xsl:when test="string(@valign)">
            <xsl:value-of select="@valign"/>
          </xsl:when>
          <!-- Then parent row -->
          <xsl:when test="../@valign">
            <xsl:value-of select="../@valign"/>
          </xsl:when>
          <!-- Then parent tbody|thead -->
          <xsl:when test="../../@valign">
            <xsl:value-of select="../../@valign"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="cellcolor">
        <xsl:if test="processing-instruction('dblatex')">
          <xsl:call-template name="pi-attribute">
            <xsl:with-param name="pis" select="processing-instruction('dblatex')"/>
            <xsl:with-param name="attribute" select="'bgcolor'"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:variable>

      <xsl:variable name="bgcolor">
        <xsl:choose>
          <xsl:when test="$cellcolor != ''">
            <xsl:value-of select="$cellcolor"/>
          </xsl:when>
          <xsl:when test="$rowcolor != ''">
            <xsl:value-of select="$rowcolor"/>
          </xsl:when>
          <xsl:when test="$colspec/colspec[@colnum=$colstart]/@bgcolor">
            <xsl:value-of select="$colspec/colspec[@colnum=$colstart]/@bgcolor"/>
          </xsl:when>
          <xsl:when test="ancestor::*[self::table or self::informaltable]/@bgcolor">
            <xsl:value-of select="ancestor::*[self::table or
                                              self::informaltable]/@bgcolor"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      
      <xsl:copy>
        <xsl:for-each select="@*"><xsl:copy/></xsl:for-each>
        <xsl:attribute name="colstart">
          <xsl:value-of select="$colstart"/>
        </xsl:attribute>
        <xsl:attribute name="colend">
          <xsl:value-of select="$colend"/>
        </xsl:attribute>
        <xsl:attribute name="coloff">
          <xsl:value-of select="$coloff"/>
        </xsl:attribute>
        <xsl:attribute name="rowstart">
          <xsl:value-of select="$rownum"/>
        </xsl:attribute>
        <xsl:attribute name="rowend">
          <xsl:choose>
            <xsl:when test="@morerows and @morerows > 0">
              <xsl:value-of select="@morerows + $rownum"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$rownum"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="colsep">
          <xsl:value-of select="$colsep"/>
        </xsl:attribute>
        <xsl:attribute name="defrowsep">
          <xsl:value-of select="$defrowsep"/>
        </xsl:attribute>
        <xsl:attribute name="align">
          <xsl:value-of select="$align"/>
        </xsl:attribute>
        <xsl:attribute name="valign">
          <xsl:value-of select="$valign"/>
        </xsl:attribute>
        <xsl:if test="$bgcolor != ''">
          <xsl:attribute name="bgcolor">
            <xsl:value-of select="$bgcolor"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="tabletype">
          <xsl:value-of select="$tabletype"/>
        </xsl:attribute>
        <!-- Process the output here, to stay in the document context. -->
        <!-- In RTF entries the document links/refs are lost -->
        <xsl:element name="output">
          <xsl:apply-templates select="." mode="output"/>
        </xsl:element>
      </xsl:copy>
      
      <!-- See if we've run out of entries for the current row -->
      <xsl:if test="$colend &lt; $cols and
                    not(following-sibling::*[self::entry or self::entrytbl][1])">
        <!-- Create more blank entries to pad the row -->
        <xsl:call-template name="tbl.blankentry">
          <xsl:with-param name="colnum" select="$colend + 1"/>
          <xsl:with-param name="colend" select="$cols"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
          <xsl:with-param name="entries" select="$entries"/>
          <xsl:with-param name="tabletype" select="$tabletype"/>
        </xsl:call-template>
      </xsl:if>
      
      <xsl:apply-templates mode="newtbl.buildentries" 
               select="following-sibling::*[self::entry or self::entrytbl][1]">
        <xsl:with-param name="colnum" select="$colend + 1"/>
        <xsl:with-param name="rownum" select="$rownum"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="rowcolor" select="$rowcolor"/>
        <xsl:with-param name="entries" select="$entries"/>
        <xsl:with-param name="tabletype" select="$tabletype"/>
      </xsl:apply-templates>
    </xsl:otherwise></xsl:choose>
  </xsl:if>  <!-- $colnum <= $cols -->
</xsl:template>



<!-- Output the current entry node -->
<xsl:template match="entry|entrytbl" mode="newtbl">
  <xsl:param name="colspec"/>
  <xsl:param name="context"/>
  <xsl:param name="frame"/>
  <xsl:param name="rownum"/>
  
  <xsl:variable name="cols" select="count($colspec/*)"/>
  <!--
      <xsl:if test="@colstart &gt; $cols">
      <xsl:message>BANG</xsl:message>
      </xsl:if>
  -->
  <xsl:if test="@colstart &lt;= $cols">
    
    <!-- Should this column be sized by latex? -->
    <xsl:variable name="autowidth"
                  select="$colspec/colspec[@colnum=current()/@colstart]/@autowidth"/>

    <xsl:variable name="moreprint"
                  select="not($autowidth and (@rowstart != $rownum))"/>

    <!-- Generate the column spec for this column -->
    <xsl:text>\multicolumn{</xsl:text>
    <xsl:value-of select="@colend - @colstart + 1"/>
    <xsl:text>}{</xsl:text>
    <xsl:apply-templates select="." mode="tbl.colfmt">
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="frame" select="$frame"/>
      <xsl:with-param name="autowidth" select="$autowidth"/>
    </xsl:apply-templates>
    <xsl:text>}{</xsl:text>
    
    <!-- Put everything inside a multirow if required -->
    <xsl:if test="@morerows and @morerows > 0 and $moreprint">
      <!-- Multirow doesn't use setlength and hence our calc stuff doesn't -->
      <!-- work. Do it manually then -->
      <xsl:if test="not($autowidth)">
        <xsl:text>\setlength{\newtblcolwidth}{</xsl:text>
        <!-- Put the column width here for line wrapping -->
        <xsl:call-template name="tbl.colwidth">
          <xsl:with-param name="col" select="@colstart"/>
          <xsl:with-param name="colend" select="@colend"/>
          <xsl:with-param name="colspec" select="$colspec"/>
        </xsl:call-template>
        <xsl:text>}</xsl:text>
      </xsl:if>
      <xsl:text>\multirowii</xsl:text>
      
      <!-- Vertical alignment done by custom multirow -->
      <xsl:if test="@valign and @valign!=''">
        <xsl:choose>
        <xsl:when test="@valign = 'top'"><xsl:text>[p]</xsl:text></xsl:when>
        <xsl:when test="@valign = 'bottom'"><xsl:text>[b]</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>[m]</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      
      <xsl:text>{</xsl:text>
      <xsl:value-of select="@morerows + 1"/>
      <xsl:choose>
        <xsl:when test="not($autowidth)">
          <xsl:text>}{</xsl:text>
          <!-- Only output the contents of this row if it's on the correct -->
          <!-- row -ve width means don't output the cell contents, but maybe -->
          <!-- just output a height spacer. -->
          <xsl:if test="@rowstart != $rownum">
            <xsl:text>-</xsl:text>
          </xsl:if>
          <xsl:text>\newtblcolwidth}{</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>}{*}{</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    
    <!-- Do rotate if required. What to do about line wrapping though?? -->
    <xsl:if test="@rotate and @rotate != 0">
      <xsl:text>\rotatebox{90}{</xsl:text>
    </xsl:if>
    
    <xsl:if test="not($autowidth)">  
      <xsl:choose>
        <xsl:when test="@align = 'left'">
          <xsl:text>\raggedright</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'right'">
          <xsl:text>\raggedleft</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'center'">
          <xsl:text>\centering</xsl:text>
        </xsl:when>
        <xsl:when test="@align = 'justify'"></xsl:when>
        <xsl:when test="@align != ''">
          <xsl:message>Word-wrapped alignment <xsl:value-of 
          select="@align"/> not supported</xsl:message>
        </xsl:when>
      </xsl:choose>
    </xsl:if>  
    
    <!-- Apply some default formatting depending on context -->
    <xsl:choose>
      <xsl:when test="$context = 'thead'">
        <xsl:value-of select="$newtbl.format.thead"/>
      </xsl:when>
      <xsl:when test="$context = 'tbody'">
        <xsl:value-of select="$newtbl.format.tbody"/>
      </xsl:when>
      <xsl:when test="$context = 'tfoot'">
        <xsl:value-of select="$newtbl.format.tfoot"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Unknown context <xsl:value-of select="$context"/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
    
    <!-- Dump out the entry contents -->
    <xsl:if test="$moreprint">
      <xsl:text>%&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="output">
          <xsl:value-of select="output"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="." mode="output"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>%&#10;</xsl:text>
    </xsl:if>
    
    <!-- Close off multirow if required -->
    <xsl:if test="@morerows and @morerows > 0 and $moreprint">
      <xsl:text>}</xsl:text>
    </xsl:if>
    
    <!-- Close off rotate if required -->
    <xsl:if test="@rotate and @rotate != 0">
      <xsl:text>}</xsl:text>
    </xsl:if>
    
    <!-- End of the multicolumn -->
    <xsl:text>}</xsl:text>
    
    <!-- Put in the column separator -->
    <xsl:if test="@colend != $cols">
      <xsl:text>&amp;</xsl:text>
    </xsl:if>
    
  </xsl:if> <!-- colstart > cols -->
  
</xsl:template>


<!-- Process the entry content, and remove spurious empty lines -->
<xsl:template match="entry" mode="output">
  <xsl:call-template name="normalize-border">
    <xsl:with-param name="string">
      <xsl:apply-templates/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>


<!-- Actually build the embedded table like tgroup does -->
<xsl:template match="entrytbl" mode="output">
  <xsl:call-template name="tgroup">
    <xsl:with-param name="tablewidth" select="'\linewidth-2\arrayrulewidth'"/>
    <xsl:with-param name="tableframe" select="'none'"/>
  </xsl:call-template>
</xsl:template>


<!-- Rowsep building using \cline - done within a row -->
<xsl:template name="clines.build">
  <xsl:param name="entries"/>
  <xsl:param name="rownum"/>

  <!-- Store any rowsep for this row -->
  <xsl:variable name="thisrowsep" select="@rowsep"/>

  <xsl:for-each select="$entries/*">
    <!-- Only do rowsep for this col if it's not spanning this row -->
    <xsl:if test="@rowend = $rownum">
      <xsl:variable name="dorowsep">
        <xsl:choose>
          <!-- Entry rowsep override -->
          <xsl:when test="@rowsep">
            <xsl:value-of select="@rowsep"/>
          </xsl:when>
          <!-- Row rowsep override -->
          <xsl:when test="$thisrowsep">
            <xsl:value-of select="$thisrowsep"/>
          </xsl:when>
          <!-- Else use the default for this column -->
          <xsl:otherwise>
            <xsl:value-of select="@defrowsep"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$dorowsep = 1">
        <xsl:text>\cline{</xsl:text>
        <xsl:value-of select="@colstart"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="@colend"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!-- Rowsep building using \hhline - done within a row -->
<xsl:template name="hhline.build">
  <xsl:param name="entries"/>
  <xsl:param name="rownum"/>

  <!-- Store any rowsep for this row -->
  <xsl:variable name="thisrowsep" select="@rowsep"/>

  <xsl:text>\hhline{</xsl:text>
  <xsl:for-each select="$entries/*">
    <xsl:variable name="dorowsep">
      <xsl:choose>
        <!-- Only do rowsep for this col if it's not spanning this row -->
        <xsl:when test="@rowend != $rownum">
          <xsl:value-of select="0"/>
        </xsl:when>
        <!-- Entry rowsep override -->
        <xsl:when test="@rowsep">
          <xsl:value-of select="@rowsep"/>
        </xsl:when>
        <!-- Row rowsep override -->
        <xsl:when test="$thisrowsep">
          <xsl:value-of select="$thisrowsep"/>
        </xsl:when>
        <!-- Else use the default for this column -->
        <xsl:otherwise>
          <xsl:value-of select="@defrowsep"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- hhline separator value -->
    <xsl:variable name="hsep">
      <xsl:choose>
        <xsl:when test="$dorowsep = 1">-</xsl:when>
        <xsl:otherwise>~</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@colstart = @colend">
        <xsl:value-of select="$hsep"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*{</xsl:text>
        <xsl:value-of select="@colend - @colstart + 1"/>
        <xsl:text>}{</xsl:text>
        <xsl:value-of select="$hsep"/>
        <xsl:text>}</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>}</xsl:text>
</xsl:template>


<!-- Process each row in turn -->
<xsl:template match="row" mode="newtbl">
  <xsl:param name="tabletype"/>
  <xsl:param name="rownum"/>
  <xsl:param name="rows"/>
  <xsl:param name="colspec"/>
  <xsl:param name="spanspec"/>
  <xsl:param name="frame"/>
  <xsl:param name="oldentries"><nop/></xsl:param>
  <xsl:param name="rowstack"/>

  <xsl:variable name="picolor">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="processing-instruction('dblatex')"/>
      <xsl:with-param name="attribute" select="'bgcolor'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="rowcolor">
    <xsl:choose>
      <xsl:when test="$picolor!=''">
        <xsl:value-of select="$picolor"/>
      </xsl:when>
      <xsl:when test="ancestor::thead">
        <xsl:value-of select="$newtbl.bgcolor.thead"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

   <!-- Build the entry node-set -->
  <xsl:variable name="entries">
    <xsl:choose>
      <xsl:when test="(entry|entrytbl)[1]">
        <xsl:apply-templates mode="newtbl.buildentries" select="(entry|entrytbl)[1]">
          <xsl:with-param name="colnum" select="1"/>
          <xsl:with-param name="rownum" select="$rownum"/>
          <xsl:with-param name="colspec" select="$colspec"/>
          <xsl:with-param name="spanspec" select="$spanspec"/>
          <xsl:with-param name="frame" select="$frame"/>
          <xsl:with-param name="rowcolor" select="$rowcolor"/>
          <xsl:with-param name="entries" select="exsl:node-set($oldentries)"/>
          <xsl:with-param name="tabletype" select="$tabletype"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="exsl:node-set($oldentries)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Now output each entry -->
  <xsl:variable name="context" select="local-name(..)"/>
  <xsl:variable name="row-output">
    <xsl:if test="$context = 'thead'">
      <xsl:value-of select="$rowstack"/>
    </xsl:if>

    <xsl:if test="$rownum = 1">
      <!-- Need a top line? -->
      <xsl:if test="$frame = 'all' or $frame = 'top' or $frame = 'topbot'">
        <xsl:text>\hline</xsl:text>
      </xsl:if>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>

    <xsl:apply-templates select="exsl:node-set($entries)/*" mode="newtbl">
      <xsl:with-param name="colspec" select="$colspec"/>
      <xsl:with-param name="frame" select="$frame"/>
      <xsl:with-param name="context" select="$context"/>
      <xsl:with-param name="rownum" select="$rownum"/>
    </xsl:apply-templates>
    
    <!-- End this row -->
    <xsl:text>\tabularnewline&#10;</xsl:text>
    
    <!-- Now process rowseps only if not the last row -->
    <xsl:if test="$rownum != $rows">
      <xsl:choose>
      <xsl:when test="$newtbl.use.hhline='1'">
        <xsl:call-template name="hhline.build">
          <xsl:with-param name="entries" select="exsl:node-set($entries)"/>
          <xsl:with-param name="rownum" select="$rownum"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="clines.build">
          <xsl:with-param name="entries" select="exsl:node-set($entries)"/>
          <xsl:with-param name="rownum" select="$rownum"/>
        </xsl:call-template>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <!-- Head rows must be buffered -->
  <xsl:if test="$context != 'thead'">
    <xsl:value-of select="$row-output"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="following-sibling::row[1]">
      <xsl:apply-templates mode="newtbl" select="following-sibling::row[1]">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="rownum" select="$rownum + 1"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="oldentries" select="$entries"/>
        <xsl:with-param name="rowstack" select="$row-output"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$context = 'tfoot'">
    </xsl:when>
    <xsl:otherwise>
      <!-- Ask to table to end the head -->
      <xsl:if test="$context = 'thead'">
        <xsl:apply-templates select="(ancestor::table
                                     |ancestor::informaltable)[last()]"
                             mode="newtbl.endhead">
          <xsl:with-param name="tabletype" select="$tabletype"/>
          <xsl:with-param name="headrows" select="$row-output"/>
        </xsl:apply-templates>
      </xsl:if>

      <xsl:apply-templates mode="newtbl" 
                           select="(../following-sibling::tbody/row)[1]">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="rownum" select="$rownum + 1"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="spanspec" select="$spanspec"/>
        <xsl:with-param name="frame" select="$frame"/>
        <xsl:with-param name="oldentries" select="$entries"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- Calculate column width between two columns -->
<xsl:template name="tbl.colwidth">
  <xsl:param name="col"/>
  <xsl:param name="colend"/>
  <xsl:param name="colspec"/>
  
  <xsl:value-of select="$colspec/colspec[@colnum=$col]/@colwidth"/>
  
  <xsl:if test="$col &lt; $colend">
    <xsl:text>+2\tabcolsep+\arrayrulewidth+</xsl:text>
    <xsl:call-template name="tbl.colwidth">
      <xsl:with-param name="col" select="$col + 1"/>
      <xsl:with-param name="colend" select="$colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="tbl.colwidth2">
  <xsl:param name="col"/>
  <xsl:param name="colend"/>
  <xsl:param name="colspec"/>
  
  <xsl:value-of select="$colspec/colspec[@colnum=$col]/@fixedwidth"/>
  
  <xsl:if test="$col &lt; $colend">
    <xsl:text>+</xsl:text>
    <xsl:call-template name="tbl.colwidth2">
      <xsl:with-param name="col" select="$col + 1"/>
      <xsl:with-param name="colend" select="$colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<xsl:template match="entry|entrytbl" mode="width.colfmt">
  <xsl:param name="colspec"/>
  <xsl:param name="color"/>
  <xsl:param name="rsep"/>

  <!-- Color in pre-command -->
  <xsl:if test="$color != ''">
    <xsl:value-of select="concat('>{',$color,'}')"/>
  </xsl:if>

  <!-- Get the column width -->
  <xsl:variable name="width">
    <xsl:call-template name="tbl.colwidth">
      <xsl:with-param name="col" select="@colstart"/>
      <xsl:with-param name="colend" select="@colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
    <xsl:if test="$rsep = ''">
      <xsl:text>+\arrayrulewidth</xsl:text>
    </xsl:if>
    <xsl:if test="@coloff = 0">
      <xsl:text>+2\tabcolsep</xsl:text>
    </xsl:if>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="@valign = 'top'">
      <xsl:text>p</xsl:text>
    </xsl:when>
    <xsl:when test="@valign = 'bottom'">
      <xsl:text>b</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>m</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$width"/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="entry|entrytbl" mode="widthx.colfmt">
  <xsl:param name="colspec"/>
  <xsl:param name="color"/>

  <xsl:variable name="stars" 
                select="sum(exsl:node-set($colspec)/colspec
                            [@colnum &gt;= current()/@colstart and 
                             @colnum &lt;= current()/@colend]/@star)"/>

  <!-- Get the column fixed width part -->
  <xsl:variable name="width">
    <xsl:call-template name="tbl.colwidth2">
      <xsl:with-param name="col" select="@colstart"/>
      <xsl:with-param name="colend" select="@colend"/>
      <xsl:with-param name="colspec" select="$colspec"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$stars = 0">
    <xsl:if test="$color != ''">
      <xsl:value-of select="concat('>{',$color,'}')"/>
    </xsl:if>
    <!-- Only a fixed width -->
    <xsl:choose>
      <xsl:when test="@valign = 'top'">
        <xsl:text>p</xsl:text>
      </xsl:when>
      <xsl:when test="@valign = 'bottom'">
        <xsl:text>b</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>m</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$width"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>>{</xsl:text>
    <xsl:value-of select="$color"/>
    <xsl:text>\setlength\hsize{</xsl:text>
    <xsl:if test="$width != ''">
      <xsl:value-of select="$width"/>
      <xsl:text>+</xsl:text>
    </xsl:if>
    <xsl:value-of select="$stars"/>
    <xsl:text>\hsize}}X</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Convert a frame tag to a CALS frame equivalent -->
<xsl:template name="cals.frame">
  <xsl:param name="frame"/>

  <xsl:choose>
  <xsl:when test="$frame='void'">none</xsl:when>
  <xsl:when test="$frame='above'">top</xsl:when>
  <xsl:when test="$frame='below'">bottom</xsl:when>
  <xsl:when test="$frame='hsides'">topbot</xsl:when>
  <xsl:when test="$frame='vsides'">sides</xsl:when>
  <xsl:when test="$frame='box'">all</xsl:when>
  <xsl:when test="$frame='border'">all</xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$frame"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Generate a latex column specifier, possibly surrounded by '|' -->
<xsl:template match="entry|entrytbl" mode="tbl.colfmt">
  <xsl:param name="frame"/>
  <xsl:param name="colspec"/>
  <xsl:param name="autowidth"/>
  
  <xsl:variable name="cols" select="count($colspec/*)"/>

  <!-- Need a colsep to the left? - only if first column and frame says so -->
  <xsl:if test="@colstart = 1 and ($frame = 'all' or $frame = 'sides')">
    <xsl:text>|</xsl:text>
  </xsl:if>

  <!-- Need a colsep to the right? - only if last column and frame says -->
  <!-- so, or we are not the last column and colsep says so  -->
  <xsl:variable name="rsep">
    <xsl:if test="(@colend = $cols and ($frame = 'all' or $frame = 'sides')) or 
                  (@colend != $cols and @colsep = 1)">
      <xsl:text>|</xsl:text>
    </xsl:if>
  </xsl:variable>

  <!-- Remove the offset between column and cell content? -->
  <xsl:if test="@coloff = 0">
    <xsl:text>@{}</xsl:text>
  </xsl:if>

  <!-- Column color? -->
  <xsl:variable name="color">
    <xsl:if test="@bgcolor != ''">
      <xsl:text>\columncolor</xsl:text>
      <xsl:call-template name="get-color">
        <xsl:with-param name="color" select="@bgcolor"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>
  
  <xsl:choose>
  <xsl:when test="not($autowidth)">
    <xsl:choose>
    <xsl:when test="@tabletype = 'tabularx'">
      <xsl:apply-templates select="." mode="widthx.colfmt">
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="color" select="$color"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="width.colfmt">
        <xsl:with-param name="colspec" select="$colspec"/>
        <xsl:with-param name="color" select="$color"/>
        <xsl:with-param name="rsep" select="$rsep"/>
      </xsl:apply-templates>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="$color != ''">
      <xsl:value-of select="concat('>{',$color,'}')"/>
    </xsl:if>
    <xsl:choose>
      <xsl:when test="@align = 'left'">l</xsl:when>
      <xsl:when test="@align = 'right'">r</xsl:when>
      <xsl:when test="@align = 'center'">c</xsl:when>
      <xsl:otherwise>c</xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
  
  <xsl:if test="@coloff = 0">
    <xsl:text>@{}</xsl:text>
  </xsl:if>

  <xsl:value-of select="$rsep"/>
</xsl:template>


<xsl:template name="table.width">
  <xsl:param name="fullwidth"/>
  <xsl:param name="exclude"/>

  <xsl:variable name="piwidth">
    <xsl:call-template name="pi-attribute">
      <xsl:with-param name="pis" select="../processing-instruction('dblatex')"/>
      <xsl:with-param name="attribute" select="'table-width'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- precedence between table-widths specifications -->
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="$piwidth != '' and
                      ($exclude='' or not(contains($piwidth,$exclude)))">
        <xsl:value-of select="$piwidth"/>
      </xsl:when>
      <xsl:when test="(@width or ../@width) and
                      ($exclude='' or not(contains(../@width,$exclude)))">
        <xsl:value-of select="(@width|../@width)[last()]"/>
      </xsl:when>
      <xsl:when test="$default.table.width != '' and
                      ($exclude='' or
                      not(contains($default.table.width,$exclude)))">
        <xsl:value-of select="$default.table.width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$fullwidth"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- convert percentage to real width -->
  <xsl:choose>
    <xsl:when test="contains($width, '%')">
      <xsl:value-of select="number(substring-before($width, '%')) div 100"/>
      <xsl:value-of select="$fullwidth"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$width"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


<xsl:template name="tbl.sizes">
  <xsl:param name="colspec"/>
  <xsl:param name="width"/>

  <!-- Now get latex to calculate the 'spare' width of the table -->
  <!-- (Table width - widths of all specified columns - gaps between columns)-->
  <xsl:text>\setlength{\newtblsparewidth}{</xsl:text>
  <xsl:value-of select="$width"/>
  <xsl:for-each select="$colspec/*">
    <xsl:if test="@fixedwidth">
      <xsl:text>-</xsl:text>
      <xsl:value-of select="translate(@fixedwidth,'+','-')"/>
    </xsl:if>
    <xsl:text>-2\tabcolsep</xsl:text>
  </xsl:for-each>
  <xsl:text>}%&#10;</xsl:text>
  
  <!-- Now get latex to calculate widths of cols with starred colwidths -->
  
  <xsl:variable name="numunknown" 
                select="sum($colspec/colspec/@star)"/>
  <!-- If we have at least one such col, then work out how wide it should -->
  <!-- be -->
  <xsl:if test="$numunknown &gt; 0">
    <xsl:text>\setlength{\newtblstarfactor}{\newtblsparewidth / \real{</xsl:text>
    <xsl:value-of select="$numunknown"/>
    <xsl:text>}}%&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- tabularx vertical alignment setup, global to the whole table -->
<xsl:template name="tbl.valign.x">
  <xsl:param name="valign"/>

  <xsl:variable name="valign.param">
    <xsl:choose>
    <xsl:when test="$valign = 'top'"><xsl:text>p</xsl:text></xsl:when>
    <xsl:when test="$valign = 'bottom'"><xsl:text>b</xsl:text></xsl:when>
    <!-- default vertical alignment -->
    <xsl:otherwise><xsl:text>m</xsl:text></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>\def\tabularxcolumn#1{</xsl:text>
  <xsl:value-of select="$valign.param"/>
  <xsl:text>{#1}}</xsl:text>
</xsl:template>


<xsl:template name="tbl.begin">
  <xsl:param name="colspec"/>
  <xsl:param name="tabletype"/>
  <xsl:param name="width"/>

  <xsl:text>\begin{</xsl:text>
  <xsl:value-of select="$tabletype"/>
  <xsl:text>}</xsl:text>

  <xsl:choose>
  <xsl:when test="$tabletype = 'tabularx'">
    <xsl:text>{</xsl:text>
    <xsl:value-of select="$width"/>
    <xsl:text>}{</xsl:text>
    <xsl:for-each select="$colspec/*">
      <xsl:choose>
      <xsl:when test="@star">
        <xsl:text>&gt;{\hsize=</xsl:text>
        <xsl:if test="@fixedwidth">
          <xsl:value-of select="@fixedwidth"/>
          <xsl:text>+</xsl:text>
        </xsl:if>
        <xsl:value-of select="@star"/>
        <xsl:text>\hsize}X</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>l</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>{</xsl:text>
    <!-- The initial column definition -->
    <xsl:for-each select="$colspec/*">
      <xsl:text>l</xsl:text>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- The main starting point of the table handling -->
<xsl:template match="tgroup" mode="newtbl" name="tgroup">
  <xsl:param name="tabletype">tabular</xsl:param>
  <xsl:param name="tablewidth">\linewidth-2\tabcolsep</xsl:param>
  <xsl:param name="tableframe">all</xsl:param>

  <!-- First, save the table verbatim data, but only at tgroup level -->
  <xsl:if test="not(self::entrytbl)">
    <xsl:apply-templates mode="save.verbatim"/>
  </xsl:if>
  <xsl:text>\begingroup%&#10;</xsl:text>

  <!-- Set cellpadding -->
  <xsl:if test="../@cellpadding">
    <xsl:text>\setlength{\tabcolsep}{</xsl:text>
    <xsl:value-of select="../@cellpadding"/>
    <xsl:text>}%&#10;</xsl:text>
  </xsl:if>

  <!-- Get the number of columns -->
  <xsl:variable name="cols">
    <xsl:choose>
      <xsl:when test="@cols">
        <xsl:value-of select="@cols"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(tbody/row[1]/*[self::entry or
                              self::entrytbl])"/>
        <xsl:message>Warning: table's tgroup lacks cols attribute. 
        Assuming <xsl:value-of select="count(tbody/row[1]/*)"/>.
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Get the number of rows -->
  <xsl:variable name="rows" select="count(*/row)"/>
  
  <xsl:if test="$rows = 0">
    <xsl:message>Warning: 0 rows</xsl:message>
  </xsl:if>

  <!-- Get the specified table width -->
  <xsl:variable name="table.width">
    <xsl:call-template name="table.width">
      <xsl:with-param name="fullwidth" select="$tablewidth"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Find the table width -->
  <xsl:variable name="width">
    <xsl:choose>
      <xsl:when test="not(contains($table.width,'auto'))">
        <xsl:value-of select="$table.width"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="table.width">
          <xsl:with-param name="fullwidth" select="$tablewidth"/>
          <xsl:with-param name="exclude" select="'auto'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Get the autowidth option -->
  <xsl:variable name="autowidth">
    <xsl:choose>
      <xsl:when test="contains($table.width,'auto')">
        <!-- Expect something like 'autowidth.all' or 'autowidth.default' -->
        <xsl:value-of select="$table.width"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$newtbl.autowidth"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Get default align -->
  <xsl:variable name="align" 
                select="@align|parent::node()[not(*/@align)]/@align"/>
  
  <!-- Get default colsep -->
  <xsl:variable name="colsep" 
                select="@colsep|parent::node()[not(*/@colsep)]/@colsep"/>
  
  <!-- Get default rowsep -->
  <xsl:variable name="rowsep" 
                select="@rowsep|parent::node()[not(*/@rowsep)]/@rowsep"/>
  
  <!-- Now the frame style -->
  <xsl:variable name="frame">
    <xsl:choose>
      <xsl:when test="../@frame">
        <xsl:value-of select="../@frame"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$tableframe"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- Build up a complete colspec for each column -->
  <xsl:variable name="colspec">
    <xsl:call-template name="tbl.colspec">
      <xsl:with-param name="autowidth" select="$autowidth"/>
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rowsep">
        <xsl:choose>
          <xsl:when test="$rowsep"><xsl:value-of select="$rowsep"/>
          </xsl:when>
          <xsl:when test="$newtbl.default.rowsep">
            <xsl:value-of select="$newtbl.default.rowsep"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="colsep">
        <xsl:choose>
          <xsl:when test="$colsep"><xsl:value-of select="$colsep"/>
          </xsl:when>
          <xsl:when test="$newtbl.default.colsep">
            <xsl:value-of select="$newtbl.default.colsep"/>
          </xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="align">
        <xsl:choose>
          <xsl:when test="$align"><xsl:value-of select="$align"/>
          </xsl:when>
          <xsl:otherwise>left</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  
  <!-- Get all the spanspecs as an RTF -->
  <xsl:variable name="spanspec" select="spanspec"/>

  <xsl:if test="$tabletype != 'tabularx'">
    <xsl:call-template name="tbl.sizes">
      <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
      <xsl:with-param name="width" select="$width"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:if test="$tabletype = 'tabularx'">
    <xsl:call-template name="tbl.valign.x">
      <xsl:with-param name="valign" select="tbody/@valign"/>
    </xsl:call-template>
  </xsl:if>
  
  <!-- Start the next table on a new line -->
  <xsl:if test="preceding::tgroup">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  
  <!-- Start the table declaration -->
  <xsl:call-template name="tbl.begin">
    <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="width" select="$width"/>
  </xsl:call-template>

  <xsl:if test="not(thead)">
    <xsl:apply-templates select="(ancestor::table
                                 |ancestor::informaltable)[last()]"
                         mode="newtbl.endhead">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:apply-templates>
  </xsl:if>
 
  <!-- Go through each row, starting with the header -->
  <xsl:apply-templates mode="newtbl" select="((thead|tbody)/row)[1]">
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="rownum" select="1"/>
    <xsl:with-param name="rows" select="$rows"/>
    <xsl:with-param name="frame" select="$frame"/>
    <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
    <xsl:with-param name="spanspec" select="exsl:node-set($spanspec)"/>
  </xsl:apply-templates>

  <!-- Go through each footer row -->
  <xsl:apply-templates mode="newtbl" select="tfoot/row[1]">
    <xsl:with-param name="tabletype" select="$tabletype"/>
    <xsl:with-param name="rownum" select="count(thead/row|tbody/row)+1"/>
    <xsl:with-param name="rows" select="$rows"/>
    <xsl:with-param name="frame" select="$frame"/>
    <xsl:with-param name="colspec" select="exsl:node-set($colspec)"/>
    <xsl:with-param name="spanspec" select="exsl:node-set($spanspec)"/>
  </xsl:apply-templates>

  <!-- Need a bottom line? -->
  <xsl:if test="$frame = 'all' or $frame = 'bottom' or $frame = 'topbot'">
    <xsl:text>\hline</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  
  <xsl:text>\end{</xsl:text>
  <xsl:value-of select="$tabletype"/>
  <xsl:text>}\endgroup%&#10;</xsl:text>
</xsl:template>


<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################
    
    This stylesheet allows to setup paper and page dimensions through some
    predefined parameters. Most of the page setup parameters come from the
    DocBook XSL FO parameters. The latex packages used to perform this setup
    are the well known 'geometry' and 'crop'.

    This feature has been sponsored by Freexian (http://www.freexian.com).
    
-->
<xsl:param name="page.height"/>
<xsl:param name="page.margin.bottom"/>
<xsl:param name="page.margin.inner"/>
<xsl:param name="page.margin.outer"/>
<xsl:param name="page.margin.top"/>
<xsl:param name="page.width"/>
<xsl:param name="paper.type"/>
<xsl:param name="geometry.options"/>
<xsl:param name="crop.marks" select="0"/>
<xsl:param name="crop.paper.type"/>
<xsl:param name="crop.page.width"/>
<xsl:param name="crop.page.height"/>
<xsl:param name="crop.mode" select="'cam'"/>
<xsl:param name="crop.options"/>

<xsl:template name="page.setup">

  <xsl:variable name="geometry.setup">
    <geometry paperwidth="{$page.width}"
              paperheight="{$page.height}"
              papername="{$paper.type}"
              right="{$page.margin.outer}"
              left="{$page.margin.inner}"
              top="{$page.margin.top}"
              bottom="{$page.margin.bottom}"/>
  </xsl:variable>

  <xsl:variable name="geometry.params">
    <xsl:for-each select="exsl:node-set($geometry.setup)//@*">
      <xsl:if test=". != ''">
        <xsl:value-of select="local-name()"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="$geometry.options"/>
  </xsl:variable>

  <!-- The body includes the header and footer -->
  <xsl:if test="$geometry.params != ''">
    <xsl:text>\usepackage[includeheadfoot,</xsl:text> 
    <xsl:value-of select="$geometry.params"/>
    <xsl:text>]{geometry}&#10;</xsl:text> 
  </xsl:if>

  <xsl:if test="$crop.marks != 0">
    <xsl:variable name="crop.params">
      <xsl:choose>
      <xsl:when test="$crop.paper.type != ''">
        <xsl:value-of select="$crop.paper.type"/>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:when test="$crop.page.width != '' and
                      $crop.page.height != ''">
        <!-- No 'true' length, assuming no scaling -->
        <xsl:text>width=</xsl:text>
        <xsl:value-of select="$crop.page.width"/>
        <xsl:text>,</xsl:text>
        <xsl:text>height=</xsl:text>
        <xsl:value-of select="$crop.page.height"/>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Warning: crop required without crop size setup</xsl:text>
        </xsl:message>
      </xsl:otherwise>

      <!-- FIXME: find out how to use crop.margin. The following fails:
      <xsl:otherwise>
        <xsl:text>width=\pagewidth</xsl:text>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>,</xsl:text>
        <xsl:text>height=\pageheight</xsl:text>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>+</xsl:text>
        <xsl:value-of select="$crop.margin"/>
        <xsl:text>,</xsl:text>
      </xsl:otherwise>
      -->
      </xsl:choose>
      <xsl:value-of select="$crop.options"/>
    </xsl:variable>

    <xsl:if test="$crop.params != ''">
      <xsl:text>\usepackage[</xsl:text> 
      <xsl:value-of select="$crop.params"/>
      <xsl:text>center,</xsl:text>
      <xsl:value-of select="$crop.mode"/>
      <xsl:text>]{crop}&#10;</xsl:text> 
    </xsl:if>
  </xsl:if>

</xsl:template>

<!-- Unit-test cases:
     dblatex -P paper.type=a5paper
             -P page.margin.outer=1cm
             -P page.margin.inner=3cm pagesetup.xml

     dblatex -P paper.type=a5paper
             -P page.margin.outer=1cm
             -P page.margin.inner=3cm
             -P crop.marks=1
             -P crop.paper.type=a4 pagesetup.xml

     dblatex -P page.width=18.89cm
             -P page.height=24.58cm
             -P page.margin.outer=1cm
             -P page.margin.inner=3cm
             -P crop.marks=1 
             -P crop.page.width=21cm
             -P crop.page.height=29.7cm pagesetup.xml
-->



<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="para|simpara">
  <xsl:text>&#10;</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="formalpara">
  <xsl:text>&#10;{\bf </xsl:text>
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="title"/>
  </xsl:call-template>
  <xsl:text>} </xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="formalpara/title"></xsl:template>


<!--========================================================================== 
 |  Especial Cases Do not add Linefeed 
 +============================================================================-->

<xsl:template match="listitem/para|step/para|entry/para
                    |listitem/simpara|step/simpara|entry/simpara">
  <xsl:if test="preceding-sibling::*">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="textobject/para"> <xsl:apply-templates/> </xsl:template>
<xsl:template match="question/para"> <xsl:apply-templates/> </xsl:template>
<xsl:template match="answer/para"> <xsl:apply-templates/> </xsl:template>

<!--===============
 |  Miscellaneous
 +================= -->

<xsl:template match="ackno">
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>


<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!-- "Latex" parameters -->

<xsl:param name="latex.hyperparam"/>
<xsl:param name="latex.style">docbook</xsl:param>
<xsl:param name="latex.biblio.output">all</xsl:param>
<xsl:param name="latex.biblio.style"/>
<xsl:param name="latex.bibfiles">''</xsl:param>
<xsl:param name="latex.bibwidelabel">WIDELABEL</xsl:param>
<xsl:param name="latex.output.revhistory">1</xsl:param>
<xsl:param name="latex.babel.use">1</xsl:param>
<xsl:param name="latex.babel.language"/>
<xsl:param name="latex.class.options"/>
<xsl:param name="latex.class.article">article</xsl:param>
<xsl:param name="latex.class.book">report</xsl:param>
<xsl:param name="latex.index.tool"/>
<xsl:param name="latex.index.language"/>
<xsl:param name="latex.unicode.use">0</xsl:param>
<xsl:param name="texlive.version">2009</xsl:param>

<!-- Default behaviour setting -->

<xsl:param name="biblioentry.item.separator">, </xsl:param>
<xsl:param name="refentry.xref.manvolnum" select="1"/>
<xsl:param name="funcsynopsis.style">ansi</xsl:param>
<xsl:param name="funcsynopsis.decoration" select="1"/>
<xsl:param name="function.parens">0</xsl:param>
<xsl:param name="classsynopsis.default.language">java</xsl:param>
<xsl:param name="show.comments" select="1"/>
<xsl:param name="glossterm.auto.link" select="0"/>
<xsl:param name="pdf.annot.options"/>
<xsl:param name="output.quietly" select="0"/>

<!-- "Common" parameters -->

<xsl:param name="author.othername.in.middle" select="1"/>
<xsl:param name="section.label.includes.component.label" select="0"/>
<xsl:param name="component.label.includes.part.label" select="0"/>
<xsl:param name="label.from.part" select="0"/>
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="preface.autolabel" select="0"/>
<xsl:param name="part.autolabel" select="1"/>
<xsl:param name="appendix.autolabel" select="1"/>
<xsl:param name="qandadiv.autolabel" select="1"/>
<xsl:param name="qanda.inherit.numeration" select="1"/>
<xsl:param name="graphic.default.extension"/>
<xsl:param name="make.single.year.ranges" select="0"/>
<xsl:param name="make.year.ranges" select="0"/>
<xsl:param name="l10n.gentext.language" select="''"/>
<xsl:param name="l10n.gentext.default.language" select="'en'"/>
<xsl:param name="l10n.gentext.use.xref.language" select="0"/>
<xsl:param name="section.autolabel.max.depth" select="8"/>
<xsl:param name="xref.label-page.separator"><xsl:text> </xsl:text></xsl:param>
<xsl:param name="xref.label-title.separator">: </xsl:param>
<xsl:param name="xref.title-page.separator"><xsl:text> </xsl:text></xsl:param>
<xsl:param name="xref.with.number.and.title" select="0"/>
<xsl:param name="insert.xref.page.number">maybe</xsl:param>
<xsl:param name="punct.honorific" select="'.'"/>
<xsl:param name="use.id.as.filename" select="0"/>

<xsl:param name="target.database.document" select="''"/>
<xsl:param name="targets.filename" select="'target.db'"/>
<xsl:param name="use.local.olink.style" select="0"/> 
<xsl:param name="olink.doctitle" select="'yes'"/> 
<xsl:param name="olink.base.uri" select="''"/> 
<xsl:param name="olink.debug" select="0"/>
<xsl:param name="olink.lang.fallback.sequence" select="''"/> 
<xsl:param name="prefer.internal.olink" select="0"/>
<xsl:param name="insert.olink.page.number">yes</xsl:param>
<xsl:param name="insert.olink.pdf.frag" select="1"/>
<xsl:param name="current.docid"/>

<xsl:param name="ulink.footnotes" select="0"/>
<xsl:param name="ulink.show" select="0"/>

<xsl:variable name="latex.book.afterauthor">
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
  <xsl:text>\makeindex&#10;</xsl:text>
  <xsl:text>\makeglossary&#10;</xsl:text>
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
</xsl:variable>

<xsl:variable name="latex.book.begindocument">
  <xsl:text>\begin{document}&#10;</xsl:text>
</xsl:variable>

<xsl:variable name="latex.book.end">
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
  <xsl:text>% End of document&#10;</xsl:text>
  <xsl:text>% --------------------------------------------&#10;</xsl:text>
  <xsl:text>\end{document}&#10;</xsl:text>
</xsl:variable>






<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="part">
  <xsl:text>%&#10;</xsl:text>
  <xsl:text>% PART&#10;</xsl:text>
  <xsl:text>%&#10;</xsl:text>
  <xsl:call-template name="mapheading"/>
  <xsl:apply-templates/>
  <!-- Force exiting the part. It assumes the bookmark package available -->
  <xsl:if test="not(following-sibling::part)">
    <xsl:text>\bookmarksetup{startatroot}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="part/docinfo"/>
<xsl:template match="part/title"/>
<xsl:template match="part/subtitle"/>

<xsl:template match="partintro">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="partintro/title"/>
<xsl:template match="partintro/subtitle"/>
<xsl:template match="partintro/titleabbrev"/>




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




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:variable name="latex.use.hyperref">0</xsl:variable>
<xsl:param name="doc.section.depth">5</xsl:param>
<xsl:param name="toc.section.depth">5</xsl:param>
<xsl:param name="doc.pdfcreator.show">1</xsl:param>
<xsl:param name="doc.publisher.show">0</xsl:param>
<xsl:param name="doc.collab.show">1</xsl:param>
<xsl:param name="doc.alignment"/>
<xsl:param name="doc.layout">coverpage toc frontmatter mainmatter index</xsl:param>
<xsl:param name="draft.mode">maybe</xsl:param>
<xsl:param name="draft.watermark">1</xsl:param>


<xsl:variable name="latex.begindocument">
  <xsl:text>\begin{document}&#10;</xsl:text>
</xsl:variable>

<xsl:variable name="latex.enddocument">
  <xsl:text>&#10;\end{document}&#10;</xsl:text>
</xsl:variable>

<xsl:variable name="frontmatter" select="'\frontmatter&#10;'"/>
<xsl:variable name="mainmatter" select="'\mainmatter&#10;'"/>
<xsl:variable name="backmatter" select="'\backmatter&#10;'"/>

<xsl:template match="book|article" mode="preamble">
  <xsl:param name="lang"/>
  <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>

  <xsl:text>% -----------------------------------------  &#10;</xsl:text>
  <xsl:text>% Autogenerated LaTeX file from XML DocBook  &#10;</xsl:text>
  <xsl:text>% -----------------------------------------  &#10;</xsl:text>
  <!-- Parameters to pass to python parser -->
  <xsl:call-template name="py.params.set"/>
  <xsl:text>\documentclass</xsl:text>
  <xsl:if test="$latex.class.options!=''">
    <xsl:value-of select="concat('[',$latex.class.options,']')"/>
  </xsl:if>
  <xsl:text>{</xsl:text>
  <xsl:choose>
    <xsl:when test="self::book">
      <xsl:value-of select="$latex.class.book"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$latex.class.article"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>

  <xsl:variable name="external.docs">
    <xsl:call-template name="make.external.docs"/>
  </xsl:variable>
  
  <xsl:call-template name="encode.before.style">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:text>\usepackage{fancybox}&#10;</xsl:text>
  <xsl:text>\usepackage{makeidx}&#10;</xsl:text>

  <xsl:call-template name="user.params.set"/>
  <!-- Load babel before the style (bug #babel/3875) -->
  <xsl:call-template name="babel.setup"/>

  <!-- Load xr before hyperref -->
  <xsl:if test="$external.docs != ''">
    <xsl:text>\usepackage{xr-hyper}&#10;</xsl:text>
  </xsl:if>

  <!-- Paper and Page setup -->
  <xsl:call-template name="page.setup"/>

  <xsl:text>\usepackage[hyperlink]{</xsl:text>
  <xsl:value-of select="$latex.style"/>
  <xsl:text>}&#10;</xsl:text>

  <xsl:call-template name="encode.after.style">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:call-template name="lang.setup"/>
  <xsl:call-template name="image.setup"/>
  <xsl:call-template name="citation.setup"/>
  <xsl:call-template name="biblio.setup"/>
  <xsl:call-template name="annotation.setup"/>
  <xsl:call-template name="user.params.set2"/>
  <xsl:call-template name="inline.setup"/>
  <xsl:apply-templates select="." mode="docinfo"/>

  <!-- Document title -->
  <xsl:variable name="title">
    <xsl:apply-templates select="(title
                                 |info/title
                                 |bookinfo/title
                                 |articleinfo/title
                                 |artheader/title)[1]" mode="coverpage"/>
  </xsl:variable>

  <!-- Get the Authors -->
  <xsl:variable name="authors">
    <xsl:if test="$info">
      <xsl:choose>
        <xsl:when test="$info/authorgroup/author">
          <xsl:apply-templates select="$info/authorgroup"/>
        </xsl:when>
        <xsl:when test="$info/author">
          <xsl:call-template name="person.name.list">
            <xsl:with-param name="person.list" select="$info/author"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:variable>

  <xsl:text>\title{</xsl:text>
  <xsl:value-of select="$title"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:text>\author{</xsl:text>
  <xsl:value-of select="$authors"/>
  <xsl:text>}&#10;</xsl:text>

  <!-- Fill the PDF metadata -->
  <xsl:call-template name="pdf-document-information">
    <xsl:with-param name="pdfauthor" select="$authors"/>
  </xsl:call-template>

  <!-- The external documents -->
  <xsl:if test="$external.docs != ''">
    <xsl:value-of select="$external.docs"/>
  </xsl:if>

  <!-- Set the collaborator table -->
  <xsl:call-template name="collab.setup">
    <xsl:with-param name="authors" select="$authors"/>
  </xsl:call-template>

  <xsl:text>\makeindex&#10;</xsl:text>
  <xsl:text>\makeglossary&#10;</xsl:text>

  <!-- Apply the revision history here -->
  <xsl:apply-templates select="$info/revhistory"/>

  <xsl:call-template name="verbatim.setup"/>
</xsl:template>

<!-- FIXME: currently does nothing more than default rendering -->
<xsl:template match="title" mode="coverpage">
  <xsl:apply-templates/>
</xsl:template>


<!-- ##################################
     # Preamble setup from parameters #
     ################################## -->

<!-- Setup from the user parameters -->
<xsl:template name="user.params.set">
  <xsl:if test="$latex.hyperparam!=''">
    <xsl:text>\def\hyperparam{</xsl:text>
    <xsl:value-of select="$latex.hyperparam"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$doc.publisher.show='1'">
    <xsl:text>\def\DBKpublisher{</xsl:text>
    <xsl:text>\includegraphics{dblatex}</xsl:text>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$literal.layout.options">
    <xsl:text>\def\lstparamset{\lstset{</xsl:text>
    <xsl:value-of select="$literal.layout.options"/>
    <xsl:text>}}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$doc.alignment!='' and $doc.alignment!='justify'">
    <xsl:text>\usepackage{ragged2e}&#10;</xsl:text>
    <xsl:choose>
    <xsl:when test="$doc.alignment='center'">
      <xsl:text>\Centering&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$doc.alignment='left'">
      <xsl:text>\RaggedRight&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$doc.alignment='right'">
      <xsl:text>\RaggedLeft&#10;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Unknown doc.alignment='<xsl:value-of
      select="$doc.alignment"/>'</xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<!-- Setup to do when the docbook package is loaded -->
<xsl:template name="user.params.set2">
  <xsl:if test="$pdf.annot.options">
    <xsl:text>\commentsetup{</xsl:text>
    <xsl:value-of select="$pdf.annot.options"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>

  <xsl:variable name="draft">
    <xsl:choose>
    <xsl:when test="$draft.mode='yes'">1</xsl:when>
    <xsl:when test="$draft.mode='no'">0</xsl:when>
    <xsl:when test="$draft.mode='maybe' and
                    @status and @status='draft'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$draft='0'">
      <xsl:text>\renewcommand{\DBKreleaseinfo}{}&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$draft.watermark!='0'">
      <xsl:text>\showwatermark{</xsl:text>
      <!--
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'Draft'"/>
      </xsl:call-template>
      -->
      <xsl:text>DRAFT</xsl:text>
      <xsl:text>}&#10;</xsl:text>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="$latex.output.revhistory=0">
    <xsl:text>\renewcommand{\DBKrevhistory}{}&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\setcounter{tocdepth}{</xsl:text>
  <xsl:value-of select="$toc.section.depth"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:text>\setcounter{secnumdepth}{</xsl:text>
  <xsl:value-of select="$doc.section.depth"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<!-- #################
     # Collaborators #
     ################# -->

<xsl:template name="collab.setup">
  <xsl:param name="authors"/>
  <xsl:choose>
  <xsl:when test="$doc.collab.show!='0'">
    <xsl:text>% ------------------
% Collaborators
% ------------------
\renewcommand{\DBKindexation}{
\begin{DBKindtable}
\DBKinditem{\writtenby}{</xsl:text>
    <xsl:value-of select="$authors"/>
    <xsl:text>}</xsl:text>
    <xsl:apply-templates select=".//othercredit" mode="collab"/>
    <xsl:text>&#10;\end{DBKindtable}&#10;}&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>\renewcommand{\DBKindexation}{}&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="othercredit" mode="collab">
  <xsl:text>\DBKinditem{</xsl:text>
  <xsl:value-of select="contrib"/>
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates select="firstname"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="surname"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<!-- ########################
     # Document infos setup #
     ######################## -->

<xsl:template match="book|article" mode="docinfo">
  <xsl:apply-templates select="bookinfo|articleinfo|info" mode="docinfo"/>

  <!-- Override the infos if specified in the root element -->
  <xsl:apply-templates select="subtitle" mode="docinfo"/>
</xsl:template>

<xsl:template match="bookinfo|articleinfo|info" mode="docinfo">
  <!-- special case for copyrights, managed as a group -->
  <xsl:if test="copyright">
    <xsl:text>\def\DBKcopyright{</xsl:text>
    <xsl:apply-templates select="copyright" mode="titlepage.mode"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="docinfo"/>
</xsl:template>

<xsl:template match="*" mode="docinfo"/>

<xsl:template match="address" mode="docinfo">
  <xsl:text>\renewcommand{\DBKsite}{</xsl:text>
  <xsl:variable name="content"><xsl:apply-templates/></xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="releaseinfo" mode="docinfo">
  <xsl:variable name="draft">
    <xsl:choose>
    <xsl:when test="$draft.mode='yes'">1</xsl:when>
    <xsl:when test="$draft.mode='no'">0</xsl:when>
    <xsl:when test="$draft.mode='maybe' and
                  ancestor-or-self::*[@status][1]/@status='draft'">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$draft='1'">
    <xsl:text>\renewcommand{\DBKreleaseinfo}{</xsl:text>
    <xsl:apply-templates select="."/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="pubdate" mode="docinfo">
  <xsl:text>\renewcommand{\DBKpubdate}{</xsl:text>
  <xsl:variable name="content"><xsl:apply-templates/></xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="pubsnumber" mode="docinfo">
  <xsl:text>\renewcommand{\DBKreference}{</xsl:text>
  <xsl:variable name="content"><xsl:apply-templates/></xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<!-- For backward compatibility, used only if pubsnumber not used -->
<xsl:template match="biblioid[not(parent::*/pubsnumber)]" mode="docinfo">
  <xsl:text>\renewcommand{\DBKreference}{</xsl:text>
  <xsl:variable name="content"><xsl:apply-templates/></xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="edition" mode="docinfo">
  <xsl:text>\renewcommand{\DBKedition}{</xsl:text>
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="date" mode="docinfo">
  <!-- Override the date definition if specified -->
  <xsl:text>\renewcommand{\DBKdate}{</xsl:text>
  <xsl:variable name="content"><xsl:apply-templates/></xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="subtitle" mode="docinfo">
  <xsl:text>\def\DBKsubtitle{</xsl:text>
  <xsl:call-template name="normalize-scape">
    <xsl:with-param name="string" select="."/>
  </xsl:call-template>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="releaseinfo">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="holder" mode="titlepage.mode">
  <xsl:apply-templates/>
  <xsl:if test="position() &lt; last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="copyright" mode="titlepage.mode">
  <xsl:text>\noindent </xsl:text>
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Copyright'"/>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat">copyright</xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="copyright.years">
    <xsl:with-param name="years" select="year"/>
    <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
    <xsl:with-param name="single.year.ranges"
                    select="$make.single.year.ranges"/>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:apply-templates select="holder" mode="titlepage.mode"/>
  <xsl:if test="following-sibling::copyright">
    <xsl:text>\par&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- #################
     # Main template #
     ################# -->

<!-- A DocBook subset does not contain coverpage and so on,
     so use a minimal layout
-->
<xsl:template match="book|article" mode="wrapper">
  <xsl:apply-templates select=".">
    <xsl:with-param name="layout">
      <xsl:if test="contains(concat($doc.layout, ' '), 'index ')">
        <xsl:text>index </xsl:text>
      </xsl:if>
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="book|article">
  <xsl:param name="layout" select="concat($doc.layout, ' ')"/>

  <xsl:variable name="info" select="bookinfo|articleinfo|artheader|info"/>
  <xsl:variable name="lang">
    <xsl:call-template name="l10n.language">
      <xsl:with-param name="target" select="(/set|/book|/article)[1]"/>
      <xsl:with-param name="xref-context" select="true()"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Latex preamble -->
  <xsl:apply-templates select="." mode="preamble">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:apply-templates>

  <xsl:value-of select="$latex.begindocument"/>
  <xsl:call-template name="lang.document.begin">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:call-template name="label.id"/>

  <!-- Setup that must be performed after the begin of document -->
  <xsl:call-template name="verbatim.setup2"/>

  <!-- Apply the legalnotices here, when language is active -->
  <xsl:call-template name="print.legalnotice">
    <xsl:with-param name="nodes" select="$info/legalnotice"/>
  </xsl:call-template>

  <xsl:if test="contains($layout, 'frontmatter ')">
    <xsl:value-of select="$frontmatter"/>
  </xsl:if>

  <xsl:if test="contains($layout, 'coverpage ')">
    <xsl:text>\maketitle&#10;</xsl:text>
  </xsl:if>

  <!-- Print the TOC/LOTs -->
  <xsl:if test="contains($layout, 'toc ')">
    <xsl:apply-templates select="." mode="toc_lots"/>
  </xsl:if>

  <!-- Print the abstract and front matter content -->
  <xsl:apply-templates select="(abstract|$info/abstract)[1]"/>
  <xsl:apply-templates select="dedication|preface"/>

  <!-- Body content -->
  <xsl:if test="contains($layout, 'mainmatter ')">
    <xsl:value-of select="$mainmatter"/>
  </xsl:if>
  <xsl:apply-templates select="*[not(self::abstract or
                                     self::preface or
                                     self::dedication or
                                     self::colophon or
                                     self::appendix)]"/>

  <!-- Back matter -->
  <xsl:if test="contains($layout, 'backmatter ')">
    <xsl:value-of select="$backmatter"/>
  </xsl:if>

  <xsl:apply-templates select="appendix"/>
  <xsl:if test="contains($layout, 'index ')">
    <xsl:if test="*//indexterm|*//keyword">
      <xsl:call-template name="printindex"/>
    </xsl:if>
  </xsl:if>
  <xsl:apply-templates select="colophon"/>
  <xsl:call-template name="lang.document.end">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:value-of select="$latex.enddocument"/>
</xsl:template>

<xsl:template match="book/title"/>
<xsl:template match="article/title"/>
<xsl:template match="bookinfo"/>
<xsl:template match="articleinfo"/>


<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<xsl:template match="procedure">
  <xsl:apply-templates select="*[not(self::step)]"/>
  <xsl:text>\begin{enumerate}&#10;</xsl:text>
  <xsl:apply-templates select="step"/>
  <xsl:text>\end{enumerate}&#10;</xsl:text>
</xsl:template>

<xsl:template match="procedure/title">
  <xsl:text>{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select=".."/>
  </xsl:call-template>
  <!-- Ask to latex to let the title with its list -->
  <xsl:text>\nopagebreak&#10;</xsl:text>
</xsl:template>

<xsl:template match="step/title">
  <xsl:text>{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="step">
  <xsl:text>\item{</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="substeps">
  <xsl:text>\begin{enumerate}&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>\end{enumerate}&#10;</xsl:text>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- qandaset parameters -->
<xsl:param name="qanda.defaultlabel">number</xsl:param>


<xsl:template match="qandaset">
  <!-- is it displayed as a section? -->
  <xsl:variable name="title"
                select="(title|blockinfo/title|info/title)[1]"/>

  <xsl:if test="$title">
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level">
        <xsl:call-template name="get.sect.level"/>
      </xsl:with-param>
      <xsl:with-param name="num" select="'0'"/>
      <xsl:with-param name="title" select="$title"/>
    </xsl:call-template>
  </xsl:if>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="qandaset/title"/>
<xsl:template match="qandaset/blockinfo"/>


<!-- ############
     # qandadiv #
     ############ -->

<xsl:template match="qandadiv/title"/>

<xsl:template match="qandadiv">
  <!-- display the title according the section depth -->
  <xsl:variable name="l">
    <xsl:value-of select="count(ancestor::qandadiv)"/>
  </xsl:variable>
  <xsl:variable name="lset">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="ancestor::qandaset"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:if test="blockinfo/title|info/title|title">
    <xsl:call-template name="makeheading">
      <xsl:with-param name="level">
        <xsl:choose>
        <xsl:when test="ancestor::qandaset[title|blockinfo/title|info/title]">
          <xsl:value-of select="$l+$lset+1"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$l+$lset"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:apply-templates/>
</xsl:template>


<!-- ##############
     # qandaentry #
     ############## -->

<!-- should be really processed -->
<xsl:template match="label"/>

<xsl:template match="qandaentry">
  <xsl:variable name="defaultlabel">
    <xsl:choose>
    <xsl:when test="ancestor::qandaset[@defaultlabel]">
      <xsl:value-of select="ancestor::qandaset/@defaultlabel"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$qanda.defaultlabel"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- if default label is a number, display the quandaentries
       like an enumerate list
    -->
  <xsl:if test="not(preceding-sibling::qandaentry) and
                $defaultlabel='number'">
    <xsl:text>&#10;\begin{enumerate}&#10;</xsl:text>
  </xsl:if>

  <xsl:apply-templates select="question" mode="wp">
    <xsl:with-param name="defaultlabel" select="$defaultlabel"/>
  </xsl:apply-templates>
  <xsl:apply-templates select="answer" mode="wp">
    <xsl:with-param name="defaultlabel" select="$defaultlabel"/>
  </xsl:apply-templates>

  <xsl:if test="not(following-sibling::qandaentry) and
                $defaultlabel='number'">
    <xsl:text>&#10;\end{enumerate}</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="question" mode="wp">
  <xsl:param name="defaultlabel"/>

  <xsl:choose>
  <xsl:when test="$defaultlabel='number'">
    <xsl:text>\item</xsl:text>
    <xsl:if test="label">
      <!-- label has priority on defaultlabel -->
      <xsl:text>[\textbf{</xsl:text>
      <xsl:value-of select="label"/>
      <xsl:text>}]</xsl:text>
    </xsl:if>
    <xsl:text>{}</xsl:text>
  </xsl:when>
  <xsl:when test="label">
    <xsl:text>\textbf{</xsl:text>
    <xsl:value-of select="label"/>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:when test="$defaultlabel='qanda'">
    <xsl:text>\textbf{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'question'"/>
    </xsl:call-template>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <!-- don't use textit since we can have several paragraphs -->
  <xsl:text>{\it </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<xsl:template match="answer" mode="wp">
  <xsl:param name="defaultlabel"/>

  <xsl:choose>
  <xsl:when test="$defaultlabel='number'">
    <!-- answers are other paragraphs of the enumerated entry -->
    <xsl:text>&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="label">
    <xsl:text>&#10;\noindent\textbf{</xsl:text>
    <xsl:value-of select="label"/>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:when test="$defaultlabel='qanda'">
    <xsl:text>&#10;\noindent\textbf{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'answer'"/>
    </xsl:call-template>
    <xsl:text>}~</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates/>
  <xsl:text>&#10;&#10;</xsl:text>
</xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->


<xsl:template match="epigraph|blockquote">
  <xsl:text>\begin{quote}&#10;</xsl:text>
  <xsl:apply-templates select="*[not(self::attribution)]"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="attribution"/>
  <xsl:text>\end{quote}&#10;</xsl:text>
</xsl:template>

<xsl:template match="epigraph/title|blockquote/title">
  <xsl:text>{\sc </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;&#10;</xsl:text>
</xsl:template>

<xsl:template match="attribution">
  <xsl:text>\hspace*\fill---</xsl:text>
  <xsl:apply-templates/>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->
<xsl:param name="refentry.tocdepth">5</xsl:param>
<xsl:param name="refentry.numbered">1</xsl:param>
<xsl:param name="refentry.generate.name" select="0"/>
<xsl:param name="refclass.suppress" select="0"/>

<xsl:template name="refsect.level">
  <xsl:param name="n" select="."/>
  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level">
      <xsl:with-param name="n" select="$n/ancestor::refentry"/>
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:variable name="offset">
    <xsl:choose>
    <xsl:when test="local-name($n)='refsynopsisdiv'">1</xsl:when>
    <xsl:when test="local-name($n)='refsect1'">1</xsl:when>
    <xsl:when test="local-name($n)='refsect2'">2</xsl:when>
    <xsl:when test="local-name($n)='refsect3'">3</xsl:when>
    <xsl:when test="local-name($n)='refsection'">
      <xsl:value-of select="count($n/ancestor::refsection)+1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$level + $offset"/>
</xsl:template>

<!-- #############
     # reference #
     ############# -->

<xsl:template match="reference">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% Reference &#10;</xsl:text>
  <xsl:text>% ---------&#10;</xsl:text>
  <xsl:call-template name="makeheading">
    <!-- raise to the highest existing book section level (part or chapter) -->
    <xsl:with-param name="level">
      <xsl:choose>
      <xsl:when test="preceding-sibling::part or
                      following-sibling::part">-1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates select="partintro"/>
  <xsl:apply-templates select="*[local-name(.) != 'partintro']"/>
</xsl:template>

<xsl:template match="reference/docinfo"/>
<xsl:template match="reference/title"/>  
<xsl:template match="reference/subtitle"/>
<xsl:template match="refentryinfo|refentryinfo/*"/>

<!-- ############
     # refentry #
     ############ -->

<xsl:template match="refentry">
  <xsl:variable name="refmeta" select=".//refmeta"/>
  <xsl:variable name="refentrytitle" select="$refmeta//refentrytitle"/>
  <xsl:variable name="refnamediv" select=".//refnamediv"/>
  <xsl:variable name="refname" select="$refnamediv//refname"/>
  <xsl:variable name="title">
    <xsl:choose>
    <xsl:when test="$refentrytitle">
      <xsl:apply-templates select="$refentrytitle[1]"/>
    </xsl:when>
    <xsl:when test="$refname">
      <xsl:apply-templates select="$refname[1]"/>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>% Refentry &#10;</xsl:text>
  <xsl:text>% ---------&#10;</xsl:text>

  <xsl:variable name="level">
    <xsl:call-template name="get.sect.level"/>
  </xsl:variable>

  <xsl:choose>
  <xsl:when test="$refentry.numbered = '0'">
    <!-- Unumbered refentry title (but in TOC) -->
    <xsl:call-template name="section.unnumbered">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title"/>
      <xsl:with-param name="tocdepth" select="$refentry.tocdepth"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <!-- Numbered refentry title -->
    <xsl:call-template name="maketitle">
      <xsl:with-param name="level" select="$level"/>
      <xsl:with-param name="title" select="$title"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="refmeta">
  <xsl:apply-templates select="indexterm"/>
</xsl:template>

<xsl:template match="refentrytitle">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="manvolnum">
  <xsl:if test="$refentry.xref.manvolnum != 0">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ###############
     # refsynopsis #
     ############### -->

<!-- A refsynopsisdiv with a title is handled like a refsectx -->
<xsl:template match="refsynopsisdiv">
  <!-- Without title, generate a localized "Synopsis" heading -->
  <xsl:call-template name="maketitle">
    <xsl:with-param name="num" select="'0'"/>
    <xsl:with-param name="level">
      <xsl:call-template name="refsect.level"/>
    </xsl:with-param>
    <xsl:with-param name="title">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'RefSynopsisDiv'"/>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdivinfo"/>
<xsl:template match="refsynopsisdiv/title"/>

<!-- ##############
     # refnamediv #
     ############## -->

<xsl:template match="refnamediv">
  <!-- Generate a localized "Name" subheading if is non-zero -->
  <xsl:if test="$refentry.generate.name != 0">
    <xsl:call-template name="maketitle">
      <xsl:with-param name="num" select="'0'"/>
      <xsl:with-param name="level">
        <xsl:call-template name="refsect.level"/>
      </xsl:with-param>
      <xsl:with-param name="title">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'RefName'"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <!-- refdescriptor is used only if no refname -->
  <xsl:choose>
  <xsl:when test="refname">
    <xsl:apply-templates select="refname"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="refdescriptor"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="*[local-name(.)!='refname' and
                                 local-name(.)!='refdescriptor']"/>
</xsl:template>

<xsl:template match="refname">
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::refname">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:text> --- </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refdescriptor">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refclass">
  <xsl:if test="$refclass.suppress = 0">
    <!-- Displayed as block -->
    <xsl:text>&#10;&#10;</xsl:text>
    <xsl:if test="@role">
      <xsl:value-of select="@role"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ############
     # refsectx #
     ############ -->

<xsl:template match="refsect1/title"/>
<xsl:template match="refsect2/title"/>
<xsl:template match="refsect3/title"/>
<xsl:template match="refsection/title"/>
<xsl:template match="refsect1info"/>
<xsl:template match="refsect2info"/>
<xsl:template match="refsect3info"/>

<xsl:template match="refsection|refsect1|refsect2|refsect3">
  <xsl:call-template name="makeheading">
    <xsl:with-param name="level">
      <xsl:call-template name="refsect.level"/>
    </xsl:with-param>
    <xsl:with-param name="num" select="0"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refsynopsisdiv[title|
                                    refsynopsisdivinfo/title|
                                    info/title]">
  <!-- Select the title node -->
  <xsl:variable name="title"
                select="(title|
                         refsynopsisdivinfo/title|
                         info/title)[1]"/>

  <xsl:call-template name="makeheading">
    <xsl:with-param name="level">
      <xsl:call-template name="refsect.level"/>
    </xsl:with-param>
    <xsl:with-param name="num" select="0"/>
    <xsl:with-param name="title" select="$title"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>




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




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="text()">
  <xsl:call-template name="scape">
  <xsl:with-param name="string" select="."/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="text()" mode="latex.verbatim">
  <xsl:value-of select="."/> 
</xsl:template>

<xsl:template name="do.slash.hyphen">
  <xsl:param name="str"/>
  <xsl:choose>
  <xsl:when test="contains($str,'/')">
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="substring-before($str,'/')"/>
    </xsl:call-template>
    <xsl:text>/\-</xsl:text>
    <xsl:call-template name="do.slash.hyphen">
      <xsl:with-param name="str" select="substring-after($str,'/')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="scape">
      <xsl:with-param name="string" select="$str"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="slash.hyphen">
  <xsl:choose>
  <xsl:when test="contains(.,'://')">
    <xsl:call-template name="scape">
      <xsl:with-param name="string">
        <xsl:value-of select="substring-before(.,'://')"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:value-of select="'://'"/>
    <xsl:call-template name="do.slash.hyphen">
      <xsl:with-param name="str" select="substring-after(.,'://')"/>
    </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="do.slash.hyphen">
      <xsl:with-param name="str" select="."/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Beware, we must replace some text in an escaped string -->
<xsl:template name="scape.index">
  <xsl:param name="string"/>
  <xsl:call-template name="scape-replace">
  <xsl:with-param name="from">@</xsl:with-param>
  <xsl:with-param name="to">"@</xsl:with-param>
  <xsl:with-param name="string">
    <xsl:call-template name="scape-replace">
    <xsl:with-param name="from">!</xsl:with-param>
    <xsl:with-param name="to">"!</xsl:with-param>
    <xsl:with-param name="string">
      <xsl:call-template name="scape-replace">
      <xsl:with-param name="from">|</xsl:with-param>
      <xsl:with-param name="to">\ensuremath{"|}</xsl:with-param>
      <xsl:with-param name="string">
        <!-- if '\{' and '\}' count is not in the same in the
             index term, latex indexing fails.
             so use a macro to avoid this side effect -->
        <xsl:call-template name="scape-replace">
        <xsl:with-param name="from">\tbleft </xsl:with-param>
        <xsl:with-param name="to">\textbraceleft{}</xsl:with-param>
        <xsl:with-param name="string">
          <xsl:call-template name="scape-replace">
          <xsl:with-param name="from">\tbright </xsl:with-param>
          <xsl:with-param name="to">\textbraceright{}</xsl:with-param>
          <xsl:with-param name="string">
            <!-- need two passes to avoid mess with macro ending with {} -->
            <xsl:call-template name="scape-replace">
            <xsl:with-param name="from">{</xsl:with-param>
            <xsl:with-param name="to">\tbleft </xsl:with-param>
            <xsl:with-param name="string">
              <xsl:call-template name="scape-replace">
              <xsl:with-param name="from">}</xsl:with-param>
              <xsl:with-param name="to">\tbright </xsl:with-param>
              <xsl:with-param name="string">
                <xsl:call-template name="scape-replace">
                <xsl:with-param name="from">"</xsl:with-param>
                <xsl:with-param name="to">""</xsl:with-param>
                <xsl:with-param name="string">
                   <xsl:call-template name="normalize-scape">
                    <xsl:with-param name="string" select="$string"/>
                  </xsl:call-template>
                </xsl:with-param>
                </xsl:call-template></xsl:with-param>
              </xsl:call-template></xsl:with-param>
            </xsl:call-template></xsl:with-param>
          </xsl:call-template></xsl:with-param>
        </xsl:call-template></xsl:with-param>
      </xsl:call-template></xsl:with-param>
    </xsl:call-template></xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- TODO: how to scape tabs? xt plants -->
<!-- If probing is required the text is silently skipped.
     See verbatim.xsl for an overview of the verbatim environment design
     that explains the need of probing.
-->
<xsl:template match="text()" mode="latex.programlisting">
  <xsl:param name="probe" select="0"/>
  <xsl:if test="$probe = 0">
    <xsl:value-of select="."/> 
  </xsl:if>
</xsl:template>

<xsl:template name="normalize-scape" >
  <xsl:param name="string"/>
  <xsl:call-template name="scape">
    <xsl:with-param name="string" select="normalize-space($string)"/>
  </xsl:call-template>
</xsl:template>


<!-- So many lines to do so little: removing spurious blank lines
     before and after actual text, but keeping in-between blank lines.
-->
<xsl:template name="normalize-border" >
  <xsl:param name="string"/>
  <xsl:param name="step" select="'start'"/>
  <xsl:variable name="left" select="substring-before($string,'&#10;')"/>

  <xsl:choose>
  <xsl:when test="not(contains($string,'&#10;'))">
    <xsl:value-of select="$string"/>
  </xsl:when>
  <xsl:when test="$step='start'">
    <xsl:choose>
    <xsl:when test="string-length(normalize-space($left))=0">
      <xsl:call-template name="normalize-border">
        <xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
        <xsl:with-param name="step" select="$step"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$left"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:call-template name="normalize-border">
        <xsl:with-param name="string" select="substring-after($string,'&#10;')"/>
        <xsl:with-param name="step" select="'cont'"/>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$left"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:variable name="right" select="substring-after($string,'&#10;')"/>
    <xsl:if test="string-length(normalize-space($right))!=0">
      <xsl:call-template name="normalize-border">
        <xsl:with-param name="string" select="$right"/>
        <xsl:with-param name="step" select="'cont'"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--  (c) David Carlisle
      replace all occurences of the character(s) `from'
      by the string `to' in the string `string'.
  -->
<xsl:template name="string-replace" >
  <xsl:param name="string"/>
  <xsl:param name="from"/>
  <xsl:param name="to"/>
  <xsl:choose>
    <xsl:when test="contains($string,$from)">
      <xsl:value-of select="substring-before($string,$from)"/>
      <xsl:value-of select="$to"/>
      <xsl:call-template name="string-replace">
        <xsl:with-param name="string" select="substring-after($string,$from)"/>
        <xsl:with-param name="from" select="$from"/>
        <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="sect1|sect2|sect3|sect4|sect5">
  <xsl:call-template name="mapheading"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sect1/title"/>
<xsl:template match="sect1/subtitle"/>
<xsl:template match="sect2/title"/>
<xsl:template match="sect2/subtitle"/>
<xsl:template match="sect3/title"/>
<xsl:template match="sect3/subtitle"/>
<xsl:template match="sect4/title"/>
<xsl:template match="sect4/subtitle"/>
<xsl:template match="sect5/title"/>
<xsl:template match="sect5/subtitle"/>

<xsl:template name="map.sect.level">
  <xsl:param name="level" select="''"/>
  <xsl:param name="name" select="''"/>
  <xsl:param name="num" select="'1'"/>
  <xsl:param name="allnum" select="'0'"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:choose>
  <xsl:when test="$level &lt; 6">
    <xsl:choose>
      <xsl:when test='$level=1'>\section</xsl:when>
      <xsl:when test='$level=2'>\subsection</xsl:when>
      <xsl:when test='$level=3'>\subsubsection</xsl:when>
      <xsl:when test='$level=4'>\paragraph</xsl:when>
      <xsl:when test='$level=5'>\subparagraph</xsl:when>
      <!-- rare case -->
      <xsl:when test='$level=0'>\chapter</xsl:when>
      <xsl:when test='$level=-1'>\part</xsl:when>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="$name!=''">
    <xsl:choose>
      <xsl:when test="$name='sect1'">\section</xsl:when>
      <xsl:when test="$name='sect2'">\subsection</xsl:when>
      <xsl:when test="$name='sect3'">\subsubsection</xsl:when>
      <xsl:when test="$name='sect4'">\paragraph</xsl:when>
      <xsl:when test="$name='sect5'">\subparagraph</xsl:when>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:message>
      <xsl:text>Section level &gt; 6 not well supported for </xsl:text>
      <xsl:value-of select="local-name(.)"/>
      <xsl:if test="@id|@xml:id">
        <xsl:text>(id=</xsl:text>
        <xsl:value-of select="(@id|@xml:id)[1]"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </xsl:message> 
    <xsl:text>\subparagraph</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
  <xsl:when test="$allnum = '1'"/>
  <xsl:when test="$num = '0'">
    <xsl:text>*</xsl:text>
  </xsl:when>
  <xsl:when test="ancestor::preface|ancestor::colophon|
                  ancestor::dedication|ancestor::partintro|
                  ancestor::glossary|ancestor::qandaset">
    <xsl:text>*</xsl:text>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="section">
  <xsl:variable name="min">
    <xsl:choose>
    <xsl:when test="ancestor::appendix and ancestor::article">
      <xsl:value-of select="'2'"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="'1'"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="makeheading">
    <xsl:with-param name="level" select="count(ancestor::section)+$min"/>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="get.sect.level">
  <xsl:param name="n" select="."/>
  <xsl:choose>
  <xsl:when test="$n/parent::section">
    <xsl:value-of select="count($n/ancestor::section)+1"/>
  </xsl:when>
  <xsl:when test="$n/parent::chapter">1</xsl:when>
  <xsl:when test="$n/parent::article">1</xsl:when>
  <xsl:when test="$n/parent::sect1">2</xsl:when>
  <xsl:when test="$n/parent::sect2">3</xsl:when>
  <xsl:when test="$n/parent::sect3">4</xsl:when>
  <xsl:when test="$n/parent::sect4">5</xsl:when>
  <xsl:when test="$n/parent::sect5">6</xsl:when>
  <xsl:when test="$n/parent::reference">1</xsl:when>
  <xsl:when test="$n/parent::preface">1</xsl:when>
  <xsl:when test="$n/parent::simplesect or
                  $n/parent::refentry">
    <xsl:variable name="l">
      <xsl:call-template name="get.sect.level">
        <xsl:with-param name="n" select="$n/parent::*"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="$l+1"/>
  </xsl:when>
  <xsl:when test="$n/parent::book">
    <xsl:choose>
    <xsl:when test="preceding-sibling::part or
                    following-sibling::part">-1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="$n/parent::part">0</xsl:when>
  <xsl:when test="$n/parent::appendix">
    <xsl:choose>
    <xsl:when test="$n/ancestor::book">1</xsl:when>
    <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>7</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="simplesect">
  <xsl:call-template name="makeheading">
    <xsl:with-param name="level">
      <xsl:call-template name="get.sect.level"/>
    </xsl:with-param>
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="section/title"/>
<xsl:template match="simplesect/title"/>

<xsl:template match="sectioninfo
                    |sect1info
                    |sect2info
                    |sect3info
                    |sect4info
                    |sect5info">
  <xsl:apply-templates select="itermset"/>
</xsl:template>

<xsl:template match="titleabbrev"/>




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




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:template match="sgmltag|tag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="normalize-space(@class)"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$class='attribute'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:when test="$class='attvalue'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:when test="$class='element'">
      <xsl:call-template name="inline.monoseq"/>
    </xsl:when>
    <xsl:when test="$class='endtag'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$/</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='genentity'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>\&amp;</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='numcharref'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>\&amp;\#</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='paramentity'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>\%</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='pi'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>?$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='xmlpi'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$?</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>?$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='starttag'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='emptytag'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>/$&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$class='sgmlcomment'">
      <xsl:call-template name="inline.monoseq">
        <xsl:with-param name="content">
          <xsl:text>$&lt;$!$--$</xsl:text>
          <xsl:apply-templates/>
          <xsl:text>$--&gt;$</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.charseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- The sidebar block must be a latex environment where verbatim
     stuff is correctly handled. This environment must support options
     that are user specific.
  -->
<xsl:template match="sidebar">
  <xsl:text>&#10;&#10;\begin{sidebar}</xsl:text>
  <xsl:if test="@role and @role != ''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="concat('role=', @role)"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="title"/>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>\end{sidebar}&#10;</xsl:text>
</xsl:template>

<xsl:template match="sidebar/title">
  <xsl:text>\textbf{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}&#10;&#10;</xsl:text>
</xsl:template>





<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:strip-space elements="cmdsynopsis arg group"/>


<xsl:template match="synopsis">
  <xsl:call-template name="label.id"/>
  <xsl:call-template name="output.verbatim"/>
</xsl:template>

<xsl:template match="synopsis|funcsynopsisinfo" mode="save.verbatim">
  <xsl:call-template name="save.verbatim"/>
</xsl:template>

<!-- we want the brackets -->
<xsl:template match="optional" mode="latex.verbatim">
  <xsl:value-of select="$arg.choice.opt.open.str"/>
  <xsl:apply-templates mode="latex.verbatim"/>
  <xsl:value-of select="$arg.choice.opt.close.str"/>
</xsl:template>


<!-- ###############
     # cmdsynopsis #
     ############### -->

<xsl:template match="cmdsynopsis">
  <xsl:text>&#10;</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="cmdsynopsis/command">
  <xsl:text>&#10; </xsl:text>
  <xsl:call-template name="inline.monoseq"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="cmdsynopsis/command[1]">
  <xsl:call-template name="inline.monoseq"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="group|arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:variable name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@sepchar">
        <xsl:value-of select="ancestor-or-self::*/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="preceding-sibling::*">
    <xsl:value-of select="$sepchar"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.open.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.open.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <xsl:choose>
    <xsl:when test="$rep='repeat'">
      <xsl:value-of select="$arg.rep.repeat.str"/>
    </xsl:when>
    <xsl:when test="$rep='norepeat'">
      <xsl:value-of select="$arg.rep.norepeat.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.rep.def.str"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.close.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.close.str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="group/arg">
  <xsl:if test="preceding-sibling::*">
    <xsl:value-of select="$arg.or.sep"/>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="sbr">
  <xsl:text>\newline&#10;</xsl:text>
</xsl:template>

<xsl:template match="synopfragmentref">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="synopfragment.number"/>
  </xsl:variable>

  <xsl:text>{\em (</xsl:text>
  <xsl:value-of select="$snum"/>
  <xsl:text>)</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="synopfragment" mode="synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="synopfragment">
  <xsl:variable name="snum">
    <xsl:apply-templates select="." mode="synopfragment.number"/>
  </xsl:variable>

  <xsl:if test="$snum=1"><xsl:text>&#10;</xsl:text></xsl:if>
  <xsl:text>&#10;(</xsl:text>
  <xsl:value-of select="$snum"/>
  <xsl:text>) </xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>   


<!-- ################
     # funcsynopsis #
     ################ -->

<xsl:template match="funcsynopsis">
  <xsl:text>&#10;</xsl:text>
  <xsl:call-template name="label.id"/>
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcsynopsisinfo">
  <xsl:call-template name="output.verbatim"/>
</xsl:template>

<xsl:template match="funcprototype">
  <xsl:apply-templates/>
  <xsl:if test="$funcsynopsis.style='kr'">
    <xsl:apply-templates select="./paramdef" mode="kr"/>
  </xsl:if>
  <xsl:if test="following-sibling::*">
    <xsl:text>\newline</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="funcdef">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="funcdef/function">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <xsl:text>\textbf{</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>}</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="void">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.style='ansi'">
      <xsl:text>(void);</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>();</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="varargs">
  <xsl:text>( ... );</xsl:text>
</xsl:template>

<xsl:template match="paramdef">
  <xsl:variable name="paramnum">
    <xsl:number count="paramdef" format="1"/>
  </xsl:variable>
  
  <xsl:if test="$paramnum=1">(</xsl:if>
  <xsl:choose>
    <xsl:when test="not(parameter) or $funcsynopsis.style='ansi'">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="./parameter"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="following-sibling::paramdef">
      <xsl:text>, </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>);</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="paramdef/parameter">
  <xsl:choose>
    <xsl:when test="$funcsynopsis.decoration != 0">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="following-sibling::parameter">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="paramdef" mode="kr">
  <xsl:if test="parameter">
    <xsl:text>\newline&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="funcparams">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Upper table and informaltable templates. They make the wrapper environment
     depending of the kind of table (floating, landscape, role) and call the
     actual newtbl engine. The $newtbl.use parameter is now removed. -->

<xsl:param name="newtbl.format.thead">\bfseries%&#10;</xsl:param>
<xsl:param name="newtbl.format.tbody"/>
<xsl:param name="newtbl.format.tfoot"/>
<xsl:param name="newtbl.bgcolor.thead"/>
<xsl:param name="newtbl.default.colsep" select="'1'"/>
<xsl:param name="newtbl.default.rowsep" select="'1'"/>
<xsl:param name="newtbl.use.hhline" select="'0'"/>
<xsl:param name="newtbl.autowidth"/>
<xsl:param name="table.title.top" select="'0'"/>
<xsl:param name="table.in.float" select="'1'"/>
<xsl:param name="table.default.position" select="'[htbp]'"/>
<xsl:param name="table.default.tabstyle"/>
<xsl:param name="default.table.width"/>


<xsl:template match="table">
  <xsl:choose>
  <xsl:when test="$table.in.float='1'">
    <xsl:apply-templates select="." mode="float"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="." mode="longtable"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="." mode="foottext"/>
</xsl:template>

<!-- Switch to CALS or HTML templates -->
<xsl:template name="make.table.content">
  <xsl:param name="tabletype">tabular</xsl:param>
  <xsl:param name="tablewidth">\linewidth-2\tabcolsep</xsl:param>

  <xsl:choose>
    <xsl:when test="tgroup">
      <xsl:apply-templates select="tgroup" mode="newtbl">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="tablewidth" select="$tablewidth"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="htmlTable">
        <xsl:with-param name="tabletype" select="$tabletype"/>
        <xsl:with-param name="tablewidth" select="$tablewidth"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="table" mode="float">
  <!-- do we need to change text size? -->
  <xsl:variable name="size">
    <xsl:choose>
    <xsl:when test="@role='small' or @role='footnotesize' or
                    @role='scriptsize' or @role='tiny'">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>normal</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- pgwide usefull in two column mode -->
  <xsl:variable name="table.env">
    <xsl:text>table</xsl:text>
    <xsl:if test="@pgwide='1'">
      <xsl:text>*</xsl:text>
    </xsl:if>
  </xsl:variable>
  <!-- in a float only tabular or tabularx allowed -->
  <xsl:variable name="tabletype">
    <xsl:choose>
    <xsl:when test="@tabstyle='tabular' or @tabstyle='tabularx'">
      <xsl:value-of select="@tabstyle"/>
    </xsl:when>
    <xsl:when test="$table.default.tabstyle='tabular' or
                    $table.default.tabstyle='tabularx'">
      <xsl:value-of select="$table.default.tabstyle"/>
    </xsl:when>
    <xsl:otherwise>tabular</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@orient='land'">
    <xsl:text>\begin{landscape}&#10;</xsl:text>
  </xsl:if>
  <xsl:value-of select="concat('\begin{', $table.env, '}')"/>
  <!-- table placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$table.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
  <!-- title caption before the table -->
  <xsl:if test="$table.title.top='1'">
    <xsl:apply-templates select="title|caption"/>
  </xsl:if>
  <xsl:if test="$size!='normal'">
    <xsl:text>\begin{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\begin{center}&#10;</xsl:text>

  <!-- do the actual work -->
  <xsl:call-template name="make.table.content">
    <xsl:with-param name="tabletype" select="$tabletype"/>
  </xsl:call-template>

  <xsl:text>&#10;\end{center}&#10;</xsl:text>
  <xsl:if test="$size!='normal'">
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$table.title.top='0'">
    <xsl:apply-templates select="title|caption"/>
  </xsl:if>
  <xsl:value-of select="concat('\end{', $table.env, '}&#10;')"/>
  <xsl:if test="@orient='land'">
    <xsl:text>\end{landscape}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="table/title|table/caption">
  <xsl:text>&#10;\caption</xsl:text>
  <xsl:apply-templates select="." mode="format.title"/>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="parent::table"/>
  </xsl:call-template>
</xsl:template>


<!-- Use the longtable features to have captions for formal tables -->
<xsl:template match="table" mode="longtable">
  <!-- do we need to change text size? -->
  <xsl:variable name="size">
    <xsl:choose>
    <xsl:when test="@role='small' or @role='footnotesize' or
                    @role='scriptsize' or @role='tiny'">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>normal</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="@orient='land'">
    <xsl:text>\begin{landscape}&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="$size!='normal'">
    <xsl:text>\begin{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\begin{center}&#10;</xsl:text>

  <!-- do the actual work -->
  <xsl:call-template name="make.table.content">
    <xsl:with-param name="tabletype" select="'longtable'"/>
  </xsl:call-template>

  <xsl:text>&#10;\end{center}&#10;</xsl:text>
  <xsl:if test="$size!='normal'">
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="@orient='land'">
    <xsl:text>\end{landscape}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="table/title|table/caption" mode="longtable">
  <xsl:variable name="toc">
    <xsl:apply-templates select="." mode="toc"/>
  </xsl:variable>
  <xsl:variable name="content">
    <xsl:apply-templates select="." mode="content"/>
  </xsl:variable>
  <xsl:text>\caption</xsl:text>
  <!-- The title in the TOC -->
  <xsl:choose>
  <xsl:when test="$toc != ''">
    <xsl:value-of select="$toc"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>[{</xsl:text>
    <xsl:value-of select="$content"/>
    <xsl:text>}]</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>{</xsl:text>
  <xsl:value-of select="$content"/>
  <xsl:call-template name="label.id">
    <xsl:with-param name="object" select="parent::table"/>
  </xsl:call-template>
  <xsl:text>}\tabularnewline&#10;</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="align.environment">
  <xsl:param name="align"/>
  <xsl:param name="align-default" select="'center'"/>

  <xsl:choose>
    <xsl:when test="$align = 'left'">
      <xsl:text>flushright</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'right'">
      <xsl:text>flushleft</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'center'">
      <xsl:text>center</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$align-default"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tbl.align.begin">
  <xsl:param name="tabletype"/>

  <!-- provision for user-specified alignment -->
  <xsl:variable name="align" select="'center'"/>

  <xsl:choose>
  <xsl:when test="$tabletype = 'longtable'">
    <xsl:choose>
    <xsl:when test="$align = 'left'">
      <xsl:text>\raggedright</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'right'">
      <xsl:text>\raggedleft</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'center'">
      <xsl:text>\centering</xsl:text>
    </xsl:when>
    <xsl:when test="$align = 'justify'"></xsl:when>
    <xsl:otherwise>
      <xsl:message>Word-wrapped alignment <xsl:value-of 
          select="$align"/> not supported</xsl:message>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:variable name="alignenv">
      <xsl:call-template name="align.environment">
        <xsl:with-param name="align" select="$align"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('\begin{',$alignenv,'}')"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="tbl.align.end">
  <xsl:param name="tabletype"/>

  <!-- provision for user-specified alignment -->
  <xsl:variable name="align" select="'center'"/>

  <xsl:if test="$tabletype != 'longtable'">
    <xsl:variable name="alignenv">
      <xsl:call-template name="align.environment">
        <xsl:with-param name="align" select="$align"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="concat('\end{',$alignenv,'}')"/>
  </xsl:if>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="informaltable">
  <!-- do we need to change text size? -->
  <xsl:variable name="size">
    <xsl:choose>
    <xsl:when test="@role='small' or @role='footnotesize' or
                    @role='scriptsize' or @role='tiny'">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>normal</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- are we a nested table? -->
  <xsl:variable name="nested" select="ancestor::entry|ancestor::td"/>

  <!-- longtables cannot be nested -->
  <xsl:variable name="tabletype">
    <xsl:choose>
    <xsl:when test="$nested">tabular</xsl:when>
    <xsl:when test="@tabstyle='tabular' or @tabstyle='tabularx'">
      <xsl:value-of select="@tabstyle"/>
    </xsl:when>
    <xsl:when test="$table.default.tabstyle='tabular' or
                    $table.default.tabstyle='tabularx'">
      <xsl:value-of select="$table.default.tabstyle"/>
    </xsl:when>
    <xsl:otherwise>longtable</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="@orient='land'">
    <xsl:text>\begin{landscape}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="$size!='normal'">
    <xsl:text>\begin{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:choose>
  <xsl:when test="not($nested)">
    <xsl:text>&#10;&#10;{</xsl:text>
    <!-- table alignment -->
    <xsl:call-template name="tbl.align.begin">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:call-template>
    <!-- do the actual work -->
    <xsl:if test="$tabletype='longtable'">
      <xsl:text>\savetablecounter </xsl:text>
    </xsl:if>

    <xsl:call-template name="make.table.content">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:call-template>

    <xsl:if test="$tabletype='longtable'">
      <xsl:text>\restoretablecounter%&#10;</xsl:text>
    </xsl:if>
    <xsl:call-template name="tbl.align.end">
      <xsl:with-param name="tabletype" select="$tabletype"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="make.table.content">
      <xsl:with-param name="tabletype" select="$tabletype"/>
      <xsl:with-param name="tablewidth" select="'\linewidth'"/>
    </xsl:call-template>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="$size!='normal'">
    <xsl:text>\end{</xsl:text>
    <xsl:value-of select="$size"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:if>
  <xsl:if test="@orient='land'">
    <xsl:text>\end{landscape}&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="." mode="foottext"/>
</xsl:template>

<!-- Hook for the newtbl to decide what to do after the table head,
     depending on the type of table used.
-->
<xsl:template match="informaltable" mode="newtbl.endhead">
  <xsl:param name="tabletype"/>
  <xsl:param name="headrows"/>
  <xsl:value-of select="$headrows"/>
  <xsl:if test="$tabletype='longtable' and $headrows!=''">
    <!-- longtable endhead to put only when there's an actual head -->
    <xsl:text>\endhead&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="table" mode="newtbl.endhead">
  <xsl:param name="tabletype"/>
  <xsl:param name="headrows"/>
  <xsl:choose>
  <xsl:when test="$tabletype='longtable'">
    <!-- longtable endhead -->
    <xsl:choose>
    <xsl:when test="$table.in.float='0'">
      <xsl:apply-templates select="title|caption" mode="longtable"/>
      <xsl:value-of select="$headrows"/>
      <xsl:text>\endfirsthead&#10;</xsl:text>
      <xsl:text>\caption[]</xsl:text>
      <xsl:text>{(continued)}\tabularnewline&#10;</xsl:text>
      <xsl:value-of select="$headrows"/>
      <xsl:text>\endhead&#10;</xsl:text>
    </xsl:when>
    <xsl:when test="$headrows!=''">
      <xsl:value-of select="$headrows"/>
      <xsl:text>\endhead&#10;</xsl:text>
    </xsl:when>
    </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="$headrows"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- ToC/LoT parameters -->
<xsl:param name="doc.lot.show">figure,table</xsl:param>
<xsl:param name="doc.toc.show">1</xsl:param>


<!-- Noting to do: things are done by latex -->
<xsl:template match="toc"/>
<xsl:template match="lot"/>
<xsl:template match="lotentry"/>
<xsl:template match="tocpart|tocchap|tocfront|tocback|tocentry"/>
<xsl:template match="toclevel1|toclevel2|toclevel3|toclevel4|toclevel5"/>


<!-- Print one LoT -->
<xsl:template match="book|article" mode="lot">
  <xsl:param name="lot"/>

  <xsl:choose>
  <xsl:when test="$lot='figure' and .//figure">
    <xsl:text>\listoffigures&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$lot='table' and .//table">
    <xsl:text>\listoftables&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$lot='example' and .//example">
    <!-- A non standard float list -->
    <xsl:text>\listof{</xsl:text>
    <xsl:value-of select="$lot"/>
    <xsl:text>}{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'ListofExamples'"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  <xsl:when test="$lot='equation' and .//equation">
    <!-- A non standard float list -->
    <xsl:text>\listof{dbequation}</xsl:text>
    <xsl:text>{</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'ListofEquations'"/>
    </xsl:call-template>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- Print the ToC and all the LoTs listed in $doc.lot.show -->
<xsl:template match="book|article" mode="toc_lots">
  <xsl:if test="$doc.toc.show != '0'">
    <xsl:text>\tableofcontents&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates select="." mode="lots"/>
</xsl:template>

<!-- Print all the LoTs listed in $doc.lot.show -->
<xsl:template match="book|article" mode="lots">
  <xsl:param name="lots" select="$doc.lot.show"/>

  <xsl:choose>
  <xsl:when test="contains($lots, ',')">
    <xsl:apply-templates select="." mode="lot">
      <xsl:with-param name="lot"
                      select="normalize-space(substring-before($lots, ','))"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="." mode="lots">
      <xsl:with-param name="lots" select="substring-after($lots, ',')"/>
    </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>
    <xsl:apply-templates select="." mode="lot">
      <xsl:with-param name="lot" select="normalize-space($lots)"/>
    </xsl:apply-templates>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Update the TOC depth for printed TOC and PDF bookmarks -->
<xsl:template name="set-tocdepth">
  <xsl:param name="depth"/>
  <!-- For printed TOC -->
  <xsl:text>\addtocontents{toc}{\protect\setcounter{tocdepth}{</xsl:text>
  <xsl:value-of select="$depth"/>
  <xsl:text>}\ignorespaces}&#10;</xsl:text>
  <!-- For bookmarks -->
  <xsl:text>\setcounter{tocdepth}{</xsl:text>
  <xsl:value-of select="$depth"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>




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




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<!-- Literal parameters -->
<xsl:param name="literal.width.ignore">0</xsl:param>
<xsl:param name="literal.layout.options"/>
<xsl:param name="literal.lines.showall">1</xsl:param>
<xsl:param name="literal.role"/>
<xsl:param name="literal.class">monospaced</xsl:param>
<xsl:param name="literal.extensions"/>
<xsl:param name="linenumbering.scope"/>
<xsl:param name="linenumbering.default"/>
<xsl:param name="linenumbering.everyNth"/>
<!-- Use scalable dblatex listing if the feature is required -->
<xsl:param name="literal.environment">
  <xsl:choose>
  <xsl:when test="contains($literal.extensions,'scale')">
    <xsl:text>lstcode</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>lstlisting</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:param>


<xsl:template name="verbatim.setup">
  <!-- dblatex requires that a listing environment starts with 'lst' -->
  <xsl:if test="substring($literal.environment,1,3) != 'lst'">
    <xsl:message terminate="yes">
      <xsl:text>Error: </xsl:text>
      <xsl:value-of select="$literal.environment"/>
      <xsl:text>: a listing environment must start with 'lst'</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:apply-templates select="//screen|//programlisting"
                       mode="save.verbatim.preamble"/>
</xsl:template>

<xsl:template name="verbatim.setup2">
  <xsl:text>\lstsetup&#10;</xsl:text>
</xsl:template>


<xsl:template match="address">
  <xsl:call-template name="output.verbatim"/>
</xsl:template>

<xsl:template match="text()" mode="save.verbatim"/>

<xsl:template match="address"
              mode="save.verbatim">
  <xsl:call-template name="save.verbatim"/>
</xsl:template>

<xsl:template name="save.verbatim">
  <xsl:param name="content">
    <xsl:apply-templates mode="latex.verbatim"/>
  </xsl:param>
  <xsl:text>&#10;\begin{SaveVerbatim}{</xsl:text>
  <xsl:value-of select="generate-id()"/>
  <xsl:text>}&#10;</xsl:text>
  <xsl:value-of select="$content"/>
  <xsl:text>&#10;\end{SaveVerbatim}&#10;</xsl:text>
</xsl:template>

<xsl:template name="output.verbatim">
  <xsl:param name="content">
    <xsl:apply-templates mode="latex.verbatim"/>
  </xsl:param>
  <!-- In tables just use the data previously saved -->
  <xsl:choose>
  <xsl:when test="ancestor::entry|
                  ancestor::legalnotice">
    <xsl:text>\UseVerbatim{</xsl:text>
    <xsl:value-of select="generate-id(.)"/>
    <xsl:text>}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <xsl:text>&#10;\begin{verbatim}</xsl:text>
    <xsl:value-of select="$content"/>
    <xsl:text>\end{verbatim}&#10;</xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Special cases where nothing to output in verbatim mode -->
<xsl:template match="alt" mode="latex.verbatim"/>

<!-- Returns the filename from @fileref or @entityref attribute -->
<xsl:template match="*" mode="filename.get">
  <xsl:choose>
  <xsl:when test="@entityref">
    <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:value-of select="@fileref"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Template that must be called by elements that want to be escaped in a
     programlisting environment. It escapes the tex sequence, *but* prints
     out the sequence only if probing is not required (i.e. = 0).
     
     Probing is used by a parent that wants to know if it contains some
     element that needs some tex escaping.
     -->

<xsl:template name="verbatim.embed">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>
  <xsl:param name="content"/>

  <xsl:value-of select="concat($co-tagin, 't&gt;')"/>
  <xsl:if test="$probe = 0">
    <xsl:choose>
      <xsl:when test="$content != ''">
        <xsl:value-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:value-of select="'&lt;/t&gt;'"/>
</xsl:template>

<!-- Template to format (bold, italic) the calling element. The format is
     specified by the <style> that drives the corresponding delimiter
     sequence. Styles can be nested, so apply the same template mode to
     children.
     -->

<xsl:template name="verbatim.format">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>
  <xsl:param name="style" select="'b'"/>
  <xsl:param name="content"/>

  <xsl:value-of select="concat($co-tagin, $style, '&gt;')"/>
  <xsl:if test="$probe = 0">
    <xsl:choose>
      <xsl:when test="$content != ''">
        <xsl:value-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="latex.programlisting">
          <xsl:with-param name="co-tagin" select="$co-tagin"/>
          <xsl:with-param name="rnode" select="$rnode"/>
          <xsl:with-param name="probe" select="$probe"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
  <xsl:value-of select="concat('&lt;/', $style, '&gt;')"/>
</xsl:template>

<!-- A latex Processing-Instruction in verbatim is meaningfull, so
     process it.
     -->

<xsl:template match="processing-instruction('latex')"
              mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:value-of select="concat($co-tagin, 't', '&gt;')"/>
  <xsl:value-of select="."/>
  <xsl:value-of select="concat('&lt;/', 't', '&gt;')"/>
</xsl:template>

<!-- ==================================================================== -->

<!-- By default an element in a programlisting environment just prints out its
     text() adapted to this environment, and apply to its children the same
     template. -->

<xsl:template match="*" mode="latex.programlisting">
  <xsl:param name="co-tagin" select="'&lt;'"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="probe" select="0"/>

  <xsl:if test="$output.quietly = 0">
    <xsl:message>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text>: default template used in programlisting or screen</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:apply-templates mode="latex.programlisting">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
    <xsl:with-param name="probe" select="$probe"/>
  </xsl:apply-templates>
</xsl:template>


<!-- ==================================================================== -->

<!-- The following templates now works only with the listings package -->

<!-- The listing content is internal to the element, and is not a reference
     to an external file -->

<xsl:template match="programlisting|screen|literallayout" mode="internal">
  <xsl:param name="opt"/>
  <xsl:param name="co-tagin"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="env" select="'lstlisting'"/>


  <xsl:text>&#10;\begin{</xsl:text>
  <xsl:value-of select="$env"/>
  <xsl:text>}</xsl:text>
  <xsl:if test="$opt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$opt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <!-- some text just after the open tag must be put on a new line -->
  <xsl:if test="not(contains(.,'&#10;')) or
                string-length(normalize-space(
                  substring-before(.,'&#10;')))&gt;0">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="latex.programlisting">
    <xsl:with-param name="co-tagin" select="$co-tagin"/>
    <xsl:with-param name="rnode" select="$rnode"/>
  </xsl:apply-templates>
  <!-- ensure to have the end on a separate line -->
  <xsl:if test="substring(.,string-length(.))!='&#10;' and
                substring(translate(.,' &#09;',''),
                  string-length(translate(.,' &#09;','')))!='&#10;'">
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>\end{</xsl:text>
  <xsl:value-of select="$env"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="linenumbering">
  <xsl:choose>
    <xsl:when test="@linenumbering='numbered'">1</xsl:when>
    <xsl:when test="@linenumbering and @linenumbering!='numbered'">0</xsl:when>
    <xsl:when test="$linenumbering.default='numbered' and 
                   (contains(concat(' ',$linenumbering.scope,' '),
                             concat(' ',local-name(.),' ')))">1</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
  </xsl:choose>
</xsl:template>
 
<xsl:template match="programlisting|screen|literallayout">
  <xsl:param name="rnode" select="/"/>

  <!-- formula to compute the listing width -->
  <xsl:variable name="width">
    <xsl:if test="$literal.width.ignore='0' and
                  @width and string(number(@width))!='NaN'">
      <xsl:text>\setlength{\lstwidth}{</xsl:text>
      <xsl:value-of select="@width"/>
      <xsl:text>\lstcharwidth+2\lstframesep}</xsl:text>
    </xsl:if>
  </xsl:variable>

  <!-- is there some elements needing escaping? -->
  <xsl:variable name="escaped">
    <xsl:apply-templates mode="latex.programlisting">
      <xsl:with-param name="probe" select="1"/>
    </xsl:apply-templates>
  </xsl:variable>

  <!-- get the listing escape sequence if needed -->
  <xsl:variable name="co-tagin">
    <xsl:if test="descendant::co or $escaped != ''">
      <xsl:call-template name="co-tagin-gen"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="linenumbered">
    <xsl:call-template name="linenumbering"/>
  </xsl:variable>

  <xsl:variable name="role">
    <xsl:choose>
    <xsl:when test="@role">
      <xsl:value-of select="@role"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$literal.role"/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="opt">
    <!-- skip empty endlines -->
    <xsl:if test="$literal.lines.showall='0'">
      <xsl:text>showlines=false,</xsl:text>
    </xsl:if>
    <!-- Remove wrap mode if required -->
    <xsl:if test="$role='overflow'">
      <xsl:text>breaklines=false,</xsl:text>
    </xsl:if>
    <!-- The scaling feature is not available with standard listings -->
    <xsl:if test="contains($literal.extensions, 'scale')">
      <xsl:choose>
      <xsl:when test="$role='scale' or 
          ($role='' and $literal.extensions='scale.by.width' and $width!='')">
        <xsl:text>scale=true,</xsl:text>
        <!-- don't wrap to scale to the longest line if no width specified -->
        <xsl:if test="$width=''">
          <xsl:text>breaklines=false,</xsl:text>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>scale=false,</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- language option is only for programlisting -->
    <xsl:if test="@language">
      <xsl:text>language=</xsl:text>
      <xsl:value-of select="@language"/>
      <xsl:text>,</xsl:text>
    </xsl:if>
    <!-- listing width -->
    <xsl:if test="$width!=''">
      <xsl:text>linewidth=\lstwidth,</xsl:text>
    </xsl:if>
    <!-- print line numbers -->
    <xsl:if test="$linenumbered=1">
      <xsl:text>numbers=left,</xsl:text>
      <xsl:if test="number($linenumbering.everyNth) &gt; 1">
        <xsl:text>stepnumber=</xsl:text>
        <xsl:value-of select="number($linenumbering.everyNth)"/>
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:if>
    <!-- find the fist line number to print -->
    <xsl:choose>
    <xsl:when test="@startinglinenumber">
      <xsl:text>firstnumber=</xsl:text>
      <xsl:value-of select="@startinglinenumber"/>
      <xsl:text>,</xsl:text>
    </xsl:when>
    <xsl:when test="@continuation and (@continuation='continues')">
      <!-- ask for continuation -->
      <xsl:text>firstnumber=last</xsl:text>
      <xsl:text>,</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <!-- explicit restart numbering -->
      <xsl:text>firstnumber=1</xsl:text>
      <xsl:text>,</xsl:text>
    </xsl:otherwise>
    </xsl:choose>
    <!-- In literallayout no specific background, nor monospaced font -->
    <xsl:if test="self::literallayout">
      <xsl:text>backgroundcolor={},</xsl:text>
      <xsl:choose>
      <xsl:when test="@class='monospaced' or
                      $literal.class='monospaced'">
        <xsl:text>basicstyle=\ttfamily,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>basicstyle=\normalfont,flexiblecolumns,</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- TeX/verb delimiters if tex or formatting is embedded (like <co>s) -->
    <xsl:if test="$co-tagin!=''">
      <xsl:call-template name="listing-delim">
        <xsl:with-param name="tagin" select="$co-tagin"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

  <!-- put the listing with formula here -->
  <xsl:if test="$width!=''">
    <xsl:text>&#10;</xsl:text>
    <xsl:value-of select="$width"/>
  </xsl:if>
  <xsl:choose>
  <xsl:when test="descendant::imagedata[@format='linespecific']|
                  descendant::inlinegraphic[@format='linespecific']|
                  descendant::textdata">
    <!-- the listing content is in an external file -->
    <xsl:text>&#10;\lstinputlisting</xsl:text>
    <xsl:if test="$opt!=''">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$opt"/>
      <xsl:text>]</xsl:text>
    </xsl:if>
    <xsl:text>{</xsl:text>
    <xsl:apply-templates
        select="descendant::imagedata|descendant::inlinegraphic|
                descendant::textdata"
        mode="filename.get"/>
    <xsl:text>}&#10;</xsl:text>
  </xsl:when>
  <xsl:otherwise>
    <!-- the listing content is internal -->
    <xsl:apply-templates select="." mode="internal">
      <xsl:with-param name="rnode" select="$rnode"/>
      <xsl:with-param name="co-tagin" select="$co-tagin"/>
      <xsl:with-param name="opt" select="$opt"/>
      <xsl:with-param name="env" select="$literal.environment"/>
    </xsl:apply-templates>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Defines the style delimiters to use, and the tex sequence delimiters -->

<xsl:template name="listing-delim">
  <xsl:param name="tagin" select="'&lt;'"/>
  <xsl:variable name="tex" select="concat($tagin, 't&gt;')"/>
  <xsl:variable name="bf" select="concat($tagin, 'b&gt;')"/>
  <xsl:variable name="it" select="concat($tagin, 'i&gt;')"/>

  <xsl:text>escapeinside={</xsl:text>
  <xsl:value-of select="$tex"/>
  <xsl:text>}{&lt;/t&gt;}</xsl:text>
  <xsl:text>,</xsl:text>
  <xsl:text>moredelim={**[is][\bfseries]{</xsl:text>
  <xsl:value-of select="$bf"/>
  <xsl:text>}{&lt;/b&gt;}},</xsl:text>
  <xsl:text>moredelim={**[is][\itshape]{</xsl:text>
  <xsl:value-of select="$it"/>
  <xsl:text>}{&lt;/i&gt;}},</xsl:text>
</xsl:template>

<!-- ==================================================================== -->

<!-- Global listing saving, for listings in footnotes, since we never know
     in which context the footnotes are used. A check is done to not cover
     the other saving points in tables. -->

<xsl:template match="programlisting|screen|literallayout"
              mode="save.verbatim.preamble">
  <xsl:if test="not(ancestor::table or ancestor::informaltable) and
                ancestor::footnote">
    <xsl:apply-templates select="." mode="save.verbatim"/>
  </xsl:if>
</xsl:template>


<!-- Listings does not work in tables, even for external files. So, we
     use the fancyvrb verbatim coupled to listings for the rendering stuff.
     This mode assumes that all the verbatim data is in an external
     file. Using the save/use commands would work except for linenumbering
     stuff. -->

<xsl:template match="programlisting|screen|literallayout"
              mode="save.verbatim">
  <xsl:if test="not(descendant::imagedata[@format='linespecific']|
                    descendant::inlinegraphic[@format='linespecific']|
                    descendant::textdata)">
    <xsl:variable name="str1" select="."/>
    <xsl:variable name="str">
      <xsl:apply-templates mode="latex.programlisting"/>
    </xsl:variable>

    <xsl:text>\begin{VerbatimOut}{tmplst-</xsl:text>
    <xsl:value-of select="generate-id()"/>
    <xsl:text>}</xsl:text>
    <!-- some text just after the open tag must be put on a new line -->
    <xsl:if test="not(contains($str1,'&#10;')) or
           string-length(
             normalize-space(substring-before($str1,'&#10;')))&gt;0">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:value-of select="$str"/>
    <!-- put a \n only if needed -->
    <xsl:if test="substring($str1,string-length($str1))!='&#10;' and
                  substring(translate($str1,' &#09;',''),
                    string-length(translate($str1,' &#09;','')))!='&#10;'">
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
    <xsl:text>\end{VerbatimOut}&#10;</xsl:text>
  </xsl:if>
</xsl:template>


<!-- Special case for literal blocks in tables or foonotes -->
<xsl:template match="*[self::entry or
                       self::entrytbl or
                       self::footnote]//
                     *[self::programlisting or
                       self::screen or
                       self::literallayout]">

  <xsl:variable name="lsopt">
    <!-- language option is only for programlisting -->
    <xsl:if test="@language">
      <xsl:text>language=</xsl:text>
      <xsl:value-of select="@language"/>
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="linenumbered">
    <xsl:call-template name="linenumbering"/>
  </xsl:variable>

  <xsl:variable name="fvopt">
    <!-- print line numbers -->
    <xsl:if test="$linenumbered=1">
      <xsl:text>numbers=left,</xsl:text>
      <xsl:if test="number($linenumbering.everyNth) &gt; 1">
        <xsl:text>stepnumber=</xsl:text>
        <xsl:value-of select="number($linenumbering.everyNth)"/>
        <xsl:text>,</xsl:text>
      </xsl:if>
      <!-- find the fist line number to print -->
      <xsl:choose>
      <xsl:when test="@startinglinenumber">
        <xsl:text>firstnumber=</xsl:text>
        <xsl:value-of select="@startinglinenumber"/>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:when test="@continuation and (@continuation='continues')">
        <!-- ask for continuation -->
        <xsl:text>firstnumber=last</xsl:text>
        <xsl:text>,</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- explicit restart numbering -->
        <xsl:text>firstnumber=1</xsl:text>
        <xsl:text>,</xsl:text>
      </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <!-- In literallayout no specific background, nor monospaced font -->
    <xsl:if test="self::literallayout">
      <xsl:choose>
      <xsl:when test="@class='monospaced' or
                      $literal.class='monospaced'">
        <xsl:text>fontfamily=tt,</xsl:text>
      </xsl:when>
      <!-- FIXME: don't know how to force to use normal text font -->
      </xsl:choose>
    </xsl:if>
    
    <!-- TODO: TeX delimiters if <co>s are embedded. Use commandchars -->
  </xsl:variable>

  <xsl:text>\begin{fvlisting}</xsl:text>
  <xsl:if test="$lsopt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$lsopt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:text>\VerbatimInput</xsl:text>
  <xsl:if test="$fvopt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$fvopt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>

  <xsl:text>{</xsl:text>
  <xsl:choose>
  <xsl:when test="descendant::imagedata[@format='linespecific']|
                  descendant::inlinegraphic[@format='linespecific']|
                  descendant::textdata">
    <!-- the listing content is in a (real) external file -->
    <xsl:apply-templates
        select="descendant::imagedata|descendant::inlinegraphic|
                descendant::textdata"
        mode="filename.abs.get"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- the listing is outputed in a temporary file -->
    <xsl:text>tmplst-</xsl:text>
    <xsl:value-of select="generate-id(.)"/>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>}&#10;</xsl:text>

  <xsl:text>\end{fvlisting}&#10;</xsl:text>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="filename.abs.get">
  <xsl:choose>
  <xsl:when test="@entityref">
    <xsl:value-of select="unparsed-entity-uri(@entityref)"/>
  </xsl:when>
  <xsl:when test="contains(@fileref, ':')">
    <!-- absolute uri scheme -->
    <xsl:value-of select="substring-after(@fileref, ':')"/>
  </xsl:when>
  <xsl:when test="starts-with(@fileref, '/')">
    <!-- absolute unix like path -->
    <xsl:value-of select="@fileref"/>
  </xsl:when>
  <xsl:otherwise>
    <!-- relative to the doc directory -->
    <xsl:value-of select="$current.dir"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="@fileref"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


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




<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX 
    ############################################################################ -->

<xsl:variable name="version">0.3.7</xsl:variable>


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
                or local-name($target) = 'para'">
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

  <!-- Get the normal markup but replace hot links by counters -->
  <xsl:variable name="xref.text">
    <xsl:call-template name="string-replace">
      <xsl:with-param name="string">
        <xsl:apply-templates select="."/>
      </xsl:with-param>
      <xsl:with-param name="from" select="'\ref{'"/>
      <xsl:with-param name="to" select="'\ref*{'"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Remove an internal hyperlink wrapper (external links seem ok) -->
  <xsl:choose>
    <xsl:when test="starts-with($xref.text, '\hyperlink{')">
      <xsl:value-of select="substring-after($xref.text, '}')"/>
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
