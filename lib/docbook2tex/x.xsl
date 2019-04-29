<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0' 
  xmlns:str="http://exslt.org/strings" 
   extension-element-prefixes="str">
<!-- Shahryar: I added support for eslt string funcs-->
<!-- <xsl:import href="str.xsl" />    --><!--not needed with updated xsltproc-->
 
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

<xsl:template match="part[partintro/@role='backpage']">
  <xsl:text>%&#10;</xsl:text>
  <xsl:text>% PART (wiht back pageinfo)&#10;</xsl:text>
  <xsl:text>%&#10;</xsl:text>
  <xsl:apply-templates select="partintro" mode="backpage"/>
  <xsl:call-template name="mapheading"/>
  <!-- <xsl:text>\makeatletter\@openrightfalse\makeatother\thispagestyle{empty}&#10;</xsl:text> -->
  <!-- <xsl:text> \makeatletter\@openrighttrue\makeatother&#10;</xsl:text> -->
  <xsl:text>\myresetpartnote{}</xsl:text>
  <xsl:apply-templates/>
  <!-- Force exiting the part. It assumes the bookmark package available -->
  <xsl:if test="not(following-sibling::part)">
    <xsl:text>\bookmarksetup{startatroot}&#10;</xsl:text>
  </xsl:if>
</xsl:template>
<xsl:template match="partintro"/><!-- Disables standalone partintro -->
<xsl:template match="partintro" mode="backpage">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\mysetpartnote{</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
    <xsl:text>}&#xa;</xsl:text>
</xsl:template>

<!-- Dedication (headless), Shahryar -->
<xsl:template match="dedication">
<!--   <xsl:text>\begin{mydedication}</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>\end{mydedication}&#xa;</xsl:text> -->
<xsl:text>\mydedication{</xsl:text>
  <xsl:apply-templates select="*[not(self::title)]" />  
  <xsl:text>}&#xa;</xsl:text>   
</xsl:template>  

<!-- Colophon (headless), Shahryar -->
<xsl:template match="colophon">
  <xsl:text>\begin{mycolophon}</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]"/>
  <xsl:text>\end{mycolophon}&#xa;</xsl:text>
</xsl:template>

<!-- Glossary , Shahryar -->
<xsl:template match="glossary">
  <xsl:text>\myglossary[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>
</xsl:template>

<!-- Biblio , Shahryar -->
<xsl:template match="bibliography">
  <xsl:text>\mybibliography[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>
</xsl:template>  

<!-- Index , Shahryar -->
<xsl:template match="index">
  <xsl:text>\myindex[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
</xsl:template>  


<!-- Book Keywords, Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' bookkeywords ')]">
  <xsl:text>\begin{mybookkeywords}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{mybookkeywords}&#xa;</xsl:text>
</xsl:template> 

<!-- Book Table of Contents, Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' tableofcontents ')]">
  <xsl:text>\mytableofcontents[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>
  <xsl:text>&#xa;</xsl:text>     
</xsl:template> 


<!-- Acknowledgements , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' acknowledgments ')]">
  <xsl:text>\begin{myacknowledgements}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{myacknowledgements}&#xa;</xsl:text>
</xsl:template>   

<!-- Preface , Shahryar -->
<xsl:template match="preface">
  <xsl:text>\begin{mypreface}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{mypreface}&#xa;</xsl:text>
</xsl:template>   

<!-- Book Abstract , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' abstract ')] | abstract">
  <xsl:text>\begin{mybookabstract}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]&#xa;</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{mybookabstract}&#xa;</xsl:text>
</xsl:template>   

<!-- Book Epigraph (headless), Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' bookepigraph ')]">
 <xsl:text>\mybookepigraph{</xsl:text>
  <xsl:apply-templates select="blockquote/simpara" />
  <xsl:text>}{</xsl:text>
  <xsl:variable name="quote_owner"><xsl:apply-templates select="blockquote/attribution/node()[not(self::citetitle)]"/></xsl:variable>
    <xsl:value-of select="normalize-space(translate($quote_owner, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
  <!-- <xsl:apply-templates select="blockquote/attribution/node()[not(self::citetitle)]" /> -->
  <xsl:text>}{</xsl:text>
  <xsl:apply-templates select="blockquote/attribution/citetitle/node()" /><xsl:text>}&#xa;</xsl:text> 
</xsl:template>  


<!-- Book End Notes , Shahryar -->
<xsl:template match="chapter[contains(concat(' ', normalize-space(@role), ' '), ' theendnoteschapter ')] ">
  <xsl:text>\begin{myendnoteschapter}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
  <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{myendnoteschapter}&#xa;</xsl:text>
</xsl:template> 


<!-- 
=================================
Chapter Parts (and text blocks)
================================= 
-->  


<!-- Graybox -->
<xsl:template match="section[@role='graybox']">
  <xsl:text>&#10;</xsl:text>    
  <xsl:text>\begin{mygrayenv}</xsl:text>
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
  <xsl:text>\end{mygrayenv}</xsl:text>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 

<!-- Chapter Authors -->

