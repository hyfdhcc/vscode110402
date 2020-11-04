/// This class contains convenient methods for running Java programs.
/// 
/// If the java executable on the system path is acceptable, then you can
/// leave the java home setting in sys mgmt portal blank.  Otherwise you
/// should set it to the root directory of a supported JDK installation.
/// On Windows, if more than one JDK is installed, you should always set 
/// the java home setting.
/// To test by hand if the java home setting is correct, type this in
/// a terminal window:
/// <tt>w&nbsp;##class(%RunJava).getJDK(.sc,,$g(^%SYS("sql","sys","Java Home")))</tt><br>
/// <tt>w sc</tt><br>
/// The second result is '1' if the configured JDK is supported.
/// <p>
/// On Solaris, the standard java program is a 32-bit executable.
/// The use64Bit argument is only used on Solaris, and 
/// the 64-bit java executable is only chosen if it is installed.
/// </p>
Class %Library.RunJava Extends %Library.RegisteredObject [ System = 4 ]
{

Property JavaDebug As %Boolean [ InitialExpression = "0" ];

Property JavaDebugPort As %String(TRUNCATE = 1) [ InitialExpression = "8000" ];

Property JavaDebugSuspend As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",y,n") [ InitialExpression = "n" ];

/// Java debugging parameters:
/// (see http://java.sun.com/j2se/1.3/docs/guide/jpda/conninv.html#Xrunjdwp)
/// 
/// -Xdebug						Enable debugging
/// -Xnoagent					Disables oldjdb support
/// -Djava.compiler=NONE		Disable JIT compiler
/// -Xrunjdwp:					JDWP Options
/// 	transport=dt_socket,	- Use TCP/IP
/// 	address=8000,			- Listen on port 8000
/// 	suspend=y,				- Suspend the Java process until the debugger connects
/// 	server=y				- Listen for incoming debugger connection
Parameter JAVADEBUG As %String = "-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=${JavaDebugPort},suspend=${JavaDebugSuspend},server=y";

ClassMethod JavaHome() As %String
{
	q ^%SYS("sql","sys","Java Home")
}

/// Count the number of occurences of a delimiter in a string	
ClassMethod Occurs(str As %String = "", del As %String = "", start As %Integer = 0) As %Integer [ Private ]
{
	s ocnt=0, strlen=$l(str)
	
	q:(start>=strlen) ocnt
	
	while(start<=strlen) {
		s start=$f(str,del,start)
		q:start=0
		if start'=0 s ocnt=ocnt+1
	}
	
	q ocnt
}

/// Returns the path to the CacheDB.jar file corresponding to the version.
/// The version is returned by getJDK().
/// if jdk is null, returns path to the CacheDB.jar file in the lib subdirectory.  This 
/// jar file is used by default for Java Gateway.
ClassMethod getCacheDbJarPath(jdk As %String = "") As %String
{
  if ((jdk'="JDK17") && (jdk'="JDK18")) q ""
  if (jdk="") {
    q ##class(%Library.File).NormalizeFilename($system.Util.InstallDirectory() _ "lib/cachedb.jar")
  } else {
    q ##class(%Library.File).NormalizeFilename($system.Util.InstallDirectory() _ "dev/java/lib/"_jdk_"/cachedb.jar")
  }
}

