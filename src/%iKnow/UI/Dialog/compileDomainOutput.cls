Class %iKnow.UI.Dialog.compileDomainOutput Extends %CSP.Page [ System = 4 ]
{

Parameter SECURITYRESOURCE = "%Development";

/// Set this to the correct domain.
Parameter DOMAIN = "%Utility";

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
	Set tSC = $$$OK
	Try 
	{
		Set tClass = $G(%request.Data("DOMAINDEF",1))
		&html<<html><head></head>>
		&html<<body>>
		If tClass = "" {
			Write $$$TextHTML("Class name is empty. Nothing to compile.")
			&html<</body></html>>
			Quit
		}
		Set ^CacheTemp.iKnowDomainCompile($Username,tClass,+$J) = $H
		Write $$$FormatText($$$Text("Compiling class: %1"),tClass),"<br/>"
		Do %response.Flush()
		&html<<pre>>
		Set model = ##class(%iKnow.UI.Architect).%GetModel(tClass)
		do model.%SaveToClass(tClass,0,1,1,"%iKnow.DomainDefinition")
		&html<</pre>>
		Write $$$Text("Complete"),"<br/>"
		Do %response.Flush()
		Set ^CacheTemp.iKnowDomainCompile($Username,tClass,+$J) = "Done"
		&html<</body>>
		&html<</html>>
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	Quit $$$OK
}

}
