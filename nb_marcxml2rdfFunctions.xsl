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
		<xsl:variable name="str1" select="replace($s, ' [/:=;\]]$', '')" />
		<xsl:variable name="str2" select="replace($str1, '^[\[]', '')" />
		<xsl:variable name="str3" select="replace($str2,'. -$','')" />
		<xsl:variable name="str4" select="replace($str3,'&#x0098;','')" />
		<xsl:variable name="str5" select="replace($str4,'&#x009C;','')" />
		<xsl:variable name="str6" select="normalize-space($str5)" />
		<xsl:variable name="str7" select="normalize-unicode($str6, 'NFC')" />
		<xsl:value-of select="$str7" />
	</xsl:function>

	<!-- Normalize string -->
	<xsl:function name="nb:stringTool">
		<xsl:param name="s" />
		<xsl:variable name="str1" select="$s" />
		<xsl:variable name="str2" select="normalize-space($str1)" />
		<xsl:variable name="str3" select="replace($str2, ' [:/=;]$', ' ')" />
		<xsl:variable name="str4" select="replace($str3,'. -$','')" />
		<xsl:variable name="str5" select="replace($str4,'&#x0098;','')" />
		<xsl:variable name="str6" select="replace($str5,'&#x009C;','')" />
		<xsl:variable name="str7" select="normalize-space($str6)" />
		<xsl:variable name="str8" select="normalize-unicode($str7, 'NFC')" />
		<xsl:value-of select="$str8" />
	</xsl:function>



</xsl:stylesheet>