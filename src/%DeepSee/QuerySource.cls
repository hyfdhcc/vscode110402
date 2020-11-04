Include %occInclude

/// This class defines the API needed to connect data sources to DeepSee dashboards.
Class %DeepSee.QuerySource [ Abstract, System = 4 ]
{

/// Return a list of available filters for this data source.
ClassMethod %GetFilterList(Output pList As %List) As %Status
{
	Quit $$$ERROR($$$GeneralError,"%GetFilterList is not implemented")
}

/// Return a list of available members for given filter.
ClassMethod %GetFilterMembers(pFilter As %String, Output pMembers As %List) As %Status
{
	Quit $$$ERROR($$$GeneralError,"%GetFilterMembers is not implemented")
}

}
