/// This class contains methods which are used to maintain compatibility with previous
/// versions.
Class SYS.Compatibility Extends %SYSTEM.Help [ Abstract, System = 4 ]
{

/// Enable access of a global with a name which is truncated by the compiler and ends with 
/// a "." (DEPRECATED)<br> 
/// When a global name is larger than 31 characters, the compiler truncates it to the first
/// 31 characters.  If the truncation results in the final character being a period ("."), 
/// the name is illegal and should cause an error.  But previous versions of the compiler did not 
/// detect the illegal name and could create an invalid global or LOCK entry.<br> 
/// This method allows you to continue to access an invalid global that was created under the 
/// old version, or to continue using LOCK operations on an invalid name.<br>
/// You should call this method at system startup only if you have invalid globals that need
/// to be accessed. It is meant for compatibility only, until you can migrate your global 
/// structure to use a valid global name, or convert your LOCK code to use a valid name.<br> 
/// If you do need to use this method, edit your SYSTEM^%ZSTART or ZSTU code and call it
/// from there.<br><br>
/// s Status=##Class(SYS.Compatibility).SetGlobalNameTruncated(1)
/// Parameters:<br>
/// Value = 0 - (Default) Do not allow a 31 character global name to end in "."<br>
/// Value = 1 - Allow a 31 character global name to end in "."
ClassMethod SetGlobalNameTruncated(Value As %Boolean = 0) As %Status
{
}

}
