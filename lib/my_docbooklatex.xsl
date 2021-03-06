<?xml version='1.0' encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0' 
  xmlns:str="http://exslt.org/strings" 
   extension-element-prefixes="str">
<xsl:output method="text" encoding="UTF-8" />   
<!-- Shahryar: I added support for eslt string funcs-->
<!-- <xsl:import href="str.xsl" />    --><!--not needed with updated xsltproc-->
<!--iso-8859-1-->
 
<!-- Let's import our own XSL to override the default behaviour. -->
<!-- <xsl:import href="mystyle.xsl"/> -->


<!-- 
************************************************************************************
************************************************************************************
Shahryar special addons
************************************************************************************
************************************************************************************
 -->  




<!-- 
************************************************************************************
Parameters
************************************************************************************
 -->  
<xsl:param name="latex.encoding">utf8</xsl:param>
<!-- <xsl:param name="latex.encoding.use">1</xsl:param> -->
<xsl:param name="citation.natbib.use">1</xsl:param>
<xsl:param name="figure.default.position">[htbp]</xsl:param>







<!-- 
=================================
Extension Functions
================================= 
-->  

<!-- Replace -->
 <xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="by" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>





<!-- 
=================================
Book Parts
================================= 
-->  

<!-- Dedication (headless), Shahryar -->
<!-- <xsl:template match="part">
  <xsl:text>\mypart{</xsl:text>  
        <xsl:value-of select="./title"/>
  <xsl:text>}</xsl:text>
  <xsl:text>{</xsl:text>
        <xsl:value-of select="./partintro/*[not(self::title)]"/>
  <xsl:text>}&#xa;</xsl:text>
        <xsl:apply-templates select="*[not(self::title | self::partintro)]"/>
</xsl:template>   -->

<xsl:template match="part">
  <xsl:text>%&#10;</xsl:text>
  <xsl:text>% PART&#10;</xsl:text>
  <xsl:text>%&#10;</xsl:text>
  <xsl:call-template name="mapheading"/>
  <xsl:apply-templates/>
  <!-- Force exiting the part. It assumes the bookmark package available -->
  <xsl:if test="not(following-sibling::part)">
    <xsl:text>\amPartEnding{}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="part[partintro/@role='backpage']">
  <xsl:text>%&#10;</xsl:text>
  <xsl:text>% PART (with back pageinfo)&#10;</xsl:text>
  <xsl:text>%&#10;</xsl:text>
  <xsl:apply-templates select="partintro" mode="backpage"/>
  <xsl:call-template name="mapheading"/>
  <!-- <xsl:text>\makeatletter\@openrightfalse\makeatother\thispagestyle{empty}&#10;</xsl:text> -->
  <!-- <xsl:text> \makeatletter\@openrighttrue\makeatother&#10;</xsl:text> -->
  <xsl:text>\myresetpartnote{}</xsl:text>
  <xsl:apply-templates/>
  <!-- Force exiting the part. It assumes the bookmark package available -->
  <xsl:if test="not(following-sibling::part)">
    <xsl:text>\amPartEnding{}&#10;</xsl:text>
  </xsl:if>
</xsl:template>
<xsl:template match="part[partintro/@role='frontimage']">
  <xsl:text>%&#10;</xsl:text>
  <xsl:text>% PART (with back pageinfo)&#10;</xsl:text>
  <xsl:text>%&#10;</xsl:text>
  <xsl:apply-templates select="partintro" mode="frontimage"/>
  <xsl:call-template name="mapheading"/>
  <!-- <xsl:text>\makeatletter\@openrightfalse\makeatother\thispagestyle{empty}&#10;</xsl:text> -->
  <!-- <xsl:text> \makeatletter\@openrighttrue\makeatother&#10;</xsl:text> -->
  <xsl:text>\myresetpartnote{}</xsl:text>
  <xsl:apply-templates/>
  <!-- Force exiting the part. It assumes the bookmark package available -->
  <xsl:if test="not(following-sibling::part)">
    <xsl:text>\amPartEnding{}&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="partintro"/><!-- Disables standalone partintro -->
<xsl:template match="partintro" mode="backpage">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\mysetpartnote{</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>
<xsl:template match="partintro" mode="frontimage">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amSetPartNoteFrontImage{</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!-- Dedication (headless), Shahryar -->
<xsl:template match="dedication">
  <xsl:text>&#xa;</xsl:text>     
<!--   <xsl:text>\begin{amDedication}</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>\end{amDedication}&#xa;</xsl:text> -->
<xsl:text>\amDedication{</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]" />  
  <xsl:text>}&#xa;</xsl:text>   
</xsl:template>  

<!-- Colophon (headless), Shahryar -->
<xsl:template match="colophon">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\begin{amColophon}</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>\end{amColophon}&#xa;</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template>

<!-- Glossary , Shahryar -->
<xsl:template match="glossary">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\amGlossary[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template>

<!-- Biblio , Shahryar -->
<xsl:template match="bibliography[contains(concat(' ', normalize-space(@role), ' '), ' amBibPage ')]">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\amBibPage[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template>  

<xsl:template match="bibliography[contains(concat(' ', normalize-space(@role), ' '), ' ambibsection')]">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\amBibSection{</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>}</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template>  

<xsl:template match="bibliography[contains(concat(' ', normalize-space(@role), ' '), ' amBibChapter')]">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\amBibChapter{</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>}</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template>  

<!-- Index , Shahryar -->
<xsl:template match="index">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\amIndex[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:text>&#xa;</xsl:text>     
</xsl:template>  


<!-- Book Keywords, Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amBookKeywords ')]">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\begin{amBookKeywords}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amBookKeywords}&#xa;</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template> 




<!-- Book Table of Contents, Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amTableOfContents ')]">
  <xsl:text>&#xa;</xsl:text>     
  <xsl:text>\amTableOfContents[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template> 


<!-- Acknowledgements , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amAcknowledgements ')]">
  <xsl:text>\begin{amAcknowledgements}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amAcknowledgements}&#xa;</xsl:text>
</xsl:template>   

<!-- Preface , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amPreface ')] | preface">
  <xsl:text>\begin{amPreface}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amPreface}&#xa;</xsl:text>
</xsl:template>   

<!-- Book Abstract , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amBookAbstract ')] | abstract">
  <xsl:text>\begin{amBookAbstract}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]&#xa;</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amBookAbstract}&#xa;</xsl:text>
</xsl:template>   

<!-- Book Epigraph (headless), Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amBookEpigraph ')]">
 <xsl:text>\amBookEpigraph{</xsl:text>
  <xsl:apply-templates select="blockquote/simpara" />
  <xsl:text>}{</xsl:text>
  <xsl:variable name="quote_owner"><xsl:apply-templates select="blockquote/attribution/node()[not(self::citetitle)]"/></xsl:variable>
    <xsl:value-of select="normalize-space(translate($quote_owner, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
  <!-- <xsl:apply-templates select="blockquote/attribution/node()[not(self::citetitle)]" /> -->
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates select="blockquote/attribution/citetitle/node()" /><xsl:text>}&#xa;</xsl:text> 
</xsl:template>  

<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amBookEpigraphTwo ')]">
 <xsl:text>\amBookEpigraphTwo{</xsl:text>
  <xsl:apply-templates select="blockquote[1]/simpara" />
  <xsl:text>}{</xsl:text>
  <xsl:variable name="quote_owner1"><xsl:apply-templates select="blockquote[1]/attribution/node()[not(self::citetitle)]"/></xsl:variable>
    <xsl:value-of select="normalize-space(translate($quote_owner1, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates select="blockquote[1]/attribution/citetitle/node()" /><xsl:text>}{</xsl:text> 
  <xsl:apply-templates select="blockquote[2]/simpara" />
  <xsl:text>}{</xsl:text>
  <xsl:variable name="quote_owner2"><xsl:apply-templates select="blockquote[2]/attribution/node()[not(self::citetitle)]"/></xsl:variable>
    <xsl:value-of select="normalize-space(translate($quote_owner2, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates select="blockquote[2]/attribution/citetitle/node()" /><xsl:text>}&#xa;</xsl:text>
</xsl:template>  


<!-- Book End Notes , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' amEndnotesChapter ')] ">
  <xsl:text>\begin{amEndnotesChapter}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amEndnotesChapter}&#xa;</xsl:text>
