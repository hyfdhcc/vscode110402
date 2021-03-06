Include %occInclude

/// Sample Installer
Class Net.Provision.Installer
{

/// Application Definition
XData Install [ XMLNamespace = INSTALLER ]
{
<Manifest>
<Namespace>
<!-- Invoke a helper method on this installer class -->
<Invoke Class="Net.Provision.Installer" Method="OSAuth" CheckStatus="1"/>

<!-- Load manifest classes (if they exist) -->
<If Condition='#{##class(%File).DirectoryExists("${INSTALLDIR}/manifest/")}'>
<!-- Load a directory full of files, ignore error 5202 ... -->
<Import File="${INSTALLDIR}/manifest/" IgnoreErrors="5202" Flags="ck"/>

<!-- Configure user manifest -->
<Invoke Class="Default.Installer" Method="setup" CheckStatus="1">
</Invoke>
</If>

</Namespace>
</Manifest>
}

/// This is a method generator whose code is generated by XGL.
ClassMethod setup(ByRef pVars, pLogLevel As %Integer, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
	#; Let our XGL document generate code for this method. 
	Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

/// Provision method to set OS Authentication
ClassMethod OSAuth() As %Status [ Internal ]
{
	s System=##Class(Security.System).%OpenId("SYSTEM")
	i +System=0 s System=##Class(Security.System).%New()
	s System.AutheEnabled=$zb(+System.AutheEnabled,$$$AutheOS,7)
	s System.AutheEnabled=$zb(+System.AutheEnabled,$$$AutheOSDelegated,2)
	#;Now save the system object
	s Status=System.%Save()
	k System
	Q Status
}

}
