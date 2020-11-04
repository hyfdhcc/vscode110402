Include (%sySecurity, %syAudit, %syEMS, %sySystem, %occErrors, %ems)

/// Define the security Resource database, and methods which manipulate them.<br>
/// The system includes a set of pre-defined System resources. Some properties
/// of the system resources may not be modified.<br><br>
/// Resource names have the following properties:<br>
/// 1) Resource names are case insensitive.<br>
/// 2) Maximum length of a resource name is 64 characters.<br>
/// 3) First Character after the "_" cannot be a % for user-defined resources<br>
/// 4) Resource names cannot contain a "," or ":"<br><br>
/// The %Admin_Secure:USE permission is required to operate on a resource
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Resources Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Parameter DOMAIN = "%Utility";

Parameter EMSSERVICE [ Internal ] = "Security";

Index NameIndex On NameLowerCase [ IdKey ];

/// Description of the resource.<br>
/// Description cannot be modified if a system defined resource.<br>
Property Description As %String(MAXLEN = 256);

/// Name of the resource.<br>
Property Name As %String(COLLATION = "Exact", MAXLEN = 64, MINLEN = 1) [ Required ];

/// Resource Name in Lowercase.<br>
/// Used for indexing, not to be displayed or modified
Property NameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// Public permissions on the resource.<br>
/// Bit 0 - Read<br>
/// Bit 1 - Write<br>
/// Bit 2 - Use<br>
Property PublicPermission As Security.Datatype.Permission [ InitialExpression = 0 ];

/// Type - Bitmap describing the type of resource.<br>
/// Bit 0 = System initialized resource<br>
/// Bit 1 = Database resource<br>
/// Bit 2 = Service resource<br>
/// Bit 3 - Application resource<br>
/// Bit 4 - DeepSee resource<br>
/// Bits 5-30 reserved<br>
/// Bit 31 = User defined Resource<br>
/// Bits 31-64 user defined <Reserved for future use><br>
/// Note that this property is set automatically by the filer and should
/// not be set for user defined resources.<br>
/// Do not modify this field directly except on initialization of system defaults.
Property Type As Security.Datatype.ResourceType(MINVAL = 0) [ InitialExpression = 0 ];

/// Create a Resource.<br>
/// Creates a Resource in the Security database.<br>
/// Parameters:<br>
/// Name - Name of the resource to create<br>
/// Description- Description of the resource<br>
/// PublicPermission - Public permission on the resource<br>
/// May be one or more of "R","W","U"<br>
/// Type - Internal use only, User defined resources should not pass this parameter<br>
ClassMethod Create(Name As %String, Description As %String, PublicPermission As Security.Datatype.Permission, Type As %Integer) As %Status
{
}

/// Delete a resource.<br>
/// This method will delete a resource from the security database. After the resource
/// is deleted, it will update all the roles which hold this resource to remove the 
/// resource from the role. It will then update the in-memory security tables to mark this 
/// resource as "No access" for all roles, and "no access" for its public permissions.<br>
/// Access to these resources will
/// then be restricted only to users who own the %All role.<br>
/// Parameters:<br>
/// Name - Name of the resource to delete<br>
ClassMethod Delete(Name As %String) As %Status
{
}

/// Resource exists.<br>
/// This method checks for the existence of a resource in the security database.<br>
/// Parameters:<br>
/// Name - Name of the resource to check existence of<br>
/// Return values:<br>
/// If Value of the method = 0 (Resource does not exist, or some error occured)<br>
/// Resource = Null<br>
/// Status = Resource "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Resource exists)<br>
/// Resource = Object handle to resource<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String, ByRef Resource As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports Resource records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// Resources - Comma separated list of Resources to export, "*" = All<br>
/// PublicPermissions - Only export those with this type of public permissions<br>
/// -1 = All<br>
/// Bit 0 - Read public permission<br>
/// Bit 1 - Write public permission<br>
/// Bit 2 - Use public permission<br>
/// Bit 9 - No public permission<br>
/// Type - Internal use only, pass -1
ClassMethod Export(FileName As %String = "ResourcesExport.xml", ByRef NumExported As %Integer, Resources As %String = "*", PublicPermissions As %Integer = -1, Type As %Integer = -1) As %Status
{
}

/// Get a resource's properties.<br>
/// Gets a resource's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the resource to get<br>
/// Return values:<br>
/// Properties - Array of resource properties<br>
/// Properties("Description")- Description of the resource<br>
/// Properties("PublicPermission") - Public permission on the resource<br>
/// May be one or more of "R","W","U"<br>
/// Properties("Type") - Internal use only
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Get a resource's properties.<br>
/// Gets a resource's properties from the security database.<br>
/// Parameters:<br>
/// Resource - Object handle to a resource record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(Resource As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Import Resource records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Resource records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "ResourcesExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Initializes the Resource database for the first time when the system is installed.<br>
/// This is callable anytime to make sure all the system resources are created/defined.
/// If any are missing, it will add them.<br>
/// Note that some system resources are created by the Services class
ClassMethod Initialize(SecuritySetting As %String = "None") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

/// Checks if the resource is in use.<br>
/// Checks if the resource specified is used by any role,
/// application or database. <br>
/// Parameters:<br>
/// Name - Name of the resource to check.<br>
/// Return values:<br>
/// InUse = 0 Not used<br>
/// InUse = 1 Used<br>
/// Roles - $list of roles the resource is used by or null if none<br>
/// Databases - $list of databases the resource is used by or null if none<br>
/// Applications - $list of applications the resource is used by or null if none<br>
/// Flags - Controls return values<br>
///  Bit 0 - Return roles in format $lb(Role1_":"_Permission,Role2_":"_Permission)<br>
///  
ClassMethod InUse(Name As %String, ByRef InUse As %Status, ByRef Roles As %List, ByRef Databases As %List, ByRef Applications As %List, Flags As %Integer = 0) As %Status
{
}

/// Modify a resource.<br>
/// Modify an existing resource's properties in the security database.<br>
/// Parameters:<br>
/// Name - Name of the resource to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Given a resource name, return its description
ClassMethod NameToDescription(Name As %String, Description As %String) As %String [ Internal ]
{
}

/// Initialize an EMS client when an event changes
ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

/// List Resource types<br>
/// Names - Comma separated list of resource names<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record matching one of these elements, or starting with "String1"<br>
/// PublicPermissions - Only list those with this type of public permissions<br>
/// -1 = All<br>
/// Bit 0 - Read public permission<br>
/// Bit 1 - Write public permission<br>
/// Bit 2 - Use public permission<br>
/// Bit 9 - No public permission<br>
/// Type - Internal use only, pass -1<br>
/// Flags - 0 - Use "Startswith" as the selection on the name.<br>
/// Flags - 1 - Use "Contains" as the selection on the name.<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String, PublicPermissions As %Integer, Type As %Integer, Flags As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Description:%String,PublicPermission:%String,Type:%String,ResourceType:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", PublicPermissions As %Integer = -1, Type As %Integer = -1, Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Storage Default
{
<Data name="ResourcesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>PublicPermission</Value>
</Value>
<Value name="5">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ResourcesD")</DataLocation>
<DefaultData>ResourcesDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ResourcesD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ResourcesI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ResourcesS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
