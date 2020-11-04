/// A <class>ComponentSet</class> object represents a set of <class>Component</class> objects
/// It is used to associate Components that otherwise are unrelated.
Class Inventory.ComponentSet Extends Component
{

/// The element name used in the XML representation of the component.
Parameter XMLNAME = "ComponentSet";

/// The identifier used to distinguish the type of this component in the XML representation.
Parameter XMLTYPE = "ComponentSet";

Method Init(scan As Scan) As ComponentSet
{
}

/// Adds a newcomponent to this set, represented as a subcomponent
Method AddComponent(component As Component) As %Status
{
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
