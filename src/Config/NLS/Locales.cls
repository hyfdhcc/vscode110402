Include (%sySecurity, %syAudit, %syNLS, %syEMS, %ems)

/// This class is a description of a locale. A locale contains:<ul>
/// <li>Basic properties (language, country, character set, etc)</li>
/// <li>Available tables to be loaded at startup</li>
/// <li>Defaults for the various kinds of tables</li>
/// <li>Default time, date and number formats for $ZDATE
/// and $FNUMBER</li>
/// <li>Some localization strings</li></ul>
/// <br>Warning!<br><br>
/// Only locales whose names begin with "y" (e.g. "yda8" or "yptw")
/// are considered custom locales and are preserved during system
/// upgrades. All other locales are restored to their original
/// state and any changes to them made with methods from this class will
/// be lost in an upgrade.
Class Config.NLS.Locales Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index NameIndex On Name [ IdKey ];

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Sufix which may optionally be appended to time values
/// prior to 12 noon.<br><br>
/// Example: "AM"
Property AM As %String;

/// Name of character set on which this locale is based.<br><br>
/// Examples: "Latin1", "CP1251", "Unicode"
Property CharacterSet As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default collation table.
Property CollationTable As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// List of available collation tables.
Property CollationTables As list Of %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Country supported by this locale.
Property Country As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// ISO 3166 two-letter abbreviation of Country.<br><br>
/// Example: US
Property CountryAbbr As %String(MAXLEN = 2, MINLEN = 2) [ Required ];

/// Currency symbol (string) encoded in native character set.
Property Currency As %String(MINLEN = 1);

/// The DateFormat code used whenever a $ZDATE, $ZDATEH,
/// $ZDATETIME or $ZDATETIMEH function call omits its second
/// parameter, or specifies	a second parameter value of -1.<br><br>
/// Example: 1
Property DateFormat As %Integer;

/// The maximum value for a date allowed in $ZDATE, $ZDATEH,
/// $ZDATETIME or $ZDATETIMEH functions.<br><br>
/// Example: 94232  (12/30/2098)
Property DateMaximum As %Integer;

/// The minimum value for a date allowed in $ZDATE, $ZDATEH,
/// $ZDATETIME or $ZDATETIMEH functions.<br><br>
/// Example: 1
Property DateMinimum As %Integer;

/// The character used to delimit the months, days, and years
/// of those dates which are otherwise entirely numeric.<br><br>
/// Example: "/"
Property DateSeparator As %String(MAXLEN = 1, MINLEN = 1) [ Required ];

/// The character used by the $FNUMBER function to separate
/// the whole part of a number from the fractional part of
/// the number. Also used by $ZDATETIME, $ZDATETIMEH, $ZTIME
/// and $ZTIMEH to separate the whole part of the seconds from
/// the optional fractional part of the seconds, if any.<br><br>
/// Example: "."
Property DecimalSeparator As %String(MAXLEN = 1, MINLEN = 1) [ Required ];

/// Simple description of locale. Usually in one of these formats:<ul>
/// <li>&lt;country&gt;,&lt;language&gt;,&lt;character set&gt;</li>
/// <li>&lt;comment&gt;,&lt;character set&gt;</li></ul>
/// 
Property Description As %String(MAXLEN = 128);

/// The default identifier table.
Property IdentifierTable As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// List of available identifier tables.
Property IdentifierTables As list Of %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Localization language for this locale.
Property Language As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// ISO 639-2 two-letter abbreviation of Language
/// possibly followed by "-" and CountryAbbr.<br><br>
/// Examples: fr, en-US
Property LanguageAbbr As %String(MAXLEN = 5, MINLEN = 2) [ Required ];

/// The default lower-case table.
Property LowerCaseTable As %String(MAXLEN = 64, MINLEN = 1);

/// List of available lower-case tables.
Property LowerCaseTables As list Of %String(MAXLEN = 64, MINLEN = 1);

/// The suffix which may optionally be appended to time
/// values corresponding to exactly 12 midnight.<br><br>
/// Example: "MIDNIGHT"
Property Midnight As %String;

/// The character which may precede or follow a negative
/// numeric quantity formatted by the $FNUMBER function.<br><br>
/// Example: "-"
Property MinusSign As %String(MAXLEN = 1, MINLEN = 1) [ Required ];

