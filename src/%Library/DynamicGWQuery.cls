IncludeGenerator %occInclude

Class %Library.DynamicGWQuery Extends %Query [ Not ProcedureBlock, System = 2 ]
{

/*
		Close the query associated with the handle
	*/
ClassMethod Close(qHandle As %Binary) As %Status
{
 n connection,hstmt Set connection=$g(qHandle(1)),hstmt=$g(qHandle(2))
 Quit:connection=""!(hstmt="") $$$ERROR($$$QueryNotPrepared)
 Quit connection.DropStatement(hstmt)
}

/*
		Execute is passed parameters for Query
		Returns handle for subsequent operations
	*/
ClassMethod Execute(ByRef qHandle As %Binary) As %Status [ CodeMode = generator ]
{
	s %code=0
		#; don't generate any code if it not for a query
	i %mode="method" QUIT $$$OK
	n %sc,formal,i,line,qformal,qline,query
		#; Reset the formal list to the query declaration:
	$$$comSubMemberKeyGetLvar(formal,%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed)
	$$$comMemberKeyGetLvar(qformal,%class,$$$cCLASSquery,%property,$$$cQUERYformalspecparsed)
	$$$comSubMemberKeySet(%class,$$$cCLASSquery,%property,$$$cQUERYmethod,%method,$$$cMETHformalspecparsed,formal_qformal)
	s %sc=$$SetOneQueryMeth^%occQuery(%class,%property,%method) q:$$$ISERR(%sc) %sc
	$$$GENERATE(" n connection,fp,hstmt,qformal,parmmt,pptr Set connection=$g(qHandle(1)),hstmt=$g(qHandle(2)),parmmt=$g(qHandle(4))")
	$$$GENERATE(" Quit:connection=""""!(hstmt="""") $$$ERROR($$$QueryNotPrepared)")
	$$$GENERATE(" i $l(parmmt)>0 Do  QUIT:$$$ISERR(sc) sc")
	$$$GENERATE(" . s sc=$$$OK,qformal="""_qformal_"""")
	$$$GENERATE(" . f pptr=1:1:$l(parmmt) s fp=""s fp=""_$s($e(parmmt,pptr):""+"",1:"""")_""$g(""_$lg($lg(qformal,pptr),1)_"")"" x fp s sc=connection.SetParameter(hstmt,$lb(fp),pptr) Quit:$$$ISERR(sc)")
	$$$GENERATE(" d .."_%property_"GetInfo(,,,.qHandle)")
	$$$GENERATE(" Quit connection.Execute(hstmt)")
	QUIT $$$OK
}

ClassMethod Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
{
 n connection,hstmt,rlist,sc,ii,val Set connection=$g(qHandle(1)),hstmt=$g(qHandle(2)) Quit:connection=""!(hstmt="") $$$ERROR($$$QueryNotPrepared)
 //s sc=connection.FetchRows(hstmt,.rlist,1) i $$$ISERR(sc) QUIT sc
 s sc=connection.Fetch(hstmt)  i $$$ISERR(sc) QUIT sc
 s Row=""
 if connection.sqlcode=100 Set AtEnd=1 QUIT $$$OK
 for ii=1:1:qHandle("colcount") {
	 if '($g(%SQLGateway("-uv"))&&$zbitget($zversion(0),1)) {s sc=connection.GetData(hstmt, ii, 1, .val)}
	 else { s sc=connection.GetDataW(hstmt, ii, -8, .val)}
	 Quit:$$$ISERR(sc) sc
	 s Row=Row_$lb(val)
 }
 s AtEnd=0 
 
 QUIT $$$OK
}

ClassMethod Prepare(ByRef qHandle As %Binary, sqltext As %String, containid As %Integer = 0, connection As %String) As %Status
{
 QUIT:$g(connection)="" $$$ERROR($$$GatewayConnection)
 n hstmt,mtype,plist,sc
 s mtype=""
 s sc=connection.AllocateStatement(.hstmt) QUIT:$$$ISERR(sc)!(hstmt="") $$$ERROR($$$GatewayAllocate)
  if '$g(%SQLGateway("-uv")) {
	  	s sc=connection.Prepare(hstmt,sqltext) QUIT:$$$ISERR(sc) sc
	  }
	  else{
	  	s sc=connection.PrepareW(hstmt,sqltext) QUIT:$$$ISERR(sc) sc
	  }
 s sc=connection.DescribeParameters(hstmt,.plist) QUIT:$$$ISERR(sc) sc
 i $ll(plist)>1 Do  Quit:$$$ISERR(sc) sc
 . n cdef,datatype,pdesc,pptr,precision,ptype,scale,type
 . s ptype="",precision="",datatype="",scale="",cdef=""
 . f pptr=2:1:$ll(plist) s pdesc=$li(plist,pptr) s type=$li(pdesc,1) s ptype=ptype_$lb(1),datatype=datatype_$lb(type),precision=precision_$lb($li(pdesc,2)),scale=scale_$lb($li(pdesc,3)),cdef=cdef_$lb($li(pdesc,2)) s mtype=mtype_$s(type>1&(type<9):1,1:0)
 . s sc=connection.BindParameters(hstmt,ptype,datatype,precision,scale,cdef) QUIT:$$$ISERR(sc)
 s qHandle(1)=connection,qHandle(2)=hstmt,qHandle(3)=containid,qHandle(4)=mtype
 Quit $$$OK
}

