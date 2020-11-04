/// Extends <b>TestScript</b>.  Adds methods to test ObjectScript code.
/// <br><br>
/// This class compares a file called <b>output.log</b> to a file called <b>reference.log</b>.
/// <br>
/// 
/// <ol>
/// <li>Create a new class that extends <b>TestCacheScript</b> called, for example, <b>TestCacheScriptX</b> and export it to your test directory. <br><br>
/// <li>Create a file called <b>script.txt</b> in your test directory, containing ObjectScript code you want to test. Here's an example:
/// <pre>
/// w "abc"
/// w $p("abc,xyz",",",Z)
/// </pre>
/// <li>Run the test.
/// <br><br><code>
/// d ##class(%UnitTest.Manager).RunTest("dirname",,"reference")</code>
/// <br><br>
/// Each line of code in <b>script.txt</b> is executed and command output is written to <b>reference.log</b> until the end of file in <b>script.txt</b> is reached.  
/// The first time that you run the test, set the third argument as <b>"reference"</b> (lowercase and in double quotes) to create a <b>reference.log</b> file. (Use <b>"screen"</b> as the third argument to display output on the screen.) Check that the contents of new <b>reference.log</b> file are correct. 
/// <br><br>
/// <li>Run the test again
/// <br><br><code>
/// d ##class(%UnitTest.Manager).RunTest("dirname")</code><br><br>
/// </ol>
/// 
/// Every time you run your test the new output is written to <b>output.log</b>. <b>output.log</b> is compared to <b>reference.log</b>. 
/// If the files match, the test passes. If the files do not match, the test fails. 
/// If the output changes, you need to update the <b>reference.log</b> file. 
/// 
/// Note that, in Intersystems, the default test directory is <b>U:/internal/testing/unit_tests</b>
/// 

Class %UnitTest.TestCacheScript Extends %UnitTest.TestScript [ System = 3 ]
{

ClassMethod runScript(scriptfile As %String, outputfile As %String)
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
 . Use scriptfile Read command
 . Use 0 Use:outputfile'="" outputfile
 . Write "COS>",command,!
 . Xecute command
 . Write !
scriptEOF ;
 Set $ZT=""
 Close scriptfile
 Close:outputfile'="" outputfile
 Quit $$$OK
}

}
