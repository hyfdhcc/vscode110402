Include (%sySystem, %sySecurity, %syAudit, %sySite, %occSystemMessages, %occErrors, %syEMS, %ems)

/// This class defines the applications for a system.<br>
/// There are three types of applications which can be defined:<br><br>
/// 1) CSP applications<br>
/// 2) Privileged routine applications<br>
/// 3) Client Applications<br><br>
/// Depending on the type of application defined (Type property), properties may or may not be relevant
/// to that type of application. See each property description for its relevance for
/// each type of application.<br>
/// Application names have the following properties:<br>
/// 1) Application names are case insensitive.<br>
/// 2) Maximum length of an application name is 64 characters.<br>
/// The %Admin Secure:USE permission is required to operate on an application<br>
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Applications Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index NameIndex On NameLowerCase [ IdKey ];

Parameter EMSSERVICE [ Internal ] = "Security";

/// Authentication and Session mechanisms enabled (CSP Only).<br>
/// Bit 2 = AutheK5API<br>
/// Bit 5 - AutheCache<br>
/// Bit 6 = AutheUnauthenticated<br>
/// Bit 11 = AutheLDAP<br>
/// Bit 12 = AutheLDAPCache<br>
/// Bit 13 = AutheDelegated<br>
/// Bit 14 = LoginToken<br>
/// Bit 20 = TwoFactorSMS<br>
/// Bit 21 = TwoFactorPW<br>
Property AutheEnabled As Security.Datatype.Authentication [ InitialExpression = 64 ];

/// This specifies whether CSP files should automatically compile or not (CSP Only).<br>
/// If this is turned on, then when a CSP file is more recent than its compiled class,<br>
/// it is recompiled. This is normally something you would turn on in development environments<br>
/// and turn off in production environments.
Property AutoCompile As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// A predefined change password page that can be sent out to the browser if the user account requires<br>
/// that a password change is required(CSP Only).<br>
Property ChangePasswordPage As %String(MAXLEN = 256);

/// List of time stamps and hash values for valid executables (Client Applications Only).
/// Each element is in the form $zdatetime($h,3)^HashValue
Property ClientApplications As list Of %String(MAXLEN = 64);

/// Scope of the session cookie (CSP Only).<br>
/// This determines which urls the browser will send the session cookie back to Cache.<br>
/// If your application name is 'myapp', it defaults to '/myapp/' meaning it will only send<br>
/// the cookie for pages under '/myapp/'. You should restrict this to only what is required<br>
/// by your application to prevent this session cookie being used by other CSP application<br>
/// on this machine, or from being seen by any other application on this web server.<br>
Property CookiePath As %String(MAXLEN = 256);

/// Indicates whether this application will process CSP/Zen Pages (CSP Only).
Property CSPZENEnabled As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// Prevent login CSRF attack (CSP only).<br>
/// When enabled generate a token and cookie in the login page that is validated before accepting 
/// any username/password. Enabling this will prevent programatic access to pages in this application 
/// that just pass in the username/password on the initial request. 
Property CSRFToken As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// Indicates whether DeepSee access is enabled for this application
Property DeepSeeEnabled As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// Application description.<br>
Property Description As %String(MAXLEN = 256);

/// If defined this will dispatch all requests in this CSP application to this one class.
/// This will bypass the normal url to classname conversion so allowing the specified
/// class complete control over this dispatch of the page. A predefined dispatch class
/// that can be used is '%25CSP.REST' which provides REST dispatch capabilities.
Property DispatchClass As %String(MAXLEN = 256);

/// Application is enabled.<br>
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// A CSP or CLS page that will be displayed if an error occurs when generating the page (CSP Only).<br>
Property ErrorPage As %String(MAXLEN = 256);

/// This specifies the class whose methods are invoked for CSP application events,<br>
/// such as a timeout (CSP Only).
Property EventClass As %String(MAXLEN = 64);

/// Indicates whether this application's authentication will move in sync with other applications in the same id group (CSP Only).
Property GroupById As %String(MAXLEN = 64);

/// <b>DEPRECATED</b>, no longer used in 2008.2. <br>
Property HyperEvent As %Integer(MAXVAL = 3, MINVAL = 0) [ InitialExpression = 0, Internal ];