</xsl:template> 


<!-- 
=================================
Chapter Parts (and text blocks)
================================= 
-->  


<!--  Section Graybox -->
<xsl:template match="section[contains(concat(' ', normalize-space(@role), ' '), ' amGrayBox ')] | formalpara[contains(concat(' ', normalize-space(@role), ' '), ' amGrayBox ')]">
  <xsl:text>&#10;</xsl:text>    
  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\begin{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\begin{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>\begin{amGrayBox}</xsl:text>

    <xsl:text>[</xsl:text> 
    <xsl:value-of select="title" />  
    <xsl:text>]</xsl:text> 
    <xsl:text>&#10;</xsl:text>    
    <xsl:copy>
      <xsl:apply-templates select="figure/mediaobject/imageobject"/>
    </xsl:copy>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="figure/mediaobject/textobject/*">  
      <xsl:text>\captionof{figure}[</xsl:text>    
        <xsl:copy>
          <xsl:apply-templates select="figure/mediaobject/textobject/*"/>
        </xsl:copy>
      <xsl:text>]{</xsl:text>    
        <xsl:copy>
          <xsl:apply-templates select="figure/mediaobject/textobject/*"/>
        </xsl:copy>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="(node()|*)[not(self::figure | self::title)]"/>
    </xsl:copy>
  <xsl:text>\end{amGrayBox}</xsl:text>
  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\end{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\end{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 



<!--  Section Graybox -->
<xsl:template match="section[contains(concat(' ', normalize-space(@role), ' '), ' amGrayBoxThumbnail ')] | formalpara[contains(concat(' ', normalize-space(@role), ' '), ' amGrayBox ')]">
  <xsl:text>&#10;</xsl:text>    
  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\begin{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\begin{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>\begin{amGrayBoxThumbnail}</xsl:text>

    <xsl:text>[</xsl:text> 
    <xsl:value-of select="title" />  
    <xsl:text>]</xsl:text> 
    <xsl:text>&#10;</xsl:text>    
    <xsl:copy>
      <xsl:apply-templates select="figure/mediaobject/imageobject"/>
    </xsl:copy>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="figure/mediaobject/textobject/*">  
      <xsl:text>\captionof{figure}[</xsl:text>    
        <xsl:copy>
          <xsl:apply-templates select="figure/mediaobject/textobject/*"/>
        </xsl:copy>
      <xsl:text>]{</xsl:text>    
        <xsl:copy>
          <xsl:apply-templates select="figure/mediaobject/textobject/*"/>
        </xsl:copy>
      <xsl:text>}</xsl:text>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="(node()|*)[not(self::figure | self::title)]"/>
    </xsl:copy>
  <xsl:text>\end{amGrayBoxThumbnail}</xsl:text>
  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\end{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\end{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 




<!--  Section GrayZone -->
<xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amGrayZone ')]" name="grayzone">
  <xsl:text>&#10;</xsl:text>    
  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\begin{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\begin{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>\begin{amGrayZone}[</xsl:text>
      <xsl:value-of select="title"/>
    <!-- <xsl:copy> 
      <xsl:apply-templates select="title"/>
    </xsl:copy>    -->
  <xsl:text>]{</xsl:text>
  
    <xsl:text>&#10;</xsl:text>  

      <!-- <xsl:copy-of select=".[contains(concat(' ', normalize-space(@role), ' '), ' amgrayzone ')]">  -->
        <xsl:apply-templates /><!-- (*|node()) -->
      <!-- </xsl:copy-of> -->

  <xsl:text>\end{amGrayZone}</xsl:text>

  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\end{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\end{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 




<!--  Section Graybox -->
<xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amGrayZoneTwo ')]" name="grayzonetwo">
  <xsl:text>&#10;</xsl:text>    
  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\begin{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\begin{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
<xsl:text>\begin{amGrayZoneTwo}[</xsl:text>
      <xsl:value-of select="title"/>
    <!-- <xsl:copy> 
      <xsl:apply-templates select="title"/>
    </xsl:copy>    -->
  <xsl:text>]{</xsl:text>

  
    <xsl:text>&#10;</xsl:text>  

      <!-- <xsl:copy-of select=".[contains(concat(' ', normalize-space(@role), ' '), ' amgrayzoneTwo ')]">  -->
        <xsl:apply-templates /><!-- (*|node()) -->
      <!-- </xsl:copy-of> -->

  <xsl:text>\end{amGrayZoneTwo}</xsl:text>

  <xsl:choose>
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amFullWidth ')]">
    <xsl:text>\end{amFullWidth}</xsl:text>
  </xsl:when>    
  <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amWrapTextExpandToMargin ')]">
    <xsl:text>\end{amWrapTextExpandToMargin}</xsl:text>
  </xsl:when>
  <xsl:otherwise>
  </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 





<!--  Code Listing Graybox -->
<xsl:template match="programlisting|screen|literallayout" mode="internal">
  <xsl:param name="opt"/>
  <xsl:param name="co-tagin"/>
  <xsl:param name="rnode" select="/"/>
  <xsl:param name="env" select="'amListing'"/>


  <xsl:if test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amfullwidth ')]">
  <xsl:text>\begin{amFullWidth}</xsl:text>
  </xsl:if>    

  <xsl:variable name="amenv">
  <xsl:choose>
      <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amroutput ')]">amROutput</xsl:when>
      <xsl:otherwise>amVerbatimConsole</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:text>&#10;\begin{</xsl:text>
    <xsl:value-of select="$amenv" />
  <xsl:text>}&#10;</xsl:text>

  <!-- <xsl:value-of select="$env"/> -->
<!--   <xsl:if test="$opt!=''">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$opt"/>
    <xsl:text>]</xsl:text>
  </xsl:if>
 -->
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

  <xsl:text>&#10;\end{</xsl:text>
    <xsl:value-of select="$amenv" />
  <xsl:text>}&#10;</xsl:text>  
  <!-- <xsl:value-of select="$env"/> -->
  <xsl:if test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amfullwidth ')]">
    <xsl:text>\end{amFullWidth}</xsl:text>
  </xsl:if>      


</xsl:template>



<!-- Chapter Subtitle -->
<xsl:template match="phrase[@role='amChapterSubtitle']">
  <xsl:text>\amChapterSubtitle{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
  <xsl:text>&#10;</xsl:text>  
</xsl:template> 


<!-- Chapter Running Head -->
<xsl:template match="simpara[@role='amChapterRunningHead']">
  <xsl:text>\amChapterRunningHead{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
  <xsl:text>&#10;</xsl:text>  
</xsl:template> 


<!-- Chapter Authors -->
<xsl:template match="simpara[@role='chapter_authors']">
  <xsl:text>\amChapterAuthor{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
  <xsl:text>&#10;</xsl:text>  
</xsl:template> 

<!-- Chapter Abstract -->
<xsl:template match="section[@role='chapter_abstract']">
  <xsl:text>\begin{amChapterAbstract}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amChapterAbstract}</xsl:text>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 

<!-- Chapter Keywords -->
<xsl:template match="section[@role='amChapterKeywords']">
  <xsl:text>\begin{amChapterKeywords}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amChapterKeywords}&#xa;</xsl:text>
</xsl:template>

<!-- Chapter Summary -->
<xsl:template match="*[@role='amSummaryBlock']">
  <xsl:text>\begin{amSummaryBlock}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amSummaryBlock}&#xa;</xsl:text>
</xsl:template> 


<!-- Chapter Summary -->
<xsl:template match="*[@role='amCoverBlock']">
  <xsl:text>\begin{amCoverBlock}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{amCoverBlock}&#xa;</xsl:text>
</xsl:template> 

<!-- No Head Section -->
<xsl:template match="section[@role='amNoHeadSect']">
  <xsl:text>\section*{}</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 


<!-- Chapter Epigraph, Shahryar -->
<xsl:template match="blockquote[contains(concat(' ', normalize-space(@role), ' '), ' epigraph ')]">
  <xsl:text>&#xa;\begin{epigraphs}</xsl:text>  
      <!-- <xsl:copy-of select="mediaobject|informalfigure"> -->
        <xsl:apply-templates select="mediaobject|informalfigure"/>
      <!-- </xsl:copy-of> -->
      <xsl:text>&#xa;\qitem{</xsl:text><!-- \begin{verse}\setlength{\leftmargini}{0pt} -->
      <!-- <xsl:text>\enquote{</xsl:text>     -->
        <xsl:apply-templates select="(*|node())[not(self::mediaobject|self::informalfigure|self::attribution)]"/>
      <!-- <xsl:text>}&#xa;</xsl:text>   -->
    <xsl:text>}{\textemdash~</xsl:text><!-- \textemdash --><!-- \end{verse} --><xsl:value-of select="./attribution/text()"/>
      <xsl:if test="./attribution/citetitle">
        <xsl:text>,~</xsl:text><xsl:text>\emph{</xsl:text><!-- footnote, marginnote -->
        <xsl:value-of select="./attribution/citetitle/text()"/>
        <xsl:text>}</xsl:text>
      </xsl:if>
    <xsl:text>}&#xa;</xsl:text>
  <xsl:text>\end{epigraphs}&#xa;</xsl:text>  
</xsl:template>

<!-- Algorithm -->
<xsl:template match="screen[@role='algorithm']">
  <xsl:copy-of  select="text()"/>  
</xsl:template> 


<!-- Chapter Keywords -->
<xsl:template match="sidebar">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amAside{%</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 

<xsl:template match="sidebar[contains(concat(' ', normalize-space(@role), ' '), ' amMarginNextPage ')]">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amAside{</xsl:text><xsl:apply-templates /><xsl:text>}[n]</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 


<!-- Side summaries -->
<!-- Verbs=sidesummary, -->
<xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' side-summary ')]">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amAside{</xsl:text><xsl:apply-templates /><xsl:text>}</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 


<xsl:template match="text()" name="my_remove_space" mode="remove_space">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="blockquote">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\begin{amBlockQuote}[</xsl:text>
  <xsl:variable name="quote_owner"><xsl:apply-templates select="attribution/node()[not(self::citetitle)]"/></xsl:variable>
    <xsl:value-of select="normalize-space(translate($quote_owner, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
  <xsl:text>][</xsl:text>
    <xsl:apply-templates select="attribution/citetitle/node()"/>
  <xsl:text>]%</xsl:text>
    <xsl:apply-templates select="(node()|*)[not(self::attribution)]"/>
    <xsl:text>\end{amBlockQuote}&#xa;</xsl:text>
</xsl:template>

<xsl:template match="blockquote11111111">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\begin{quote}</xsl:text>
    <xsl:apply-templates select="(node()|*)[not(self::attribution)]"/>
    <xsl:text>&#10;</xsl:text>    
    <xsl:apply-templates select="attribution"/>
    <xsl:text>\end{quote}&#xa;</xsl:text>
</xsl:template>

<!-- <xsl:template match="text()" mode="nospace" priority="1" name="mynospace">
    <xsl:value-of select="normalize-space(.)" />
</xsl:template> -->

 <xsl:template match="attribution1111111111">

    <xsl:text>&#xa;</xsl:text>
    <xsl:text>\hspace*\fill</xsl:text>
    <xsl:text>\begin{varwidth}{0.7\linewidth}\RaggedLeft---</xsl:text>
    <xsl:call-template match="node() | @*" mode="nospace" name="mynospace">
      <xsl:copy>
        <xsl:apply-templates select="(node()|*)[not(self::citetitle)]"/>
      </xsl:copy>
    </xsl:call-template>
  <xsl:text>, </xsl:text>
  <xsl:apply-templates select="(node()|*)[self::citetitle]"/>
    <xsl:text>\end{varwidth}</xsl:text>
</xsl:template>


<!-- 
=================================
Paragraph & Phrase Parts
================================= 
-->

<!-- let the direct latex core -->
<xsl:template match="remark[not(@role='latexcode')]">
</xsl:template>
<xsl:template match="remark[@role='latexcode'] | remark[@role='amLatexCode']">
  <xsl:value-of select="."/>
</xsl:template>



<!-- include pdf -->
<xsl:template match="remark[@role='amIncludePDF']">
  <xsl:text>&#10;\amIncludePDF[</xsl:text>
  <xsl:value-of select="@arch"/>
  <xsl:text>]{</xsl:text>
  <xsl:value-of select="@condition"/>
  <xsl:text>}&#10;</xsl:text>
</xsl:template>

<!-- amBeginFromOddPage -->
<xsl:template match="remark[@role='amBeginFromOddPage']">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amBeginFromOddPage%</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 


<!-- amBeginFromOddPage -->
<xsl:template match="remark[@role='amVSkip']">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amVSkip[</xsl:text>
  <xsl:value-of select="@condition"/>
  <xsl:text>]%&#10;</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 



<!-- amChapterToC -->
<xsl:template match="remark[@role='amChapterToC']">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\amChapterToC%</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 


<!-- new refsection for biblatex -->
<xsl:template match="remark[@role='amNewRefSection']">
  <xsl:text>\amNewRefSection{}&#10;</xsl:text>
</xsl:template>
<xsl:template match="remark[@role='amEndRefSection']">
  <xsl:text>\amEndRefSection{}&#10;</xsl:text>
</xsl:template>


<!-- new refsection for biblatex -->
<xsl:template match="remark[@role='amResetGls']">
  <xsl:text>&#10;\amResetGls%&#10;</xsl:text>
</xsl:template>

<!-- Cross Ref -->


<xsl:template match="xref[@linkend]">
  <!-- <xsl:text>\hyperlink{</xsl:text> -->
  <!-- <xsl:value-of select="@linkend"/> -->
  <!-- <xsl:text>}{\Cref{</xsl:text> -->
  <xsl:text>\Cref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}</xsl:text>
  <!-- <xsl:text>}}</xsl:text> -->
</xsl:template>



<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amCombinedRef ')]">
<xsl:for-each select="xref[@linkend]">
  <xsl:choose>
    <xsl:when test="position() = '1'">
          <xsl:text>\Cref{</xsl:text>
          <xsl:value-of select="@linkend"/>
    </xsl:when>
    <xsl:otherwise>
          <xsl:text>,</xsl:text>
          <xsl:value-of select="@linkend"/>
    </xsl:otherwise>
    </xsl:choose>
  <xsl:if test="position()= last()">
        <xsl:text>}</xsl:text>
  </xsl:if>
</xsl:for-each>
  </xsl:template>

<!-- We changed amCiteP to autocite because of problem in auto moving around period after citation -->
<!-- we cannot support multipe citation with page number at the same time -->
<!-- Citation to \citep or \citet-->
<xsl:template match="citation[contains(concat(' ', normalize-space(@role), ' '), ' citep ')]">
  <!-- <xsl:text>\amCiteP{</xsl:text> -->
  <xsl:variable name="citation_key" select="." disable-output-escaping = "yes" />
  <xsl:variable name="citation_page" select="@condition" disable-output-escaping = "yes" />
  <xsl:text>\autocite</xsl:text>
  <xsl:if test="@condition">
    <xsl:text>[</xsl:text>
        <!-- <xsl:value-of select="control" disable-output-escaping = "yes" /> -->
        <xsl:value-of select="$citation_page" disable-output-escaping = "yes" />
    <xsl:text>]</xsl:text>
  </xsl:if>      
  <xsl:text>{</xsl:text>
        <!-- <xsl:value-of select="." disable-output-escaping = "yes" /> -->
        <xsl:value-of select="$citation_key" disable-output-escaping = "yes" />
  <xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="citation[contains(concat(' ', normalize-space(@role), ' '), ' citet ')]">
  <xsl:variable name="citation_key" select="." disable-output-escaping = "yes" />
  <xsl:variable name="citation_page" select="@condition" disable-output-escaping = "yes" />
  <xsl:text>\citeyear</xsl:text>
  <!-- <xsl:text>\amCiteT{</xsl:text> -->
        <!-- <xsl:value-of select="control" disable-output-escaping = "yes" /> -->
  <xsl:if test="@condition">
    <xsl:text>[</xsl:text>
        <!-- <xsl:value-of select="control" disable-output-escaping = "yes" /> -->
        <xsl:value-of select="$citation_page" disable-output-escaping = "yes" />
    <xsl:text>]</xsl:text>
  </xsl:if>      
  <xsl:text>{</xsl:text>
        <!-- <xsl:value-of select="." disable-output-escaping = "yes" /> -->
        <xsl:value-of select="$citation_key" disable-output-escaping = "yes" />
  <xsl:text>}</xsl:text>
</xsl:template> 


<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amFullCite ')]">
  <xsl:text>\amFullCite</xsl:text>
  <xsl:text>{</xsl:text>
        <xsl:value-of select="text()" disable-output-escaping = "yes" />
  <xsl:text>}</xsl:text>
</xsl:template> 

<!-- Unicode Letters -->
<!-- <xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' unicode ')]">
  <xsl:variable name="the_string">
    <xsl:call-template name="string-replace-all">
      <xsl:with-param name="text" select="text()" />
      <xsl:with-param name="replace" select="'ø'" />
      <xsl:with-param name="by" select="'Z'" />
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$the_string"/>  
</xsl:template>  -->

<!-- Manual Indent -->
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' hs1 ')]">
  <xsl:text>\phantom{m}~</xsl:text>
</xsl:template> 
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' hs2 ')]">
  <xsl:text>\phantom{m}\hspace{1em}~</xsl:text>
</xsl:template> 

<!-- Sparklines -->
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amSparkBarThin ')]">
  <xsl:text>\amSparkline{BarThin}{</xsl:text>
    <!-- removes the first and the last {} chars -->
      <!-- <xsl:value-of select="substring(., 2, string-length(.) - 2)" /> -->
      <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>


<!-- Roman Numbers -->
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amColorRed ')]">
  <xsl:text>\amColorRed{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amRomanNumRed ')]">
  <xsl:text>\amColorRed{</xsl:text>
  <xsl:text>\amRomanNumUp{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
  <xsl:text>}</xsl:text>
</xsl:template>

<!-- Roman Numbers -->
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' romannumup ')]  | phrase[contains(concat(' ', normalize-space(@role), ' '), ' amRNU ')] | phrase[contains(concat(' ', normalize-space(@role), ' '), ' amRomanNumUp ')]">
  <xsl:text>\amRomanNumUp{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' romannumlow ')] | phrase[contains(concat(' ', normalize-space(@role), ' '), ' amRNL ')] | phrase[contains(concat(' ', normalize-space(@role), ' '), ' amRomanNumLow ')]">
  <xsl:text>\amRomanNumLow{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amSSU ')]">
  <xsl:text>\amSmallSuperscript{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template>


<!-- Newline -->
<xsl:template match="processing-instruction('asciidoc-br')">
  <xsl:text>\newline{}&#10;</xsl:text>
</xsl:template>



<xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' marginnote ')]">
  <xsl:text>\marginnote{</xsl:text><!-- Shahryar -->
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text><!-- Shahryar -->
</xsl:template>

<!-- The End Note -->
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amEndNote ')]">
  <xsl:text>\amEndnote{</xsl:text><!-- Shahryar -->
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text><!-- Shahryar -->
</xsl:template>


<xsl:template match="phrase[@role='acro']">
  <xsl:text>\amAbbreviation[</xsl:text>
   <xsl:value-of select="text()"/>
<!--     <xsl:apply-templates select="(*|node())[not(self::indexterm)]" /> -->
  <xsl:text>]</xsl:text>
  <xsl:text>{</xsl:text>
   <xsl:value-of select="text()"/>
<!--     <xsl:apply-templates select="(*|node())[not(self::indexterm)]" /> -->
  <xsl:text>}</xsl:text>  
</xsl:template> 

<!-- 
<xsl:template match="phrase[@role='acro']">
  <xsl:text>\gls{</xsl:text>
   <xsl:value-of select="text()"/>
  <xsl:text>}</xsl:text>
  <xsl:text>\index{</xsl:text>
   <xsl:value-of select="text()"/>
  <xsl:text>}</xsl:text>  
</xsl:template> 
 --> 

 <!--  changes <phrase role="newt">X</phrase> to \amNewThought{X} -->
<xsl:template match="phrase[@role='newt']">
	<xsl:text>\amNewThought{</xsl:text>
		<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>	

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amRed ')]">
  <xsl:text>\amRed{</xsl:text>
    <xsl:apply-templates  />
  <xsl:text>}</xsl:text>
</xsl:template> 
  
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' amBlue ')]">
  <xsl:text>\amBlue{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' isbn ')]">
  <xsl:text>\amISBN{</xsl:text>
    <xsl:value-of select="."/>
  <xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' copyrightline ')]">
  <xsl:text>\amCopyrightLine{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template> 
 
 <xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' greekletter ')]">
  <xsl:choose>
    <xsl:when test="./text()='&#945;'">
      <xsl:text>\textalpha{}</xsl:text>
    </xsl:when>
    <xsl:when test="./text()='&#946;'">
      <xsl:text>\textbeta{}</xsl:text>
    </xsl:when>
    <xsl:when test="./text()='&#947;'">
      <xsl:text>\textgamma{}</xsl:text>
    </xsl:when>
  </xsl:choose>
</xsl:template> 
<!-- Disable abstract Shahryar-->
<!-- <xsl:template match="abstract">
</xsl:template>  -->

  <!-- <xsl:variable name="vWords" select="tokenize(.,'&#xA;')[normalize-space()]"/>   -->

<!-- <xsl:template match="simpara[@role='newthought']">
  <xsl:variable name="vWords" select="tokenize(.,' ')[normalize-space()]"/>
  <xsl:text>\amNewThought{</xsl:text>
  <xsl:value-of select="string-join(./node()[position() &lt; 4],''" >
  	<xsl:apply-templates/>
  </xsl:value-of>
	<xsl:text>} </xsl:text>
  <xsl:value-of select="string-join(./node()[position() &gt; 4],''" >
    <xsl:apply-templates/>
  </xsl:value-of>
</xsl:template> -->
<!-- <xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' newthought ')]">
  <xsl:variable name="vWords" select="str:tokenize(text(),' ')"/>  
    <xsl:variable name="vHead" select="concat($vWords[1],' ',$vWords[2],' ',$vWords[3])"/>
    <xsl:text>\amNewThought{</xsl:text>
      <xsl:copy-of select="$vHead"/>
    <xsl:text>} </xsl:text>
    <xsl:value-of select="substring-after(text(), $vHead)"/>
</xsl:template>     -->
<!--  <xsl:template match="node()|@*">
   <xsl:copy>
     <xsl:apply-templates select="node()|@*"/>
   </xsl:copy>
 </xsl:template> -->

 
<xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' newthought ')]">
     <xsl:text>&#xa;</xsl:text>   
    <xsl:for-each select="node()|*">
      <xsl:choose>
      <xsl:when test="position()=1">
        <xsl:choose>
        <xsl:when test="self::text()">
          <xsl:text>\amNewThought{</xsl:text>
          <xsl:value-of select="substring(substring-before(.,' '),1)"/>
          <xsl:text>} </xsl:text>     
          <xsl:value-of select="substring(substring-after(.,' '),1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>\amNewThought{</xsl:text>
            <xsl:value-of select="."/>
          <xsl:text>} </xsl:text>     
        </xsl:otherwise>
      </xsl:choose>        
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

   <xsl:text>&#xa;</xsl:text>    

