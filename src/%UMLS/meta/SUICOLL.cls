Class %UMLS.meta.SUICOLL Extends %Persistent [ System = 4 ]
{

Parameter UMLSVERSION = "2014AA";

Property NWD As list Of %String(MAXLEN = 100);

Property SUI As %String;

Property LAT As %String;

Index i1 On NWD(ELEMENTS) [ Type = bitmap ];

Index PK On (SUI, LAT) [ PrimaryKey, Unique ];

Index i3 On SUI;

Index iLAT On LAT [ Type = bitmap ];

ClassMethod addLAT(lat As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim table, col, sql1, sql2, sui As %String
	#dim rs As %IResultSet
	#dim result As %SQL.StatementResult
	#dim count As %Integer
	#dim list As %List

	Try {
		set count = 0
		
		set lat = $zcvt(lat,"U")
		set table = $case(lat,"ENG":"MRXNW_ENG","DUT":"MRXW_DUT","GER":"MRXW_GER","POR":"MRXW_POR","RUS":"MRXW_RUS","FRE":"MRXW_FRE",:"")
		if (table = "") {
			set sc = $$$ERROR($$$GeneralError,"Unsupported Language: "_lat)
			Quit
		}
		
		if ($e(table,1,5) = "MRXNW") {
			set col = "NWD"
		} else {
			set col = "WD"
		}
		
		set table = "%UMLS_meta."_table
		
		set stmt1 = ##class(%SQL.Statement).%New()
		set stmt2 = ##class(%SQL.Statement).%New()
		
		set sql1 	= "select SUI, %DLIST("_col_") from "_table_" group by SUI"
		set sql2 	= "insert %NOINDEX into %UMLS_meta.SUICOLL (SUI, LAT, NWD) Values(?, ?, ?)"
		
		w sql1, !
		
		set sc = stmt1.%Prepare(sql1)
		Quit:$$$ISERR(sc)
		
		set sc = stmt2.%Prepare(sql2)
		Quit:$$$ISERR(sc)
		
		set rs = stmt1.%Execute()
		w "Select Executed", !
		
		While (rs.%Next()) {
			set sui = rs.%GetData(1)
			set list = rs.%GetData(2)
			
			set result = stmt2.%Execute(sui, lat, list)
			if (result.%ROWCOUNT '= 1) {
				set ex = ##class(%Exception.SQL).CreateFromSQLCODE(result.%SQLCODE, result.%Message)
				Throw ex
			}
			
			set count = $i(count)
			if ((count#10000) = 0) {
				w "New rorws inserted: "_count, !
			}
		}
		Quit:$$$ISERR(sc)

		w "Total rorws inserted: "_count, !
		
		s sc = ..%BuildIndices()
		Quit:$$$ISERR(sc)
		
		d $system.SQL.TuneTable(table)
		
		w "Indices rebuilt", !
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	if ($$$ISERR(sc)) {
		d $system.OBJ.DisplayError(sc)
	}

	Quit sc
}

Storage Default
{
<Data name="SUICOLLDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NWD</Value>
</Value>
<Value name="3">
<Value>SUI</Value>
</Value>
<Value name="4">
<Value>LAT</Value>
</Value>
</Data>
<DataLocation>^%UMLS.meta.SUICOLLD</DataLocation>
<DefaultData>SUICOLLDefaultData</DefaultData>
<ExtentSize>6220226</ExtentSize>
<IdLocation>^%UMLS.meta.SUICOLLD</IdLocation>
<IndexLocation>^%UMLS.meta.SUICOLLI</IndexLocation>
<Property name="%%CLASSNAME">
<Selectivity>0.0009%</Selectivity>
</Property>
<Property name="%%ID">
<Selectivity>1</Selectivity>
</Property>
<Property name="LAT">
<Selectivity>0.0009%</Selectivity>
</Property>
<Property name="NWD">
<Selectivity>0.0000220293319018153%</Selectivity>
</Property>
<Property name="SUI">
<Selectivity>0.000016076586284807%</Selectivity>
</Property>
<StreamLocation>^%UMLS.meta.SUICOLLS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