/// Indicates whether iKnow access is enabled for this application
Property iKnowEnabled As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// Indicates whether this application will process Web Services (CSP Only).
Property InbndWebServicesEnabled As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// Indicates that this application is the default application for its namespace. 
/// As such it will be returned by the call $System.CSP.GetDefaultApp()
Property IsNameSpaceDefault As Security.Datatype.BooleanYN [ InitialExpression = 0 ];

/// Lock CSP Name (CSP Only). <br>
/// If true then you can only access this CSP page if the url you enter matches
/// the url stored in the CSPURL parameter value in the class. CSP pages have
/// the CSPURL set to the original url requested automatically when they are
/// compiled. If the url does not match you get a page not found error. For
/// example if you have two CSP applications defined that both map to the same
/// namespace and the same directory '/A' and '/B'. Then you view '/A/page.csp'
/// this will load this page and create the class 'csp.page' with the CSPURL
/// parameter set to '/A/page.csp'. With this flag set you may only access this
/// page using the url '/A/page.csp'. If this flag is false you may access it
/// via the pages '/B/page.csp', '/A/csp.page.cls', '/B/csp.page.cls'. The Cache
/// 5.0 behavior was for this flag to be off. Note that the flag is checked on
/// the application associated with the CSPURL parameter, so even if the '/B'
/// application has the flag turned off, if the '/A' application has it turned
/// on you will get a page not found error from '/B/page.csp'. If you modify the
/// CSP class and change the CSPURL="" then this disables checking for this
/// page.
Property LockCSPName As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// A predefined login page that can be sent out to the browser if the application requires<br>
/// an authenticated identity and one is not available yet (CSP Only).<br>
Property LoginPage As %String(MAXLEN = 256);

/// Mapping of Match Roles to added Target Roles.<br>
/// MatchRoles are in the format:<br>
/// MatchRole:TargetRole1:TargetRole2<br>
/// To specify a role to always be granted to an application, set
/// MatchRole="", i.e. (:TargetRole1)<br>
Property MatchRoles As list Of %String(MAXLEN = 32767);

/// Short Name for Application. Must start with an alpha character and be
/// followed by alpha, numeric, or underscore characters.  
/// Must be a legal global subscript.<br>
/// CSP applications usually start with "/csp".<br>
/// Client Applications are in the format AppName.EXE.<br>
/// Privileged routines can be any format.<br>
Property Name As %String(MAXLEN = 64, MINLEN = 1) [ Required ];

Property NameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly, Required ];

/// The Cache server namespace where pages for this application are run (CSP Only).<br>
Property NameSpace As %String(MAXLEN = 64);

/// Force the namespace to be uppercase.<br>
Method NameSpaceSet(Val) As %Status [ Internal ]
{
}

/// Specifies the package to prefix to the class name for all CSP files in this application.<br>
/// If not specified it defaults to "csp" (CSP Only).<br>
Property Package As %String(MAXLEN = 64);

/// This specifies the physical path (directory) for the CSP files on the Caché server (CSP Only).<br>
Property Path As %String(MAXLEN = 256);

/// A name pattern which is used by the CSP Server to limit the classes which may be run in this application. <br>
/// This is a COS pattern, (1"B",1"A".1N) match {B.cls, A0.cls ... A9.cls} <br>
Property PermittedClasses As %String(MAXLEN = "");

/// This specifies whether to use subdirectories (CSP Only).<br>
/// If WPath is the Web Path and PPath is the Physical Path, then with recurse turned on,<br>
/// WPath/xxx/yyy will look in PPath/xxx/yyy. If recurse is turned off, only files directly<br>
/// contained in WPath are used.
Property Recurse As Security.Datatype.BooleanYN [ InitialExpression = 1 ];

/// The Resource name that controls access to this application.<br>
/// If no resource is defined, then it is a public application which
/// anyone can run.<br>
Property Resource As %String(MAXLEN = 64, MINLEN = 0);

/// List of Routines that can invoke this application (Privileged routine applications only).<br>
/// These are in the format Routine/Class:dbname:Flag, where dbname is 
/// the name of the database where the routine resides; Flag=0 is a routine, Flag=1 is a class name.
Property Routines As list Of %String(MAXLEN = 32767);