</xsl:template>





<xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' lettrine ') or contains(concat(' ', normalize-space(@role), ' '), ' amInitial ') or contains(concat(' ', normalize-space(@role), ' '), ' initial ')]">
    <xsl:for-each select="node()|*">
      <xsl:choose>
      <xsl:when test="position()=1">
        <xsl:choose>
        <xsl:when test="self::text()">
          <!--\lettrine-->
          <xsl:text>&#xa;</xsl:text>
          <xsl:text>\amInitial{</xsl:text>
          <xsl:value-of select="substring(.,1,1)"/>
          <xsl:text>}</xsl:text>
          <xsl:text>{</xsl:text>
          <xsl:value-of select="substring(substring-before(.,' '),2)"/>
          <xsl:text>} </xsl:text>
          <xsl:value-of select="substring(substring-after(.,' '),1)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>        
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="."/>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#xa;</xsl:text>
</xsl:template>

<!-- <xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' lettrine ')]">
	<xsl:for-each select="node()">
		<xsl:choose>
		<xsl:when test="position()=1">
			<xsl:text>\lettrine{</xsl:text>
			<xsl:value-of select="substring(.,1,1)"/>
			<xsl:text>}</xsl:text>
			<xsl:text>{</xsl:text>
			<xsl:value-of select="substring(substring-before(.,' '),2)"/>
			<xsl:text>} </xsl:text>		  
      <xsl:value-of select="substring(substring-after(.,' '),1)"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select=".">
				<xsl:apply-templates/>
			</xsl:value-of >				
		</xsl:otherwise>
		</xsl:choose> 		
	</xsl:for-each>	
