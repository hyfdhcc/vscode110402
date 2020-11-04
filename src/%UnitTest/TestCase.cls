Include %outUnitTest

/// Extend this class to create new test case classes. In the test case class, for each test that you want to run, create a method whose name begins with <b>Test</b>. You'll use <b>%UnitTest.Manager.RunTest</b> to run all tests in a specified directory.  
/// <br><br>
/// <b>TestCase</b> provides <b>$$$Assert*</b> macros that can be used to test conditions (located in the file <B>%outUnitTest.INC</B>).  The <b>$$$Assert*</b> macros call their associated methods automatically. A test fails if one or more of the macros fails, otherwise the test passes.
/// <br><br>
/// Click a method to go to the description of its macro:<br>
/// <br><method>AssertTrueViaMacro</method>
/// <br><method>AssertNotTrueViaMacro</method>
/// <br><method>AssertEqualsViaMacro</method>
/// <br><method>AssertNotEqualsViaMacro</method>
/// <br><method>AssertStatusOKViaMacro</method>
/// <br><method>AssertStatusNotOKViaMacro</method>
/// <br><method>AssertFilesSameViaMacro</method>
/// <br><method>AssertFilesSQLUnorderedSameViaMacro</method>
/// <br><method>AssertSuccessViaMacro</method>
/// <br><method>AssertFailureViaMacro</method>
/// <br><method>AssertSkippedViaMacro</method>
/// <br><br>
/// Use the <B>OnBefore*</B> methods to perform tasks before all test cases or before each test case.<br>
/// Use the <B>OnAfter*</B> methods to perform tasks after all test cases or after each test case.
/// <br><br>
/// You might use <B>OnBefore*</B> and <B>OnAfter*</B> to, for example, set environment 
/// variables before tests and unset them after tests or load files before tests and delete 
/// files after tests.
///  <br><br>
/// Click a method to go to the description:
/// <br>
/// <br><method>OnBeforeAllTests</method>
/// <br><method>OnBeforeOneTest</method>
/// <br><method>OnAfterAllTests</method>
/// <br><method>OnAfterOneTest</method>
/// <br><br>
///  Note: In your test class, do not use property names that begin with <b>Test</b>, as the auto-generated Get and Set methods corresponding to the properties would also begin with <b>Test</b>, and, thus, be treated as test methods.
///  
///  
Class %UnitTest.TestCase Extends %RegisteredObject [ System = 3 ]
{

/// Pointer to the %UnitTest.Manager object
Property Manager As %UnitTest.Manager [ Private ];

/// Use the <b>/debug</b> flag with <b>%UnitTest.Manager.RunTest</b> to break into debug mode on the first failure. 
Property Debug As %Boolean [ InitialExpression = 0 ];

/// The SkipTest property gets set when a test is being skipped.  It will be handled by the <b>%UnitTest.Manager</b> to handle
/// skipping tests from OnBeforeOneTest.  <b>NOTE:</b> OnBeforeAllTests does not currently support skipping tests.
Property SkipTest As %Boolean [ InitialExpression = 0 ];

/// Run by the <B>%New</B> method to provide notification that a new instance of an object 
/// is being created. Passes initialization information to a new instance of the object.
/// <br><br>If this method returns an error then the object is not created. 
/// <br>It is passed the arguments provided in the <B>%New</B> call. There may be up to 
/// ten of these arguments, <I>p1...p10</I>. 
/// 
Method %OnNew(initvalue) As %Status
{
 Set r%Manager=initvalue
 Quit $$$OK
}

/// Run by <B>RunTest</B> once <a href="#OnBeforeAll">before any test methods</a> in the test class are run. Can be used to set up a 
/// test environment that will be later cleaned up by <B>OnAfterAllTests</B>. 
/// <br><br>Example: Setup and Cleanup of an environment: 
/// <pre>
/// Method OnBeforeAllTests() As %Status
/// {
/// 	//do setup stuff here
///  	set ^inputMessage = "input message"
/// 	quit $$$OK
/// }
/// Method OnAfterAllTests() As %Status
/// {
/// 	//do clean up stuff here
/// 	kill ^inputMessage
/// 	quit $$$OK
/// }</pre>
/// 
Method OnBeforeAllTests() As %Status
{
 Quit $$$OK
}

/// Run by <B>RunTest</B> once after all test methods in the test class are run. Can be used to tear down a test environment that was set up by <B>OnBeforeAllTests</B> See example in <b>OnBeforeAllTests</b>. 
Method OnAfterAllTests() As %Status
{
 Quit $$$OK
}

/// Run by <B>RunTest</B> immediately before each test method in the test class is run.<br>
/// <dl>
/// <dt><i>testname</i>
/// <dd>Name of the test to be run. Required. 
/// </dl> 
Method OnBeforeOneTest(testname As %String) As %Status
{
 Quit $$$OK
}

/// Run by <B>RunTest</B> immediately after each test method in the test class is run.<br>
/// <dl>
/// <dt><i>testname</i>
/// <dd>Name of the test to be run. Required. 
/// </dl> 
Method OnAfterOneTest(testname As %String) As %Status
{
 Quit $$$OK
}

///  Returns true if two values <a NAME="AssertEquals">are equal. Invoke with the <B>$$$AssertEquals</B> macro, in the form 
/// <pre>
/// $$$AssertEquals(<i>value1,value2,"description"</i>)</pre>
/// 
/// where:
/// <DL>
/// <dt><I>value1</I>,<I>value2</I> <dd>Values to be compared. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: <pre>
/// do $$$AssertEquals(x,y,"x equals y")</pre>
Method AssertEqualsViaMacro(autoquoted, value1, value2, description) As %Boolean
{
 Set manager=r%Manager
 Set success=value1=value2
 If '$data(description) {
 	Set description=..ParseAutoQuoted(autoquoted,"equals")
 	If 'success Set description=description_" was '"_value1_"'"
 }
 Do manager.LogAssert(success,"AssertEquals",description)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Returns true if expressions are <a NAME="AssertNotEquals">not equal. Invoke with the <b>$$$AssertNotEquals</b> macro in the form.
/// <pre>
/// $$$AssertNotEquals(<i>value1,value2,"description"</i>)</pre>
/// where:
/// <DL>
/// <dt><I>value1</I>,<I>value2</I> <dd>Values to be compared. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: <pre>
/// do $$$AssertNotEquals(x,y,"x is not equal to y")</pre>
Method AssertNotEqualsViaMacro(autoquoted, value1, value2, description) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,..ParseAutoQuoted(autoquoted,"equals"))
 Set success=value1'=value2
 Do manager.LogAssert(success,"AssertNotEquals",description)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Returns true if expression is <a NAME="AssertTrue">true. Invoke with the <b>$$$AssertTrue</b> macro in the form.
