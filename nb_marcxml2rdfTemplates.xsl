<xsl:stylesheet version="2.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:nb="http://nb.admin.ch/lod/ns/" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdau="http://rdaregistry.info/Elements/u/"
	xmlns:bibo="http://purl.org/ontology/bibo/">



	<xsl:template name="creator">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="nb:stringTool($str1)" />
		<xsl:if test="$str2!=''">
			<dc:creator rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str2" />
			</dc:creator>
		</xsl:if>
	</xsl:template>

	<xsl:template name="contributor">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="nb:stringTool($str1)" />
		<xsl:if test="$str2!=''">
			<dc:contributor rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str2" />
			</dc:contributor>
		</xsl:if>
	</xsl:template>


	<!-- Number or name of Part of Title (245 $n_$p) -->
	<xsl:template name="numberOrNameOfPartOfTitle">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="nb:cleanupTitle($str1)" />
		<xsl:if test="$str2!=''">
			<rdau:P60493 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str2" />
			</rdau:P60493>
		</xsl:if>
	</xsl:template>

	<xsl:template name="publicationStatement">
		<xsl:param name="codes">
			abcdefghijklmnopqrstuvwxyz3
		</xsl:param>
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="nb:stringTool($str1)" />
		<xsl:if test="$str2!=''">
			<rdau:P60333 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str2" />
			</rdau:P60333>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subfieldSelectRemainderOfTitle">
		<xsl:param name="codes">
			abcdefghijklmnopqrstuvwxyz
		</xsl:param>
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="normalize-space($str1)" />
		<xsl:variable name="str3" select="replace($str2,'. -','')" />
		<xsl:variable name="str4" select="replace($str3,' [=:/]','')" />
		<xsl:if test="$str4!=''">
			<rdau:P60492 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str4" />
			</rdau:P60492>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subfieldSelectAlternative">
		<xsl:param name="codes">
			abcdefghijklmnopqrstuvwxyz
		</xsl:param>
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="normalize-space($str1)" />
		<xsl:variable name="str3" select="replace($str2,'. -','')" />
		<xsl:variable name="str4" select="replace($str3,' [=:/]','')" />
		<xsl:if test="$str4!=''">
			<rdau:P60492 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str4" />
			</rdau:P60492>
		</xsl:if>
	</xsl:template>

	<xsl:template name="issn">
		<xsl:param name="codes" />

		<xsl:for-each select="marc:datafield[@tag='022']">
			<nb:f2>
				<xsl:value-of select="$codes" />
			</nb:f2>

			<xsl:choose>
				<xsl:when test="substring($codes,1,2) = 'cr'">
					<bibo:eissn rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
						<xsl:value-of select="marc:subfield[@code='a']" />
					</bibo:eissn>
				</xsl:when>
				<xsl:otherwise>
					<bibo:issn rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
						<xsl:value-of select="marc:subfield[@code='a']" />
					</bibo:issn>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="bibliographicCitation">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> ; </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="nb:stringTool($str1)" />
		<xsl:if test="$str2!=''">
			<dcterms:bibliographicCitation rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str2" />
			</dcterms:bibliographicCitation>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subject">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str1">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str2" select="nb:stringTool($str1)" />
		<xsl:if test="$str2!=''">
			<dc:subject rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str2" />
			</dc:subject>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet>