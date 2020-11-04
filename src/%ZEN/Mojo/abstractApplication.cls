/// Foundation class for application classes within Zen Mojo.
/// Applications should extend this class.
Class %ZEN.Mojo.abstractApplication Extends (%ZEN.application, %ZEN.Mojo.localizableObject)
{

/// This is the name of this application.
Parameter APPLICATIONNAME = "Zen Mojo";

/// Domain used for localization.
Parameter DOMAIN = "%ZEN";

/// This is the URL of the main starting page of this application.
Parameter HOMEPAGE;

/// This Style block contains application-wide CSS style definitions in alphabetical order.
XData Style
{
<style type="text/css">
</style>
}

/// Return an object containing the various configured settings for the portal.
ClassMethod %GetAppSettings(pPage As %String = "", pMode As %String = "") As %ZEN.proxyObject
{
	Set tInfo = ##class(%ZEN.proxyObject).%New()
	Quit tInfo
}

/// Render all client-side (javascript) methods for this class.
ClassMethod %DrawClientMethods() As %Status [ CodeMode = objectgenerator, Final, Internal ]
{
	Set tSC = $$$OK
	Try {
		#; find all JavaScript methods
		#; these are client-side methods
		Set tCount = %compiledclass.Methods.Count()
		For n = 1:1:tCount {
			Set tMethod = %compiledclass.Methods.GetAt(n)
			If ((tMethod.ClientMethod) && (tMethod.Language = "javascript") && ('tMethod.Abstract)){
				Set tMethods(tMethod.Name) = tMethod
			}
		}

		#; write out client method implementations
		#; gather list of methods in tProtoList so we can later
		#; build the classLoader code
		Set tName = $O(tMethods(""))
		While (tName '= "") {
			Set tMethod = tMethods(tName)

			#; pick up all methods; there is no inheritance in this case

			#; build clean list of args (no types)
			Set tArgList = tMethod.FormalSpecParsed
			Set tArgs = ""
			For n = 1:1:$LL(tArgList) {
				Set tArgs = tArgs _ $S(tArgs="":"",1:",") _ $LG($LG(tArgList,n),1)
			}

			#; check for localized strings in js method code
			Set DOMAIN = $G(%parameter("DOMAIN"))
			Set tSC = ##class(%ZEN.Generator).%FindLocalizedText(tMethod,DOMAIN,.tTextList)
			If $$$ISERR(tSC) Quit

			#; cache list of localized strings
			Merge ^CacheTempCls($get(%ISCName,$job),%compiledclass.Name,"TextList") = tTextList

			#; use helper tag to write out client method
			Do %code.WriteLine(" Do JSClientMethod("""_tName_""","""_tArgs_""")")

			#; next method
			Set tName = $O(tMethods(tName))
		}

		Do %code.WriteLine(" Quit $$$OK")

		// helper method:
		// write out JS methods and attach to the zenPage object.
		Do %code.WriteLine("JSClientMethod(method,args)")
		Do %code.WriteLine(" Write !,""zenPage."",method,"" = function("",args,"") {"",!")
		Do %code.WriteLine(" For line=1:1:$$$comMemberKeyGet("""_%class.Name_""",$$$cCLASSmethod,method,$$$cMETHimplementation) {")
		Do %code.WriteLine("  If +$G(%zenStripJS) {")
		Do %code.WriteLine("   Set tLine = $ZSTRIP($$$comMemberArrayGet("""_%class.Name_""",$$$cCLASSmethod,method,$$$cMETHimplementation,line),""<>W"")")
		Do %code.WriteLine("   If (tLine[""&"") {")
		// escape common characters that XHTML does not support
		Do %code.WriteLine("    Set tLine = $Replace(tLine,""&nbsp;"",""&#160;"")")
		Do %code.WriteLine("    Set tLine = $Replace(tLine,""&raquo;"",""&#187;"")")
		Do %code.WriteLine("    Set tLine = $Replace(tLine,""&laquo;"",""&#171;"")")
		Do %code.WriteLine("   }")
		Do %code.WriteLine("   Write:(($L(tLine)>0)&&($E(tLine,1,2)'=""//"")) tLine,!")
		Do %code.WriteLine("  } Else {")
		Do %code.WriteLine("   Write $$$comMemberArrayGet("""_%class.Name_""",$$$cCLASSmethod,method,$$$cMETHimplementation,line),!")
		Do %code.WriteLine("  }")
		Do %code.WriteLine(" }")
		Do %code.WriteLine(" Write ""}"",!") // end of method
		Do %code.WriteLine(" Quit")
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

///  Render list of localized javascript strings for this object.
ClassMethod %DrawJSStrings(ByRef pVisited As %String) As %Status [ CodeMode = objectgenerator, Final, ForceGenerate, GenerateAfter = %DrawClientMethods, Internal ]
{
	Do %code.WriteLine(" Set tSC = $$$OK")
	If (%class.Name '= "%ZEN.Mojo.abstractApplication") {
		Do %code.WriteLine(" If '$D(pVisited("""_%compiledclass.Name_""")) {")
		Do %code.WriteLine("  Set tSC = ##super(.pVisited)")
		Do %code.WriteLine("  Set pVisited("""_%compiledclass.Name_""") = """"")
		Do %code.WriteLine(" }")
	}

	Set tKey = $O(^CacheTempCls($get(%ISCName,$job),%compiledclass.Name,"TextList",""))
	While (tKey'="") {
		// JMD1018: remove JS escape chars
		Set tKey2 = $Replace(tKey,"\\","\")
		Set tKey2 = $Replace(tKey2,"\""","""")
		Set tKey2 = $Replace(tKey2,"\'","'")
		Set tDomain = $P(tKey2,"/",1)
		Set tText = $P(tKey2,"/",2,99999)
		If ((tDomain'="")&&(tText'="")) {
			Do %code.WriteLine(" Write "_$$$quote("self._zenTEXT['"_$ZCVT(tKey2,"O","JS")_"']='")_ "_$ZCVT($$$Text("_$$$quote(tText)_","_$$$quote(tDomain)_"),""O"",""JS"")" _ "_""';"",!")
		}
		Set tKey = $O(^CacheTempCls($get(%ISCName,$job),%compiledclass.Name,"TextList",tKey))
	}
	Do %code.WriteLine(" Quit tSC")
	Quit $$$OK
}

}
