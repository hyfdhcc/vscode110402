Class %BI.GridColorScheme [ Abstract, Not ProcedureBlock, System = 4 ]
{

/*
Property FontColor As %String(MAXLEN = 15);

Property BackColor As %String(MAXLEN = 15);

Property FontFamily As %String(MAXLEN = 30);

Property FontWeight As %Boolean;

Property FontStyle As %Boolean;

Property FontSize As %Integer;

Property TxtDeco1 As %Boolean;//underline

Property TxtDeco2 As %Boolean;//line-through

Property TxtAlignment As %String(MAXLEN = 15);

Property BorderSize As %String(MAXLEN = 15);

Query GridScheme() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,FontColor,BackColor,FontFamily,FontWeight,FontStyle,FontSize,TxtDeco1,TxtDeco2,TxtAlignment 
FROM GridColorScheme
}
*/
ClassMethod SavePrefSampleJS(id, name, settings)
{
	d savePrefSampleJS^%bi.SWr.GridColorScheme(id,name,settings)
}

ClassMethod RemovePrefSampleJS(id)
{
	d removePrefSampleJS^%bi.SWr.GridColorScheme(id)
}

ClassMethod GridColorSchemeJS(tid, pivID, settings, count, saveType)
{
	d saveSettingsJS^%bi.SWr.GridColorScheme(tid,pivID,settings,count,saveType)
}

ClassMethod GetPrefSchemeJS(val, pid, tid)
{
	;q $$getPrefSchemeJS^%bi.SWrCE.GridColorScheme("")
	d getPrefSchemeJS^%bi.SWr.GridColorScheme(val,pid,tid)
}

ClassMethod killSettingsJS(tableID)
{
	s sessID = %session.%Id()
	k ^BI.GridColorScheme(sessID)
}

ClassMethod remLastJS()
{
	;remove current user highlight
	w "LsName='"_%session.Get("LastScheme")_"';"
	w "LsId='"_%session.Get("LastSchemeID")_"';"
}

ClassMethod keepLastJS(sName, sID)
{
	;set current user highlight
	s %session.Data("LastScheme") = sName
	s %session.Data("LastSchemeID") = sID
}

}
