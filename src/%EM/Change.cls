/// The %EM.Change class describes the changes (diffs) between the data
/// on an instance and the group which contains the instance.
Class %EM.Change Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Class is the short classname of the object which will change
Property Class As %String;

/// Name is the name or IdKey of the object which will change.
Property Name As %String;

/// Action is Add, Delete, Modify action.
Property Action As %String;

/// Property is the name of property which will change (if Action=Modify).
Property Property As %String;

}
