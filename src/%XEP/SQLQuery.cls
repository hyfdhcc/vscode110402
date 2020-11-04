Class %XEP.SQLQuery Extends %RegisteredObject [ System = 4 ]
{

ClassMethod UpdateClassIndex(clname As %String)
{
	s pos = $f(clname,".")
	if pos=0 quit
	s gsubscript=$e(clname,pos,*)
	s ^CacheTempEventIndex(gsubscript,"active")=1
	// clname is a complete classname
loop	s id2=$g(^Event(gsubscript))
	s id1=+$g(^EventI(gsubscript,"curId"))
	while((id2>0)&&('$d(^Event(gsubscript,id2)))) {
		s id2=id2-1
	}
	s delta=id2-id1
	d $classmethod(clname,"%SaveIndices",id1,id2)
	s ^EventI(gsubscript,"curId")=id2+1
	i '$g(^CacheTempEventIndex(gsubscript,"run")) s ^CacheTempEventIndex(gsubscript,"active")=0 quit 
	i delta>1000 g loop
	h .1
	g loop
}

ClassMethod ExecuteQuery(sql As %String(MAXLEN=""), delim As %String) As %Integer
{
	// cname is a short class name (no package)
	//if '$isobject($Get(%sqlcontext)) { set %sqlcontext = ##class(%Library.ProcedureContext).%New() }
	s tablist=$$tableList^%qaqpreparser(.sql)
	s tname=$li(tablist)
	s cname=$$$GetClassNameFromTableName($p(tname,"."),$p(tname,".",2))
	s ^||delim=delim
	s ^||cname=cname
	s pos=$find(cname,".")
	s ^||shcname=$e(cname,pos,*)

	if $$$UPPER(sql) ["WHERE"{ 
		s ^||query=sql_" AND id>= ? AND id <= ?"
	}
	else {
				s ^||query=sql_" WHERE id>= ? AND id <= ?"
	}
  	s ^||ubound=+$g(^EventI(^||shcname,"curId"))  //Current Id
  	s ^||lbound=1
	set rs = ##class(%ResultSet.SQL).%Prepare(^||query,.error,"",^||lbound,^||ubound)
	//do %sqlcontext.AddResultSet(rs)
	set tRSMD = rs.%GetMetaData()
	//k ^result
	
	set ^||numcol = tRSMD.columns.Count()
  	s ^||lbound=^||ubound+1
  	d rs.%SendDelimitedRows(0,delim,.numrows)
  	

	quit numrows
}

ClassMethod DumpResult(rs As %ResultSet.SQL)
{
	  s ^result=$g(^result)
		while rs.%Next(.status){
			s ^result=^result+1
			if ^||numcol {
				set ^result(^result) = rs.%GetData(1)
				for tPtr = 2:1:^||numcol {
					set ^result(^result)= (^result(^result))_(^||delim)_(rs.%GetData(tPtr))
			}
			}
		}
}

ClassMethod MoreData() As %Integer
{
	// cname is a short class name (no package)

	s ^||ubound=+$g(^EventI(^||shcname,"curId"))  //Current Id
	set rs = ##class(%ResultSet.SQL).%Prepare(^||query,.error,"",^||lbound,^||ubound)
	//k ^result
  	d rs.%SendDelimitedRows(0,^||delim,.numrows)
  	s ^||lbound=^||ubound+1
	quit numrows
}

ClassMethod getCurId(cname As %String) As %Integer
{
	// cname is a short class name (no package)
	QUIT +$g(^EventI(cname,"curId"))
}

}
