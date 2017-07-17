<xsl:stylesheet version="2.0"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:umbel="http://umbel.org/umbel#" xmlns:nb="http://nb.admin.ch/lod/ns/"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:rdau="http://rdaregistry.info/Elements/u/" xmlns:rdact="http://rdaregistry.info/termList/RDACarrierType/"
	xmlns:rdamt="http://rdaregistry.info/termList/RDAMediaType/"
	xmlns:rdaco="http://rdaregistry.info/termList/RDAContentType/"
	xmlns:rdami="http://rdaregistry.info/termList/ModeIssue/" xmlns:rdaftn="http://rdaregistry.info/termList/TacNotation/"
	xmlns:rdae="http://rdaregistry.info/Elements/u/P60318/" xmlns:bibo="http://purl.org/ontology/bibo/"
	xmlns:isbdmediatype="http://iflastandards.info/ns/isbd/terms/mediatype/"
	xmlns:isbd="http://iflastandards.info/ns/isbd/elements/" xmlns:gnd="http://d-nb.info/gnd/"
	xmlns:helveticat="http://permalink.snl.ch/bib/" xmlns:foaf="http://xmlns.com/foaf/spec/#">
	<xsl:import href="nb_marcxml2rdfFunctions.xsl" />
	<xsl:import href="nb_marcxml2rdfTemplates.xsl" />
	<xsl:output method="xml" indent="yes" />

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:apply-templates />
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="marc:record">

		<!-- Variables -->

		<xsl:variable name="record" select="." />

		<!-- System Control Number, Permalink -->
		<xsl:variable name="systemControlNumber" select="marc:controlfield[@tag=001]" />
		<xsl:variable name="permalink"
			select="nb:permalinkHelveticat($systemControlNumber)" />

		<!-- Leader und 008 -->
		<xsl:variable name="leader" select="marc:leader" />
		<xsl:variable name="leader06" select="substring($leader,7,1)" />
		<xsl:variable name="leader07" select="substring($leader,8,1)" />
		<xsl:variable name="f008" select="marc:controlfield[@tag=008]" />
		<xsl:variable name="date1" select="substring($f008,8,4)" />
		<xsl:variable name="date2" select="substring($f008,12,4)" />
		<xsl:variable name="typeOfDate" select="substring($f008,7,1)" />


		<!-- 007 -->
		<xsl:variable name="f007" select="marc:controlfield[@tag=007]" />
		<xsl:variable name="remote">
			<xsl:for-each select="$f007">
				<xsl:variable name="pos1to2" select="substring(current(),1,2)" />
				<xsl:if test="$pos1to2='cr'">
					<xsl:value-of select="1" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="braille">
			<xsl:for-each select="$f007">
				<xsl:variable name="pos1to2" select="substring(current(),1,2)" />
				<xsl:if test="$pos1to2='fb'">
					<xsl:value-of select="1" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="text">
			<xsl:for-each select="$f007">
				<xsl:variable name="pos1" select="substring(current(),1,1)" />
				<xsl:if test="$pos1='t'">
					<xsl:value-of select="1" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="computer">
			<xsl:for-each select="$f007">
				<xsl:variable name="pos1" select="substring(current(),1,1)" />
				<xsl:if test="$pos1='c'">
					<xsl:value-of select="1" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="audio">
			<xsl:for-each select="$f007">
				<xsl:variable name="pos1" select="substring(current(),1,1)" />
				<xsl:if test="$pos1='s'">
					<xsl:value-of select="1" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>



		<!-- Define position 18-34 of field 008 -->
		<xsl:variable name="typeOfMaterial">
			<xsl:if
				test="(($leader06='a') and ($leader07='a' or $leader07='c' or $leader07='d' or $leader07='m'))">
				<xsl:text>BK</xsl:text>
			</xsl:if>
			<xsl:if test="$leader06='t'">
				<xsl:text>BK</xsl:text>
			</xsl:if>
			<xsl:if
				test="(($leader06='a') and ($leader07='b' or $leader07='i' or $leader07='s'))">
				<xsl:text>CR</xsl:text>
			</xsl:if>
			<xsl:if
				test="$leader06='c' or $leader06='d' or $leader06='i' or $leader06='j'">
				<xsl:text>MU</xsl:text>
			</xsl:if>
			<xsl:if test="$leader06='e' or $leader06='f'">
				<xsl:text>MP</xsl:text>
			</xsl:if>
			<xsl:if
				test="$leader06='g' or $leader06='k' or $leader06='o' or $leader06='r'">
				<xsl:text>VM</xsl:text>
			</xsl:if>
			<xsl:if test="$leader06='m'">
				<xsl:text>CF</xsl:text>
			</xsl:if>
			<xsl:if test="$leader06='p'">
				<xsl:text>MX</xsl:text>
			</xsl:if>
		</xsl:variable>



		<!-- rdf:Description -->
		<rdf:Description rdf:about="{$permalink}">

			<!-- =============== -->
			<!-- KIM: Titel -->
			<!-- =============== -->

			<!-- Dublin Core -->
			<!-- Title -->
			<dc:title rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
				<xsl:value-of
					select="nb:cleanupTitle(marc:datafield[@tag='245']/marc:subfield[@code='a'])" />
			</dc:title>

			<!-- Alternative Title -->
			<xsl:for-each
				select="marc:datafield[@tag='130']|marc:datafield[@tag='240']|marc:datafield[@tag='730']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='a'">
						<dcterms:alternative rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="nb:cleanupTitle(current())" />
						</dcterms:alternative>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag='246']">
				<xsl:if test="@ind2='1'">
					<xsl:for-each select="marc:subfield">
						<xsl:if test="@code='a'">
							<dcterms:alternative rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
								<xsl:value-of select="nb:cleanupTitle(current())" />
							</dcterms:alternative>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each
				select="marc:datafield[@tag='700']|marc:datafield[@tag='710']|marc:datafield[@tag='711']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='t'">
						<dcterms:alternative rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="nb:cleanupTitle(current())" />
						</dcterms:alternative>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<!-- Bibo Ontology -->
			<!-- Short Title -->
			<xsl:for-each select="marc:datafield[@tag='210']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='a'">
						<bibo:shortTitle rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="nb:cleanupTitle(current())" />
						</bibo:shortTitle>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<!-- RDA Unconstrained properties element set -->
			<!-- has other Title information -->
			<xsl:for-each select="marc:datafield[@tag='245']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='b'">
						<rdau:P60493 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="nb:cleanupTitle(current())" />
						</rdau:P60493>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag='245']">
				<xsl:variable name="codes" select="np" />
				<xsl:call-template name="numberOrNameOfPartOfTitle">
					<xsl:with-param name="codes">
						np
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

			<!-- ================================ -->
			<!-- KIM: Personen und Körperschaften -->
			<!-- ================================ -->

			<!-- Dublin Core -->

			<!-- Creator -->
			<xsl:for-each
				select="marc:datafield[@tag='100']|marc:datafield[@tag='110']|marc:datafield[@tag='111']">
				<xsl:variable name="hasGndNo">
					<xsl:variable name="startsWithDE">
						<xsl:if test="marc:subfield[@code='0']">
							<xsl:for-each select="marc:subfield">
								<xsl:if test="@code='0'">
									<xsl:variable name="dollar0" select="." />
									<xsl:choose>
										<xsl:when
											test="starts-with($dollar0, '(DE-588)') and
											string-length($dollar0)>8">
											<xsl:value-of select="1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="0" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</xsl:variable>
					<xsl:value-of select="$startsWithDE" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hasGndNo = '1'">
						<xsl:for-each select="marc:subfield">
							<xsl:if test="@code='0'">
								<dcterms:creator rdf:resource="{nb:permalinkGnd(current())}" />
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="creator">
							<xsl:with-param name="codes">
								abcdeg
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<!-- Contributor -->
			<xsl:for-each
				select="marc:datafield[@tag='700']|marc:datafield[@tag='710']|marc:datafield[@tag='711']">
				<xsl:variable name="hasGndNo">
					<xsl:variable name="startsWithDE">
						<xsl:if test="marc:subfield[@code='0']">
							<xsl:for-each select="marc:subfield">
								<xsl:if test="@code='0'">
									<xsl:variable name="dollar0" select="." />
									<xsl:choose>
										<xsl:when
											test="starts-with($dollar0, '(DE-588)') and
											string-length($dollar0)>8">
											<xsl:value-of select="1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="0" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</xsl:variable>
					<xsl:value-of select="$startsWithDE" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hasGndNo = '1'">
						<xsl:for-each select="marc:subfield">
							<xsl:if test="@code='0'">
								<dcterms:contributor rdf:resource="{nb:permalinkGnd(current())}" />
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="not(marc:subfield[@code='t'])">
							<xsl:call-template name="contributor">
								<xsl:with-param name="codes">
									abcdenq
								</xsl:with-param>
							</xsl:call-template>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>


			<!-- ====================================== -->
			<!-- KIM: Orts-, Verlags- und Datumsangaben -->
			<!-- ====================================== -->

			<!-- RDA Unconstrained properties element set -->

			<!-- has publication statement -->
			<xsl:for-each select="marc:datafield[@tag='260']">
				<xsl:call-template name="publicationStatement">
					<xsl:with-param name="codes">
						abc3
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

			<!-- has place of publication -->
			<xsl:for-each select="marc:datafield[@tag='260']">
				<xsl:for-each select="marc:subfield[@code='a']">
					<xsl:variable name="str1" select="." />
					<xsl:variable name="str2" select="replace($str1, '[\[\]]', ' ')" />
					<xsl:variable name="str3" select="replace($str2, ' etc. ', '')" />
					<rdau:P60163 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
						<xsl:value-of select="nb:stringTool($str3)" />
					</rdau:P60163>
				</xsl:for-each>
			</xsl:for-each>

			<!-- Dublin Core -->

			<!-- Publisher -->
			<xsl:for-each select="marc:datafield[@tag='260']">
				<xsl:for-each select="marc:subfield[@code='b']">
					<xsl:variable name="str1" select="." />
					<xsl:variable name="str2" select="replace($str1, '[\[\]]', ' ')" />
					<xsl:variable name="str3" select="replace($str2, ' etc. ', '')" />
					<xsl:variable name="str4" select="nb:stringTool($str3)" />
					<xsl:variable name="str5" select="replace($str4, ',$', '')" />
					<dc:publisher rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
						<xsl:value-of select="$str5" />
					</dc:publisher>
				</xsl:for-each>
			</xsl:for-each>

			<!-- Date Issued -->
			<xsl:choose>
				<xsl:when
					test="substring($f008,7,1) = 'q' 
							or substring($f008,7,1) = 'r' 
							or substring($f008,7,1) = 's'">
					<dc:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
						<xsl:value-of select="$date1" />
					</dc:issued>
				</xsl:when>
				<xsl:when
					test="substring($f008,7,1) = 'c' 
							or substring($f008,7,1) = 'd' 
							or substring($f008,7,1) = 'm'
							or substring($f008,7,1) = 'u'">
					<dc:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
						<xsl:variable name="str" select="concat($date1, '-')" />
						<xsl:value-of select="concat($str, $date2)" />
					</dc:issued>
				</xsl:when>
			</xsl:choose>


			<!-- =============== -->
			<!-- KIM: Identifier -->
			<!-- =============== -->

			<!-- Dublin Core -->

			<!-- 035 - System Control Number (R) -->
			<xsl:for-each select="marc:datafield[@tag='035']">
				<xsl:for-each select="marc:subfield[@code='a']">
 						<dc:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="." />
						</dc:identifier>
				</xsl:for-each>
			</xsl:for-each>


			<!-- Bibo Ontology -->

			<!-- isbn -->
			<xsl:for-each select="marc:datafield[@tag='020']">
				<xsl:for-each select="marc:subfield[@code='a']">
					<xsl:variable name="str" select="." />
					<xsl:choose>
						<xsl:when test="matches($str, '^\d{12}[\d|X]')">
							<bibo:isbn13 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
								<xsl:value-of select="substring($str,1,13)" />
							</bibo:isbn13>
						</xsl:when>
						<xsl:when test="matches($str, '^\d{9}[\d|X]')">
							<bibo:isbn10 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
								<xsl:value-of select="substring($str,1,9)" />
							</bibo:isbn10>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:for-each>

			<!-- issn und eissn -->
			<xsl:choose>
				<xsl:when test="$remote = '1'">
					<xsl:for-each select="$record/marc:datafield[@tag='022']">
						<bibo:eissn rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="marc:subfield[@code='a']" />
						</bibo:eissn>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="marc:datafield[@tag='022']">
						<bibo:issn rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
							<xsl:value-of select="marc:subfield[@code='a']" />
						</bibo:issn>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>

			<!-- Umbel -->

			<!-- is like -->
			<xsl:for-each select="marc:datafield[@tag='024']">
				<xsl:variable name="dollar2" select="marc:subfield[@code='2']" />
				<xsl:choose>
					<xsl:when test="@ind1='7' and $dollar2 = 'DOI'">
						<xsl:for-each select="marc:subfield[@code='a']">
							<umbel:isLike rdf:resource="{nb:doi(current())}" />
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="@ind1='7' and $dollar2 = 'URN'">
						<xsl:for-each select="marc:subfield[@code='a']">
							<umbel:isLike rdf:resource="{nb:urn(current())}" />
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>

			<!-- ================ -->
			<!-- KIM: Medientypen -->
			<!-- ================ -->

			<!-- Bibo Ontology -->

			<!-- Document -->
			<xsl:if test="$leader07 = 'm'">
				<xsl:choose>
					<!-- audio document -->
					<xsl:when test="$leader06 = 'i' or $leader06 = 'j'">
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/AudioDocument" />
					</xsl:when>
					<!-- audio-visual document -->
					<xsl:when test="$leader06 = 'o' or $leader06 = 'p'">
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/AudioVisualDocument" />
					</xsl:when>
					<!-- Map -->
					<xsl:when test="$leader06 = 'e' or $leader06 = 'f'">
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/Map" />
					</xsl:when>
					<!-- Image -->
					<xsl:when test="$leader06 = 'k'">
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/Image" />
					</xsl:when>
					<xsl:otherwise>
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/Document" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<!-- Article -->
			<xsl:if test="$leader07 = 'a'">
				<rdf:type rdf:resource="http://purl.org/ontology/bibo/Article" />
			</xsl:if>
			<!-- Issue -->
			<xsl:if test="$leader07 = 'b'">
				<rdf:type rdf:resource="http://purl.org/ontology/bibo/Issue" />
			</xsl:if>
			<!-- Collection -->
			<xsl:if test="$leader07 = 'c'">
				<rdf:type rdf:resource="http://purl.org/ontology/bibo/Collection" />
			</xsl:if>
			<!-- Series und Periodical -->
			<xsl:if test="$leader07 = 's'">
				<xsl:choose>
					<xsl:when test="substring($f008,22,1) = 'm'">
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/Series" />
					</xsl:when>
					<xsl:otherwise>
						<rdf:type rdf:resource="http://purl.org/ontology/bibo/Periodical" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>



			<!-- RDA Unconstrained properties element set -->

			<!-- has mode of issuance -->
			<!-- integrating resource -->
			<xsl:if test="$leader07 = 'i'">
				<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/ModeIssue/1002" />
			</xsl:if>
			<!-- serial -->
			<xsl:if test="$leader07 = 's'">
				<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/ModeIssue/1003" />
			</xsl:if>

			<!-- has content type -->
			<!-- text -->
			<xsl:if test="$leader06 = 'a' or $leader06 = 't' or $text = '1'">
				<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1020" />
			</xsl:if>
			<!-- notated music -->
			<xsl:if test="$leader06 = 'c'">
				<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1010" />
			</xsl:if>
			<!-- performed music -->
			<xsl:if test="$leader06 = 'j'">
				<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1010" />
			</xsl:if>
			<!-- three-dimensional form -->
			<xsl:if test="$leader06 = 'r'">
				<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1021" />
			</xsl:if>

			<!-- has media type -->
			<!-- unmediated -->
			<xsl:if
				test="($typeOfMaterial = 'BK'
								or $typeOfMaterial = 'MU' 
								or $typeOfMaterial = 'CR' 
								or $typeOfMaterial = 'MX')
								and (substring($f008,24,1) = ' '
								or substring($f008,24,1) = 'd'
								or substring($f008,24,1) = 'f'
								or substring($f008,24,1) = 'r')">
				<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1007" />
			</xsl:if>
			<xsl:if
				test="($typeOfMaterial = 'MP'
								or $typeOfMaterial = 'VM')
								and (substring($f008,30,1) = ' '
								or substring($f008,30,1) = 'd'
								or substring($f008,30,1) = 'f'
								or substring($f008,30,1) = 'r')">
				<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1007" />
			</xsl:if>
			<!-- microform -->
			<xsl:if
				test="($typeOfMaterial = 'BK'
								or $typeOfMaterial = 'MU' 
								or $typeOfMaterial = 'CR' 
								or $typeOfMaterial = 'MX')
								and (substring($f008,24,1) = 'a'
								or substring($f008,24,1) = 'b'
								or substring($f008,24,1) = 'c')">
				<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1002" />
			</xsl:if>
			<xsl:if
				test="($typeOfMaterial = 'MP'
								or $typeOfMaterial = 'VM')
								and (substring($f008,30,1) = 'a'
								or substring($f008,30,1) = 'b'
								or substring($f008,30,1) = 'c')">
				<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1002" />
			</xsl:if>

			<!-- audio -->
			<xsl:choose>
				<xsl:when test="$audio = '1'">
					<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1001" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$leader06 = 'i' or $leader06 = 'j'">
						<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1001" />
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<!-- projected -->
			<xsl:if test="$leader06 = 'g'">
				<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1005" />
			</xsl:if>

			<!-- computer -->
			<xsl:choose>
				<xsl:when test="$computer = '1'">
					<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$typeOfMaterial = 'CP'">
						<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003" />
					</xsl:if>
					<!-- <xsl:if test="($leader06 = 'c' or $leader06 ='d' or $leader06 ='i' 
						or $leader06 ='j' or $leader06 ='p' or $leader06 ='r' or $leader06 ='t') 
						and (substring($f008,24,1) = 'o' or substring($f008,24,1) = 'q' or substring($f008,24,1) 
						= 's')"> <rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003" 
						/> </xsl:if> -->
					<xsl:if
						test="($typeOfMaterial = 'BK'
								or $typeOfMaterial = 'MU' 
								or $typeOfMaterial = 'CR' 
								or $typeOfMaterial = 'MX')
								and (substring($f008,24,1) = 'o'
								or substring($f008,24,1) = 'q'
								or substring($f008,24,1) = 's')">
						<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003" />
					</xsl:if>
					<!-- <xsl:if test="($leader06 = 'e' or $leader06 ='f' or $leader06 ='k' 
						or $leader06 ='o') and (substring($f008,30,1) = 'o' or substring($f008,30,1) 
						= 'q' or substring($f008,30,1) = 's')"> <rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003" 
						/> </xsl:if> -->
					<xsl:if
						test="($typeOfMaterial = 'MP'
								or $typeOfMaterial = 'VM')
								and (substring($f008,30,1) = 'o'
								or substring($f008,30,1) = 'q'
								or substring($f008,30,1) = 's')">
						<rdau:P60050 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003" />
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>

			<!-- video -->
			<xsl:if
				test="($typeOfMaterial = 'VM')
								and (substring($f008,34,1) = 'v')">
				<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1008" />
			</xsl:if>


			<!-- has carrier type -->
			<!-- remote -->
			<xsl:if test="$remote = '1'">
				<rdau:P60048 rdf:resource="http://rdaregistry.info/termList/RDACarrierType/1018" />
			</xsl:if>


			<!-- has form of tactile notation -->
			<!-- braille code -->
			<xsl:choose>
				<xsl:when test="$braille = '1'">
					<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/TacNotation/1001" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:if
						test="($typeOfMaterial = 'BK'
								or $typeOfMaterial = 'MU' 
								or $typeOfMaterial = 'CR' 
								or $typeOfMaterial = 'MX')
								and (substring($f008,24,1) = 'f')">
						<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/TacNotation/1001" />
					</xsl:if>
					<xsl:if
						test="($typeOfMaterial = 'MP'
								or $typeOfMaterial = 'VM')
								and (substring($f008,30,1) = 'f')">
						<rdau:P60049 rdf:resource="http://rdaregistry.info/termList/TacNotation/1001" />
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>


			<!-- Isbd -->

			<!-- multiple media -->
			<xsl:if test="$leader06 = 'o' or $leader06 = 'p'">
				<dc:terms rdf:resource="http://iflastandards.info/ns/isbd/terms/mediatype/T1008" />
			</xsl:if>


			<!-- =============== -->
			<!-- KIM: Relationen -->
			<!-- =============== -->

			<xsl:for-each select="marc:datafield[@tag='770']|marc:datafield[@tag='773']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='w'">
						<xsl:if test="matches(current(),'^\d+$')">
							<xsl:variable name="relation"
								select="format-number(current(), '000000000')" />
							<dcterms:isPartOf
								rdf:resource="{concat('http://permalink.snl.ch/bib/sz', $relation)}" />
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each
				select="marc:datafield[@tag='772']|marc:datafield[@tag='774']
			 				|marc:datafield[@tag='775']|marc:datafield[@tag='776']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='w'">
						<xsl:if test="matches(current(),'^\d+$')">
							<xsl:variable name="relation"
								select="format-number(current(), '000000000')" />
							<dcterms:hasPart
								rdf:resource="{concat('http://permalink.snl.ch/bib/sz', $relation)}" />
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>

			<xsl:for-each
				select="marc:datafield[@tag='800']|marc:datafield[@tag='810']
			 				|marc:datafield[@tag='811']|marc:datafield[@tag='830']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='w'">
						<xsl:if test="matches(current(),'^\d+$')">
							<xsl:variable name="relation"
								select="format-number(current(), '000000000')" />
							<dcterms:isPartOf
								rdf:resource="{concat('http://permalink.snl.ch/bib/sz', $relation)}" />
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>


			<!-- ================== -->
			<!-- KIM: Sprachangaben -->
			<!-- ================== -->

			<!-- aus Feld 041 -->
			<xsl:for-each select="marc:datafield[@tag='041']">
				<xsl:for-each select="marc:subfield">
					<xsl:if test="@code='a'">
						<xsl:variable name="language" select="replace(current(),'\s','')" />
						<dcterms:language
							rdf:resource="{concat('http://id.loc.gov/vocabulary/iso639-2/', $language)}" />
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
			<!-- aus Feld 008 -->
			<dcterms:language
				rdf:resource="{concat('http://id.loc.gov/vocabulary/iso639-2/', replace(substring($f008,36,3),'\s',''))}" />

			<!-- ================== -->
			<!-- KIM: Umfangsangabe -->
			<!-- ================== -->

			<xsl:if test="marc:datafield[@tag='300']">
				<xsl:for-each select="marc:datafield[@tag='300']">
					<xsl:for-each select="marc:subfield">
						<xsl:if test="@code='a'">
							<isbd:P1053 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
								<xsl:value-of select="nb:stringTool(current())" />
							</isbd:P1053>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>

			<!-- ============== -->
			<!-- KIM: Sonstiges -->
			<!-- ============== -->

			<!-- Ausgabebezeichnung -->
			<xsl:if test="marc:datafield[@tag='250']">
				<xsl:for-each select="marc:datafield[@tag='250']">
					<xsl:for-each select="marc:subfield">
						<xsl:if test="@code='a'">
							<bibo:edition rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
								<xsl:value-of select="nb:stringTool(current())" />
							</bibo:edition>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>

			<!-- Titel Überordnung -->
			<xsl:for-each select="marc:datafield[@tag='773']">
				<xsl:call-template name="bibliographicCitation">
					<xsl:with-param name="codes">
						ag
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag='440']">
				<xsl:call-template name="bibliographicCitation">
					<xsl:with-param name="codes">
						axv
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="marc:datafield[@tag='490']">
				<xsl:call-template name="bibliographicCitation">
					<xsl:with-param name="codes">
						axv
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>

			<!-- 3.9.3 Hochschulschriftenvermerk -->
			<xsl:if test="marc:datafield[@tag='502']">
				<xsl:for-each select="marc:datafield[@tag='502']">
					<xsl:for-each select="marc:subfield">
						<xsl:if test="@code='a'">
							<rdau:P60489 rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
								<xsl:value-of select="nb:stringTool(current())" />
							</rdau:P60489>
						</xsl:if>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:if>

			<!-- 3.9.4 Inhaltserschliessung -->
			<xsl:for-each
				select="marc:datafield[@tag='600']|marc:datafield[@tag='610']|marc:datafield[@tag='611']
				|marc:datafield[@tag='630']|marc:datafield[@tag='648']|marc:datafield[@tag='650']|marc:datafield[@tag='651']
				|marc:datafield[@tag='655']">
				<xsl:variable name="hasGndNo">
					<xsl:variable name="startsWithDE">
						<xsl:if test="marc:subfield[@code='0']">
							<xsl:for-each select="marc:subfield">
								<xsl:if test="@code='0'">
									<xsl:variable name="dollar0" select="." />
									<xsl:choose>
										<xsl:when
											test="starts-with($dollar0, '(DE-588)') and
											string-length($dollar0)>8">
											<xsl:value-of select="1" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="0" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</xsl:variable>
					<xsl:value-of select="$startsWithDE" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$hasGndNo = '1'">
						<xsl:for-each select="marc:subfield">
							<xsl:if test="@code='0'">
								<dcterms:subject rdf:resource="{nb:permalinkGnd(current())}" />
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="subject">
							<xsl:with-param name="codes">
								abcdefghijklmnopqrstuvwxyz
							</xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<!-- Sachgruppe -->
			<xsl:for-each select="marc:datafield[@tag='082']">
				<xsl:if test="@ind1='7' and @ind2='4'">
					<xsl:for-each select="marc:subfield">
						<xsl:if test="@code='a'">
							<dcterms:subject
								rdf:resource="{concat('http://d-nb.info/ddc-sg/', (replace(current(),'\s','')))}" />

						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>


			<!-- 3.9.3 URL -->
			<xsl:for-each select="marc:datafield[@tag='856']">
				<xsl:choose>
					<xsl:when test="@ind1='4' and @ind2='1'">
						<xsl:for-each select="marc:subfield">
							<xsl:if test="@code='u'">
								<dcterms:tableOfContents rdf:resource="{replace(current(),'\s','')}" />
							</xsl:if>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="marc:subfield">
							<xsl:if test="@code='u'">
								<foaf:isPrimaryTopicOf rdf:resource="{replace(current(),'\s','')}" />
							</xsl:if>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

		</rdf:Description>
		<!-- rdf:Description -->


	</xsl:template>


</xsl:stylesheet>

