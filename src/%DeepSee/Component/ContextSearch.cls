/// Additional context searches used by DeepSee pages.
Class %DeepSee.Component.ContextSearch Extends %ZEN.Portal.ContextSearch [ Abstract, System = 4 ]
{

/// Set this to the correct domain.
Parameter DOMAIN = "%DeepSee";

/// Search method: Folders.<br/>
/// Execute a user portal folder search.<br/>
ClassMethod Folders(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Folders")

		// get recent folders
		Set tSC = ##class(%DeepSee.UserLibrary.Utils).%GetRecentItemList("folder",.tRecent)
		If $$$ISERR(tSC) Quit

		Set n = 0
		Set k = $O(tRecent(""),1,tName)
		While (k'="") {
			Set n = n + 1
			Set pTopResults(n) = tName
			Set k = $O(tRecent(k),1,tName)
		}

		// get list of folders
		Set tSC = ##class(%DeepSee.UserLibrary.Utils).%GetFolderList(.pResults)
		If $$$ISERR(tSC) Quit
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

/// Search method: DataProperties.<br/>
/// List available properties for a DeepSee data source.<br/>
/// pParms("dataSource") holds the data source name.
ClassMethod DataProperties(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Data properties")

		Set tDataSource = $G(pParms("dataSource"))
		If (tDataSource = "") Quit

		// get list of properties
		Set tSC = ##class(%DeepSee.Dashboard.Utils).%GetPropertiesForDataSource(tDataSource,.pResults)
		If $$$ISERR(tSC) Quit
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

/// Search method: Dimensions.<br/>
/// Provide a list of dimensions within the cube/subjectArea specified by
/// pParms("subject").<br/>
/// If pParms("list") is provided, then this is a csv-list of additional items to show. 
ClassMethod Dimensions(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Dimensions")
		Set tCube = $G(pParms("subject"))
		Set tLocalList = $G(pParms("list"))
		Set tExcludeMeasures = ($G(pParms("excludeMeasures")) = 1)

		If (tCube '= "") {
			Set tSC = ##class(%DeepSee.Utils).%GetDimensionList(tCube,.tList,1)
			Set tStart = $S('tExcludeMeasures:"",1:0)
			Set tDim = $O(tList(tStart))
			While (tDim'="") {
				If (tDim<0) {
					// calc mbr
					Set tInfo = $G(tList(tDim,1,0))
					Set tDimName = $LG(tInfo,2)
					If (tDimName'="") {
						Set pResults($I(n)) = tDimName
					}
				}
				Else {
					Set tInfo = $G(tList(tDim,0,0))
					Set tDimName = $LG(tInfo,2)
					If (tDimName'="") {
						Set pResults($I(n)) = tDimName
					}
				}
				Set tDim = $O(tList(tDim))
			}
		}

		For p=1:1:$L(tLocalList,",") {
			Set tDimName = $P(tLocalList,",",p)
			If (tDimName'="") {
				Set pTopResults($I(n2)) = tDimName
			}
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

/// Search method: Members.<br/>
/// Provide a list of members for the given filter/dimension within the cube/kpi specified by
/// pParms("dataSource").<br/>
/// pParms("filter") is the name of the filter.
ClassMethod Members(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Members")
		Set tDataSource = $G(pParms("dataSource"))
		Set tFilterName = $G(pParms("filter"))

		If (tDataSource '= "") {
			// Get members of the given filter
			// tFilters(n) = $LB(text,value)
			Kill tFilters
			Set tSC = ##class(%DeepSee.Dashboard.Utils).%GetMembersForFilter(tDataSource,tFilterName,.tFilters,.tDefaultFilterValue,"")
			If $$$ISERR(tSC) Quit

			Set k = $O(tFilters(""))
			While (k'="") {
				Set pResults($I(n)) = $LG(tFilters(k),2)
				Set k = $O(tFilters(k))
			}
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

/// Search method: Settings.<br/>
/// Provide a list of user-defined settings.<br/>
/// pParms("context") is the context of the settings to display.
ClassMethod UserSettings(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Settings")
		Set tContext = $G(pParms("context"))

		Set tSC = ##class(%DeepSee.UserPortal.Utils).%GetUserSettingsList(.tList,tContext)
		If $$$ISERR(tSC) Quit

		Set k = $O(tList(""))
		While (k'="") {
			Set pResults($I(n)) = $LG(tList(k),1)
			Set k = $O(tList(k))
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

/// Search method: QualityMeasureCatalogs.<br/>
/// Provide a list of Quality Measure Catalogs.<br/>
ClassMethod QualityMeasureCatalogs(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Catalogs")
		Set tSC = ##class(%DeepSee.QualityMeasure.Utils).%GetCatalogList(.tList)
		If $$$ISERR(tSC) Quit

		Set k = $O(tList(""))
		While (k'="") {
			Set pResults($I(n)) = $LG(tList(k),1)
			Set k = $O(tList(k))
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

/// Search method: QualityMeasureSets.<br/>
/// Provide a list of Quality Measure Sets within a given catalog.<br/>
/// pParms("catalog") is the catalog.
ClassMethod QualityMeasureSets(Output pCaption As %String, Output pTopResults, Output pResults, ByRef pParms As %String, pSearchKey As %String) As %Status
{
	Set tSC = $$$OK

	Try {
		Set pCaption = $$$Text("Sets")
		Set tCatalog = $G(pParms("catalog"))

		Set tSC = ##class(%DeepSee.QualityMeasure.Utils).%GetSetList(.tList,tCatalog)
		If $$$ISERR(tSC) Quit

		Set k = $O(tList(""))
		While (k'="") {
			Set pResults($I(n)) = $LG(tList(k),1)
			Set k = $O(tList(k))
		}
	}
	Catch {
		Set tSC = $$$ERROR($$$CacheError,$ZE)
	}
	Quit tSC
}

}
