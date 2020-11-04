/// Extends <b>TestCase</b>.  Add methods to compare log files and write out test results and display errors. 
/// <br><br>
/// The <b>TestScript</b> class is an example of how you can extend <b>TestCase</b> to create classes for your own testing needs.
/// 
Class %UnitTest.TestScript Extends %UnitTest.TestCase [ System = 3 ]
{

/// List that correlates XML tags in a data file with classes. Tag/class entries are in the form <i>tag:class, tag1:class1, tag2:class2</i>.  Each entry is like setting the <b>DATATAG</b> and <b>DATACLASS</b> parameters, but the <b>CORRELATIONLIST</b> sets several tag/class pairs in one parameter.  If <b>CORRELATIONLIST</b>, <b>DATACLASS</b>, and <b>DATATAG</b> are all specified, the <b>DATATAG</b> and <b>DATACLASS</b> pair are added to the end of the <b>CORRELATIONLIST</b>.  
Parameter CORRELATIONLIST;

///  Specifies a class, such as <b>Sample.Person</b> which should be correlated with the XML tag specified by <b>DATATAG</b>, such as <<b>person></b>, in the <b>DATAFILE</b>.
Parameter DATACLASS;

/// File that contains data in XML format, such as <b>Person.xml</b>.  If no directory name is specified by <b>RunTest</b>, then the current <b>UnitTest</b> directory is used.
Parameter DATAFILE;

/// Specifies an XML tag in <b>DATAFILE</b>, such as <<b>person></b>, which should be correlated to the class specified by <b>DATACLASS</b>, such as <b>Sample.Person</b>.
Parameter DATATAG;

Parameter SHOWPLAN;

Parameter TESTFILE;

/// Set to 1 to call $$$AssertFilesSQLUnorderedSame rather than $$$AssertFilesSame
Parameter UNORDEREDFILESAME = 0;

/// Runs the test script. 
Method TestRunScript()
{
 Set dir=..Manager.CurrentDir
 Set scriptfile=dir_$s(..#TESTFILE'="":..#TESTFILE,1:"script.txt")
 Set outputfile=dir_"output.log",compare=1
 If ..Manager.UserParam="reference" Set compare=0,outputfile=dir_"reference.log"
 If ..Manager.UserParam="screen"    Set compare=0,outputfile=""
 Do $$$AssertStatusOK(..runScript(scriptfile,outputfile))
 If compare {
	 if (..#UNORDEREDFILESAME) {
		 Do $$$AssertFilesSQLUnorderedSame(outputfile,dir_"reference.log")
	 } else {
		 Do $$$AssertFilesSame(outputfile,dir_"reference.log") 
	 }
 } 
 Quit
}

ClassMethod runScript(scriptfile As %String, outputfile As %String) [ Abstract ]
{
}

}
