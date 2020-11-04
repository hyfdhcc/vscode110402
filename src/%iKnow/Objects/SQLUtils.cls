Include (%occInclude, %IKInclude)

Class %iKnow.Objects.SQLUtils Extends (%iKnow.Objects.StoredProcBase, %iKnow.Queries.AbstractQAPI) [ System = 4 ]
{

ClassMethod CrcAsString(domain As %Integer, crcId As %Integer) As %String [ SqlName = CRC_AS_STRING, SqlProc ]
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim str As %String
	#dim list As %List

	Try {
		set list = ##class(%iKnow.Queries.CrcAPI).GetValue(domain, crcId)
		set str = $li(list,1)_" ~ "_$li(list,2)_" ~ "_$li(list,3)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	if ($$$ISERR(sc)) {
		Quit $System.Status.GetErrorText(sc)
	}
	
	Quit str
}

ClassMethod MatchCRC(domain As %Integer, crcId As %Integer, filter As %String = "", verbose As %Boolean = 0, xui As %String = "") As %String [ SqlName = MATCH_CRC, SqlProc ]
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim str, match As %String
	#dim list As %List

	Try {
		set match = "!"
		set list = ##class(%iKnow.Queries.CrcAPI).GetValue(domain, crcId)
		set str = $li(list,1)_" "_$li(list,2)_" "_$li(list,3)
		set str = $zstrip(str,"<>W")
		
		set match = ##class(%iKnow.ont.Matcher).match(str, filter, verbose, xui)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	if ($$$ISERR(sc)) {
		Quit $System.Status.GetErrorText(sc)
	}
	
	Quit match
}

