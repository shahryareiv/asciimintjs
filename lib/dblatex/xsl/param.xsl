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
<xsl:param name="insert.xref.page.number.para">yes</xsl:param>
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


</xsl:stylesheet>