/// The abbreviations of the names of the twelve months,
/// used whenever a $ZDATE, $ZDATEH, $ZDATETIME or $ZDATETIMEH
/// function call omits its MonthNameList parameter, or specifies
/// a MonthNameList parameter value of -1, and the selected date
/// format uses month name abbreviations (i.e., the effective
/// DateFormat code is 0, 2, 5, 6 or 7)<br><br>
/// Example: " Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
Property MonthAbbr As %String(MAXLEN = 100, MINLEN = 1) [ Required ];

/// The full names of the twelve months, used whenever a
/// $ZDATE, $ZDATEH, $ZDATETIME or $ZDATETIMEH function call
/// omits its MonthNameList parameter, or specifies a MonthNameList
/// parameter value of -1, and the selected date format uses full
/// month names (i.e., the effective DateFormat code is 9).<br><br>
/// Example: " January February March April... November December"
Property MonthName As %String(MAXLEN = 100, MINLEN = 1) [ Required ];

/// Code name of the locale. Generally this is a 3-letter code
/// expressing the language and country followed by a character
/// size indicator: "8" for 8-bit character sets and "w" for Unicode.
Property Name As %String(MAXLEN = 64) [ Required ];

/// The suffix which may optionally be appended to time values
/// corresponding to exactly 12 noon.<br><br>
/// Example: "NOON"
Property Noon As %String;

/// The character used to separate groups of numeric digits
/// within the whole number portion of a number formatted by
/// the $FNUMBER function.<br><br>
/// Example: ","
Property NumericGroupSeparator As %String(MAXLEN = 1, MINLEN = 1) [ Required ];

/// The number of digits in a numeric group formatted by the
/// $FNUMBER function.<br><br>
/// Example: 3
Property NumericGroupSize As %Integer;

/// The default pattern match table.
Property PatternTable As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// List of available pattern match tables.
Property PatternTables As list Of %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// True if terminals should have Physical Cursor set by default.<br>
/// Used by Japanese locales
Property PhysicalCursor As %Boolean;

/// The suffix which may optionally be appended to time values
/// at or after 12 noon.<br><br>
/// Example: "PM"
Property PM As %String;

/// The character which may optionally precede or follow a
/// non-negative numeric quantity formatted by the $FNUMBER
/// function.<br><br>
/// Example: "+"
Property PlusSign As %String(MAXLEN = 1, MINLEN = 1) [ Required ];

/// Deprecated. For compatibility with previous versions.
Property Resource As %Integer;

/// The TimeFormat code used whenever a $ZDATETIME, $ZDATETIMEH,
/// $ZTIME or $ZTIMEH function call omits its TimeFormat parameter,
/// or specifies a TimeFormat parameter value of -1.<br><br>
/// Example: 1
Property TimeFormat As %Integer;

/// The number of fractional digits displayed in a time value
/// whenever a $ZDATETIME or $ZTIME function call omits its
/// Precision parameter, or specifies a Precision parameter
/// value of -1.<br><br>
/// Example: 0
Property TimePrecision As %Integer;

/// The character used to delimit the hours, minutes and seconds
/// in a time value.<br><br>
/// Example: ":"
Property TimeSeparator As %String(MAXLEN = 1, MINLEN = 1) [ Required ];

/// The default title-case table.
Property TitleCaseTable As %String(MAXLEN = 64, MINLEN = 1);

/// List of available title-case tables.
Property TitleCaseTables As list Of %String(MAXLEN = 64, MINLEN = 1);

/// The default translation table for DDP.
Property TranDDP As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for DTM-DCP.
Property TranDTMDCP As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for magtapes.
Property TranMagTape As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for printers.
Property TranPrinter As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for TCP/IP connections.
Property TranTCP As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for the Cache Terminal.
Property TranProgrammer As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for files and other sequential devices.
Property TranSequential As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for OS system calls.
Property TranSystemCall As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for LAT and Telnet terminals.
Property TranTerminal As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default translation table for $ZCVT().
Property TranZCVT As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The default upper-case table.
Property UpperCaseTable As %String(MAXLEN = 64, MINLEN = 1);

/// List of available upper-case tables.
Property UpperCaseTables As list Of %String(MAXLEN = 64, MINLEN = 1);

