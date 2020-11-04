/// Task to run an Inventory Scan
Class %SYS.Task.InventoryScan Extends %SYS.Task.Definition [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC1429 07/29/08 Steve Clay, System tasks always run in %SYS namespace 
-------------------End Documentation----------------------------------
*/
Parameter TaskName = "InventoryScan";

/// This method is responsible for executing the task
/// At the scheduled time, the Task Manager
/// - creates an instance of this object,
/// - Sets any property values using the stored "Settings" for the task,
/// - and invokes this method to execute the task.
Method OnTask() As %Status
{
#;We must run in %SYS
	d $zu(5,"%SYS")
	Set scanName = "Inventory Scan: " _ $ZV
	Set scan = ##class(Inventory.Scanner).RunScan(scanName)
	Set sc = scan.%Save()
	Quit sc
}

}
