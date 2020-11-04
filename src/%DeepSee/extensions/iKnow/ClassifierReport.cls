Include (%IKPublic, %occInclude)

Class %DeepSee.extensions.iKnow.ClassifierReport Extends %RegisteredObject [ System = 4 ]
{

ClassMethod TextReport(conf As %DeepSee.extensions.iKnow.conf.Config, keywords As %String, listPos As %List, listNeg As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		w "Principal contributors to main component:", !
		w "  Positive:", !
		set sc = ..PrintList(conf, keywords, listPos)
		Quit:$$$ISERR(sc)
		
		w "  Negative:", !
		set sc = ..PrintList(conf, keywords, listNeg)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod TextGDAReport(conf As %DeepSee.extensions.iKnow.conf.Config, keywords As %String, N As %Integer, listPos As %List, listNeg As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		w "Principal contributors to component #"_N_":", !
		w "  Positive:", !
		set sc = ..PrintContribList(conf, keywords, listPos)
		Quit:$$$ISERR(sc)
		
		w "  Negative:", !
		set sc = ..PrintContribList(conf, keywords, listNeg)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod CSVReport(fileName As %String, conf As %DeepSee.extensions.iKnow.conf.Config, keywords As %String, listPos As %List, listNeg As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim target As %String
	
	Try {
		set file = ##class(%File).%New(fileName)
		
		set sc = file.Open("WSN")
		Quit:$$$ISERR(sc)
		
		set target = conf.classifier.TargetValue
		set sc = file.WriteLine("N, Term, Contrib, P("_target_"|term), sDiff, fDiff, s1, f1, s2, f2")
		Quit:$$$ISERR(sc)
		
		set sc = ..PrintList(conf, keywords, listPos, file)
		Quit:$$$ISERR(sc)
		
		set sc = ..PrintList(conf, keywords, listNeg, file)
		Quit:$$$ISERR(sc)
		
		d file.Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod HTMLReport(fileName As %String, conf As %DeepSee.extensions.iKnow.conf.Config, keywords As %String, listPos As %List, listNeg As %List) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim target As %String
	
	#dim Top
	
	Try {
		set file = ##class(%File).%New(fileName)
		
		set sc = file.Open("WSN")
		Quit:$$$ISERR(sc)
		
		set sc = ..openHTML(file, conf)
		Quit:$$$ISERR(sc)
		
		set sc = ..PrintList(conf, keywords, listPos, file, .Top)
		Quit:$$$ISERR(sc)
		
		
		set sc = file.WriteLine("</table>")
		Quit:$$$ISERR(sc)
		set sc = ..writeHTMLTableHeader(file, "Negative Contributions", conf.classifier.TargetValue)
		Quit:$$$ISERR(sc)
		
		set sc = ..PrintList(conf, keywords, listNeg, file, .Top)
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</table>")
		
		set sc = ..writeHTMLTopTable(file, .Top)
		Quit:$$$ISERR(sc)

		set sc = ..writeHTMLTableLegend(file, conf.classifier.TargetValue)
		Quit:$$$ISERR(sc)

		set sc = ..closeHTML(file)		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod PrintList(conf As %DeepSee.extensions.iKnow.conf.Config, keywords As %String, list As %List, file As %File = "", Output Top) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim n, i, k, idx, maxlen As %Integer
	#dim w As %Double
	#dim keyword As %String
	#dim p As %Integer
	#dim D
	
	Try {
		set n = $ll(list)

		set maxlen = 0		
		for i=1:1:n {
			set k = $li($li(list,i),1)
			set keyword = $p(keywords,",",k)
			if ($l(keyword) > maxlen) {
				set maxlen = $l(keyword)
			}
		}
				
		for i=1:1:n {
			set k = $li(list,i)
			set w = $li(k,2) * 100
			set k = $li(k,1)
			set keyword = $p(keywords,",",k)
			set sc = ..GetFilteredData(conf, keyword, .D)
			Quit:$$$ISERR(sc)
			
			
			set p = D(0)
			if (p > 0.55) {
				if (w > 0) {
					set Top(1,1) = $g(Top(1,1)) + 1
					set Top(1,1,Top(1,1)) = keyword
				} else {
					set Top(1,-1) = $g(Top(1,-1)) + 1
					set Top(1,-1,Top(1,-1)) = keyword
				}
			} elseif (p < 0.45) {
				if (w > 0) {
					set Top(-1,1) = $g(Top(-1,1)) + 1
					set Top(-1,1,Top(-1,1)) = keyword
				} else {
					set Top(-1,-1) = $g(Top(-1,-1)) + 1
					set Top(-1,-1,Top(-1,-1)) = keyword
				}
			}
			
			if (file = "") {
				set sc = ..outputText(i, k, maxlen, keyword, w, .D)
			} elseif ($e(file.Name,*-4,*) = ".html") {
				set sc = ..outputHTML(file, i, maxlen, keyword, w, .D)
			} else {
				set sc = ..outputCSV(file, i, maxlen, keyword, w, .D)
			}
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod PrintContribList(conf As %DeepSee.extensions.iKnow.conf.Config, keywords As %String, list As %List, file As %File = "", Output Top) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim n, i, k, idx, maxlen As %Integer
	#dim w As %Double
	#dim keyword As %String
	
	Try {
		set n = $ll(list)

		set maxlen = 0		
		for i=1:1:n {
			set k = $li($li(list,i),1)
			set keyword = $p(keywords,",",k)
			if ($l(keyword) > maxlen) {
				set maxlen = $l(keyword)
			}
		}
				
		for i=1:1:n {
			set k = $li(list,i)
			set w = $li(k,2) * 100
			set k = $li(k,1)
			set keyword = $p(keywords,",",k)

			if (file = "") {
				set sc = ..outputText(i, k, maxlen, keyword, w)
			} elseif ($e(file.Name,*-4,*) = ".html") {
				set sc = ..outputHTML(file, i, maxlen, keyword, w)
			} else {
				set sc = ..outputCSV(file, i, maxlen, keyword, w)
			}
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod outputText(i As %Integer, k As %Integer, maxlen As %Integer, keyword As %String, w As %Double, ByRef D) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim idx As %Integer
	
	Try {
		
			w $j(i,3)_"/"_$j(k,3)_": "_keyword_$j(": ", maxlen - $l(keyword) + 2)_$c(9)_$fn(w,"",2)_"%"
			
			if ($d(D) > 1) {
				for idx = 0:1:2 {
					w $j($fn(D(idx),"",2),6)
				}
				for idx = 3:1:6 {
					w $j(D(idx),6)
				}
			}
			w !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod outputCSV(file As %File, i As %Integer, maxlen As %Integer, keyword As %String, w As %Double, ByRef D) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim idx As %Integer
	
	Try {
		set sc = file.Write($j(i,3)_", "_keyword_$j(", ", maxlen - $l(keyword) + 2)_$c(9)_$fn(w,"",2)_"%"_",")
		Quit:$$$ISERR(sc)
		if ($d(D) > 1) {
			for idx = 0:1:2 {
				set sc = file.Write($j($fn(D(idx),"",2),6)_",")
				Quit:$$$ISERR(sc)
			}
			Quit:$$$ISERR(sc)
			for idx = 3:1:6 {
				set sc = file.Write($j(D(idx),6)_",")
				Quit:$$$ISERR(sc)
			}
			Quit:$$$ISERR(sc)
		}
		set sc = file.WriteLine()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod GetFilteredData(conf As %DeepSee.extensions.iKnow.conf.Config, entity As %String, Output D) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim domainId, mdKey, mdValue As %String
	#dim id As %String
	#dim isCRC As %Boolean
	
	#dim s1, s0, f1, f0, N1, N0 As %Integer
	#dim ds, df, bayes As %Double

	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	#dim config As %DeepSee.extensions.iKnow.conf.Data = conf.data
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	
	Try {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(config.Domain)
		set mdKey = model.MDField
		set mdValue = classifier.TargetValue
		set sc = ..GetId(domainId, conf, entity, .id, .isCRC)
		Quit:$$$ISERR(sc)
		
		set filter = ##class(%iKnow.Filters.SimpleMetadataFilter).%New(domainId, mdKey, "=", mdValue)
		set N1 = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domainId, filter, sc)
		Quit:$$$ISERR(sc)
		
		if (isCRC) {
			set s1 = filter.GetFilteredCrcSpread(id)
			set f1 = filter.GetFilteredCrcFrequency(id)
		} else {
			set s1 = filter.GetFilteredEntitySpread(id, $$$ENTTYPECONCEPT)
			set f1 = filter.GetFilteredEntityFrequency(id, $$$ENTTYPECONCEPT)
		}
		
		set filter = ##class(%iKnow.Filters.SimpleMetadataFilter).%New(domainId, mdKey, "!=", mdValue)
		if (filter = "") {
			set sc = %objlasterror
			Quit
		}
		set N0 = ##class(%iKnow.Queries.SourceAPI).GetCountByDomain(domainId, filter, sc)
		Quit:$$$ISERR(sc)
		
		if (isCRC) {
			set s0 = filter.GetFilteredCrcSpread(id)
			set f0 = filter.GetFilteredCrcFrequency(id)
		} else {
			set s0 = filter.GetFilteredEntitySpread(id, $$$ENTTYPECONCEPT)
			set f0 = filter.GetFilteredEntityFrequency(id, $$$ENTTYPECONCEPT)
		}
		
		set bayes = s1 / (s1 + s0)
		set ds = ((s1/N1) - (s0/N0)) / ((s1/N1) + (s0/N0))
		set df = ((f1/N1) - (f0/N0)) / ((f1/N1) + (f0/N0))
		
		set D(0) = bayes
		set D(1) = ds
		set D(2) = df
		set D(3) = s1
		set D(4) = f1
		set D(5) = s0
		set D(6) = f0
		
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}
	
	Quit sc
}

ClassMethod GetId(domainId As %Integer, conf As %DeepSee.extensions.iKnow.conf.Config, str As %String, Output id As %Integer, Output isCRC As %Boolean) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim master, r, slave As %String
	
	Try {
		if (conf.models.Count() > 1) {
			if (str["~") {
				set isCRC = 1
			} else {
				set isCRC = 0
			}
		} else {
			if (conf.model.FactType = "crc") {
				set isCRC = 1
			} else {
				set isCRC = 0
			}
		}
		if (isCRC) {
			set master = $p(str,"~",1)
			set r =  $p(str,"~",2)
			set slave =  $p(str,"~",3)
			
			set id = ##class(%iKnow.Queries.CrcAPI).GetId(domainId, master, r, slave)
		} else {
			set id = ##class(%iKnow.Queries.EntityAPI).GetId(domainId, str)
		}
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod openHTML(file As %File, conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	#dim clf As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	
	#dim title, t As %String
	
	Try {
		set title = "Domain "_data.Domain_" Analysis Report"
		set t = clf.TargetValue
		
		set sc = file.WriteLine("<html>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<head>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<title>"_title_"</title>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</head>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<body>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<center><h1>"_title_"</h1></center>")
		Quit:$$$ISERR(sc)
		set title = "The Most Relevant Entities and CRC Patterns to recognize sources where "
		set title = title_model.MDField_ " has value of "_t
		set sc = file.WriteLine("<center><h2>"_title_"</h2></center>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<h3>Tables:</h3>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<ul>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<li><a href = '#Positive Contributions'>Positive Contributions</a></li>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<li><a href = '#Negative Contributions'>Negative Contributions</a></li>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<li><a href = '#ToTable'>Comaprative Influences of Patterns for Discriminanat and Frequency Analysis</a></li>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</ul>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<a href = '#Legend'>Explanation of Table Columns</a>")
		Quit:$$$ISERR(sc)
		
		set sc = ..writeHTMLTableHeader(file, "Positive Contributions", t)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod writeHTMLTopTable(file As %File, ByRef Top) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim Cell
	
	Try {
		set sc = file.WriteLine("<table border = '1' cellspacing = '2' cellpadding = '2'>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<caption><em>Comparative Influences for Discriminant and Frequency Based Approach</em></caption>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<a name = 'TopTable'/>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<tr>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<th></th>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<th>Positive Frequency Influence</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>Negative Frequency Influence</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</tr>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<tr>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<th>Positive Discriminant Influence</th>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<td>")
		Quit:$$$ISERR(sc)
		
		m Cell = Top(1,1)
		set sc = ..writeHTMLTopTableCell(file, .Cell)
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("</td>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<td>")
		Quit:$$$ISERR(sc)
		
		k Cell
		m Cell = Top(-1,1)
		set sc = ..writeHTMLTopTableCell(file, .Cell)
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("</td>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("</tr>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<tr>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<th>Negative Discriminant Influence</th>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<td>")
		Quit:$$$ISERR(sc)
		
		k Cell
		m Cell = Top(1,-1)
		set sc = ..writeHTMLTopTableCell(file, .Cell)
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("</td>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<td>")
		Quit:$$$ISERR(sc)
		
		k Cell
		m Cell = Top(-1,-1)
		set sc = ..writeHTMLTopTableCell(file, .Cell)
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("</td>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("</tr>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("</table>")
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod writeHTMLTopTableCell(file As %File, ByRef Top) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim i, n As %Integer
	
	
	Try {
		set sc = file.WriteLine("<ul>")
		Quit:$$$ISERR(sc)

		set n = Top
		for i = 1:1:n {
			set sc = file.Write("<li>")
			Quit:$$$ISERR(sc)

			set sc = file.Write(Top(i))
			Quit:$$$ISERR(sc)
			
			set sc = file.WriteLine("</li>")
			Quit:$$$ISERR(sc)
		}
		

		set sc = file.WriteLine("</ul>")
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}
	
	Quit sc
}

ClassMethod writeHTMLTableLegend(file As %File, target As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set sc = file.WriteLine("<a name = 'Legend'/>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<h3>Explanation of Table Columns:</h3>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<dl>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<dt>Concept or CRC</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Entity of type Concept or CRC Pattern used in classification. CRC patterns are presented in the form of <em>master~relation~slave</em></dd>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<dt>Contribution</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Contribution of given <em>Entitiy or CRC Pattern</em> in classification formula</dd>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<dt>P("_target_"|Concept)</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Conditional probability of a source having target value "_target_" if it includes given <em>Entitiy or CRC Pattern</em> </em></dd>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<dt>SDiff</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Weighted difference between spreads of the given <em>Entitiy or CRC Pattern</em> in sources with and without value "_target_"</dd>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<dt>FDiff</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Weighted difference between frequencies of the given <em>Entitiy or CRC Pattern</em> in sources with and without value "_target_"</dd>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<dt>Spread("_target_")</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Spread of the given <em>Entitiy or CRC Pattern</em> in sources with the metdata value of "_target_"</dd>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<dt>Spread(Not "_target_")</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Spread of the given <em>Entitiy or CRC Pattern</em> in sources with other metdata values (Not "_target_")</dd>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<dt>Freq("_target_")</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Frequency of the given <em>Entitiy or CRC Pattern</em> in sources with the metdata value of "_target_"</dd>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<dt>Freq(Not "_target_")</dt>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<dd>Frequency of the given <em>Entitiy or CRC Pattern</em> in sources with other metdata values (Not "_target_")</dd>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("</dl>")
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod writeHTMLTableHeader(file As %File, title As %String, target As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set sc = file.WriteLine("<table border = '1' cellspacing = '2' cellpadding = '2'>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<caption><em>"_title_"</em></caption>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<a name = '"_title_"'/>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<tr>")
		Quit:$$$ISERR(sc)

		set sc = file.WriteLine("<th>#</th>")
		Quit:$$$ISERR(sc)
		
		set sc = file.WriteLine("<th>Concept or CRC</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>Contribution</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>P("_target_"|Concept)</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>SDiff</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>FDiff</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>Spread("_target_")</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>Spread(Not "_target_")</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>Freq("_target_")</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<th>Freq(Not "_target_")</th>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</tr>")
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod closeHTML(file As %File) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set sc = file.WriteLine("</body>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</html>")
		Quit:$$$ISERR(sc)

		d file.Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod outputHTML(file As %File, i As %Integer, maxlen As %Integer, keyword As %String, w As %Double, ByRef D) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim idx As %Integer
	
	Try {
		set sc = file.WriteLine("<tr>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<td>"_i_"</td>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<td>"_keyword_"</td>")
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("<td>"_$fn(w,"",2)_"%</td>")
		Quit:$$$ISERR(sc)
		
		for idx = 0:1:2 {
			set sc = file.WriteLine("<td>"_$fn(D(idx),"",2)_"</td>")
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		for idx = 3:1:6 {
			set sc = file.WriteLine("<td>"_D(idx)_"</td>")
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		set sc = file.WriteLine("</tr>")
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

}
