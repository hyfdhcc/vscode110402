/// This class defines an API to schedule tasks to run in the background.
/// <br><br>
Class %SYS.Task Extends %SYS.TaskSuper [ System = 4 ]
{

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
