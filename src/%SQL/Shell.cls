Include (%occDS, %msql)

/// %SQL.Shell - Interactive SQL shell
///  
/// <p>The interactive SQL shell allows the user to execute SQL statements dynamically. There are two execution modes - immediate and
/// deferred. The execution mode can be set by executing a <var>set executemode</var> command with <var>immediate</var> or <var>deferred</var>
/// as the executemode value. If the execution mode is immediate then SQL statements are prepared and executed immediately. If execute
/// mode is deferred then a statement is only prepared and not executed until either a <var>#</var> or <var>go</var> command is entered.
/// The result of executing the statement is displayed on the current device after the statement is executed.</p>
/// <p>If <var>displaymode</var> is <var>currentdevice</var> and <var>messages</var> is <var>on</var> then the time taken to prepare the current
/// statement and the time taken to execute the current statement are displayed after the result is displayed. Execute time includes the time
/// to instantiate the result object and the time to display the statement.</p>
/// <p>SQL statements can span multiple lines. To enter a multiline statement, simply press the enter key to enter multiline mode. When
/// the statement is complete enter <var>go</var> to exit multiline mode. If execution mode is immediate the multiline statement will be
/// executed at that point, otherwise and additional <var>#</var> or <var>go</var> will cause the statement to execute.</p>
/// <p>The user is prompted to supply a value for each parameter defined in the statement each time the statement is executed. If the value entered begins
/// with a colon then the user is prompted to enter if the value is a literal or not. If the value is a literal the user must answer with <var>Y</var> or <var>y</var>.
/// The default is <var>N</var> and if that is the desired response simply press <var>Enter</var> and the value entered is assumed to be a COS expression or
/// host variable. Host variables are assumed to be public variables. Public variables can be set using the <var>cos set var = value</var> command. Other
/// expressions can be entered, including function calls and class methods that return a value. The statement can be executed again by entering 'go'
/// resulting in prompts for new statement values. The expression used to execute the statement is
/// displayed just prior to executing the statement. If the statement does not contain any parameters then execution will proceed without any prompting.</p>
/// 
/// <p>The Shell supports statement recall. Any statement that is prepared may be recalled from the statement buffer by entering <b>#</b><var>nbr</nbr>
/// where <var>nbr</var> is the statement number in the buffer. Just entering <b>#</b> will list the statements currently in the buffer. Entering <b>#clear</b>
/// will clear the statement buffer on confirmation. Entering <b>#0</b> will recall the most recently prepared statement from the buffer. If <var>executemode</var>
/// is set to <var>immediate</var> then the recalled statement will also be executed.</p>
/// <p>Statements can also be saved in a statement pool. To save the current statement enter <b>save</b> <var>name</var>. That statement is saved in the pool
/// and can be later recalled by entering <b>open</b> <var>name</var>.<p>
/// <p>Statements can be deleted from the statement pool by entering <b>clear</b> <var>name</var>. If no <var>name</var> is specified then all statements are removed
/// from the pool on confirmation.</p>
/// <p>
/// Shell commands are entered in the first column and do not often conflict with executable statements. In some cases, such as <var>set</var>, a command and an SQL statement
/// can be ambiguous. This occurs most often in complex statements such as <var>CREATE PROCEDURE</var>. To eliminate confusion, the SQL Shell supports a command prefix
/// that can be set to any value. The command prefix allows the user to specify that all commands begin with a special character or character sequence. To set the command prefix
/// simply set <b>commandprefix</b> option using the <b>set</b> command:<br>
/// <pre>
/// 		USER>>set commandprefix = .
/// </pre>
/// <br>
/// Once the command prefix is set, all commands must be prefixed by the value of the commandprefix setting. There are three exceptions - <b>?</b>, <b>#</b> and <b>GO</b> do
/// not have to be prefixed.</p>
/// <p>
/// The <b>commandprefix</b> option is saved by the <b>set save</b> command and, if saved, will be restored automatically the next time the user starts the shell. By default there is no
/// <b>commandprefix</b>. To reset the command prefix back to the default once it has been set to something else, enter:<br>
/// <pre>
/// 		USER>>set commandprefix = ""
/// </pre>
/// </p>
/// <p>Shell context settings are set by the <b>set</b> command. Context settings can be retained and used by future instances of the shell by entering <b>set save</b> and
/// cleared by entering <b>set clear</b>. Entering <b>set</b> without any additional qualifiers will display the current shell context settings.</p>
/// 	<p>To execute an SQL statement, type it in and press ENTER.</p>
/// 	<p>To execute a multiline SQL statement, press ENTER to enter multiline mode, type in the statement, and enter <var>go</var>.</p>
/// 	<p>Available commands:</p>
/// <p><table cols=2 border=1>
/// 		<tr>
/// 				<td width="20%" valign="top">Press ENTER</td>
/// 				<td width="50%" valign="top">Enter multiline statement mode. While in multiline
/// 							statement mode, some basic commands are supported.
/// 							<p>
/// 								<table cols=2 border=1>
/// 									<tr><td width="20%" valign="top">c[lear]</td><td width="50%" valign="top">
/// 											Clear all statement lines entered.
/// 										</td>
/// 									</tr>
/// 									<tr><td width="20%" valign="top">c[lear] <var>line nbr</var></td><td width="50%" valign="top">
/// 											Clear line <var>line nbr</var>.
/// 										</td>
/// 									</tr>
/// 									<tr><td width="20%" valign="top">g[o]</td><td width="50%" valign="top">
/// 											Exit multiline statement mode. If <var>EXECUTEMODE</var>
/// 										is immediate then execute the statement. The result is displayed
/// 											after execution.
/// 										</td>
/// 									</tr>
/// 									<tr><td width="20%" valign="top">l[ist]</var></td><td width="50%" valign="top">
/// 											List the statement lines entered.
/// 										</td>
/// 									</tr>
/// 									<tr><td width="20%" valign="top">q[uit]</td><td width="50%" valign="top">
/// 											Exit multiline statement mode and discard any statement lines.
/// 										</td>
/// 									</tr>
/// 	 								<tr>
/// 	 									<td width="20%" valign="top">
/// 	 										<table cols=1 border=0>
/// 	 										<tr>
/// 	 											<td>?</td>
/// 	 											</tr>
/// 	 										<tr>
/// 	 											<td>help</td>
/// 	 											</tr>
/// 	 										</table>
/// 	 									</td>
/// 	 									<td width="50%" valign="top">
///  											Display statement mode help.
/// 							 			</td>
/// 									</tr>
/// 								</table>
/// 							</p>
/// 					</td>
/// 				</tr>
/// 	<tr><td width="20%" valign="top"><var>SQL Statement</var></td><td width="50%" valign="top">Prepare the statement. If <var>EXECUTEMODE</var>
/// is immediate then execute the statement. The result is displayed after execution.</td></tr>
/// 		<tr>
/// 			<td width="20%" valign="top">
/// 				<table cols=1 border=0>
/// 				<tr>
/// 					<td><b>?</b></td>
/// 					</tr>
/// 				<tr>
/// 					<td><b>help</b></td>
/// 					</tr>
/// 				</table>
/// 			</td>
/// 			<td width="50%" valign="top">
/// 				Display help.
/// 			</td>
/// 		</tr>
/// 	<tr><td width="20%" valign="top"><b>#</b></td><td width="50%" valign="top">List statements currently in the history buffer.</td></tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>#</b><var>nbr</var></td>
/// 			<td width="50%" valign="top">
/// 				Recall statement <var>nbr</var> from the statement history buffer. If <var>nbr</var> is zero then recall the most recent statement.
/// 				Recalled statements are executed if <var>EXECUTEMODE</var> is set to 'immediate'.
/// 				If <var>EXECUTEMODE</var> is set to 'deferred' then it is necessary to enter <var>GO</var> to execute the recalled statement.
/// 			</td>
/// 		</tr>
/// 	<tr><td width="20%" valign="top"><b>#?</b></td><td width="50%" valign="top">List statements currently in the history buffer.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>#clear</b></td><td width="50%" valign="top">Clear the statement history buffer.</td></tr>
/// 		<tr>
/// 			<td width="20%" valign="top">
/// 				<b>c[lear]</b> <var>name</var>
/// 			</td>
/// 			<td width="50%" valign="top">
/// 				Clear (delete) the statement identified by <var>name</var> from the statement pool.
/// 			</td>
/// 		</tr>
/// 	<tr><td width="20%" valign="top"><b>cos</b> <var>cos_command</var></td><td width="50%" valign="top">Execute <var>cos_command</var>.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>g[o]</b></td><td width="50%" valign="top">Run the most recently executed or loaded statement.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>l[ist]</b></td><td width="50%" valign="top">List statements in the statement pool.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>load</b> <var>filename</var></td><td width="50%" valign="top">Load a statement from <var>filename</var>.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>m[etadata]</b></td><td width="50%" valign="top">Displays the metadata for the current statement.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>o[pen]</b> <var>name</var></td><td width="50%" valign="top">Open the statement name <var>name</var> from the statement pool. The retrieved statement
/// 		is prepared and executed (depending on the EXECUTEMODE setting).</td></tr>
/// 		<tr>
/// 			<td width="20%" valign="top">
/// 				<table cols=1 border=0>
/// 				<tr>
/// 					<td><b>q[uit]</b></td>
/// 					</tr>
/// 				<tr>
/// 					<td><b>e[xit]</b></td>
/// 					</tr>
/// 				</table>
/// 			</td>
/// 			<td width="50%" valign="top">
/// 				Exit the shell.
/// 			</td>
/// 		</tr>
/// 	<tr><td width="20%" valign="top"><b>run</b> [<var>filename</var>]</td><td width="50%" valign="top">Run an SQL script. If <filename> is not specified then the user will be prompted for the file name.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>saveglobal</b>|<b>sg</b> <var>name</var></td><td width="50%" valign="top">Save the currently prepared statement in the statement global using the given <var>name</var>.</td></tr>
/// 	<tr><td width="20%" valign="top"><b>s[ave]</b> <var>filename</var></td><td width="50%" valign="top">Save the currently prepared statement to <var>filename</var>.</td></tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>set</b></td>
/// 				<td width="50%" valign="top">
/// 					Display the current context settings.</td>
/// 			</tr>
/// 		<tr>
/// 				<td width="20%" valign="top"><b>set clear</b></td>
/// 				<td width="50%" valign="top">
/// 					Clear the saved Shell settings for this user.
/// 				</td>
/// 			</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>set commandprefix</b> [=] <var>string value</var></td>
/// 				<td width="50%" valign="top">
/// 					Sets the command prefix to <var>string value</var>. To set the command prefix to nothing, enter <var>""</var> as the string value.
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>set dialect</b> [=] <var>sybase | mssql | cache</var></td>
/// 				<td width="50%" valign="top">
/// 					Sets the dialect to the desired SQL dialect. If <var>schemalist</var> is empty then Cache SQL is assumed.
/// 					The dialect setting determines which dialect mode is used when preparing a statement.
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set displayfile</b> [=] <var>file</var></td>
/// 			<td width="50%" valign="top">
/// 				Set the name of the file to be used for displaying the results of executing SQL statements. If no file name is specified
/// 					then a random file name will be generated for each statement execution. Additionally, a messages file may be produced. The
/// 					name of the file containing messages is either the <var>file</var> concatenated with "Messages" or it is a random file name
/// 					if <var>file</var> is set to nothing. To set the <var>file</var> setting to nothing after it was previously set, enter "".
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set displaymode</b> [=] <var>displaymode</var></td>
/// 			<td width="50%" valign="top">
/// 				Set the DISPLAYMODE. If <var>displaymode</var> is not specified, the current DISPLAYMODE setting is displayed on the current device.
/// 				<var>displaymode</var> values can be <b>cur[rentdevice]</b>,<b>xml</b>,<b>html</b>,<b>pdf</b>, or <b>txt</b>. When DISPLAYMODE is set to
/// 				CURRENTDEVICE, statement results are displayed on the current device. When XML, HTML, PDF or TXT are specified then statement results are written
/// 				to a temporary file using a ZEN Report that is generated from the statement metadata.
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set displaypath</b> [=] <var>path</var></td>
/// 			<td width="50%" valign="top">
/// 				Set the path where files used to save statement results will be placed.
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set displaytranslate[table]</b> [=] <var>translatetable</var></td>
/// 			<td width="50%" valign="top">
/// 				Set the translate table used for <var>displayfile</var> when writing output in 'csv' and 'txt' formats. 
/// 				For example, "UTF8". Values are case sensitive. 
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set executemode</b> [=] <var>executemode</var></td>
/// 			<td width="50%" valign="top">
/// 			Set EXECUTEMODE to <var>executemode</var>. Valid values are <b>immediate</b> and <b>deferred</b>.
/// 				If <var>immediate</var> then SQL statements are executed immediately. If <var>deferred</var> then the current statement
/// 				is executed by entering a 'go' command. If <var>executemode</var> is not specified then the current EXECUTEMODE
/// 				setting is displayed.
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set log</b> [=] on | off | <var>file</var></td>
/// 			<td width="50%" valign="top">
/// 				Turn logging on or off. If a <var>file</var> is specified, logging is turned on and the log is written to the file specified.
/// 				The default file for logging is used if logging is simply turned 'on'.
/// 			</td>
/// 		</tr>
/// 	<tr>
/// 			<td width="20%" valign="top"><b>set messages</b> [=] on | off</td>
/// 			<td width="50%" valign="top">
/// 				Turn messages on or off. If <var>messages</var> is off then results are displayed without any additional information. Times are
/// 					not displayed.
/// 			</td>
/// 		</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>set path</b> [=] <var>schemalist</var></td>
/// 				<td width="50%" valign="top">
/// 					Sets the current schema search path. If <var>schemalist</var> is empty then the current path is displayed.
/// 					To set PATH to the default schema then specify <var>schemalist</var> as """".
/// 					</td>
/// 		</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>set save</b></td>
/// 				<td width="50%" valign="top">
/// 					Save the current Shell settings for this user. The settings are restored when the current user
/// 					starts another Shell session.
/// 				</td>
/// 		</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>set selectmode</b> [=] <var>selectmode</var></td>
/// 				<td width="50%" valign="top">
/// 					Sets the current SELECTMODE to <b>odbc</b>, <b>logical</b>, or <b>display</b>.
/// 					If <var>selectmode</var> is NULL the current setting is displayed.</td>
/// 			</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>show [pl[an]]</b></td><td width="50%" valign="top">
/// 					Show the execution plan for the current statement.</td>
/// 			</tr>
/// 	<tr>
/// 				<td width="20%" valign="top"><b>show st[atement]</b></td><td width="50%" valign="top">
/// 					Show the current statement text and other details such as the implementation class.</td>
/// 			</tr>
/// </table></p>
Class %SQL.Shell Extends %Library.RegisteredObject [ System = 4 ]
{

/// This callback method is invoked by the <METHOD>%New</METHOD> method to 
/// provide notification that a new instance of an object is being created.
/// 
/// <P>If this method returns an error then the object will not be created.
/// <p>It is passed the arguments provided in the %New call.
/// When customizing this method, override the arguments with whatever variables and types you expect to receive from %New().
/// For example, if you're going to call %New, passing 2 arguments, %OnNew's signature could be:
/// <p>Method %OnNew(dob as %Date = "", name as %Name = "") as %Status
Method %OnNew(initvalue As %CacheString) As %Status [ Internal, Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	set ..Statement = ..StatementNewObject()
	if $Data(^SQL.Shell($Username,0))#10 { set ..ExecuteMode = $Listget(^SQL.Shell($Username,0),1), ..SelectMode = $Listget(^SQL.Shell($Username,0),2), ..Path = $Listget(^SQL.Shell($Username,0),3), ..DisplayMode = $Listget(^SQL.Shell($Username,0),4) , ..Dialect = $Listget(^SQL.Shell($Username,0),5), ..EchoMode = $Listget(^SQL.Shell($Username,0),6,1), ..MessageMode = $Listget(^SQL.Shell($Username,0),7,1), ..CommandPrefix = $Listget(^SQL.Shell($Username,0),8,""), ..DisplayFile = $Listget(^SQL.Shell($Username,0),9,""), ..DisplayPath = $Listget(^SQL.Shell($Username,0),10,"") }
	if ..Path = "" { set ..Path = $$$DefaultSchema }
	Quit $$$OK
}

Property Statement As %SQL.Statement;

Property StatementNbr As %Integer;

Property StatementText As %Library.String(MAXLEN = "") [ MultiDimensional ];

/// <p>CommandPrefix is the string value used to indicate that a command is being entered. The default value is null, meaning
/// that no command prefix is in use. If CommandPrefix is set to a non-empty value then that prefix must be entered as a prefix
/// to most commands.  There are three commands that do not require a prefix: <var>?</var>, <var>#</var> and <var>GO</var>.</p>
/// <pre>
/// USER>>set commandprefix = /
/// USER>>/set save
/// USER>>/quit
/// </pre>
Property CommandPrefix As %String(MAXLEN = 10);

/// Dialect is the dialect of SQL to be used when preparing a statement. Supported dialects are Cache SQL (default), Sybase and MS SQL Server.
Property Dialect As %Library.String;

Method DialectSet(pValue As %String = "") As %Status
{
	if pValue = i%Dialect quit $$$OK
	set tDialect = $ListFind($$$SQLDIALECTALLUPPER,$zconvert(pValue,"U"))
	if tDialect { set i%Dialect = $ListGet($$$SQLDIALECTALL,tDialect) quit $$$OK } else { quit $$$ERROR($$$GeneralError,"Invalid dynamic statement dialect mode: '"_pValue_"'") }
}

/// DisplayMode is the format in which results are displayed.
Property DisplayMode As %Integer(DISPLAYLIST = ",currentdevice,xml,html,pdf,txt,csv", VALUELIST = ",-1,0,1,2,99,100") [ InitialExpression = -1 ];

Property DisplayPath As %Library.String(MAXLEN = "");

Property DisplayFile As %Library.String(MAXLEN = "");

Property DisplayTranslateTable As %Library.String(MAXLEN = "");

/// EchoMode is either on (not zero) or off (zero). If on, statements and results are echoed to the current device.
/// This setting does not impact logging.
Property EchoMode As %Integer(DISPLAYLIST = ",off,on", VALUELIST = ",0,1") [ InitialExpression = 1 ];

/// ExecuteMode defines when the current statement will be executed. If ExecuteMode is 'immediate' then each statement is executed as
/// so as it is prepared. If ExecuteMode is 'deferred' then the statement is prepared but not executed until a 'GO' command is entered.
Property ExecuteMode As %Integer(DISPLAYLIST = ",deferred,immediate", VALUELIST = ",0,1") [ InitialExpression = 1 ];

/// executeStartTime is the time the statement execute started. This is reset during execute() after parameter values are entered.
/// The execute time is computed after %Display() is complete and displayed after the rowcount and SQLCODE.
Property executeStartTime As %Time;

/// Used to compute how many lines this query executes, global reads and disk latency
Property executeStats As %List;

/// Log instance. This is an oref that references a log object to be used when logging statements, messages, and results.
Property Log As %XSQL.Log;

/// Either on or off. If on then statements, messages and results will be logged using the current Log value.
Property LogMode As %Integer(DISPLAYLIST = ",off,on", VALUELIST = ",0,1") [ InitialExpression = 0 ];

/// MessageMode is either on (not zero) or off (zero). If on, messages will be displayed on the current device.
/// This does not impact the LogMode setting.
Property MessageMode As %Integer(DISPLAYLIST = ",off,on", VALUELIST = ",0,1") [ InitialExpression = 1 ];

/// Path is the schema search path used when resolving unqualified names.
Property Path As %String(MAXLEN = "");

/// prepareTime is the time is took to prepare the most recent statement.
Property prepareTime As %Time;

/// Used to compute how many lines this query executes, global reads and disk latency
Property prepareStats As %List;

/// SelectMode defines the format of literals and column values when executing an SQL statement.
Property SelectMode As %Integer(DISPLAYLIST = ",logical,odbc,display", VALUELIST = ",0,1,2") [ InitialExpression = 0 ];

/// %Go() - instantiate the shell and prompt for commands.
ClassMethod %Go(pDialect As %String) [ PublicList = SQLCODE ]
{
	new SQLCODE, %ROWID, %ROWCOUNT, %objcn, %objqacn, %protocol
	$$$StackObjectState($system.Context.SQL())
	set tCommandList = $Listbuild("#","exit","go","md","metadata","q","quit","save","set","trace")
	set tShell = ..%New()
	set tSC = $$$OK
	set tTrace = 0
	set tStats = 0
	set tCache = 1
	set tAsync = 0
	set tShowNodeNums = 0

	write "SQL Command Line Shell",!
	write "----------------------------------------------------",!
	write !,"The command prefix is currently set to: ",$Select(tShell.CommandPrefix="":"<<nothing>>.",1:tShell.CommandPrefix),!
	write "Enter ",tShell.CommandPrefix,"q to quit, ? for help.",!
	if ($Data(pDialect)) {
		set tSC = tShell.DialectSet(pDialect)
		if $$$ISERR(tSC) { write !,"Dialect override failed, requested '",pDialect,"'." }
		else { write !,"dialect = ",tShell.DialectLogicalToDisplay(tShell.Dialect),! }
	}
	do {
		set tRS = ""
		write $zutil(5),">>"
		read tInput
		if tInput = "" {
			set tContinue = 1
			write "  << entering multiline statement mode >>"
			do tShell.EnterStatement(.tInput)
			if tInput { do tShell.cmdProcessStatement(.tInput) }
		}
		else {
			write !
			set tShell.StatementNbr = 0
			set tContinue = tShell.dispatcher(.tInput)
		}
		kill tInput
	} while tContinue
	quit
}

Method dispatcher(ByRef pInput As %Library.String = "") [ PublicList = SQLCODE ]
{
	try {
		set tContinue = 1
Dispatch
		set tInputLC = $zconvert(pInput,"l")
		if (((..CommandPrefix '= "") && ($Extract(tInputLC,1,$Length(..CommandPrefix)) = ..CommandPrefix)) || ($Extract(tInputLC,1) = "?") || ($Extract(tInputLC,1) = "#") || ($Extract(tInputLC,1,2) = "go"))
			|| ((..CommandPrefix = "") && ($Find("?,#,set,show,trace,g,go,m,metadata,l,load,run,s,save,sg,saveglobal,o,open,l,list,c,clear,cos,q,quit,",$Piece(tInputLC," ",1)_","))) {
				// Strip the command prefix if present
			if (..CommandPrefix '= "") && ($Extract(tInputLC,1,$Length(..CommandPrefix)) = ..CommandPrefix) { set tInputLC = $Extract(tInputLC,$Length(..CommandPrefix)+1,*) }
			set tCommand = $Piece(tInputLC," ",1)

			// test for commands
			if ((tCommand="?") && ($Extract($ZStrip($Extract(tInputLC,2,*),"<W")) '= "="))||(tCommand="help") {
				do ..Help()
				write !,"The command prefix is currently set to: ",$Select(..CommandPrefix="":"<<nothing>>.",1:..CommandPrefix),!
			}
			elseif (tCommand="") { quit }
			elseif (tCommand = "cos") {
				do ..cmdCOS(.pInput)
				write !
			}
				#; QUIT the shell - QUIT, Q, EXIT or E.
			elseif ((tCommand="q")||(tCommand="quit"))||(tCommand="exit")||(tCommand="e") {
				set tContinue = 0
			}
			elseif tCommand="set" {
				do ..cmdSet(.tInputLC,.pInput)
			}
			elseif tCommand = "show" {
				do ..cmdShow(.tInputLC)
			}
			elseif (tCommand="trace on") {
				set tTrace = 1
				quit
			}
			elseif (tCommand="trace off") {
				set tTrace = 0
				quit
			}
			elseif ($extract(tCommand)="#") {
				do ..processCache(.pInput,.tCommand)
				if ($Extract(pInput) '= "#") && ($Extract(pInput,$Length(..CommandPrefix)+1) '= "#") { goto Dispatch }
				quit
			}
			elseif ((tCommand="g")||(tCommand="go")) {
				do ..cmdGo()
				quit
			}
			elseif (tCommand = "m") || (tCommand = "metadata") {
				do ..cmdMetadata(.tInputLC)
				quit
			}
		// Load a statement from a file
			elseif (tCommand = "load") {
				kill tStatement
				do ..cmdLoad(.pInput,.tStatement)
				if $Data(tStatement) {
					kill pInput
					merge pInput = tStatement
					goto Dispatch
				}
				else {
					write !,"Statement file invalid or empty.",!
					quit
				}
			}
			elseif (tCommand = "run") {
				do ..cmdRun(.pInput)
				quit
			}
				#; Save the current statement to the statement global
			elseif (tCommand="s")||(tCommand="save") {
				// save current statement
				if '$Data(..StatementText) {
					write "There is no statement to save.",!
					quit
				}
				else { set tStatus = ..cmdSave(.pInput) }
				quit
			}
				#; Save the current statement to the statement global
			elseif (tCommand="sg")||(tCommand="saveglobal") {
				do ..cmdSaveGlobal(.pInput)
				quit
			}
			elseif (tCommand = "c") || (tCommand = "clear") {
				set tName = $Piece(tInputLC," ",2)
				if tName '= "" {
					if '$Data(^SQL.Shell($username,1,tName)) { write "Saved statement not found: ",tName,! }
					else {
						kill ^SQL.Shell($username,1,tName)
						write !,"'",tName,"' deleted.",!
					}
				}
				else {
					write !,"Clearing the statement pool for user '",$Username,"'. Are you sure? [y|n]:"
					read tYN
					if $zconvert($Extract(tYN),"l") = "y" {
						kill ^SQL.Shell($Username,1)
						write "...cleared",!
					}
					else { write "...not cleared",! }
				}
				quit
			}
			elseif (tCommand = "o")||(tCommand = "open") {
				do ..cmdOpen(.pInput)
				quit
			}
			elseif (tCommand="l")||(tCommand="list") {
					#; list queries
				set tFound = 0
				write !,"Saved statements: "
				set tName = $order(^SQL.Shell($username,1,""))
				while (tName '= "") {
					set tFound = 1
					write "---------------------------------",!
					write tName,":",!
					write $get(^SQL.Shell($username,1,tName)),!
					set tName = $order(^SQL.Shell($username,1,tName))
				}
				if 'tFound { write "No statements saved in ^SQL.Shell($username)",! }
				quit
			}
			else {
				do ..cmdProcessStatement(.pInput)
			}
		}
		else {
			do ..cmdProcessStatement(.pInput)
		}
	}
	catch tException {
		write !,"Exception caught: ",tException.DisplayString(),!!
	}
	quit tContinue
}

Method processCache(ByRef pInput As %Library.String = "", pCommand As %Library.String(MAXLEN="") = "")
{
		// run historic query
	set tValue = $extract(pCommand,2,*)
	if $zconvert(tValue,"l") = "clear" {
		write !,"Clearing the statement history. Are you sure? [y|n]:"
		read tYN
		if $zconvert($Extract(tYN),"l") = "y" {
			kill ^||isc.sqlshell
			write "...cleared",!
		}
		else { write "...not cleared",! }
		quit
	}
	elseif (tValue = "?") || (tValue = "") {
		set n = $order(^||isc.sqlshell(0))
		if 'n { write !,"No statements logged.",! }
		else {
			while n {
				set tIndentFirst = $justify(n,6,0)_". "
				merge tCachedStatement = ^||isc.sqlshell(n)
					// The user entered a command to display these statements. Do it and ignore MessageMode.
				do ..displayStatement(.tCachedStatement,tIndentFirst,"        ")
				set n = $order(^||isc.sqlshell(n))
			}
			write !
		}
		quit
	}
	elseif (tValue = +tValue) {
		set ..StatementNbr = +tValue
		if (..StatementNbr = 0) { set ..StatementNbr = $get(^||isc.sqlshell,0) }
		if '$data(^||isc.sqlshell(..StatementNbr)) {
			write "No statement found: ",..StatementNbr,!
			quit
		}
		merge pInput = ^||isc.sqlshell(..StatementNbr)
		do ..displayStatement(.pInput)
		if ($Extract(pInput) = "#") || ($Extract(pInput,$Length(..CommandPrefix)+1) = "#") { write !,"Recalled command is command recall - invalid.",! }
	}
	else { write !,"Invalid cached statement option: '",tValue,"'",! }
}

/// cmdCOS will execute a COS command
Method cmdCOS(ByRef pInput As %Library.String(MAXLEN="") = "")
{
	set tCOS = $zstrip($Piece(pInput," ",2,9999),"<=W")
	if tCOS '= "" { xecute tCOS }
}

Method cmdGo()
{
		// run current statement
	set tPriorMode = $Zutil(115,5,..SelectMode)
	set tResult = ..execute(..Statement)
	if ..MessageMode { write ! }
	do ..displayResult(tResult)
	set tExecuteTime = $zh - ..executeStartTime
	if ..MessageMode {
		set $listbuild(tGlobals,tLines,tDiskRead)=..executeStats
		set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences-tGlobals,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted-tLines,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds-tDiskRead
		write !,"statement prepare time(s)/globals/lines/disk: ",$Justify(..prepareTime,0,4),"s/",$list(..prepareStats,1),"/",$list(..prepareStats,2),"/",$list(..prepareStats,3),"ms"
		write !,"          execute time(s)/globals/lines/disk: ",$Justify(tExecuteTime,0,4),"s/",tGlobals,"/",tLines,"/",tDiskRead,"ms"
		write !,$translate($justify("-",75)," ","-"),!
	}
	elseif ..DisplayMode = -1 { write ! }
	set ..prepareTime = 0
	quit
}

/// Display the current statement's metadata.
Method cmdMetadata(ByRef pInputLC As %Library.String(MAXLEN="") = "")
{
	set tMetadata = ..Statement.%Metadata
	if $Isobject(tMetadata) { do tMetadata.%Display() }
	else { write !,"No prepared statement.",! }
}

/// Open (retrieve) a statement from the SQL statement pool.
Method cmdOpen(ByRef pInput As %Library.String(MAXLEN="") = "")
{
		// open statement
	set tName = $piece(pInput," ",2)
	if (tName = "") {
		write "Please provide the name of the statement to load.",!
		quit
	}
	merge pInput = ^SQL.Shell($username,1,tName)
	if ($Get(pInput) = "") {
		write "Saved statement not found: ",tName,!
		quit
	}
	do ..cmdProcessStatement(.pInput)
}

Method cmdProcessStatement(ByRef pInput As %Library.String(MAXLEN="") = "")
{
		// Prepare a new statement. Only replace the shell Statement property if
		// prepare is successful.
	try {
		set tStatement = ##class(%SQL.Statement).%New(..SelectMode,..Path)
		set tStatement.%Dialect = ..Dialect
		do ##class(%SYSTEM.Process).EnableDiskReadTiming()
		set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds
		set tTime = $zh
		do tStatement.prepare(.pInput)
		set ..prepareTime = $zh - tTime
		set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences-tGlobals,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted-tLines,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds-tDiskRead
		set ..prepareStats=$lb(tGlobals,tLines,tDiskRead)
		set ..Statement = tStatement, tStatement = ""
			// remember statement
		kill ..StatementText
		merge ..StatementText = pInput
		if '..StatementNbr {
			set ..StatementNbr = $increment(^||isc.sqlshell)
			merge ^||isc.sqlshell(..StatementNbr) = pInput
		}
		if ..MessageMode {
			write ..StatementNbr,"."
			do ..displayStatement(.pInput)
		}
		if $Isobject(..Log) { do ..Log.logStatementSource(.pInput,0,2) }
		if ..ExecuteMode {
			if ..MessageMode { write ! }
			set tResult = ..execute(..Statement)
			do ..displayResult(tResult)
			set tExecuteTime = $zh - ..executeStartTime
			if ..MessageMode {
				set $listbuild(tGlobals,tLines,tDiskRead)=..executeStats
				set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences-tGlobals,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted-tLines,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds-tDiskRead
				write !,"statement prepare time(s)/globals/lines/disk: ",$Justify(..prepareTime,0,4),"s/",$list(..prepareStats,1),"/",$list(..prepareStats,2),"/",$list(..prepareStats,3),"ms"
				write !,"          execute time(s)/globals/lines/disk: ",$Justify(tExecuteTime,0,4),"s/",tGlobals,"/",tLines,"/",tDiskRead,"ms"
			}
			set ..prepareTime = 0
		}
		if ..MessageMode { write !,$translate($justify("-",75)," ","-"),! }
		elseif ..DisplayMode = -1 { write ! }
	}
	catch tException {
		if ..MessageMode {
			do $system.Status.DisplayError(tException.AsStatus())
			write !
		}
		if $Isobject(..Log) { do ..Log.logException(tException) }
	}
	quit
}

Method cmdSaveGlobal(ByRef pInput As %Library.String(MAXLEN="") = "")
{
	// save current statement
	if '$Data(..StatementText) {
		write "There is no statement to save.",!
		quit
	}
	set tName = $piece(pInput," ",2)
	if (tName = "") {
		write "Please provide a name of the statement to save.",!
		quit
	}
	if $Data(^SQL.Shell($username,1,tName)) {
		write !,"A statement named '",tName,"' already exists. Do you want to overwrite it? [y|n]:"
		read tYN
		if $zconvert($Extract(tYN),"l") = "y" {
			kill ^SQL.Shell($username,1,tName)
			merge ^SQL.Shell($username,1,tName) = ..StatementText
			write !,"...statement saved as: ",tName,!
		}
		else { write !,"...statement was not saved.",! }
	}
	else {
		kill ^SQL.Shell($username,1,tName)
		merge ^SQL.Shell($username,1,tName) = ..StatementText
		write !,"...statement saved as: ",tName,!
	}
	quit
}

Method cmdSet(ByRef pInputLC As %Library.String(MAXLEN="") = "", pInput As %Library.String(MAXLEN=""))
{
		// Various set options
		// set <option> [=] <value>
		// invoke a tokenizer to return tOption and tValue
	do ..parseSet(pInputLC,.tOption,.tValue)
	if tOption = "clear" {
		kill ^SQL.Shell($Username,0)
		write !,"...settings cleared.",!
	}
	elseif tOption = "commandprefix" {
			#; Set the CommandPrefix...
		if tValue = "" { write !,"commandprefix = ",..CommandPrefixLogicalToDisplay(..CommandPrefix),! quit }
		set ..CommandPrefix = $Select(tValue'="""""":tValue,1:"")
		write !,"commandprefix = ",$Select(..CommandPrefix'="":..CommandPrefix,1:""""""),!
	}
	elseif tOption = "dialect" {
			#; Set the Dialect context variable...
		if tValue = "" { write !,"dialect = ",..DialectLogicalToDisplay(..Dialect),! quit }
		if '$Case(tValue,"":1,"cache":1,"sybase":1,"mssql":1,:0) { write !,"Dialect '",tValue,"' is not supported.",! quit }
		set ..Dialect = tValue
		write !,"dialect = ",..DialectLogicalToDisplay($Select(..Dialect="":$$$SQLDIALECTCACHE,1:..Dialect)),!
	}
	elseif tOption = "displayfile" {
			#; Set the DISPLAYFILE context variable...
			#; support "cur" as an abbreviation for "currentdevice"
		if tValue '= "" {
			if tValue '= """""" { do ..parseSet(pInput,.tOption,.tValueAE) } else { set tValueAE = "" }
			if tValueAE '= "" {
				set tValueAEV = ##class(%Library.File).NormalizeFilename(tValueAE,"")
				if tValueAEV = "" {
					write !,"'",tValueAE,"' is not a valid file name.",!
					quit
				}
			}
			set ..DisplayFile = $Case($Extract(tValueAE),"/":$Extract(tValueAE,2,*),"\":$Extract(tValueAE,2,*),:tValueAE)
		}
		write !,"displayfile = ",..DisplayFileLogicalToDisplay(..DisplayFile),!
	}
	elseif tOption = "displaymode" {
			#; Set the DISPLAYMODE context variable...
			#; support "cur" as an abbreviation for "currentdevice"
	    if $Extract(tValue,1,3) = "cur" { set tValue = "currentdevice" }
		if tValue = "" { write !,"displaymode = ",..DisplayModeLogicalToDisplay(..DisplayMode),! quit }
		set tDisplayMode = ..DisplayModeDisplayToLogical(tValue) // $case(tValue,"xml":0,"html":1,"pdf":2,"txt":99,"currentdevice":-1,:"")
		if tDisplayMode = "" { write !,"Invalid 'displaymode' value... ("_tValue_")",! quit }
		set ..DisplayMode = tDisplayMode
		write !,"displaymode = ",..DisplayModeLogicalToDisplay(..DisplayMode),!
	}
	elseif tOption = "displaypath" {
			#; Set the DISPLAYPATH context variable...
			#; support "cur" as an abbreviation for "currentdevice"
		if tValue = "" { write !,"displaypath = ",..DisplayPathLogicalToDisplay(..DisplayPath),! quit }
		do ..parseSet(pInput,.tOption,.tValueAE)
		if tValueAE '= "" {
			set tValueAEV = ##class(%Library.File).NormalizeDirectory(tValueAE)
			if tValueAEV = "" {
				write !,"'",tValueAE,"' is not a valid display path."
			}
			else {
				set ..DisplayPath = tValueAEV
			}
		}
		else { set ..DisplayPath = "" }
		write !,"displaypath = ",..DisplayPathLogicalToDisplay(..DisplayPath),!
	}
	elseif $Extract(tOption,1,16) = "displaytranslate" {
			#; Set the DISPLAYTRANSLATE context variable...
		if tValue = "" { write !,"displaytranslatetable = ",..DisplayTranslateTableLogicalToDisplay(..DisplayTranslateTable),! quit }
		do ..parseSet(pInput,.tOption,.tValueAE)
			// tValueAE = value as entered, preserves original casing.
		set ..DisplayTranslateTable = tValueAE
		write !,"displaytranslatetable = ",..DisplayTranslateTableLogicalToDisplay(..DisplayTranslateTable),!
	}
	elseif tOption = "echo" {
			// Set the ECHOMODE context variable...
		if tValue = "" { write !,"echomode = ",..EchoModeLogicalToDisplay(..EchoMode),! quit }
		set tEchoMode = $case(tValue,"on":1,"off":0,:"")
		if tEchoMode = "" { write !,"Invalid 'echomode' value... ("_tValue_")",! quit }
		set ..EchoMode = tEchoMode
		write !,"echo = ",..EchoModeLogicalToDisplay(..EchoMode),!
	}
	elseif tOption = "executemode" {
	        #; Set the EXECUTEMODE context variable...
		if tValue = "" { write !,"executemode = ",..ExecuteModeLogicalToDisplay(..ExecuteMode),! quit }
		set tExecuteMode = $case(tValue,"deferred":0,"immediate":1,:tValue)
		if (tExecuteMode '= 0) && (tExecuteMode '= 1) { write !,"Invalid 'Executemode' value... ("_tValue_")",! quit }
		set ..ExecuteMode = tExecuteMode
		write !,"Executemode = ",..ExecuteModeLogicalToDisplay(..ExecuteMode),!
	}
	elseif tOption = "log" {
			#; Set the LOG context variable...
			#; support "on" and "off", "on" meaning to activate logging using the default file name
			#; "off" means turn off logging and close the current log file
			// <file> means activate logging and use <file> for the log file.
		if tValue = "" {
				// display the current log status
			write !,"log = ",$Select($Isobject(..Log):..Log.logFile,1:"off"),!
		}
		elseif tValue = "on" {
				// activate logging
			if $Isobject(..Log) { write !,"logging is already activated, current log output is '",..Log.logFile,"'",! }
			else {
				set ..Log = ..LogNewObject()
				write !,"log = ",$Select($Isobject(..Log):..Log.logFile,1:"off"),!
			}
		}
		elseif tValue = "off" {
			if $Isobject(..Log) {
				write !,"logging to '",..Log.logFile,"' is now suspended.",!
				set ..Log = ""
			}
			else {
				write !,"log = off",!
			}
		}
		else {
				// activate logging
			do ..parseSet(pInput,,.tValueOC)
			if $Isobject(..Log) {
				write !,"logging is active, current log output is '",..Log.logFile,"'",!
				if ..Log.logFile '= tValueOC {
					write "closing current log..."
					set ..Log = ""
					write !,"opening new log..."
					set ..Log = ##class(%XSQL.Log).%New(tValueOC)
					if '$Isobject(..Log) { write "failed.",! }
					else { write "activated",! }
				}
			}
			else {
				write !,"opening new log..."
				set ..Log = ##class(%XSQL.Log).%New(tValueOC)
				if '$Isobject(..Log) { write "failed.",! }
				else { write "activated",! }
			}
			write !,"log = ",$Select($Isobject(..Log):..Log.logFile,1:"off"),!
		}
	}
	elseif tOption = "messages" {
			// Set the MESSAGEMODE context variable...
		if tValue = "" { write !,"messages = ",..MessageModeLogicalToDisplay(..MessageMode),! quit }
		set tMessageMode = $case(tValue,"on":1,"off":0,:"")
		if tMessageMode = "" { write !,"Invalid 'messagemode' value... ("_tValue_")",! quit }
		set ..MessageMode = tMessageMode
		write !,"messages = ",..MessageModeLogicalToDisplay(..MessageMode),!
	}
	elseif tOption = "path" {
		if tValue '= "" {
			if tValue = """""" { set tValue = $$$DefaultSchema }
			set ..Path = tValue
		}
		write !,"path = ",$Select(..Path'="":..Path,1:"<<empty>>"),!
	}
	elseif tOption = "save" {
		set ^SQL.Shell($Username,0) = $ListBuild(..ExecuteMode,..SelectMode,..Path,..DisplayMode,..Dialect,..EchoMode,..MessageMode,..CommandPrefix,..DisplayFile,..DisplayPath)
		write !,"current settings saved.",!
	}
	elseif tOption = "selectmode" {
	        #; Set the SELECTMODE context variable...
		if tValue = "" { write !,"selectmode = ",..SelectModeLogicalToDisplay(..SelectMode),! quit }
		set tSelectMode = $case(tValue,"logical":0,"odbc":1,"display":2,:"")
		if tSelectMode = "" { write !,"Invalid 'selectmode' value... ("_tValue_")",! quit }
		set ..SelectMode = tSelectMode
		write !,"selectmode = ",..SelectModeLogicalToDisplay(..SelectMode),!
	}
	elseif tOption = "" {
		write !,"commandprefix = ",$Select(..CommandPrefix'="":..CommandPrefix,1:""""""),!
		write "dialect = ",..DialectLogicalToDisplay($Select(..Dialect="":$$$SQLDIALECTCACHE,1:..Dialect)),!
		write "displayfile = ",..DisplayFileLogicalToDisplay(..DisplayFile),!
		write "displaymode = ",..DisplayModeLogicalToDisplay(..DisplayMode),!
		write "displaypath = ",..DisplayPathLogicalToDisplay(..DisplayPath),!
		write "displaytranslatetable = ",..DisplayTranslateTableLogicalToDisplay(..DisplayTranslateTable),!
		write "echo = ",..EchoModeLogicalToDisplay(..EchoMode),!
		write "executemode = ",..ExecuteModeLogicalToDisplay(..ExecuteMode),!
		write "log = ",$Select($Isobject(..Log):..Log.logFile,1:"off"),!
		write "messages = ",..MessageModeLogicalToDisplay(..MessageMode),!
		write "path = ",..Path,!
		write "selectmode = ",..SelectModeLogicalToDisplay(..SelectMode),!
	}
	else {
		write !,"Invalid option: '",tOption,"'",!
	}
	quit
}

Method cmdShow(ByRef pInputLC As %Library.String(MAXLEN="") = "", pCommand As %Library.String = "")
{
		// Various "show" options
	set tCommandOption = $Piece(pInputLC," ",2)
	if ((tCommandOption = "plan") || (tCommandOption = "")) || ($Extract(tCommandOption,1,2) = "pl") {
		if '$Data(..StatementText) {
			write "There is no query to analyze.",!
			quit
		}
			#;-------------------------------------------------------------------
			#;  Function:     ShowPlan^%apiSQL(sql,arr)
			#;  Description:  Generate a plan description for a given query text
			#;  Parameters:
			#;     1.  sql - Passed by reference.  sql(1:sql) are lines of SQL query text
			#;     2.  arr - 1 or 0 ("").  If 1, leave the resulting plan lines in the
			#;               array %plan(1:%plan), otherwise output the plan using WRITE
			#;     3.  forTest - 1 or 0 ("").  If 1, generate regression test output
			#;     4.  showstats - 1 or 0.  If 1 the run the SQL query to generate stats
			#;                     and output the stats as part of the plan text
			#;     5.  packages = $List of package names that will be used as default packages/schemas
			#;-------------------------------------------------------------------
		if +..StatementText '= ..StatementText { set tSQL = 1, tSQL(1) = ..StatementText } else { merge tSQL = ..StatementText }
		 	#; If this is a SELECT query, add on a "DECLARE CURSOR QRS FOR " so the showplan will match the statement index for a dynamic query that may have already been executed and had it's plan frozen.
		 	#; This will allow the statment to match and use the frozen plan
		 if $$$UPPER($e($$$StripLeadingWhiteSpace(tSQL(1)),1,6))="SELECT" {
			 set tSQL(1)="DECLARE QRS CURSOR FOR "_tSQL(1)
		 }
		if ..Path '= "" {
			set tCurrentPath = $g(%sqlSchemaPath)
			set tSchemaPath = $$$UPPER(..Path)
			for tPtr = 1:1:$l(tSchemaPath,",") {
				set tSchema=$p(tSchemaPath,",",tPtr)
				if tSchema = "" { throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$SqlCompileBadMode)) }
				set:tSchema="CURRENT_PATH" $p(tSchemaPath,",",tPtr) = tCurrentPath
				#; TODO: How do we determine the code container? It is either contextless (server based or command line based), in a routine or in a class. We are only interested
				#; 		if we are in a class. This code, from the MPP, knows the code container:
						;	set:tSchema="CURRENT_SCHEMA" $p(tSchemaPath,",",tPtr)=$s($g(%classname)'="":$$$UPPER($$DetermineSchemaName^%qarmac(%classname)),1:$$$DEFAULTSCHEMA)
			}
		}
		else { set tSchemaPath = "" }
		do ShowPlan^%apiSQL(.tSQL,0,0,0,"",$listfromstring(tSchemaPath),1,"RUNTIME")
		write !
	}
	elseif ($Extract(tCommandOption,1,2) = "st") || (tCommandOption = "statement") {
		do ..Statement.%Display()
	}
	quit
}