</xsl:template> -->






<!-- 
************************************************************************************
General Layout
************************************************************************************
 -->  

<!-- This disables things not to show in latex -->
<xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' nolatex ')]">
</xsl:template>



<!-- This disables preamble, list of figures/tables/equations/... , ! Shahryar -->
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
<!--   <xsl:apply-templates select="." mode="preamble">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:apply-templates> -->

  <!-- <xsl:value-of select="$latex.begindocument"/> -->
  <xsl:call-template name="lang.document.begin">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template>
  <xsl:call-template name="label.id"/>

  <!-- Setup that must be performed after the begin of document -->
  <!-- <xsl:call-template name="verbatim.setup2"/> -->

  <!-- Apply the legalnotices here, when language is active -->
<!--   <xsl:call-template name="print.legalnotice">
    <xsl:with-param name="nodes" select="$info/legalnotice"/>
  </xsl:call-template> -->

<!--   <xsl:if test="contains($layout, 'frontmatter ')">
    <xsl:value-of select="$frontmatter"/>
  </xsl:if> -->

 <!--  <xsl:if test="contains($layout, 'coverpage ')">
    <xsl:text>\maketitle&#10;</xsl:text>
  </xsl:if> -->

  <!-- Print the TOC/LOTs -->
<!--   <xsl:if test="contains($layout, 'toc ')">
    <xsl:apply-templates select="." mode="toc_lots"/>
  </xsl:if> -->

  <!-- Print the abstract and front matter content -->
  <!-- <xsl:apply-templates select="(abstract|$info/abstract)[1]"/> -->

  <!-- This was my template apply but no need anymore, Shahryar -->
