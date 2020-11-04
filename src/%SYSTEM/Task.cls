/// This class has been deprecated please use %SYS.Task
/// 
Class %SYSTEM.Task Extends (%SYS.TaskSuper, Help) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
JB230	07/20/05 James Bourette  Items not indexed correctly
JB200	03/25/05 James Bourette  Redirect calls to %SYS.Task
*/
Parameter XMLTYPE = "SYSTEMTask";

Storage Default
{
<Data name="TaskDefaultData1">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>SuspendOnError</Value>
</Value>
</Data>
<DefaultData>TaskDefaultData1</DefaultData>
<ExtentSize>100000</ExtentSize>
<Type>%Library.CacheStorage</Type>
}

}
