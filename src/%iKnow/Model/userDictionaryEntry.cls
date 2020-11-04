/// Model representation of an <class>%iKnow.UserDictionary</class> entry, as nested in a
/// <class>%iKnow.Model.userDictionary</class> element. 
Class %iKnow.Model.userDictionaryEntry Extends %iKnow.Model.node [ System = 3 ]
{

Parameter XMLNAME = "entry";

Relationship userDictionary As %iKnow.Model.userDictionary(XMLPROJECTION = "none") [ Cardinality = one, Inverse = entries ];

/// String to replace in user input.
Property rewriteFrom As %String(XMLPROJECTION = "ATTRIBUTE") [ Required ];

/// String to replace <property>rewriteFrom</property> with.
Property rewriteTo As %String(XMLPROJECTION = "ATTRIBUTE");

/// Label to assign to <property>rewriteFrom</property>
Property assignLabel As %String(VALUELIST = ",UDNegation,UDPosSentiment,UDNegSentiment", XMLPROJECTION = "ATTRIBUTE");

/*
	Remove DISPLAYLIST pending prodlog 133803
Property assignLabel As %String(DISPLAYLIST = ",negation,positive sentiment,negative sentiment", VALUELIST = ",UDNegation,UDPosSentiment,UDNegSentiment", XMLPROJECTION = "ATTRIBUTE");
*/
Method %Validate(pDomainId As %Integer, pDomainDefinition As %iKnow.Model.domain) As %Status
{
	set tSC = $$$OK
	try {
		
		if (..rewriteFrom="") {
			set tSC = $$$ERROR($$$GeneralError, "'rewriteFrom' is a required attribute for <entry>")
			quit
		}
		
		if (..rewriteTo="") && (..assignLabel="") {
			set tSC = $$$ERROR($$$GeneralError, "Either 'rewriteTo' or 'assignLabel' needs to be supplied for <entry>")
			quit
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

}
