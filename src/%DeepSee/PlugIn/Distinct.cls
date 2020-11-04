/// %DeepSee.PlugIn.Distinct
/// 
/// This plugin can be used to get the count of distinct values for a given level
/// in a given cell.
/// 
/// For example: %KPI("%DeepSee.Distinct","DISTINCT",,"%level","[DocD].[H1].[Doctor]","%CONTEXT")
/// 
/// The above returns the number of unique doctors contained in the set of fact for a cell.
/// Use the "%level" parameter to tell the plugin which level you are interested in -- use
/// [<dimension>].[<hierarchy>].[<level>]
/// 
Class %DeepSee.PlugIn.Distinct Extends %DeepSee.KPIPlugIn [ System = 4 ]
{

/// Cube(s) that this plug-in is based on.
Parameter BASECUBE = "*";

Parameter CACHEABLE = 0;

Parameter LISTINGSOURCE = "FactTable";

Parameter PLUGINTYPE = "Aggregate";

Parameter ASYNC = 0;

/// This XData definition defines the KPI.
XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi"
 name="%DeepSee.Distinct" sourceType="mdx"
 caption=""
>
<filter name="%cube" displayName="Subject Area"/>
<filter name="%level" displayName="Level"/>
<property name="DISTINCT" displayName="Distinct Count" description="Compute the number of distinct values for a given level" />
</kpi>
}

/// Get the base query for this plug-in.
Method %OnGetMDX(ByRef pMDX As %String) As %Status
{
	Set tBaseCube = ""

	// Use %cube filter to find the base cube
	If $IsObject(..%filterValues) {
		If (..%filterValues.%cube'="") {
			Set tBaseCube = ..%filterValues.%cube
		}
	}

	If (tBaseCube'="") {
		Set pMDX = "SELECT FROM "_tBaseCube
	}
	Quit $$$OK
}

/// Returns the field list (RETURN clause) of the listing used to supply data for this plug-in.
/// In this case, determine which measure we need.
Method %OnGetListingFields() As %String
{
	Set tBaseCube = ..#BASECUBE
	If $IsObject(..%filterValues) {
		If (..%filterValues.%cube'="") {
			Set tBaseCube = ..%filterValues.%cube
		}
	}

	Set tListingFields = "'ERROR:No Level' Level"
	If $IsObject(..%filterValues) {
		If (..%filterValues.%level'="") {
			Set tLevel = ..%filterValues.%level

			Set:$E(tBaseCube)="[" tBaseCube = $E(tBaseCube,2,*-1)
			Set tListingFields = "'ERROR:No Level ("_tLevel_")' Level"

			// find fact name for measure
			Set tSC = ##class(%DeepSee.Utils).%GetDimensionInfo(tBaseCube,tLevel,.tDNO,.tHNO,.tLNO)
			
			If $$$ISOK(tSC) {
				
				//Get FactName
				Set tInfo = $G($$$DeepSeeMetaGLVN("cubes",tBaseCube,"mbr#",tDNO,tHNO,tLNO))
				Set tFactName = $lg(tInfo,12)
				Set:tFactName'="" tAlias = $G($$$DeepSeeMetaGLVN("cubes",tBaseCube,"fact","prop",tFactName,"alias"))
				Set:$G(tAlias)'="" tFactName=tAlias
				Set:$G(tFactName)'="" tListingFields = tFactName _ " As CountLevel "
			}
		}
	}
	Quit tListingFields
}

/// This is where we actually do work in the PlugIn.
/// We are given an SQL result set of all the facts included in this
/// cell. We can loop over the facts and exclude doubles from the count
Method %OnCompute(pSQLRS As %SQL.StatementResult, pFactCount As %Integer) As %Status
{
 	Set ..%seriesCount = 1
 	Set ..%seriesNames(1) = "Total"
 
	// iterate through result set 
	Set tDistinctValues = 0
	Set n = 0
	
	While (pSQLRS.%Next(.tSC)) {
		If $$$ISERR(tSC) {
			Set tErrMsg = $System.Status.GetErrorText(tSC)
			Quit
		}
		Set n = n + 1

		//Grab the value for this fact
		Set tFactValue = pSQLRS.CountLevel	
		//Test if value is distinct
		If ($G(^||tValues(tFactValue))) { /* do nothing */ }
		Else {
	  		//Count distinct value
	  		Set ^||tValues(tFactValue) = 1
	  		Set tDistinctValues = tDistinctValues+1
		}
		// update pct complete
		If (n#100 = 0) {
			Do ..%SetPercentComplete(100*(n/pFactCount))
		}
	}
	Set ..%data(1,"DISTINCT") = tDistinctValues
	Kill ^||tValues
	
	quit $$$OK
}

}
