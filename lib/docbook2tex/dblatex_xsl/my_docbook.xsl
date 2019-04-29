<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version="1.0">

<!--############################################################################
    XSLT Stylesheet DocBook -> LaTeX
    ############################################################################ -->

<xsl:output method="text" encoding="UTF-8" indent="yes"/>

<xsl:include href="fasttext.xsl"/>

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

<xsl:include href="errors.xsl"/>

<xsl:key name="id" match="*" use="@id|@xml:id"/>

<xsl:strip-space elements="book article articleinfo chapter"/>

</xsl:stylesheet>