<!--   <xsl:apply-templates select="
    dedication|
    colophon|
    (abstract|$info/abstract)[1]|
    chapter[contains(concat(' ', normalize-space(@role), ' '), ' abstract ')]|
    preface|
    chapter[contains(concat(' ', normalize-space(@role), ' '), ' bookkeywords ')]|
    chapter[contains(concat(' ', normalize-space(@role), ' '), ' acknowledgments ')]|
    chapter[contains(concat(' ', normalize-space(@role), ' '), ' tableofcontents ')]
    "/>
 -->
 <xsl:apply-templates/>


  <!-- Body content -->
<!--   <xsl:if test="contains($layout, 'mainmatter ')">
    <xsl:value-of select="$mainmatter"/>
  </xsl:if> -->

<!--   <xsl:apply-templates select="*[not(self::abstract or
                                     self::preface or
                                     self::dedication or
                                     self::colophon or
                                     self::appendix)]"/> -->

  <!-- Back matter -->
<!--   <xsl:if test="contains($layout, 'backmatter ')">
    <xsl:value-of select="$backmatter"/>
  </xsl:if> -->

<!--   <xsl:apply-templates select="appendix"/>
  <xsl:if test="contains($layout, 'index ')">
    <xsl:if test="*//indexterm|*//keyword">
      <xsl:call-template name="printindex"/>
    </xsl:if>
  </xsl:if>
  <xsl:apply-templates select="colophon"/>
  <xsl:call-template name="lang.document.end">
    <xsl:with-param name="lang" select="$lang"/>
  </xsl:call-template> -->
  <!-- <xsl:value-of select="$latex.enddocument"/> -->