ClassMethod CreateDomainTables(pTableName As %String, pColumnName As %String, ByRef pDomainName As %String = "", pIdColumn As %String = "", lang As %String = "", turnOffJournal As %Boolean = "", noindex As %Boolean = "") As %Status [ ReturnResultsets, SqlName = BuildDomainTables, SqlProc ]
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim tDomainId As %Integer
	
	Try {
		if ('$Isobject($Get(%sqlcontext))) { 
			set %sqlcontext = ##class(%Library.ProcedureContext).%New() 
		}
		
		set rs = ..%New(,"build")
		
		do %sqlcontext.AddResultSet(rs)
		
		if ($g(pDomainName) = "") {
			set pDomainName = ""
		}
		if ($g(pIdColumn) = "") {
			set pIdColumn = "ID"
		}
		if ($g(lang) = "") {
			set lang = ""
		}
		if ($g(turnOffJournal) = "") {
			set turnOffJournal = 0
		}
		if ($g(noindex) = "") {
			set noindex = 1
		}
		
		set sc = $system.iKnow.CreateDomainTables(pTableName, pColumnName, .pDomainName, .tDomainId, pIdColumn, lang, 0, turnOffJournal, noindex)
		Quit:$$$ISERR(sc)
		
		w "Domain: "_pDomainName, !
		w "Domain ID: "_tDomainId, !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod DeleteDomain(pDomainName As %String) As %Status [ ReturnResultsets, SqlName = DeleteDomain, SqlProc ]
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim tDomainId As %Integer
	
	Try {
		if ('$Isobject($Get(%sqlcontext))) { 
			set %sqlcontext = ##class(%Library.ProcedureContext).%New() 
		}
		
		set rs = ..%New(,"delete")
		
		do %sqlcontext.AddResultSet(rs)
		
		if ($g(pDomainName) = "") {
			set sc = $$$ERROR($$$GeneralError,"Domain Name is required")
			d $system.Status.DisplayError(sc)
			Quit
		}
		
		set sc = ##class(%iKnow.Domain).Delete(pDomainName)
		Quit:$$$ISERR(sc)
		
		w "Deleted Domain: "_pDomainName, !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	if ($$$ISERR(sc)) {
		d $system.Status.DisplayError(sc)
	} 

	Quit sc
}

ClassMethod testIO(n As %Integer) As %Status [ Internal, ReturnResultsets, SqlName = IOasRSTest, SqlProc ]
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim i As %Integer

	Try {
		if ('$Isobject($Get(%sqlcontext))) { 
			set %sqlcontext = ##class(%Library.ProcedureContext).%New() 
		}
		
		set rs = ..%New(,"test")
		
		do %sqlcontext.AddResultSet(rs)
		
		for i = 1:1:n {
			w "Test line # "_i, !
		}

	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod CountTokens(str As %String, pattern As %String = "") As %Integer [ SqlName = CountTokens, SqlProc ]
{
	#dim n As %Integer
	#dim sc 	As %Status = $$$OK
	
	set sc = ##class(%DeepSee.extensions.utils.StringMatchUtils).getNumberOfTokens(str, .n, pattern)
	if ($$$ISERR(sc)) {
		set n = -1
	}
	
	Quit n
}

ClassMethod DomainCoverage(domainId As %Integer, topEntities As %Integer, margin As %Integer, type As %String = "ent", Output sc As %Status) As %Double [ SqlName = DomainCoverage, SqlProc ]
{
	set sc = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim rs As %IResultSet
	#dim entList As %List
	#dim schema, sql, table, refId As %String
	
	#dim coverage As %Double
	#dim N As %Integer
	
	Try {
		set coverage = ""
		set sc = ..GetDomainTablesInfo(domainId, , .schema, , .refId)
		Quit:$$$ISERR(sc)
		
		set sql = "select count(*) from "_schema_"Source"
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)

		set rs = stmt.%Execute()
		if ('rs.%Next()) {
			set sc = $$$ERROR($$$GeneralError,"No Data for: "_sql)
			Quit
		}
		
		set N = rs.%GetData(1)
		d rs.%Close()
		
		if (type = "ent") {
			set table = "Ent"
			set entList = ..TopEntitiesList(domainId, topEntities,,.sc)
		} elseif(type = "cui") {
			set table = "CUI"
			set entList = ..TopCUIList(domainId, topEntities,,.sc)
		} else {
			set table = type
		}
		Quit:$$$ISERR(sc)
		set table = table_"MetadataTfIdf"
		
		set sql = "select count(Instance) from ("
		set sql = sql_"select Instance, count(Concept) as num "
		set sql = sql_"from "_schema_table_" "
		set sql = sql_"where Category = '"_refId_"' "
		set sql = sql_"and Concept %INLIST ? "
		set sql = sql_"group by Instance"
		set sql = sql_") "
		set sql = sql_"where num > ?"
		
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)

		set rs = stmt.%Execute(entList, margin)
		if ('rs.%Next()) {
			set sc = $$$ERROR($$$GeneralError,"No Data for: "_sql)
			Quit
		}
		
		set coverage = rs.%GetData(1)
		d rs.%Close()
		
		set coverage = coverage / N
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	if ($$$ISERR(sc)) {
		set coverage = -1 //$system.Status.GetErrorText(sc)
	}
	
	Quit coverage
}

ClassMethod TopEntitiesList(domainId As %Integer, topEntities As %Integer, returnValues As %Boolean = 0, Output sc As %Status) As %List [ SqlName = TopEntitiesList, SqlProc ]
{
	#dim ex As %Exception.AbstractException
	set sc = $$$OK

	#dim rs As %IResultSet
	#dim entList As %List
	
	#dim schema, sql, what As %String
	
	Try {
		set entList = ""
		set sc = ..GetDomainTablesInfo(domainId, , .schema)
		Quit:$$$ISERR(sc)
		
		if (returnValues) {
			set what = "EntityValue"
		} else {
			set what = "EntUniId"
		}
		
		set sql = "select top "_topEntities_" "_what_" from "_schema_"EntityUnique order by CorpusSpreadAsConcept desc"
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)

		set rs = stmt.%Execute()
		While (rs.%Next()) {
			set entList = entList_$lb(rs.%GetData(1))
		}
		d rs.%Close()
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	if ($$$ISERR(sc)) {
		set entList = $lb($system.Status.GetErrorText(sc))
	}
	
	Quit entList
}

ClassMethod TopCUIList(domainId As %Integer, topEntities As %Integer, returnValues As %Boolean = 0, Output sc As %Status) As %List [ SqlName = TopCUIList, SqlProc ]
{
	#dim ex As %Exception.AbstractException
	set sc = $$$OK

	#dim rs As %IResultSet
	#dim entList As %List
	
	#dim schema, sql, what As %String
	
	Try {
		set entList = ""
		set sc = ..GetDomainTablesInfo(domainId, , .schema)
		Quit:$$$ISERR(sc)
		
		if (returnValues) {
			set what = "%iKnow_ont.umlsString(M)"
		} else {
			set what = "M"
		}
		
		set sql = "select top "_topEntities_" "_what_" from "_schema_"CorpusMatches order by Spread desc"
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)

		set rs = stmt.%Execute()
		While (rs.%Next()) {
			set entList = entList_$lb(rs.%GetData(1))
		}
		d rs.%Close()
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	if ($$$ISERR(sc)) {
		set entList = $lb($system.Status.GetErrorText(sc))
	}
	
	Quit entList
}

ClassMethod GetDomainTablesInfo(domainId As %Integer, Output package As %String, Output schema As %String, Output refTable As %String, Output refId As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim domain As %iKnow.Domain
	#dim domainName, refClass, srcClass As %String

	Try {
		set domain = ##class(%iKnow.Domain).OpenId(domainId,.sc)
		set domainName = domain.Name

		set package = domainName_".tables"
		set srcClass = package_".Source"
		set clsDef = ##class(%Dictionary.CompiledClass).%OpenId(srcClass,,.sc)
		Quit:$$$ISERR(sc)
		set schema = clsDef.SqlSchemaName_"."
			
		set pdef = ##class(%Dictionary.CompiledProperty).%OpenId(srcClass_"||Ref",,.sc)
		Quit:$$$ISERR(sc)
		
		set refClass = pdef.Type
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(refClass,,.sc)
		Quit:$$$ISERR(sc)

		set refTable = cDef.SqlSchemaName_"."_cDef.SqlTableName	
		
		set refId = $parameter(srcClass,"RefIdColumn")
			
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod PrintDomainCoverageReport(domainId As %Integer, t1 As %Integer, t2 As %Integer, t3 As %Integer, margin As %Integer, file As %String = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim rs As %IResultSet
	#dim entList, cuiList As %List
	#dim schema, sql, table, refId, line As %String
	
	#dim c1, c2 As %Double
	#dim N, top As %Integer
	
	Try {
		set sc = ..GetDomainTablesInfo(domainId, , .schema, , .refId)
		Quit:$$$ISERR(sc)
		
		set sql = "select count(*) from "_schema_"Source"
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)

		set rs = stmt.%Execute()
		if ('rs.%Next()) {
			set sc = $$$ERROR($$$GeneralError,"No Data for: "_sql)
			Quit
		}
		
		set N = rs.%GetData(1)
		d rs.%Close()
		
		
		set stmt1 = ##class(%SQL.Statement).%New()
		set table = "EntMetadataTfIdf"
		set sql = "select count(Instance) from ("
		set sql = sql_"select Instance, count(Concept) as num "
		set sql = sql_"from "_schema_table_" "
		set sql = sql_"where Category = '"_refId_"' "
		set sql = sql_"and Concept %INLIST ? "
		set sql = sql_"group by Instance"
		set sql = sql_") "
		set sql = sql_"where num > ?"
		set sc = stmt1.%Prepare(sql)
		Quit:$$$ISERR(sc)

		set stmt2 = ##class(%SQL.Statement).%New()
		set table = "CUIMetadataTfIdf"
		set sql = "select count(Instance) from ("
		set sql = sql_"select Instance, count(Concept) as num "
		set sql = sql_"from "_schema_table_" "
		set sql = sql_"where Category = '"_refId_"' "
		set sql = sql_"and Concept %INLIST ? "
		set sql = sql_"group by Instance"
		set sql = sql_") "
		set sql = sql_"where num > ?"
		set sc = stmt2.%Prepare(sql)
		Quit:$$$ISERR(sc)
		
		if (file '= "") {
			set out = ##class(%File).%New(file)
			set sc = out.Open("WSN")
			Quit:$$$ISERR(sc)
		}

		for top = t1:t2:t3 {
			set entList = ..TopEntitiesList(domainId, top,,.sc)
			Quit:$$$ISERR(sc)
			set cuiList = ..TopCUIList(domainId, top,,.sc)
			Quit:$$$ISERR(sc)
			
			set rs = stmt1.%Execute(entList, margin)
			if ('rs.%Next()) {
				set sc = $$$ERROR($$$GeneralError,"No Data for: "_sql_"["_rs.%Message_"]")
				Quit
			}
		
			set c1 = rs.%GetData(1) / N
			d rs.%Close()
		
			set rs = stmt2.%Execute(cuiList, margin)
			if ('rs.%Next()) {
				set sc = $$$ERROR($$$GeneralError,"No Data for: "_sql_"["_rs.%Message_"]")
				Quit
			}
		
			set c2 = rs.%GetData(1) / N
			d rs.%Close()
			
			set line = top_" "_$c(9)_c1_" "_$c(9)_c2
			w line, !
			if (file '= "") {
				set sc = out.WriteLine(line)
				Quit:$$$ISERR(sc)
			}
		}
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc)
	}
	
	Quit sc
}

Query GetRelatedEntities(domainId As %Integer, entityId As %Integer) As %Query(ROWSPEC = "entityId:%Integer,entityValue:%String,proximity:%Integer") [ SqlName = GetRelated, SqlProc ]
{
}

ClassMethod GetRelatedEntitiesExecute(ByRef qHandle As %Binary, domainId As %Integer, entityId As %Integer) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim r
	
	Try {
		set sc = ##class(%iKnow.Semantics.ProximityAPI).GetProfileForEntity(.r,domainId,entityId,1,0)
		Quit:$$$ISERR(sc)
		
		set qHandle = $lb("","ProximityProfile:"_$r(999999))
		m ^||%IKQ.Result($li(qHandle,2)) = r
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetRelatedEntitiesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRelatedEntitiesExecute ]
{
	kill ^||%IKQ.Result(+$lg(qHandle,2))
	Quit $$$OK
}

ClassMethod GetRelatedEntitiesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRelatedEntitiesExecute ]
{
	quit ..GenericFetch(.qHandle, .Row, .AtEnd)
}