/// The abbreviations of the names of the seven days of the
/// week, starting with Sunday and ending with Saturday, used
/// whenever a $ZDATE or $ZDATEIME function call selects a date
/// format which uses weekday name abbreviations (i.e., the
/// effective DateFormat code is 11).<br><br>
/// Example: " Sun Mon Tue Wed Thu Fri Sat"
Property WeekdayAbbr As %String(MAXLEN = 100, MINLEN = 1) [ Required ];

/// The full names of the seven days of the week, starting
/// with Sunday and ending with Saturday, used whenever a
/// $ZDATE or $ZDATEIME function call selects a date format
/// which uses full weekday names (i.e., the effective
/// DateFormat code is 12).<br><br>
/// Example: " Sunday Monday Tuesday... Friday Saturday"
Property WeekdayName As %String(MAXLEN = 100, MINLEN = 1) [ Required ];

/// ("table name")=$LB(InputFrom,InputTo,OutputFrom,OutputTo)<br>
/// Example: TranslationTables("LatinG")=$LB("LatinG","Unicode","Unicode","LatinG")
Property XLTTables As array Of %List;

/// The default $X/$Y table.
Property XYTable As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// List of available $X/$Y tables.
Property XYTables As list Of %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// The YearOption code used whenever a $ZDATE, $ZDATEH,
/// $ZDATETIME or $ZDATETIMEH function call omits its
/// YearOption parameter, or specifies a YearOption parameter
/// value of -1.<br><br>
/// Example: 0
Property YearOption As %Integer;

/// Compiles a single Locale<br><br>
/// Parameters:<ul>
/// <li>Name - Locale name</li></ul>
ClassMethod Compile(Name As %String) As %Status
{
}

/// Compiles all Tables from all Locales<br><br>
ClassMethod CompileAll() As %Status
{
}

