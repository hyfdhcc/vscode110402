/// This is a "CSPApplication" activity within a Manifest document
Class %Installer.CSPApplication Extends %Installer.Activity [ ServerOnly = 1, System = 3 ]
{

/// Application URL
Property Url As %String(MAXLEN = 1024) [ Required ];

/// Application Description
Property Description As %String(MAXLEN = 1024);

/// Application Directory
Property Directory As %String(MAXLEN = 1024) [ Required ];

/// Application Resource
Property Resource As %String;

/// Resource(s) granted when logged in
Property Grant As %String(MAXLEN = 512);

/// Recurse flag
Property Recurse As %Boolean [ InitialExpression = 0 ];

/// Login class
Property LoginClass As %String(MAXLEN = 128);

/// Cookie Path
Property CookiePath As %String(MAXLEN = 256);

/// Authentication flags (4=Kerberos, 32=Password, 64=Unauthenticated). <br>
/// If not specified, the default value depends on the installation type
Property AuthenticationMethods As %String;

/// Lock CSP Name property
Property LockCSPName As %Boolean [ InitialExpression = 1 ];

/// Event Class
Property EventClass As %String(MAXLEN = 256);

/// Default timeout
Property DefaultTimeout As %Integer;

/// Default Superclass 
Property DefaultSuperclass As %String(MAXLEN = 256);

/// Use Cookie for Session 
Property UseSessionCookie As %Integer;

/// Serve Files 
Property ServeFiles As %Boolean;

/// Serve Files Timeout 
Property ServeFilesTimeout As %Integer;

/// Custom Error Page 
Property CustomErrorPage As %String(MAXLEN = 1024);

/// Package Name 
Property PackageName As %String(MAXLEN = 256);

/// Change Password Page
Property ChangePasswordPage As %String(MAXLEN = 1024);

/// Group By ID
Property GroupById As %String(MAXLEN = 1024);

/// CSP ZEN Enabled
Property CSPZENEnabled As %Boolean [ InitialExpression = 1 ];

/// Inbound web services enabled
Property InboundWebServicesEnabled As %Boolean [ InitialExpression = 1 ];

/// Two factor authentication enabled
Property TwoFactorEnabled As %Boolean [ InitialExpression = 0 ];

/// Is Namespace default
Property IsNamespaceDefault As %Boolean [ InitialExpression = 0 ];

/// PermittedClasses default
Property PermittedClasses As %String;

/// Autocompile flag
Property AutoCompile As %Boolean [ InitialExpression = 1 ];

/// Generate code for this document.
Method %OnGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Do pCode.WriteLine(..%Indent()_"Do tInstaller.CSPApplication($$$EVAL("_..Url_"),tNSName,$$$EVAL("_..Description_"),$$$EVAL("_..Directory_"),$$$EVAL("_..Resource_"),$$$EVAL("_..Recurse_"),$$$EVAL("_..LoginClass_"),tInstaller.Evaluate("""_..Grant_"""),tInstaller.Evaluate("""_..CookiePath_"""),tInstaller.Evaluate("""_..AuthenticationMethods_"""),tInstaller.Evaluate("""_..LockCSPName_"""),tInstaller.Evaluate("""_..EventClass_"""),tInstaller.Evaluate("""_..DefaultTimeout_"""),tInstaller.Evaluate("""_..DefaultSuperclass_"""),tInstaller.Evaluate("""_..UseSessionCookie_"""),tInstaller.Evaluate("""_..ServeFiles_"""),tInstaller.Evaluate("""_..ServeFilesTimeout_"""),tInstaller.Evaluate("""_..CustomErrorPage_"""),tInstaller.Evaluate("""_..PackageName_"""),tInstaller.Evaluate("""_..ChangePasswordPage_"""),tInstaller.Evaluate("""_..GroupById_"""),tInstaller.Evaluate("""_..CSPZENEnabled_"""),tInstaller.Evaluate("""_..InboundWebServicesEnabled_"""),tInstaller.Evaluate("""_..TwoFactorEnabled_"""),tInstaller.Evaluate("""_..IsNamespaceDefault_"""),tInstaller.Evaluate("""_..PermittedClasses_"""),tInstaller.Evaluate("""_..AutoCompile_"""))")
	Quit $$$OK
}

}
