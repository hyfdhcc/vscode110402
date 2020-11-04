Class %BI.swMapSetupCode Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/*
	Author : Steven :P
	Purpose: For MapSetup - Routines to manage add/delete/list map details
	Created: 23.06.2005
	Updated: 15.09.2005 Steven
*/
Property KPI As %Integer;

Property KPIDef As %Boolean;

//Groups

ClassMethod GroupMapCreate(sName, sDesc, sRow, sCol, sHeight, sWidth, bStartMap, sFolderID) As %String
{
	q $$GroupMapCreate^%bi.SWr.WebswMapSetupCode(sName,sDesc,sRow,sCol,sHeight,sWidth,bStartMap, sFolderID)
}

ClassMethod GroupMapUpdate(oMap, sName, sDesc, sRow, sCol, sHeight, sWidth, bStartMap, sFolderID)
{
	q $$GroupMapUpdate^%bi.SWr.WebswMapSetupCode(oMap,sName,sDesc,sRow,sCol,sHeight,sWidth,bStartMap, sFolderID)
}

ClassMethod GroupMapDelete(oMap) As %String
{
	q $$GroupMapDelete^%bi.SWr.WebswMapSetupCode(oMap)
}

ClassMethod GroupMapRetrieveDetails(iMapID, bIsLink) As %String
{
	q $$GroupMapRetrieveDetails^%bi.SWr.WebswMapSetupCode(iMapID,bIsLink)
}

ClassMethod GroupMapUpdateSubMaps(iGID, varMapRowColID, iRow, iCol)
{
	q $$GroupMapUpdateSubMaps^%bi.SWr.WebswMapSetupCode(iGID,.varMapRowColID,iRow,iCol)
}

ClassMethod GroupMapShowGridMap(iGID, bIsLink)
{
 	q $$GroupMapShowGridMap^%bi.SWr.WebswMapSetupCode(iGID, bIsLink)
}

ClassMethod GroupMapPointLoadAllHotSpots(iParentMapID, sGridID, bIsLink)
{
	d GroupMapPointLoadAllHotSpots^%bi.SWr.WebswMapSetupCode(iParentMapID, sGridID, bIsLink)
}

ClassMethod GroupMapBuildGrids(iRow, iCol, iHgt, iWdt, bIsLink)
{
	d GroupMapBuildGrids^%bi.SWr.WebswMapSetupCode(iRow,iCol,iHgt,iWdt,bIsLink)
}

//Maps

ClassMethod MapCreate(sName, sDesc, sMapRef, sFolderID, sMapLink, bStartMap, iHgt, iWdt) As %String
{
	q $$MapCreate^%bi.SWr.WebswMapSetupCode(sName,sDesc,sMapRef,sFolderID,sMapLink,bStartMap,iHgt,iWdt)
}

ClassMethod MapUpdate(oMap, sName, sDesc, sMapRef, sFolderID, sMapLink, bStartMap, iHgt, iWdt)
{
	q $$MapUpdate^%bi.SWr.WebswMapSetupCode(oMap,sName,sDesc,sMapRef,sFolderID,sMapLink,bStartMap,iHgt,iWdt)
}

ClassMethod MapDelete(oMap) As %String
{
	q $$MapDelete^%bi.SWr.WebswMapSetupCode(oMap)
}

ClassMethod MapRetrieveDetails(iMapID, bIsLink) As %String
{
	q $$MapRetrieveDetails^%bi.SWr.WebswMapSetupCode(iMapID,bIsLink)
}

ClassMethod MapLoadAllMaps(stat, sType)
{
	d MapLoadAllMaps^%bi.SWr.WebswMapSetupCode(stat,sType)
}

//Load the map image When user click on the Maps

ClassMethod ShowMapImage(imgId) As %String
{
	q $$ShowMapImage^%bi.SWr.WebswMapSetupCode(imgId)
}

ClassMethod MapGetImagePath(iMapID) As %String
{
	q $$MapGetImagePath^%bi.SWr.WebswMapSetupCode(iMapID)
}

//Add Single Poi To DB.Return "true"/"false"

