/// This is a "namespace" activity within a Manifest document
Class %Installer.Namespace Extends %Installer.Sequence [ ServerOnly = 1, System = 3 ]
{

/// Namespace name
Property Target As %String(XMLNAME = "Name") [ Required ];

/// Code Database
Property Code As %String;

/// Data Database
Property Data As %String;

/// Create flags
Property Create As %String(VALUELIST = ",yes,no,overwrite") [ InitialExpression = "yes" ];

/// Ensemble flag
Property Ensemble As %String;

/// Ensemble portal suffix
Property EnsemblePortalSuffix As %String(MAXLEN = 256);

/// Ensemble portal prefix
Property EnsemblePortalPrefix As %String(MAXLEN = 256);

/// Ensemble portal cookie path
Property EnsemblePortalCookiePath As %String(MAXLEN = 256);

/// Resource(s) granted when logged in
Property EnsemblePortalGrant As %String(MAXLEN = 512);

/// Authentication flags (4=Kerberos, 32=Password, 64=Unauthenticated)
Property EnsemblePortalAuthMethods As %String [ InitialExpression = "36" ];

/// Generate starting code for this document.
Method %OnBeforeGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	#dim tConfiguration As %XGEN.AbstractElement
	
	Do pCode.WriteLine(..%Indent()_"// <Namespace>")
	
	Set tConfiguration = ..findChild("Configuration")
	If $IsObject(tConfiguration) {
	
		#dim tDatabase As %XGEN.AbstractElement
		
		// Dig out the first Database item
		Set tDatabase = tConfiguration.findChild("Database")
		If $IsObject(tDatabase) {
			Set:..Code="" ..Code = tDatabase.Target
			Set:..Data="" ..Data = tDatabase.Target
		}
	}

	// NOTE: These are actually used by the Configuration class' code generator
	Do pCode.WriteLine(..%Indent()_"Set tNSName = $$$EVAL("_..Target_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSCodeDB = $$$EVAL("_..Code_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSDataDB = $$$EVAL("_..Data_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSFlags = $$$EVAL("_..Create_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSEnsemble = $$$EVAL("_..Ensemble_")")
	Do pCode.WriteLine(..%Indent()_"Set:tNSEnsemble="""" tNSEnsemble=##class(%EnsembleMgr).IsEnsembleInstalled()")
	Do pCode.WriteLine(..%Indent()_"Set tNSEnsPortalSuffix = $$$EVAL("_..EnsemblePortalSuffix_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSEnsPortalPrefix = $$$EVAL("_..EnsemblePortalPrefix_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSEnsPortalCookiePath = $$$EVAL("_..EnsemblePortalCookiePath_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSEnsPortalGrant = $$$EVAL("_..EnsemblePortalGrant_")")
	Do pCode.WriteLine(..%Indent()_"Set tNSEnsPortalAuthMethods = $$$EVAL("_..EnsemblePortalAuthMethods_")")
	
	Set ..%level = ..%level - 1
	
	Quit $$$OK
}

/// Generate code for this document.
Method %OnAfterGenerateCode(pTargetClass As %Dictionary.CompiledClass, pCode As %Stream.TmpCharacter, pDocument As %Installer.Manifest) As %Status [ Internal ]
{
	Set ..%level = ..%level + 1
	
	// Clear the value of tNSName
	Do pCode.WriteLine(..%Indent()_"Set tNSName = """"")
	Do pCode.WriteLine(..%Indent()_"// </Namespace>")
	Quit $$$OK
}

}