/// <pre>
/// $$$AssertTrue(<i>value, "description"</i>)</pre>
/// 
/// where:
/// <DL>
/// <dt><I>value</I> <dd>Expression to be evaluated. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: <pre>
/// do $$$AssertTrue(x=y,"Expression x=y is true")</pre>
Method AssertTrueViaMacro(autoquoted, value, description) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,..ParseAutoQuoted(autoquoted,"expr"))
 Set success=''value
 Do manager.LogAssert(success,"AssertTrue",description)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Unconditionally log a failure.
/// Invoke with the <b>$$$AssertFailure</b> macro in the form.
/// <pre>
/// $$$AssertFailure(<i>"message"</i>)</pre>
/// 
/// This assertion is intended to replace the convention of passing 0 to <b>$$$AssertTrue</b>.
/// It's useful when the condition is implicit (e.g., in a try block after an exception should have been thrown), and when you don't want to pollute the log with many successful assertions (e.g., in a loop).
Method AssertFailureViaMacro(message) As %Boolean
{
 Set manager=r%Manager
 Do manager.LogAssert(0,"AssertFailure",$g(message))
 Break:..Debug
 Quit 0
}

/// Unconditionally log success.
/// Invoke with the <b>$$$AssertSucccess</b> macro in the form.
/// <pre>
/// $$$AssertSucccess(<i>"message"</i>)</pre>
/// 
/// This assertion is intended to replace the convention of passing 1 to <b>$$$AssertTrue</b>.
Method AssertSuccessViaMacro(message) As %Boolean
{
 Set manager=r%Manager
 Do manager.LogAssert(1,"AssertSuccess",$g(message))
 Quit 1
}

/// An assertion to state that the test has been skipped for the reason described in the assertion's message
/// This would typically be used if the preconditions for the test have not been met.
/// After calling this assertion, you would typically would want to quit from the test method.
Method AssertSkippedViaMacro(message) As %Boolean
{
 Set manager=r%Manager
 Do manager.LogAssert(2,"TestSkipped",message)
 s ..SkipTest = 1
 Quit 1
}