/// Searches for entities related to a given or similar string
Query FindRelated(domainId As %Integer, entityValue As %String, similarity As %EnumString = 1) As %Query(ROWSPEC = "entityValue:%String,relatedValue:%String,proximity:%Integer") [ SqlName = FindRelated, SqlProc ]
{
}

ClassMethod FindRelatedExecute(ByRef qHandle As %Binary, domainId As %Integer, entityValue As %String, similarity As %EnumString = 1) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim r, result
	#dim entityId, counter As %Integer
	
	Try {
		set result = ""
		if (similarity = 0) {
			set entityId = ##class(%iKnow.Queries.EntityQAPI).GetId(domainId,entityValue)
			if (entityId > 0) {
				set sc = ##class(%iKnow.Semantics.ProximityAPI).GetProfileForEntity(.r,domainId,entityId,1,0)
				Quit:$$$ISERR(sc)
				
				set sc = ..rr(.r,.result,entityValue)
				Quit:$$$ISERR(sc)
			} 
		} elseif (similarity = 1) {
			set counter = 0
			set rs = ##class(%ResultSet).%New("%iKnow.Queries.EntityQAPI:GetSimilar")
			set sc = rs.Execute(domainId,entityValue,1,0)
			Quit:$$$ISERR(sc)
			
			While (rs.Next()) {
				set entityId = rs.%GetData(1)

				k r
				set sc = ##class(%iKnow.Semantics.ProximityAPI).GetProfileForEntity(.r,domainId,entityId,1,0)
				Quit:$$$ISERR(sc)

				set sc = ..rr(.r,.result,rs.%GetData(2))
				Quit:$$$ISERR(sc)
			}
		}
		
		
		set qHandle = $lb("","PRelated||"_entityValue_"||"_$r(999999))
		m ^||%IKQ.Result($li(qHandle,2)) = result
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod FindRelatedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRelatedExecute ]
{
	kill ^||%IKQ.Result(+$lg(qHandle,2))
	Quit $$$OK
}

