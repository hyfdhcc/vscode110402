Include %syGluedef

/// jsonProvider restricted to use the set of callbacks that Zen Mojo uses
Class %ZEN.Mojo.Component.mojoJsonProvider Extends %ZEN.Auxiliary.jsonProvider [ System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

Property OnGetArray As %ZEN.Datatype.delegator(FORMALSPEC = "&pParameters:%String,*pMetaData,*pData", RETURNTYPE = "%Status", ZENENCRYPT = 0);

Property OnGetTargetObject As %ZEN.Datatype.delegator(FORMALSPEC = "&pParameters:%String,*pObject:%RegisteredObject", RETURNTYPE = "%Status", ZENENCRYPT = 0);

Property OnRenderJSON As %ZEN.Datatype.delegator(FORMALSPEC = "&pParameters:%String", RETURNTYPE = "%Status", ZENENCRYPT = 0);

Property OnSubmitContent As %ZEN.Datatype.delegator(FORMALSPEC = "pCommand:%String,pProvider:%ZEN.Auxiliary.jsonProvider,pSubmitObject:%RegisteredObject,&pResponseObject:%RegisteredObject", RETURNTYPE = "%Status", ZENENCRYPT = 0);

/// Invoke the OnGetArray callback.
Method %OnGetArray(ByRef pParms, Output pMetaData, Output pData) As %Status [ Internal ]
{
	Set tSC = ..%ValidateCallback("OnGetArray")
	Quit:$$$ISERR(tSC) tSC
	
	Quit ##super(.pParms,.pMetaData,.pData)
}

/// Invoke the OnGetTargetObject callback.
Method %OnGetTargetObject(ByRef pParms, Output pObject As %RegisteredObject) As %Status [ Internal ]
{
	Set tSC = ..%ValidateCallback("OnGetTargetObject")
	Quit:$$$ISERR(tSC) tSC
	
	Quit ##super(.pParms,.pObject)
}

/// Invoke the <property>OnSubmitContent</property> callback.<br/>
/// If <var>pResponseObject</var> is returned, then it is passed back to the client.
Method %OnSubmitContent(pCommand As %String, pSubmitObject As %RegisteredObject, ByRef pResponseObject As %RegisteredObject) As %Status [ Internal ]
{
	Set tSC = ..%ValidateCallback("OnSubmitContent")
	Quit:$$$ISERR(tSC) tSC
	
	Quit ##super(pCommand,pSubmitObject,.pResponseObject)
}

/// Invoke the <property>OnRenderJSON</property> callback.
Method %OnRenderJSON(ByRef pParms) As %Status [ Internal ]
{
	Set tSC = ..%ValidateCallback("OnRenderJSON")
	Quit:$$$ISERR(tSC) tSC
	
	Quit ##super(.pParms)
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
