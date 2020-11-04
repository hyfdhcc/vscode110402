Include (%sySecurity, %syNLS)

/// The objects of this class contain the data points for
/// tables of type XLT, COL, Case and the input side of
/// Mode tables.
/// <br>The name of a sub-table is a string with three pieces
/// separated by "-": type-from-to
/// <br><br>Warning!<br><br>
/// Only sub-tables whose names have a "from" or "to" piece beginning
/// with "y" (e.g. "XLT-yEBCDIC-Unicode" or "XLT-Latin1-yPrinter") or
/// that end with a dot followed by 4 digits (e.g. "XLT-CP1250-Unicode.0001")
/// are considered custom sub-tables and are preserved during system
/// upgrades. All other sub-tables are restored to their original
/// state and any changes to them made with methods from this class will
/// be lost in an upgrade.
Class Config.NLS.SubTables Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index NameIndex On Name [ IdKey ];

/// Description of the SubTable.<br>
Property Description As %String(MAXLEN = 128);

/// Each node of this array contains one mapping. Both the index
/// and the value of the node can be either a single character
/// code (e.g. "168") or a comma-separated list of codes (e.g.
/// "251,128,65"). For collation tables, the value can contain
/// a disambiguator (e.g. "65,65;1").
Property FromTo As array Of %String;

/// The name of a sub-table contains 3 parts separated by "-":
/// type, source encoding and target encoding.<br><br>
/// Examples: "XLT-Latin2-Unicode", "COL-Latin1-German2"
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Type of sub-table.<ul>
/// <li>0 - SUBSingle</li>
/// <li>1 - SUBToMulti</li>
/// <li>2 - SUBFromMulti</li>
/// <li>3 - SUBMulti</li>
/// <li>4 - SUBLeadByte</li>
/// <li>5 - SUBToCol</li>
/// <li>6 - SUBFromCol</li></ul>
Property Type As %Integer(MAXVAL = 6, MINVAL = 0) [ Required ];

/// Creates a SubTable the NLS database.<br><br>
/// Parameters:<ul>
///   <li<Name - Name of the SubTable to create</li>
///   <li>Properties - Array of properties corresponding to the class properties</li></ul>
ClassMethod Create(Name, ByRef Properties As %String) As %Status
{
}

/// Deletes a SubTable.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of SubTable to delete</li></ul>
ClassMethod Delete(Name As %String) As %Status
{
}