ClassMethod FindRelatedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRelatedExecute ]
{
	quit ..GenericFetch(.qHandle, .Row, .AtEnd)
}

ClassMethod rr(ByRef r, ByRef result, v As %String) As %Status [ Internal ]
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim i, p As %Integer
	#dim key, s As %String
	#dim list, lv As %List

	Try {
		set i = $o(r(""))
		set lv = $lb(v)
		
		While (i > 0) {
			set list = r(i)
			set s = $li(list,2)
			set p = 9999999999999999 - $li(list,3)
			set list = lv_$li(list,2,3)
			set key = $j(p,16)_"||"_v_"||"_s
			set result(key) = list
			
			set i = $o(r(i))
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod %DList(class As %String, query As %String, col As %Integer, domainId As %Integer, args As %List) As %List [ SqlName = %DList, SqlProc ]
{
	#dim list As %List
	#dim n As %Integer
	#dim sc As %Status = $$$OK
	
	set list = ""
	set rs = ##class(%ResultSet).%New("%iKnow.Queries."_class_"QAPI:"_query)
	
	
	if ($lv(args)) {
		set n = $ll(args)
		if (n = 1) {
			set sc = rs.Execute(domainId,$li(args,1),1,0)
		} elseif (n = 2) {
			set sc = rs.Execute(domainId,$li(args,1),$li(args,2),1,0)
		} elseif (n = 3) {
			set sc = rs.Execute(domainId,$li(args,1),$li(args,2),$li(args,3),1,0)
		} elseif (n = 4) {
			set sc = rs.Execute(domainId,$li(args,1),$li(args,2),$li(args,3),$li(args,4),1,0)
		} elseif (n = 5) {
			set sc = rs.Execute(domainId,$li(args,1),$li(args,2),$li(args,3),$li(args,4),$li(args,5),1,0)
		} else {
			set sc = $$$ERROR($$$GeneralError,"List of arguments is too long: "_n)
		}
	} else {
		set sc = rs.Execute(domainId,args,1,0)
	}
	
	if ($$$ISERR(sc)) {
		Throw ##class(%Exception.StatusException).CreateFromStatus(sc)
	}
	
	While (rs.%Next()) {
		set list = list_$lb(rs.%GetData(col))
	}
	d rs.Close()
	
	Quit list
}

ClassMethod %List(class As %String, query As %String, col As %Integer, args As %List) As %List [ SqlName = %List, SqlProc ]
{
	#dim list As %List
	#dim n As %Integer
	#dim sc As %Status
	
	set list = ""
	set rs = ##class(%ResultSet).%New(class_":"_query)
	
	
	if ($lv(args)) {
		set n = $ll(args)
		if (n = 1) {
			set sc = rs.Execute($li(args,1))
		} elseif (n = 2) {
			set sc = rs.Execute($li(args,1),$li(args,2))
		} elseif (n = 3) {
			set sc = rs.Execute($li(args,1),$li(args,2),$li(args,3))
		} elseif (n = 4) {
			set sc = rs.Execute($li(args,1),$li(args,2),$li(args,3),$li(args,4))
		} elseif (n = 5) {
			set sc = rs.Execute($li(args,1),$li(args,2),$li(args,3),$li(args,4),$li(args,5))
		}
	} else {
		set sc = rs.Execute(args)
	}
	
	if ($$$ISERR(sc)) {
		Throw ##class(%Exception.StatusException).CreateFromStatus(sc)
	}
	
	While (rs.%Next()) {
		set list = list_$lb(rs.%GetData(col))
	}
	d rs.Close()
	
	Quit list
}

}
