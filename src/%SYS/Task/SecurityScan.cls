/// This class is a pre-defined system task which runs a security
/// scan every day at midnight. The scan consists of the following
/// items:<br><br>
/// 1) Disable expired user accounts<br>
/// 2) Expire user passwords<br>
/// 3) Expire CSP session tokens<br>
/// 
Class %SYS.Task.SecurityScan Extends %SYS.Task.Definition [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC1692 10/28/09 Steve Clay, Update %SYS.Task.SecurityScan documentation
STC1429 07/29/08 Steve Clay, System tasks always run in %SYS namespace 
STC1075	09/25/06 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
Parameter TaskName = "SecurityScan";

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
Method OnTask() As %Status
{
#;We must run in %SYS
	d $zu(5,"%SYS")
	s Status=$$SecurityScan^%SYS.SECURITY()
	Quit Status
}

}
