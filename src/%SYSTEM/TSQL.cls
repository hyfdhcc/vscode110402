/// The <class>%SYSTEM.TSQL</class> class provides an interface for managing
/// Cach&eacute; TSQL configurations.<br>
/// <p>You can use it via the special <b>$SYSTEM</b> object:<br>
/// <example>
/// Do $SYSTEM.TSQL.SetAnsiNulls("sybase","on")
/// </example>
/// <p>You can call help to get a list of all entry points:<br>
/// <p>
/// Do $SYSTEM.TSQL.Help()
Class %SYSTEM.TSQL Extends Help [ Abstract, Not ProcedureBlock, System = 4 ]
{

/// This method will return the current setting that are defined for InterSystems TSQL compatibility features.
ClassMethod CurrentSettings()
{
	w !,"Current Dialect:    ", $g(^%SYS("tsql","DIALECT"),"Caché SQL")
	w !,"ANSI_NULLS:         ", $g(^%SYS("tsql","SET","ANSI_NULLS"),"OFF")
	w !,"CaseInsCompare:     ", $g(^%SYS("tsql","SET","CASEINSCOMPARE"),"OFF")
	w !,"Quoted_Identifier:  ", $g(^%SYS("tsql","SET","QUOTED_IDENTIFIER"),"OFF")
}

/// This method returns the current default TSQL Dialect for the System.  The two options are Sybase and MSSQL
ClassMethod GetDialect() As %String
{
	QUIT $G(^%SYS("tsql","DIALECT"))
}

/// This method sets the default TSQL Dialect for the System.
/// <br><br>
/// <b>Parameter:</b>
/// <dl>
/// <dt><i>Dialect</i>
/// <dd>Name of the TSQL dialect:  Sybase or MSSQL.  The Default is Caché SQL
/// 
/// </dl>
/// <br><b>Returns:</b>  The previous default TSQL Dialect value or an invalid error message
ClassMethod SetDialect(Dialect) As %String
{
	Set Dialect=$ZCONVERT(Dialect,"U")
	if ",SYBASE,MSSQL," '[ (","_Dialect_",") QUIT "Invalid dialect, please enter Sybase or MSSQL"
	Set current=$G(^%SYS("tsql","DIALECT"))
	Set ^%SYS("tsql","DIALECT") = Dialect
	QUIT current
}

/// This method returns the current default TSQL dialect and the value for TSQL Ansi Null behavior.
/// 
/// valid values aare ON or OFF 
ClassMethod GetAnsiNulls() As %String
{
	QUIT $G(^%SYS("tsql","DIALECT"))_", "_$G(^%SYS("tsql","SET","ANSI_NULLS"),"OFF")
}

/// This method sets the current default TSQL dialect and the value for TSQL Ansi Null behavior.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>Dialect</i>
/// <dd>Name of the TSQL dialect:  Sybase or MSSQL
/// <dt><i>flag</i>
/// <dd>Value for TSQL Ansi NULL behavior: ON or OFF
/// </dl>
/// <br><b>Returns:</b>  The previous default TSQL dialect value and Ansi Null behavior
ClassMethod SetAnsiNulls(Dialect, flag) As %String
{
	Set Dialect=$ZCONVERT(Dialect,"U")
	if ",SYBASE,MSSQL," '[ (","_Dialect_",") QUIT "Invalid dialect, please enter Sybase or MSSQL"
	Set flag=$ZCONVERT(flag,"U")
	if ",ON,OFF," '[ ","_Dialect_"," QUIT "Invalid flag, please enter ON or OFF"
	Set current=$G(^%SYS("tsql","DIALECT"))_", "_$G(^%SYS("tsql","SET","ANSI_NULLS"),"OFF")
	Set ^%SYS("tsql","DIALECT") = Dialect
	Set ^%SYS("tsql","SET","ANSI_NULLS") = flag
	QUIT current
}

/// This method returns the current default TSQL dialect and the value for TSQL non-case-sensitive equality comparison behavior.
/// 
/// valid values aare ON or OFF
ClassMethod GetCaseInsCompare() As %String
{
	QUIT $G(^%SYS("tsql","DIALECT"))_", "_$G(^%SYS("tsql","SET","CASEINSCOMPARE"),"OFF")
}

/// This method sets the current default TSQL dialect and the value for TSQL non-case-sensitive equality comparison behavior.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>Dialect</i>
/// <dd>Name of the TSQL dialect:  Sybase or MSSQL
/// <dt><i>flag</i>
/// <dd>Value for TSQL non-case-sensitive equality comparison behavior: ON or OFF
/// </dl>
/// <br><b>Returns:</b>  The previous default TSQL dialect value and TSQL non-case-sensitive equality comparison behavior.
ClassMethod SetCaseInsCompare(Dialect, flag) As %String
{
	Set Dialect=$ZCONVERT(Dialect,"U")
	if ",SYBASE,MSSQL," '[ (","_Dialect_",") QUIT "Invalid dialect, please enter Sybase or MSSQL"
	Set flag=$ZCONVERT(flag,"U")
	if ",ON,OFF," '[ ","_Dialect_"," QUIT "Invalid flag, please enter ON or OFF"
	Set current=$G(^%SYS("tsql","DIALECT"))_", "_$G(^%SYS("tsql","SET","CASEINSCOMPARE"),"OFF")
	Set ^%SYS("tsql","DIALECT") = Dialect
	Set ^%SYS("tsql","SET","CASEINSCOMPARE") = flag
	QUIT current
}

/// This method returns the current default TSQL dialect and the value for TSQL Quoted Identifier behavior.
/// 
/// valid values aare ON or OFF
ClassMethod GetQuotedIdentifier() As %String
{
	QUIT $G(^%SYS("tsql","DIALECT"))_", "_$G(^%SYS("tsql","SET","QUOTED_IDENTIFIER"),"OFF")
}

/// This method sets the current default TSQL dialect and the value for TSQL Quoted Identifier behavior.
/// <br><br>
/// <b>Parameters:</b>
/// <dl>
/// <dt><i>Dialect</i>
/// <dd>Name of the TSQL dialect:  Sybase or MSSQL
/// <dt><i>flag</i>
/// <dd>Value for TSQL Quoted Identifier behavior: ON or OFF
/// </dl>
/// <br><b>Returns:</b>  The previous default TSQL dialect value and TSQL Quoted Identifier behavior.
ClassMethod SetQuotedIdentifier(Dialect, flag) As %String
{
	Set Dialect=$ZCONVERT(Dialect,"U")
	if ",SYBASE,MSSQL," '[ (","_Dialect_",") QUIT "Invalid dialect, please enter Sybase or MSSQL"
	Set flag=$ZCONVERT(flag,"U")
	if ",ON,OFF," '[ ","_Dialect_"," QUIT "Invalid flag, please enter ON or OFF"
	Set current=$G(^%SYS("tsql","DIALECT"))_", "_$G(^%SYS("tsql","SET","QUOTED_IDENTIFIER"),"OFF")
	Set ^%SYS("tsql","DIALECT") = Dialect
	Set ^%SYS("tsql","SET","QUOTED_IDENTIFIER") = flag
	QUIT current
}

}
