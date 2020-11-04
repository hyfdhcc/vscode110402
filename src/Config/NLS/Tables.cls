Include (%syNLS, %ems)

/// This class describes the basic properties of a table and,
/// depending on its type, can also contain the table data itself.<br><br>
/// For types XLT, COL, and Case, the data points are stored in a
/// SubTable object. For types Patcode, Ident and XY, the data points
/// are kept in the Table object itself. Mode tables use a hybrid
/// mechanism, with the modal escape sequences kept in the Table and
/// the data points in a Mode SubTable. Pattern tables keep the pattern
/// code ranges but also point to a Patcode Table.
/// <br><br>Warning!<br><br>
/// Only tables which have a "NameFrom" or "NameTo" property beginning
/// with "y" (e.g. "yPrinterXYZ" or "yMytable")
/// are considered custom tables and are preserved during system
/// upgrades. All other tables are restored to their original
/// state and any changes to them made with methods from this class will
/// be lost in an upgrade.
Class Config.NLS.Tables Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index TypeNameFromNameToIndex On (Type, NameFrom, NameTo) [ IdKey ];

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// For Collation tables only.<br>
/// $LB(collation #,local encoding rule,global encoding rule)
Property COLRules As %List;

/// Description of the Table.<br>
Property Description As %String(MAXLEN = 128);

/// For Identifier tables only.<br>
/// $LB("start:num","start:num",...)<br>
Property Identifiers As %List;

/// For Mode tables only.<br>
/// array({mode-index})="mode-name:mode-bytes:mode-seq"<br>
Property Modes As array Of %String;

/// For XLT tables this corresponds to the source encoding or
/// character set. For the other types this is the character set
/// used by the current locale.
Property NameFrom As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// For XLT tables this corresponds to the target encoding or
/// character set. For the other types is is usually the name
/// of the table.
Property NameTo As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// For Patcode tables only.<br>
/// $LB("alias:codes","alias:codes",...)<br>
Property PatAliases As %List;

/// For Patcode tables only.<br>
/// $LB("code:num","code:num",...)<br>
Property PatCodes As %List;

/// For pattern tables only.<br>
/// array("A")=$LB("start:num","start:num",...)<br>
Property PatternRanges As array Of %List;

/// For LowerCase, UpperCase, TitleCase, XLT, COL and Pattern tables.
Property SubTableName As %String;

/// Type of table:<br>
/// Lowercase, UpperCase, TitleCase,<br>
/// XLT, COL, Mode, Pattern, Ident, XY, Patcode<br>
Property Type As %String(MAXLEN = 10, MINLEN = 1) [ Required ];

/// For XLT tables only.<br>
/// XLT Default actions:<br>
/// 0 - Generate error<br>
/// 1 - Replace with replacement string/value<br>
/// 2 - Replace with original string/value (ignore)<br>
Property XLTDefaultAction As %Integer;

/// For XLT modal tables only.<br>
/// XLT Name of mode table.<br>
Property XLTModeTableName As %String;

/// For XLT tables only.<br>
/// XLT Replacement value.<br>
Property XLTReplacementValue As %String;

/// For XLT tables only.<br>
/// XLT Reversibility:<br>
/// 0 - Non-reversible (ambiguous)<br>
/// 1 - Reversible<br>
/// 2 - Generated from a reversible table<br>
Property XLTReversibility As %Integer;

/// For XLT tables only.<br>
/// XLT Table type:<br>
/// 0 - Non-modal to non-modal<br>
/// 1 - Non-modal to modal<br>
/// 2 - Modal to modal<br>
Property XLTType As %Integer;

/// For XY table only.<br>
/// array({xytype})=$LB("start:num","start:num",...)<br>
/// xytype:<br>
/// 0 - Normal printing character<br>
/// 1 - Full width character<br>
/// 2 - Non printing character<br>
/// 3 - Backspace character<br>
/// 4 - Line feed character<br>
/// 5 - Form feed character<br>
/// 6 - Carriage return character<br>
/// 7 - Escape sequence character<br>
Property XYActions As array Of %List;

