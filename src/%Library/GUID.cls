IncludeGenerator %occInclude

/// This class implements utility methods for GUIDs.
Class %Library.GUID [ Abstract, System = 3 ]
{

Parameter GUIDENABLED = 1;

/// This method should be implemented by the user. This method is invoked by %SYNC.SyncSet.AddJournaledObject when the Filter is not null.
/// Non zero return value  means that the object should be excluded
/// 
ClassMethod Filter(guid As %String, FilterObject As %RegisteredObject = "", trn As %Integer) As %Integer
{

	Quit 0
}

ClassMethod %GUIDFind(guid As %String) As %CacheString [ CodeMode = expression ]
{
$Get(^OBJ.GUID(0,guid))
}

ClassMethod %GUIDGetNextOp(guid As %String, ByRef num As %String) As %CacheString
{
	Set num=$order(^OBJ.GUID(0,guid,num))
	Quit $select(num="":"",1:^OBJ.GUID(0,guid,num))
}

ClassMethod %GUIDGetLastOp(guid As %String, ByRef num As %String) As %CacheString
{
	Set num=$order(^OBJ.GUID(0,guid,""),-1)
	Quit $select(num="":"",1:^OBJ.GUID(0,guid,num))
}

/// This method will assign a GUID to all objects that don't already have one.
ClassMethod AssignGUID(class As %String, nOutput As %Integer = 0) As %Status
{
	Set $ZTrap = "CatchError"
	Set sc = $classmethod(class,"ExtentExecute",.qh)
	If $$$ISERR(sc) Ztrap "QX"
	Set sc = $classmethod(class,"ExtentFetchRows",.qh,,.RowSet, .ReturnCount, .AtEnd)
	If $$$ISERR(sc) Ztrap "QX"
	Do $classmethod(class,"ExtentGetInfo",.cols,.parms,.idinfo) Set cardinality = $ll(cols),idpos = $li(idinfo)
	While ReturnCount {
		For rowptr = 0:1:ReturnCount - 1 {
			Set id = $List(RowSet,rowptr*cardinality+idpos)
			Set obj = $classmethod(class,"%OpenId",id)
			if nOutput Write !,"Checking object ",id
			If $IsObject(obj) {
				set oid = obj.%Oid()
				If obj.%GUID(oid) = "" {
					Set guid = $System.Util.CreateGUID()
					Set ^OBJ.GUID(0,guid)=oid,^OBJ.GUID(1,oid)=guid
					if nOutput Write !,"....assigned GUID ",guid
				}
			}
		}
		If AtEnd { Set ReturnCount = 0 }
		Else { Set sc = $classmethod(class,"ExtentFetchRows",.qh,,.RowSet, .ReturnCount, .AtEnd) If $$$ISERR(sc) Ztrap "QX" }
	}
	Do $classmethod(class,"ExtentClose",qh)
	Quit $$$OK
CatchError Set $ZTrap = ""
	Set error = $ZError If $Extract(error,1,5) = "<ZQX>" Do $classmethod(class,"ExtentClose",qh) Quit sc
	Quit $$$ERROR($$$CacheError,error)
}

/// %FindGUID() attempts to locate the GUID of object for which we do not know the most specific type class.
/// This can happen when resolving the ID for an object that has been deleted, as sometimes occurs when dealing with
/// objects retrieved from the system journal for the purpose of synchronizing with another system.
/// 
/// This method assumes that the normal GUID resolution has failed and that if another object of a different MSTC exists within
/// the same root extent then it is the same object (same GUID). For example, class A is persistent and it has two sub classes - B and C.
/// An instance of B is created and assigned a GUID. At some future time, that instance of B is deleted and recreated as an instance of C using
/// the same ID value. The premise of %FindGUID is that the object having an OID of (id,"B") is the same object as that with an OID of (id,"C").
ClassMethod %FindGUID(pClassName As %String(MAXLEN=""), pID As %Binary) As %String
{
	set tGUID = $Get(^OBJ.GUID(1,$$$oidCompose(pID,pClassName)))
	if (tGUID = "") && ($Data($$$EXTsubextent($$$pEXT,pClassName))) {
		set tSubextent = $order($$$EXTSUBEXTENT($$$pEXT,pClassName,""))
		while tSubextent '= "" {
			set tGUID = ..%FindGUID(tSubextent,pID)
			if tGUID '= "" { quit }
			set tSubextent = $order($$$EXTSUBEXTENT($$$pEXT,pClassName,tSubextent))
		}
	}
	quit tGUID
}

}
