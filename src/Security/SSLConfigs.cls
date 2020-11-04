Include (%sySecurity, %sySystem, %syAudit, %syLDAP, %occErrors, %sySite)

/// Define the SSL/TLS configurations, and methods which manipulate them.<br>
/// 1) SSL configuration names are case sensitive.<br>
/// 2) Maximum length of a configuration name is 64 characters.<br>
/// Once an SSL configuration is defined and activated, you can use the name of the 
/// configuration as a parameter to the open or use command in order to set up an
/// SSL connection.<br>
/// Open dev:(Host:Port:"M":/TLS="Name"):10<br>
/// The %Admin Secure:USE permission is required to operate on an SSL
/// configuration.
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.SSLConfigs Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// Name by which this configuration is referenced.<br>
Index NameIndex On Name [ IdKey ];

/// File containing X.509 certificate(s) of trusted Certificate Authorities.<br>
/// Can be an absolute pathname or a pathname relative to the Cache' manager's directory.<br>
/// Clients:  Specify CAFile and/or CAPath<br>
/// Servers:  Specify CAFile and/or CAServer if VerifyPeer > 0
Property CAFile As %String(MAXLEN = 255);

/// Directory containing file(s) with X.509 certificate(s) of trusted Certificate Authorities.<br>
/// Can be an absolute pathname or a pathname relative to the Cache' manager's directory.<br>
/// Clients:  Specify CAFile and/or CAPath<br>
/// Servers:  Specify CAFile and/or CAServer if VerifyPeer > 0
Property CAPath As %String(MAXLEN = 255);

/// File containing X.509 Certificate Revocation List for trusted Certificate Authorities.<br>
/// Can be an absolute pathname or a pathname relative to the Cache' manager's directory.<br>
/// CAFile or CAPath must be specified if CRLFile is specified.
Property CRLFile As %String(MAXLEN = 255) [ Internal ];

/// File containing this configuration's X.509 certificate.<br>
/// Can be an absolute pathname or a pathname relative to the Cache' manager's directory.
/// If not null, PrivateKeyFile must also be specified.
Property CertificateFile As %String(MAXLEN = 255);

/// Colon-delimited list of enabled ciphersuites.<br>
/// By default, disable anonymous, unencrypted, and SSLv2 ciphersuites.
Property CipherList As %String(MAXLEN = 255) [ InitialExpression = "ALL:!aNULL:!eNULL:!EXP:!SSLv2", Required ];

/// Description of the SSL configuration.<br>
Property Description As %String(MAXLEN = 256);

/// Configuration is enabled.<br>
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// SSL configuration name.<br>
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

/// File containing this configuration's private key.<br>
/// Can be an absolute pathname or a pathname relative to the Cache' manager's directory.
/// If not null, CertificateFile must also be specified.
Property PrivateKeyFile As %String(MAXLEN = 255);

/// Optional password used to decrypt this configuration's private key.<br>
/// If not null, PrivateKeyFile and CertificateFile must also be specified.
Property PrivateKeyPassword As Security.Datatype.Password(MAXLEN = 255);

/// Private key type, one of:<br>
/// 1 = DSA<br>
/// 2 = RSA
Property PrivateKeyType As Security.Datatype.PrivateKeyType(MAXVAL = 2, MINVAL = 1) [ InitialExpression = 2, Required ];

/// Protocols enabled.<br>
/// Bit 0 - SSLv2<br>
/// Bit 1 - SSLv3<br>
/// Bit 2 - TLSv1.0<br>
/// Bit 3 - TLSv1.1<br>
/// Bit 4 - TLSv1.2<br>
/// Default is TLSv1.0+TLSv1.1+TLSv1.2
Property Protocols As Security.Datatype.Protocol(MAXVAL = 31, MINVAL = 1) [ InitialExpression = 28, Required ];

/// Intended type for this configuration.<br>
/// 0 = client<br>
/// 1 = server<br>
/// Default is client (0)
Property Type As Security.Datatype.SSLType [ InitialExpression = 0, Required ];

/// Maximum number of CA certificates allowed in peer certificate chain.<br>
Property VerifyDepth As %Integer(MINVAL = 0) [ InitialExpression = 9, Required ];

/// Peer certificate verification level.<br>
/// <br>
/// Clients:<br>
/// 0 = None (continue even if certificate verification fails)<br>
/// 1 = Require server certificate (continue only if certificate verification succeeds)<br>
/// <br>
/// Servers:<br>
/// 0 = None (do not request client certificate)<br>
/// 1 = Request client certificate (terminate if certificate is provided and verification fails)<br>
/// 3 = Require client certificate (continue only if certificate is provided and verification succeeds)<br>
Property VerifyPeer As %Integer(MAXVAL = 3, MINVAL = 0) [ InitialExpression = 0, Required ];