/// Allows the web server built into Caché to serve up static files, e.g., html or jpg files,<br>
/// from this application path (CSP Only).<br>
/// This also allows the stream server to serve files from this path.<br>
/// 0 - No - Never serve files from this application path<br>
/// 1 - Always - Always serve files from this application path, ignore CSP security setting for this path for static files. This is the default for new applications as it is backward compatible with serving files from the web server.<br>
/// 2 - Always and cached - Always serve files from this application path and allow the CSP gateway to cache these files to avoid having to request them from Cache. This is the mode we expect deployed application to use<br>
/// 3 - Use CSP security - If the user has permissions to view a csp/cls page in this application then allow them to view a static file, if they do not have permissions to view a csp/cls page then return a 404 page not found page.<br>
Property ServeFiles As %Integer(DISPLAYLIST = ",No,Always,Always and cached,Use CSP security", VALUELIST = ",0,1,2,3") [ InitialExpression = 1 ];

/// Time, in seconds, of how long to cache static files.<br>
Property ServeFilesTimeout As %Integer [ InitialExpression = 3600 ];

/// This specifies the default superclass (CSP Only).<br>
/// If blank, it defaults to %CSP.Page.<br>
Property SuperClass As %String(MAXLEN = 1024);

/// This specifies the default session timeout, in seconds (CSP Only).<br>
Property Timeout As %Integer(MAXVAL = 100000, MINVAL = 0) [ InitialExpression = 900 ];

/// This specifies whether to use two-factor authentication for this application (CSP Only).<br>
/// Two Factor Authentication is used with Password authentication which causes a security token to be<br>
/// sent to the user. To complete authentication the user must enter the security token.
Property TwoFactorEnabled As Security.Datatype.BooleanYN [ InitialExpression = 0, Internal ];

/// Type - Bitmap describing the type of application<br>
/// Bit 0 = System Application - Reserved<br>
/// Bit 1 = CSP Application (Default)<br>
/// Bit 2 = Privileged routine application<br>
/// Bit 3 - Client Application<br>
Property Type As Security.Datatype.ApplicationType(MAXVAL = 9, MINVAL = 2) [ InitialExpression = 2 ];

/// This specifies whether to use cookies for CSP session management or not (CSP Only).<br>
/// You can set this on a per-application basis. It does NOT affect the user's use of<br>
/// cookies in their application, simply how Caché manages the session. The available<br>
/// options are:<br>
/// 'Never' use cookies - This will just use the CSPCHD parameter to persist the session<br>
/// state from page to page and will not send a cookie to the browser at all.<br>
/// 'AutoDetect' (the default) - This will start by sending the cookie to the browser and<br>
/// also including the CSPCHD parameter in all the links and forms. Then when the user clicks<br>
/// on the next link if the browser accepted the cookie it will switch to the 'Always'<br>
/// mode and turn off the use of the CSPCHD parameters. If the browser did not accept<br>
/// the cookie it will turn into the 'Never' mode.<br>
/// 'Always' use cookies - Do not include the CSPCHD parameter.<br>
/// 0 = Never, 1 = AutoDetect, 2 = Always
Property UseCookies As %Integer(DISPLAYLIST = ",Never,AutoDetect,Always", VALUELIST = ",0,1,2") [ InitialExpression = 2 ];

/// Copy an application.<br>
/// Copy an existing application in the Security database to a new one.<br>
/// Parameters:<br>
/// Name - Name of the Application to be copied<br>
/// NewName - Name of the Application to be created<br>
/// NewDescription - Full name of the application<br>
ClassMethod Copy(Name As %String, NewName As %String, NewDescription As %String = "") As %Status
{
}

