/// <class>Scan</class> objects represent the results of scanning the installation
/// and examining its components. Different types of component (e.g., routines, databases, files)
/// are represented by different subclasses of the <class>Component</class> class. <class>Component</class>s can contain
/// subcomponents. Components are scanned recursively, and the result is a tree of objects.
/// <p>The tree is rooted in the <property>RootComponent</property> property of the scan.
/// <p><class>Scan</class> objects also record the <a href="#StartTimeStamp">start</a> and <a href="#EndTimeStamp">end</a>
/// times of the scan, as well as a text description, which is not requried to be unique. 
Class Inventory.Scan Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

Index EndTimeStampIndex On EndTimeStamp;

Index StartTimeStampIndex On StartTimeStamp;

Index RootComponentIndex On RootComponent;

/// A description of the circumstances of this scan
Property Description As %String(MAXLEN = 512);

/// The end time of this scan.
Property EndTimeStamp As %TimeStamp;

/// The <class>Component</class> that served as the origin of the scan. 
Property RootComponent As Component;

/// The start time of this scan.
Property StartTimeStamp As %TimeStamp;

/// Opens a previously saved <class>Scan</class> object with a <property>Description</property> of <var>description</var>.
/// <p>If more than one <class>Scan</class> has the given description, returns the first one found.
/// <p>Returns "" if no <class>Scan</class> found.
ClassMethod OpenByDescription(description As %String) As Scan
{
}

/// Writes the content of this scan to <var>filename</var> in <class>%XML.Export</class> format.
/// Note that an existing file will be overwritten.
Method WriteToFile(filename As %String) As %Status
{
}

Storage Default
{
<Data name="ScanDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>EndTimeStamp</Value>
</Value>
<Value name="4">
<Value>RootComponent</Value>
</Value>
<Value name="5">
<Value>StartTimeStamp</Value>
</Value>
</Data>
<DataLocation>^SYS("Inventory","ScanD")</DataLocation>
<DefaultData>ScanDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Inventory","ScanD")</IdLocation>
<IndexLocation>^SYS("Inventory","ScanI")</IndexLocation>
<StreamLocation>^SYS("Inventory","ScanS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