/// Activate the configuration.<br>
/// Activate the configuration for use when new TCP connections are 
/// OPENed with the /SSL or /TLS parameter.
Method Activate() As %Status
{
}

/// Activate all configurations.<br>
/// Activate all defined SSL configurations.
ClassMethod ActivateAll() As %Status
{
}

/// Deactivate this configuration.
Method Deactivate() As %Status
{
}

/// Create an SSL configuration.<br>
/// Create an SSL configuration in the Security database.<br>
/// Parameters:<br>
/// Name - Name of the SSL configuration to create<br>
/// Properties - Array of properties corresponding to the class properties<br>
/// For example, Properties("CAFile")=Filename
ClassMethod Create(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Delete an SSL configuration.<br>
/// This method will delete an SSL configuration from the security database.<br>
/// Parameters:<br>
/// Name - Name of SSL configuration to delete
ClassMethod Delete(Name As %String) As %Status
{
}

/// SSL configuration exists.<br>
/// This method checks for the existence of an SSL Configuration in the security database.<br>
/// Parameters:<br>
/// Name - Name of the SSL configuration to check existence of<br>
/// Return values:<br>
/// If Value of the method = 0 (SSL configuration does not exist, or some error occured)<br>
/// SSLConfig = Null<br>
/// Status = SSL configuration "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (SSL configuration exists)<br>
/// SSLConfig = Object handle to SSL configuration<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String, ByRef SSLConfig As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports SSL configuration Objects to a file in xml format.<br>
/// Parameters:<br>
/// FileName - Output file name<br>
/// NumExported (byref) - Returns number of XML records exported.<br>
/// SSLConfigs - Comma separated list of SSL configurations to export, "*" = All
ClassMethod Export(FileName As %String = "SSLConfigsExport.xml", ByRef NumExported As %Integer, SSLConfigs As %String = "*") As %Status
{
}

/// Get a SSL configuration's properties.<br>
/// Gets a SSL configuration's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the SSL configuration to get<br>
/// Return values:<br>
/// Properties - Array of properties.<br>
/// For example, Properties("CAFile")=Filename<br>
/// Note: Admin_Secure:Use permission required for this method since it
/// returns an unhashed password.
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Get an X.509 CRL using the value of the crlDistributionPoints standard extension
/// in the X.509 certificate contained in the file CAFile, and store it in the file
/// CRLFile.
Method GetCRLFile() As %Status
{
}

/// Get a SSL configuration's properties.<br>
/// Gets a SSL configuration's properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the SSL configuration to get<br>
/// Return values:<br>
/// Properties - Array of properties.<br>
/// For example, Properties("CAFile")=Filename<br>
ClassMethod GetProperties(SSLConfig As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Import SSL configuration records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import SSL configuration records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
/// Warning: Import will fail if the certificate paths or certificates
/// do not exist before the import.<br>
ClassMethod Import(FileName As %String = "SSLConfigsExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Modify an SSL configuration.<br>
/// Modify an existing SSL configuration's properties in the security database.<br>
/// Parameters:<br>
/// Name - Name of the SSL configuration to modify<br>
/// Properties - Array of properties to modify.<br>
/// For example, Properties("CAFile")=Filename
/// If a specific property is not passed in the properties array, or is the same
/// as the existing value, the value is not modified.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// Test the SSL configuration.<br>
/// Attempts to make an SSL connection to the passed Host and port.<br>
/// Parameters:<br>
/// Host - Ip name of the host to connect to<br>
/// Port - Port # of the host to connect to<br>
/// Return Values:<br>
/// On success, Info is returned as an array of messages concerning the
/// host which we connected to.
Method TestConnection(Host As %String, Port As %Integer, ByRef Info As %String) As %Status
{
}

/// Retrieve reason for ErrorProtocol in TestConnection().<br>
/// Calls $System.Security.Users.GetLastError() to retrieve ssl error text.
/// Protects against errors retrieving error text.
Method TestConnectionGetError(Device As %String) As %String [ Final, Internal ]
{
}

/// Validate the SSL configuration (DEPRECATED).<br>
/// Use the TestConnection method instead.<br>
/// Attempts to make an SSL connection to the passed Host and port.<br>
/// Parameters:<br>
/// Host - Ip name of the host to connect to<br>
/// Port - Port # of the host to connect to<br>
/// Return Values:<br>
/// String of success or error messages.
Method Validate(Host As %String, Port As %Integer) As %String
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
/// If the service name is %Service Terminal, reinitialize the memory which depends on it.
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
Method %OnValidateObject(ReadOnly As %Boolean = 0) As %Status [ Internal ]
{
}

/// Determines if the named SSL configuration is valid for use by EMS.<br>
/// Checks general object validity and insures that at lease one certificate is unexpired in the CAFile.
/// Returns 1 if validated by %OnValidateObject and any certificate in CAFile has not expired, 0 otherwise.
ClassMethod IsValidForEMS(Name As %String) As %Boolean [ Internal, ServerOnly = 1 ]
{
}

/// Inspects certificates in CAFile and returns the number that are valid and unexpired.<br>
/// If CheckAll = 0, only the first certificate is examined.  CheckAll defaults to 1.
ClassMethod CAStillValid(CAFile As %String, CheckAll As %Integer = 1) As %Integer [ Internal ]
{
}

/// List all SSL configuration records, brief display. <br>
/// Names - Comma separated list of SSL configuration names, "*" = All<br>
/// Types - Comma separated list of SSL Types, 0=Clients, 1=Servers, *=All
/// Note: This query may change in future versions<br>
Query Detail(Names As %String = "*", Types As %String = "*") As %Query(ROWSPEC = "Name:%String,Description:%String,Enabled:%String,CAFile:%String,CAPath:%String,CertificateFile:%String,CipherList:%String,PrivateKeyFile:%String,PrivateKeyPassword:%String,PrivateKeyType:%String,Protocols:%String,Type:%String,VerifyDepth:%String,VerifyPeer:%String,CRLFile:%String,EnabledInternal:%Integer,TypeInternal:%Integer") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Names As %String = "*", Types As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

/// List all SSL configuration records, brief display. <br>
/// Names - Comma separated list of SSL configuration names, "*" = All<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String) As %Query(ROWSPEC = "Name:%String,Description:%String,Enabled:%String,Type:%String,EnabledInternal:%Integer,TypeInternal:%Integer") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", Types As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// List all SSL configuration records, brief display. <br>
/// Names - Comma separated list of SSL configuration names, "*" = All<br>
Query ListNames() As %SQLQuery(ROWSPEC = "Name:%String") [ SqlProc ]
{
	SELECT Name FROM SSLConfigs
 		ORDER BY Name
}

/// List all SSL configuration records, brief display. <br>
/// Only includes SSL configuration records used by the EMS (i.e. configs intended for client use, with a private key, password, certificate, certificate authority, and not expired.) <br>
/// Names - Comma separated list of SSL configuration names, "*" = All<br>
Query ListEMS() As %Query(ROWSPEC = "Name:%String") [ SqlProc ]
{
}

ClassMethod ListEMSExecute(ByRef qHandle As %Binary) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListEMSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListEMSExecute ]
{
}

ClassMethod ListEMSClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListEMSExecute ]
{
}

/// Get the contents of the file named by CertificateFile.
Method GetCertificate() As %String [ Final ]
{
}

/// Get the content of the CA file. Return null string if failed.
Method GetCAFile() As %String [ Final, Internal ]
{
}

Storage Default
{
<Data name="SSLConfigsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CAFile</Value>
</Value>
<Value name="3">
<Value>CAPath</Value>
</Value>
<Value name="4">
<Value>CertificateFile</Value>
</Value>
<Value name="5">
<Value>CipherList</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>Enabled</Value>
</Value>
<Value name="8">
<Value>Name</Value>
</Value>
<Value name="9">
<Value>PrivateKeyFile</Value>
</Value>
<Value name="10">
<Value>PrivateKeyPassword</Value>
</Value>
<Value name="11">
<Value>PrivateKeyType</Value>
</Value>
<Value name="12">
<Value>Protocols</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
<Value name="14">
<Value>VerifyDepth</Value>
</Value>
<Value name="15">
<Value>VerifyPeer</Value>
</Value>
<Value name="16">
<Value>CRLFile</Value>
</Value>
</Data>
<DataLocation>^|"^^"_$zu(12)|SYS("Security","SSLConfigsD")</DataLocation>
<DefaultData>UsersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^|"^^"_$zu(12)|SYS("Security","SSLConfigsD")</IdLocation>
<IndexLocation>^|"^^"_$zu(12)|SYS("Security","SSLConfigsI")</IndexLocation>
<StreamLocation>^|"^^"_$zu(12)|SYS("Security","SSLConfigsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
