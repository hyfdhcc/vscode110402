Include %occInclude

Class %DeepSee.extensions.iKnow.ClassifierAnalysis Extends %RegisteredObject [ System = 4 ]
{

ClassMethod LDA(conf As %DeepSee.extensions.iKnow.conf.Config, Output lda As %DeepSee.extensions.utils.LDA, Output sql As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim ldaName As %String
	#dim i, j, n As %Integer
	#dim d, g
	#dim dim As %Integer
	#dim values, tableName, key As %String
	#dim md, p As %Boolean
	
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier 	= conf.classifier
	#dim model As %DeepSee.extensions.iKnow.conf.Model 				= conf.model
	#dim data  As %DeepSee.extensions.iKnow.conf.Data 				= conf.data
	

	Try {
		set dim = classifier.MaxPC
		w "Using dim = "_dim, !
		
		set values = model.Values
		set tableName = classifier.ClassifierTable
		set key = model.MDField
		set p = 'classifier.EqualProbabilities
		set md = classifier.UseMahalanobisDistance
		
		set n = dim
		set sql = "select"
		for i = 1:1:n {
			set sql = sql_" cz"_i_", "
		}
		
		if (values '= "") {
			#dim k, M, tv
			set sql = sql_" decode(MDValue, "
			set M = $l(values,",")
			for k=1:1:M {
				set tv = $p(values,",",k)
				if (($e(tv) = "!") || ($e(tv) = "'")) {
					Continue
				}
				set sql = sql_"'"_tv_"','"_tv_"',"
			}
			set sql = sql_"0)"
		} else {
        	set sql = sql_" NVL(MDValue,0) "
		}
    	set sql = sql_"from "_tableName_" as c "
        set sql = sql_"join "_data.MDTable_" as md  on c.Source = md.Source "
    	set sql = sql_"where MDKey = '"_key_"'"
    	w sql, !
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql_" and ("_classifier.TrainingSetPredicate_")")
		Quit:$$$ISERR(sc)
		set sc = rs.Execute()
		Quit:$$$ISERR(sc)

		set i = 0
		While (rs.%Next()) {
			set i = $i(i)
			for j=1:1:n {
				set d(i,j) = rs.%GetData(j)
			}
			set g(i) = rs.%GetData(n+1)
		}
		
		d rs.%Close()
		
		set ldaName = ##class(ClassifierBuilder).ldaName(conf)
		if (##class(%DeepSee.extensions.utils.LDA).NameIdxExists(ldaName)) {
			set lda = ##class(%DeepSee.extensions.utils.LDA).NameIdxOpen(ldaName, -1, .sc)
			Quit:$$$ISERR(sc)
		} else {
			set lda = ##class(%DeepSee.extensions.utils.LDA).%New(ldaName)
			set lda.UseMahalanobisDistance = md
		
			set sc = lda.Create(i, n, .d, .g, p)
			Quit:$$$ISERR(sc)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod DirectLDA(conf As %DeepSee.extensions.iKnow.conf.Config, Output lda As %DeepSee.extensions.utils.LDA, Output sql As %String) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim ldaName As %String
	#dim i, j, n As %Integer
	#dim d, g
	#dim dim As %Integer
	#dim values, tableName, key, prop As %String
	#dim md, p As %Boolean
	
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier 	= conf.classifier
	#dim model As %DeepSee.extensions.iKnow.conf.Model 				= conf.model
	

	Try {
		set dim = $parameter(classifier.ClassifierClass,"Dim")
		w "Using dim = "_dim, !
		
		set values = model.Values
		set tableName = classifier.ClassifierTable
		set key = model.MDField
		set p = 'classifier.EqualProbabilities
		set md = classifier.UseMahalanobisDistance
		
		set n = dim
		set sql = "select "
		for i = 1:1:n {
			set prop = ##class(ClassifierBuilder).ClassifierPropName(i)
			set sql = sql_prop_", "
		}
		
		if (values '= "") {
			#dim k, M, tv
			set sql = sql_" decode(MDValue, "
			set M = $l(values,",")
			for k=1:1:M {
				set tv = $p(values,",",k)
				if (($e(tv) = "!") || ($e(tv) = "'")) {
					Continue
				}
				set sql = sql_"'"_tv_"','"_tv_"',"
			}
			set sql = sql_"0)"
		} else {
        	set sql = sql_" NVL(MDValue,0) "
		}
    	set sql = sql_"from "_tableName_" as c "
        set sql = sql_"join "_conf.data.MDTable_" as md  on c.Source = md.Source "
    	set sql = sql_"where MDKey = '"_key_"'"
    	w sql, !
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql_" and ("_classifier.TrainingSetPredicate_")")
		Quit:$$$ISERR(sc)
		set sc = rs.Execute()
		Quit:$$$ISERR(sc)

		set i = 0
		While (rs.%Next()) {
			set i = $i(i)
			for j=1:1:n {
				set d(i,j) = rs.%GetData(j)
			}
			set g(i) = rs.%GetData(n+1)
		}
		
		d rs.%Close()
		
		set ldaName = ##class(ClassifierBuilder).ldaName(conf)
		if (##class(%DeepSee.extensions.utils.LDA).NameIdxExists(ldaName)) {
			set lda = ##class(%DeepSee.extensions.utils.LDA).NameIdxOpen(ldaName, -1, .sc)
			Quit:$$$ISERR(sc)
			set lda.UseMahalanobisDistance = md
		} else {
			set lda = ##class(%DeepSee.extensions.utils.LDA).%New(ldaName)
			set lda.UseMahalanobisDistance = md
		
			set sc = lda.Create(i, n, .d, .g, p)
			Quit:$$$ISERR(sc)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod doAnalysis(conf As %DeepSee.extensions.iKnow.conf.Config, file As %String = "", cutoff As %Double = 0.9) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier
	
	Try {
		set classifier = conf.classifier
		if (classifier.DimReduction = "none") {
			set sc = ..DirectAnalysis(conf, file, cutoff)
		} elseif (classifier.DimReduction = "pca") {
			set sc = ..PCALDAAnalysis(conf, file, cutoff)
		} elseif (classifier.DimReduction = "gda") {
			set sc = ..PCAGDAAnalysis(conf, file, cutoff)
		} else {
			set sc = $$$ERROR($$$GeneralError, "Invalid Dimension Reduction policy: "_classifier.DimReduction)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod PCALDAAnalysis(conf As %DeepSee.extensions.iKnow.conf.Config, file As %String = "", cutoff As %Double = 0.9) As %Status
{
	#dim sc 	As %Status = $$$OK
	set sc = ..PCAAnalysis(conf)
	Quit:$$$ISERR(sc) sc
	
	set sc = ..LDA4PCA(conf, file, cutoff)
	Quit:$$$ISERR(sc) sc
	
	Quit sc
}

ClassMethod PCAGDAAnalysis(conf As %DeepSee.extensions.iKnow.conf.Config, file As %String = "", cutoff As %Double = 0.9, d2 As %Integer = "") As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier = conf.classifier
	#dim pca As %DeepSee.extensions.components.PCA	
	#dim listPos, listNeg As %List
	#dim keywords As %String
	#dim j As %Integer
	
	Try {
		set sc = ..PCAAnalysis(conf, .pca)
		Quit:$$$ISERR(sc)

		if (d2 = "") {
			set d2 = pca.GetModifiedEffectiveDimensionality(classifier.DimReductionMargin,$parameter(classifier.ClassifierClass,"Dim"),.sc)
			Quit:$$$ISERR(sc)
		}
		
		for j = 1:1:d2 {
			w "Component "_j_":", !
			set sc = pca.GetAxisMajorContributors(j, cutoff, .listPos, .listNeg)
			Quit:$$$ISERR(sc)

			set sc = ##class(ClassifierBuilder).ClassifierKeyWords(conf, .keywords)
			Quit:$$$ISERR(sc)
		
			set sc = ##class(ClassifierReport).TextGDAReport(conf, keywords, j, listPos, listNeg)
			Quit:$$$ISERR(sc)
		
			if (file '= "") {
				set sc = ##class(ClassifierReport).CSVGDAReport(file, conf, keywords, listPos, listNeg)
				Quit:$$$ISERR(sc)
			}
		}
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod PCAAnalysis(conf As %DeepSee.extensions.iKnow.conf.Config, Output pca As %DeepSee.extensions.components.PCA) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier
	#dim d1, d2, i As %Integer
	#dim margin As %Double

	Try {
		set classifier = conf.classifier
		set margin = conf.classifier.DimReductionMargin
		
		if (##class(%DeepSee.extensions.components.PCA).%ExistsId(classifier.ClassifierTable)) {
			set pca = ##class(%DeepSee.extensions.components.PCA).%OpenId(classifier.ClassifierTable,-1, .sc)
			Quit:$$$ISERR(sc)

			set d1 = pca.GetEffectiveDimensionality(margin, .sc)
			Quit:$$$ISERR(sc)
			set d2 = pca.GetModifiedEffectiveDimensionality(margin,$parameter(classifier.ClassifierClass,"Dim"),.sc)
			Quit:$$$ISERR(sc)
		} else {
			set sc = ..ClassifierPCA(classifier, 0, .d1, .d2, .pca)
			Quit:$$$ISERR(sc)
		}
			
		w "For margin "_margin_" diminsionality: "_d1, !
		w "Modified diminsionality: "_d2_"; Eigenvalues:", !
		
		for i=1:1:(d2+5) {
			Quit:i>20
			w i_": "_pca.OutputStdDev(i), !
		}
		
		if (d2 > conf.classifier.MaxPC) {
			if (conf.classifier.ErrorOnMaxPC) {
				set sc = $$$ERROR($$$GeneralError,"Too few principle components: "_conf.classifier.MaxPC_" is defined, "_d2_" are required")
			} else {
				w "WARNING: "_"Too few principle components: "_conf.classifier.MaxPC_" is defined, "_d2_" are required", !
			}
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod LDA4PCA(conf As %DeepSee.extensions.iKnow.conf.Config, file As %String, cutoff As %Double) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier
	#dim i, n As %Integer
	#dim listPos, listNeg As %List
	#dim keywords, g As %String
	#dim pca As %DeepSee.extensions.components.PCA
	#dim lda As %DeepSee.extensions.utils.LDA
	#dim X
	

	Try {
		set classifier = conf.classifier
		
		if (##class(%DeepSee.extensions.components.PCA).%ExistsId(classifier.ClassifierTable)) {
			set pca = ##class(%DeepSee.extensions.components.PCA).%OpenId(classifier.ClassifierTable,-1, .sc)
			Quit:$$$ISERR(sc)
		} else {
			set sc = $$$ERROR($$$GeneralError, "No PCA Object found for table: "_classifier.ClassifierTable)
			Quit
		}
			
		set sc = ..Analyze(conf, .lda, 0)
		Quit:$$$ISERR(sc)

		set g = classifier.TargetValue
		if (g = "") {
			w "Target value is not defined", !
			Quit
		}
		set sc = lda.getCovector(g, .X)
		Quit:$$$ISERR(sc)

		if (0) {
			w "Covector: ", !
			set sc = ##class(%DeepSee.extensions.utils.MatrixArithmetics).w(.X)
			Quit:$$$ISERR(sc)
		}

		set sc = pca.GetVectorMajorContributors(.X, cutoff, .listPos, .listNeg)
		Quit:$$$ISERR(sc)

		set sc = ##class(ClassifierBuilder).ClassifierKeyWords(conf, .keywords)
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierReport).TextReport(conf, keywords, listPos, listNeg)
		Quit:$$$ISERR(sc)
		
		if (file '= "") {
			set sc = ##class(ClassifierReport).CSVReport(file, conf, keywords, listPos, listNeg)
			Quit:$$$ISERR(sc)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod DirectAnalysis(conf As %DeepSee.extensions.iKnow.conf.Config, file As %String = "", cutoff As %Double = 0.9) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier
	#dim i, n As %Integer
	#dim listPos, listNeg As %List
	#dim keywords As %String
	#dim lda As %DeepSee.extensions.utils.LDA
	

	Try {
		set classifier = conf.classifier
		set sc = ..Analyze(conf, .lda, 1)
		Quit:$$$ISERR(sc)

		if (0) {
			set sc = ..printCovector(conf, lda)
			Quit:$$$ISERR(sc)
		}
		
		set sc = lda.GetMajorContributors(classifier.TargetValue, , cutoff, .listPos, .listNeg)
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierBuilder).ClassifierKeyWords(conf, .keywords)
		Quit:$$$ISERR(sc)
		
		set sc = ##class(ClassifierReport).TextReport(conf, keywords, listPos, listNeg)
		Quit:$$$ISERR(sc)
		
		if (file '= "") {
			if ($e(file,*-4,*) = ".html") { 
				set sc = ##class(ClassifierReport).HTMLReport(file, conf, keywords, listPos, listNeg)
			} else {
				set sc = ##class(ClassifierReport).CSVReport(file, conf, keywords, listPos, listNeg)
			}
			Quit:$$$ISERR(sc)
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod printCovector(conf As %DeepSee.extensions.iKnow.conf.Config, lda As %DeepSee.extensions.utils.LDA) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim i, n As %Integer
	#dim keywords, keyword As %String
	#dim X
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier
	
	Try {
		set classifier = conf.classifier
		
		set sc = lda.getCovector(classifier.TargetValue, .X)
		Quit:$$$ISERR(sc)
			
		set sc = ##class(ClassifierBuilder).ClassifierKeyWords(conf, .keywords)
		Quit:$$$ISERR(sc)
		
		set n = $l(keywords, ",")
		w "Covector:", !
		for i = 1:1:n {
			w $j(i,3)_": "
			set keyword = $p(keywords,",", i)
			w keyword
			w " "_$c(9)_X(i), !
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod Analyze(conf As %DeepSee.extensions.iKnow.conf.Config, Output lda As %DeepSee.extensions.utils.LDA, direct As %Boolean = 0) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier

	#dim d1, d2, i As %Integer
	#dim columns, sql, g As %String
	#dim margin As %Double
	#dim e

	Try {
		set classifier = conf.classifier
		
		if (direct) {
			set sc = ##class(ClassifierAnalysis).DirectLDA(conf, .lda, .sql)
		} else {
			set sc = ##class(ClassifierAnalysis).LDA(conf, .lda, .sql)
		}
		Quit:$$$ISERR(sc)
			
		w "Training Set Confusion Matrix:", !
		set sc = lda.printConfusionMatrix()
		Quit:$$$ISERR(sc)

		set g = classifier.TargetValue
		w "Overall Sensetivity: "_(lda.getSensitivity(g) * lda.getSpecificity(g)), !

		w "Test Set Confusion Matrix:", !
		set sc = ..printConfusionMatrix(sql_" and ( NOT ("_classifier.TrainingSetPredicate_"))", 0, lda)
		Quit:$$$ISERR(sc)
		
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod printConfusionMatrix(sql As %String, verbose As %Boolean, lda As %DeepSee.extensions.utils.LDA, Output s As %Double) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim i, j, y As %Integer
	#dim confusion, x
	#dim r, ss As %Double
	#dim f, v1, v2, cov1, cov2
	#dim g

	Try {
		set rs = ##class(%ResultSet).%New("%DynamicQuery:SQL")
		set sc = rs.Prepare(sql)
		Quit:$$$ISERR(sc)
		set sc = rs.Execute()
		Quit:$$$ISERR(sc)

		set sc = lda.getConfusionMatrixForTestSet(rs, 1, lda.Dim, .confusion, .r)
		Quit:$$$ISERR(sc)
		
		if (verbose) {
			set sc = lda.getCovector(1, .cov1)
			Quit:$$$ISERR(sc)
			set sc = lda.getCovector(2, .cov2)
			Quit:$$$ISERR(sc)
			
			set sc = rs.Execute()
			Quit:$$$ISERR(sc)
			
			While (rs.%Next()) {
				k x
				set x(1,0) = lda.Dim
				set x(0,1) = 1
				for i=1:1:lda.Dim {
					set x(i) = rs.%GetData(i)
				}
				set g = rs.%GetData(lda.Dim + 1)

				set y = lda.predict(.x, .sc)
				Quit:$$$ISERR(sc)
				
				set sc = lda.GetDF(.x, .f, 0)
				Quit:$$$ISERR(sc)
				
				set sc = ##class(%DeepSee.extensions.utils.MatrixArithmetics).mult(.cov1, .x, .v1)
				Quit:$$$ISERR(sc)
				
				set sc = ##class(%DeepSee.extensions.utils.MatrixArithmetics).mult(.cov2, .x, .v2)
				Quit:$$$ISERR(sc)
				
				w g_$c(9)_y
				w $j($fn(f(1),"",5),12)_$j($fn(v1(1),"",5),12)_$j($fn((v1(1) - f(1)),"",2),9)
				w $j($fn(f(2),"",5),12)_$j($fn(v2(1),"",5),12)_$j($fn((v2(1) - f(2)),"",2),9), !
			}
			Quit:$$$ISERR(sc)
		}
		
		set sc = lda.printConfusionMatrix(.confusion)
		Quit:$$$ISERR(sc)

		w "R = "_r, !
		
		set s = 1
		set r = 1
		set g = $o(confusion(""))
		While (g '= "") {
			set ss = lda.getSensitivity(g, .sc, .confusion)
			Quit:$$$ISERR(sc)
			set s = s * ss
			
			set ss = lda.getSpecificity(g, .sc, .confusion)
			Quit:$$$ISERR(sc)
			set r = r * ss
			
			set g = $o(confusion(g))
		}
		
		w "Overall Sensitivity :"_s, !
		w "Overall Specificity :"_r, !
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}

	Quit sc
}

ClassMethod ClassifierPCA(model As %DeepSee.extensions.iKnow.conf.Classifier, verbose As %Boolean = 1, Output d1 As %Integer, Output d2 As %Integer, Output pca As %DeepSee.extensions.components.PCA) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	#dim input, output, prop As %String
	#dim i, n As %Integer
	#dim margin As %Double
	
	Try {
		set input = ""
		set n = $parameter(model.ClassifierClass,"Dim")
		for i=1:1:n {
			set:input'="" input = input_","
			set prop = ##class(ClassifierBuilder).ClassifierPropName(i)
			set input = input_prop
		}
		set output = "cz1"
		for i=2:1:model.MaxPC {
			set output = output_",cz"_i
		}
		
		set margin = model.DimReductionMargin
		w "Doing PCA:", !
		set sc = ..PCA(model.ClassifierTable, input, output, 0, margin, .d1, .d2, .pca)
		Quit:$$$ISERR(sc)
		
		set sc = pca.%Save()
		Quit:$$$ISERR(sc)
		
		if (verbose) {
			w "For margin "_margin_" diminsionality: "_d1, !
			Quit:$$$ISERR(sc)
			w "Modified diminsionality: "_d2_"; Eigenvalues:", !
			for i=1:1:d2 {
				w i_": "_pca.OutputStdDev(i), !
			}
		
			if (d2 > model.MaxPC) {
				set sc = $$$ERROR($$$GeneralError,"Too few principle components: "_model.MaxPC_" is defined, "_d2_" are required")
			}
		}
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod PCA(table As %String, input As %String, out As %String, print As %Boolean = 1, margin As %Double = "", Output d1 As %Integer, Output d2 As %Integer, Output pca As %DeepSee.extensions.components.PCA) As %Status
{
	#dim sc As %Status = $$$OK
	#dim ex As %Exception.AbstractException

	Try {
		w:print "Doing PCA on "_table_"; input = "_input_", output = "_out, !
		set sc = ##class(%DeepSee.extensions.components.PCA).process(table, input, out, .pca, 1, print)
		Quit:$$$ISERR(sc)
		
		if (print) {
			set sc = pca.print()
			Quit:$$$ISERR(sc)
		}
		if (margin '= "") {
			set d1 = pca.GetEffectiveDimensionality(margin, .sc)
			Quit:$$$ISERR(sc)
			set d2 = pca.GetModifiedEffectiveDimensionality(margin,$l(input,","),.sc)
			Quit:$$$ISERR(sc)
		}

	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

}
