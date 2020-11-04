/// Model representation of a blacklist, containing entities to be left out of processing
Class %iKnow.Model.blacklist Extends %iKnow.Model.node [ System = 4 ]
{

Relationship domain As %iKnow.Model.domain(XMLPROJECTION = "none") [ Cardinality = one, Inverse = blacklists ];

/// Name of the blacklist
Property name As %String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

Property description As %String(XMLPROJECTION = "ATTRIBUTE");

Property entries As list Of %String(XMLNAME = "entry", XMLPROJECTION = "ELEMENT");

Method %Validate(pDomainId As %Integer, pDomainDefinition As %iKnow.Model.domain) As %Status
{
	set tSC = $$$OK
	try {
		
		if (..name="") { 
			set tSC = $$$ERROR($$$GeneralError, "Blacklist name is a required field")
			quit
		} else {
			set tBLId = ##class(%iKnow.Utils.MaintenanceAPI).GetBlackListId(pDomainId, ..name)
			set tBLObj = ##class(%iKnow.Objects.BlackList).PKINDEXOpen(pDomainId, tBLId)
			if $isobject(tBLObj) {
				set tDefClass = ^ISC.IK.Sys.Params(pDomainId,$$$IKPDEFINITIONCLASS)
				if tDefClass'=tBLObj.ManagerClass {
					set tSC = $$$ERROR($$$IKBlackListExists, ..name)
					quit
				}
			}
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
