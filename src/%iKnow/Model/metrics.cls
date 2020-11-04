Class %iKnow.Model.metrics Extends %iKnow.Model.node [ System = 3 ]
{

/// If set to 1, this element is ignored when compiling, validating and building the domain.
/// This property is ignored in Metric Definitions (outside of a Domain Definition).
Property disabled As %Boolean(XMLPROJECTION = "attribute");

Relationship metrics As %iKnow.Model.metric(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = many, Inverse = group ];

/// Whether or not metrics are to be built as part of the Domain Definition's %Build() method.
/// This property is ignored in Metric Definitions (outside of a Domain Definition).
Property autoExecute As %Boolean(XMLPROJECTION = "ATTRIBUTE");

Method %Validate(pDomainId As %Integer, pDomainDefinition As %iKnow.Model.domain = "") As %Status
{
	set tSC = $$$OK
	try {
		quit:..disabled
		
		// check individual metric definitions
		for i = 1:1:..metrics.Count() {
			set tSC = ..metrics.GetAt(i).%Validate(pDomainId, pDomainDefinition)
			quit:$$$ISERR(tSC)
		}
		quit:$$$ISERR(tSC)
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
