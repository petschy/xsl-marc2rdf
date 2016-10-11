<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:nb="http://nb.admin.ch/lod/ns/">

	<!-- Permalink Helveticat -->
	<xsl:function name="nb:permalinkHelveticat">
		<xsl:param name="systemControlNumber" />
		<xsl:variable name="permalink"
			select="substring($systemControlNumber, 5, string-length($systemControlNumber))" />
		<xsl:variable name="permalink"
			select="normalize-space(concat('http://permalink.snl.ch/bib/sz', $permalink))" />
		<xsl:variable name="permalink" select="replace($permalink,'\s','')" />
		<xsl:value-of select="$permalink" />
	</xsl:function>


	<!-- Permalink GND -->
	<xsl:function name="nb:permalinkGnd">
		<xsl:param name="gndNo" />
		<xsl:variable name="permalink" select="$gndNo" />
		<xsl:variable name="permalink"
			select="substring($permalink, 9, string-length($permalink))" />
		<xsl:variable name="permalink"
			select="concat('http://d-nb.info/gnd/', $permalink)" />
		<xsl:variable name="permalink" select="replace($permalink,'\s','')" />
 		<xsl:value-of select="$permalink" />
	</xsl:function>

	<!-- DOI -->
	<xsl:function name="nb:doi">
		<xsl:param name="doi" />
		<xsl:variable name="permalink" select="$doi" />
		<xsl:variable name="permalink"
			select="concat('http://dx.doi.org/', $permalink)" />
		<xsl:variable name="permalink" select="replace($permalink,'\s','')" />
		<xsl:value-of select="$permalink" />
	</xsl:function>

	<!-- URN -->
	<xsl:function name="nb:urn">
		<xsl:param name="urn" />
		<xsl:variable name="permalink" select="$urn" />
		<xsl:variable name="permalink"
			select="concat('http://nbn-resolving.de/', $permalink)" />
		<xsl:variable name="permalink" select="replace($permalink,'\s','')" />
		<xsl:value-of select="$permalink" />
	</xsl:function>

	<!-- Clean up title string -->
	<xsl:function name="nb:cleanupTitle">
		<xsl:param name="s" />
		<xsl:variable name="str" select="replace($s, ' [/:=;\]]$', '')" />
		<xsl:variable name="str" select="replace($str, '^[\[]', '')" />
		<xsl:variable name="str" select="replace($str,'. -$','')" />
		<xsl:variable name="str" select="replace($str,'&#x0098;','')" />
		<xsl:variable name="str" select="replace($str,'&#x009C;','')" />
		<xsl:variable name="str" select="normalize-space($str)" />
		<xsl:variable name="str" select="normalize-unicode($str, 'NFC')" />
		<xsl:value-of select="$str" />
	</xsl:function>

	<!-- Normalize string -->
	<xsl:function name="nb:stringTool">
		<xsl:param name="s" />
		<xsl:variable name="str" select="$s" />
		<xsl:variable name="str" select="normalize-space($str)" />
		<xsl:variable name="str" select="replace($str, ' [:/=;]$', ' ')" />
		<xsl:variable name="str" select="replace($str,'. -$','')" />
		<xsl:variable name="str" select="replace($str,'&#x0098;','')" />
		<xsl:variable name="str" select="replace($str,'&#x009C;','')" />
		<xsl:variable name="str" select="normalize-space($str)" />
		<xsl:variable name="str" select="normalize-unicode($str, 'NFC')" />
		<xsl:value-of select="$str" />
	</xsl:function>



</xsl:stylesheet>