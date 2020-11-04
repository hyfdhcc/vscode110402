/// <class>DatabaseComponent</class> is a subclass of <class>FileComponent</class>.
/// An instance represents a CACHE.DAT Cache database file.
/// <p>In addition to the properties of a <class>FileComponent</class>, it
/// also contains the name of the database and the database's routines as
/// subcomponents.
Class Inventory.DatabaseComponent Extends FileComponent
{

/// The element name used in the XML representation of the component.
Parameter XMLNAME = "DatabaseComponent";

/// The identifier used to distinguish the type of this component in the XML representation.
Parameter XMLTYPE = "DatabaseComponent";

Index DatabaseNameIndex On DatabaseName;

/// The name of this database in the installed configuration.
Property DatabaseName As %String;

/// Given a CACHE.DAT file name as <var>datFile</var>, returns the name
/// of the corresponding database in the active configuration, or the empty
/// string if there is no such database.
ClassMethod GetDatabaseName(datFile As %String) As %String [ Private ]
{
}

/// Initializes and saves this <class>DatabaseComponent</class>, recording <var>scan</var>
/// as the <property>Scan</property> property, and scanning <var>fileName</var> for
/// its <property>DatabaseName</property> and routines.
/// <p>The saved <class>DatabaseComponent</class> is returned.
Method Init(scan As Scan, fileName As %String) As DatabaseComponent
{
}

/// Scan the routines of the database into the SubComponents property of this
/// <class>DatabaseComponent</class>. If the database is not the manager's database, then
/// system routines are skipped.
Method ScanRoutinesAndClasses() As %Status [ Private ]
{
}

Storage Default
{
<Data name="DatabaseComponentDefaultData">
<Subscript>"DatabaseComponent"</Subscript>
<Value name="1">
<Value>DatabaseName</Value>
</Value>
</Data>
<DefaultData>DatabaseComponentDefaultData</DefaultData>
<Property name="DatabaseName"/>
<Property name="DateModified"/>
<Property name="Filename"/>
<Property name="Name"/>
<Property name="ParentComponent"/>
<Property name="SHA1Hash"/>
<Property name="Scan"/>
<Property name="Size"/>
<Property name="Type"/>
<Type>%Library.CacheStorage</Type>
}

}