<xsl:template match="simpara[@role='chapter_authors']">
  <xsl:text>\mychapterauthor{</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
  <xsl:text>&#10;</xsl:text>  
</xsl:template> 

<!-- Chapter Abstract -->
<xsl:template match="section[@role='chapter_abstract']">
  <xsl:text>\begin{mychapterabstract}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{mychapterabstract}</xsl:text>
  <xsl:text>&#10;</xsl:text>    
</xsl:template> 

<!-- Chapter Keywords -->
<xsl:template match="section[@role='chapter_keywords']">
  <xsl:text>\begin{mykeywords}[</xsl:text>
  <xsl:value-of select="title" />  
  <xsl:text>]</xsl:text>  
        <xsl:apply-templates select="*[not(self::title)]" />
  <xsl:text>\end{mykeywords}&#xa;</xsl:text>
</xsl:template> 

<!-- Chapter Epigraph, Shahryar -->
<xsl:template match="blockquote[contains(concat(' ', normalize-space(@role), ' '), ' epigraph ')]">
  <xsl:text>\begin{epigraphs}&#xa;</xsl:text>  
      <xsl:copy> 
        <xsl:apply-templates select="mediaobject|informalfigure"/>
      </xsl:copy>

      <xsl:text>\qitem{</xsl:text><!-- \begin{verse}\setlength{\leftmargini}{0pt} -->
      <!-- <xsl:text>\enquote{</xsl:text>     -->
        <xsl:apply-templates select="(*|node())[not(self::mediaobject|self::informalfigure|self::attribution)]"/>
      <!-- <xsl:text>}&#xa;</xsl:text>   -->
    <xsl:text>}{—</xsl:text><!-- \textemdash --><!-- \end{verse} -->
      <xsl:value-of select="./attribution/text()"/><xsl:text>,~</xsl:text> 
      <xsl:text>\emph{</xsl:text><!-- footnote, marginnote -->
      <xsl:value-of select="./attribution/citetitle/text()"/>
      <xsl:text>}</xsl:text>
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
  <xsl:text>\myaside{</xsl:text>
        <xsl:apply-templates />
  <xsl:text>}</xsl:text>
  <xsl:text>&#xa;</xsl:text>
</xsl:template> 

<xsl:template match="text()" name="my_remove_space" mode="remove_space">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<xsl:template match="blockquote">
  <xsl:text>&#xa;</xsl:text>
  <xsl:text>\begin{myblockquote}{</xsl:text>
  <xsl:variable name="quote_owner"><xsl:apply-templates select="attribution/node()[not(self::citetitle)]"/></xsl:variable>
    <xsl:value-of select="normalize-space(translate($quote_owner, '&#x20;&#x9;&#xD;&#xA;', ' '))"/>
  <xsl:text>}{</xsl:text>
    <xsl:apply-templates select="attribution/citetitle/node()"/>
  <xsl:text>}%</xsl:text>
    <xsl:apply-templates select="(node()|*)[not(self::attribution)]"/>
    <xsl:text>\end{myblockquote}&#xa;</xsl:text>
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
<xsl:template match="remark[@role='latexcode']">
  <xsl:value-of select="."/>
</xsl:template>

<!-- Cross Ref -->
<xsl:template match="xref[@linkend]">
  <xsl:text>\hyperlink{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}{\Cref{</xsl:text>
  <xsl:value-of select="@linkend"/>
  <xsl:text>}}</xsl:text>
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

<!-- Roman Numbers -->
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' romannumup ')]">
  <xsl:text>\myromannumup{</xsl:text>
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
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' endnote ')]">
  <xsl:text>\endnote{</xsl:text><!-- Shahryar -->
  <xsl:apply-templates/>
  <xsl:text>}</xsl:text><!-- Shahryar -->
</xsl:template>


<xsl:template match="phrase[@role='acro']">
  <xsl:text>\gls{</xsl:text>
   <xsl:value-of select="text()"/>
<!--     <xsl:apply-templates select="(*|node())[not(self::indexterm)]" /> -->
  <xsl:text>}</xsl:text>
  <xsl:text>\index{</xsl:text>
   <xsl:value-of select="text()"/>
<!--     <xsl:apply-templates select="(*|node())[not(self::indexterm)]" /> -->
  <xsl:text>}</xsl:text>  
</xsl:template> 

 <!--  changes <phrase role="newt">X</phrase> to \newthought{X} -->
<xsl:template match="phrase[@role='newt']">
	<xsl:text>\newthought{</xsl:text>
		<xsl:apply-templates/>
	<xsl:text>}</xsl:text>
</xsl:template>	

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' myredtext ')]">
  <xsl:text>\myredtext{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template> 
  
<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' mybluetext ')]">
  <xsl:text>\mybluetext{</xsl:text>
    <xsl:apply-templates/>
  <xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' isbn ')]">
  <xsl:text>\myisbn{</xsl:text>
    <xsl:value-of select="."/>
  <xsl:text>}</xsl:text>
</xsl:template> 