</xsl:template>


<xsl:template match="appendix">
  <xsl:if test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amClearPage ')]">
    <xsl:text>&#xa;</xsl:text>     
    <xsl:text>\clearpage%</xsl:text>
    <xsl:text>&#xa;</xsl:text>     
  </xsl:if>
  <xsl:if test="not (preceding-sibling::appendix)">
    <xsl:choose>
      <xsl:when test="parent::chapter">
        <xsl:text>% ---------------------&#10;</xsl:text>
        <xsl:text>% Subappendixes start here&#10;</xsl:text>
        <xsl:text>% ---------------------&#10;</xsl:text>
        <xsl:text>\begin{amSubAppendix}&#10;</xsl:text>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>% ---------------------&#10;</xsl:text>
        <xsl:text>% Appendixes start here&#10;</xsl:text>
        <xsl:text>% ---------------------&#10;</xsl:text>
        <xsl:text>\begin{appendices}&#10;</xsl:text>
        <xsl:text>\crefalias{chapter}{appchapter}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>      
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
    <xsl:choose>
      <xsl:when test="parent::chapter">
        <xsl:text>\end{amSubAppendix}&#10;</xsl:text>        
      </xsl:when>
      <xsl:otherwise>
    <xsl:text>&#10;\end{appendices}&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>      
  </xsl:if>
</xsl:template>







<!-- 
************************************************************************************
FIGURES
************************************************************************************

 -->

 <!-- My wrapfigure, Shahryar -->
<!-- <xsl:template match="figure[contains(concat(' ', normalize-space(@role), ' '), ' wrapfigure ')]">

  <xsl:text>\begin{amWrapFigure}&#10;</xsl:text>
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="*[not(self::title)]"/>

    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>

  <xsl:text>\end{wrapfigure}&#10;</xsl:text>
