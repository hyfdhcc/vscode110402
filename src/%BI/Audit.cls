Class %BI.Audit Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

// (%Persistent, Speed.Miner)

Property TrTypeID As %Integer;

//either Pivot or KPI ID

Property TrDate As %String(TRUNCATE = 1);

Property TrType As %String(TRUNCATE = 1);

Property TrClass As %String(TRUNCATE = 1);

Property TrUsrID As %Integer;

Property TrQuery As %String(TRUNCATE = 1);

Property TrSessID As %String(TRUNCATE = 1);

Property TrObjID As %String(TRUNCATE = 1);

Property TrQueryVar As %String(TRUNCATE = 1);

Property TrParCond As %String(TRUNCATE = 1);

Property TrParLink As %String(TRUNCATE = 1);

Property TrDateStart As %Date;

Property TrDateStop As %Date;

Property TrTimeStart As %Time;

Property TrTimeStop As %Time;

Index Cls On TrClass As Exact;

Index AuDate On (TrDate As Exact, TrType As Exact);

Index Usr On TrUsrID As Exact;

/* method 2
ClassMethod TypeOnLoad()
{
	d LoadType^SWrCE.Audit
}

ClassMethod ClassOnLoad()
{
	d LoadClass^SWrCE.Audit
}

ClassMethod UserOnLoad()
{
	d LoadUser^SWrCE.Audit
}
	*/

/*	method 1 - not used anymore
ClassMethod ClassOnLoadJS(auType)
{
	d LoadClassJS^SWrCE.Audit(auType)
}

ClassMethod UIDOnLoadJS(auType, auClass)
{
	d LoadUIDJS^SWrCE.Audit(auType,auClass)
}

ClassMethod DateOnLoadJS(auType, auClass, usrID)
{
	d LoadDateJS^SWrCE.Audit(auType,auClass,usrID)
}
	*/

/* old method
ClassMethod FindJS(auType, auClass, usrID, auDate)
{
	;	to list results found
	k %session.Data("currTrailID")
	s %session.Data("totRow") = 0
	d LoadResultJS^SWrCE.AuditResult(auType,auClass,usrID,auDate)
}

ClassMethod urlJS(loc)
{
	s loc = $G(loc)
	s typeLen = $L(loc)
	s loc = $E(loc,2,typeLen-1)
	d ##class(%Net.URLParser).Parse(loc,.components)
	s query = components("query")
	s auID = $P(query,"&",1)	; to extract the ID
	s type = $P(query,"&",2)	; to extract the type
	s auID = $P(auID,"=",2)
	s type = $P(type,"=",2)

	d treeJS^SWrCE.AuditResult(auID,type)
}

ClassMethod LoadAllDate()
{
	d LoadAllDate^SWrCE.Audit
}
	
ClassMethod PurgeDataJS(purgeDate)
{
	d PurgeDataJS^SWrCE.Audit(purgeDate)
}
	*/
ClassMethod setSess(auID)
{
	d setSess^%bi.SWrCE.AuditResult(auID)
}

Storage Default
{
<Data name="AuditDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TrClass</Value>
</Value>
<Value name="3">
<Value>TrDate</Value>
</Value>
<Value name="4">
<Value>TrObjID</Value>
</Value>
<Value name="5">
<Value>TrParCond</Value>
</Value>
<Value name="6">
<Value>TrParLink</Value>
</Value>
<Value name="7">
<Value>TrQuery</Value>
</Value>
<Value name="8">
<Value>TrQueryVar</Value>
</Value>
<Value name="9">
<Value>TrSessID</Value>
</Value>
<Value name="10">
<Value>TrType</Value>
</Value>
<Value name="11">
<Value>TrTypeID</Value>
</Value>
<Value name="12">
<Value>TrUsrID</Value>
</Value>
<Value name="13">
<Value>TrTimeStart</Value>
</Value>
<Value name="14">
<Value>TrTimeStop</Value>
</Value>
<Value name="15">
<Value>TrDateStart</Value>
</Value>
<Value name="16">
<Value>TrDateStop</Value>
</Value>
</Data>
<DataLocation>^BIlog.AuditD</DataLocation>
<DefaultData>AuditDefaultData</DefaultData>
<IdLocation>^BIlog.AuditD</IdLocation>
<IndexLocation>^BIlog.AuditI</IndexLocation>
<StreamLocation>^BIlog.AuditS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