<xsl:template match="phrase[contains(concat(' ', normalize-space(@role), ' '), ' copyrightline ')]">
  <xsl:text>\mycopyrightline{</xsl:text>
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
  <xsl:text>\newthought{</xsl:text>
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
    <xsl:text>\newthought{</xsl:text>
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
    <xsl:for-each select="node()|*">
      <xsl:choose>
      <xsl:when test="position()=1">
        <xsl:choose>
        <xsl:when test="self::text()">
          <xsl:text>\newthought{</xsl:text>
          <xsl:value-of select="substring(substring-before(.,' '),1)"/>
          <xsl:text>} </xsl:text>     
          <xsl:value-of select="substring(substring-after(.,' '),1)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>\newthought{</xsl:text>
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


<xsl:template match="simpara[contains(concat(' ', normalize-space(@role), ' '), ' lettrine ')]">
    <xsl:for-each select="node()|*">
      <xsl:choose>
      <xsl:when test="position()=1">
        <xsl:choose>
        <xsl:when test="self::text()">
          <xsl:text>\lettrine{</xsl:text>
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
  <xsl:if test="not (preceding-sibling::appendix)">
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>% Appendixes start here&#10;</xsl:text>
    <xsl:text>% ---------------------&#10;</xsl:text>
    <xsl:text>\begin{appendices}&#10;</xsl:text>
    <xsl:text>\crefalias{chapter}{appchapter}&#10;</xsl:text>
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


<!-- 
************************************************************************************
FIGURES
************************************************************************************

 -->

 <!-- My wrapfigure, Shahryar -->
<!-- <xsl:template match="figure[contains(concat(' ', normalize-space(@role), ' '), ' wrapfigure ')]">

  <xsl:text>\begin{mywrapfigure}&#10;</xsl:text>
    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="*[not(self::title)]"/>

    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>

  <xsl:text>\end{wrapfigure}&#10;</xsl:text>
</xsl:template> -->
<!-- mywrapfigure, Shahryar -->
<xsl:template match="figure[@role='wrapfigure' or @role='wrapfigure_expand_to_margin' or @role='wrapfigure_with_margin_caption']">

  <xsl:variable name="environ">
    <xsl:choose>
      <xsl:when test="@role='wrapfigure_expand_to_margin'">\mywrapfigureexpandtomargin</xsl:when>
      <xsl:when test="@role='wrapfigure_with_margin_caption'">\mywrapfigurewithmargincaption</xsl:when>
      <xsl:otherwise>\mywrapfigure</xsl:otherwise>
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



<!-- My marginfigure, Shahryar -->
<xsl:template match="figure[contains(concat(' ', normalize-space(@role), ' '), ' marginfigure ')]">

  <xsl:text>\begin{marginfigure}&#10;</xsl:text>

    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="1"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="*[not(self::title)]"/>

    <xsl:apply-templates select="." mode="caption.and.label">
      <xsl:with-param name="position.top" select="0"/>
    </xsl:apply-templates>

  <xsl:text>\end{marginfigure}&#10;</xsl:text>
</xsl:template>




<!-- marginfigurenote with inline image, Shahryar -->
<!-- This both covers marginfigurenotes with inline image(s) and  marginfigurenotes with title plus block images -->
 <xsl:template match="*[contains(concat(' ', normalize-space(@role), ' '), ' marginfigurenote ')]">
  <xsl:text>\begin{marginfigure}&#10;</xsl:text><!-- Shahryar -->
      <xsl:copy> 
        <xsl:apply-templates select="mediaobject"/>
      </xsl:copy>
      <xsl:apply-templates select="(*|node())[not(self::mediaobject)]"/>
  <xsl:text>\end{marginfigure}&#10;</xsl:text><!-- Shahryar -->
</xsl:template>



<!-- Shahryar: I removed \begin{center} -->
<xsl:template match="informalfigure">
  <xsl:apply-templates/>
</xsl:template>

 <!-- My own figure template, Shahryar -->
<xsl:template match="figure">
  <xsl:text>&#10;</xsl:text>

  <xsl:variable name="environ">
    <xsl:choose>
      <!-- <xsl:when test="@role ='wrapfigure'">mywrapfigure</xsl:when> -->
      <xsl:when test="@role ='fullfigure'">figure*</xsl:when>
      <xsl:otherwise>figure</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

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
  <xsl:text>&#10;</xsl:text>

</xsl:template>



<xsl:template match="figure" mode="caption.and.label">
  <xsl:param name="position.top"/>

  <xsl:choose>
  <xsl:when test="$figure.title.top='1'">

    <xsl:if test="$position.top='1'">
      <xsl:text>\caption[</xsl:text>
      <xsl:value-of select="mediaobject/textobject/phrase"/>
      <xsl:text>]</xsl:text><!-- Shahryar -->
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

      <xsl:text>\caption[</xsl:text>
      <xsl:value-of select="mediaobject/textobject/phrase"/>
      <xsl:text>]</xsl:text><!-- Shahryar -->      
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





<!-- 
************************************************************************************
TABLES
************************************************************************************
 -->
<!-- 
<xsl:template match="">
</xsl:template> -->

</xsl:stylesheet>