/// Test JDK directory to see if it contains a valid JDK.
/// Returns version information in jv
ClassMethod existJava(ByRef jv As %String = "", javaHome As %String = "") As %Status
{
	s exists=0
	s javaver = """"_..FindJava(javaHome)_""" -version 2>&1"
	s oldio = $IO
	try {
	open "|CPIPE|":javaver:"RQ"
	use "|CPIPE|"
	read javaln
	read javaln2
	use oldio
	if ((javaln["java version")&&(javaln2'["GNU")) {s exists=1}
	close "|CPIPE|"}
	catch{
		use oldio
	}
	s jv=$g(javaln)
	if exists q $$$OK
	q $$$ERROR($$$InvalidArgument, javaHome)
}

/// Returns the version string for the given JDK, for example: "JDK16"
ClassMethod getJDK(ByRef sc As %Status, ByRef jv As %String = "", javaHome As %String = "") As %String
{
	s sc=$$$OK
	if jv="" s sc=..existJava(.jv, javaHome)
	q:'$$$ISOK(sc) sc
	
	s start=0,end=0
	;expect jv to have version in quotes like: java version "1.7.0_01"
	s start=$f(jv,"""")
	if start>0 {
		set end=$f(jv,"""",start)
	}
	else {
		;try the quotes are missing
		s start=$f(jv,"java version ")
		if start>0 s end=$l(jv)+2
	}
	if end>0 {
		s jver=$e(jv,start,end-2)
	 	s dots=..Occurs(jver,".")
	 	s dots=$s(dots<3:dots,1:2)
	 	s jdk="JDK",spot=1
	 	f i=1:1:dots {
		 	s jdk=jdk_$e(jver,spot,$f(jver,".",spot)-2)
		 	s spot=$f(jver,".",spot)
	 	}
	 	// check for valid JDK
		if ($e(jdk,4,5)<17)||($e(jdk,4,5)>18)  { set sc=$$$ERROR($$$BadJavaVersion,"1.7","1.8",$e(jdk,4)_"."_$e(jdk,5)) }
	 	q jdk
	}
	else {
		s sc=$$$ERROR($$$InvalidArgument, javaHome)
		q ""
	}
}

/// Returns the command string necessary to run the java program.
ClassMethod GetJavaCmd(pJavaHome As %String = "", pClassPath As %String = "", pJVMArgs As %String = "", pDebug As %Boolean = 0, pClass As %String, pArgs As %String = "", jdk As %String = "", debugPort As %String = "8000", debugSuspend As %Boolean = 0, use64Bit As %Boolean = 0) As %String
{
	// disable internal java signal handling
	Set tJava = """"_..FindJava(pJavaHome, use64Bit)_""" ""-Xrs""" 
	
	// add debug parameters
	If pDebug Set tJava = tJava_" "_..JavaDebugParams(debugPort, debugSuspend)
	
	// Add any JVM arguments
	If pJVMArgs'="" Set tJava=tJava_" "_pJVMArgs

	// add the classpath
	Set tCP=""
	// use CacheDB.jar if no classpath
	if pClassPath="" s tCP=""""_..getCacheDbJarPath(jdk)_""""
	If pClassPath'="" s tCP=""""_pClassPath_""""
	Set tJava=tJava_" ""-classpath"" "_tCP

	// Add the classname and finally the args
	Set tJava=tJava_" """_pClass_""""
	If pArgs'="" Set tJava = tJava_" "_pArgs
	
	q tJava
}

/// Spawns the java program as a separate process.
ClassMethod RunJava(pJavaHome As %String = "", pClassPath As %String = "", pJVMArgs As %String = "", pDebug As %Boolean = 0, pClass As %String, pArgs As %String = "", jdk As %String = "", debugPort As %String = "8000", debugSuspend As %Boolean = 0, use64Bit As %Boolean = 0) As %String
{
	Set tSC=$$$OK

	Set tCmd=..GetJavaCmd(pJavaHome, pClassPath, pJVMArgs, pDebug, pClass, pArgs, jdk, debugPort, debugSuspend, use64Bit)
	if $$$isWINDOWS s tCmd=""""_tCmd_""""
	If $ZF(-2,tCmd,"","",1)'=0 Set tSC=$$$ERROR($$$FileCanNotOpen,tJava)
	Quit tSC
}

/// Returns the printed output of the java program as a string, using ReadProgramOutput.
ClassMethod ReadJavaOutput(pJavaHome As %String = "", pClassPath As %String = "", pJVMArgs As %String = "", pDebug As %Boolean = 0, pClass As %String, pArgs As %String = "", jdk As %String = "", debugPort As %String = "8000", debugSuspend As %Boolean = 0, use64Bit As %Boolean = 0) As %String
{
	q ..ReadProgramOutput(..GetJavaCmd(pJavaHome, pClassPath, pJVMArgs, pDebug, pClass, pArgs, jdk, debugPort, debugSuspend, use64Bit))
}

/// Returns the printed output of the program as a string.
/// Intended only for fast-running programs that generate relatively
/// small amounts of output.
ClassMethod ReadProgramOutput(tCmd As %String) As %String
{
	s tCmd=tCmd_" 2>&1"

	if $$$isWINDOWS s tCmd=""""_tCmd_""""
	set retval=""
	s eof=$SYSTEM.Process.SetZEOF(1)
	s oldio = $IO
	open "|CPIPE|":tCmd:"RQ"
	use "|CPIPE|"
	while 1 {
	  read javaln
	  if ($ZEOF=-1) q
	  s retval=retval_javaln_$CHAR(13)_$CHAR(10)
	}
	use oldio
	close "|CPIPE|"
	d $SYSTEM.Process.SetZEOF(eof)
	q retval
}

ClassMethod JavaDebugParams(debugPort As %String = "8000", debugSuspend As %Boolean = 0) As %String [ Private ]
{
	s ds="n"
	if debugSuspend s ds="y"
    q """-Xdebug"" ""-Xnoagent"" ""-Djava.compiler=NONE"" ""-Xrunjdwp:transport=dt_socket,address="_debugPort_",suspend="_ds_",server=y"""
}

/// Locate the java executable for a given JAVA_HOME
ClassMethod FindJava(pJavaHome As %String = "", use64Bit As %Boolean = 0) As %String
{
	if (use64Bit && $G(pJavaHome)'="" && ($zv [ "Solaris")) {
		s arch="sparcv9"
		if ($zv [ "x86-64") s arch="amd64"
		s tJava= pJavaHome_"/bin/"_arch_"/java"
		if (##class(%File).Exists(tJava)) {
			q tJava
		}
	}
	Set tJava = ""
	If $G(pJavaHome)'="" {
		Set tJava = ##class(%File).SubDirectoryName(pJavaHome,"bin")
	}
	Set tJava = $G(tJava)_$S($$$isWINDOWS&($g(tJava)=""):"java.exe",$$$isWINDOWS:"\java.exe",$$$isVMS:"java.exe",($g(tJava)=""):"java",1:"/java")
	Quit tJava
}

}
