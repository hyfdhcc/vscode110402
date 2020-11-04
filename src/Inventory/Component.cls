/// <class>Component</class> is a superclass of all types of components discoverable in an
/// inventory scan. A component represents a named object in a system installation
/// such as a file, database or routine.
/// <p>Components maintain a relationship with an optional parent component and any sub-components.
/// For example, files are subcomponents of directories.
/// <p>Component data is stored in the %SYS database, and may be exported into an XML
/// representation.
Class Inventory.Component Extends (%Persistent, %XML.Adaptor) [ Inheritance = right ]
{

/// The element name used in the XML representation of the component.
Parameter XMLNAME = "Component";

/// The identifier used to distinguish the type of this component in the XML representation.
Parameter XMLTYPE = "Component";

Index NameIndex On Name As Exact;

Index ParentComponentIndex On ParentComponent;

Index ScanIndex On Scan [ Type = bitmap ];

/// The name of this component, which distinguishes it from other components of the same type.
Property Name As %String(COLLATION = "EXACT", MAXLEN = 512);

/// The parent component of this component.
Relationship ParentComponent As Inventory.Component [ Cardinality = one, Inverse = SubComponents ];

/// The <class>Scan</class> which found this component.
Property Scan As Scan(XMLREFERENCE = "ID") [ Required ];

/// The subcomponents of this component.
Relationship SubComponents As Component [ Cardinality = many, Inverse = ParentComponent ];

Storage Default
{
<Data name="ComponentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>ParentComponent</Value>
</Value>
<Value name="4">
<Value>Scan</Value>
</Value>
</Data>
<Data name="SubComponents">
<Attribute>SubComponents</Attribute>
<Structure>subnode</Structure>
<Subscript>"SubComponents"</Subscript>
</Data>
<DataLocation>^SYS("Inventory","ComponentD")</DataLocation>
<DefaultData>ComponentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS("Inventory","ComponentD")</IdLocation>
<IndexLocation>^SYS("Inventory","ComponentI")</IndexLocation>
<Property name="Name"/>
<Property name="ParentComponent"/>
<Property name="Scan"/>
<Property name="Type"/>
<StreamLocation>^SYS("Inventory","ComponentS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
