| Element Rule Applies To | Rule Identifier | Rule Content |
|--------------------------|-----------------|--------------|
| complexType CodeListDocument | Rule 1 [document] | A code list must have at least one key, unless it is a metadata-only definition without a 'SimpleCodeList' element. |
| attribute xml:base in complexType CodeListDocument | Rule 2 [application] | xml:base does not apply to canonical URIs. |
| complexType CodeListRef | Rule 3 [application] | The code list reference must be valid. An application may use the CanonicalVersionUri to select a local copy of the code list. If there is no CanonicalVersionUri, the CanonicalUri may be used to select a local copy of the code list. Otherwise the LocationUri value(s) may be tried in order, until a valid code list document is retrieved. An application must signal an error to the user if it is not able to retrieve a code list document to match the code list reference. |
| element CanonicalUri in complexType CodeListRef | Rule 4 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalUri in complexType CodeListRef | Rule 5 [application] | Must not be used as a de facto location URI. |
| element CanonicalVersionUri in complexType CodeListRef | Rule 6 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalVersionUri in complexType CodeListRef | Rule 7 [application] | Must not be used as a de facto location URI. |
| element LocationUri in complexType CodeListRef | Rule 8 [application] | If the CanonicalVersionUri has been defined, the LocationUri must reference a genericode CodeList document. If the CanonicalVersionUri is undefined, the LocationUri must reference a genericode CodeList Metadata document. An application must signal an error to the user if a LocationUri does not reference the appropriate type of genericode document. |
| element LocationUri in complexType CodeListRef | Rule 9 [application] | An application must signal an error to the user if a document retrieved using a LocationUri is not in genericode format. |
| attribute xml:base in complexType CodeListRef | Rule 10 [application] | xml:base does not apply to canonical URIs. |
| attribute xml:base in complexType CodeListSetDocument | Rule 11 [application] | xml:base does not apply to canonical URIs. |
| complexType ColumnRef | Rule 12 [application] | The column reference must be valid. An application may use the CanonicalVersionUri to select a local copy of the code list or column set which contains the column definition. Otherwise the LocationUri value(s) may be tried in order, until a valid code list or column set document (containing the necessary column definition) is retrieved. An application must signal an error to the user if it is not able to retrieve a code list or column set document which contains the necessary column definition. |
| attribute Use in complexType ColumnRef | Rule 13 [application] | If specified, this overrides the usage specified in the external column set or code list document. |
| attribute xml:base in complexType ColumnRef | Rule 14 [application] | xml:base does not apply to canonical URIs. |
| attribute xml:base in complexType ColumnSet | Rule 15 [application] | xml:base does not apply to canonical URIs. |
| attribute xml:base in complexType ColumnSetDocument | Rule 16 [application] | xml:base does not apply to canonical URIs. |
| complexType ColumnSetRef | Rule 17 [application] | The column set reference must be valid. An application may use the CanonicalVersionUri to select a local copy of the column set or code list. Otherwise the LocationUri value(s) may be tried in order, until a valid column set or code list document is retrieved. An application must signal an error to the user if it is not able to retrieve a column set or code list document to match the column set reference. |
| attribute xml:base in complexType ColumnSetRef | Rule 18 [application] | xml:base does not apply to canonical URIs. |
| attribute Type in complexType Data | Rule 19 [document] | The datatype ID must not include a namespace prefix. For the W3C XML Schema datatypes, possible datatype IDs are 'string', 'token', 'boolean', 'decimal', etc. |
| attribute Type in complexType Data | Rule 20 [document] | If the data is complex (i.e. XML), this value is set to the root element name for the XML value, or '*' if the root element name is not restricted. |
| attribute DatatypeLibrary in complexType Data | Rule 21 [application] | If this URI not explicitly provided, the datatype library for the enclosing column set is used. |
| attribute DatatypeLibrary in complexType Data | Rule 22 [document] | If the data is complex (i.e. XML), this value is set to the namespace URI for the XML, or '*' if the namespace URI is not restricted. |
| complexType DataRestrictions | Rule 23 [document] | The 'gc:lang' attribute may be specified only if no language is already set for the data type that is being restricted. |
| attribute ExternalRef in attributeGroup ExternalReference | Rule 24 [document] | The external reference must not be prefixed with a '#' symbol. |
| element CanonicalUri in complexType Identification | Rule 25 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalUri in complexType Identification | Rule 26 [application] | Must not be used as a de facto location URI. |
| element CanonicalVersionUri in modelGroup IdentificationRefUriSet | Rule 27 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalVersionUri in modelGroup IdentificationRefUriSet | Rule 28 [application] | Must not be used as a de facto location URI. |
| element LocationUri in modelGroup IdentificationRefUriSet | Rule 29 [application] | An application must signal an error to the user if a document retrieved using a LocationUri is not in genericode format. |
| element CanonicalUri in modelGroup IdentificationVersionUriSet | Rule 30 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalUri in modelGroup IdentificationVersionUriSet | Rule 31 [application] | Must not be used as a de facto location URI. |
| element CanonicalVersionUri in modelGroup IdentificationVersionUriSet | Rule 32 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalVersionUri in modelGroup IdentificationVersionUriSet | Rule 33 [application] | Must not be used as a de facto location URI. |
| complexType Key | Rule 34 [document] | Only required columns can be used for keys. |
| complexType KeyRef | Rule 35 [application] | The key reference must be valid. An application may use the CanonicalVersionUri to select a local copy of the code list or column set which contains the key definition. Otherwise the LocationUri value(s) may be tried in order, until a valid code list or column set document (containing the necessary key definition) is retrieved. An application must signal an error to the user if it is not able to retrieve a code list or column set document which contains the necessary key definition. |
| attribute xml:base in complexType KeyRef | Rule 36 [application] | xml:base does not apply to canonical URIs. |
| element Value in complexType Row | Rule 37 [document] | A value must be provided for each required column. A value does not need to be provided for a column if the column is optional. |
| element Value in complexType Row | Rule 38 [document] | If a value does not have an explicit column reference, the column is taken to be the column following the column of the preceding value in the row, or the first column if the value is the first value of the row. |
| complexType ShortName | Rule 39 [document] | Must not contain whitespace characters. |
| complexType SimpleCodeList | Rule 40 [application] | Applications must not have any dependency on the ordering of the rows. |
| element SimpleValue in modelGroup ValueChoice | Rule 41 [document] | The value must be valid with respect to the datatype and restrictions of the matching column. |
| element ComplexValue in modelGroup ValueChoice | Rule 42 [document] | The names of all direct child elements of the 'ComplexValue' element must match the datatype ID for the matching column, unless that ID is set to '*'. |
| element ComplexValue in modelGroup ValueChoice | Rule 43 [document] | The namespace URIs of all direct child elements of the 'ComplexValue' element must match the datatype library URI for the matching column, unless that URI is set to '*'. |
| element CanonicalVersionUri in modelGroup VersionLocationUriSet | Rule 44 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalVersionUri in modelGroup VersionLocationUriSet | Rule 45 [application] | Must not be used as a de facto location URI. |
| element LocationUri in modelGroup VersionLocationUriSet | Rule 46 [application] | An application must signal an error to the user if a document retrieved using a LocationUri is not in genericode format. |
| complexType CodeListSetRef | Rule 47 [application] | The code list set reference must be valid. An application may use the CanonicalVersionUri to select a local copy of the code list set. If there is no CanonicalVersionUri, the CanonicalUri may be used to select a local copy of the code list set. Otherwise the LocationUri value(s) may be tried in order, until a valid code list set document is retrieved. An application must signal an error to the user if it is not able to retrieve a code list set document to match the code list set reference. |
| element CanonicalUri in complexType CodeListSetRef | Rule 48 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalUri in complexType CodeListSetRef | Rule 49 [application] | Must not be used as a de facto location URI. |
| element CanonicalVersionUri in complexType CodeListSetRef | Rule 50 [document] | Must be an absolute URI, must not be relative. |
| element CanonicalVersionUri in complexType CodeListSetRef | Rule 51 [application] | Must not be used as a de facto location URI. |
| element LocationUri in complexType CodeListSetRef | Rule 52 [application] | If the CanonicalVersionUri has been defined, the LocationUri must reference a genericode CodeListSet document. If the CanonicalVersionUri is undefined, the LocationUri must reference a genericode CodeListSet Metadata document. An application must signal an error to the user if a LocationUri does not reference the appropriate type of genericode document. |
| element LocationUri in complexType CodeListSetRef | Rule 53 [application] | An application must signal an error to the user if a document retrieved using a LocationUri is not in genericode format. |
| attribute xml:base in complexType CodeListSetRef | Rule 54 [application] | xml:base does not apply to canonical URIs. |