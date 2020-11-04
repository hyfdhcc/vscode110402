Include %occInclude

IncludeGenerator %occInclude

/// The <b>%DynamicObjectQuery</b> class is used for defining class queries based on runtime Object/Bitmap statements.
Class %Library.DynamicObjectQuery Extends %DynamicSQLQuery [ Not ProcedureBlock, System = 2 ]
{

/*
		Execute is passed parameters for Query
		Returns handle for subsequent operations
	*/
ClassMethod Execute(ByRef qHandle As %Binary) As %Status [ CodeMode = generator, ServerOnly = 1 ]
{
 s %code=0
 #; don't generate any code if it not for a query
 i %mode="method" QUIT $$$OK

 n %sc,formal,i,line,qformal,qline,query

 #; Reset the formal list to the query declaration:
#if 0 ; DLP827+
 s formal=$$$QUERYMETHformalspec($$$gMGINFO,%class,%property,%method)
 s qformal=$$$QUERYformalspec($$$gMGINFO,%class,%property)
 i $e(qformal)="(",$e(qformal,$l(qformal))=")"
 i  s qformal=$e(qformal,2,$l(qformal)-1)

 s $$$QUERYMETHformalspec($$$sMGINFO,%class,%property,%method)=formal_$s(qformal'=""&(formal'=""):",",1:"")_qformal
#else ; DLP827=
 $$$comSubMemberKeyGetLvar(formal,%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed)
 $$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
 $$$comSubMemberKeySet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed,formal_qformal)
#endif ; DLP827-
 s %sc=$$SetOneQueryMeth^%occQuery(%class,%property,%method) q:$$$ISERR(%sc) %sc

 $$$GENERATE(" n %qref,id,rtn Set %qref=$lg(qHandle,1),rtn=$lg(qHandle,2)"),id=""
 $$$GENERATE(" Quit:%qref=""""!(rtn="""") $$$ERROR($$$QueryNotPrepared)")
 $$$GENERATE(" Quit $$Execute^@rtn")
 QUIT $$$OK
}

/*
		FetchRows returns the next FetchCount rows in the query
		Updates handle for subsequent operations
		Returns $list for row or  "" if no more rows
	*/
ClassMethod FetchRows(ByRef qHandle As %Binary, FetchCount As %Integer = 0, ByRef RowSet As %List, ByRef ReturnCount As %Integer, ByRef AtEnd As %Integer) As %Status [ ServerOnly = 1 ]
{
 n %qref,id,rtn Set %qref=$lg(qHandle,1),rtn=$lg(qHandle,2),id=$lg(qHandle,3)
 Quit:%qref=""!(rtn="") $$$ERROR($$$QueryNotPrepared)
 QUIT $$FetchRows^@rtn
}

ClassMethod Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ ServerOnly = 1 ]
{
 n %qref,id,rtn Set %qref=$lg(qHandle,1),rtn=$lg(qHandle,2),id=$lg(qHandle,3)
 Quit:%qref=""!(rtn="") $$$ERROR($$$QueryNotPrepared)
 QUIT $$Fetch^@rtn
}

ClassMethod Prepare(ByRef qHandle As %Binary, query As %String, containid As %Integer = 0, selectmode As %String = "LOGICAL") As %Status [ CodeMode = generator, ServerOnly = 1 ]
{
 s %code=0
 i %mode="method" QUIT $$$OK
 n formallist,qformal,parmarray,ptr,var
#if 0 ; DLP827+
 s qformal=$$$QUERYformalspec($$$gMGINFO,%class,%property)
 i $e(qformal)="(",$e(qformal,$l(qformal))=")"
 i  s qformal=$e(qformal,2,$l(qformal)-1)
#else ; DLP827=
 $$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
#endif ; DLP827-
 s formallist=""
 i qformal'="" s formallist=$$formallist^%occName(qformal,"") s formallist=$e(formallist,2,$l(formallist)-1)
 $$$GENERATE(" Quit 0  // DPV2528= %ourQueryBM has not existed for some time!  $$Prepare^%ourQueryBM(.qHandle,query,containid,selectmode,"""_formallist_""")")
 Quit $$$OK
}

}
