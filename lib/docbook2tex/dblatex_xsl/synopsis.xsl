<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

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

</xsl:stylesheet>
