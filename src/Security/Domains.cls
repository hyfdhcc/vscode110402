Include (%sySecurity, %sySystem, %syAudit, %syDatabase, %occErrors, %ems)

/// This class defines the security domains for a system.<br>
/// Domain names have the following properties:<br>
/// 1) Domain names are case insensitive.<br>
/// 2) Maximum length of a domain name is 64 characters.<br>
/// The %Admin Secure:USE permission is required to operate on a domain
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Domains Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Parameter EMSSERVICE [ Internal ] = "Users";

Index NameIndex On NameLowerCase [ IdKey ];

/// Domain description.<br>
Property Description As %String(MAXLEN = 128);

/// Name of the domain.<br>
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// Domain Name in lowercase<br>
/// Used for indexing, not to be displayed or modified.
Property NameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// Change the domain of users.<br>
/// This method will change the domain to a new domain for users which
/// match the old domain. Its primary use is if we change the default system domain,
/// we would call this method to change all the users which referenced the
/// old default domain.<br>
/// Note that if a username@domain already exists in the new domain we are changing to,
/// then the old username@domain is just deleted, and the new one is used. If there is 
/// any error during the operation, the entire transaction is rolled back.<br>
/// Parameters:<br>
/// OldName - Domain name to change<br>
/// NewDomain - Domain name to change to<br>
/// If OldName="", then we are changing from using no domains to using domains i.e.
/// the multiple domains parameter is turned on. NewDomain must be a valid domain set up
/// in the domain file.
/// If NewDomain="", then we are changing from using multiple Domains to using no domains.
/// In order for this to succeed, all the users must have the same domain name as the
/// OldDomainName parameter passed in.
/// Note that if we are going from no domains to Multiple domains, or Multiple domains to
/// no domains, the system parameter governing this must be set before this method is called.
/// 
ClassMethod Change(OldDomainName As %String, NewDomainName As %String) As %Status
{
}

/// Create a Domain.<br>
/// Create a Domain in the Security database.<br>
/// Parameters:<br>
/// Name - Name of the domain to create<br>
/// Description - Description of the domain<br>
ClassMethod Create(Name As %String, Description As %String) As %Status
{
}

/// Delete a domain.<br>
/// This method will delete a domain from the security database. If the domain is 
/// in use by a user, the domain will not be deleted.<br>
/// Parameters:<br>
/// Name - Name of domain to delete
ClassMethod Delete(Name As %String) As %Status
{
}

/// Domain exists.<br>
/// This method checks for the existence of a domain in the security database.<br>
/// Parameters:<br>
/// Name - Name of the domain to check existence of<br>
/// Return values:<br>
/// If Value of the method = 0 (Domain does not exist, or some error occured)<br>
/// Domain = Null<br>
/// Status = Domain "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Domain exists)<br>
/// Domain = Object handle to domain<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String, ByRef Domain As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports Domain records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// Domains - Comma separated list of Domains to export, "*" = All<br>
ClassMethod Export(FileName As %String = "DomainsExport.xml", ByRef NumExported As %Integer, Domains As %String = "*") As %Status
{
}

/// Get a domain's properties.<br>
/// Gets a domain's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the domain to get<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// Properties("Description") - Description of the domain<br>
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Get a domain's properties.<br>
/// Gets a domain's properties from the security database.<br>
/// Parameters:<br>
/// Domain - Object handle to a Domain record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(Domain As %ObjectHandle, ByRef Properties As %String) As %Status
{
}

/// Import Domain records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Domain records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "DomainsExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Checks if the domain is in use.<br>
/// Checks if the domain specified is used by any user.<br>
/// Parameters:<br>
/// Name - Name of the domain to check.<br>
/// Return values:<br>
/// InUse = 0 Not used<br>
/// InUse = 1 Used<br>
/// Users = $list of users the domain is used by or null if none<br>
/// MoreUsers = 0 - Entire list of users using the domain returned<br>
/// MoreUsers = 1 - Entire list of users using the role Not returned<br>
/// If MoreUsers=1, and you wish to get the entire list of users using the domain, 
/// use the following code:<br>
/// s x=##Class(Security.Domains).InUse("Domain1",.InUse,.Users,.MoreUsers)
/// While (MoreUsers) {<br>
/// s SaveUsers($i(i))=Users<br>
/// s x=##Class(Security.Domains).InUse("Domain1",.InUse,.Users,.MoreUsers)<br?
/// }
ClassMethod InUse(Name As %String, ByRef InUse As %Boolean = 0, ByRef Users As %List, ByRef MoreUsers As %Boolean = 0) As %Status
{
}

/// Modify a domain.<br>
/// Modify an existing domain's properties in the security database.<br>
/// Parameters:<br>
/// Name - Name of the domain to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

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

/// List of Domains.<br>
/// Names - Comma separated list of Domain names, "*" = All<br>
/// Flags - 0 - Use "Startswith" as the selection on the name.<br>
/// Flags - 1 - Use "Contains" as the selection on the name.<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String = "*", Flags As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Description") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
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
<Data name="DomainsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","DomainsD")</DataLocation>
<DefaultData>DomainsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","DomainsD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","DomainsI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","DomainsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