/// Create an Application.<br>
/// Create an Application in the Security database.<br>
/// Parameters:<br>
/// Name - Name of the application to create<br>
/// Properties - Array of properties to set.<br>
/// Properties only need to be defined if required for that type of application. 
/// Properties are in the format defined by the property definitions for the class
/// with the following exceptions:<br><br>
/// "MatchRoles" - MatchRole/TargetRoles pairs to assign to the application<br>
/// MatchRoles are in the format:<br>
/// MatchRole1:TargetRole1:TargetRole2,MatchRole2:TargetRole3:TargetRole4<br>
/// "Routines" - Routine/Database pairs<br>
/// Routines are in the format:<br>
/// Routine1:dbname:Flag,Routine2:dbname:Flag<br>
/// "ClientApplications" - Client application identification hash<br>
/// ClientApplications are in the format:<br>
/// Hash,Hash1,Hash2<br><br>
/// For CSP applications, if the path specified does not exist, it is created.
ClassMethod Create(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Delete an Application.<br>
/// This method will delete an application from the security database.<br>
/// Parameters:<br>
/// Name - Name of application to delete<br>
ClassMethod Delete(Name As %String) As %Status
{
}

/// Application exists.<br>
/// This method checks for the existence of an application in the security database.<br>
/// Parameters:<br>
/// Name - Name of the application to check existence of<br>
/// Return values:<br>
/// If Value of the method = 0 (Application does not exist, or some error occured)<br>
/// Application = Null<br>
/// Status = Application "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Application exists)<br>
/// Application = Object handle to application<br>
/// Status = $$$OK<br>
ClassMethod Exists(Name As %String, ByRef Application As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports Application records to a file in xml format.<br>
/// Parameters:<br>
/// FileName - Output file name<br>
/// NumExported (byref) - Returns number of records exported<br>
/// Applications - Comma separated list of Applications to export, "*" = All<br>
/// Type - Type of applications to export, -1 = all<br>
/// Bit 0 = System Application - Reserved<br>
/// Bit 1 = CSP Application<br>
/// Bit 2 = Privileged routine application<br>
/// Bit 3 - Client Application<br>
ClassMethod Export(FileName As %String = "ApplicationsExport.xml", ByRef NumExported As %Integer, Applications As %String = "*", Type As %Integer = -1) As %Status
{
}

/// Get an application's properties.<br>
/// Gets an applications properties from the security database.<br>
/// Parameters:<br>
/// Name - Name of the application to get<br>
/// Return values:<br>
/// Properties - See the Create method for more information on properties returned
ClassMethod Get(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Get an application's properties.<br>
/// Gets an applications properties from the security database.<br>
/// Parameters:<br>
/// Application - Object handle to an application record<br>
/// Return values:<br>
/// Properties - See the Create method for more information on properties returned
ClassMethod GetProperties(Application As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Return a hash value and last modified timestamp for a visual basic cache direct executable
ClassMethod GetClientApplicationHash(FileName As %String, ByRef Hash As %Integer) As %Status
{
}

/// Import Applications records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Application records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "ApplicationsExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Initialize database of built-in Applications.<br>
ClassMethod Initialize(SecuritySetting As %String = "None", NewInstall As %Boolean = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

/// Application is public.<br>
Method IsPublic() As %Boolean
{
}

/// Modify an aplication.<br>
/// Modify an existing application's properties in the security database.<br>
/// Parameters:<br>
/// Name - Name of the application to modify<br>
/// Properties - Array of properties to modify.<br>
/// See the Create() method for a description of the Properties parameter.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String) As %Status
{
}

/// Given an application name, return its description
ClassMethod NameToDescription(Name As %String, Description As %String) As %String [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%OnDelete</METHOD> method of
/// the Roles class to provide notification that the role is being removed
ClassMethod RemoveRoleFromAllApplications(RoleName As %String) As %Status [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>RemoveRolesFromApplications</METHOD> class method 
/// to provide notification that the role is being removed.
/// 
Method RemoveRoleFromApplication(RoleName As %String) As %Status [ Internal ]
{
}

/// Initialize an EMS client when an application changes
ClassMethod StartEMS() [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Private ]
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
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private ]
{
}

/// Detail all Application records, brief display. <br>
/// Names - Comma separated list of application names, "*" = All<br>
/// Type - Type of application, -1 = all<br>
/// Bit 0 = System Application - Reserved<br>
/// Bit 1 = CSP Application<br>
/// Bit 2 = Privileged routine application<br>
/// Bit 3 - Client Application<br>
/// Note: This query may change in future versions<br>
Query Detail(Names As %String, Type As %Integer) As %Query(ROWSPEC = "Name:%String,Type:%String,Description:%String,Enabled:%String,AddedRoles:%String,MatchRoles:%String,Resource:%String,Routines:%String,ClientApplications:%String,AutheEnabled:%String,AutoCompile:%String,CookiePath:%String,CSPZENEnabled:%String,DispatchClass:%String,ErrorPage:%String,EventClass:%String,GroupById:%String,HyperEvent:%String,InbndWebServicesEnabled:%String,IsNameSpaceDefault:%String,LockCSPName:%String,LoginPage:%String,ChangePasswordPage:%String,NameSpace:%String,Package:%String,Path:%String,PermittedClasses:%String,Recurse:%String,Resource:%String,ServeFiles:%String,ServeFilesTimeout:%String,SuperClass:%String,Timeout:%String,TwoFactorEnabled:%String,UseCookies:%String,DeepSeeEnabled:%String,iKnowEnabled:%String,CSRFToken:%String") [ SqlProc ]
{
}

ClassMethod DetailExecute(ByRef qHandle As %Binary, Names As %String = "*", Type As %Integer = -1) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod DetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

ClassMethod DetailClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = DetailExecute ]
{
}

/// List all Application records.<br>
/// Names - Comma separated list of application names, "*" = All<br>
/// Type - Type of application, -1 = all<br>
/// Bit 0 = System Application - Reserved<br>
/// Bit 1 = CSP Application<br>
/// Bit 2 = Privileged routine application<br>
/// Bit 3 - Client Application<br>
/// Note: This query may change in future versions<br>
Query List(Names As %String, Type As %Integer, Filter As %String) As %Query(ROWSPEC = "Name:%String,Namespace:%String,Namespace Default:%String,Enabled:%String,Type:%String,Resource:%String,Authentication Methods:%String,IsSystemApp:%Boolean") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", Type As %Integer = -1, Filter As %String = "") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// List Application records associated with a namespace.<br>
/// Namespaces - Comma separated list of namespace names, "*" = All<br>
/// Note: This query may change in future versions<br>
Query NamespaceList(Namespaces As %String) As %Query(ROWSPEC = "Name:%String,Path:%String") [ SqlProc ]
{
}

ClassMethod NamespaceListExecute(ByRef qHandle As %Binary, Namespaces As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod NamespaceListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = NamespaceListExecute ]
{
}

ClassMethod NamespaceListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = NamespaceListExecute ]
{
}

/// Extent query of Service.Applications excluding Client Applications 
Query EMSExtent() As %SQLQuery(CONTAINID = 1) [ Internal ]
{
SELECT ID FROM Applications
 WHERE (Type NOT= 8)
}

Storage Default
{
<Data name="ApplicationsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AutheEnabled</Value>
</Value>
<Value name="3">
<Value>AutoCompile</Value>
</Value>
<Value name="4">
<Value>ClientApplications</Value>
</Value>
<Value name="5">
<Value>CookiePath</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>Enabled</Value>
</Value>
<Value name="8">
<Value>ErrorPage</Value>
</Value>
<Value name="9">
<Value>EventClass</Value>
</Value>
<Value name="10">
<Value>HyperEvent</Value>
</Value>
<Value name="11">
<Value>LockCSPName</Value>
</Value>
<Value name="12">
<Value>LoginPage</Value>
</Value>
<Value name="13">
<Value>MatchRoles</Value>
</Value>
<Value name="14">
<Value>Name</Value>
</Value>
<Value name="15">
<Value>NameSpace</Value>
</Value>
<Value name="16">
<Value>Package</Value>
</Value>
<Value name="17">
<Value>Path</Value>
</Value>
<Value name="18">
<Value>Recurse</Value>
</Value>
<Value name="19">
<Value>Resource</Value>
</Value>
<Value name="20">
<Value>Routines</Value>
</Value>
<Value name="21">
<Value>ServeFiles</Value>
</Value>
<Value name="22">
<Value>SuperClass</Value>
</Value>
<Value name="23">
<Value>Timeout</Value>
</Value>
<Value name="24">
<Value>Type</Value>
</Value>
<Value name="25">
<Value>UseCookies</Value>
</Value>
<Value name="26">
<Value>ChangePasswordPage</Value>
</Value>
<Value name="27">
<Value>ServeFilesTimeout</Value>
</Value>
<Value name="28">
<Value>TwoFactorEnabled</Value>
</Value>
<Value name="29">
<Value>CSPZENEnabled</Value>
</Value>
<Value name="30">
<Value>InbndWebServicesEnabled</Value>
</Value>
<Value name="31">
<Value>GroupById</Value>
</Value>
<Value name="32">
<Value>IsNameSpaceDefault</Value>
</Value>
<Value name="33">
<Value>PermittedClasses</Value>
</Value>
<Value name="34">
<Value>DispatchClass</Value>
</Value>
<Value name="35">
<Value>DeepSeeEnabled</Value>
</Value>
<Value name="36">
<Value>iKnowEnabled</Value>
</Value>
<Value name="37">
<Value>CSRFToken</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ApplicationsD")</DataLocation>
<DefaultData>UsersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ApplicationsD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ApplicationsI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","ApplicationsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