/// Compiles a single Table<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT", etc.)</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li></ul>
ClassMethod Compile(Type As %String, NameFrom As %String, NameTo As %String) As %Status
{
}

/// Creates a Table the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT", etc.)</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li>
///   <li>Properties - Array of properties corresponding to the class properties</li></ul>
ClassMethod Create(Type As %String, NameFrom As %String, NameTo As %String, ByRef Properties As %String) As %Status
{
}

/// Deletes a Table.<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT", etc.)</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li></ul>
ClassMethod Delete(Type As %String, NameFrom As %String, NameTo As %String, Deep As %Integer = 0) As %Status
{
}

/// Checks for the existence of a Table in the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT", etc.)</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li></ul>
/// Return values:<br>
/// If Value of the method = 0 (Table does not exist, or some error occured)<ul>
///   <li>Table = Null</li>
///   <li>Status = Table "x" does not exist, or other error message</li></ul>
/// If Value of the method = 1 (Table exists)<ul>
///   <li>Table = Object handle to Table</li>
///   <li>Status = $$$OK</li></ul>
ClassMethod Exists(Type As %String, NameFrom As %String, NameTo As %String, ByRef Table As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// Exports Table Objects to a file in xml format.<br><br>
/// Parameters:<br>
///   <li>FileName - Output file name</li>
///   <li>NumExported (byref) - Returns number of Table records exported.</li>
///   <li>Tables - Comma separated list of Tables to export, "*" = All</li></ul>
ClassMethod Export(FileName As %String = "TablesExport.xml", ByRef NumExported As %Integer, Types As %String = "*", NamesFrom As %String = "*", NamesTo As %String = "*") As %Status
{
}

/// Exports Table Objects to separate xml files.<br><br>
/// Parameters:<br>
///   <li>Dir - Directory where the files will be created</li>
///   <li>NumExported (byref) - Returns number of Table records exported.</li>
///   <li>Types/NamesFrom/NamesTo - Comma separated list of Tables to export, "*" = All</li></ul>
ClassMethod ExportDir(Dir As %String, ByRef NumExported As %Integer, Types As %String = "*", NamesFrom As %String = "*", NamesTo As %String = "*") As %Status
{
}

/// Similar to Export() but uses a list of Tables to export rather than a
/// query. Used internally by Locales.ExportList() and other utilities.<br><br>
/// Parameters:<ul>
///   <li>FileName - Output file name</li>
///   <li>NumExported - Number of exported SubTables [out]</li>
///   <li>Tables - Array of Tables to export</li></ul>
ClassMethod ExportList(FileName As %String = "TablesExport.xml", ByRef NumExported As %Integer, ByRef Tables As %String) As %Status
{
}

/// Exports one Table record to ^%nls.<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT", etc.)</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li>
///   <li>Deep - If true export associated SubTable(s)</li></ul>
ClassMethod ExportToNls(Type As %String, NameFrom As %String, NameTo As %String, Deep As %Integer = 0) As %Status
{
}

/// Exports all Table records to ^%nls.<br><br>
/// Parameters:<ul>
///   <li>Return values: Status</li>
///   <li>NumExported - Number of exported tables</li></ul>
ClassMethod ExportAllToNls(ByRef NumExported As %Integer, Deep As %Integer = 0) As %Status
{
}

/// Deletes a single row in a "FromTo" table (XLT, COL or Case).<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT")</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li>
///   <li>FromCode - Source character or sequence</li></ul>
ClassMethod FromToDeleteRow(Type As %String, NameFrom As %String, NameTo As %String, FromCode As %String) As %Status
{
}

/// Edits a single row in a "FromTo" table (XLT, COL or Case).<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT")</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li>
///   <li>FromCode - Source character or sequence</li>
///   <li>ToCode - Target character or sequence</li></ul>
ClassMethod FromToEditRow(Type As %String, NameFrom As %String, NameTo As %String, FromCode As %String, ToCode As %String) As %Status
{
}

/// Gets a Table's properties from the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of the Table to get</li>
///   <li>Properties - Array of properties. See the Create() method for a full list</li></ul>
ClassMethod Get(Type As %String, NameFrom As %String, NameTo As %String, ByRef Properties As %String) As %Status
{
}

/// Gets a Table's properties from the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Properties - See the Create method for more information on properties returned</li></ul>
Method GetProperties(ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Gets a Table's properties from the ^%nls global.<br><br>
/// Parameters:<ul>
///   <li>Type - Type of table ("XLT", "COL", etc.)</li>
///   <li>From - Source character set ("Latin1", "Unicode", etc)</li>
///   <li>To - Destination character set</li>
///   <li>Properties - Reference to array where properties will be stored</li>
///   <li>Ref - Source global reference</li></ul>
/// See the Create method for more information on properties returned
ClassMethod GetPropertiesFromNls(Type As %String, NameFrom As %String, NameTo As %String, ByRef Properties As %String, Ref As %String = "^%nls") As %Status
{
}

/// Imports Table records from an xml file.<br><br>
/// Parameters:<ul>
///   <li>FileName - Filename to import Table records from</li>
///   <li>NumImported (byref) - Returns number of records imported</li>
///   <li>Flags - Control import</li><ul>
///     <li>Bit 0 - Do not import records, just return count</li></ul></ul>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "TablesExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Imports one Table record from ^%nls.<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT")</li>
///   <li>NameFrom - Character set or name (eg: "Unicode", "DTM-J")</li>
///   <li>NameTo - Character set or name (eg: "Unicode", "DTM-J")</li>
///   <li>Deep - If true also import associated SubTables</li>
///   <li>Ref - Source global reference</li></ul>
ClassMethod ImportFromNls(Type As %String, NameFrom As %String, NameTo As %String, Deep As %Integer = 0, Ref As %String = "^%nls") As %Status
{
}

/// Imports Table records from ^%nls.<br><br>
/// Parameters:<ul>
///   <li>NumImported (byref) - Returns number of records imported</li>
///   <li>Flags - Control import</li><ul>
///     <li>Bit 0 - Do not import records, just return count</li></ul>
///   <li>Ref - Source global reference</li></ul>
ClassMethod ImportAllFromNls(ByRef NumImported As %Integer, Flags As %Integer = 0, Deep As %Integer = 0, Ref As %String = "^%nls") As %Status
{
}

/// Imports table files from a directory.<br><br>
/// Parameters:<ul>
///   <li>Dir - Directory to import NLS files from</li>
///   <li>NumImported (byref) - Returns number of tables imported.</li></ul>
ClassMethod ImportDir(Dir As %String, ByRef NumImported As %String, forcemulticompile As %Boolean = "") As %Status
{
}

/// Verifies whether a table can be loaded<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT")</li>
///   <li>NameFrom - Character set or name (eg: "Unicode", "DTM-J")</li>
///   <li>NameTo - Character set or name (eg: "Unicode", "DTM-J")</li>
///   <li>Table - Returned Table reference</li>
///   <li>Errors - Returned list of errors</li></ul>
/// Returns: True if table has been compiled and can be loaded<br>
///          False otherwise
ClassMethod IsLoadable(Type As %String, NameFrom As %String, NameTo As %String, ByRef Table As %ObjectHandle, ByRef Errors As %String) As %Boolean
{
}

/// Verifies validity of table<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT")</li>
///   <li>NameFrom - Character set or name (eg: "Unicode", "DTM-J")</li>
///   <li>NameTo - Character set or name (eg: "Unicode", "DTM-J")</li>
///   <li>Errors - Returned list of errors</li></ul>
///   <li>Warnings - Returned list of warnings</li></ul>
/// Returns: True if the table has a consistent definition<br>
///          False otherwise
ClassMethod IsValid(Type As %String, NameFrom As %String, NameTo As %String, ByRef Errors As %String, ByRef Warnings As %String) As %Boolean
{
}

/// Loads a Table from a Locale.<br><br>
/// Parameters:<ul>
///   <li>loc - Name of locale that contains table (eg: "jpnw")</li>
///   <li>typ - Type of table (eg: "XLT", "UpperCase", "XY")</li>
///   <li>nam - Name of table in locale (eg: "CP1252", "UnicodeBig")</li></ul>
/// If typ="COL" or typ="XLT", loads both input and output sides.<br>
/// If loc = current locale, changes defaults if necessary<br>
ClassMethod Load(loc As %String, typ As %String, nam As %String) As %Status
{
}

/// Modifies an existing Table's properties in the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Type - Table type (eg: "LowerCase", "COL", "XLT", etc.)</li>
///   <li>NameFrom - Source character set (eg: "Unicode", "CP1250", "DTM-J", "etc.)</li>
///   <li>NameTo - Target character set (eg: "Unicode", "CP1251", "Latin2", etc.)</li>
///   <li>Properties - Array of properties to modify.</li></ul>
/// See the Create() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, or is the same
/// as the existing value, the value is not modified.<br>
ClassMethod Modify(Type As %String, NameFrom As %String, NameTo As %String, ByRef Properties As %String) As %Status
{
}

/// Sets a Table's properties from the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Properties - See the Create method for more information on properties returned</li></ul>
Method SetProperties(ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Sets a Table's properties in ^%nls.<br><br>
/// Parameters:<ul>
///   <li>Properties - Array with locale properties</li></ul>
ClassMethod SetPropertiesToNls(ByRef Properties As %String) As %Status
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
/// If the service name is %Service Terminal, reinitialize the memory which depends on it.
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private ]
{
}

/// List all Table records, brief display. <br>
/// Names - Comma separated list of Table names, "*" = All<br>
/// Types - Comma separated list of Table types, "*" = All<br>
/// NamesFrom - Comma separated list of source character set names, "*" = All<br>
/// NamesTo - Comma separated list of target character set names, "*" = All<br>
/// Note: This query may change in future versions<br>
Query Detail(Types As %String, NamesFrom As %String, NamesTo As %String) As %Query(ROWSPEC = "Type:%String,NameFrom:%String,NameTo:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Types As %String = "*", NamesFrom As %String = "*", NamesInto As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

Query List(Types As %String = "*", NamesFrom As %String = "*", NamesTo As %String = "*") As %Query(ROWSPEC = "Type:%String,NameFrom:%String,NameTo:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Types As %String = "*", NamesFrom As %String, NamesTo As %String) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Query FromToTable(Type As %String, NameFrom As %String, NameTo As %String) As %Query(ROWSPEC = "FromCode:%String,ToCode:%String") [ SqlProc ]
{
}

ClassMethod FromToTableExecute(ByRef qHandle As %Binary, Type As %String, NameFrom As %String, NameTo As %String) As %Status [ Internal ]
{
}

ClassMethod FromToTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod FromToTableClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = FromToTableExecute ]
{
}

Storage Default
{
<CounterLocation>^Config.NLS.TablesC</CounterLocation>
<Data name="Modes">
<Attribute>Modes</Attribute>
<Structure>subnode</Structure>
<Subscript>"Modes"</Subscript>
</Data>
<Data name="PatternRanges">
<Attribute>PatternRanges</Attribute>
<Structure>subnode</Structure>
<Subscript>"PatternRanges"</Subscript>
</Data>
<Data name="TablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Identifiers</Value>
</Value>
<Value name="4">
<Value>SubTableName</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
<Value name="6">
<Value>XLTDefaultAction</Value>
</Value>
<Value name="7">
<Value>XLTModeTableName</Value>
</Value>
<Value name="8">
<Value>XLTReplacementValue</Value>
</Value>
<Value name="9">
<Value>XLTReversibility</Value>
</Value>
<Value name="10">
<Value>XLTType</Value>
</Value>
<Value name="11">
<Value>Patcodes</Value>
</Value>
<Value name="12">
<Value>PatAliases</Value>
</Value>
<Value name="13">
<Value>PatCodes</Value>
</Value>
<Value name="14">
<Value>COLRules</Value>
</Value>
</Data>
<Data name="XYActions">
<Attribute>XYActions</Attribute>
<Structure>subnode</Structure>
<Subscript>"XYActions"</Subscript>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","TablesD")</DataLocation>
<DefaultData>TablesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","TablesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","TablesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","TablesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
