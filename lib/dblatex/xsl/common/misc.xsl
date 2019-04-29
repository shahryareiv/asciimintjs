<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:m="http://www.w3.org/1998/Math/MathML"
                version="1.0">

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

</xsl:stylesheet>