</xsl:template> -->
<!-- amWrapFigure, Shahryar -->
<xsl:template match="figure[@role='wrapfigure' or @role='amWrapFigure' or @role='wrapfigure_expand_to_margin' or @role='amWrapFigureExpandToMargin' or @role='wrapfigure_with_margin_caption' or @role='amWrapFigureWithMarginCaption']">

  <xsl:variable name="environ">
    <xsl:choose>
      <xsl:when test="@role='wrapfigure_expand_to_margin' or @role='amWrapFigureExpandToMargin'">\amWrapFigureExpandToMargin</xsl:when>
      <xsl:when test="@role='wrapfigure_with_margin_caption' or @role='amWrapFigureWithMarginCaption'">\amWrapFigureWithMarginCaption</xsl:when>
      <xsl:otherwise>\amWrapFigure</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

   <xsl:value-of select="$environ"/><xsl:text>{</xsl:text>
      <xsl:copy> 
        <xsl:apply-templates select="title"/>
      </xsl:copy>   
   <xsl:text>}{</xsl:text>
   <xsl:text>}{</xsl:text>
    <xsl:value-of select="mediaobject/imageobject/imagedata/@fileref"/>
   <xsl:text>}</xsl:text>
   <xsl:text>&#xa;</xsl:text>       
</xsl:template>


<!-- My myCornerBackground, Shahryar -->
<xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' cornerbackground ')]">
  <xsl:text>&#10;</xsl:text>  
  <xsl:text>\myCornerBackground{</xsl:text>
  <xsl:value-of select="@xml:id" />  
  <xsl:text>}</xsl:text>
  <xsl:text>&#10;</xsl:text>  

  <xsl:copy> 
  <xsl:apply-templates/>        
  </xsl:copy>

  <xsl:text>&#10;</xsl:text>  

</xsl:template>

<!-- My marginfigure, Shahryar -->
<xsl:template match="figure[contains(concat(' ', normalize-space(@role), ' '), ' marginfigure ')] | figure[contains(concat(' ', normalize-space(@role), ' '), ' amMarginFigure ')]">
  <xsl:text>&#10;</xsl:text>  

  <xsl:text>\begin{amMarginFigure}&#10;</xsl:text>

    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <!--This part handles the image part-->
    <xsl:text>\begin{center}&#10;</xsl:text>
    <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:text>\hspace*{\fill}</xsl:text>  
    <xsl:text>\end{center}&#10;</xsl:text>

    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>

  <xsl:text>\end{amMarginFigure}&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>  
</xsl:template>



<!-- marginfigurenote with inline image, Shahryar -->
<!-- This both covers marginfigurenotes with inline image(s) and  marginfigurenotes with title plus block images -->
 <xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amMarginGraphic ')]">
  <xsl:text>\begin{amMarginGraphic}&#10;</xsl:text><!-- Shahryar -->
      <xsl:copy> 
        <xsl:apply-templates select="mediaobject"/>
      </xsl:copy>
      <xsl:apply-templates select="(*|node())[not(self::mediaobject)]"/>
  <xsl:text>\end{amMarginGraphic}&#10;</xsl:text><!-- Shahryar -->
</xsl:template>



<!-- marginfigurenote with inline image, Shahryar -->
<!-- This both covers marginfigurenotes with inline image(s) and  marginfigurenotes with title plus block images -->
 <xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amMarginFigureNote ')]">
  <xsl:text>\begin{amMarginFigure}&#10;</xsl:text><!-- Shahryar -->
      <xsl:copy> 
        <xsl:apply-templates select="mediaobject"/>
      </xsl:copy>
      <xsl:apply-templates select="(*|node())[not(self::mediaobject)]"/>
  <xsl:text>\end{amMarginFigure}&#10;</xsl:text><!-- Shahryar -->
</xsl:template>


 <xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amNormalGraphic ')]">
  <xsl:text>\amNormalGraphic{</xsl:text><!-- Shahryar -->
      <xsl:value-of select="./mediaobject/imageobject/imagedata/@fileref" />  
  <xsl:text>}[</xsl:text><!-- Shahryar -->
  <xsl:apply-templates select="title"/>      
  <xsl:text>]&#10;</xsl:text><!-- Shahryar -->
</xsl:template>


 <xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amTwoPageFigure ')]">
  <xsl:text>\amTwoPageFigure[][]{</xsl:text><!-- Shahryar -->
      <xsl:value-of select="./mediaobject/imageobject/imagedata/@fileref" />  
  <xsl:text>}{</xsl:text><xsl:apply-templates select="title"/><xsl:text>}[</xsl:text>
  <xsl:apply-templates select="mediaobject/textobject"/>      
  <xsl:text>][][</xsl:text>
  <xsl:value-of select="@xml:id"/>      
  <xsl:text>]&#10;</xsl:text>
</xsl:template>

 <xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amGrayBoxGraphic ')]">
  <xsl:text>\amGrayBoxGraphic{</xsl:text><!-- Shahryar -->
      <xsl:value-of select="./mediaobject/imageobject/imagedata/@fileref" />  
  <xsl:text>}[</xsl:text><!-- Shahryar -->
  <xsl:apply-templates select="title"/>      
  <xsl:text>]&#10;</xsl:text><!-- Shahryar -->
</xsl:template>

<xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' amGrayBoxGraphicTwo ')]">
  <xsl:text>\amGrayBoxGraphicTwo{</xsl:text><!-- Shahryar -->
      <xsl:value-of select="./mediaobject/imageobject/imagedata/@fileref" />  
  <xsl:text>}[</xsl:text><!-- Shahryar -->
  <xsl:apply-templates select="title"/>      
  <xsl:text>]&#10;</xsl:text><!-- Shahryar -->
</xsl:template>




<!-- Shahryar: I removed \begin{center} -->
<xsl:template match="informalfigure">
  <xsl:apply-templates/>
</xsl:template>


 <!-- My own figure template, Shahryar -->
<xsl:template match="figure[contains(concat(' ', normalize-space(@role), ' '), ' amFullFigureWithOverlayCaption ')]">
  <xsl:text>&#10;</xsl:text>
  
  <xsl:text>\amFullFigureWithOverlayCaption{</xsl:text>
    <xsl:value-of select="mediaobject/imageobject/imagedata/@fileref"/>
  <xsl:text>}{\protect{</xsl:text>
        <xsl:apply-templates select="title" mode="format.title"/>
  <xsl:text>}}[</xsl:text>
        <xsl:value-of select="mediaobject/textobject/phrase"/>
  <xsl:text>][</xsl:text>
    <xsl:value-of select="@xml:id" />  
  <xsl:text>]</xsl:text>
    <xsl:text>&#10;</xsl:text>
