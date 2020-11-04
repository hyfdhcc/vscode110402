Include (%syJrninc, %occErrors)

Class %SYS.Task.SwitchJournal Extends %SYS.Task.Definition [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
RFD676  09/27/11 Rob Davis, better error code handling
STC1429 07/29/08 Steve Clay, System tasks always run in %SYS namespace 
JB203	04/07/05 James Bourette	 Ensure system tasks are initialized
-------------------End Documentation----------------------------------
*/
Parameter TaskName = "SwitchJournal";

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
Method OnTask() As %Status
{
#;We must run in %SYS
	d $zu(5,"%SYS")
	f i=1:1:10 s rc=$$INT^JRNSWTCH(,,.err,,,,,$$$JRNSWREASONTASKMGR) q:rc  h 10
	i rc q $$$OK
	#; ^JRNSWTCH may return a converted status code, strip this part off
	i $p(err,":")[("#"_$$$JournalingSwitchError),$l(err,":")>2 s err=$p(err,":",3,$l(err,":"))
	q $$$ERROR($$$JournalingSwitchError,err)
}

}