ClassMethod MapPointCreate(sParentMapID As %String, sX As %String, sY As %String, sName As %String, sKPI As %String, sCond As %String, sMapRef As %String, sTooltip As %String, sQueryName As %String, sQueryVal As %String, iImageID As %Integer) As %String
{
	q $$MapPointCreate^%bi.SWr.WebswMapSetupCode(sParentMapID,sX,sY,sName,sKPI,sCond,sMapRef,sTooltip, sQueryName,sQueryVal,iImageID)
}

ClassMethod MapPointUpdate(iID As %String, sX As %String, sY As %String, sName As %String, sKPI As %String, sCond As %String, sMapRef As %String, sTooltip As %String, sQueryName As %String, sQueryVal As %String, iImageID As %Integer) As %String
{
	q $$MapPointUpdate^%bi.SWr.WebswMapSetupCode(iID,sX,sY,sName,sKPI,sCond,sMapRef,sTooltip,sQueryName,sQueryVal,iImageID)
}

ClassMethod MapPointRetrieve(iID) As %String
{
	q $$MapPointRetrieve^%bi.SWr.WebswMapSetupCode(iID)
}

ClassMethod MapPointRetrieveAll(iParentMapID)
{
	do MapPointRetrieveAll^%bi.SWr.WebswMapSetupCode(iParentMapID)
}

ClassMethod MapPointDelete(iID) As %String
{
	q $$MapPointDelete^%bi.SWr.WebswMapSetupCode(iID)
}

ClassMethod MapPointDeleteAll(iPID) As %String
{
	q $$MapPointDeleteAll^%bi.SWr.WebswMapSetupCode(iPID)
}

ClassMethod MapPointLoadAllHotSpots(iParentMapID, bIsLink)
{
	d MapPointLoadAllHotSpots^%bi.SWr.WebswMapSetupCode(iParentMapID, bIsLink)
}

ClassMethod MapPointGetMapName(iMapID)
{
	q $$MapPointGetMapName^%bi.SWr.WebswMapSetupCode(iMapID)
}

ClassMethod LoadDefaultKPI() As %String
{
	q $$LoadDefaultKPI^%bi.SWr.WebswMapSetupCode()
}

ClassMethod MapPointHeader(bClose) As %String
{
	d MapPointHeader^%bi.SWr.WebswMapSetupCode(bClose)
}

ClassMethod LoadGISViewPort(sDivID, sBdrCol)
{
	d LoadGISViewPort^%bi.SWr.WebswMapSetupCode(sDivID,sBdrCol)
}

ClassMethod KPIShowDetListing(iMapID)
{
	d KPIShowDetListing^%bi.SWr.WebswMapSetupCode(iMapID)
}

ClassMethod RefreshDashBoardObject(iMapID)
{
	d RefreshDashBoardObject^%bi.SWr.WebswMapSetupCode(iMapID)
}

ClassMethod InitWebMap()
{
	d InitWebMap^%bi.SWr.WebswMapSetupCode
}

ClassMethod InitVariables(sFilter, sQueryVar, frmID, dbKey)
{
	d InitVariables^%bi.SWr.WebswMapSetupCode(sFilter,sQueryVar,frmID,dbKey)
}

ClassMethod InitGIS(P0, P1, P2, P3, P4, P5)
{
	d InitVariables^%bi.SWr.WebswMapSetupCode(P0,P1,P2,P3)
	d LoadGISViewPort^%bi.SWr.WebswMapSetupCode(P4,P5)
}

Storage Default
{
<Data name="MapPointsCollection">
<Attribute>MapPointsCollection</Attribute>
<Structure>subnode</Structure>
<Subscript>"MapPointsCollection"</Subscript>
</Data>
<Data name="swMapSetupCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>mintI</Value>
</Value>
<Value name="3">
<Value>KPI</Value>
</Value>
<Value name="4">
<Value>KPIDef</Value>
</Value>
</Data>
<DataLocation>^BI.swMapSetupCodeD</DataLocation>
<DefaultData>swMapSetupCodeDefaultData</DefaultData>
<IdLocation>^BI.swMapSetupCodeD</IdLocation>
<IndexLocation>^BI.swMapSetupCodeI</IndexLocation>
<StreamLocation>^BI.swMapSetupCodeS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