</xsl:template>


 <!-- My own figure template, Shahryar -->
<xsl:template match="figure">
  <xsl:text>&#10;</xsl:text>

  <xsl:variable name="environ">
    <xsl:choose>
      <!-- <xsl:when test="@role ='wrapfigure'">amWrapFigure</xsl:when> -->
      <xsl:when test="contains(concat(' ', normalize-space(@role), ' '), ' amFullFigureWithOverlayCaption ')">figure*</xsl:when>
      <xsl:when test="contains(concat(' ', normalize-space(@role), ' '), ' amFullFigure ')">figure*</xsl:when>
      <xsl:when test="contains(concat(' ', normalize-space(@role), ' '), ' amSinglePageCentered ')">amSinglePageCentered</xsl:when>
      <xsl:otherwise>figure</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>



<!-- <xsl:if test="contains(concat(' ', normalize-space(@role), ' '), ' amSinglePageCentered ')">
      <xsl:text>\vspace*{\fill}</xsl:text>
      <xsl:text>\begin{adjustbox}{max width=\amFullWidthLength ,max height=\textheight,valign=m,float={figure*}[p]}</xsl:text>
</xsl:if> -->

  <xsl:text>\begin{</xsl:text><xsl:value-of select="$environ"/><xsl:text>}</xsl:text>
  
  <!-- figure placement preference -->
  <xsl:choose>
    <xsl:when test="@floatstyle != ''">
      <xsl:value-of select="@floatstyle"/>
    </xsl:when>
    <xsl:when test="not(@float) or (@float and @float='0')">
      <xsl:text>[htbp]</xsl:text> <!-- Shahryar -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$figure.default.position"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>

<!-- center the figure -->
<xsl:text>\centering</xsl:text>
  <xsl:text>&#10;</xsl:text>



  <!-- title caption before the image -->
  <xsl:apply-templates select="." mode="caption.and.label">
    <xsl:with-param name="position.top" select="1"/>
  </xsl:apply-templates>

  <!-- <xsl:text>&#10;\begin{center}&#10;</xsl:text> --><!-- Shahryar -->
  <xsl:apply-templates select="*[not(self::title)]"/>
  <!-- <xsl:text>&#10;\end{center}&#10;</xsl:text> --><!-- Shahryar -->

  <!-- title caption after the image -->
  <xsl:apply-templates select="." mode="caption.and.label">
    <xsl:with-param name="position.top" select="0"/>
  </xsl:apply-templates>
   <xsl:text>\end{</xsl:text><xsl:value-of select="$environ"/><xsl:text>}</xsl:text>

<!-- 
<xsl:if test="contains(concat(' ', normalize-space(@role), ' '), ' amSinglePageCentered ')">
      <xsl:text>\end{adjustbox}\end{fullwidth}</xsl:text>
      <xsl:text>\vspace*{\fill}</xsl:text>
</xsl:if> -->

  <xsl:text>&#10;</xsl:text>

</xsl:template>



<xsl:template match="figure" mode="caption.and.label">
  <xsl:param name="position.top"/>

  <xsl:choose>
  <xsl:when test="$figure.title.top='1'">

    <xsl:if test="$position.top='1'">

      <xsl:choose>
      <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amNoLabel ')]">
        <xsl:text>\amNoLabelCaption</xsl:text><!-- I added protec, Shahryar -->
        <xsl:apply-templates select="title" mode="format.title"/>      
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>\caption[</xsl:text><!-- I added protec, Shahryar -->
        <xsl:value-of select="mediaobject/textobject/phrase"/>
        <xsl:text>]</xsl:text><!-- Shahryar -->
        <xsl:text>{\protect</xsl:text><!-- Shahryar: protect -->
        <xsl:apply-templates select="title" mode="format.title"/><xsl:text>}</xsl:text><!-- Shahryar: end protect -->
        <xsl:text>&#10;%top caption ends here &#10;</xsl:text>   

        <xsl:text>&#10;\phantomsection%&#10;</xsl:text><!--hopefully this will fix table of figures wrong link -->       

        <xsl:if test="$figure.anchor.top=$position.top">
          <xsl:call-template name="label.id">
            <xsl:with-param name="object" select="."/>
          </xsl:call-template>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>

      </xsl:otherwise>
      </xsl:choose>

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

      <xsl:choose>
      <xsl:when test="self::node()[contains(concat(' ', normalize-space(@role), ' '), ' amNoLabel ')]">
        <xsl:text>\amNoLabelCaption</xsl:text><!-- \caption* --><!-- I added protec, Shahryar -->
        <xsl:apply-templates select="title" mode="format.title"/>      
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>&#10;%bottom caption starts here &#10;</xsl:text>       
        <xsl:text>\caption[</xsl:text><!-- I added protec, Shahryar -->
        <xsl:value-of select="mediaobject/textobject/phrase"/>
        <xsl:text>]</xsl:text><!-- Shahryar -->
        <xsl:text>{\protect</xsl:text><!-- Shahryar: protect -->
        <xsl:apply-templates select="title" mode="format.title"/><xsl:text>}</xsl:text><!-- Shahryar: end protect -->
        <xsl:text>&#10;%bottom caption ends here &#10;</xsl:text>       

        <xsl:text>&#10;\phantomsection%&#10;</xsl:text><!--hopefully this will fix table of figures wrong link -->       


        <xsl:if test="$figure.anchor.top='0'">
          <xsl:call-template name="label.id">
            <xsl:with-param name="object" select="."/>
          </xsl:call-template>
        </xsl:if>

      </xsl:otherwise>
      </xsl:choose>


    </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  </xsl:choose>
</xsl:template>





<!-- 
************************************************************************************
TABLES
************************************************************************************
 -->
<!-- 
<xsl:template match="">
</xsl:template> -->


<!-- 
************************************************************************************
COMMON
************************************************************************************
 -->
<xsl:template match="title|table/caption" mode="format.title">
  <xsl:param name="allnum" select="'0'"/>
<!--   <xsl:apply-templates select="." mode="toc">
    <xsl:with-param name="allnum" select="$allnum"/>
  </xsl:apply-templates>
 -->  <xsl:text>{</xsl:text> 
  <!-- should be normalized, but it is done by post processing -->
  <xsl:apply-templates select="." mode="content"/>
  <xsl:text>}&#10;</xsl:text> 
</xsl:template>

</xsl:stylesheet>