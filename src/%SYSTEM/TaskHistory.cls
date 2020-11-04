/// This class has been deprecated, use %SYS.Task.History instead
Class %SYSTEM.TaskHistory Extends (%Persistent, %SYS.Task.History) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
JB200	03/25/05 James Bourette Moved Class to %SYS.Task.History
JB158	10/21/03 James Bourette Fixed Storage.  Updated to System=4
JB157 	09/22/03 James Bourette Task Manager to common package name 
*/
Storage Default
{
<Data name="HistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ER</Value>
</Value>
<Value name="3">
<Value>Error</Value>
</Value>
<Value name="4">
<Value>ExecuteCode</Value>
</Value>
<Value name="5">
<Value>LastFinished</Value>
</Value>
<Value name="6">
<Value>LastStarted</Value>
</Value>
<Value name="7">
<Value>Name</Value>
</Value>
<Value name="8">
<Value>NameSpace</Value>
</Value>
<Value name="9">
<Value>Number</Value>
</Value>
<Value name="10">
<Value>RunningJobNumber</Value>
</Value>
<Value name="11">
<Value>Status</Value>
</Value>
<Value name="12">
<Value>Task</Value>
</Value>
<Value name="13">
<Value>LogDate</Value>
</Value>
<Value name="14">
<Value>LogTime</Value>
</Value>
<Value name="15">
<Value>Username</Value>
</Value>
</Data>
<DataLocation>^|"^^"_$ZU(12)|SYS("Task","HistoryD")</DataLocation>
<DefaultData>HistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^|"^^"_$ZU(12)|SYS("Task","HistoryD")</IdLocation>
<IndexLocation>^|"^^"_$ZU(12)|SYS("Task","HistoryI")</IndexLocation>
<StreamLocation>^|"^^"_$ZU(12)|SYS("Task","HistoryS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
