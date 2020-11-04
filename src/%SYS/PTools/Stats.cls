/// <p>This class is designed to gather performance statistics for any type of routine or code block.
/// 
/// <p>The data for this class is stored in ^%SYS.PTools.Stats, ^%SYS.PTools.StatsD and ^%SYS.PTools.StatsI.
/// These globals default to the %SYS NameSpace, you might want to map them to a different NameSpace to avoid filling %SYS.
///  
/// <p>By calling pairs of the Start() and Stop() methods we will record GlobalRef, commands executed, TotalTime, and some process info for each code block.
/// 
/// <p>You need to manually add the calls to the Start() and Stop() methods to your code.
/// 
/// <p>Each method takes 3 parameters:
/// 
///     Namespace   - Current namespace the code is being executed in
///     RoutineName - Name of the routine you are gathering stats for
///     ModuleName  - Name of the sub block with a given routine, Defaults to 1
/// 
/// <p>For example when the code below is executed we will put three entries into the %SYS_PTools.Stats table, one for each call to Stop().
/// 
/// 
/// <example>
/// Test	;
/// 	DO ##class(%SYS.PTools.Stats).Start("Samples","Test","Full Routine")
/// 	DO ##class(%SYS.PTools.Stats).Start("Samples","Test","Part 1")
/// 	
/// 	DO ##class(Sample.Person).Populate(1000)
/// 	
/// 	DO ##class(%SYS.PTools.Stats).Stop("Samples","Test","Part 1")
/// 	DO ##class(%SYS.PTools.Stats).Start("Samples","Test","Part 2")
/// 	
/// 	DO ##class(Sample.Person).PrintPersons()
/// 	
/// 	DO ##class(%SYS.PTools.Stats).Stop("Samples","Test","Part 2")
/// 	DO ##class(%SYS.PTools.Stats).Stop("Samples","Test","Full Routine")
/// 	QUIT
/// 
/// </example>
Class %SYS.PTools.Stats Extends %Persistent [ System = 4 ]
{

/// <p>Contains the NameSpace and Routine these stats are for
/// The format is NameSpace|RoutineName
/// 
/// This is not used in the %SYS.PTools.SQLStats class
/// 
Property RoutineInfo As %String;

/// Sections of the SQL statement, these should match up the the Module names in the Query Plan output
/// 
/// When used with this class it can be used to distinguish block of code within a give routine
/// this will default to 1 if nothing is provided
/// 
Property ModuleName As %String [ SqlColumnNumber = 6 ];

/// This is the number of times the query has been run since the last compile.
/// 
Property Counter As %Integer [ SqlColumnNumber = 5 ];

/// How many rows did the query return for this run
/// Used only by Sub class
/// 
Property RowCount As %Integer [ SqlColumnNumber = 7 ];

/// How many global references were done in this Module for the given query
/// the Modules are nested and the count for the outer ones is cumulative
/// 
Property GlobalRefs As %Integer [ SqlColumnNumber = 8 ];

/// How many lines of COS code were executed in this Module for the given query
/// the Modules are nested and the count for the outer ones is cumulative
/// 
Property LinesOfCode As %Integer [ SqlColumnNumber = 9 ];

/// Number of Milliseconds spent waiting for Disk reads in this Module for the given query
/// the Modules are nested and the count for the outer ones is cumulative
/// 
Property DiskWait As %Integer [ SqlColumnNumber = 18 ];

/// How much time was spent in this Module for the given query
/// the Modules are nested and the count for the outer ones is cumulative
/// 
Property TotalTime As %Float [ SqlColumnNumber = 10 ];

/// How much time was spent finding the first row
/// This is only set for Module Main
/// 
Property TimeToFirstRow As %Numeric;

/// TimeStamp of when the query was run
/// 
Property StartTime As %TimeStamp [ SqlColumnNumber = 11 ];

/// Cache UserName of the person who ran this query
/// 
Property UserName As %String [ InitialExpression = {$UserName}, SqlColumnNumber = 12 ];

/// IP Address of the machine that ran this query
/// 
Property IPAddress As %String [ SqlColumnNumber = 13 ];

/// Name of the machine that ran this query
/// 
Property MachineName As %String [ SqlColumnNumber = 14 ];

/// Name of the executable that ran this query
/// 
Property ExeName As %String [ SqlColumnNumber = 15 ];

/// OS level Process ID
/// 
Property Pid As %String [ SqlColumnNumber = 17 ];

/// Number of times we entered this module for the run of the query
/// Used only by Sub class
/// 
Property ModuleCount As %String [ SqlColumnNumber = 16 ];

/// called to start the counters for gather stats
/// 
ClassMethod Start(NS As %String, Rou As %String, Mod As %String = 1)
{
	
	k %SQLStats(NS,Rou,Mod)
	s %SQLStats("StartTime",NS,Rou,Mod)=$ZDATETIME($H,3,1)
	s %SQLStats(NS,Rou,Mod,"Stime")=$ZH
	s pid=$j
	&sql(SELECT CommandsExecuted,GlobalReferences 
	     INTO :LoC,:GRefs 
	     FROM %SYS.ProcessQuery 
	     WHERE Pid = :pid)
 	s %SQLStats(NS,Rou,Mod,"Sline")=LoC
 	s %SQLStats(NS,Rou,Mod,"Sglo")=GRefs
}

/// Called to stop the counter for gather stats
/// INSERT a row into %SYS_PTools.Stats table
/// 
ClassMethod Stop(NS As %String, Rou As %String, Mod As %String = 1)
{
	s pid=$j
	&sql(SELECT CommandsExecuted,GlobalReferences, ClientIPAddress, ClientNodeName, ClientExecutableName 
	     INTO :LoC,:GRefs,:IPAddress, :NodeName, :ExeName 
	     FROM %SYS.ProcessQuery 
	     WHERE Pid = :pid)
	s %SQLStats(NS,Rou,Mod,"Etime")=$ZH
 	s %SQLStats(NS,Rou,Mod,"Eline")=LoC
 	s %SQLStats(NS,Rou,Mod,"Eglo")=GRefs
 	s Tglo=$s($g(%SQLStats(NS,Rou,Mod,"Sglo"))="":0,1:(%SQLStats(NS,Rou,Mod,"Eglo")-%SQLStats(NS,Rou,Mod,"Sglo")))
 	s Tline=$s($g(%SQLStats(NS,Rou,Mod,"Sline"))="":0,1:(%SQLStats(NS,Rou,Mod,"Eline")-%SQLStats(NS,Rou,Mod,"Sline")))
 	s Ttime=$s($g(%SQLStats(NS,Rou,Mod,"Stime"))="":0,1:(%SQLStats(NS,Rou,Mod,"Etime")-%SQLStats(NS,Rou,Mod,"Stime")))
 	s id=NS_"|"_Rou
 	s ST=%SQLStats("StartTime",NS,Rou,Mod)
 	s Counter=$I(^%SYS.PTools.Stats(NS,Rou,Mod))
 	
 	&SQL(INSERT INTO %SYS_PTools.Stats 
 	(RoutineInfo,ModuleName,StartTime,Counter,TotalTime,LinesOfCode,GlobalRefs,IPAddress,MachineName,ExeName) 
 	VALUES 
 	(:id, :Mod, :ST, :Counter, :Ttime, :Tline, :Tglo, :IPAddress, :NodeName, :ExeName))
 	k %SQLStats(NS,Rou,Mod)
	k %SQLStats("StartTime",NS,Rou,Mod)
}

/// Generates a comma delimited file containing the data from the %SYS_PTools.Stats table
/// By default the file will be created in the mgr directory of the Cache Instantance
/// You can pass in a value for FileName if you want to override the default
/// 
ClassMethod Report(FileName = "")
{
	set LogDir=$zu(12),version = "Statsv02",config=$p($zu(86),"*",2),fdate=$zd($h,8),ftime=$tr($zt($p($h,",",2)),":","")
	
	set LogDir=$zu(12)
	set fname=$zu(54,0)_"_"_config_"_"_fdate_"_"_ftime_".Stats"
	set LogFile=$s(FileName="":LogDir_fname,1:FileName)
	w !,"Creating Report in file:  ",LogFile
	open LogFile:"NWS":5 ; need a recover for open failure
	if '$T use 0 write !,"unable to open logfile - exiting",! quit 
	set eof=$zu(68,40,1) ; get current eof behaviour (and set to our needs)
	do ..LogHeader(LogFile,version)
	&SQL(DECLARE stats cursor for
	     SELECT RoutineInfo, ModuleName, Counter, StartTime, GlobalRefs, LinesofCode, TotalTime, UserName, MachineName, IPAddress, EXEName
	     INTO :RouInfo, :Mod, :Counter, :ST, :GRefs, :LoC, :TTime, :User, :Machine, :IP, :Exe
	     FROM %SYS_PTools.Stats)
	&SQL(OPEN stats)
	f  {
		&SQL(FETCH stats)
		Q:SQLCODE'=0
        s NS=$P(RouInfo,"|",1),Rou=$P(RouInfo,"|",2)
		d ..LogSave(NS,Rou,Mod,Counter,ST,GRefs,LoC,TTime,User,Machine,IP,Exe,LogFile)
	}   
	u LogFile w !,"</Stats>"
	c LogFile
	&SQL(CLOSE stats)
}

/// This is the header row that will be in the output file.  The columns should be comma delimited
ClassMethod LogHeader(File, version)
{
	u File 
	w !,File," , ",version
	w !,"<Stats>"
	w !,"NameSpace, Routine, Module, Counter, Start Time, Global Refs, Lines of Code, Total Time, User Name, Machine Name, IP Address, EXE Name"
	QUIT
}

ClassMethod LogSave(NS, Rou, Mod, Counter, ST, Grefs, LoC, TTime, User, Machine, IP, Exe, LogFile)
{
	U LogFile
	w !
	w NS,", "						; Current NameSpace
	w Rou,", "						; Routine Name
	w Mod,", "						; Name of Code Block with a Routine
	w Counter,", "					; Number of time this Code Block was called
	w ST,", "						; Code Block Start Time
	w $g(Grefs,"NULL"),", "			; Number of Global References made
	w $g(LoC,"NULL"),", "			; Number of line of COS code run
	w $g(TTime,"NULL"),", "			; Time to run the Code Block
	w User,", "						; Cache User Name for this Process
	w Machine,", "					; Machine Name For this Connection
	w IP,", "						; Ip Address of the local machine for this Connection
	w Exe,", "						; Exe name that produced this query
}

Storage Default
{
<Data name="StatsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModuleName</Value>
</Value>
<Value name="3">
<Value>Counter</Value>
</Value>
<Value name="4">
<Value>RowCount</Value>
</Value>
<Value name="5">
<Value>GlobalRefs</Value>
</Value>
<Value name="6">
<Value>LinesOfCode</Value>
</Value>
<Value name="7">
<Value>TotalTime</Value>
</Value>
<Value name="8">
<Value>StartTime</Value>
</Value>
<Value name="9">
<Value>UserName</Value>
</Value>
<Value name="10">
<Value>IPAddress</Value>
</Value>
<Value name="11">
<Value>MachineName</Value>
</Value>
<Value name="12">
<Value>ExeName</Value>
</Value>
<Value name="13">
<Value>ModuleCount</Value>
</Value>
<Value name="14">
<Value>NameSpace</Value>
</Value>
<Value name="15">
<Value>RoutineInfo</Value>
</Value>
<Value name="16">
<Value>TimeToFirstRow</Value>
</Value>
<Value name="17">
<Value>Pid</Value>
</Value>
<Value name="18">
<Value>DiskWait</Value>
</Value>
</Data>
<DataLocation>^%SYS.PTools.StatsD</DataLocation>
<DefaultData>StatsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^%SYS.PTools.StatsD</IdLocation>
<IndexLocation>^%SYS.PTools.StatsI</IndexLocation>
<StreamLocation>^%SYS.PTools.StatsS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
