/// This pages shows the output of a DeepSee cube definition compilation.
Class %DeepSee.UI.Dialog.CubeCompileOutput Extends %CSP.Page [ System = 4 ]
{

/// Set this to the correct domain.
Parameter DOMAIN = "%Utility";

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
	Set tSC = $$$OK
	Try {
		Set tUse = $System.Security.Check("%DeepSee_Architect","USE")||
				$System.Security.Check("%DeepSee_ArchitectEdit","USE")

		If 'tUse {
			Quit
		}
		Set tClass = $G(%request.Data("CUBECLASS",1))
		&html<<html><head></head>>
		&html<<body>>
		If tClass = "" {
			Write $$$TextHTML("Class name is empty. Nothing to compile.")
			&html<</body></html>>
			Quit
		}
		New %SourceControl
		Set tSC = ##class(%CSP.Portal.SourceControl.Util).CreateSourceControl(.tSourceControl,.tCreated)
		If $$$ISOK(tSC) && $get(tCreated) {
			Set %SourceControl = tSourceControl
		}
		Set ^CacheTemp.DeepSeeCubeCompile($Username,tClass,+$J) = $H
		Write $$$FormatText($$$Text("Compiling class: %1"),tClass),"<br/>"
		Do %response.Flush()
		&html<<pre>>
		Do $System.OBJ.Compile(tClass)
		&html<</pre>>
		Write $$$Text("Complete"),"<br/>"
		Do %response.Flush()
		Set ^CacheTemp.DeepSeeCubeCompile($Username,tClass,+$J) = "Done"
		&html<</body>>
		&html<</html>>
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}

	Quit $$$OK
}

}