/// Creates a Locale in the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Name - Name of the Locale to create</li>
/// <li>Properties - Array of properties corresponding to the class properties</li></ul>
ClassMethod Create(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Deletes a Locale from the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Name - Name of Locale to delete</li></ul>
ClassMethod Delete(Name As %String) As %Status
{
}

/// Checks for the existence of a Locale in the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Name - Name of the Locale to check existence of</li></ul>
/// Return values:<br><br>
/// If Value of the method = 0 (Locale does not exist, or some error occured)<ul>
/// <li>Locale = Null</li>
/// <li>Status = Locale "x" does not exist, or other error message</li></ul>
/// If Value of the method = 1 (Locale exists)<ul>
/// <li>Locale = Object handle to Locale</li>
/// <li>Status = $$$OK</li></ul>
ClassMethod Exists(Name As %String, ByRef Locale As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// Exports Locale Objects to a file in xml format.<br><br>
/// Parameters:<ul>
/// <li>FileName - Output file name</li>
/// <li>NumExported (byref) - Returns number of Locale records exported.</li>
/// <li>Locales - Comma separated list of Locales to export, "*" = All</li></ul>
ClassMethod Export(FileName As %String = "Locales.xml", ByRef NumExported As %Integer, Locales As %String = "*") As %Status
{
}

/// Exports all Locale records to ^%nls.<br><br>
/// Parameters:<ul>
/// <li>NumExported (byref) - Returns number of exported entities ("Locales","Table" and "SubTables") [out]</li>
/// <li>Deep - True if we also want to export associated Tables and SubTables</li></ul>
ClassMethod ExportAllToNls(ByRef NumExported As %Integer, Deep As %Integer = 0) As %Status
{
}

/// Exports Locale Objects to separate xml files.<br><br>
/// Parameters:<ul>
/// <li>Dir - Directory where the files will be created</li>
/// <li>NumExported (byref) - Returns number of Locale records exported.</li>
/// <li>Locales - Comma separated list of Locales to export, "*" = All</li></ul>
ClassMethod ExportDir(Dir As %String, ByRef NumExported As %Integer, Locales As %String = "*") As %Status
{
}

/// Similar to Export() but uses a list of Locales to export rather than a
/// query. Used internally by some utilities.<br><br>
/// Parameters:<ul>
/// <li>FileName - Output file name</li>
/// <li>NumExported (byref) - Returns number of exported entities ("Locales","Table" and "SubTables") [out]</li>
/// <li>Locales (byref) - Array of Locales to export</li></ul>
ClassMethod ExportList(FileName As %String = "LocalesExport.xml", ByRef NumExported As %Integer, ByRef Locales As %String) As %Status
{
}

/// Exports one Locale record to ^%nls.<br><br>
/// Parameters:<ul>
/// <li>Name - Locale name</li>
/// <li>Deep - If true exports all associated Tables.</li></ul>
ClassMethod ExportToNls(Name As %String, Deep As %Integer = 0) As %Status
{
}

/// Gets a locale's properties from the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Name - Name of the Locale to get</li></ul>
/// Return values:<ul>
/// <li>Properties - Array of properties. See the Create() method for a full list</li></ul>
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Gets a Locale's properties from the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Properties (byref) - Array that gets the locale's properties</li></ul>
Method GetProperties(ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Delete all custom custom locales and tables.<br>
/// This is used by the EMS to repopulate a client when the locale changes.
ClassMethod DeleteCustomTables() As %Status [ Internal ]
{
}

/// Get an array of all NLS instances which contain custom locale information and custom tables.<br>
/// This is used by EMS, since we don't want to send/receive all the NLS data.
/// 
/// The array is returned as NLSArray(ClassName, InstanceID)=$List(data).
/// ClassName is the short NLS classname, InstanceID may be a multi-part IdKey using the "||" delimiter. 
ClassMethod GetCustomTables(ByRef NLSArray As %String) As %Status [ Internal ]
{
}

/// Gets a Locale's properties from the ^%nls global.<br><br>
/// Parameters:<ul>
/// <li>Locale - Name of the Locale to get</li>
/// <li>Properties - Reference to array where properties will be stored</li>
/// <li>Ref - Source global reference</li></ul>
ClassMethod GetPropertiesFromNls(Locale As %String, ByRef Properties As %String, Ref As %String = "^%nls") As %Status [ Internal ]
{
}

/// Gets all tables defined in a locale and creates an array with
/// Table(<type>,<from>,<to>)
Method GetTables(ByRef Tables As %String)
{
}

/// Imports Locale records from an xml file.<br><br>
/// Parameters:<ul>
/// <li>FileName - Filename to import Locale records from</li>
/// <li>NumImported (byref) - Returns number of records imported</li>
/// <li>Flags - Control import<ul>
///   <li>Bit 0 - Do not import records, just return count</li></ul></ul>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "Locales.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Imports all NLS records from an xml file.<br><br>
/// Parameters:<ul>
/// <li>FileName - Filename to import NLS records from</li>
/// <li>NumImported (byref) - Returns number of records imported for each
///     type of NLS record:</li><ul>
///    <li>NumImported("Locales")</li>
///    <li>NumImported("Tables")</li>
///    <li>NumImported("SubTables")</li></ul>
/// <li>SelBits - Select which record types to import (can be added):</li><ul>
///     <li>1 - SubTables</li>
///     <li>2 - Tables</li>
///     <li>4 - Locales</li></ul></ul>
/// Note: On failure, no records will be imported<br>
ClassMethod ImportAll(FileName As %String = "LocalesExport.xml", ByRef NumImported As %String, SelBits As %Integer = -1) As %Status
{
}

/// Imports all Locale records from ^%nls.<br><br>
/// Parameters:<ul>
/// <li>NumImported (byref) - Returns number of records imported</li>
/// <li>Flags - Control import</li><ul>
///   <li>Bit 0 - Do not import records, just return count</li></ul>
/// <li>Deep - If true also import referenced Tables</li>
/// <li>Ref - Source global reference</li></ul>
ClassMethod ImportAllFromNls(ByRef NumImported As %Integer, Flags As %Integer = 0, Deep As %Integer = 0, Ref As %String = "^%nls") As %Status
{
}

/// Imports locale files from a directory.<br><br>
/// Parameters:<ul>
/// <li>Dir - Directory to import NLS files from</li>
/// <li>NumImported (byref) - Returns number of locales imported.</li></ul>
ClassMethod ImportDir(Dir As %String, ByRef NumImported As %String, forcemulticompile As %Boolean = "") As %Status
{
}

/// Imports one Locale record from ^%nls.<br><br>
/// Parameters:<ul>
/// <li>Name - Locale name</li>
/// <li>Ref - Source global reference</li></ul>
ClassMethod ImportFromNls(Name As %String, Ref As %String = "^%nls") As %Status
{
}

/// Imports all NLS records from a legacy goq file.<br><br>
/// Parameters:<ul>
/// <li>FileName - Filename to import NLS records from</li>
/// <li>NumImported (byref) - Returns number of records imported for each
///     type of NLS record:</li><ul>
///    <li>NumImported("Locales")</li>
///    <li>NumImported("Tables")</li>
///    <li>NumImported("SubTables")</li></ul>
/// <li>SelBits - Select which record types to import (can be added):</li><ul>
///     <li>1 - SubTables</li>
///     <li>2 - Tables</li>
///     <li>4 - Locales</li></ul>
/// <li>Warnings - Returned list of warnings</li></ul>
/// Note: System records are skipped<br>
ClassMethod ImportLegacy(FileName As %String, ByRef NumImported As %String, SelBits As %Integer = -1, ByRef Warnings As %String) As %Status
{
}

/// Sets the new "current locale" and loads its tables.
/// If the desired locale is not loadable, compiles it
/// it before the installation.<br><br>
/// Parameter:<ul>
/// <li>Locale - Locale name</li>
ClassMethod Install(Locale As %String) As %Status
{
}

/// Checks whether a locale can be installed in the current system<br><br>
/// Parameters:<ul>
/// <li>Name - Locale name</li>
/// <li>Errors - Returned list of errors</li></ul>
/// <li>Warnings - Returned list of warnings</li></ul>
/// Returns: True if the locale can be installed<br>
///        False otherwise
ClassMethod IsInstallable(Name As %String, ByRef Errors As %String, ByRef Warnings As %String) As %Boolean
{
}

/// Verifies whether a locale can be loaded<br><br>
/// Parameters:<ul>
/// <li>Name - Locale name</li>
/// <li>Locale - Returned locale reference</li>
/// <li>Errors - Returned list of errors</li></ul>
/// Returns: True if all its tables are loadable<br>
///        False otherwise
ClassMethod IsLoadable(Name As %String, ByRef Locale As %ObjectHandle, ByRef Errors As %String) As %Boolean
{
}

/// Verifies validity of locale<br><br>
/// Parameters:<ul>
/// <li>Name - Locale name</li>
/// <li>Errors - Returned list of errors</li></ul>
/// <li>Warnings - Returned list of warnings</li></ul>
/// Returns: True if the locale has a consistent definition<br>
///        False otherwise
ClassMethod IsValid(Name As %String, ByRef Errors As %String, ByRef Warnings As %String) As %Boolean
{
}

/// Loads all the tables from a Locale and sets the
/// defaults as approprate
ClassMethod Load(Locale As %String) As %Status
{
}

/// Loads all the collations available to a system.<br>
ClassMethod LoadAllCollations() As %Status
{
}

/// Modifies an existing Locale's properties in the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Name - Name of the Locale to modify</li>
/// <li>Properties - Array of properties to modify.</li>
/// If a specific property is not passed in the properties array, or is the same
/// as the existing value, the value is not modified.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Opens current Locale
ClassMethod OpenCurrent(ByRef Status As %Status = 1) As %ObjectHandle
{
}

/// Sets a Locale's properties from the NLS database.<br><br>
/// Parameters:<ul>
/// <li>Properties - See the Create method for more information on Properties</li></ul>
Method SetProperties(ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Sets a Locale's properties in ^%nls.<br><br>
/// Parameters:<ul>
/// <li>Locale - Name of the Locale to set in ^%nls</li>
/// <li>Properties - Array with locale properties</li></ul>
ClassMethod SetPropertiesToNls(Name As %String, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Compile and load the default locale
ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// Remove any configured table default not available in this locale
Method ValidateConfigDefaults() As %Status
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
Method %OnBeforeSave(Insert As %Boolean) As %Status [ Internal, Private ]
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

/// List all Locale records, brief display. <br>
/// Names - Comma separated list of Locale names, "*" = All<br>
/// Note: This query may change in future versions<br>
Query Detail(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Names As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
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

Query Tables(Locale As %String, Type As %String, BuiltIn As %Boolean = 0) As %Query(ROWSPEC = "Name:%String") [ Internal ]
{
}

ClassMethod TablesExecute(ByRef qHandle As %Binary, Locale As %String, Type As %String, BuiltIn As %Boolean = 0) As %Status [ Internal ]
{
}

ClassMethod TablesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod TablesClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = TablesExecute ]
{
}

Storage Default
{
<CounterLocation>^Config.NLS.LocalesC</CounterLocation>
<Data name="LocalesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CharacterSet</Value>
</Value>
<Value name="3">
<Value>CollationTable</Value>
</Value>
<Value name="4">
<Value>CollationTables</Value>
</Value>
<Value name="5">
<Value>Country</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>IdentifierTable</Value>
</Value>
<Value name="8">
<Value>IdentifierTables</Value>
</Value>
<Value name="9">
<Value>Language</Value>
</Value>
<Value name="10">
<Value>LowerCaseTable</Value>
</Value>
<Value name="11">
<Value>LowerCaseTables</Value>
</Value>
<Value name="12">
<Value>PatternTable</Value>
</Value>
<Value name="13">
<Value>PatternTables</Value>
</Value>
<Value name="14">
<Value>Region</Value>
</Value>
<Value name="15">
<Value>Resource</Value>
</Value>
<Value name="16">
<Value>TitleCaseTable</Value>
</Value>
<Value name="17">
<Value>TitleCaseTables</Value>
</Value>
<Value name="18">
<Value>TranDDP</Value>
</Value>
<Value name="19">
<Value>TranDTMDCP</Value>
</Value>
<Value name="20">
<Value>TranMagTape</Value>
</Value>
<Value name="21">
<Value>TranPrinter</Value>
</Value>
<Value name="22">
<Value>TranTCP</Value>
</Value>
<Value name="23">
<Value>TranProgrammer</Value>
</Value>
<Value name="24">
<Value>TranSequential</Value>
</Value>
<Value name="25">
<Value>TranSystemCall</Value>
</Value>
<Value name="26">
<Value>TranTerminal</Value>
</Value>
<Value name="27">
<Value>TranZCVT</Value>
</Value>
<Value name="28">
<Value>UpperCaseTable</Value>
</Value>
<Value name="29">
<Value>UpperCaseTables</Value>
</Value>
<Value name="30">
<Value>XYTable</Value>
</Value>
<Value name="31">
<Value>XYTables</Value>
</Value>
<Value name="32">
<Value>AM</Value>
</Value>
<Value name="33">
<Value>DateFormat</Value>
</Value>
<Value name="34">
<Value>DateMaximum</Value>
</Value>
<Value name="35">
<Value>DateMinimum</Value>
</Value>
<Value name="36">
<Value>DateSeparator</Value>
</Value>
<Value name="37">
<Value>DecimalSeparator</Value>
</Value>
<Value name="38">
<Value>Midnight</Value>
</Value>
<Value name="39">
<Value>MinusSign</Value>
</Value>
<Value name="40">
<Value>MonthAbbr</Value>
</Value>
<Value name="41">
<Value>MonthName</Value>
</Value>
<Value name="42">
<Value>Noon</Value>
</Value>
<Value name="43">
<Value>NumericGroupSeparator</Value>
</Value>
<Value name="44">
<Value>NumericGroupSize</Value>
</Value>
<Value name="45">
<Value>PM</Value>
</Value>
<Value name="46">
<Value>PlusSign</Value>
</Value>
<Value name="47">
<Value>TimeFormat</Value>
</Value>
<Value name="48">
<Value>TimePrecision</Value>
</Value>
<Value name="49">
<Value>TimeSeparator</Value>
</Value>
<Value name="50">
<Value>WeekdayAbbr</Value>
</Value>
<Value name="51">
<Value>WeekdayName</Value>
</Value>
<Value name="52">
<Value>YearOption</Value>
</Value>
<Value name="53">
<Value>Currency</Value>
</Value>
<Value name="54">
<Value>PhysicalCursor</Value>
</Value>
<Value name="55">
<Value>CountryAbbr</Value>
</Value>
<Value name="56">
<Value>LanguageAbbr</Value>
</Value>
</Data>
<Data name="XLTTables">
<Attribute>XLTTables</Attribute>
<Structure>subnode</Structure>
<Subscript>"XLTTables"</Subscript>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","LocalesD")</DataLocation>
<DefaultData>LocalesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","LocalesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","LocalesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("NLS","LocalesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
