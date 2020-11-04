/// This class has been deprecated, use %SYS.Task.Config instead
Class %SYSTEM.TaskConfig Extends (%Persistent, %SYS.Task.Config) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
JB200	03/25/05 James Bourette Moved Class to %SYS.Task.Config
JB158	10/21/03 James Bourette Fixed Storage.  Updated to System=4
JB157 	09/22/03 James Bourette Task Manager to common package name 
*/
Storage Default
{
<Data name="ConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
<Value name="3">
<Value>ParamName</Value>
</Value>
</Data>
<DataLocation>^|"^^"_$ZU(12)|SYS("Task","ConfigD")</DataLocation>
<DefaultData>ConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^|"^^"_$ZU(12)|SYS("Task","ConfigD")</IdLocation>
<IndexLocation>^|"^^"_$ZU(12)|SYS("Task","ConfigI")</IndexLocation>
<StreamLocation>^|"^^"_$ZU(12)|SYS("Task","ConfigS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
