<?xml version='1.0' encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

<!-- DB2LaTeX has its own admonition graphics -->
<xsl:param name="figure.note">note</xsl:param>
<xsl:param name="figure.tip">tip</xsl:param>
<xsl:param name="figure.warning">warning</xsl:param>
<xsl:param name="figure.caution">caution</xsl:param>
<xsl:param name="figure.important">important</xsl:param>

<!-- Options used for documentclass -->
<xsl:param name="latex.class.options">a4paper,10pt,twoside,openright</xsl:param>

<!-- DB2LaTeX requires Palatino like fonts -->
<xsl:param name="xetex.font">
  <xsl:text>\setmainfont{URW Palladio L}&#10;</xsl:text>
  <xsl:text>\setsansfont{FreeSans}&#10;</xsl:text>
  <xsl:text>\setmonofont{FreeMono}&#10;</xsl:text>
</xsl:param>

</xsl:stylesheet>