Method execute(pStatement As %SQL.Statement) As %SQL.StatementResult
{
	try {
		new %tResult,%tStatement,%tValue
		set %tResult = ""
		set %tStatement = pStatement
		if pStatement.%Metadata.parameters.Count() > 0 {
			set tExecute = "set %tResult=%tStatement.%Execute("
			set tExecuteDisplay = tExecute
			for tParm = 1:1:pStatement.%Metadata.parameters.Count() {
				set tParameter = pStatement.%Metadata.parameters.GetAt(tParm)
					// The default parameter expression is %tValue<n>. This changes
					// if the value entered by the user for an input directed parameter
					// begins with a <colon>.
				set tParmExpr = "%tValue"_tParm
				if (tParameter.columnType = 1) || (tParameter.columnType = 2) {
					write !,"Enter the value for parameter '",tParm,"': "
					read tParmVal
					if $Extract(tParmVal) = ":" {
						write "...is this a literal (Y/N)?  [N]:"
						read tLiteral
						if $$$ucase(tLiteral) '= "Y" {
							set tParmExpr = $Extract(tParmVal,2,*)
						set tExecuteDisplay = tExecuteDisplay _ tParmExpr _","
						}
						else {
							set tParmExpr = "%tValue"_tParm
							set @("%tValue"_tParm) = tParmVal
							set tExecuteDisplay = tExecuteDisplay _ $ZUtil(144,1,tParmVal) _","
						}
					}
					else {
						set @tParmExpr = tParmVal
						set tExecuteDisplay = tExecuteDisplay _ $ZUtil(144,1,tParmVal) _","
					}
					set tExecute = tExecute _ tParmExpr _ ","
				}
				elseif tParameter.columnType > 3 {
						// Output only (4) or Return value (5)
					set tExecuteDisplay = tExecuteDisplay _","
					set tExecute = tExecute _ ","
				}
			}
			set tExecute = $Select($Extract(tExecute,*)'="(":$Extract(tExecute,1,*-1)_")",1:tExecute _ ")")
			write !,"executing statement with parameter values: ",$Select($Extract(tExecuteDisplay,*)'="(":$Extract(tExecuteDisplay,1,*-1)_")",1:tExecuteDisplay_")"),!
			set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds
			set ..executeStats=$lb(tGlobals,tLines,tDiskRead)
			set ..executeStartTime = $zh
			xecute tExecute
		}
		else {
			set tGlobals = $zu(67,9,$J)+$system.Context.WorkMgr().GlobalReferences,tLines=$zu(67,8,$J)+$system.Context.WorkMgr().LinesExecuted,tDiskRead=$zu(67,41,$J)+$system.Context.WorkMgr().DiskReadMilliseconds
			set ..executeStats=$lb(tGlobals,tLines,tDiskRead)
			set ..executeStartTime = $zh
			set %tResult = pStatement.%Execute()
		}
	}
	catch tException {
		write !,"Exception occurred during statement execution"
		do $system.OBJ.DisplayError(tException.AsStatus())
	}
	quit %tResult
}

ClassMethod cmdLoad(pInput As %String(MAXLEN=""), ByRef pStatement As %String(MAXLEN=""))
{
	set tFileName = $zstrip($Piece(pInput," ",2,9999),"<=W")
	write !,"Loading statement from '",tFileName,"'..."
	try {
		set tBatch = ##class(%Stream.FileCharacter).%New()
		set tStatus = tBatch.LinkToFile(tFileName)
		if $$$ISERR(tStatus) { throw ##class(%Exception.StatusException).CreateFromStatus(tStatus) }
		set tBatch.LineTerminator = $Char(13,10)
		set tSourceLine = tBatch.ReadLine()
		write !,$Char(9),tSourceLine
		set pStatement = 1, pStatement(pStatement) = tSourceLine
			#; Now read the input stream to the end
		do {
			set tSourceLine = tBatch.ReadLine()
			set pStatement = pStatement + 1, pStatement(pStatement) = tSourceLine
			write !,$Char(9),tSourceLine
		} while 'tBatch.AtEnd
		set tStatus = $$$OK
	}
	catch tException {
		set tStatus = tException.AsStatus()
		do $system.OBJ.DisplayError(tStatus)
		kill pStatement
	}
	quit tStatus
}

Method cmdSave(pInput As %String(MAXLEN=""))
{
	try {
		new %objlasterror
		set tFileName = $zstrip($Piece(pInput," ",2,9999),"<=W")
		if ##class(%Library.File).Exists(tFileName) {
			write !,"File '",tFileName,"' already exists. Overwrite? (Y/N)? "
			read tYN
			if $zconvert($Extract(tYN),"l") '= "y" {
				throw ##class(%Exception.StatusException).CreateFromStatus($$$ERROR($$$GeneralError,"File '"_tFileName_"' already exists"))
			}
		}
		set tBatch = ##class(%Stream.FileCharacter).%New()
		if tBatch = $$$NULLOREF { throw ##class(%Exception.StatusException).CreateFromStatus($Get(%objlasterror)) }
		set tStatus = tBatch.LinkToFile(tFileName)
		if ..StatementText = +..StatementText {
			for tLine = 1:1:..StatementText {
				set tStatus = tBatch.WriteLine(..StatementText(tLine))
				if $$$ISERR(tStatus) { quit }
			}
		}
		else { set tStatus = tBatch.WriteLine(..StatementText) }
		if $$$ISERR(tStatus) { throw ##class(%Exception.StatusException).CreateFromStatus(tStatus) }
		set tStatus = tBatch.%Save()
		if $$$ISERR(tStatus) { throw ##class(%Exception.StatusException).CreateFromStatus(tStatus) }
		write !,"...statement saved as: ",tFileName,!
	}
	catch tException {
		set tStatus = tException.AsStatus()
		write !,"...error occurred during file write. Not saved: "
		do $system.OBJ.DisplayError(tStatus)
		write !
	}
	quit tStatus
}

/// EnterStatement - multi-line statement entry
Method EnterStatement(ByRef pInput As %Library.String(MAXLEN="") = "")
{
	write !
	set pInput = 0
	do {
		write $Char(9),pInput+1,">>"
		read tInput
		write !
Dispatch
		set tInputLC = $zconvert(tInput,"l")
		if (((..CommandPrefix '= "") && ($Extract(tInputLC,1,$Length(..CommandPrefix)) = ..CommandPrefix)) || ($Extract(tInputLC,1) = "?") || ($Extract(tInputLC,1) = "#") || ($Extract(tInputLC,1,2) = "go"))
			|| ((..CommandPrefix = "") && ($Find("?,q,quit,c,clear,cos,g,go,l,list,load,",$Piece(tInputLC," ",1)_","))) || (tInput = "") {
				// Strip the command prefix if present
			if (..CommandPrefix '= "") && ($Extract(tInputLC,1,$Length(..CommandPrefix)) = ..CommandPrefix) { set tInputLC = $Extract(tInputLC,$Length(..CommandPrefix)+1,*) }
			set tCommand = $Piece(tInputLC," ",1)

				// test for commands
			if ((tCommand = "?") && ($Extract($ZStrip($Extract(tInputLC,2,*),"<W")) '= "="))||(tCommand="help") {
				do ..HelpStatementMode()
				continue
			}
			if (tCommand = "") {
				if tInput '= "" { set pInput = pInput + 1, pInput(pInput) = tInput }
				continue
			}
			if (tCommand = "c") || (tCommand = "clear") {
				set tLine = $Piece(tInputLC," ",2)
				if tLine '= "" {
					if tLine > pInput { write "Line not defined: ",tLine,! }
					else {
						kill pInput(tLine)
						for tPtr = tLine:1:pInput-1 { set pInput(tPtr) = pInput(tPtr+1) }
						kill pInput(pInput)
						set pInput = pInput - 1
						write !,"Line '",tLine,"' cleared.",!
					}
				}
				else {
					write !,"Clearing the entire statement. Continue? [y|n]:"
					read tYN
					if $zconvert($Extract(tYN),"l") = "y" {
						kill pInput
						set pInput = 0
						write "...cleared",!
					}
					else { write "...not cleared",! }
				}
				continue
			}
			if (tCommand = "cos") {
				do ..cmdCOS(.tInput)
				write !
				continue
			}
			if ((tCommand="g")||(tCommand="go")) {
				quit
			}
			if (tCommand="l")||(tCommand="list") {
					#; list the current statement
				write "---------------------------------",!
				for tPtr = 1:1:pInput { write $Char(9),pInput(tPtr),! }
				write "---------------------------------",!
				continue
			}
				#; QUIT - clear the statement buffer and return
			if ((tCommand="q")||(tCommand="quit")) {
				kill pInput
				set pInput = ""
				quit
			}
		}
		set pInput = pInput + 1, pInput(pInput) = tInput
	} while 1
	quit
}

ClassMethod parseSet(pCommand As %String(MAXLEN="") = "", ByRef pOption As %String(MAXLEN="") = "", ByRef pValue As %String(MAXLEN="") = "") As %Status [ Internal ]
{
		// pCommand is expected to be all lower case and it begins with "set ".
		
		// First task is to remove the "set "
	set tCommand = $Piece(pCommand," ",2,999)
		// Now extract the option from tCommand. The assignment operator is optional. If not present, a space is required.
	if tCommand [ "=" { set pOption = $Piece(tCommand,"=",1), pValue = $Piece(tCommand,"=",2,9999) }
	else { set pOption = $Piece(tCommand," ",1), pValue = $Piece(tCommand," ",2,9999) }
	set pOption = $Zstrip(pOption,"<>W")
	set pValue = $Zstrip(pValue,"<>W")
	quit $$$OK
}

ClassMethod displayStatement(ByRef pStatement As %Library.String(MAXLEN=""), pIndentFirst As %Library.String = {$Char(9)}, pIndent As %Library.String = {$Char(9)})
{
	if +pStatement '= pStatement { write pIndentFirst,pStatement,! }
	else { write pIndentFirst,$Get(pStatement(1)),! for tPtr = 2:1:pStatement { write pIndent,pStatement(tPtr),! } }
}

ClassMethod Help()
{
		#; Print the command set with hints to the screen
	write !,"Interactive SQL Shell"
	write !,?15,"(c) InterSystems Corporation 1999-2009 All Rights Reserved",!
	write "----------------------------------------------------",!
	write "To execute an SQL statement, type it in and press ENTER.",!
	write "To execute a multiline SQL statement, press <enter> to enter",!
	write "multiline statement mode, enter the each statement line and",!
	write "enter GO to exit multiline statement mode and execute the statement.",!
	write !,"Available commands:",!
	write !,?3,"<enter>               Enter multiline statement mode.",!
	write !,?3,"#[?]                  List statements currently in the history buffer.",!
	write !,?3,"#<n>                  Recall statement <n> from the statement history buffer."
	write !,?3,"                      If <n> is zero then recall the most recent statement."
	write !,?3,"                      Recalled statements are executed if EXECUTEMODE is set"
	write !,?3,"                      to 'immediate'."
	write !,?3,"                      If EXECUTEMODE is set to 'deferred' then it is"
	write !,?3,"                      necessary to enter 'go' to execute the recalled"
	write !,?3,"                      statement.",!
	write !,?3,"#clear                Clear the statement history buffer.",!
	write !,?3,"c[lear] <name>        Clear (delete) the statement identified by <name> from"
	write !,?3,"                      the statement pool.",!
	write !,?3,"cos <cos command>     Execute <cos command>.",!
	write !,?3,"g[o]                  Run the most recently executed or loaded statement.",!
	write !,?3,"l[ist]                List saved queries.",!
	write !,?3,"load <filename>       Load a statement from a file.",!
	write !,?3,"m[etadata]            Displays the statement metadata of the"
	write !,?3,"                      current statement.",!
	write !,?3,"o[pen] <name>         Open the statement name <name> from the statement pool."
	write !,?3,"                      The retrieved statement is prepared and executed"
	write !,?3,"                      (depending on the EXECUTEMODE setting).",!
	write !,?3,"q[uit]                Exit the shell.",!
	write !,?3,"run [<filename>]      Run an SQL script. If <filename> is not specified then"
	write !,?3,"                      the user will be prompted for the file name.",!
	write !,?3,"saveglobal <name>     Save the current statement using the given name in the"
	write !,?3,"                      statement global.",!
	write !,?3,"s[ave] <filename>     Save the current statement to a file.",!
	write !,?3,"set                   Displays the current context settings.",!
	write !,?3,"set clear             Clear saved Shell settings for this user.",!
	write !,?3,"set commandprefix [=] <value>"
	write !,?3,"                      Sets the commandprefix to <value>.",!
	write !,?3,"set dialect [=] sybase | mssql | cache."
	write !,?3,"                      Sets the dialect to the desired SQL dialect. If"
	write !,?3,"                      dialect is empty then Cache SQL is assumed."
	write !,?3,"                      The dialect setting determines which dialect mode is"
	write !,?3,"                      used when preparing a statement.",!
	write !,?3,"set displayfile [=] <file>"
	write !,?3,"                      Set the name of the file to be used for displaying the"
	write !,?3,"                      results of executing SQL statements. If no file name is"
	write !,?3,"                      specified then a random file name will be generated for"
	write !,?3,"                      each statement execution. Additionally, a messages file"
	write !,?3,"                      may be produced. The name of the file containing messages"
	write !,?3,"                      is either the <file> concatenated with ""Messages"""
	write !,?3,"                      or it is a random file name if <file> is set to"
	write !,?3,"                      nothing. To set the <file> setting to nothing"
	write !,?3,"                      after it was previously set, enter """".",!
	write !,?3,"set displaymode [=] <displaymode>",!
	write !,?3,"                      Set the DISPLAYMODE. If <var>displaymode</var> is not"
	write !,?3,"                      specified, the current DISPLAYMODE setting is displayed"
	write !,?3,"                      on the current device. <displaymode> values can be"
	write !,?3,"                      cur[rentdevice],xml,html,pdf, txt or csv."
	write !,?3,"                      When DISPLAYMODE is set to CURRENTDEVICE, statement"
	write !,?3,"                      results are displayed on the current device. When XML,"
	write !,?3,"                      HTML, PDF or TXT are specified then the statement"
	write !,?3,"                      results are written to a file using a ZEN Report"
	write !,?3,"                      that is generated from the statement metadata.",!
	write !,?3,"set displaypath [=] <path>"
	write !,?3,"                      Set the path where files used to save statement results will be placed.",!
	write !,?3,"set displaytranslate[table] [=] <translatetable>"
	write !,?3,"                      Set the translate table used for displayfile when"
	write !,?3,"                      writing output in 'csv' and 'txt' formats. For example, ""UTF8""."
	write !,?3,"                      Values are case sensitive.",!
	write !,?3,"set executemode [=] immediate|deferred"
	write !,?3,"                      Sets the execute mode. If immediate then"
	write !,?3,"                      SQL statements are executed immediately."
	write !,?3,"                      If deferred then that current statement is"
	write !,?3,"                      executed by entering a 'go' command.",!
	write !,?3,"set log [=] on | off | <filename>"
	write !,?3,"                      Turn logging on or off. If a file name is specified,"
	write !,?3,"                      logging is turned on and the log is written to the"
	write !,?3,"                      file specified. The default file for logging is used"
	write !,?3,"                      if logging is simply turned 'on'.",!
	write !,?3,"set messages [=] on | off"
	write !,?3,"                      Turn messages on or off. If <var>messages</var> is off"
	write !,?3,"                      then results are displayed without any additional information"
	write !,?3,"                      and prepare and execute times are not displayed.",!
	write !,?3,"set path [=] <schemalist> Sets the current schema search path."
	write !,?3,"                      If <schemalist> is empty then the current path"
	write !,?3,"                      is displayed. To set PATH to the default schema then"
	write !,?3,"                      specify <schemalist> as """".",!
	write !,?3,"set save              Save the current Shell settings for this user."
	write !,?3,"                      The settings are restored when the current user"
	write !,?3,"                      starts another Shell session.",!
	write !,?3,"set selectmode [=] <selectmode>     Sets the current select mode to odbc,"
	write !,?3,"                      logical, or display. If <selectmode>"
	write !,?3,"                      is NULL the current setting is displayed.",!
	write !,?3,"show                  Show the execution plan for the current statement.",!
	write !,?3,"show pl[an]           Shows the current statement execution plan.",!
	write !,?3,"show st[atement]      Shows the current statement and details regarding",!
	write !,?3,"                      the statement.",!
	write !,?3,"<SQL Statement>       Prepares and executes the statement. The result"
	write !,?3,"                      is displayed after execution.",!
	quit
}

ClassMethod HelpStatementMode()
{
		#; Print the command set with hints to the screen
	write !,"Interactive SQL Shell - Multiline Statement Mode"
	write !,?15,"(c) InterSystems Corporation 1999-2009 All Rights Reserved",!
	write "----------------------------------------------------",!
	write !,"Multline statement mode.",!
	write !,"To enter a multiline statement, enter each line followed by <enter>. The prompt"
	write !,"indicates the current line number. When the statement is complete, enter GO"
	write !,"(must appear on its own line) to exit multiline mode. If the execution mode is"
	write !,"immediate the statement will be executed.",!
	write !,"Available commands in multiline mode:",!
	write !,?3,"c[lear]               Clear (delete) the statement lines entered thus far.",!
	write !,?3,"c[lear] <linenbr>     Clear (delete) line <linenbr> from the statement line buffer.",!
	write !,?3,"cos <cos command>     Execute <cos command>.",!
	write !,?3,"g[o]                  Exit multiline statement mode and, if execute mode is immediate,"
	write !,?3,"                      execute the statement.",!
	write !,?3,"l[ist]                List the statement lines.",!
	write !,?3,"q[uit]                Exit multiline statement mode.",!
	write !,?3,"<SQL Statement line>  Enter a new line into the statement line buffer.",!
	quit
}

/// cmdRun will run a SQL script file - Currently only Sybase is supported.
Method cmdRun(ByRef pInput As %Library.String(MAXLEN="") = "")
{
	set tFileName = $zstrip($Piece(pInput," ",2,9999),"<=W")
	do ##class(%SQL.Util.Import).interactive(..Dialect,tFileName,..MessageMode,..EchoMode)
}

/// This method displays the result produced by executing the current statement. DISPLAYMODE determines how the statement is displayed
/// and ECHOMODE suppresses the results display on the current device.
Method displayResult(pResult As %SQL.StatementResult = "")
{
#define NewFileRoot					$translate($zstrip($SYSTEM.Encryption.Base64Encode($system.Encryption.GenCryptRand(10)),">","="), "+/", "ab")
#define TempFilePath				##class(%File).NormalizeDirectory(##class(%ZEN.Report.reportPage).%GetTempDir())
	try {
			// Get the OS. If the OS is not Windows or Unix then deliver the message that the file cannot
			// be automatically displayed.
		set tOS = $system.Version.GetBuildOS()
		if ..DisplayMode = -1 { if ..EchoMode { do pResult.%Display() } }
		else {
			set tMessages = ##class(%SQL.Manager.Messages).%New()
			if (..DisplayMode '= -1) && (..SelectMode = 0) {
				do tMessages.Insert("WARNING: Formatted display of results in LOGICAL mode might fail if the results contain control characters!")
				do tMessages.Insert("         A common result column containing a $List value, such as a list collection, will contain control characters")
				do tMessages.Insert("         and an empty result file will be displayed.")
			}
			if ..DisplayPath = "" { set tDisplayPath = $$$TempFilePath }
			else { set tDisplayPath = ..DisplayPath }
			if ..DisplayFile = "" { set tFileRoot = ##class(%Library.File).NormalizeFilename($$$NewFileRoot,tDisplayPath) }
			else { set tFileRoot =  ##class(%Library.File).NormalizeFilename(..DisplayFile,tDisplayPath) }
			try { do pResult.%DisplayFormatted(..DisplayMode,tFileRoot,tMessages,.tFiles,..DisplayTranslateTable) }
			catch tExceptionInner {
				set tSQLCODE = tExceptionInner.AsSQLCODE()
				set tSQLMessage = tExceptionInner.AsSQLMessage()
				if ..MessageMode {
					write !!,"[SQLCODE: <",tSQLCODE,">:<",$$sqlcode^%apiSQL(tSQLCODE),">]",!
					if tSQLMessage'="" { write "[%msg: <",tSQLMessage,">]",! }
				}
				if ..LogMode { do ..Log.logException(tExceptionInner) }
			}
			if tMessages.Count() > 0 { do tMessages.%DisplayFormatted(..DisplayMode,tFileRoot_"Messages",,.tFiles,..DisplayTranslateTable) }
			if tFiles { for tFile = 1:1:tFiles { write !,tFiles(tFile) } }
		}
			// Note that result sets have already been consumed by the time we log the result unless ECHOMODE is off:
		if $Isobject(..Log) { do ..Log.logStatementResult(pResult) }
	}
	catch tException {
		if ..MessageMode {
			set tSQLCODE = tException.AsSQLCODE()
			set tSQLMessage = tException.AsSQLMessage()
			write !!,"[SQLCODE: <",tSQLCODE,">:<",$$sqlcode^%apiSQL(tSQLCODE),">]",!
			if tSQLMessage'="" { write "[%msg: <",tSQLMessage,">]",! }
		}
		if $Isobject(..Log) { do ..Log.logException(tException) }
	}
}

}