/// Checks for the existence of a SubTable in the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of the SubTable to check existence of</li></ul>
/// Return values:<br>
/// If Value of the method = 0 (SubTable does not exist, or some error occured)<ul>
///   <li>SubTable = Null</li>
///   <li>Status = SubTable "x" does not exist, or other error message</li></ul>
/// If Value of the method = 1 (SubTable exists)<ul>
///   <li>SubTable = Object handle to SubTable</li>
///   <li>Status = $$$OK</li></ul>
ClassMethod Exists(Name As %String, ByRef SubTable As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// Exports SubTable Objects to a file in xml format.<br><br>
/// Parameters:<ul>
///   <li>FileName - Output file name</li>
///   <li>NumExported (byref) - Returns number of SubTable records exported.</li>
///   <li>SubTables - Comma separated list of SubTables to export, "*" = All</li></ul>
ClassMethod Export(FileName As %String = "SubTablesExport.xml", ByRef NumExported As %Integer, SubTables As %String = "*") As %Status
{
}

/// Exports SubTable Objects to separate xml files.<br><br>
/// Parameters:<br>
///   <li>Dir - Directory where the files will be created</li>
///   <li>NumExported (byref) - Returns number of SubTable records exported.</li>
///   <li>SubTables - Comma separated list of SubTables to export, "*" = All</li></ul>
ClassMethod ExportDir(Dir As %String, ByRef NumExported As %Integer, SubTables As %String = "*") As %Status
{
}

/// Similar to Export() but uses a list of SubTables to export rather than a
/// query. Used internally by Tables.ExportList() and other utilities.<br><br>
/// Parameters:<ul>
///   <li>FileName - Output file name</li>
///   <li>NumExported - Number of exported SubTables [out]</li>
///   <li>SubTables - Array of SubTables to export</li></ul>
ClassMethod ExportList(FileName As %String = "SubTablesExport.xml", ByRef NumExported As %Integer, ByRef SubTables As %String) As %Status
{
}

/// Exports ONE SubTable record to ^%nls.<br><br>
/// Parameters:<ul>
///   <li>Name - SubTable name</li></ul>
ClassMethod ExportToNls(sub As %String) As %Status
{
}

/// Exports all SubTable records to ^%nls.<br><br>
/// Parameters:<ul>
///   <li>NumExported - Number of exported records</li></ul>
ClassMethod ExportAllToNls(ByRef NumExported As %Integer) As %Status
{
}

/// Gets a SubTable's properties from the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of the SubTable to get</li>
///   <li>Properties - Array of properties. See the Create() method for a full list</li></ul>
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Gets a SubTable's properties from the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Properties - See the Create method for more information on properties returned</li></ul>
Method GetProperties(ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Gets a SubTable's properties from the ^%nls global.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of the SubTable to get</li>
///   <li>Properties - See the Create method for more information on properties returned</li>
///   <li>Ref - Source global reference</li></ul>
ClassMethod GetPropertiesFromNls(SubTable As %String, ByRef Properties As %String, Ref As %String = "^%nls") As %Status [ Internal ]
{
}

/// Imports SubTable records from an xml file.<br><br>
/// Parameters:<ul>
///   <li>FileName - Filename to import SubTable records from</li>
///   <li>NumImported (byref) - Returns number of records imported</li>
///   <li>Flags - Control import</li><ul>
///      <li>Bit 0 - Do not import records, just return count</li></ul></ul
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "SubTablesExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Imports SubTable record from ^%nls.<br><br>
/// Parameters:<ul>
///   <li>Name - SubTable name</li>
///   <li>Ref - Source global reference</li></ul>
ClassMethod ImportFromNls(Sub As %String, Ref As %String = "^%nls") As %Status
{
}

/// Imports all SubTable records from ^%nls.<br><br>
/// Parameters:<ul>
///   <li>NumImported (byref) - Returns number of records imported</li>
///   <li>Flags - Control import</li><ul>
///     <li>Bit 0 - Do not import records, just return count</li></ul>
///   <li>Ref - Source global reference</li></ul>
ClassMethod ImportAllFromNls(ByRef NumImported As %Integer, Flags As %Integer = 0, Ref As %String = "^%nls") As %Status
{
}

/// Imports subtable files from a directory.<br><br>
/// Parameters:<ul>
///   <li>Dir - Directory to import NLS files from</li>
///   <li>NumImported (byref) - Returns number of subtables imported.</li></ul>
ClassMethod ImportDir(Dir As %String, ByRef NumImported As %String, forcemulticompile As %Boolean = "") As %Status
{
}

/// Modifies an existing SubTable's properties in the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of the SubTable to modify</li>
///   <li>Properties - Array of properties to modify.</li>
/// If a specific property is not passed in the properties array, or is the same
/// as the existing value, the value is not modified.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Returns the number of Tables that reference this SubTable.<br><br>
/// Parameters:<ul>
///   <li>Name - The name of the SubTable</li></ul>
ClassMethod NumberOfRefs(Name As %String) As %Integer [ Internal ]
{
}

/// Sets a SubTable's properties from the NLS database.<br><br>
/// Parameters:<ul>
///   <li>Properties - See the Create method for more information on properties returned</li></ul>
Method SetProperties(ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Sets a SubTable's properties to the ^%nls global.<br><br>
/// Parameters:<ul>
///   <li>Name - Name of the SubTable to get</li>
///   <li>Properties - See the Create method for more information on properties returned</li></ul>
ClassMethod SetPropertiesToNls(SubTable As %String, ByRef Properties As %String) As %Status [ Internal ]
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

Query List(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<CounterLocation>^Config.NLS.SubTablesC</CounterLocation>
<Data name="FromTo">
<Attribute>FromTo</Attribute>
<Structure>subnode</Structure>
<Subscript>"FromTo"</Subscript>
</Data>
<Data name="SubTablesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>Subtype</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","SubTablesD")</DataLocation>
<DefaultData>SubTablesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","SubTablesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","SubTablesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","SubTablesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