/// Returns true if the expression is not true. Invoke with the <b>$$$AssertNotTrue</b> macro in the form.
/// <pre>
/// $$$AssertNotTrue(<i>value, "description"</i>)</pre>
/// 
/// where:
/// <DL>
/// <dt><I>value</I> <dd>Expression to be evaluated. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: <pre>
/// do $$$AssertNotTrue(x=y,"Expression x=y is not true")</pre>
Method AssertNotTrueViaMacro(autoquoted, value, description) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,..ParseAutoQuoted(autoquoted,"expr"))
 Set success='value
 Do manager.LogAssert(success,"AssertNotTrue",description)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Returns true if the status code is $$$OK. Invoke with the <B>$$$AssertStatusOK</B> macro in the form.
/// <pre>
/// $$$AssertStatusOK(<i>value, "description"</i>)</pre>
/// 
/// where:
/// <DL>
/// <dt><I>value</I> <dd>Expression that returns a status code. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: <pre>
/// set sc=##class(%Integer).IsValid("5")
/// do $$$AssertStatusOK(sc,"Status is OK")</pre>
Method AssertStatusOKViaMacro(autoquoted, status, description) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,..ParseAutoQuoted(autoquoted,"expr"))
 Set success=''$$$ISOK(status)
 If $$$ISERR(status) Do
 . Do $system.Status.DecomposeStatus(status,.errorarray,"-d")
 . Set description=description_" => "_$g(errorarray(1))
 Do manager.LogAssert(success,"AssertStatusOK",description)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Returns true if the status code is not a successful status code. Invoke with the <b>$$$AssertStatusNotOK</b> macro in the form.
/// <pre>
/// $$$AssertStatusNotOK(<i>value, "description"</i>)</pre>
/// 
/// where:
/// <DL>
/// <dt><I>value</I> <dd>Expression that returns a status code. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: <pre>
/// set sc=##class(%Integer).IsValid("$")
/// do $$$AssertStatusNotOK(sc,"Status is NotOK")</pre>
Method AssertStatusNotOKViaMacro(autoquoted, status, description) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,..ParseAutoQuoted(autoquoted,"expr"))
 Set success=$$$ISERR(status)
 Do manager.LogAssert(success,"AssertStatusNotOK",description)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Returns true if two statuses are equal. Invoke with the <b>$$$AssertStatusEquals</b> macro in the form.
/// <pre>
/// $$$AssertStatusEquals(<i>value1,value2,"description"</i>)</pre>
/// where:
/// <DL>
/// <dt><I>value1,value2</I> <dd>Expressions that return status codes. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example: This is extremely useful to verify an expected failure.
/// <pre>
/// s x=##class(Sample.Person).%New()
/// s sc=x.%Save()
/// s sc2=$system.Status.Error(5659,"Name")
/// d $$$AssertStatusEquals(sc,sc2,"Verify Name property requirement at %Save")
/// </pre>
Method AssertStatusEqualsViaMacro(autoquoted, value1, value2, description) As %Boolean
{
 Set $ztrap="StatusEqualsTrap"
 Set manager=r%Manager
 Set description=$g(description,..ParseAutoQuoted(autoquoted,"equals"))
 Set success=1
 Do {
	If (value1=1) && (value2=1) Quit
	If $extract(value1,1,2)'=$extract(value2,1,2) Set success=0 Quit
	Set value1=$extract(value1,3,$length(value1))
	Set value2=$extract(value2,3,$length(value2))
	If $listlength(value1)'=$listlength(value2) Set success=0 Quit
	For i=1:1:$listlength(value1) {
		Set err1=$list(value1,i)
		Set err2=$list(value2,i)
		For j=1:1:9 {
			If $listget(err1,j)'=$listget(err2,j) Set success=0 Quit
		}
		If success=0 Quit
	 }
 } While (0)
StatusEqualsExit  
 Do manager.LogAssert(success,"AssertStatusEquals",description)
 If success||'..Debug Quit success
 Break  Quit success
StatusEqualsTrap Set $ztrap=""
 Set success=0
 Goto StatusEqualsExit
}

