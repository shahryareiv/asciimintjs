<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

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

</xsl:stylesheet>

