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
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="nb:stringTool($str)" />
		<xsl:if test="$str!=''">
			<dc:creator rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
			</dc:creator>
		</xsl:if>
	</xsl:template>

	<xsl:template name="contributor">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="nb:stringTool($str)" />
		<xsl:if test="$str!=''">
			<dc:contributor rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
			</dc:contributor>
		</xsl:if>
	</xsl:template>


	<!-- Number or name of Part of Title (245 $n_$p) -->
	<xsl:template name="numberOrNameOfPartOfTitle">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="nb:cleanupTitle($str)" />
		<xsl:if test="$str!=''">
			<rdau:P60493 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
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
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="nb:stringTool($str)" />
		<xsl:if test="$str!=''">
			<rdau:P60333 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
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
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="normalize-space($str)" />
		<xsl:variable name="str" select="replace($str,'. -','')" />
		<xsl:variable name="str" select="replace($str,' [=:/]','')" />
		<xsl:if test="$str!=''">
			<rdau:P60492 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
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
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="normalize-space($str)" />
		<xsl:variable name="str" select="replace($str,'. -','')" />
		<xsl:variable name="str" select="replace($str,' [=:/]','')" />
		<xsl:if test="$str!=''">
			<rdau:P60492 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
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
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="nb:stringTool($str)" />
		<xsl:if test="$str!=''">
			<dcterms:bibliographicCitation rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
			</dcterms:bibliographicCitation>
		</xsl:if>
	</xsl:template>

	<xsl:template name="subject">
		<xsl:param name="codes" />
		<xsl:param name="delimiter">
			<xsl:text> </xsl:text>
		</xsl:param>
		<xsl:variable name="str">
			<xsl:for-each select="marc:subfield">
				<xsl:if test="contains($codes, @code)">
					<xsl:value-of select="text()" />
					<xsl:value-of select="$delimiter" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="str" select="nb:stringTool($str)" />
		<xsl:if test="$str!=''">
			<dc:subject rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of select="$str" />
			</dc:subject>
		</xsl:if>
	</xsl:template>



</xsl:stylesheet>