/// Returns true if two files are identical. Invoke with the <b>$$$AssertFilesSame</b> macro  in the form.
/// <pre>
/// $$$AssertFilesSame(<i>file1,file2,"description"</i>)</pre>
/// where:
/// <DL>
/// <dt><I>file1,file2</I> <dd>Files to compare.  If no directory path is specified, the current UnitTest directory is used. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// </dl>
/// Example:
/// <pre>
/// do $$$AssertFilesSame(output.log,reference.log,"Comparing output.log to reference.log")
/// </pre>
Method AssertFilesSameViaMacro(autoquoted, file1, file2, description) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,"'"_file1_"'=='"_file2_"'")
 If ##class(%File).GetDirectory(file1)="" Set file1=manager.CurrentDir_file1
 If ##class(%File).GetDirectory(file2)="" Set file2=manager.CurrentDir_file2
 Set success=..IsFileSame(file1,file2,.diff)
 Do manager.LogAssert(success,"AssertFilesSame",description,diff)
 If success||'..Debug Quit success
 Break  Quit success
}

/// Returns true if two files containing SQL query results contain the same unordered results. Invoke with the <b>$$$AssertFilesSQLUnorderedSame</b> macro  in the form.
/// <pre>
/// $$$AssertFilesSQLUnorderedSame(<i>file1,file2,"description"</i>)</pre>
/// where:
/// <DL>
/// <dt><I>file1,file2</I> <dd>Files to compare.  If no directory path is specified, the current UnitTest directory is used. <br>
/// <dt><I>description</I> <dd>Optional comment shown on the results page.  If you don't include a description, the expression is used by default.
/// <dt><I>ignoreOrderBy</I> <dd>Optional boolean stating to ignore "order by" when determining whether results are ordered
/// <dt><I>skipPlan</I> <dd>Optional boolean stating to not include output from ShowPlan in diff.  This feature will be enabled by default if ^%SYS("HINT","%PARALLEL")=1 but off in any other cases
/// <dt><I>noheader</I> <dd>Optional boolean stating that there is no header in the SQL reference file
/// </dl>
/// Example:
/// <pre>
/// do $$$AssertFilesSQLUnorderedSame(output.log,reference.log,"Comparing output.log to reference.log")
/// </pre>
Method AssertFilesSQLUnorderedSameViaMacro(autoquoted, file1, file2, description, ignoreOrderBy = 0, skipPlan = "", noheader = 0) As %Boolean
{
 Set manager=r%Manager
 Set description=$g(description,"'"_file1_"'=='"_file2_"'")
 If ##class(%File).GetDirectory(file1)="" Set file1=manager.CurrentDir_file1
 If ##class(%File).GetDirectory(file2)="" Set file2=manager.CurrentDir_file2
 Set success=..IsFileSame(file1,file2,.diff)
 s sameMethod = "AssertFilesSQLOrderSame"
 if (success = 0) {
	 s success = ..IsFileOrderSame(file1,file2,.diff,ignoreOrderBy,skipPlan,noheader)
	 s sameMethod = "AssertFilesSQLUnorderSame"
 }
 Do manager.LogAssert(success,sameMethod,description,diff)
 If success||'..Debug Quit success
 Break  Quit success
}

