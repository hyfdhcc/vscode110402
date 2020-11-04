Class %UMLS.Utils Extends %RegisteredObject [ System = 4 ]
{

ClassMethod findPrefSUI(str As %String, ttys As %String = "", Output cuiList As %List, Output suiList As %List, Output srcList As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim strn, langList As %String

	Try {
		set langList = ..getLanguages()
		set strn = $$normalize^%UMLS.apiONT(str)
		
		set ttyList = ""
		if (ttys = "") {
			set ttys = "PT"
		} elseif (ttys [ ",") {
			set ttyList = $lfs(ttys)
		}
		
		if (ttyList '= "") {
			&sql(
				select %DLIST(distinct cui), %DLIST(distinct sui), %DLIST(distinct SAB) into :cuiList,:suiList,:srcList
				from %UMLS_meta.MRCONSO 
				where (str = :str or str = :strn)
					and TTY %INLIST :ttyList
					and LAT %INLIST :langList
			)
		} else {
			&sql(
				select %DLIST(distinct cui), %DLIST(distinct sui), %DLIST(distinct SAB) into :cuiList,:suiList,:srcList
				from %UMLS_meta.MRCONSO 
				where (str = :str or str = :strn)
					and TTY = :ttys
					and LAT %INLIST :langList
			)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod findSUI(str As %String, Output cuiList As %List, Output suiList As %List, Output srcList As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim cuiSet, suiSet, srcSet
	#dim strn As %String

	Try {
		set langList = ..getLanguages()
		set strn = $$normalize^%UMLS.apiONT(str)
		&sql(declare c1 cursor for
			select cui, sui, SAB into :cui,:sui,:src from %UMLS_meta.MRCONSO where (str = :str or str = :strn)
				and LAT %INLIST :langList
		)
		&sql(Open c1)
		&sql(Fetch c1)

		While(SQLCODE = 0) {
			set cuiSet(cui) = 1
			set suiSet(sui) = 1
			set srcSet(src) = 1
			
			&sql(Fetch c1)
		}

		&sql(Close c1)
		Quit:$$$ISERR(sc)

		set sc = ..buildList(.cuiSet, .cuiList)
		Quit:$$$ISERR(sc)
		
		set sc = ..buildList(.suiSet, .suiList)
		Quit:$$$ISERR(sc)
		
		set sc = ..buildList(.srcSet, .srcList)
		Quit:$$$ISERR(sc)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod buildList(ByRef set, Output list) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim key As %String
	
	Try {
		set list = ""
		set key = $o(set(""))
		While (key '= "") {
			if (($l(key) > 100) && set(key) = -1) {
				set list = list_$lb(set(key,1))
			} else {
				set list = list_$lb(key)
			}
			set key = $o(set(key))
		}
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod bestString(cuiList As %List, str As %String = "", isConcept As %Boolean = 1, Output strList As %List, Output suiList As %String, Output luiList As %String, Output auiList As %String, sabList As %List = "") As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim normalizeCode As %String = "$$normalize^%UMLS.apiONT(?)"
	#dim word, desc0 As %String
	#dim d, dMin, score As %Double
	#dim i, n, N1, N2 As %Integer
	#dim langList As %List
	#dim contains As %Boolean
	
	#dim a1, a2, costs, strSet, suiSet, luiSet, auiSet
	
	Try {
		//set zh = $zh
		set strList = ""
		set suiList = ""
		set luiList = ""
		set auiList = ""
		k a1, a2, costs, strSet, suiSet, luiSet, auiSet
		
		set langList = ..getLanguages()
		if (str = "") {
			&sql(declare c3 cursor for
				select str,cui,sui,lui,AUI into :desc,:cui,:sui,:lui,:aui from %UMLS_meta.MRCONSO where 
					LAT %INLIST :langList and
					cui %inlist :cuiList and
					((:sabList is NULL) Or (SAB %INLIST :sabList)) and
					STT = 'PF' and
					TS  = 'P'  and
					ISPREF = 'Y'
			)
			&sql(Open c3)
			&sql(Fetch c3)
			While (SQLCODE = 0) {
				if ($l(desc) > 150) {
					set strSet($e(desc,1,150)) = -1
					set strSet($e(desc,1,150),1) = desc
				} else {
					set strSet(desc) = 1
				}
				set suiSet(sui) = 1
				set luiSet(lui) = 1
				set auiSet(aui) = 1
				&sql(Fetch c3)
			}
			&sql(Close c3)
			Quit:$$$ISERR(sc)			
			
			set sc = ..buildList(.strSet, .strList)
			Quit:$$$ISERR(sc)			
			
			set sc = ..buildList(.suiSet, .suiList)
			Quit:$$$ISERR(sc)			
			
			set sc = ..buildList(.luiSet, .luiList)
			Quit:$$$ISERR(sc)			
			
			set sc = ..buildList(.auiSet, .auiList)
			Quit:$$$ISERR(sc)			
			
			Quit
		}
		
		set sc = ##class(%DeepSee.extensions.utils.StringMatchUtils).tokenize(str, .a1)
		Quit:$$$ISERR(sc)
		
		set n = a1
		set N1 = a1
		for i = 1:1:n {
			set word = a1(i)
			set sc = ..GetSignificanceScore(word, isConcept, .score)
			Quit:$$$ISERR(sc)
			if (score > 0) { 
				set costs(1, word) = score
			} else {
				set costs(1, word) = 0.33
			}
		}
		Quit:$$$ISERR(sc)
		set costs("t") = 0.5
		set costs("s") = 1
		set costs("c") = 0 //0.05
		set costs("n") = 0.2
		set dMin = 10000
		
		&sql(declare c2 cursor for
			select str,cui,sui,lui,AUI into :desc,:sui,:cui,:lui,:aui from %UMLS_meta.MRCONSO 
				where cui %inlist :cuiList 
					and	LAT %INLIST :langList
					and ((:sabList is NULL) Or (SAB %INLIST :sabList)) 
			)
		&sql(Open c2)
		&sql(Fetch c2)
		
		While (SQLCODE = 0) {
			set desc0 = desc
			set desc = $zcvt(desc,"l")
			
			if ((N1 = 1) && '(desc [ str)) {
				&sql(Fetch c2)
				Continue
			}

			set sc = ##class(%DeepSee.extensions.utils.StringMatchUtils).tokenize(desc0, .a2)
			Quit:$$$ISERR(sc)
			set N2 = a2
			
			if ((N2 - N1) < (dMin + 2)) {
				set sc = ##class(%DeepSee.extensions.utils.StringMatchUtils).compareArr(.a1, .a2, .d, .costs, normalizeCode)
				Quit:$$$ISERR(sc)
				
				if (N1 = 1) {
					set contains = 0
					for i = 1:1:N2 {
						if (a2(i) = a1(1)) {
							set contains = 1
							Quit
						}
					}
					
					if ('contains) {
						set d = 1000
					}
				}
				
				if (d < dMin) {
					set dMin = d
					k strSet, suiSet, luiSet, auiSet
				} 
				if (d = dMin) {
					if ($l(desc) > 150) {
						set strSet($e(desc0,1,150)) = -1
						set strSet($e(desc0,1,150),1) = desc
					} else {
						set strSet(desc0) = 1
					}
					set suiSet(sui) = 1
					set luiSet(lui) = 1
					set auiSet(aui) = 1
				}
			}

			&sql(Fetch c2)
		}
		
		set desc = $o(strSet(""))
		if ($o(strSet(desc)) '= "") {
			set dMin = ""
			While (desc '= "") {
				set sc = ##class(%DeepSee.extensions.utils.StringMatchUtils).compareMonoGrams(str, desc, .d, .costs)
				Quit:$$$ISERR(sc)
				if (dMin = "") {
					set dMin = d
				} elseif (d < dMin) {
					set dMin = d
				}
				
				set strSet(desc) = d
				
				set desc = $o(strSet(desc))
			}

			set desc = $o(strSet(""))
			While (desc '= "") {
				if (strSet(desc) > dMin) {
					k strSet(desc)
				}
				set desc = $o(strSet(desc))
			}
		}
		
		&sql(Close c2)
		Quit:$$$ISERR(sc)

		set sc = ..buildList(.strSet, .strList)
		Quit:$$$ISERR(sc)			
			
		set sc = ..buildList(.suiSet, .suiList)
		Quit:$$$ISERR(sc)			
			
		set sc = ..buildList(.luiSet, .luiList)
		Quit:$$$ISERR(sc)			
			
		set sc = ..buildList(.auiSet, .auiList)
		Quit:$$$ISERR(sc)			
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	//set:$d(zh) ^dbgT = $g(^dbgT) + ($zh - zh)
	Quit sc
}

ClassMethod findCUI(pattern As %String, Output cuis As %List, matchType As %String = "like") As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim sql As %String
	#dim rs As %IResultSet
	#dim tmp As %List

	Try {
		if (matchType = "[") {
			set matchType = "like"
			set pattern = "%"_pattern_"%"
		}
		
		set matchType = $zcvt(matchType,"l")
		set cuis = ""
		
		if (matchType = "%startswith") {
			&sql(declare ca cursor for
				select cui into :cui from %UMLS_meta.MRCONSO where str %startsWith :pattern
				group by cui
			)
			&sql(Open ca)
			&sql(Fetch ca)
			While (SQLCODE = 0) {
				set cuis = cuis_$lb(cui)
				&sql(Fetch ca)
			}
			&sql(Close ca)
		} elseif (matchType = "like"){
			&sql(declare cb cursor for
				select cui into :cui from %UMLS_meta.MRCONSO where str like :pattern
				group by cui
			)
			&sql(Open cb)
			&sql(Fetch cb)
			While (SQLCODE = 0) {
				set cuis = cuis_$lb(cui)
				&sql(Fetch cb)
			}
			&sql(Close cb)
		} elseif ((matchType = "similar") || (matchType = "%similar")) {
			if ($l(pattern," ") > 1) {
				set sc = ..findCUI(pattern, .tmp, "%startsWith")
				Quit:$$$ISERR(sc)
				
				set sc = ..findSimilarCUI(pattern, .cuis)
				Quit:$$$ISERR(sc)
				
				set cuis = tmp_cuis
			} else {
				&sql(declare cc cursor for
					select cui into :cui from %UMLS_meta.MRXNW_ENG where nwd %startswith :pattern
					group by cui
				)
				&sql(Open cc)
				&sql(Fetch cc)
				While (SQLCODE = 0) {
					set cuis = cuis_$lb(cui)
					&sql(Fetch cc)
				}
				&sql(Close cc)
				
				if ((cuis = "") && ($l(pattern) > 5)) {
					set sc = ..findCUI($e(pattern,1,*-1), .cuis, matchType)
					Quit:$$$ISERR(sc)
				}
			}
		} else {
			set sql = "select cui from %UMLS_meta.MRCONSO where str "_matchType_" ? group by cui"
			set stmt = ##class(%SQL.Statement).%New()

			set sc = stmt.%Prepare(sql)
			Quit:$$$ISERR(sc)
			
			set rs = stmt.%Execute(pattern)
			While (rs.%Next()) {
				set cui = rs.%GetData(1)
				set cuis = cuis_$lb(cui)
			}
			
			d rs.%Close()
			d stmt.%Close()
		}
		
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod matchCUI(pattern As %String, matchType As %String = "=", filter As %List = "", Output cuis As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim sql As %String
	#dim rs As %IResultSet
	#dim tmp As %List
	#dim fsabs, fstns, f, type, list As %List
	#dim i, n As %Integer

	Try {
		if (filter = "") {
			set sc = ..findCUI(pattern, .cuis, matchType)
			Quit
		}
		
		set fsabs = ""
		set fstns = ""
		
		if ('$lv(filter)) {
			set filter = $lfs(filter,";")
		}
		set n = $ll(filter)
		for i = 1:1:n {
			set f = $li(filter,i)
			if ($lv(f)) {
				set type = $li(f,1)
				set list = $li(f,2)
			} else {
				set type = $p(f,"=",1)
				set list = $lfs($p(f,"=",2))
			}
			set type = $zcvt(type, "U")
			if (type = "SAB") {
				set fsabs = list
			} elseif (type = "STN") {
				set fstns = list
			} else {
				set sc = $$$ERROR($$$GeneralError,"Unknown filter type : "_type)
				Quit
			}
		}
		
		if (matchType = "[") {
			set matchType = "like"
			set pattern = "%"_pattern_"%"
		}
		
		set matchType = $zcvt(matchType,"l")
		set cuis = ""
		
		if (matchType = "%startswith") {
			/*
			&sql(declare c2a cursor for
				select c.cui into :cui 
				from %UMLS_meta.MRCONSO as c 
					join %UMLS_meta.MRSTY as s on s.CUI = c.CUI
				where str %startsWith :pattern
					and (sab %inlist :fsabs or :fsabs is null)
					and (stn %inlist :fstns or :fstns is null)
				group by c.cui
			)
			*/
			if ((fsabs = "") && (fstns = "")) {
				&sql(
					SELECT %DLIST(distinct cui) into :cui 
					FROM %UMLS_meta.MRCONSO
					WHERE str %startsWith :pattern
				)
			} elseif (fstns = "") {
				&sql(
					SELECT %DLIST(distinct cui) into :cui 
					FROM %UMLS_meta.MRCONSO
					WHERE str %startsWith :pattern
					AND sab %INLIST :fsabs
				)
			} elseif (fsabs = "") {
				&sql(
					SELECT %DLIST(distinct cui) into :cui 
					FROM %UMLS_meta.MRSTY
					WHERE stn %INLIST :fstns
						AND CUI %INLIST (
							SELECT %DLIST(cui)
							FROM %UMLS_meta.MRCONSO
							WHERE str %startsWith :pattern
						)
				)
			} else {
				&sql(
					SELECT %DLIST(distinct cui) into :cui 
					FROM %UMLS_meta.MRSTY
					WHERE stn %INLIST :fstns
						AND CUI %INLIST (
							SELECT %DLIST(cui)
							FROM %UMLS_meta.MRCONSO
							WHERE str %startsWith :pattern
							AND sab %INLIST :fsabs
						)
				)
			}
			
			If (SQLCODE = 0) {
				set cuis = cui
			} else {
				throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
			}
		} elseif (matchType = "like"){
			&sql(declare c2b cursor for
				select c.cui into :cui 
				from %UMLS_meta.MRCONSO as c 
					join %UMLS_meta.MRSTY as s on s.CUI = c.CUI
				where str like :pattern
					and (sab %inlist :fsabs or :fsabs is null)
					and (stn %inlist :fstns or :fstns is null)
				group by c.cui
			)
			&sql(Open c2b)
			&sql(Fetch c2b)
			While (SQLCODE = 0) {
				set cuis = cuis_$lb(cui)
				&sql(Fetch c2b)
			}
			&sql(Close c2b)
		} elseif ((matchType = "occurs") || (matchType = "%occurs")) {
			set sc = ..findCUIsFiltered(pattern, "=", fsabs, fstns, .cuis)
			Quit:$$$ISERR(sc)
		} elseif ((matchType = "similar") || (matchType = "%similar")) {
			set sc = ..findCUIsFiltered(pattern, "%startsWith", fsabs, fstns, .cuis)
			Quit:$$$ISERR(sc)

			/*
			if ($l(pattern," ") > 1) {
				set sc = ..matchCUI(pattern, "%startsWith", filter, .tmp)
				Quit:$$$ISERR(sc)
				
				set sc = ..findCUIsFiltered(pattern, "%startsWith", fsabs, fstns, .cuis)
				Quit:$$$ISERR(sc)
				
				set cuis = tmp_cuis
			} else {
				&sql(declare c2c cursor for
					--select cui into :cui from %UMLS_meta.MRXNW_ENG 
					--where nwd %startswith :pattern
					--group by cui
					select c.cui into :cui 
					from %UMLS_meta.MRCONSO as c 
						join %UMLS_meta.MRXNW_ENG as x on x.cui = c.cui
						join %UMLS_meta.MRSTY as s on s.CUI = c.CUI
					where x.nwd = :pattern
						and (sab %inlist :fsabs or :fsabs is null)
						and (stn %inlist :fstns or :fstns is null)
					group by c.cui
				)
				&sql(Open c2c)
				&sql(Fetch c2c)
				While (SQLCODE = 0) {
					set cuis = cuis_$lb(cui)
					&sql(Fetch c2c)
				}
				&sql(Close c2c)
			}
		*/
		} else {
			set sql = "select c.cui "
			set sql = sql_"	from %UMLS_meta.MRCONSO as c "
			set sql = sql_" join %UMLS_meta.MRSTY as s on s.CUI = c.CUI"
			set sql = sql_" where str "_matchType_" ?"
			if (fsabs '= "") {
				set sql = sql_" and sab %inlist ?"
			} else {
				set sql = sql_" and ? is null"
			}
			if (fstns '= "") {
				set sql = sql_" and stn %inlist ?"
			} else {
				set sql = sql_" and ? is null"
			}
			set sql = sql_" group by c.cui"
			//w sql, !
			set stmt = ##class(%SQL.Statement).%New()

			set sc = stmt.%Prepare(sql)
			Quit:$$$ISERR(sc)
			
			set rs = stmt.%Execute(pattern, fsabs, fstns)
			While (rs.%Next()) {
				set cui = rs.%GetData(1)
				set cuis = cuis_$lb(cui)
			}
			
			d rs.%Close()
			d stmt.%Close()
		}
		
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetSAB(cui As %String) As %List [ SqlName = getSAB, SqlProc ]
{
	#dim sab As %List = ""
	
	if (cui = "") {
		Quit ""
	}
	
	&sql(select %DLIST(distinct SAB) into :sab from %UMLS_meta.MRCONSO where CUI = :cui)
	
	Quit sab
}

ClassMethod String(cui As %String) As %String [ SqlName = String, SqlProc ]
{
	if (cui = "") {
		Quit ""
	}
	Quit $$getPrefString^%UMLS.apiONT(cui)
}

ClassMethod getSTY(cui As %String) As %List [ SqlName = getSTY, SqlProc ]
{
	if (cui = "") {
		Quit ""
	}
	Quit $$getATUIList^%UMLS.apiONT($lb(cui))
}

ClassMethod getAUI(str As %String, Output sc As %Status) As %List [ SqlName = getAUI, SqlProc ]
{
	set sc = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim cuiList As %List
	
	Try {
		set auiList = ""
		set str = $$normalize^%UMLS.apiONT(str)
		&sql(
			SELECT %DLIST(AUI) into :auiList
			FROM %UMLS_meta.MRCONSO
			WHERE 
   				STR = :str 
		)
		
		if (auiList '= "") {
			Quit
		}
			
		set sc = ..findCUI(str, .cuiList, "similar")
		Quit:$$$ISERR(sc)

		set sc = ..bestString(cuiList, str, 0, , , , .auiList, "")
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit auiList
}

ClassMethod getExpandedCUIList(str As %String) As %List [ SqlName = getExpandedCUI, SqlProc ]
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim auiList, expList As %List
	#dim aui, root As %String
	#dim i, n As %Integer
	#dim set
	
	Try {
		k set
		set expList = ""
		set auiList = ""
		set auiList = ..getAUI(str, .sc)
		Quit:$$$ISERR(sc)
		
		set n = $ll(auiList)
		for i = 1:1:n {
			set aui = $li(auiList,i)
			
			set cui = ""
			&sql(
				select cui into :cui FROM %UMLS_meta.MRCONSO where AUI = :aui
			)
			if (cui '= "") {
				set set(cui) = ""
			}
			set cui = ""
			
			set ptr = ""
			&sql(
				select ptr into :ptr from %UMLS_meta.MRHIER 
				where aui = :aui
			)
			if (ptr = "") {
				Continue
			}
			set root = $e(ptr,1,8)
			if (root = "A3684559") { // Special Concepts
				Continue
			}
			if (root = "A5461963") {
				Continue
			}
			
			set ptr = ptr_"."_aui
			
			&sql(declare auiCursor cursor for
				select cui into :cui from %UMLS_meta.MRHIER
				where ptr %startswith :ptr
			)
			&sql(Open auiCursor)
			&sql(Fetch auiCursor)
			While (SQLCODE = 0) {
				set set(cui) = ""
				// b:cui="C0017181"
				&sql(Fetch auiCursor)
			}
			&sql(Close auiCursor)
		}
		
		set sc = ..buildList(.set, .expList)
		QUit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit expList
}

ClassMethod expandSTNList(stnList As %List, Output expList As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim sql As %String
	#dim i, n As %Integer
	#dim rs As %IResultSet
	
	Try {
		set expList = ""
		if (stnList = "") {
			Quit
		}
		
		set n = $ll(stnList)
		set sql = "select STN from %UMLS_meta.MRSTY"
		set sql = sql_" where STN %startswith '"_$li(stnList,1)_"'"
		for i = 2:1:n {
			set sql = sql_" or STN %startswith '"_$li(stnList,i)_"'"
		}
		set sql = sql_" group by STN order by STN"
		
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)
		
		set rs = stmt.%Execute()
		
		While (rs.%Next()) {
			set expList = expList_$lb(rs.%GetData(1))
		}
		d rs.%Close()
		d stmt.%Close()
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod completionList(pattern As %String, Output list As %List, limit As %Integer, condition As %String = "") As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim sql As %String
	#dim rs As %IResultSet

	Try {
		set list = ""
		set sql = "select %DLIST (str) from ("
		set sql = sql_"select top ? str from %UMLS_meta.MRCONSO where str %startsWith ?"
		if (condition '= "") {
			set sql = sql_" AND ("_condition_")"
		}
		set sql = sql_" group by sui"
		set sql = sql_" order by str"
		set sql = sql_")"

		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)
		
		set rs = stmt.%Execute(limit, pattern)
		if (rs.%Next()) {
			set list = rs.%GetData(1)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod findMatchByNWD(pattern As %String, matchType As %String = "like", condition As %List, columns As %List, Output results As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim sql, col, columnList1, columnList2, cui, cclause As %String
	#dim rs As %IResultSet
	#dim tmp, carg As %List
	
	#dim ii, n As %Integer
	#dim x As %Boolean

	Try {
		if (matchType = "[") {
			set matchType = "like"
			set pattern = "%"_pattern_"%"
		}
		
		set matchType = $zcvt(matchType,"l")
		
		set n = $ll(columns)
		if (n < 1) {
			set sc = $$$ERROR($$$GeneralError,"No columns specified for query: "_pattern)
			Quit
		}
		
		k results
		set results = ""
		set columnList1 = ""
		set columnList2 = ""
		for ii = 1:1:n {
			set col = $li(columns,ii)
			set results(col) = ""
			set columns(ii) = col
			set columnList2 = columnList2_"%UMLS_meta.MRCONSO."_col
			if ($zcvt(col,"U") = "STR") {
				set columnList1 = columnList1_"%Exact(%UMLS_meta.MRCONSO."_col_")"
			} else {
				set columnList1 = columnList1_"%UMLS_meta.MRCONSO."_col
			}
			if (ii < n) {
				set columnList1 = columnList1_","
				set columnList2 = columnList2_","
			}
		}
		
		set carg = ""
		set cclause = ""
		if (condition '= "") {
			set cclause = $lg(condition,1)
			set carg = $lg(condition,2)
		}

		if ((matchType = "similar") || (matchType = "%similar")) {
			if ($l(pattern," ") > 1) {
				k tmp
				set sc = ..findMatchByNWD(pattern, "%startsWith", condition, columns, .tmp)
				Quit:$$$ISERR(sc)
				
				set sc = ..findSimilarByNWD(pattern, "sui", condition, columns, .results)
				Quit:$$$ISERR(sc)
				
				set results = ""

				for ii = 1:1:n {
					set col = $li(columns,ii)
					set results(col) = tmp(col)_results(col)
				}
			} else {
				set x = 1
				for ii = 1:1:n {
					if ((columns(ii) '= "cui") && (columns(ii) '= "sui")) {
						set x = 0
						Quit
					}
				}
				if (x) {
					set sql = "select "_$lts(columns)_" from %UMLS_meta.MRXNW_ENG where nwd %startswith ? "
					set sql = sql_" group by "_$lts(columns)
					set stmt = ##class(%SQL.Statement).%New()
					w sql, !

					set sc = stmt.%Prepare(sql)
					Quit:$$$ISERR(sc)
				
					set rs = stmt.%Execute(pattern)
					while(rs.%Next()) {
						for ii = 1:1:n {
							s cui = rs.%GetData(ii)
							set col = columns(ii)
							set results(col) = results(col)_$lb(cui)
						}
	 				}
	 	
					d rs.%Close()
					d stmt.%Close()
				
					if ((results(columns(1)) = "") && ($l(pattern) > 5)) {
						set sc = ..findMatchByNWD($e(pattern,1,*-1), matchType, condition, columns, .results)
						Quit:$$$ISERR(sc)
					}
				} else {
					set sc = ..findSimilarByNWD(pattern, "sui", condition, columns, .results)
					Quit:$$$ISERR(sc)
				}
			}
		} else {
			set sql = "select "_columnList1_" from %UMLS_meta.MRCONSO where str "_matchType_" ? "
			if (cclause '= "") {
				set sql = sql_" AND ("_cclause_" )"
			}
			set sql = sql_" group by "_columnList2
			//w sql, !
			//zw carg
			set stmt = ##class(%SQL.Statement).%New()

			set sc = stmt.%Prepare(sql)
			Quit:$$$ISERR(sc)
			
			if (carg = "") {
				set rs = stmt.%Execute(pattern)
			} else {
				set rs = stmt.%Execute(pattern, carg)
			}
			while(rs.%Next()) {
				for ii = 1:1:n {
					s cui = rs.%GetData(ii)
					set col = columns(ii)
					set results(col) = results(col)_$lb(cui)
				}
	 		}
	 	
			d rs.%Close()
			d stmt.%Close()
		}
		
		if (results = "") {
			for ii = 1:1:n {
				set col = $li(columns,ii)
				set results = results_$lb(results(col))
			}	 	
		}
			
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod findSimilarCUI(pattern As %String, Output cuis As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim pList As %List
	#dim qu, cui As %String
	
	#dim ii As %Integer
	#dim rset As %IResultSet

	Try {
		set cuis = ""
		set pattern = $zstrip(pattern,"<=>W")
		set pList = $lfs(pattern, " ")

		SET tSt = ##class(%SQL.Statement).%New()
		s qu = "select a.cui from %UMLS_meta.cuicoll a, %UMLS_meta.MRCONSO b "
		s qu = qu_" where FOR SOME %ELEMENT(nwd)(%value %startswith '"_$$normalize^%UMLS.apiONT($li(pList,1))_"')"
		for ii=2:1:$ll(pList) {
		 	s qu=qu_" AND FOR SOME %ELEMENT(nwd)(%value %startswith '"_$$normalize^%UMLS.apiONT($li(pList,ii))_"')"
 		}
	 	s qu=qu_" AND a.cui=b.cui"
	 	//w qu, !
		s sc = tSt.%Prepare(qu)
		Quit:$$$ISERR(sc)

		s rset=tSt.%Execute()
		while(rset.%Next()) {
			s cui=rset.%GetData(1)
			set cuis = cuis_$lb(cui)
	 	}
	 	
	 	d rset.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod findSimilarCUIFiltered(pattern As %String, fsabs As %List, fstns As %List, Output cuis As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim pList As %List
	#dim qu, cui As %String
	
	#dim ii As %Integer
	#dim rset As %IResultSet

	Try {
		set cuis = ""
		set pattern = $zstrip(pattern,"<=>W")
		set pList = $lfs(pattern, " ")

		SET tSt = ##class(%SQL.Statement).%New()
		s qu = "select a.cui from %UMLS_meta.cuicoll a, %UMLS_meta.MRCONSO b "
		if (fstns '= "") {
			s qu = qu_" join %UMLS_meta.MRSTY as s on s.cui = b.cui "
		}
		s qu = qu_" where FOR SOME %ELEMENT(nwd)(%value %startswith '"_$$normalize^%UMLS.apiONT($li(pList,1))_"')"
		for ii=2:1:$ll(pList) {
		 	s qu=qu_" AND FOR SOME %ELEMENT(nwd)(%value %startswith '"_$$normalize^%UMLS.apiONT($li(pList,ii))_"')"
 		}
	 	s qu=qu_" AND a.cui=b.cui"
	 	if (fsabs '= "") {
	 		s qu=qu_" AND (b.sab %INLIST ?)"
	 	}
	 	if (fstns '= "") {
	 		s qu=qu_" AND (s.stn %INLIST ?)"
	 	}
	 	// w qu, !
		s sc = tSt.%Prepare(qu)
		Quit:$$$ISERR(sc)

		if (fstns '= "") {
			if (fsabs '= "") {
				s rset=tSt.%Execute(fsabs, fstns)
			} else {
				s rset=tSt.%Execute(fstns)
			}
		} else {
			if (fsabs '= "") {
				s rset=tSt.%Execute(fsabs)
			} else {
				s rset=tSt.%Execute()
			}
		}
		while(rset.%Next()) {
			s cui=rset.%GetData(1)
			set cuis = cuis_$lb(cui)
	 	}
	 	
	 	d rset.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod findCUIsFiltered(pattern As %String, matchType As %String, fsabs As %List, fstns As %List, Output cuis As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim pList As %List
	#dim sql, subsql As %String
	
	#dim ii As %Integer
	#dim rset As %IResultSet

	Try {
		set cuis = ""
		set pattern = $zstrip(pattern,"<=>W")
		set pList = $lfs(pattern, " ")

		SET tSt = ##class(%SQL.Statement).%New()
		s subsql = "SELECT %DLIST(CUI) FROM %UMLS_meta.cuicoll"
		s subsql = subsql_" WHERE "
		for ii=1:1:$ll(pList) {
			if (ii > 1) {
				s subsql = subsql_" AND "
			}
		 	s subsql = subsql_" FOR SOME %ELEMENT(nwd)(%VALUE "_matchType
		 	s subsql = subsql_" '"_$$normalize^%UMLS.apiONT($li(pList,ii))_"')"
 		}
		
		if (fstns '= "") {
			set sql = "SELECT %DLIST(CUI) FROM %UMLS_meta.MRSTY"
			set sql = sql_" WHERE STN %INLIST ? AND CUI %INLIST ("_subsql_")"
		}
	 	if (fsabs '= "") {
		 	if (fstns '= "") {
			 	set subsql = sql
		 	}
			set sql = "SELECT %DLIST(CUI) FROM %UMLS_meta.MRCONSO"
			set sql = sql_" WHERE SAB %INLIST ? AND CUI %INLIST ("_subsql_")"
	 	}

	 	// w sql, !
		s sc = tSt.%Prepare(sql)
		Quit:$$$ISERR(sc)

		if (fstns '= "") {
			if (fsabs '= "") {
				s rset=tSt.%Execute(fsabs, fstns)
			} else {
				s rset=tSt.%Execute(fstns)
			}
		} else {
			if (fsabs '= "") {
				s rset=tSt.%Execute(fsabs)
			} else {
				s rset=tSt.%Execute()
			}
		}
		
		if (rset.%Next()) {
			s cuis = rset.%GetData(1)
	 	} else {
		 	set sc = $$$ERROR($$$GeneralError,"NO DATA")
		 	Quit
	 	}
	 	
	 	d rset.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod findSimilarByNWD(pattern As %String, key As %String, condition As %List, columns As %List, Output results As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim pList, carg As %List
	#dim sql, cui, col, cclause As %String
	
	#dim ii, n As %Integer
	#dim rset As %IResultSet

	Try {
		k results
		set results = ""
		set pattern = $zstrip(pattern,"<=>W")
		set pList = $lfs(pattern, " ")

		SET tSt = ##class(%SQL.Statement).%New()
		set sql = "select "
		set n = $ll(columns)
		if (n < 1) {
			set sc = $$$ERROR($$$GeneralError,"No columns specified for query: "_pattern)
			Quit
		}
		
		for ii = 1:1:n {
			set col = $li(columns,ii)
			set results(col) = ""
			set columns(ii) = col
			set sql = sql_"b."_col
			if (ii < n) {
				set sql = sql_","
			}
		}

		set carg = ""
		set cclause = ""
		if (condition '= "") {
			set cclause = $lg(condition,1)
			set carg = $lg(condition,2)
		}
		
		set sql = sql_" from %UMLS_meta."_key_"coll a, %UMLS_meta.MRCONSO b "
		set sql = sql_" where FOR SOME %ELEMENT(nwd)(%value %startswith '"_$$normalize^%UMLS.apiONT($li(pList,1))_"')"
		for ii=2:1:$ll(pList) {
		 	set sql=sql_" AND FOR SOME %ELEMENT(nwd)(%value %startswith '"_$$normalize^%UMLS.apiONT($li(pList,ii))_"')"
 		}
	 	s sql = sql_" AND a."_key_"=b."_key
	 	if (cclause '= "") {
		 	set sql = sql_" AND ( "_cclause_" )"
	 	}
	 	
	 	//w sql, !
		s sc = tSt.%Prepare(sql)
		Quit:$$$ISERR(sc)

	 	if (carg = "") {
			s rset=tSt.%Execute()
	 	} else {
			s rset=tSt.%Execute(carg)
	 	}
		while(rset.%Next()) {
			for ii = 1:1:n {
				s cui = rset.%GetData(ii)
				set col = columns(ii)
				set results(col) = results(col)_$lb(cui)
			}
	 	}
	 	d rset.%Close()
	 	
		for ii = 1:1:n {
			set col = $li(columns,ii)
			set results = results_$lb(results(col))
		}	 	
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetSignificanceScore(mgram As %String, isConcept As %Boolean, Output score As %Double, Output score2 As %Double) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim sca
	#dim n As %Integer
	
	Try {
		set score2 = 1
		if ($isvalidnum(mgram)) {
			set score = 0.25
			Quit
		}
		set n = $$GetGType^%UMLS.apiONT(mgram,.sca)
		if (n = 0) {
			set n = $$getTermFrequency^%UMLS.apiONT(mgram)
			if (n = 0) {
				set score = 0
			} else {
				set score = 1
			}
			set score2 = score
			Quit
		}
		
		set score = $s(
			($g(sca("PREP"), 0) > 0):0,
			($g(sca("CONJ"), 0) > 0):0,
			($g(sca("MODAL"),0) > 0):0,
			($g(sca("COMPL"),0) > 0):0,
			($g(sca("PRON"), 0) > 0):0,
			($g(sca("AUX"),  0) > 0):0,
			($g(sca("DET"),  0) > 0):0,
			($g(sca("ADV"),	 0) > 0):0.5,
			($g(sca("ADJ"),	 0) > 0):0.75,
			1:""
		)
		
		if (score '= "") {
			set score2 = score
			Quit
		}
		
		if (('isConcept) && ($g(sca("VERB"),0) > 0)) {
			set score = 0.75
		} else {
			set score = 1
		}

		set score2 = score

	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod isValidSource(sab As %String) As %Boolean
{
	set n = 0
	&sql(select count(*) into :n from %UMLS_meta.MRSAB where RSAB = :sab)
	if (SQLCODE '= 0) {
		throw ##class(%Exception.SQL).CreateFromSQLCODE(SQLCODE,%msg)
	}
	
	Quit (n>0)
}

ClassMethod getIKnowLanguage(langId As %Integer)
{
	// $LB("en","fr","de","nl","es","pt","ru")
	Quit $case(langId,1:"ENG",2:"FRE",3:"GER",4:"DUT",5:"SPA",6:"POR",7:"RUS")
}

ClassMethod getLanguages() As %List
{
	if ($g(%domainLanguages) '= "") {
		Quit %domainLanguages
	}
	Quit $g(^ISC.UMLS.PreferredLanguages,$g(^%UMLS.Install.Languages,$lb("ENG")))
}

ClassMethod %version() As %String [ SqlName = version, SqlProc ]
{
	#dim v As %String = $$version^%UMLS.apiONT()
	if ($e(v,1,6) = "%UMLS-") {
		set v = $e(v,7,*)
	}
	Quit v
}

ClassMethod setLanguages(lang As %List)
{
	if (lang = "") {
		k ^ISC.UMLS.PreferredLanguages
	} else {
		set ^ISC.UMLS.PreferredLanguages = lang
	}
}

ClassMethod GetTermFrequency(term As %String) As %Integer
{
	#dim ex As %Exception.AbstractException
	#dim lat, sql, table, col As %String
	#dim i, n, f, f1 As %Integer
	#dim langlist As %List
	#dim rs As %IResultSet
	
	set f = 0
	set langlist = ..getLanguages()
	set n = $ll(langlist)
	
	for i = 1:1:n {
		set lat = $li(langlist, i)
		if (lat = "ENG") {
			set f1 = $$getTermFrequency^%UMLS.apiONT(term,1)
		} else {
			set table = "MRXW_"_lat
			set col = "WD"
			set sql = "select count(*) from %UMLS_meta."_table_" where "_col_" = ?"
			//w sql_"{"_term_"}", !
			
			set rs = ##class(%SQL.Statement).%ExecDirect(,sql, term)
			if (rs.%SQLCODE '= 0) {
				set ex = ##class(%Exception.SQL).CreateFromSQLCODE(rs.%SQLCODE, rs.%Message)
				Throw ex
			}
			
			d rs.%Next()
			set f1 = rs.%GetData(1)
		}
		
		set f = f + f1
	}
	
	Quit f
}

ClassMethod GetParentsByString(str As %String, cuiList As %List, sabList As %List, Output parentList As %List, Output pauiList) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim auiList As %List

	Try {
		set sc = ..GetAUIByString(str, .cuiList, sabList, .auiList)
		Quit:$$$ISERR(sc)
		
		if (auiList = "") {
			set parentList = ""
			set pauiList = ""
			Quit
		}
		
		set sc = ..GetParentsByAUI(auiList, sabList, .parentList, .pauiList)
		Quit:$$$ISERR(sc)
		
		if (parentList = "") {
			k auiList
			set sc = ..GetAUIByString("", cuiList, sabList, .auiList)
			Quit:$$$ISERR(sc)
			
			if (auiList = "") {
				Quit
			}
			set sc = ..GetParentsByAUI(auiList, sabList, .parentList, .pauiList)
			Quit:$$$ISERR(sc)
		}
		
		if (parentList = "") {
			set parentList = $lb("")
		}
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetAUIByString(str As %String, ByRef cuiList As %List, sabList As %List, Output auiList) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim r
	
	Try {
		set auiList = ""
		if (0) {
			set sc = ..findMatchByNWD(str,"similar","",$lb("AUI"),.r)
			Quit:$$$ISERR(sc)
			
			set auiList = r("AUI")
		} else {
			&sql(
				SELECT %DLIST(AUI) into :auiList
				FROM %UMLS_meta.MRCONSO
				WHERE 
    				STR = :str 
    				AND SAB %INLIST :sabList
    				AND (:cuiList is NULL OR CUI %INLIST :cuiList)
			)
			
			if (auiList '= "") {
				Quit
			}
			
			if (cuiList = "") {
				set sc = ..findCUI(str, .cuiList, "similar")
				Quit:$$$ISERR(sc)
			} 

			set sc = ..bestString(cuiList, str, 0, , , , .auiList, sabList)
			Quit:$$$ISERR(sc)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetAncestors(str As %String, cuiList As %List, sabList As %List, ByRef level As %Integer, Output parentList As %List, Output pauiList) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim auiList, plist, a2list As %List
	#dim i As %Integer

	Try {
		set sc = ..GetAUIByString(str, .cuiList, sabList, .auiList)
		Quit:$$$ISERR(sc)
		
		if (auiList = "") {
			set parentList = ""
			set pauiList = ""
			Quit
		}
		
		for i = 1:1:level {
			set sc = ..GetParentsByAUI(auiList, sabList, .plist, .pauiList)
			Quit:$$$ISERR(sc)
			
			if (pauiList = "") {
				set a2list = ""
				set sc = ..AUIList2CUIList(auiList, .cuiList)
				Quit:$$$ISERR(sc)
				
				set sc = ..GetAUIByString("", cuiList, sabList, .a2list)
				Quit:$$$ISERR(sc)
			
				if (auiList = "") {
					Quit
				}
				set sc = ..GetParentsByAUI(a2list, sabList, .parentList, .pauiList)
				Quit:$$$ISERR(sc)
			}

			if (pauiList = "") {
				set level = i - 1
				if (level > 1) {
					set pauiList = auiList
				} else {
					set parentList = $lb("")
				}
				Quit
			}
			
			set auiList = pauiList
			set parentList = plist
		}
		Quit:$$$ISERR(sc)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetHighLevelConcepts(str As %String, cuiList As %List, level As %Integer, Output styList As %List, Output stnList) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim stn2List As %List
	#dim i, n, j, k As %Integer
	#dim stn As %String

	Try {
		set styList = ""
		set stnList = ""
		if (cuiList = "") {
			set sc = ..findCUI(str, .cuiList, "=")
			Quit:$$$ISERR(sc)

			if (cuiList = "") {
				set sc = ..findCUI(str, .cuiList, "similar")
				Quit:$$$ISERR(sc)
			}
		}
		
		&sql(
			select %DLIST(distinct STN) into :stnList from %UMLS_meta.MRSTY
			where CUI %INLIST :cuiList
		)
		
		if (level > 1) {
			set stn2List = ""
			set n = $ll(stnList)
			for i = 1:1:n {
				set stn = $li(stnList,i)
				set k = $l(stn,".") - level + 1
				if (k > 0) {
					set stn = $p(stn,".",1,k)
				}
				set stn2List = stn2List_$lb(stn)
			}
			set stnList = stn2List
		}
		
		&sql(declare csty cursor for
			select STN, STY into :stn, :sty from %UMLS_meta.MRSTY where STN %INLIST :stnList group by STN
		)
		&sql(Open csty)
		&sql(Fetch csty)
		While (SQLCODE = 0) {
			set styList = styList_$lb($lb("IS A",stn,sty))
			&sql(Fetch csty)
		}
		&sql(Close csty)
		
		Quit:$$$ISERR(sc)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetParentsByAUI(auiList As %List, sabList As %List, Output parentList As %List, Output pauiList) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim plist As %List

	Try {
		set parentList = ""
		set pauiList = ""
		
		&sql(declare c4 cursor for
			SELECT * 
     			into :aui, :paui, :rela, :sab, :pcui, :pstr
			FROM (
				SELECT h.AUI, h.PAUI, h.RELA, h.SAB,
					c.CUI, c.STR
				FROM %UMLS_meta.MRHIER as h
					JOIN %UMLS_meta.mrconso as c ON c.AUI = h.PAUI
				WHERE	
					h.AUI %INLIST :auiList
					AND ((h.SAB %INLIST :sabList) OR :sabList is null)
				GROUP BY PAUI
			) GROUP BY CUI
		)
		&sql(Open c4)
		&sql(Fetch c4)		
		While (SQLCODE = 0) {
			set plist = $lb(rela,paui,pstr,sab)
			set parentList = parentList_$lb(plist)
			set pauiList = pauiList_$lb(paui)
			&sql(Fetch c4)		
		}
		&sql(Close c4)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetChildrenAsRS(aui As %String, Output rs As %IResultSet, columnList As %List = "")
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim sql As %String
	#dim i, n As %Integer

	Try {
		set rs = ""

		set sc = ..SqlChildrenByAUI(.sql, columnList)
		Quit:$$$ISERR(sc)
		
		//w sql, !
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)
		
		set rs = stmt.%Execute(aui)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod SqlChildrenByAUI(Output sql As %String, columnList As %List = "")
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim i, n As %Integer
	#dim c As %String

	Try {
		set n = $ll(columnList)
		if (n < 1) {
			set columnList = $lb("cui","str")
			set n = $ll(columnList)
		}
		set sql = "select "
		for i = 1:1:n {
			set c = $li(columnList,i)
			if ($system.SQL.IsReservedWord(c)) {
				set c = $$$QUOTE(c)
			}
			set sql = sql_"c."_c
			if (i < n) {
				set sql = sql_","
			}
		}
		set sql = sql_" from %UMLS_meta.MRHIER as h"
		set sql = sql_" JOIN %UMLS_meta.mrconso as c ON c.AUI = h.AUI"
		set sql = sql_" WHERE h.PAUI = ?"
		set sql = sql_" GROUP BY h.CUI"
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod SqlDescendantsByAUI(Output sql As %String, aui As %String, columnList As %List = "", level As %Integer = "")
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim i, n, l, k As %Integer
	#dim ptr, c As %String

	Try {
		set ptr = ""
		&sql(select PTR into :ptr from %UMLS_meta.MRHIER where AUI = :aui)
		if (ptr '= "") {
			set ptr = ptr_"."
		} 
		//set ptr = ptr_aui
		set l = $l(ptr,".") 
		
		set n = $ll(columnList)
		if (n < 1) {
			set columnList = $lb("cui","str")
			set n = $ll(columnList)
		}
		set sql = "select "
		for i = 1:1:n {
			set c = $li(columnList,i)
			if (c = "$PTR") {
				for k = (l+1):1:(l + level) {
					set c = "(select top 1 STR from %UMLS_meta.MRCONSO As c2 where c2.AUI = $piece(h.PTR,'.',"_k_"))"
					set sql = sql_" "_c
					if ((k < (l + level)) || (i < n)) {
						set sql = sql_","
					}
				}
				Continue
			}
			if ($system.SQL.IsReservedWord(c)) {
				set c = $$$QUOTE(c)
			}
			set sql = sql_"c."_c
			if (i < n) {
				set sql = sql_","
			}
		}
		
		set sql = sql_" from %UMLS_meta.MRHIER as h"
		set sql = sql_" JOIN %UMLS_meta.mrconso as c ON c.AUI = h.AUI"
		set sql = sql_" WHERE  h.PTR %Startswith '"_ptr_"'||?"
		if (level > 0) {
			set sql = sql_" AND ($length(h.PTR,'.') - "_l_") = ?"
		}
		set sql = sql_" GROUP BY h.CUI"
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetSTNChildrenAsRS(stn As %List, limit As %Integer, columnList As %List = "", Output rs As %IResultSet)
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim sql As %String
	#dim i, n As %Integer
	#dim langList As %List

	Try {
		set langList = ..getLanguages()
		set rs = ""
		set n = $ll(columnList)
		if (n < 1) {
			set columnList = $lb("cui","str")
			set n = $ll(columnList)
		}
		set sql = "select "
		for i = 1:1:n {
			set sql = sql_"c."""_$li(columnList,i)_""""
			if (i < n) {
				set sql = sql_","
			}
		}
		set sql = sql_" from %UMLS_meta.mrconso as c "
		set sql = sql_" WHERE c.CUI %INLIST (select %DLIST(cui) from (select"
		if (+limit > 0) {
			set sql = sql_" top "_limit_" "
		}
		set sql = sql_" cui from %UMLS_meta.MRSTY as h"
		set sql = sql_" 	WHERE h.STN %INLIST ?"
		set sql = sql_"      	AND not exists (select * from %UMLS_meta.MRSTY as h2 "
		set sql = sql_"      		where h.cui = h2.cui and not h.STN %INLIST ?)"
		set sql = sql_" ))"
		set sql = sql_" AND LAT %INLIST ?"
		set sql = sql_" AND STT = 'PF' "
		set sql = sql_" AND TS  = 'P' "
		set sql = sql_" AND ISPREF = 'Y'"
		set sql = sql_" GROUP BY c.CUI"
		
		//w sql, !
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)
		
		set rs = stmt.%Execute(stn, stn, langList)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetDescendantsAsRS(auiList As %List, level As %Integer = 1, Output rs As %IResultSet, columnList As %List = "")
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim descendants As %List

	Try {
		set sc = ..GetDescendants(auiList, level, .descendants)
		Quit:$$$ISERR(sc)
		
		set sc = ..GetRSByAUIList(descendants, .rs, columnList)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetRSByAUIList(auiList As %List, Output rs As %IResultSet, columnList As %List = "")
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim sql As %String
	#dim i, n As %Integer

	Try {
		set rs = ""
		set n = $ll(columnList)
		if (n < 1) {
			set columnList = $lb("cui","str")
			set n = $ll(columnList)
		}
		set sql = "select "
		for i = 1:1:n {
			set sql = sql_""""_$li(columnList,i)_""""
			if (i < n) {
				set sql = sql_","
			}
		}
		set sql = sql_" FROM %UMLS_meta.mrconso"
		set sql = sql_" WHERE AUI %INLIST ?"
		set sql = sql_" GROUP BY CUI"
		set stmt = ##class(%SQL.Statement).%New()
		set sc = stmt.%Prepare(sql)
		Quit:$$$ISERR(sc)
		
		set rs = stmt.%Execute(auiList)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetChildrenAsList(auiList As %List, Output cauiList As %List, curList As %List = "")
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim sql As %String
	#dim i, n As %Integer

	Try {
		set cauiList = ""
		if (curList = "") {
			set curList = $lb("")
		}
		&sql(
			select %DLIST(distinct AUI) into :cauiList 
			from %UMLS_meta.MRHIER 
			where PAUI %INLIST :auiList and NOT (AUI %INLIST :curList) 
		)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod AUIList2CUIList(auiList As %List, Output cuiList As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set cuiList = ""
		&sql(
			select %DLIST(distinct CUI) into :cuiList 
			from %UMLS_meta.MRCONSO
			where AUI %INLIST :auiList 
		)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod AUIList2StrList(auiList As %List, Output strList As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set strList = ""
		&sql(
			select %DLIST(distinct STR) into :strList 
			from %UMLS_meta.MRCONSO
			where AUI %INLIST :auiList 
		)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

ClassMethod GetDescendants(auiList As %List, level As %Integer = 1, Output descendants As %List)
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim i As %Integer
	#dim childList As %List

	Try {
		set childList = ""
		set descendants =""
		for i = 1:1:level {
			set sc = ..GetChildrenAsList(auiList,.childList,descendants)
			Quit:$$$ISERR(sc)
			set auiList = childList
			set descendants = descendants_childList
		}
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}

	Quit sc
}

}
