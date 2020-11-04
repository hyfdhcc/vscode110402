Include %DeepSee

/// /// Representation of a subject area within the registry map
Class %DeepSee.CubeManager.RegistryMapSubjectArea Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

Relationship BaseCube As %DeepSee.CubeManager.RegistryMapCube [ Cardinality = parent, Inverse = SubjectAreas ];

/// Normalized internal storage key for the subject area
Property SAName As %ZEN.Datatype.string;

/// Display name for the subject area
Property SADisplayName As %ZEN.Datatype.string [ Calculated ];

/// Flag do denote if this is a compound cube
Property IsCompound As %ZEN.Datatype.boolean [ Calculated ];

/// Last modification date of this subject area definition
Property LastModDate As %String(XMLPROJECTION = "NONE") [ Calculated ];

Method SADisplayNameGet() As %String
{
	Quit ##class(%DeepSee.Utils).%GetCubeCaption(..SAName)
}

Method IsCompoundGet() As %String
{
	Quit ##class(%DeepSee.Utils).%IsCubeCompound(..SAName)
}

Method LastModDateGet() As %String
{
	Quit ##class(%DeepSee.Utils).%GetCubeModifiedDate(..SAName)
}

}