ClassMethod IsFileOrderSame(file1, file2, diff, ignoreOrderBy, skipPlan, noheader) As %Boolean
{
	s issame = 1
	s diff = "", parsed1 = "", parsed2 = ""
	Open file1:"r":0 Else  Quit 0
	Open file2:"r":0 Else  Close file1 Quit 0
	
	d ..parseSQLFile(file1, .parsed1, ignoreOrderBy,noheader)
	d ..parseSQLFile(file2, .parsed2, ignoreOrderBy,noheader)
	
	close file1
	close file2
	
	if ( (parsed1("foundSomeSQL")=0) && (parsed1("foundSomePlans")=0) ) {
		//the file we are diffing wasn't a SQL result or plan file
		s issame = 0
		quit 0
	}
	if ( (parsed2("foundSomeSQL")=0) && (parsed2("foundSomePlans")=0) ) {
		//the file we are diffing wasn't a SQL result file
		s issame = 0
		quit 0
	}
	
	
	
	if (parsed1 '= parsed2) {
		//something bad happened, we have different number of statements in the 2 files
		s diff = file1 _ " had " _ parsed1 _ " statements " _ file2 _ " had " _ parsed2 _ " statements"
		s issame = 0
		quit 0
	}
	
	if (parsed1("foundSomeSQL")=1) {
		
		for stcount = 1:1:parsed1 {
		
			if (parsed1(stcount,"sql") '= parsed2(stcount, "sql")) {
				s diff = diff _ $c(13,10) _ parsed1(stcount,"sql") _ " == " _ parsed2(stcount,"sql")
				s issame = 0
			}
			if (parsed1(stcount,"header") '= parsed2(stcount, "header")) {
				s diff = diff _ $c(13,10) _ "header " _ parsed1(stcount,"header") _ " == " _ parsed2(stcount,"header")
				s issame = 0
			}
		
			if (parsed1(stcount,"rowcount") '= parsed2(stcount, "rowcount")) {
				s diff = diff _ $c(13,10) _ parsed1(stcount, "sql") _ $c(13,10) _"rowcount " _ parsed1(stcount,"rowcount") _ " == " _ parsed2(stcount,"rowcount")
				s issame = 0
			}

			s key = $o(parsed1(stcount, "results", ""))
			while (key '= "") {
				s count1 = parsed1(stcount, "results", key)
				if ($g(parsed2(stcount, "results", key)) = "") {
					s diff = diff _ $c(13,10) _ parsed1(stcount, "sql") _ $c(13,10) _ "statement " _ stcount _ " " _ file2 _ " missing " _ key
					s issame = 0
				} else {
					s count2 = parsed2(stcount, "results", key)
					if ( count1 '= count2 ) {
						s diff = diff _ $c(13,10) _ parsed1(stcount, "sql") _ $c(13,10) _ "statement " _ stcount _ " " _ file1 _ key _ " had " _ count1 _ " entries, " _ file2 _ " had " _ count2
						s issame = 0
					}
				}
				s key = $o(parsed1(stcount, "results", key))
			} //key'= ""
		
		} // for stcount
	} //foundSomeSQL
	
	if (skipPlan = "") {
		//default to skipPlan is not set
		if ($g(^%SYS("HINT","%PARALLEL")) = 1) {
			//if the global parallel hint is enabled, skip the plan checking
			s skipPlan = 1
		} else {
			//otherwise check the plan
			s skipPlan = 0
		}
	}
	
	if ( (parsed1("foundSomePlans")=1) && (skipPlan '= 1) ) {
		for stcount = 1:1:parsed1 {
			if ($g(parsed1(stcount, "plan")) '= "") {
				if (parsed1(stcount,"plan") '= parsed2(stcount,"plan")) {
					s diff = diff _ $c(13,10) _ "plan " _ stcount _ " " _ parsed1(stcount,"plan") _ " =plan= " _ parsed2(stcount,"plan")
					s issame = 0
					continue
				}
				for plan = 1:1: parsed1(stcount,"plan") {
					if (parsed1(stcount,"plan",plan) '= parsed2(stcount,"plan",plan)) {
						s diff = diff _ $c(13,10) _ "plan " _ stcount _ " " _ parsed1(stcount,"plan",plan) _ " = " _ parsed2(stcount,"plan",plan)
					}
				} // for plan
			} // $g(plan)
		} // for stcount
	} // checking plans
	
	quit issame
}

ClassMethod parseSQLFile(file, ByRef parsed, ignoreOrderBy, noheader)
{
	Set eof=0, foundSQL = 0, foundHeader = 0, statementCount = 0, inPlan = 0
	s parsed = "", statement = "", results = ""
	s parsed("foundSomeSQL") = 0
	s parsed("foundSomePlans") = 0
	s parsed("filename") = file
	for lineno=1:1 {
		d ..getline(file, .line, .eof)
		quit:eof
		
		if (line = "<plan>") {
			if (parsed("foundSomeSQL") = 0) {
				s statementCount = statementCount + 1
			}
			s parsed("foundSomePlans") = 1
			s inPlan = 1
			s planLine = 1
			s parsed(statementCount, "plan", planLine) = line
			continue
		}
		
		if (inPlan) {
			if (line = "</plan>") {
				s inPlan = 0
				s parsed(statementCount, "plan", planLine) = line
				s parsed(statementCount, "plan") = planLine
				s planLine = 0
			} else {
				s planLine = planLine + 1
				s parsed(statementCount, "plan", planLine) = line
			}
			continue
		}
		
		if ($e(line,1,4) = "SQL>") {
			s statementCount = statementCount + 1
			s parsed(statementCount,"sql") = line
			s foundSQL = 1
			s foundHeader = 0
			s parsed(statementCount, "ordered") = 0
			s parsed(statementCount, "rowcount") = 0
			s parsed(statementCount, "header") = ""
			if (noheader) {
				s foundHeader = 1
				s parsed(statementCount, "header") = "no header in file"
			}
			s parsed("foundSomeSQL") = 1
			if ($zconvert(line,"l") [ "order by") {
				if (ignoreOrderBy '= 1) {
					s parsed(statementCount, "ordered") = 1
				}
			}
		} elseif (line = "") {
			//do nothing for empty line
		} elseif ( (foundSQL=1) && (foundHeader=0)) {
			s parsed(statementCount, "header") = line
			s foundHeader = 1
		} else {
			
			if (foundSQL) {
				if ($g(parsed(statementCount,"rowcount")) = "") {
					s parsed(statementCount,"rowcount") = 1
				} else {
					s parsed(statementCount,"rowcount") = parsed(statementCount,"rowcount") + 1
				}
			
				if ($length(line) > 500) {
					s hash = $system.Encryption.SHA1Hash(line)
					s parsed(statementCount,"hashed", hash) = line
					s line = "SHA1HASH|||" _ hash
				}
			
				if (parsed(statementCount,"ordered")) {
					s parsed(statementCount, "results", parsed(statementCount,"rowcount") _ "row|||" _ line) = 1
				} else {
					if ($g(parsed(statementCount,"results",line)) = "") {
						s parsed(statementCount,"results",line) = 1
					} else {
						s parsed(statementCount,"results",line) = parsed(statementCount,"results",line) + 1
					}
				} //not ordered
			} //foundSQL
		} //main if/elseif/elseif
	}
	s parsed = statementCount
}

ClassMethod IsFileSame(file1, file2, diff) As %Boolean
{
	Set diff="",eof1=0,eof2=0
	Open file1:"r":0 Else  Quit 0
	Open file2:"r":0 Else  Close file1 Quit 0
	Set issame=1
	For line=1:1 {
		Set oline1=$get(line1),oline2=$get(line2)
		Do ..getline(file1,.line1,.eof1)
		Do ..getline(file2,.line2,.eof2)
		If line1'=line2||(eof1'=eof2) {
			Set issame=0
			Set diff="File1 "_file1_$c(13,10)_(line-1)_":"_oline1_$c(13,10)_line_":"_line1_$c(13,10)
			Set diff=diff_"File2 "_file2_$c(13,10)_(line-1)_":"_oline2_$c(13,10)_line_":"_line2
			Quit
		}
		If eof1||eof2 Quit
	}
	Close file1,file2
	Quit issame
}

ClassMethod getline(file, line, eof)
{
	Set io=$IO
	Use file 
	Try {
		Read line Set eof=$zeof
	} Catch {
		Set line="",eof=1
	}
	Use io
}

/// Enter a message in quotes, such as "Start of test".  Message is entered in the log (<b>^UnitTest.Result</b>) when a test is run. 
Method LogMessage(message)
{
 Set manager=r%Manager
 Do manager.LogMessage($g(message))
 Quit
}

/// This method returns a useful description based on arguments used in the Assert macros.
ClassMethod ParseAutoQuoted(argline As %String, type As %String) As %String
{
	set p=0,q=0,r=0,ptr=1,piece=0
	set str=$translate(argline,"""[]{}(),",$char(0,0,0,0,0,0,0,0)),i=0
	for {
		set i=$find(str,$char(0),i+1)-1
		if i=-1 quit
		set c=$e(argline,i)
		if c="""" {
			set i=$find(argline,"""",i+1)-1
			if i=-1 quit
		} elseif c="(" {
			set p=p+1
		} elseif c=")" {
			set p=p-1
		} elseif c="[" {
			set q=q+1
		} elseif c="]" {
			set q=q-1
		} elseif c="{" {
			set r=r+1
		} elseif c="}" {
			set r=r-1
		} elseif c=",",p=0,q=0,r=0 {
			s args($increment(piece))=$extract(argline,ptr,i-1),ptr=i+1
		}
	}
	set args($increment(piece))=$extract(argline,ptr,*)
	if type="expr"   quit $g(args(1))
	if type="equals" quit $g(args(1))_"=="_$g(args(2))
	quit ""
}

}
