/// Common data used by both SQL import and export classes.
/// <p>
/// Example of using the import/export classes: 
/// <br><br>
/// 	If Wizard = "Export" set mgr = ##class(%SQL.Export.Mgr).%New()<br>
/// 	    Else  Set mgr = ##class(%SQL.Import.Mgr).%New()<br>
/// 	    Set mobj = ##class(%SQL.Manager.API).%New()<br>
/// 	    Set ok = mobj.CheckIdentifier(.SchemaName)<br>
/// 	    Set ok = mobj.CheckIdentifier(.TableName)<br>
/// 	    Set classname = mobj.FindClassName(SchemaName_"."_TableName)<br>
/// 	    Set mgr.FileName = "c:\export.txt"<br>
/// 	    Set mgr.TableName = SchemaName_"."_TableName<br>
/// 	    Set mgr.ClassName = classname<br>
/// 	    Set mgr.Delimiter = $c(9)			<-- tab<br>
/// 	    Set mgr.StringQuote = ""                    <-- double quotes<br>
/// 	    Set mgr.DateFormat = 1			<-- MM/DD/{YY}YY<br>
/// 	    Set mgr.TimeFormat = 1			<-- hh:mm:ss<br>
/// 	    Set mgr.TimeStampFormat = 1			<-- ODBC format (Import only)<br>
/// 	    Set mgr.NoCheck = 1				<-- disable validation (Import only)<br>
/// 	    Set mgr.HasHeaders = 1			<-- import file contains column headers<br>
/// 	    Do mgr.ColumnNames.Insert(colname)		<-- insert a column name<br>
/// 	    Do mgr.ColumnTypes.Insert(datatype)		<-- insert a column datatype<br>
/// <br><br>
/// 	For Export:<br>
/// 		Set result = mgr.GenerateExportRoutine()<br>
/// 		If result '= 1 Write !,"Error generating export routine: ",result Quit<br>
/// 		Set sta = mgr.OpenExport()<br>
/// 		If $$$ISERR(sta) {<br>
/// 			Set ErrMsg = "Unable to open export file"<br>
/// 			[...LogYourError here ]<br>
/// 		} Else {<br>
/// 		Set sta = mgr.GetExportSize(.size)<br>
/// 		If size = 0 {<br>
/// 			[...LogYourError here "No data to export"]<br>
/// 		} Else {<br>
/// 			Set tSC = $$$OK<br>
/// 			Do {<br>
/// 				Set tSC = mgr.ExportRows(.rows,.done)<br>
/// 				Set total = total + rows<br>
/// 				If $$$ISERR(tSC) [Do ..LogYourError here] Quit<br>
/// 			} While done = 0<br>
/// 			If $$$ISOK(tSC) {<br>
/// 				Set tmsg = "Completed at "_$zdt($h)<br>
/// 			} Else {<br>
/// 				Set tmsg ="Error occurred during export."<br>
/// 			}<br>
/// 			Set statusmsg = "Exported: "_total_" rows"<br>
/// 			Write !,tmsg,!,statusmsg<br>
/// 		}
/// 		Do mgr.CloseExport()<br>
/// 		}<br>
/// 		Do mgr.DeleteExportRoutine()<br>
/// <br><br>
/// For Import:<br>
/// 	 	Set mgr.DeferIndices = 1<br>
/// 	 	Set result = mgr.GenerateImportRoutine()<br>
/// 		If result '= 1 Write !,"Error generating import routine: ",result Quit<br>
/// 		Set sta = mgr.OpenImport()<br>
/// 		If $$$ISERR(sta) {<br>
/// 			Set ErrMsg = "Unable to open import file"<br>
/// 			[...LogYourError here ]<br>
/// 		} Else {<br>
/// 		If mgr.HasHeaders = 1 Set sta = mgr.ReadHeader(.header,.size)<br>
/// 		Set tSC = $$$OK<br>
/// 	 	Do {<br>
/// 		 	Set tSC = mgr.ImportRows(.rows,.inserted,.bytes,.done,.numerr,total)<br>
/// 		 	Set total = total + rows<br>
/// 		 	Set totalinserted = totalinserted + inserted<br>
/// 		 	Set totalbytes = totalbytes + bytes<br>
/// 		 	If $$$ISERR(tSC) [...LogYourError here ] Quit<br>
/// 	 	} While done = 0<br>
/// 	 	Do mgr.BuildIndices()<br>
/// 	 	If mgr.ErrorCount() > 0 {<br>
/// 		 	[...LogYourError here ]<br>
/// 		 	[number of error count is mgr.ErrorCount()<br>
/// 	 	} Else {<br>
/// 			If $$$ISOK(tSC) {<br>
/// 				Set tmsg = "Completed at "_$zdt($h)<br>
/// 			} Else {<br>
/// 				Set tmsg ="Error occurred during import."<br>
/// 			}<br>
/// 			Set statusmsg = "Imported: "_totalinserted_" rows"<br>
/// 			Write !,tmsg,!,statusmsg<br>
/// 		}<br>
/// 		Do mgr.CloseImport(0)<br>
/// 		}<br>
/// 		Do mgr.DeleteImportRoutine()<br>
/// 	}<br>
/// </p>
Class %SQL.ExImData [ Abstract, Not ProcedureBlock, System = 3 ]
{

/// File (on server) to use for import or export."
Property FileName As %String(TRUNCATE = 1);

/// Character Set to use for import or export. "" is Device Default.
Property Charset As %String;

/// Class to use for import/export.
Property ClassName As %String(TRUNCATE = 1);

/// Table to use for import/export.
Property TableName As %String(TRUNCATE = 1);

/// Name of generated routine.
Property RoutineName As %String(TRUNCATE = 1) [ Private ];

/// If true, file has column headers in first row.
Property HasHeaders As %Integer [ InitialExpression = 0 ];

/// Delimiter character or NULL for fixed width fields.
Property Delimiter As %String(TRUNCATE = 1);

/// Format for dates (passed to $ZDT).
Property DateFormat As %Integer;

/// Format for time (passed to $ZTime).
Property TimeFormat As %Integer;

/// Format for datetime values (ODBC or T-SQL).
Property TimeStampFormat As %Integer;

/// Character used to quote strings or NULL for no quoting.
Property StringQuote As %String(TRUNCATE = 1);

/// User defined record terminators (upto 8 charectors).
Property Terminator As %String(TRUNCATE = 1);

/// If true, import will insert with %NOCHECK.
Property NoCheck As %Integer [ InitialExpression = 0 ];

/// Names (SQL field names) of columns.
Property ColumnNames As list Of %String(TRUNCATE = 1);

/// Data types of columns.
/// <p><ul>
/// <li>D  - Date</li>
/// <li>TS - TimeStamp</li>
/// <li>N  - Numeric</li>
/// <li>S  - String</li>
/// <li>T  - Time</li>
/// </ul>
Property ColumnTypes As list Of %String(TRUNCATE = 1);

/// Widths of columns for FixedWidth files.
Property ColumnWidths As list Of %Integer;

/// Reset the export/import data.
Method ResetExImData()
{
 Set ..FileName=""
 Set ..TableName=""
 Set ..Delimiter=""
 Set ..StringQuote=""
 Set ..DateFormat=""
 Set ..TimeStampFormat=""
 Set ..HasHeaders=0
 Set ..NoCheck=0
 Set ..Terminator=""
 Set ..Charset = ""
 
 Do ..ColumnNames.Clear()
 Do ..ColumnWidths.Clear()
 Do ..ColumnTypes.Clear()

 Quit
}

}