/***********************************************************************\
	| GetInfo() returns information about columns in the query result,      |
	|   parameters in the query formal list, and whether or not the result  |
	|   contains enough information to form an ID value.                    |
	|   This information is return in three pass-by-reference parmeters:    |
	|   colinfo - contains one list element for each column declared        |
	|             in ROWSPEC. The form is name:exttype:caption              |
	|   parminfo - contains one list element for each formal paramter       |
	|             of the query in the form name:exttype                     |
	|   idinfo -  Integer indicating the position of the ID, zero if not    |
	|             included.                                                 |
	|   qHandle - <Optional> query handle, used for dynamic queries
	|   The information is not constructed until the first invocation of    |
	|   GetInfo(). Once the information is compiled the first time, it is   |
	|   stored in the ^oddMAC global and is retrieved on subsequent calls   |
	|   to GetInfo()                                                        |
	\***********************************************************************/
/// Returns information about the query. It is used by the various <b>ResultSet</b> objects.
ClassMethod GetInfo(ByRef colinfo As %List, ByRef parminfo As %List, ByRef idinfo As %List, ByRef qHandle As %Binary, extoption As %Integer = 0, extinfo As %List) As %Status
{
 n colcount,connection,hstmt,i,odbctype,sc,type,uv
 Set connection=$g(qHandle(1)),hstmt=$g(qHandle(2))
 Quit:connection=""!(hstmt="") $$$ERROR($$$QueryNotPrepared)

 s idinfo=$lb($g(qHandle(3)))

 s sc=connection.DescribeColumns(hstmt,.clist) Quit:$$$ISERR(sc) sc
 s colcount=$lg($lg(clist))
 s qHandle("colcount")=colcount
 s colinfo=""
 f i=1:1:colcount s info=$li(clist,i+1) Do
 . Set column=$li(info),odbctype=$li(info,2)+5
 . Set type=+$Piece("12|0|1|7|0|0|14|0|5|5|0|0|3|2|8|9|10","|",odbctype)
 . Set colinfo=colinfo_$Listbuild($Listbuild(column,type,column))

 s sc=connection.DescribeParameters(hstmt,.clist) Quit:$$$ISERR(sc) sc
 s colcount=$lg($lg(clist))
 s sc=connection.GetUV(.uv)
 s qHandle("uv")=uv&&$zbitget($zversion(0),1)
 s parminfo=""
 f i=1:1:colcount s info=$li(clist,i+1) Do
 . Set odbctype=$li(info,1)+5
 . Set type=+$Piece("12|0|1|7|0|0|14|0|5|5|0|0|3|2|8|9|10","|",odbctype)
 . Set parminfo=parminfo_$Listbuild($Listbuild(i,type))
	If extoption Set extinfo = ""
 QUIT $$$OK
}

}
