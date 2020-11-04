/// This is a system class that allows control of the Cache Activate environment.<br>
/// Used by Cache Activate Manager.
Class %Activate.TLEnumerator Extends %Library.RegisteredObject [ System = 3 ]
{

ClassMethod EnumerateClose(ByRef qHandle As %Binary) As %Status
{
 Quit $$$OK
}

ClassMethod EnumerateExecute(ByRef qHandle As %Binary) As %Status
{
 Set $ZT="Trap",%sc=$$$OK
 #dim objUtils,objLibs
 Do {
    If $$$isWINDOWS {
        Kill %objlasterror
        Set objUtils=##Class(%Activate.TLLib.Utils).%New()
        If '$IsObject(objUtils) Set %sc=$Get(%objlasterror,$$$ERROR($$$FailedToNewClass,"%Activate.TLLib.Utils")) Quit
        Set objLibs=objUtils.Libraries
        Set qHandle(1)=objUtils,qHandle(2)=objLibs,qHandle(3)=objLibs.Count,qHandle(4)=1
    } else {
        #; Not windows, force empty result set
        Set (qHandle(1),qHandle(2))=$$$NULLOREF,qHandle(3)=0,qHandle(4)=1
    }
 } while (0)
Exit
 Quit %sc
Trap
 If $ZE'["ACTX" {
     Set %sc=$$$ERROR($$$CacheError,$ZE)
 } else {
     Set %sc=$Get(%objlasterror,$$$ERROR($$$UnkAndUnexpectedError))
 }
 Goto Exit
}

ClassMethod EnumerateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 #dim objLibs,count,index,row
 Set $ZT="Trap",%sc=$$$OK
 Do {
    Set objLibs=qHandle(2),count=qHandle(3),index=qHandle(4)
    If index>count { Set AtEnd = 1, Row="" }
    Else {
        If count=index Set AtEnd=1
        Set row=objLibs.ItemGet(index),Row=$ListBuild($Piece(row,"|"),$Piece(row,"|",2),$Piece(row,"|",3))
        Set index=index+1,qHandle(4)=index
    }
 } while (0)
Exit
 Quit %sc
Trap
 If $ZE'["ACTX" {
     Set %sc=$$$ERROR($$$CacheError,$ZE)
 } else {
     Set %sc=$Get(%objlasterror,$$$ERROR($$$UnkAndUnexpectedError))
 }
 Goto Exit
}

/// Create Cache class based on ActiveX object's <var>physical location</var> (full path).
ClassMethod LoadTypeLibrary(Location As %String, Package As %String, qspec As %String) As %Status
{
 Quit $$LoadTypeLibrary^%occActivate(Location,Package,.qspec)
}

/// Returns ActiveX object's information: Name, Version, and Path.
Query Enumerate() As %Query(ROWSPEC = "Name:%Library.String,Version:%Library.String,Path:%Library.String") [ SqlProc ]
{
}

}
