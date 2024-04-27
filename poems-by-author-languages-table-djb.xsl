<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cam="sevdah-functions"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
  xmlns="http://www.w3.org/1999/xhtml" version="3.0">
  <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
    indent="yes"/>
  <!-- ================================================================== -->
  <!-- Stylesheet variables                                               -->
  <!-- ================================================================== -->
  <xsl:variable name="all-docs" as="document-node()+" select="collection('texts_xml/?select=*.xml')"/>
  <xsl:variable name="all-langs-sorted" as="xs:string+"
    select="$all-docs//@lang => distinct-values() => sort()"/>
  <!-- ================================================================== -->
  <!-- Local functions                                                    -->
  <!-- ================================================================== -->
  <xsl:function name="cam:initial-cap" as="xs:string">
    <xsl:param name="input" as="xs:string"/>
    <xsl:value-of select="substring($input, 1, 1) ! upper-case(.) || substring($input, 2)"/>
  </xsl:function>
  <xsl:function name="cam:rounded-percentage" as="xs:string">
    <xsl:param name="item-count" as="xs:integer"/>
    <xsl:param name="total-count" as="xs:integer"/>
    <xsl:sequence select="format-number(100 * $item-count div $total-count, '0.00')"/>
  </xsl:function>
  <xsl:function name="cam:surname-first" as="xs:string">
    <xsl:param name="full-name" as="xs:string"/>
    <xsl:variable name="name-parts" as="xs:string+" select="tokenize($full-name)"/>
    <xsl:sequence
      select="concat($name-parts[last()], ', ', string-join($name-parts[position() ne last()], ' '))"
    />
  </xsl:function>
  <!-- ================================================================== -->
  <!-- Templates                                                          -->
  <!-- ================================================================== -->
  <xsl:template name="xsl:initial-template">
    <html>
      <head>
        <title>Language precentages per poem</title>
        <style type="text/css">
          table,
          tr,
          th,
          td {
            border: 1px solid black;
            border-collapse: collapse;
          }
          tr:not(:first-child) > th {
            text-align: left;
          }
          th,
          td {
            padding: 2px 3px;
          }
          td {
            text-align: right;
          }</style>
      </head>
      <body>
        <table>
          <tr>
            <th>Song</th>
            <xsl:for-each select="$all-langs-sorted">
              <th>
                <xsl:value-of select="cam:initial-cap(.)"/>
              </th>
            </xsl:for-each>
          </tr>
          <xsl:for-each-group select="$all-docs/*"
            group-by="descendant::author ! cam:surname-first(.)">
            <!-- NB: The @collation attribute on <xsl:sort> requires Saxon PE or EE (not HE) -->
            <xsl:sort select="current-grouping-key()"
              collation="http://www.w3.org/2013/collation/UCA?lang=bs"/>
            <xsl:variable name="all-langs-for-author" as="attribute(lang)+"
              select="current-group()//origin/@lang"/>
            <tr>
              <th>
                <xsl:value-of select="current-grouping-key()"/>
              </th>
              <xsl:for-each select="$all-langs-sorted">
                <td>
                  <xsl:variable name="this-lang" as="attribute(lang)*"
                    select="$all-langs-for-author[. eq current()]"/>
                  <xsl:value-of
                    select="cam:rounded-percentage(count($this-lang), count($all-langs-for-author))"
                  />
                </td>
              </xsl:for-each>
            </tr>
          </xsl:for-each-group>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
