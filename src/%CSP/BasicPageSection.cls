/// This class is used internally by Cach&eacute;.
/// You should not make direct use of it within your applications.
/// There is no guarantee made about either the behavior or future operation of this class.<p>
/// 
/// Manage output of lines for CSP page class that is being created using Basic.
Class %CSP.BasicPageSection Extends %CSP.PageSection [ System = 3 ]
{

/// Create and save print text line for class that is being created.
Method WriteText(text As %String, crlf As %Boolean = 0) As %Status [ Internal ]
{
 If crlf {
 	Set line=" PrintLn"_$select(text="":"",1:" "_text)
 } Else {
	If text="" Quit $$$OK
 	Set line=" Print "_text
 }

 Do ..WriteLine(line,0)
 Quit $$$OK
}

}
