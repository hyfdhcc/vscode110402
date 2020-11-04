Include (%syAudit, %sySecurity, %sySystem, %msql, %syDatabase, %occErrors)

/// This class maps a key to a User. The keys should be obtained from X509 certificates. 
/// Use X509Users.GetLookupKey() go get a standard key from a certificate.
Class Security.X509Users Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right ]
{

Index LookupKeyIndex On LookupKey [ IdKey, Unique ];

/// Comment.<br>
Property Comment As %String(MAXLEN = 128);

/// Allow to log in via this key.<br>
/// 0 - Disable login.<br>
/// 1 - Enable login.<br>
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// Comment.<br>
Property LookupKey As %String(MAXLEN = 256) [ Required ];

/// UserName to be logged in as.<br>
Property Username As %String(MAXLEN = 128);

/// Return the lookup key (SubjectDN) for an X509 Certificate.<br/>
/// There are four different ways this can be called where:<br/><br/>
/// 1) Certificate = DER Encoded X509 Certificate<br/>
/// 2) Certificate = PEM Encoded X509 Certificate<br/>
/// 3) Certificate = Alias of %SYS.X509Credentials object<br/>
/// 4) Certificate = A %SYS.X509Credentials object<br/><br/>
/// If the certificate cannot be found or is invalid, an empty string is returned.
ClassMethod GetX509LookupKey(CredentialsCandidate As %String) As %String
{
}

/// Copy an X509User.<br>
/// Copy an existing X509User in the Security database to a new one.<br>
/// Parameters:<br>
/// LookupKey - LookupKey of the X509User to be copied.<br>
/// NewLookupKey - LookupKey of the X509User to be created.<br>
ClassMethod Copy(LookupKey As %String, NewLookupKey As %String) As %Status
{
}

/// Create a X509User.<br>
/// Create a X509User in the Security database.<br>
/// There are 2 ways to call this method and pass the parameters:<br><br>
/// s x=##Class(Security.X509Users).Create(LookupKey,username,...)<br>
/// or<br>
/// s x=##Class(Security.X509Users).Create(LookupKey,.Properties)<br><br>
/// Where Properties are contained in an array subscripted by 
/// property name, passed by reference.
/// See the Get() method for a description of the Properies array. Valid
/// properties for the Create() method are described below, other 
/// values are ignored.<br>
/// Parameters:<br>
/// LookupKey - Key used to lookup Username
/// UserName - Name of the user associated with this key<br>
/// Enabled - 0/1, account is disabled/enabled<br>
/// Comment - Comment<br>
ClassMethod Create(LookupKey As %String, Username As %String, Enabled As %Boolean, Comment As %String) As %Status
{
}

/// Delete an X509User.<br>
/// This method will delete a User from the security database.<br>
/// Parameters:<br>
/// LookupKey - Key to delete
ClassMethod Delete(LookupKey As %String) As %Status
{
}

/// X509 User exists.<br>
/// This method checks for the existence of a user in the security database.<br>
/// Parameters:<br>
/// LookupKey - Lookup key of the user to check existence of<br>
/// Requires the %Admin_Secure:USE privilege to change the $USERNAME value.<br>
/// Return values:<br>
/// If Value of the method = 0 (User does not exist, or some error occured)<br>
/// User = Null<br>
/// Status = User "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (User exists)<br>
/// User = Object handle to user<br>
/// Status = User "x" already exists<br>
ClassMethod Exists(LookupKey As %String, ByRef X509User As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports X509User records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// LookupKeys - Comma separated list of Keys to export, "*" = All<br>
/// Usernames - Comma separated list of Usernames, "*" = All. Export X509Users
/// containing only these usernames<br>
ClassMethod Export(FileName As %String = "X509UsersExport.xml", ByRef NumExported As %Integer = 0, LookupKeys As %String = "*", Usernames As %String = "*") As %Status
{
}

/// Get a X509User's properties.<br>
/// Gets a X509User's properties from the security database.<br>
/// Parameters:<br>
/// Username - Name of the user to get<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// Properties("Comment") - Comment<br>
/// Properties("Enabled") - 0=Disabled, 1=Enabled<br>
/// Properties("LookupKey") - Key used to find Username<br>
/// Properties("Username") - Name of associated user<br>
ClassMethod Get(LookupKey As %String, ByRef Properties As %String) As %Status
{
}

/// Get a User's properties.<br>
/// Gets a User's properties from the security database.<br>
/// Parameters:<br>
/// Username - Object handle to a User record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(X509User As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Initialize the userKey database at installation time.
ClassMethod Initialize() As %Status [ Internal ]
{
}

/// Import User records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import User records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "X509UsersExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Modify a X509User's properties.<br>
/// Modifies a X509User's properties from the security database.<br>
/// Parameters:<br>
/// LookupKey - Key of the X509User to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
/// If a value is unchanged it is not set to prevent the property modified state from being set.<br>
ClassMethod Modify(LookupKey As %String, ByRef Properties As %String) As %Status
{
}

/// List all userkey records, brief display. <br>
/// Keys - Comma separated list of userkeys, "*" = All<br>
/// Usernames - Comma separated list of Usernames, "*"=ALL <br>
/// Note: This query may change in future versions<br>
Query List(LookupKeys As %String, Usernames As %String) As %Query(ROWSPEC = "LookupKey:%String,Username:%String,Comment:%String,Enabled:%String") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, LookupKeys As %String = "*", Usernames As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
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
<Data name="X509UsersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Comment</Value>
</Value>
<Value name="3">
<Value>Enabled</Value>
</Value>
<Value name="4">
<Value>LookupKey</Value>
</Value>
<Value name="5">
<Value>Username</Value>
</Value>
</Data>
<DataLocation>^|"^^"_$zu(12)|SYS("Security","X509UsersD")</DataLocation>
<DefaultData>X509UsersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^|"^^"_$zu(12)|SYS("Security","X509UsersD")</IdLocation>
<IndexLocation>^|"^^"_$zu(12)|SYS("Security","X509UsersI")</IndexLocation>
<StreamLocation>^|"^^"_$zu(12)|SYS("Security","X509UsersS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
