/// <class>RoutineComponent</class> is a subclass of <class>Component</class>.
/// An instance represents a routine.
/// <p>It contains properties representing the routine's name,
/// size, an optional <property>InventoryRecord</property>,
/// and a SHA1 hash of the routine's compiled code.
Class Inventory.RoutineComponent Extends (Component, Hashable) [ Inheritance = right ]
{

/// The element name used in the XML representation of the component.
Parameter XMLNAME = "RoutineComponent";

/// The identifier used to distinguish the type of this component in the XML representation.
Parameter XMLTYPE = "RoutineComponent";

Index InventoryRecordIndex On InventoryRecord;

Index ScanSHA1Index On (Scan, SHA1Hash);

/// The contents of an optional tagged comment inside the routine represented by this <class>RoutineComponent</class>, used to track its origins.
Property InventoryRecord As %String(MAXLEN = 256);

/// The size of the compiled code, in bytes, of the routine represented by this <class>RoutineComponent</class>.
Property Size As %Integer;

/// Retrieve the system-generated CRC for the routine and store it as the <property>SHA1Hash</property> property
/// of this object.<br>
/// <var>string</var> is assumed to be the value of the ^rOBJ node of the routine.
Method GenerateSHA1Hash(string As %String)
{
}

/// Scans the routine represented by this <class>RoutineComponent</class> for a comment string beginning
/// with ";; ISC-TAG:".
/// If present, sets the <property>InventoryRecord</property> property of this object to the remainder of the string.
Method FindInventoryRecord(rtnData As %String)
{
}

/// Extract strings from input <var>data</var> and return as a <code>$LIST</CODE>
/// <var>minlen</var> specifies how long the string must be to be selected
/// <var>tag</var> specifies the bytes that must be contained in the string to be selected
Method Strings(data As %String, minLen As %String = 4, tag As %String = "") As %List [ Private ]
{
}

Storage Default
{
<Data name="RoutineComponentDefaultData">
<Subscript>"RoutineComponent"</Subscript>
<Value name="1">
<Value>SHA1Hash</Value>
</Value>
<Value name="2">
<Value>InventoryRecord</Value>
</Value>
<Value name="3">
<Value>Size</Value>
</Value>
</Data>
<DefaultData>RoutineComponentDefaultData</DefaultData>
<Property name="InventoryRecord"/>
<Property name="Name"/>
<Property name="ParentComponent"/>
<Property name="SHA1Hash"/>
<Property name="Scan"/>
<Property name="Size"/>
<Property name="Type"/>
<Type>%Library.CacheStorage</Type>
}

}
