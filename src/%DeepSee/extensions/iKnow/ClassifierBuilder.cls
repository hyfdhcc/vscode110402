Include (%IKPublic, %occInclude)

Class %DeepSee.extensions.iKnow.ClassifierBuilder Extends %RegisteredObject
{

Property FactOutputColumns As %String;

Property CurNullReplacement As %Double;

Property Transformation As %Integer;

Property BlackList As %String;

ClassMethod GetLoadedFieldValues(usageTable As %String, metadataField As %String, Output values) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim n As %Integer
	#dim sql, value As %String

	Try {
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select distinct MDValue from "_usageTable_" where MDKey = ?"
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute(metadataField)
		Quit:$$$ISERR(sc)

		set n = 0
		While(rs1.%Next()) {
			set value = rs1.%GetData(1)
			set n = $i(n)
			set values(n) = value
		}
		d rs1.%Close()
		Quit:$$$ISERR(sc)
		set values = n
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod TokenizeValues(valueString As %String, Output values) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim i, n As %Integer

	Try {
		set n = $l(valueString,",")
		for i=1:1:n {
			set values(i) = $p(valueString,",",i)
		}
		set values = n
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method GetValues(conf As %DeepSee.extensions.iKnow.conf.Config, Output values) As %Status [ Internal ]
{
	#dim sc As %Status = $$$OK
	#dim usageTable As %String
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	
	if (model.Values '= "") {
		set sc = ..TokenizeValues(model.Values, .values)
	} else {
		set usageTable = conf.GetUsageTable()
		set sc = ..GetLoadedFieldValues(usageTable, model.MDField, .values)
	}
	
	Quit sc
}

ClassMethod validateConfig(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim data As %DeepSee.extensions.iKnow.conf.Data 		= conf.data
	#dim model As %DeepSee.extensions.iKnow.conf.Model 		= conf.model
	#dim clf As %DeepSee.extensions.iKnow.conf.Classifier 	= conf.classifier

	#dim nmodels, imodel As %Integer

	Try {
		set sc = data.GetTableNames()
		Quit:$$$ISERR(sc)
		
		set nmodels = conf.models.Count()
		if (model.FactClass = "") {
			set model.FactClass = data.EntityClass_"."_model.FactName
		}
		Quit:$$$ISERR(sc)
		for imodel = 1:1:nmodels {
			set model = conf.models.GetAt(imodel)
			if (model.FactClass = "") {
				set model.FactClass = data.EntityClass_"."_model.FactName
			}
		}
		
		if (clf.ClassifierClass = "") {
			set clf.ClassifierClass = data.Package_".classifiers."_clf.Name
		} 
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method genFactTable(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim inputColumnList As %String
	#dim dataConfig As %DeepSee.extensions.iKnow.conf.Data = conf.data
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	
	#dim i, n As %Integer
	#dim column, tName As %String
	#dim classDef As %Dictionary.ClassDefinition
	#dim columns
	#dim values
	

	Try {
		set sc = ..GetValues(conf, .values)
		Quit:$$$ISERR(sc)
		set n = values
		
		set columns = n*2
		for i=1:1:n {
			set columns((i*2)-1) = "freq"_values(i)
			set columns((i*2))   = "spread"_values(i)
		}		

		if (model.FactClass = "") {
			set model.FactClass = dataConfig.EntityClass_"."_model.FactName
		}
		
		set sc = ..createNewClass(model.FactClass, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "Entity", conf.GetEntityClass())
		Quit:$$$ISERR(sc)
		
		set n = columns
		set inputColumnList = ""
		set ..FactOutputColumns = ""
		for i=1:1:n {
			set column = columns(i)

			set sc = ..addProperty(classDef, column, "%Double")
			Quit:$$$ISERR(sc)

			set sc = ..addProperty(classDef, column_"0rate", "%Double")
			Quit:$$$ISERR(sc)

			if (i > 1) {
				set inputColumnList = inputColumnList_","
			}
			set inputColumnList = inputColumnList_""""_column_""""

			set column = "cz"_i
			set sc = ..addProperty(classDef, column, "%Double")
			Quit:$$$ISERR(sc)
			
			if (i > 1) {
				set ..FactOutputColumns = ..FactOutputColumns_","
			}
			set ..FactOutputColumns = ..FactOutputColumns_column
		}
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "fVar", "%Double")
		Quit:$$$ISERR(sc)
		set sc = ..addProperty(classDef, "sVar", "%Double")
		Quit:$$$ISERR(sc)

		set sc = ..addIndex(classDef, "PKIdx","Entity", 1, 1, 0)
		Quit:$$$ISERR(sc)

		if (model.FactTable '= "") {
			set classDef.SqlTableName = model.FactTable
		}
				
		set sc = ..compile(classDef, .tName)
		Quit:$$$ISERR(sc)

		set model.FactTable = tName	
		if (model.InputColumns = "") {
			set model.InputColumns = inputColumnList
		}	
		
		m model.AllColumns = columns
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method buildFactTable(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim column, sql, id, usageTable As %String
	#dim i, n, count, sourceCount As %Integer
	#dim v, prop, mdkey As %String
	#dim record As %Persistent
	#dim ss1, ss2, sf1, sf2, ctr, f, s, r As %Double
	#dim values, columns

	Try {
		m columns = conf.model.AllColumns
		
		set sc = ..GetValues(conf, .values)
		Quit:$$$ISERR(sc)
		set mdkey = conf.model.MDField
		
		set sql = "select count(%ID) from "_conf.data.SourceTable
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)

		set sc = rs.%Execute()
		Quit:$$$ISERR(sc)

		if (rs.%Next()) {
			set sourceCount = rs.%GetData(1)
			w sourceCount_" records in Source Table "_conf.data.SourceTable, !
		} else {
			set sc = $$$ERROR($$$GeneralError,"No data in table: "_conf.data.SourceTable)
			Quit
		}
		d rs.%Close()
		
		set r = conf.model.NullReplacement
		if (r >= 0) {
			set ..CurNullReplacement = r
		} elseif (conf.model.TransformationType = 1) {
			set ..CurNullReplacement = (-r) * sourceCount
		} elseif (conf.model.TransformationType = 2) {
			set ..CurNullReplacement = (-r) * $zsqr(sourceCount)
		} elseif (conf.model.TransformationType = 4) {
			set ..CurNullReplacement = (-r) * sourceCount * sourceCount
		}
		set ..Transformation = conf.model.TransformationType
		w "Using null replacement: "_..CurNullReplacement, !
		
		set sql = "select %ID from "_conf.data.TermTable
		if (conf.model.EntityRestriction '= "" ) {
			set sql = sql_" where "_conf.model.EntityRestriction
		}
		
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)

		set sc = rs.%Execute()
		Quit:$$$ISERR(sc)
		
		set count = 0
		set n = values

		set usageTable = conf.GetUsageTable()
		set sql = "select FrequencyRate, SpreadRate from "_usageTable
		set sql = sql_" where Term = ? and MDKey = ? and MDValue = ?"
		set rsUsage = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		w sql, !
		set sc = rsUsage.Prepare(sql)
		Quit:$$$ISERR(sc)
		
		While (rs.%Next()) {
			set id = rs.%GetData(1)
			
			set record = $zobjclassmethod(conf.model.FactClass,"%New")
			d $zobjmethod(record,"EntitySetObjectId",id)
			
			set sf1 = 0
			set ss1 = 0
			set sf2 = 0
			set ss2 = 0

			for i=1:1:n {
				set v = values(i)

				set sc = rsUsage.%Execute(id, mdkey, v)
				Quit:$$$ISERR(sc)

				if (rsUsage.%Next()) {
					set f = rsUsage.%GetData(1)
					set s = rsUsage.%GetData(2)
				} else {
					set f = 0
					set s = 0
				}
				d rsUsage.%Close()
				
				
				set prop = columns((i*2) - 1)
				set ctr = ..transformValue(f)
				set $zobjproperty(record,prop) = ctr
				set $zobjproperty(record,prop_"0rate") = f
				set prop = columns((i*2))
				set ctr = ..transformValue(s)
				set $zobjproperty(record,prop) = ctr
				set $zobjproperty(record,prop_"0rate") = s
				
				set ss1 = ss1 + s
				set ss2 = ss2 + (s * s)
				set sf1 = sf1 + f
				set sf2 = sf2 + (f * f)
			}
			
			if (n > 1) {
				set record.fVar = (sf2 - ((sf1 * sf1) / n)) / (n - 1)
				set record.sVar = (ss2 - ((ss1 * ss1) / n)) / (n - 1)
			}
			
			set sc = record.%Save()
			Quit:$$$ISERR(sc)
			
			set count = $i(count)
			if ((count#5000) = 0) {
				w count_" Facts built", !
			}
		}
		
		d rs.%Close()
		w count_" Total Facts built", !
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method transformValue(v As %Double) As %Double
{
	if (..Transformation = 0) {
		Quit v
	} else {
		if ((v = 0) || (v = "")) {
			Quit ..CurNullReplacement
		} elseif (..Transformation = 1) {
			Quit (1/v)
		} elseif (..Transformation = 2) {
			Quit $zsqr(1/v)
		} elseif (..Transformation = 4) {
			Quit $zsqr(1/(v*v))
		}
	}
}

ClassMethod ClassifierPropName(i As %Integer) As %String
{
	#dim name As %String

	set name = $j(i,3)
	set name = $tr(name," ",0)
	Quit "T"_name
}

ClassMethod ClassifierKeyWords(conf As %DeepSee.extensions.iKnow.conf.Config, Output keywords As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	
	#dim i, n As %Integer
	#dim str As %String
	
	Try {
		set keywords = $parameter(classifier.ClassifierClass,"KeyWords")
		set n = conf.models.Count()
		for i=2:1:n {
			set str = $parameter(classifier.ClassifierClass,"KeyWords"_i)
			if (str '= "") {
				set keywords = keywords_","_str
			}
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method mixKeyWords(conf As %DeepSee.extensions.iKnow.conf.Config, classDef As %Dictionary.ClassDefinition, Output dim As %Integer) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	#dim model As %DeepSee.extensions.iKnow.conf.Model
	#dim reftables, table, spec, keyword, keywords, suffix, ldaName, origKeyWords, modelType As %String;
	#dim n, j, i, count, nmodels, imodel, maxDim, modelDim As %Integer
	#dim lda As %DeepSee.extensions.utils.LDA
	#dim g
	#dim w As %Double
	
	#dim V1, V2, X
	
	Try {
		set reftables = classifier.reftables
		set nmodels = $l(reftables, ";")
		
		set dim = 0
		set maxDim = 0
		for imodel = 1:1:nmodels {
			set spec = $p(reftables, ";", imodel)
			set table = $p(spec,":",1)
			set count = $p(spec,":",2)
			if ('$ISVALIDNUM(count)) {
				set sc = $$$ERROR($$$GeneralError,"Invalid ref table spec: """_spec_"""; must be: ""[-]<name>:<count>""")
				Quit
			}
			
			set suffix = ""
			if (imodel > 1) {
				set model = conf.models.GetAt(imodel)
				set suffix = imodel
			}

			set cDef = ##class(%Dictionary.CompiledClass).%OpenId(table)
			set modelDim = $parameter(table,"Dim")
			set modelType = classifier.DimReduction
			if (modelType = "gda") {
				set modelType = "pca"
			} 
			
			set ldaName = cDef.SqlSchemaName_"."_cDef.SqlTableName_"||"_conf.model.MDField_"||"_modelType_":"_modelDim
			set lda = ##class(%DeepSee.extensions.utils.LDA).NameIdxOpen(ldaName, -1, .sc)
			Quit:$$$ISERR(sc)
			
			set sc = lda.getCovector(classifier.TargetValue, .V1)
			Quit:$$$ISERR(sc)
			set g = $o(lda.Groups(classifier.TargetValue))
			if (g = "") {
				set g = $o(lda.Groups(g))
			}
			set sc = lda.getCovector(g, .V2)
			Quit:$$$ISERR(sc)
			
			set origKeyWords = $parameter(table,"KeyWords")
			set n = $parameter(table,"Dim")
			
			for i=1:1:n {
				set w = V1(i) - V2(i)
				set X($zabs(w)) = i
			}
			
			set w = $o(X(""),-1,i)
			if (n < count) {
				set count = n
			}

			set keywords = ""
			for j=1:1:count {
				set keyword = $p(origKeyWords, ",", i)
				if (keywords '= "") {
					set keywords = keywords_","
				}
				set keywords = keywords_keyword
				set w = $o(X(w),-1,i)
			}
		
			set dim = dim + count

			set sc = ..addParameter(classDef, "KeyWords"_suffix, "STRING", keywords)
			Quit:$$$ISERR(sc)

			set sc = ..addParameter(classDef, "Dim"_imodel, "STRING", count)
			Quit:$$$ISERR(sc)

			set sc = ..addParameter(classDef, "Columns"_imodel, "STRING", spec)
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
		set sc = ..addParameter(classDef, "Columns", "STRING", classifier.reftables)
		Quit:$$$ISERR(sc)

		w "Using "_dim_" keywords out of "_maxDim_" possible", !

		set sc = ..addParameter(classDef, "Dim", "INTEGER", dim)
		Quit:$$$ISERR(sc)

		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method genKeyWords(conf As %DeepSee.extensions.iKnow.conf.Config, classDef As %Dictionary.ClassDefinition, Output dim As %Integer) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	#dim model As %DeepSee.extensions.iKnow.conf.Model
	#dim columns, column, sql, component, term, keywords, suffix As %String;
	#dim n, m, l, i, count, nmodels, imodel, maxDim As %Integer
	
	Try {
		set nmodels = conf.models.Count()
		if (nmodels < 1) {
			set nmodels = 1
			set model = conf.model
		} else {
			set model = conf.models.GetAt(1)
		}
		
		set dim = 0
		set maxDim = 0
		for imodel = 1:1:nmodels {
			set sql = ""
			set columns = $p(classifier.columns,";",imodel)
			if (columns = "") {
				Continue
			}
			set suffix = ""
			if (imodel > 1) {
				set model = conf.models.GetAt(imodel)
				set suffix = imodel
			}
			set l = $l(columns,",")
			set n = 0
			for m=1:1:l {
				set column = $p(columns,",",m)
				set component = $p(column,":",1)
				set count = $p(column,":",2)
				if ('$ISVALIDNUM(count)) {
					set sc = $$$ERROR($$$GeneralError,"Invalid columns spec: """_column_"""; must be: ""[-]<name>:<count>""")
					Quit
				}
				set n = n + count
				if ((m > 1)) {
					set sql = sql_" union "
				}
				set sql = sql_"select top "_count_" Entity->Term from "_model.FactTable
				set sql = sql_" where Entity->SpreadRate > "_classifier.SpreadThreshold
				if (..BlackList '= "") {
					set sql = sql_" and Entity->Term not in ("_..BlackList_")"
				}
				set sql = sql_" order by "_component_" desc"
			}
			Quit:$$$ISERR(sc)

			w sql, !
			set maxDim = maxDim + n
		
			set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
			set sc = rs.Prepare(sql)
			Quit:$$$ISERR(sc)

			set sc = rs.%Execute()
			Quit:$$$ISERR(sc)
		
			set keywords = ""
			While (rs.%Next()) {
				set term = rs.%GetData(1)
				set:keywords'="" keywords = keywords_","
				set keywords = keywords_term
			}
			d rs.%Close()
		
			set count = $l(keywords,",")
			set dim = dim + count

			set sc = ..addParameter(classDef, "KeyWords"_suffix, "STRING", keywords)
			Quit:$$$ISERR(sc)

			set sc = ..addParameter(classDef, "Dim"_imodel, "STRING", count)
			Quit:$$$ISERR(sc)

			set sc = ..addParameter(classDef, "Columns"_imodel, "STRING", columns)
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
		set sc = ..addParameter(classDef, "Columns", "STRING", classifier.columns)
		Quit:$$$ISERR(sc)

		w "Using "_dim_" keywords out of "_maxDim_" possible", !

		set sc = ..addParameter(classDef, "Dim", "INTEGER", dim)
		Quit:$$$ISERR(sc)

		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method genTopSpreadKeyWords(conf As %DeepSee.extensions.iKnow.conf.Config, classDef As %Dictionary.ClassDefinition, Output dim As %Integer) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	#dim term, keywords, sql As %String;
	#dim i, count As %Integer
	#dim spread as %Double
	
	Try {
		set dim = classifier.columns
		if ('$ISVALIDNUM(dim)) {
			set sc = $$$ERROR($$$GeneralError,"Invalid columns spec for GDA: """_dim_"""; must be %Integer")
			Quit
		}
		
		set sql = "select top "_dim_" Term, SpreadRate from "_conf.GetEntityTable()
		if (..BlackList '= "") {
			set sql = sql_" and Term not in ("_..BlackList_")"
		}
		set sql = sql_" order by SpreadRate desc"
		w sql, !
		
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)

		set sc = rs.%Execute()
		Quit:$$$ISERR(sc)
		
		set keywords = ""
		set spread = ""
		While (rs.%Next()) {
			set term = rs.%GetData(1)
			set spread = rs.%GetData(2)
			set:keywords'="" keywords = keywords_","
			set keywords = keywords_term
		}
		d rs.%Close()
		
		set count = $l(keywords,",")

		set sc = ..addParameter(classDef, "KeyWords", "STRING", keywords)
		Quit:$$$ISERR(sc)

		set sc = ..addParameter(classDef, "Dim1", "STRING", count)
		Quit:$$$ISERR(sc)

		w "Using "_count_" keywords out of "_dim_" possible. The lowest spread is: "_spread, !
		set dim = count

		set sc = ..addParameter(classDef, "Dim", "INTEGER", dim)
		Quit:$$$ISERR(sc)

		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method genClassifierTable(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	#dim className, tableName As %String;
	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	//#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	
	#dim dim As %Integer
	
	Try {
		if (classifier.ClassifierClass = "") {
			set className = data.Package_".classifiers."_classifier.Name
			set classifier.ClassifierClass = className
		} else {
			set className = classifier.ClassifierClass
		}

		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		if (classifier.DimReduction = "gda") {
			set sc = ..genTopSpreadKeyWords(conf, classDef, .dim)
		} elseif (classifier.reftables = "") {
			set sc = ..genKeyWords(conf, classDef, .dim)
		} else {
			set sc = ..mixKeyWords(conf, classDef, .dim)
		}
		Quit:$$$ISERR(sc)

		set sc = ..genClassifierTableBody(conf, classDef, dim)
		Quit:$$$ISERR(sc)

	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method genClassifierTableBody(conf As %DeepSee.extensions.iKnow.conf.Config, classDef As %Dictionary.ClassDefinition, dim As %Integer) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim tableName As %String;
	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	//#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	
	#dim i As %Integer
	#dim type As %String
	
	Try {

		set sc = ..addXData(classDef, "ClassifierModel", conf)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "Total", "%Integer")
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "Source", data.SourceClass)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "SourceIdx", "Source", 1, 1, 0)
		Quit:$$$ISERR(sc)
		
		if (classifier.CorrespondenceType = "spread") {
			set type = "%Integer"
		} else {
			set type = "%Double"
		}
		for i=1:1:dim {
			set sc = ..addProperty(classDef, ..ClassifierPropName(i), type)
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
		for i=1:1:classifier.MaxPC {
			set sc = ..addProperty(classDef, "cz"_i, "%Double")
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
		if (classifier.ClassifierTable '= "") {
			set classDef.SqlTableName = classifier.ClassifierTable
		}
				
		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)

		//set classifier.ClassifierTable = tableName
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod ldaName(conf As %DeepSee.extensions.iKnow.conf.Config) As %String
{
	#dim  dim As %Integer
	#dim type As %String
	
	set type = conf.classifier.DimReduction
	if (type = "gda") {
		set type = "pca"
	} 
	
	set dim = $parameter(conf.classifier.ClassifierClass,"Dim")
	Quit conf.classifier.ClassifierTable_"||"_conf.model.MDField_"||"_type_":"_dim
}

Method buildClassifierTable(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	#dim column, sql, keywords, source, table, ldaName, existsMtd, entClass As %String;
	#dim termStr, wordList, idList As %String
	#dim termId As %Integer
	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	
	#dim row
	
	#dim n, i, l, m, j, v, pi As %Integer
	#dim count, count1, c1, skipped, excluded, nterms, nmodels, imodel As %Integer
	#dim rs1sql As %String
	#dim useFreq, useContrib As %Boolean
	
	#dim valueList As %String
	
	Try {
		set table = conf.classifier.ClassifierTable
		if (##class(%DeepSee.extensions.components.PCA).%ExistsId(table)) {
			set sc = ##class(%DeepSee.extensions.components.PCA).%DeleteId(table)
			Quit:$$$ISERR(sc)
		}
		
		set ldaName = ##class(ClassifierBuilder).ldaName(conf)
		if (##class(%DeepSee.extensions.utils.LDA).NameIdxExists(ldaName)) {
			set sc = ##class(%DeepSee.extensions.utils.LDA).NameIdxDelete(ldaName)
			Quit:$$$ISERR(sc)
			w "Old LDA Object deleted", !
		}		
		
		set n = $parameter(classifier.ClassifierClass,"Dim")

		set valueList = model.Values
		if ((valueList '= "") && ('(valueList["'"))) {
			set sql = "select o.Source, Count(distinct Term) from "_conf.GetOccurenceTable()_" as o "
			set sql = sql_" join "_data.MDTable_" as md on o.SOurce = md.Source "
			set sql = sql_" where md.MDKey = '"_model.MDField_"' and md.MDValue in ("_valueList_") "
			set sql = sql_" group by o.Source"
		} else {
			set sql = "select Source, Count(distinct Term) from "_conf.GetOccurenceTable()
			set sql = sql_" group by Source"
		}

		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)
		w "Main RS: "_sql, !

		set sc = rs.%Execute()
		Quit:$$$ISERR(sc)
		
		if (classifier.CorrespondenceType = "spread") {
			set rs1sql = "select Count(%ID) from "
			set useFreq = 0
		} elseif (classifier.CorrespondenceType = "contrib") {
			set rs1sql = "select Count(%ID), Term->SpreadRate from "
			set useFreq = 2
		} else {
			set rs1sql = "select NVL(Sum(Freq),0) from "
			set useFreq = 1
		}
		
		set nmodels = conf.models.Count()
		if (nmodels < 1) {
			set nmodels = 1
		} else {
			set conf.model = conf.models.GetAt(1)
		}
		for imodel = 1:1:nmodels {
			if (nmodels > 1) {
				set conf.model = conf.models.GetAt(imodel)
			}
			set sql = rs1sql_conf.GetOccurenceTable()_" where Source = ? and Term = ?"
			set rs(imodel) = ##class(%ResultSet).%New("%DynamicQuery:SQL")
			set sc = rs(imodel).Prepare(sql)
			Quit:$$$ISERR(sc)
			set n(imodel) = $parameter(classifier.ClassifierClass,"Dim"_imodel)
			if (imodel > 1) {
				set wordList = $parameter(classifier.ClassifierClass,"KeyWords"_imodel)
			} else {
				set wordList = $parameter(classifier.ClassifierClass,"KeyWords")
			}
			
			set existsMtd = "TermIdxExists"
			set entClass = conf.GetEntityClass()
			set idList = ""
			set l = $l(wordList,",")
			for i = 1:1:l {
				set termStr = $p(wordList,",",i)
				if ('($classmethod(entClass,existsMtd,termStr,.termId))) {
					set sc = $$$ERROR($$$GeneralError,"Term does not exist: "_termStr)
					Quit
				}
				set idList = idList_$lb(termId)
			}
			Quit:$$$ISERR(sc)
			
			set keywords(imodel) = idList
			
			w "Model# "_imodel_": SQL = """_sql_"""", !
		}
		Quit:$$$ISERR(sc)

		set count1 = 0
		While (rs.%Next()) {
			set source = rs.%GetData(1)
			set nterms = rs.%GetData(2)
			if (nterms < classifier.MinSourceLength) {
				set excluded = $i(excluded)
				if ((excluded#1000) = 0) {
					w count_" Records excluded: "_excluded, !
				}
				Continue
			}
			
			set row = $classmethod(classifier.ClassifierClass,"%New")
			d row.SourceSetObjectId(source)
			
			set c1 = 0
			set pi = 0
			for imodel = 1:1:nmodels {
				for i=1:1:n(imodel) {
					set pi = $i(pi)
					set termId = $li(keywords(imodel),i)
				
					set v = 0
					//w "SQL Exec: "_source, ", ", term, ! 
					set sc = rs(imodel).%Execute(source, termId)	
					if (rs(imodel).%Next()) {
						set v = rs(imodel).%GetData(1)
						if (useFreq = 1) {
							set v = v / ( v + 1)
						} elseif ((useFreq = 2) && (v > 0)) {
							#dim fk = rs(imodel).%GetData(2)
							set v = v / $zsqr(fk)
						}
					}		
					d rs(imodel).%Close()
				
					set column = ..ClassifierPropName(pi)
					set $zobjproperty(row,column) = v
					set:v>0 count1 = $i(count1)
					set:v>0 c1 = $i(c1)
				}
			}

			if (c1 > 0) {
				set row.Total = c1
			
				set sc = row.%Save()	
				Quit:$$$ISERR(sc)
			
				set count = $i(count)
				if ((count#100) = 0) {
					w count_" Records Saved. Number of ones: "_count1, !
				}
			} else {
				set skipped = $i(skipped)
			}
		}
		d rs.%Close()
		Quit:$$$ISERR(sc)

		W "Total: "_count_" Records Saved. "
		w " Sources excluded: "_excluded
		w ". Sources skipped: "_skipped
		w ". Number of ones: "_count1, !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method genDistanceTable(conf As %DeepSee.extensions.iKnow.conf.Config, Output className As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	#dim classifierClass, distanceClass As %String;
	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	
	Try {
		set classifierClass = classifier.ClassifierClass
		set distanceClass = classifierClass_"Distance"

		set sc = ..createNewClass(distanceClass, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addParameter(classDef, "CLASSIFIER", "STRING", classifierClass)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "Col1", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Term1", "%String")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Col2", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Term2", "%String")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Distance", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "ColIdx", "Col1,Col2", 1, 1, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "TermIdx", "Term1,Term2", 1, 0, 0)
		Quit:$$$ISERR(sc)

		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
		
		set className = distanceClass
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method buildDistanceTable(conf As %DeepSee.extensions.iKnow.conf.Config, className As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier

	#dim dim, i, j, nk1, nk2, nk12, N, count As %Integer
	#dim keywords, sql, c1, c2, t1, t2 As %String
	#dim classifierClass, classifierTable As %String
	#dim d As %Double
	
	#dim aggr

	Try {
		set classifierClass = classifier.ClassifierClass
		set classifierTable = classifier.ClassifierTable
		set dim = $parameter(classifierClass, "Dim")
		set keywords = $parameter(classifierClass, "KeyWords")

		set sc = ..aggreagte("select count(%ID) from "_classifierTable, .N)
		QUit:$$$ISERR(sc)
		
		set count = 0
		set count(0) = 1000
		for i=1:1:dim {
			set t1 = $p(keywords, ",", i)
			set c1 = ..ClassifierPropName(i)

			set sc = ..saveDistanceObject(className, i, i, t1, t1, 0)
			Quit:$$$ISERR(sc)
	
			set count = $i(count)
	
			for j = 1:1:(i-1) {
				set t2 = $p(keywords, ",", j)
		
				set c2 = ..ClassifierPropName(j)
				set sql = "select sum("_c1_"), sum("_c2_"), sum("_c1_"*"_c2_") "
				set sql = sql_" from "_classifierTable
				
				set sc = ..aggreagte(sql, .aggr)
				Quit:$$$ISERR(sc)

				set nk1  = aggr(1)
				set nk2  = aggr(2)
				set nk12 = aggr(3)

				set d = nk1 + nk2 - (2 * nk12)
				set d = d / nk1 / nk2
				set d = d * N
				set d = $zsqr(d)
				
				set sc = ..saveDistanceObject(className, i, j, t1, t2, d)
				Quit:$$$ISERR(sc)
				
				set sc = ..saveDistanceObject(className, j, i, t2, t1, d)
				Quit:$$$ISERR(sc)
				
				set count = count + 2
				
				if (count > count(0)) {
					w "Distance pairs stored: "_count, !
					set count(0) = count(0) + 1000
				}
			}
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)

	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method createDistanceTable(conf As %DeepSee.extensions.iKnow.conf.Config, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim className As %String
	
	Try {
		set sc = ..genDistanceTable(conf, .className, .tableName)
		Quit:$$$ISERR(sc)
		
		set sc = ..buildDistanceTable(conf, className)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod aggreagte(sql As %String, Output D) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim i, n As %Integer
	
	Try {
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)

		set sc = rs.%Execute()
		Quit:$$$ISERR(sc)

		if (rs.%Next() = 0) {
			set sc = $$$ERROR($$$GeneralError,"No Aggregate Data")
			Quit
		}
		
		set n = rs.GetColumnCount()
		if (n > 1) {
			for i = 1:1:n {
				set D(i) = rs.%GetData(i)
			}
		} else {
			set D = rs.%GetData(1)
		}
		
		d rs.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod saveDistanceObject(className As %String, i As %Integer, j As %Integer, t1 As %String, t2 As %String, d As %Double) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim row As %Persistent

	Try {
		set row = $classmethod(className, "%New")
		set row.Col1 = i
		set row.Col2 = j
				
		set row.Term1 = t1
		set row.Term2 = t2
		
		set row.Distance = d

		set sc = row.%Save()
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method Optimize(conf As %DeepSee.extensions.iKnow.conf.Config, N As %Integer = 150) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim optimizer As ClassifierOptimizer

	Try {
		set optimizer = ##class(ClassifierOptimizer).create($this)
		if (conf.classifier.DimReduction = "none") {
			set optimizer.DirectLDA = 1
		} else {
			set optimizer.DirectLDA = 0
		}
		
		w "Optimizing CZ1", !
		set sc = optimizer.OptimizeCZ1(conf, N)
		Quit:$$$ISERR(sc)
		
		w "Optimizing individual terms", !
		set sc = optimizer.optimizeTerms(conf)
		Quit:$$$ISERR(sc)
		
		set sc = ..buildAndAnalyze(conf)
		Quit:$$$ISERR(sc)
				
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method buildAndAnalyze(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set sc = ..genClassifierTable(conf)
		Quit:$$$ISERR(sc)
			
		set sc = ..buildClassifierTable(conf)
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierAnalysis).doAnalysis(conf)
		Quit:$$$ISERR(sc)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod genSourceTable(className As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	Try {
		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "SourceId", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "ExternalId", "%String")
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "DocIdx", "SourceId", 1, 1, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "DocIdx2", "ExternalId", 1, 0, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod genTermTable(className As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	Try {
		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "EntityId", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Term", "%String", 4096, "EXACT")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Frequency", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Spread", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "FrequencyRate", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "SpreadRate", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "EntityIdx", "EntityId", 1, 1, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "TermIdx", "Term", 1, 0, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod genCrcTable(className As %String, entityName As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	Try {
		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "CrcId", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Term", "%String", 4096, "EXACT")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Master", entityName)
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Slave", entityName)
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Relation", "%String", 128, "EXACT")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Frequency", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Spread", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "FrequencyRate", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "SpreadRate", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "CrcIdx", "CrcId", 1, 1, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "TermIdx", "Term", 1, 0, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "MasterIdx", "Master", 0, 0, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "SlaveIdx", "Slave", 0, 0, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "RelationIdx", "Relation", 0, 0, 0)
		Quit:$$$ISERR(sc)
		
		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod genOccurrenceTable(className As %String, termClass As %String, sourceClass As %String, sourcePropName, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	Try {
		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "Freq", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = classDef.%Save()
		Quit:$$$ISERR(sc)
		
		set sc = ..relate(termClass, className, "Occurrence", "Term", 1)
		Quit:$$$ISERR(sc)
		
		set sc = ..relate(sourceClass, className, sourcePropName, "Source", 1)
		Quit:$$$ISERR(sc)
		
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod genMDTable(className As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	Try {
		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "MDKey", "%String")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "MDValue", "%String", 2048)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "KeyIdx", "MDKey", 0, 0, 1)
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "ValueIdx", "MDValue", 0, 0, 1)
		Quit:$$$ISERR(sc)
		
		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod genUsageTable(className As %String, termClass As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	Try {
		set sc = ..createNewClass(className, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ..addProperty(classDef, "MDKey", "%String")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "MDValue", "%String")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Frequency", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "Spread", "%Integer")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "FrequencyRate", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addProperty(classDef, "SpreadRate", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ..addIndex(classDef, "MDIdx", "MDKey,MDValue", 0, 0, 1)
		Quit:$$$ISERR(sc)
		
		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
		
		set sc = ..relate(termClass, className, "Usages", "Term", 0)
		Quit:$$$ISERR(sc)

		set classDef = ##class(%Dictionary.ClassDefinition).%OpenId(className)
		set sc = ..addIndex(classDef, "TermIdx", "Term,MDKey,MDValue", 1, 1, 0)
		Quit:$$$ISERR(sc)

		set sc = ..compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod createNewClass(className As %String, Output classDef As %Dictionary.ClassDefinition) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		if (##class(%Dictionary.ClassDefinition).%ExistsId(className)) {
			if (##class(%Dictionary.CompiledClass).%ExistsId(className)) {
				set sc = $zobjclassmethod(className,"%KillExtent")
				Quit:$$$ISERR(sc)
			}
			set sc = $system.OBJ.Delete(className)
			Quit:$$$ISERR(sc)
			w !
		}

		set classDef = ##class(%Dictionary.ClassDefinition).%New()
		set classDef.Name = className
		set classDef.Super = "%Persistent"

	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod relate(parent As %String, child As %String, pProp As %String, cProp As %String, idx As %Boolean) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim name As %String
	#dim l As %Integer

	Try {
		set pDef = ##class(%Dictionary.ClassDefinition).%OpenId(parent)
		set cDef = ##class(%Dictionary.ClassDefinition).%OpenId(child)
		
		set propDef = ##class(%Dictionary.PropertyDefinition).%New()
		set propDef.parent = pDef
		set propDef.Name = pProp
		set propDef.Type = child
		set propDef.Relationship = 1
		set propDef.Cardinality = "many"
		set propDef.Inverse = cProp
		
		set sc = propDef.%Save()
		Quit:$$$ISERR(sc)
		
		set propDef = ##class(%Dictionary.PropertyDefinition).%New()
		set propDef.parent = cDef
		set propDef.Name = cProp
		set propDef.Type = parent
		set propDef.Relationship = 1
		set propDef.Cardinality = "one"
		set propDef.Inverse = pProp
		
		set sc = propDef.%Save()
		Quit:$$$ISERR(sc)

		if (idx) {
			set name = parent
			if (name[".") {
				set l = $l(name,".")
				set name = $p(name,".",l)
			}
			set sc = ..addIndex(cDef, name_"Idx", cProp)
			Quit:$$$ISERR(sc)
		}

		set sc = $system.OBJ.Compile(parent_","_child)
		Quit:$$$ISERR(sc)
	}Catch(ex){
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod addProperty(classDef As %Dictionary.ClassDefinition, name As %String, type As %String, maxlen As %Integer = 0, collation As %String = "") As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set propDef = ##class(%Dictionary.PropertyDefinition).%New()
		set propDef.parent = classDef
		set propDef.Name = name
		set propDef.Type = type
		
		if (maxlen > 0) {
			d propDef.Parameters.SetAt(maxlen,"MAXLEN")
		}
		if (collation '= "") {
			d propDef.Parameters.SetAt(collation,"COLLATION")
		}
			
		set sc = propDef.%Save()
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod addXData(classDef As %Dictionary.ClassDefinition, name As %String, content As %XML.Adaptor) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim stream As %Stream.TmpCharacter

	Try {
		set xData = ##class(%Dictionary.XDataDefinition).%New()
		set xData.parent = classDef
		set xData.Name = name
		
		set stream = xData.Data
		set sc = content.XMLExportToStream(.stream)
		Quit:$$$ISERR(sc)	
		
		set sc = xData.%Save()
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod addParameter(classDef As %Dictionary.ClassDefinition, name As %String, type As %String, value As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set propDef = ##class(%Dictionary.ParameterDefinition).%New()
		set propDef.parent = classDef
		set propDef.Name = name
		set propDef.Type = type
		set propDef.Default = value
			
		set sc = propDef.%Save()
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod addIndex(classDef As %Dictionary.ClassDefinition, name As %String, properties As %String, isUnique As %Boolean = 0, isPK As %Boolean = 0, isBitmap As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		set indexDef = ##class(%Dictionary.IndexDefinition).%New()
		set indexDef.Name = name
		set indexDef.PrimaryKey = isPK
		set indexDef.Unique = isUnique
		if (isBitmap) {
			set indexDef.Type = "bitmap"
		}
		set indexDef.Properties = properties
		set indexDef.parent = classDef
		
		set sc = indexDef.%Save()
		Quit:$$$ISERR(sc)
			
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod compile(classDef As %Dictionary.ClassDefinition, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set sc = classDef.%Save()
		Quit:$$$ISERR(sc)

		set sc = $system.OBJ.Compile(classDef.Name)
		Quit:$$$ISERR(sc)
		
		set cDef = ##class(%Dictionary.CompiledClass).%OpenId(classDef.Name)
		set tableName = cDef.SqlSchemaName_"."_cDef.SqlTableName
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method buildDataStructure(config As %DeepSee.extensions.iKnow.conf.Data) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim tName As %String
	
	Try {
		set sc = ..genSourceTable(config.SourceClass, .tName)
		Quit:$$$ISERR(sc)
		set config.SourceTable = tName
		
		set sc = ..genTermTable(config.EntityClass, .tName)
		Quit:$$$ISERR(sc)
		set config.TermTable = tName
		
		set sc = ..genCrcTable(config.CrcClass, .tName)
		Quit:$$$ISERR(sc)
		set config.CrcTable = tName
		
		set sc = ..genMDTable(config.MDClass, .tName)
		Quit:$$$ISERR(sc)
		set config.MDTable = tName
		
		set sc = ..relate(config.SourceClass, config.MDClass, "Metadata", "Source", 0)
		Quit:$$$ISERR(sc)
		
		set cDef = ##class(%Dictionary.ClassDefinition).%OpenId(config.MDClass)
		set sc = ..addIndex(cDef, "PKIdx", "Source,MDKey", 1, 1, 0)
		Quit:$$$ISERR(sc)
		
		set sc = $system.OBJ.Compile(config.MDClass)
		Quit:$$$ISERR(sc)
		
		set sc = ..genOccurrenceTable(config.OccurenceClass, config.EntityClass, config.SourceClass, "Occurrence", .tName)
		Quit:$$$ISERR(sc)
		set config.OccurenceTable = tName

		set sc = ..genOccurrenceTable(config.CrcOccurenceClass, config.CrcClass, config.SourceClass, "CrcOccurrence", .tName)
		Quit:$$$ISERR(sc)
		set config.CrcOccurenceTable = tName

		set sc = ..genUsageTable(config.UsageClass, config.EntityClass, .tName)
		Quit:$$$ISERR(sc)
		set config.UsageTable = tName

		set sc = ..genUsageTable(config.CrcUsageClass, config.CrcClass, .tName)
		Quit:$$$ISERR(sc)
		set config.CrcUsageTable = tName
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method cleanup(config As %DeepSee.extensions.iKnow.conf.Data) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	Try {
		set sc = $zobjclassmethod(config.UsageClass,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set sc = $zobjclassmethod(config.CrcUsageClass,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set sc = $zobjclassmethod(config.OccurenceClass,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set sc = $zobjclassmethod(config.MDClass,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set sc = $zobjclassmethod(config.EntityClass,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set sc = $zobjclassmethod(config.SourceClass,"%KillExtent")
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod cleanupField(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim sql As %String
	#dim metadataField As %String
	
	Try {
		set metadataField = conf.model.MDField
		
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "delete from "_conf.GetUsageTable()_" where MDKey = ?"
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute(metadataField)
		Quit:$$$ISERR(sc)
		w "Deleted : "_rs1.%ROWCOUNT_" records from "_conf.GetUsageTable(), !
		d rs1.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	do:$$$ISERR(sc) $system.OBJ.DisplayError(sc)
	
	Quit sc
}

ClassMethod loadSources(config As %DeepSee.extensions.iKnow.conf.Data) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim count, domainId As %Integer
	#dim mdKey, mdValue, sql As %String
	
	#dim document, mdRecord
	
	Try {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(config.Domain)
		w config.Domain_" = "_domainId, !
		
		set rs = ##class(%ResultSet).%New("%iKnow.Queries.SourceQAPI:GetByDomain")
		set sc = rs.%Execute(domainId, 1, 0)
		Quit:$$$ISERR(sc)
		
		set count = 0
		While(rs.%Next()) {
			set document = $zobjclassmethod(config.SourceClass, "%New")
			set document.SourceId = rs.%GetData(1)
			set document.ExternalId = rs.%GetData(2)
			set count = $i(count)
			
			set sc = document.%Save()
			Quit:$$$ISERR(sc)
		}

		d rs.%Close()
		
		w "Saved "_count_" sources.", !
		
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select %ID, SourceId from "_config.SourceTable
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute()
		Quit:$$$ISERR(sc)

		set count = 0
		While (rs1.%Next()) {
			#dim id, srcId As %String
			set id = rs1.%GetData(1)
			set srcId = rs1.%GetData(2)
			
			set rs = ##class(%ResultSet).%New("%iKnow.Queries.MetadataQAPI:GetValuesById")
			set sc = rs.%Execute(domainId, srcId)
			Quit:$$$ISERR(sc)
			
			set document = $zobjclassmethod(config.SourceClass, "%OpenId", id)
			
			While (rs.%Next()) {
				set mdKey   = rs.%GetData(2)
				set mdValue = rs.%GetData(3)
				
				set mdRecord = $zobjclassmethod(config.MDClass, "%New")
				set mdRecord.Source  = document
				set mdRecord.MDKey   = mdKey
				set mdRecord.MDValue = mdValue
				
				set sc = mdRecord.%Save()
				if ($$$ISERR(sc)) {
					w "Error saving Metadata: "_mdKey_"/"_mdValue, !
					Quit
				}
				set count = $i(count)
				if ((count#10000) = 0) {
					w "Saved "_count_" Metadata records", !
				}
			}
			d rs.%Close()
			Quit:$$$ISERR(sc)
		
			set sc = document.%Save()
			Quit:$$$ISERR(sc)
	
		}
		d rs1.%Close()
		
		w "Saved "_count_" Metadata records", !
		
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}
	
	Quit sc
}

ClassMethod loadTerms(config As %DeepSee.extensions.iKnow.conf.Data, verbose As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim errorCount As %Integer = 0
	
	#dim term, sql As %String
	#dim termRecord As Term
	#dim count, SourceCount As %Integer
	#dim entityId, domainId As %Integer
	#dim f,s As %Integer
	#dim minSpread As %Double
	
	set count = 0
	Try {
		set sc = $classmethod(config.EntityClass,"%KillExtent")
		Quit:$$$ISERR(sc)
		
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(config.Domain)
		
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select count(%ID) from "_config.SourceTable
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute()
		Quit:$$$ISERR(sc)
		
		if (rs1.%Next()) {
			set SourceCount = rs1.%GetData(1)
		} else {
			set SourceCount = 0
		}
		d rs1.%Close()
		if (SourceCount = 0) {
			set sc = $$$ERROR($$$GeneralError,"No Sources are loaded.")
		}
		Quit:$$$ISERR(sc)
		
		set rs = ##class(%ResultSet).%New("%iKnow.Queries.EntityQAPI:GetTop")
		set minSpread = config.MinSpread
		if ((minSpread '= "") && (minSpread > 0)) {
			set sc = rs.%Execute(domainId, 1, 0,,,$$$SORTBYSPREAD)
		} else {
			set sc = rs.%Execute(domainId, 1, 0)
		}
		Quit:$$$ISERR(sc)
		
		w "Query Executed", !
		
		While(rs.%Next()) {
			set entityId = rs.%GetData(1)
			set term = rs.%GetData(2)
			set f = rs.%GetData(3)
			set s = rs.%GetData(4)
			
			set termRecord = $zobjclassmethod(config.EntityClass, "%New")
			set termRecord.Term = term
			set termRecord.EntityId = entityId
			set termRecord.Frequency = f
			set termRecord.FrequencyRate = f / SourceCount
			set termRecord.Spread = s
			set termRecord.SpreadRate = s / SourceCount

			if ((minSpread '= "") && (minSpread > 0)) {
				if (termRecord.SpreadRate < minSpread) {
					w "Min Spread reached: "_minSpread, !
					Quit
				}
			}
			
			set count = $i(count)

			set sc = termRecord.%Save()
			if ($$$ISERR(sc)) {
				if ($system.Status.GetErrorCodes(sc) = "5808") {
					w "Term not unique: """_term_""""_"; ID = "_entityId, !
				} else {
					w "Error saving entity with id = "_entityId, !
					w term, !
				}
				if ((config.Sloppy) && (f = 1)) {
					set errorCount = $i(errorCount)
					d $system.OBJ.DisplayError(sc)
					set sc = $$$OK
					w "Entity skipped", !
				} else {
					Quit
				}
			}

			if ((count#10000)=0) {
				w "Saved "_count_" Entities. Spread = "_termRecord.SpreadRate, !
			}
		}
		
		d rs.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}
	
	w "Saved: "_count_" Entities.", !
	if (errorCount > 0) {
		w "Skipped "_errorCount_" entities because of errors", !
	}
	
	Quit sc
}

ClassMethod loadCrcs(config As %DeepSee.extensions.iKnow.conf.Data, verbose As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim errorCount As %Integer = 0
	#dim warningCount As %Integer = 0
	
	#dim term, sql, master, r, slave As %String
	#dim termRecord As Term
	#dim count, SourceCount As %Integer
	#dim entityId, domainId, masterId, slaveId As %Integer
	#dim f,s As %Integer
	#dim minSpread As %Double
	#dim sloppy As %Boolean
	
	set count = 0
	Try {
		set sloppy = config.Sloppy
		
		set sc = $classmethod(config.CrcClass,"%KillExtent")
		Quit:$$$ISERR(sc)

		set domainId = ##class(%iKnow.Domain).GetOrCreateId(config.Domain)
		
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select count(%ID) from "_config.SourceTable
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute()
		Quit:$$$ISERR(sc)
		
		if (rs1.%Next()) {
			set SourceCount = rs1.%GetData(1)
		} else {
			set SourceCount = 0
		}
		d rs1.%Close()
		if (SourceCount = 0) {
			set sc = $$$ERROR($$$GeneralError,"No Sources are loaded.")
		}
		Quit:$$$ISERR(sc)
		
		set rs = ##class(%ResultSet).%New("%iKnow.Queries.CrcQAPI:GetTop")
		set minSpread = config.MinSpread
		if ((minSpread '= "") && (minSpread > 0)) {
			set sc = rs.%Execute(domainId, 1, 0,,,$$$SORTBYSPREAD)
		} else {
			set sc = rs.%Execute(domainId, 1, 0)
		}
		Quit:$$$ISERR(sc)
		
		set rsE = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select EntityId from "_config.TermTable_" where Term = ?"
		set sc = rsE.Prepare(sql)
		Quit:$$$ISERR(sc)
		
		w "Query Executed", !
		
		While(rs.%Next()) {
			set entityId = rs.%GetData(1)
			set master = rs.%GetData(2)
			set r = rs.%GetData(3)
			set slave = rs.%GetData(4)
			set term = master_"~"_r_"~"_slave
			set f = rs.%GetData(5)
			set s = rs.%GetData(6)
			
			if (master '= "") {
				set sc = rsE.Execute(master)
				Quit:$$$ISERR(sc)
				if (rsE.%Next()) {
					set masterId = rsE.%GetData(1)
				} else {
					set sc = $$$ERROR($$$GeneralError,"For CRC """_term_"""[ID="_entityId_"] Master ["_master_"] is not found")
					//Quit
					//d $system.OBJ.DisplayError(sc)
					set sc = $$$OK
					set warningCount = $i(warningCount)
				}
			} else {
				set masterId = ""
			}
			
			if (slave '= "") {
				set sc = rsE.Execute(slave)
				Quit:$$$ISERR(sc)
				if (rsE.%Next()) {
					set slaveId = rsE.%GetData(1)
				} else {
					set sc = $$$ERROR($$$GeneralError,"For CRC """_term_"""[ID="_entityId_"] Slave ["_slave_"] is not found")
					//Quit
					//d $system.OBJ.DisplayError(sc)
					set sc = $$$OK
					set warningCount = $i(warningCount)
				}
			} else {
				set slaveId = ""
			}
			
			set termRecord = $zobjclassmethod(config.CrcClass, "%New")
			set termRecord.Term = term
			d termRecord.MasterSetObjectId(masterId)
			d termRecord.SlaveSetObjectId(slaveId)
			set termRecord.Relation = r
			set termRecord.CrcId = entityId
			set termRecord.Frequency = f
			set termRecord.FrequencyRate = f / SourceCount
			set termRecord.Spread = s
			set termRecord.SpreadRate = s / SourceCount

			if ((minSpread '= "") && (minSpread > 0)) {
				if (termRecord.SpreadRate < minSpread) {
					w "Min Spread reached: "_minSpread, !
					Quit
				}
			}

			set count = $i(count)
			set sc = termRecord.%Save()
			if ($$$ISERR(sc)) {
				if ($system.Status.GetErrorCodes(sc) = "5808") {
					w "Term not unique: """_term_""""_"; ID = "_entityId, !
				} else {
					w "Error saving entity with id = "_entityId, !
					w term, !
				}
				if ((sloppy) && (f = 1)) {
					set errorCount = $i(errorCount)
					d $system.OBJ.DisplayError(sc)
					set sc = $$$OK
					w "Entity skipped", !
				} else {
					Quit
				}
			}

			if ((count#10000)=0) {
				w "Saved "_count_" CRCs.. Spread = "_termRecord.SpreadRate, !
			}
		}
		
		d rs.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}
	
	w "Saved: "_count_" CRCs.", !
	if (errorCount > 0) {
		w "Skipped "_errorCount_" CRCs because of errors", !
	}
	if (warningCount > 0) {
		w "Detected "_warningCount_" warnings.", !
	}
	
	Quit sc
}

ClassMethod setOccurrences(config As %DeepSee.extensions.iKnow.conf.Data) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim count, count1, spread, freq, entityId As %Integer
	#dim term, domainId, sql, id, srcId, master, r, slave As %String
	#dim termRecord, occurrence 
	#dim sloppy As %Boolean
	
	#dim exists As %Boolean
	
	Try {
		set sloppy = config.Sloppy
		if ((config.MinSpread '= "") && (config.MinSpread > 0)) {
			set sloppy = 1
		}

		set domainId = ##class(%iKnow.Domain).GetOrCreateId(config.Domain)
		
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select %ID, SourceId from "_config.SourceTable
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute()
		Quit:$$$ISERR(sc)

		set count = 0
		set count1 = 0
		While (rs1.%Next()) {
			set id = rs1.%GetData(1)
			set srcId = rs1.%GetData(2)
			
			set rs = ##class(%ResultSet).%New("%iKnow.Queries.EntityQAPI:GetBySource")
			set sc = rs.%Execute(domainId, srcId,1,0,$$$ENTTYPECONCEPT)
			Quit:$$$ISERR(sc)
			
			set count = $i(count)
			While (rs.%Next()) {
				set entityId = rs.%GetData(1)
				set term = rs.%GetData(2)
				if ($l(term) < 3) {
					Continue
				}
			
				if (sloppy) {
					set exists = $zobjclassmethod(config.EntityClass,"EntityIdxExists", entityId)
					if ('exists) {
						Continue
					}
				}
				set termRecord = $zobjclassmethod(config.EntityClass,"EntityIdxOpen",entityId, -1, .sc)  //..EntityIdxOpen(entityId,-1,.sc)
				Quit:$$$ISERR(sc)
			
				set count1 = $i(count1)
				set freq = rs.%GetData(3)
				set spread = rs.%GetData(4)

				if (termRecord.Term '= term) {
					set sc = $$$ERROR($$$GeneralError, "Inconsistent data for entity: id = "_entityId_"; term = "_term_" ? "_termRecord.Term)
					Quit
				}
				if (spread '= 1) {
					set sc = $$$ERROR($$$GeneralError, "Inconsistent data for entity: id = "_entityId_"; source = "_srcId_": spread = "_spread)
					Quit
				}
			
				set occurrence = $zobjclassmethod(config.OccurenceClass, "%New")
				d occurrence.SourceSetObjectId(id)
				set occurrence.Term = termRecord
				set occurrence.Freq = freq
			
				set sc = occurrence.%Save()
				Quit:$$$ISERR(sc)
			}
			Quit:$$$ISERR(sc)
			
			set rs = ##class(%ResultSet).%New("%iKnow.Queries.CrcQAPI:GetBySource")
			set sc = rs.%Execute(domainId, srcId,1,0)
			Quit:$$$ISERR(sc)
			
			While (rs.%Next()) {
				set entityId = rs.%GetData(1)
				set master = rs.%GetData(2)
				set r = rs.%GetData(3)
				set slave = rs.%GetData(4)
				set term = master_"~"_r_"~"_slave
				if ($l(term) < 3) {
					Continue
				}
			
				if (sloppy) {
					set exists = $zobjclassmethod(config.CrcClass,"CrcIdxExists", entityId)
					if ('exists) {
						Continue
					}
				}
				set termRecord = $zobjclassmethod(config.CrcClass,"CrcIdxOpen",entityId, -1, .sc)  //..EntityIdxOpen(entityId,-1,.sc)
				Quit:$$$ISERR(sc)
			
				set count1 = $i(count1)
				set freq = rs.%GetData(5)
				set spread = rs.%GetData(6)

				if (termRecord.Term '= term) {
					set sc = $$$ERROR($$$GeneralError, "Inconsistent data for CRC id = "_entityId_"; pattern = "_term_" ? "_termRecord.Term)
					Quit
				}
				if (spread '= 1) {
					set sc = $$$ERROR($$$GeneralError, "Inconsistent data for CRC id = "_entityId_"; source = "_srcId_": spread = "_spread)
					Quit
				}
			
				set occurrence = $zobjclassmethod(config.CrcOccurenceClass, "%New")
				d occurrence.SourceSetObjectId(id)
				set occurrence.Term = termRecord
				set occurrence.Freq = freq
			
				set sc = occurrence.%Save()
				Quit:$$$ISERR(sc)
			}
			Quit:$$$ISERR(sc)

			if ((count#100)=0) {
				w "Updated "_count_" sources, created "_count1_" occurences.", !
			}
		} 
		d rs1.%Close()
		Quit:$$$ISERR(sc)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}

	Quit sc
}

ClassMethod updateRates(conf As %DeepSee.extensions.iKnow.conf.Config, metadataValue As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim SourceCount As %Integer
	#dim sql, op, mdValue As %String
	#dim usageTable, metadataField As %String
	
	Try {
		set metadataField = conf.model.MDField
		set op = $e(metadataValue)
		if ((op = "!") || (op = "'")) {
			set op = "<>"
			set mdValue = $e(metadataValue,2,*)
		} else {
			set op = "="
			set mdValue = metadataValue
		}

		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "select count(%ID) from "_conf.data.MDTable_" where MDKey = ? and MDValue "_op_" ?"
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute(metadataField, mdValue)
		Quit:$$$ISERR(sc)
		
		if (rs1.%Next()) {
			set SourceCount = rs1.%GetData(1)
		} else {
			set SourceCount = 0
		}
		d rs1.%Close()
		if (SourceCount = 0) {
			set sc = $$$ERROR($$$GeneralError,"No Sources with given metadata exist: "_metadataField_":"_metadataValue)
		}
		Quit:$$$ISERR(sc)

		w SourceCount, !
	
		set usageTable = conf.GetUsageTable()
	
		set rs1 = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sql = "update "_usageTable_" set FrequencyRate = Frequency / ?, SpreadRate = Spread / ? "
		set sql = sql_" where MDKey = ? and MDValue = ?"
		set sc = rs1.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs1.Execute(SourceCount, SourceCount, metadataField, metadataValue)
		Quit:$$$ISERR(sc)
		
		w "Updated rates: "_rs1.%ROWCOUNT, !
		d rs1.%Close()
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod load1Value(conf As %DeepSee.extensions.iKnow.conf.Config, metadataValue As %String, verbose As %Boolean = 0) As %Status
{
	Quit ..load1ValueSQL(conf,metadataValue,verbose)
}

ClassMethod load1ValueIK(conf As %DeepSee.extensions.iKnow.conf.Config, metadataValue As %String, verbose As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim domainId, op, mdValue As %String
	#dim term, master, slave, r As %String
	#dim termRecord, usage 
	#dim list As %List
	#dim freq, spread, count As %Integer
	#dim entityId As %Integer
	#dim metadataField, query As %String
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	#dim config As %DeepSee.extensions.iKnow.conf.Data = conf.data
		
	set count = 0
	Try {
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(config.Domain)
		set metadataField = model.MDField

		set query = conf.GetQAPI()_":GetByFilter"
		set rs = ##class(%ResultSet).%New(query)
		set op = $e(metadataValue)
		if ((op = "!") || (op = "'")) {
			set op = "!="
			set mdValue = $e(metadataValue,2,*)
		} else {
			set op = "="
			set mdValue = metadataValue
		}
		set filter = ##class(%iKnow.Filters.SimpleMetadataFilter).%New(domainId, metadataField, op, mdValue)
		// E.g: set filter = ##class(%iKnow.Filters.SimpleMetadataFilter).%New(2, "IsGesepareerd", "=", 1)
		w "d ##class(%ResultSet).RunQuery("""_conf.GetQAPI()_""",""GetByFilter"","_domainId_","""_filter.ToString()_""",7)", !
		
		set sc = rs.%Execute(domainId, filter.ToString(), 7)
		Quit:$$$ISERR(sc)
		
		w "Query Executed", !
		
		While(rs.%Next()) {
			set entityId = rs.%GetData(1)
			if (model.FactType = "crc") {
				set master = rs.%GetData(2)
				set r = rs.%GetData(3)
				set slave = rs.%GetData(4)
				set term = master_"~"_r_"~"_slave
			} else {
				set term = rs.%GetData(2)
			}
			if ($l(term) < 3) {
				Continue
			}
			//w entityId_":"_term, !
			
			set termRecord = $zobjclassmethod(conf.GetEntityClass(),conf.GetIndexOpenMtd(),entityId, -1, .sc)  
			Quit:$$$ISERR(sc)
			
			if (termRecord.Term '= term) {
				set sc = $$$ERROR($$$GeneralError, "Inconsistent data for entity: id = "_entityId_"; term = "_term_" ? "_termRecord.Term)
				//break
				Quit
			}
			
			set count = $i(count)
			set freq = rs.%Get("frequency")
			set spread = rs.%Get("spread")
			
			set usage = $zobjclassmethod(conf.GetUsageClass(), "%New")
			set usage.Term = termRecord
			set usage.MDKey = metadataField
			set usage.MDValue = metadataValue
			
			set usage.Frequency = freq
			set usage.Spread = spread
			
			w:verbose count_": "_term_": "_freq_"/"_spread

			set sc = usage.%Save()
			break:$$$ISERR(sc)
			Quit:$$$ISERR(sc)

			if ((count#5000)=0) {
				w "Updated "_count_" Terms.", !
			}
		}
		Quit:$$$ISERR(sc)
		
		d rs.%Close()
		
		set sc = ..updateRates(conf, metadataValue)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	w "Saved: "_count_" terms.", !
	
	Quit sc
}

ClassMethod load1ValueSQL(conf As %DeepSee.extensions.iKnow.conf.Config, metadataValue As %String, verbose As %Boolean = 0) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim err As %SYSTEM.Error
	
	#dim op, mdValue As %String
	#dim term, master, slave, r As %String
	#dim termRecord, usage 
	#dim list As %List
	#dim freq, spread, count As %Integer
	#dim entityId As %Integer
	#dim metadataField, query As %String
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model
	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
		
	set count = 0
	Try {
		set metadataField = model.MDField

		set op = $e(metadataValue)
		if ((op = "!") || (op = "'")) {
			set op = "<>"
			set mdValue = $e(metadataValue,2,*)
		} else {
			set op = "="
			set mdValue = metadataValue
		}
		set query = "select o.Term, o.Term->Term, count (distinct o.Source), sum (o.Freq) "
		set query = query_"from "_data.MDTable_" as md join "_conf.GetOccurenceTable()_" as o on md.Source = o.Source "
		set query = query_"where md.MDKey = ? and md.MDValue "_op_" ? "
		set query = query_"group by o.Term"
		w query, !
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(query)
		Quit:$$$ISERR(sc)
		
		w metadataField_op_mdValue, !
		
		set sc = rs.%Execute(metadataField, mdValue)
		Quit:$$$ISERR(sc)
		
		w "Query Executed", !
		
		While(rs.%Next()) {
			set entityId = rs.%GetData(1)
			set term = rs.%GetData(2)
			if ($l(term) < 3) {
				Continue
			}
			//w entityId_":"_term, !
			
			set termRecord = $zobjclassmethod(conf.GetEntityClass(),"%OpenId",entityId, -1, .sc)  
			Quit:$$$ISERR(sc)
			
			if (termRecord.Term '= term) {
				set sc = $$$ERROR($$$GeneralError, "Inconsistent data for entity: id = "_entityId_"; term = "_term_" ? "_termRecord.Term)
				//break
				Quit
			}
			
			set count = $i(count)
			set freq = rs.%GetData(4)
			set spread = rs.%GetData(3)
			
			set usage = $zobjclassmethod(conf.GetUsageClass(), "%New")
			set usage.Term = termRecord
			set usage.MDKey = metadataField
			set usage.MDValue = metadataValue
			
			set usage.Frequency = freq
			set usage.Spread = spread
			
			w:verbose count_": "_term_": "_freq_"/"_spread

			set sc = usage.%Save()
			break:$$$ISERR(sc)
			Quit:$$$ISERR(sc)

			if ((count#5000)=0) {
				w "Updated "_count_" Terms.", !
			}
		}
		Quit:$$$ISERR(sc)
		
		d rs.%Close()
		
		set sc = ..updateRates(conf, metadataValue)
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	w "Saved: "_count_" terms.", !
	
	Quit sc
}

Method buildAllModels(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim count, i As %Integer

	Try {
		set count = conf.models.Count()
		if (count > 0) {
			set conf.model = conf.models.GetAt(1)
		} else {
			set count = 1
		}
		w "Creating Fact tables for "_count_" models ", !
		for i = 1:1:count {
			if (i > 1) {
				set conf.model = conf.models.GetAt(i)
			}
			w "Building model #"_i, !
			set sc = ..genFactTable(conf)
			Quit:$$$ISERR(sc)
		
			set sc = ..buildFactTable(conf)
			Quit:$$$ISERR(sc)
			
			set sc = ..EntityPCA(conf.model)
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)
		
		w "Built "_i_" models", !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod loadModels(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim count, i As %Integer

	Try {
		set count = conf.models.Count()
		w "Found "_count_" models ", !
		if (count > 0) {
			for i = 1:1:count {
				set conf.model = conf.models.GetAt(i)
				w "Loading model #"_i, !
				set sc = ..loadModel(conf)
				Quit:$$$ISERR(sc)
			}
			Quit:$$$ISERR(sc)
		} else {
			set i = 1
			set sc = ..loadModel(conf)
		}
		Quit:$$$ISERR(sc)
		
		w "Loaded "_i_" models", !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod loadModel(conf As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim domainId, metadataValue As %String
	#dim inputColumnList, outputColumnList, table, class As %String
	
	#dim i, j, n, l As %Integer
	#dim values, columns
	#dim metadataField, valueList, v, vList As %String
	#dim model As %DeepSee.extensions.iKnow.conf.Model = conf.model

	Try {
		set metadataField = model.MDField
		set valueList = model.Values
		
		set sc = ..cleanupField(conf)
		Quit:$$$ISERR(sc)
		
		set domainId = ##class(%iKnow.Domain).GetOrCreateId(conf.data.Domain)
		set rs = ##class(%ResultSet).%New("%iKnow.Queries.MetadataQAPI:GetFieldValues")
		set sc = rs.%Execute(domainId, metadataField, 1, 0)
		Quit:$$$ISERR(sc)
		
		set n = 0
		set vList = ""
		While(rs.%Next()) {
			set metadataValue = rs.%GetData(1)
			if (valueList = "") {
				set n = $i(n)
				set values(n) = metadataValue
				w metadataValue, " +", !
			} else {
				set vList = vList_","_metadataValue
			}
		}
		if ((valueList '= "")) {
			set vList = vList_","
			set l = $l(valueList,",")
			set j = 0
			for i=1:1:l {
				set v = $p(valueList,",",i)
				set metadataValue = v
				w metadataValue
				if (($e(v) = "'") || ($e(v) = "'")) {
					set v = $e(v,2,*)
				}
				set v = ","_v_","
				if (vList[v) {
					set n = $i(n)
					set values(n) = metadataValue
					w " +", !
				} else {
					w " -", !
				}
			}
		} 
		set values = n

		d rs.%Close()
		
		for i=1:1:n {
			set metadataValue = values(i)
			w "Loading data for: "_metadataField_" = "_metadataValue, !
			set sc = ..load1Value(conf, metadataValue, 0)
			Quit:$$$ISERR(sc)
		}
		Quit:$$$ISERR(sc)

	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method EntityPCA(model As %DeepSee.extensions.iKnow.conf.Model) As %Status
{
	Quit ##class(ClassifierAnalysis).PCA(model.FactTable, model.InputColumns, ..FactOutputColumns)
}

ClassMethod ReadConfig(class As %String, Output config As %DeepSee.extensions.iKnow.conf.Config) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim xdata
	
	Try {
		set xdata = class_"||ClassifierModel"
		Set tXML=##class(%Dictionary.CompiledXData).%OpenId(xdata).Data
		If '$IsObject(tXML) {
			Set sc=%objlasterror 
			Quit
		}
		
		Set reader = ##class(%XML.Reader).%New()
		Set sc=reader.OpenStream(tXML)
		Quit:$$$ISERR(sc)
		Do reader.Correlate("Config","%DeepSee.extensions.iKnow.conf.Config")

		if ('reader.Next(.config,.sc)) {
			if ($$$ISOK(sc)) {
				set sc = $$$ERROR($$$GeneralError,"No Config element in XData: "_xdata)
			}
		}
		Quit:$$$ISERR(sc)
		
		if (config.models.Count() > 0) {
			set config.model = config.models.GetAt(1)
		}
	
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

}
