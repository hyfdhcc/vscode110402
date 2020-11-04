Class %DeepSee.extensions.iKnow.DistanceTools Extends %RegisteredObject [ System = 4 ]
{

ClassMethod genDistanceTable(conf As %DeepSee.extensions.iKnow.conf.Config, Output className As %String, Output tableName As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classDef As %Dictionary.ClassDefinition
	
	#dim entityClass, distanceClass As %String;
	
	Try {
		set entityClass = conf.GetEntityClass()
		set distanceClass = entityClass_"Distance"

		set sc = ##class(ClassifierBuilder).createNewClass(distanceClass, .classDef)
		Quit:$$$ISERR(sc)

		set sc = ##class(ClassifierBuilder).addParameter(classDef, "ENTITIES", "STRING", entityClass)
		Quit:$$$ISERR(sc)

		set sc = ##class(ClassifierBuilder).addProperty(classDef, "Term1", entityClass)
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierBuilder).addProperty(classDef, "Term2", entityClass)
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierBuilder).addProperty(classDef, "Distance", "%Double")
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierBuilder).addIndex(classDef, "TermIdx", "Term1,Term2", 1, 0, 0)
		Quit:$$$ISERR(sc)

		set sc = ##class(ClassifierBuilder).compile(classDef, .tableName)
		Quit:$$$ISERR(sc)
		
		set className = distanceClass
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod buildDistanceTable(conf As %DeepSee.extensions.iKnow.conf.Config, className As %String) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim data As %DeepSee.extensions.iKnow.conf.Data = conf.data
	
	#dim entityTable As %String
	#dim i, j, nk1, nk2, nk12, N, count As %Integer
	#dim sql, t1, t2 As %String
	#dim d As %Double
	
	#dim aggr

	Try {
		set entityTable = conf.GetEntityTable()

		set sc = ##class(ClassifierBuilder).aggreagte("select count(%ID) from "_data.SourceTable, .N)
		QUit:$$$ISERR(sc)
		
		set count = 0
		set count(0) = 10000
		
		set sql = "select o1.Term, o2.Term, o1.Term->Spread, o2.Term->Spread, count(o2.%ID) "
		set sql = sql_" from "_conf.GetOccurenceTable()_" as o1 join "
		set sql = sql_conf.GetOccurenceTable()_" as o2 on o1.source = o2.source "
		set sql = sql_"where o1.Term <= o2.Term "
		set sql = sql_"and o1.Term->SpreadRate > 0.01 and o2.Term->SpreadRate > 0.01 "		
		// set sql = sql_"and o1.Term < 10 and o2.Term < 10 "		
		set sql = sql_"group by o1.Term, o2.Term"
		
		w sql, !
		
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)

		set sc = rs.%Execute()
		Quit:$$$ISERR(sc)
		
		While (rs.%Next()) {
			set t1 = rs.%GetData(1)
			set t2 = rs.%GetData(2)
			
			set nk1 = rs.%GetData(3)

			set count = $i(count)
			if (t1 = t2) {
				set sc = ..saveDistanceObject(className, t1, t2, 0)
				Quit:$$$ISERR(sc)
				
				Continue
			}

			set nk2  = rs.%GetData(4)
			set nk12 = rs.%GetData(5)
	
			set d = nk1 + nk2 - (2 * nk12)
			set d = d / nk1 / nk2
			set d = d * N
			set d = $zsqr(d)
				
			set sc = ..saveDistanceObject(className, t1, t2, d)
			Quit:$$$ISERR(sc)
				
			set sc = ..saveDistanceObject(className, t2, t1, d)
			Quit:$$$ISERR(sc)
				
			set count = count + 2
				
			if (count > count(0)) {
				w "Distance pairs stored: "_count, !
				set count(0) = count(0) + 10000
			}
		}
		Quit:$$$ISERR(sc)

	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod createDistanceTable(conf As %DeepSee.extensions.iKnow.conf.Config, Output tableName As %String) As %Status
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

ClassMethod saveDistanceObject(className As %String, t1 As %String, t2 As %String, d As %Double) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim row As %Persistent

	Try {
		set row = $classmethod(className, "%New")
		if (row = "") {
			set sc = %objlasterror
			Quit
		}
				
		set sc = row.Term1SetObjectId(t1)
		Quit:$$$ISERR(sc)
		set sc = row.Term2SetObjectId(t2)
		Quit:$$$ISERR(sc)
		
		set row.Distance = d

		set sc = row.%Save()
		Quit:$$$ISERR(sc)
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

}
