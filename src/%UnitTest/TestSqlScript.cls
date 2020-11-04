/// Adds methods to test an SQL script.
/// <br><br>
///  <b>Summary</b>: To test SQL code, you will:
///  <ol>
///  <li>
///  Create a namespace, a database, and create a dataset.  
///  <br><br><li>
///  Populate the new database from the dataset.
///  <br><br><li>
///  Create a test file that contains SQL select statements that test your feature.
///  <br><br><li>
///  Run the test file to produce a reference file (using the <b>"reference"</b> argument).
///  <br><br><li>
///  Add methods to your test file that
///  <ol type = "a"><br><li>
///  Clear the database and populate the database from the dataset. 
///  <br><li>
///  Produce results to <b>output.log.</b>
///  <br><li>
///  Compare <b>output.log</b> to <b>reference.log</b>, and 
///  <br><li>
///  Report whether the two files are the same (Passed) or different (Failed).
///  <br><br> 
///   </ol></ol>
///  Each time that you run this test, your database always begins from a consistent, known state.  
///  <br><br><b>Procedure</b><br><br>
///  <i>(Note: This procedure is under construction.)</i><br><br>
/// To set up a namespace, a database, and a dataset:
///  <ol>
///  <li>
///  Create a namespace and a database called <b>UT</b>.
///  <br><br><li>
///  Create a class, such as <b>dev.xyz.classname</b>, where <b>dev.xyz</b> matches perforce directory structure, 
///  such <b>dev.sql.Query</b> or <b>dev.obj</b>. (Note that, within your test, you will specify this name with underscores, as 
///  <b>dev_xyz.classname</b>).  
///  <br><br><li>
///  Set this class to extend <b>%Populate</b> and <b>%XML.Adapter</b>. 
///  <br><br><li>
///  Open a Cache terminal, change to the <b>UT</b> namespace and populate this class with sufficient data with the Populate utility.<br>
///  <pre>
///  zn "ut"
///  do ##class(UT.classname).Populate(100)
///  </pre>
///  <li>
///  In Studio, select <b>Tools > Export</b>. Select <b>Add</b> and the <b>UT.classname.cls</b> to an XML file <b>data.xml</b> in <b>dev.xyz</b>.
///  
/// </ol>
/// To create a test that compares a file called <b>output.log</b> to a file called <b>reference.log</b>.
/// <br>
/// 
/// <ol>
/// <li>
/// Create a new class that extends <b>TestSqlScript</b> called, for example, <b>TestSqlScriptX</b> and link it to the sccs.
/// <br><br><li>
/// Put it in the <b>dev.xyz</b> directory. [Susan - however this works best]
///  
/// <br><br><li>
/// Add instance methods to the new class.
/// <oltype="a">First clear the database and repopulate the database from the <b>data.xml</b> file:
///  <pre>Method OnBeforeAllTests
///       delete * from dev_xyz.classname
///       import data.xml
///  [find a statement to import the XML]
///  </pre>
///  Now the database is in a consistent known state.
///   
///  
///  Method Test<i>devlog-id</i>
///  [how to automatically take from the devlog what we need or put the URL in the comment]
///  
///  
///  
/// <br><br><li>Create a file called <b>script.txt</b> in your test directory, containing only SQL select code you want to test, such as the following.  
///  Note that the four pound signs (####) is a command delimiter.  This is needed since it is not unusual for SQL statements to be longer than a single line.
/// <pre>
/// select max(SSN) from Sample.Person
/// ####
/// select count(ID) from Sample.Person
/// ####
/// </pre>
/// <br><li>Run the test.
/// <br><br><code>
/// d ##class(%UnitTest.Manager).RunTest()</code>
/// <br><br>
/// Each line of SQL in <b>script.txt</b> is executed and command output is written to <b>output.log</b> until the end of file in <b>script.txt</b> is reached. <b>output.log</b> is compared  to  <b>reference.log</b>.  
/// The first time that you run the test, you get an error because the <b>reference.log</b> file doesn't yet exist.
/// <br><br>
/// <li>Check that the contents of new <b>output.log</b> file are correct. <br><br>
/// <li>If they are, create a <b>reference.log</b> file that will be used in future runs of this test by copying <b>output.log</b> and to <b>reference.log</b>.  Now your two files match.
/// <br><br>
/// <li>Run the test again
/// <br><br><code>
/// d ##class(%UnitTest.Manager).RunTest()</code><br><br>
/// This time the test passes.
/// </ol>
/// 
/// Every time you run your test the new output is written to <b>output.log</b>. <b>output.log</b> is compared to <b>reference.log</b>. 
/// If the files match, the test passes. If the files do not match, the test fails. 
/// If the output changes, you need to update the <b>reference.log</b> file. 
/// 
Class %UnitTest.TestSqlScript Extends %UnitTest.TestScript [ System = 3 ]
{

/// Set <PARAMETER>SHOWPLAN</PARAMETER>=1 to dump the access plans used by each test in the test script.
/// Use this feature when you need to verify plan stability from one release to the next, or when you
/// want to investigate the impact of creating, dropping, or altering an index.
/// 
Parameter SHOWPLAN;

/// <PARAMETER>DISPLAYTESTNAME</PARAMETER> enables you to internationalize the display of the test name,
/// which may be specified after the #### delimiter in the test file, when <PARAMETER>TIMESCALE</PARAMETER> 
/// is a positive number.
/// 
Parameter DISPLAYTESTNAME = "Test ";

/// The <PARAMETER>TIMESCALE</PARAMETER> parameter enables you to control whether elapsed time information
/// is displayed for each SQL statement, and the number of significant digits used to display the time.  
/// This can be used to determine whether significant differences in elapsed time are consumed by any
/// individual query.  By default, TIMESCALE="", which will prevent elapsed time information from being
/// displayed at the end of each SQL statement in the test.  Setting DISPLAYSECONDS to 1 will display the result 
/// in seconds.  Setting DISPLAYSECONDS to 10 will display elapsed time in multiples of 10 seconds.  Setting
/// TIMESCALE to 0.1 will display elapsed time to the nearest tenth second.  By grouping together a set of
/// tests that each take about the same amount of time you can automate the process of determining if any
/// query takes "significantly" more or less time than it did previously.
/// 
Parameter TIMESCALE;

/// <PARAMETER>DISPLAYELAPSEDTIME</PARAMETER> enables you to internationalize the display of elapsed time,
/// when <PARAMETER>TIMESCALE</PARAMETER> is a positive number.
/// 
Parameter DISPLAYELAPSEDTIME = " executed and fetched in ";

/// <PARAMETER>DISPLAYSECONDS</PARAMETER> enables you to internationalize the spelling of "seconds" in
/// the output of elapsed time when <PARAMETER>TIMESCALE</PARAMETER> is a positive number.
/// 
Parameter DISPLAYSECONDS = "seconds";

Method OnBeforeAllTests() As %Status [ CodeMode = generator ]
{
 If %class="%UnitTest.TestSqlScript" Quit $$$OK
 ;
 If %parameter("DATAFILE")="" Quit $$$ERROR($$$GeneralError,"parameter 'DATAFILE' is not specified")
 ;
 Set correlationlist=%parameter("CORRELATIONLIST")
 If %parameter("DATATAG")'="" s correlationlist=correlationlist_","_%parameter("DATATAG")_":"_%parameter("DATACLASS")
 If $e(correlationlist)="," Set correlationlist=$e(correlationlist,2,*)
 ;
 For i=1:1:$l(correlationlist,",") Do
 . Set tag=$p($p(correlationlist,",",i),":",1),class=$p($p(correlationlist,",",i),":",2)
 . $$$GENERATE(" Do ##class("_class_").%DeleteExtent()")
 . $$$GENERATE(" Do ##class("_class_").%KillExtent()")
 ;
 $$$GENERATE(" Set reader = ##class(%XML.Reader).%New()")
 $$$GENERATE(" Set sc=reader.OpenFile(..Manager.CurrentDir_"""_%parameter("DATAFILE")_""")")
 $$$GENERATE(" If $$$ISERR(sc) Quit sc")
 ;
 For i=1:1:$l(correlationlist,",") Do
 . Set tag=$p($p(correlationlist,",",i),":",1),class=$p($p(correlationlist,",",i),":",2)
 . $$$GENERATE(" Do reader.Correlate("""_tag_""","""_class_""")")
 ;
 $$$GENERATE(" For  Quit:reader.Next(.object,.sc)=0  Set sc=object.%Save() If $$$ISERR(sc) Quit")
 $$$GENERATE(" Quit sc")
 Quit $$$OK
}

ClassMethod runScript(scriptfile As %String, outputfile As %String) As %Status
{
 Open scriptfile:"r":1 Else  Quit $$$ERROR($$$FileCanNotOpen,scriptfile)
 if (outputfile'="") {
      if ($zv["OpenVMS") {Open outputfile:"WS"}
      else {Open outputfile:"NWS"}
 }
 else {
      Close scriptfile
      Quit $$$ERROR($$$FileCanNotOpen,outputfile)
 }
 Set $ZT="scriptEOF"
 For  Do
 . Set sql="" For  Use scriptfile Read line  Quit:$e(line,1,4)="####"  Set sql=sql_" "_line
 . Use 0 Use:outputfile'="" outputfile
 . Write "SQL>",sql,!
 . Do ..runSqlStatement(sql, $e(line,5,*))
 . Write !
scriptEOF ;
 Set $ZT=""
 Close scriptfile
 Close:outputfile'="" outputfile
 Quit $$$OK
}

ClassMethod runSqlStatement(sql As %String, testName As %String)
{
 Set rs=##class(%ResultSet).%New() If rs=$$$NULLOREF Do DisplayError^%apiOBJ($$$ERROR($$$GeneralError,"Can not create %ResultSet.")) Quit
 Set sc=rs.Prepare(sql) If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
 Set cc=rs.GetColumnCount()
 For i=1:1:cc Write rs.GetColumnName(i),":"
 Write !
 Set startTime = $zh
 Set sc=rs.Execute()  If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
 While ( rs.Next(.sc) ) 
 {	Quit:$$$ISERR(sc)
 	For i=1:1:cc Write rs.GetData(i),":"
 	Write !
 }
 If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
 Set $ZT="scriptCloseFiles"
 If ..#TIMESCALE>0 { s elapsedTime=($zh-startTime) s elapsedTime=..#DISPLAYELAPSEDTIME_((elapsedTime+(..#TIMESCALE/2)\..#TIMESCALE)*..#TIMESCALE)_" "_..#DISPLAYSECONDS } else { s elapsedTime="" }
 If ((testName'="") || (elapsedTime'="")) { Write !,$s(testName'="":..#DISPLAYTESTNAME_testName,1:""),elapsedTime }
scriptCloseFiles ;
 If ..#SHOWPLAN 
 {
	Write !
	New %plan
	Set sqlArr(1)=sql,sqlArr=1
	Do ShowPlan^%apiSQL(.sqlArr,1,1) 
	For i=1:1:%plan { Write %plan(i), ! } Write !
 }
 Quit
}

}
