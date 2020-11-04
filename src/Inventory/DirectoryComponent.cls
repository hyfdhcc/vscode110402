/// <class>DirectoryComponent</class> is a subclass of <class>Component</class>.
/// An instance represents an operating system directory.
/// <p>It contains references to the <class>FileComponent</class>s and <class>DirectoryComponent</class>s representing
/// the files and subdirectories in the directory as subcomponents.
Class Inventory.DirectoryComponent Extends Component
{

/// The element name used in the XML representation of the component.
Parameter XMLNAME = "DirectoryComponent";

/// The identifier used to distinguish the type of this component in the XML representation.
Parameter XMLTYPE = "DirectoryComponent";

/// Initializes and saves this <class>DirectoryComponent</class>, recording <var>scan</var>
/// as the <property>Scan</property> property, and scanning <var>directoryName</var> for
/// its subdirectories and files.
/// <p>The saved <class>DirectoryComponent</class> is returned.
Method Init(scan As Scan, directoryName As %String) As DirectoryComponent
{
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
