Class %ZEN.Mojo.Component.mojoHtml Extends %ZEN.Component.html [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

/// Optional.
/// Name of Server-side callback method that provides HTML content
/// for this component.<br>
/// If defined, this callback is invoked on the server when this 
/// component is drawn. It provides HTML content by using &html or
/// by using the WRITE command.<br>
/// This must be the name of a ZenMethod in the page
/// class that contains this view component.
Property OnDrawContent As %ZEN.Datatype.delegator(FORMALSPEC = "seed:%ZEN.Datatype.string", RETURNTYPE = "%Status", ZENENCRYPT = 0);

/// Invoke user method to provide contents for this HTML
/// component.
Method %DrawContent() As %Status
{
	Set tSC = ..%ValidateCallback("OnDrawContent")
	Quit:$$$ISERR(tSC) tSC
	Quit ##super()
}

Method %ValidateCallback(pCallbackName) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
	Set tMethod = $Property($this,pCallbackName)
	If ($IsObject(tHost) && (tMethod '= "")) {
		$$$comMemberKeyGetLvar(tZENMETHOD,tHost.%ClassName(1),$$$cCLASSmethod,tMethod,$$$cMETHzenmethod)
		If ('tZENMETHOD) {
			Set tSC = $$$ERROR($$$GeneralError,$$$FormatText("Attempt to call non-ZENMethod: %1",tHost.%ClassName(1)_":"_tMethod))
		}
	}
	Quit tSC
}

}
