Class %BI.WebDashboardLibCom [ Abstract, Not ProcedureBlock, System = 4 ]
{

/*
	Program: SwDashboardLibCode.cls
	Purpose: For Dashboard library - Routines to manage add/delete/list dashboard objects
	Author : Steven :P
	Created: 01.06.2005
	Updated: 12.07.2005
*/

/*
TopCood,LeftCood,Height,Width,ControlID,
ControlType,DisplayType,Tooltips,RefreshTrigger,
FilterObject,PostAction,MixStr,MixStr2,DetailField,
DefaultVal,Caption,KPI,Schema,KPIFilter,
Dimension,OutputVariable,AllowMultiSet,ImageID,Condition,
ImageID2,OnStartup,SecurityLevel,SecurityInquiry
*/
ClassMethod previewObjectCom(P0, frmGrp)
{
	d previewObjectCom^%bi.SWr.WebDashBoardLibCode(P0,frmGrp)
}

ClassMethod ObjectCreate(objID) As %String
{
	
	q $$ObjectCreate^%bi.SWr.WebDashBoardLibCode(objID)		//use $$ for set
}

ClassMethod ObjectDelete(strLst As %String) As %String
{
		
	q $$ObjectDelete^%bi.SWr.WebDashBoardLibCode(strLst) 	//Pass ID lists for multiple deletion
}

ClassMethod LoadAllDashboardObjects()
{
	//dashboardid & caption
	;w "<tr><td colspan=3>hello</td></tr>" //tester
	;;;;;q $$LoadAllDashboardObjects^%bi.SWr.WebDashBoardLibCode()	
	;;;;;ControlType=object Type (Lable,Listbox,Combo box...)
 	s i =0
 	s blnOK=0
	s strRec = ""
	Set rset = ##class(%ResultSet).%New()
  	Do rset.Prepare("SELECT ID, Caption, ControlType FROM %BI.swDashboardLibTable")
 	Do rset.Execute()
	//loop thru all saved records
	While (rset.Next()){
		s i = 'i
 		s strRec = strRec _ ..CreateTableRow(i,rset.Data("ID"),rset.Data("Caption"),rset.Data("ControlType"))
 		s blnOK = 1
    }
	if (blnOK) write strRec
}

ClassMethod CreateTableRow(flag, strID, strCaption, intObjectType) As %String
{
	//UsedBy:SWr.WebDashBoardLibCode.MAC
	//q $$CreateTableRow^%bi.SWr.WebDashBoardLibCode(strID, strCaption)
	if (strCaption = ""){ s strCaption = "&nbsp;" }
	
	s strRow = "<tr "
	if (flag>0) s strRow = strRow _ "bgcolor=#FFCC66"
	s strRow = strRow _ "><td><input type='checkbox' name=chkNames value="_strID_"></td>"
	s strRow = strRow _ "<td>"_strID_"</td>"
	s strRow = strRow _ "<td>"_ strCaption _"</td>"
	s strRow = strRow _ "<td>"_ ..GetObjectType(intObjectType) _"</td>"
	//s strRow = strRow _ "<td>"_ strSchemaName _"</td></tr>"
	;w "alert('" _ strRow _ "')"
	q strRow
}

ClassMethod GetObjectType(intObjType) As %String
{
	if (intObjType=1) {	s strType="Pivot Table" }
	elseif(intObjType=2){ s strType="" }
	elseif(intObjType=3){ s strType="Slider" }
	elseif(intObjType=4){ s strType="Speedometer" }
	elseif(intObjType=5){ s strType="Label" }
	elseif(intObjType=6){ s strType="Image" }
	elseif(intObjType=7){ s strType="Picture Box" }
	elseif(intObjType=8){ s strType="Combo Box" }
	elseif(intObjType=9){ s strType="List Box" }
	elseif(intObjType=10){ s strType="Button" }
	elseif(intObjType=11){ s strType="Text Field" }
	elseif(intObjType=12){ s strType="Date Picker" }
	elseif(intObjType=13){ s strType="Dashboard List" }
	elseif(intObjType=14){ s strType="" }
	elseif(intObjType=15){ s strType="Frame" }
	elseif(intObjType=16){ s strType="Detail Listing" }
	elseif(intObjType=17){ s strType="Picture Button" }
	elseif(intObjType=18){ s strType="Balance Score Card" }
	elseif(intObjType=19){ s strType="Blog" }
	q strType
}

ClassMethod deleteCom(P0)
{
	d deleteCom^%bi.SWr.WebDashBoardLibCode(P0)
}

// endclass

}
