Include %occInclude

Class %DeepSee.extensions.iKnow.ClassifierOptimizer Extends %RegisteredObject [ System = 4 ]
{

Property Builder As ClassifierBuilder;

Property DirectLDA As %Boolean [ InitialExpression = 0 ];

ClassMethod create(builder As ClassifierBuilder) As ClassifierOptimizer
{
	set optimizer = ..%New()
	set optimizer.Builder = builder
	Quit optimizer
}

Method OptimizeCZ1(conf As %DeepSee.extensions.iKnow.conf.Config, N As %Integer = 150) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	//
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier

	#dim N1, N2, EffDim1, EffDim2, d1, d2, i, l As %Integer
	#dim iter As %Integer
	#dim columns, g, auxColumns As %String
	#dim margin As %Double
	#dim lda As %DeepSee.extensions.utils.LDA
	
	#dim F, ordered

	Try {
		set N1 = 0
		set N2 = N
		set EffDim1 = N
		set EffDim2 = N
		set classifier = conf.classifier
		set iter = 0
		
		set columns = classifier.columns
		set l = $f(columns,";")
		if (l > 0) {
			set auxColumns = $e(columns,l-1,*)
		} else {
			set auxColumns = ""
		}
		
		While(EffDim1 > 1) {
			set iter = $i(iter)
			set columns = ""
			if (N1 > 0) {
				set columns = "cz1:"_N1
			} 
			if (N2 > 0) {
				if (columns '= "") {
					set columns = columns_","
				}
				set columns = columns_"-cz1:"_N2
			}
			set columns = columns_auxColumns
			set columns(iter) = columns
			set classifier.columns = columns
			set N1(iter) = N1
			set N2(iter) = N2
	
			set sc = ..processConfiguration(conf, .lda, .d1, .d2)
			Quit:$$$ISERR(sc)
			
			set F(iter) = ..F(conf, lda)
			set ordered(F(iter)) = iter

			if (d1 < EffDim1) {
				set EffDim1 = d1
			}
			set EffDim2(iter) = d2
			if (d2 < EffDim2) {
				set EffDim2 = d2
			}
			
			w "N1 = ", N1_"; d1 = "_d1_"; d2 = "_d2_"; F = "_F(iter), !
			
			if (F(iter) = 0) {
				Quit
			}
			
			if (iter < 5) {
				set N1 = N1 + (N / 4)
				set N1 = N1 \ 1
				set N2 = N - N1
				Continue
			} 
			

			#dim X, Y, A
			#dim f As %Double
			#dim jiter, j As %Integer
			
			set f = ""
			for j = 1:1:3 {
				set f = $o(ordered(f),1,jiter)
				set X(j) = N1(jiter)
				set Y(j) = F(jiter)
				w "Y("_X(j)_") = "_Y(j), !
			}
			
			set sc = ##class(%DeepSee.extensions.utils.OLS).PolynomialRegression(.X, .Y, 3, 2, .A)
			Quit:$$$ISERR(sc)
			
			if (A(3) <= 0) {
				if (X(2) > X(1)) {
					set N1 = X(1) - 5
				} else {
					set N1 = X(1) + 5
				}
			} else {
				set N1 = -(A(2) / 2 / A(3))
				set N1 = N1 \ 1
			}
			if (N1 < 1) {
				set N1 = 0
			}
			
			if (N1 >N) {
				set N1 = N
			}
			
			
			w "A2 = "_A(3)_"; A(1) = "_A(2)_"; N1 = ", N1, !
			
			for j=1:1:iter {
				if (N1(j) = N1) {
					set j = -j
					Quit
				}
			}
			
			if (j < 0) {
				Quit
			}
			
			set N2 = N - N1
		}
		Quit:$$$ISERR(sc)

		set iter = ordered($o(ordered("")))
		set N1 = N1(iter)
		set N2 = N - N1
		set columns = columns(iter)		

		w "Optimal columns: """_columns_"""", !
		set classifier.columns = columns
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

ClassMethod F(conf As %DeepSee.extensions.iKnow.conf.Config, lda As %DeepSee.extensions.utils.LDA) As %Double
{
	#dim g As %String
	#dim f As %Double
	
	set g = conf.classifier.TargetValue
	set f = 1 - (lda.getSensitivity(g) * lda.getSpecificity(g))
	
	Quit f
}

Method processConfiguration(conf As %DeepSee.extensions.iKnow.conf.Config, Output lda As %DeepSee.extensions.utils.LDA, Output d1 As %Integer, Output d2 As %Integer) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim l1, l2 As %List
	
	Try {
		set sc = ..Builder.genClassifierTable(conf)
		Quit:$$$ISERR(sc)
			
		set sc = ..Builder.buildClassifierTable(conf)
		Quit:$$$ISERR(sc)
			
		if (..DirectLDA) {
			set sc = ##class(ClassifierAnalysis).DirectLDA(conf, .lda)
			Quit:$$$ISERR(sc)
			
			set sc = lda.GetMajorContributors(conf.classifier.TargetValue,, conf.classifier.DimReductionMargin, .l1, .l2)
			Quit:$$$ISERR(sc)

			set d1 = $ll(l1) + $ll(l2)
			set d2 = d1
		} else {
			set sc = ##class(ClassifierAnalysis).ClassifierPCA(conf.classifier, 0, .d1, .d2)
			Quit:$$$ISERR(sc)
			
			set sc = ##class(ClassifierAnalysis).LDA(conf, .lda)
			Quit:$$$ISERR(sc)
		}

		w "Training Set Confusion Matrix:", !
		set sc = lda.printConfusionMatrix()
		Quit:$$$ISERR(sc)

	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

Method addToBlackList(conf As %DeepSee.extensions.iKnow.conf.Config, d As %Double, lda As %DeepSee.extensions.utils.LDA, Output size As %Integer) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	#dim classifier As %DeepSee.extensions.iKnow.conf.Classifier
	#dim listPos, listNeg, list As %List
	#dim i, n, k As %Integer
	#dim keywords, blacklist, keyword, str As %String
	
	#dim X
	
	Try {
		set classifier = conf.classifier

		if (..DirectLDA) {
			set sc = lda.GetMajorContributors(classifier.TargetValue,, d, .listPos, .listNeg)
			Quit:$$$ISERR(sc)
		} else {
			set pca = ##class(%DeepSee.extensions.components.PCA).%OpenId(classifier.ClassifierTable,-1, .sc)
			Quit:$$$ISERR(sc)

			set sc = lda.getCovector(classifier.TargetValue, .X)
			Quit:$$$ISERR(sc)
				
			set sc = pca.GetVectorMajorContributors(.X, d, .listPos, .listNeg)
			Quit:$$$ISERR(sc)
		}

		set sc = ##class(ClassifierBuilder).ClassifierKeyWords(conf, .keywords)
		Quit:$$$ISERR(sc)
		
		set n = $l(keywords,",")
		for i = 1:1:n {
			set keyword = $p(keywords,",",i)
			set keywords(keyword) = i
		}
		
		set list = listPos
		set n = $ll(list)

		for i=1:1:n {
			set k = $li($li(list,i),1)
			set keyword = $p(keywords,",",k)
			k keywords(keyword)
		}
		
		set list = listNeg
		set n = $ll(list)

		for i=1:1:n {
			set k = $li($li(list,i),1)
			set keyword = $p(keywords,",",k)
			k keywords(keyword)
		}
		
		set blacklist = ""
		set keyword = $o(keywords(""))
		While (keyword '= "") {
			if (blacklist '= "") {
				set blacklist = blacklist_","
			}
			set blacklist = blacklist_"'"_keyword_"'"
			set keyword = $o(keywords(keyword))
		}
		
		if (blacklist = "") {
			set size = 0
			Quit
		}
		
		set size = $l(blacklist,",")
		
		if (..Builder.BlackList = "") {
			set ..Builder.BlackList = blacklist
		} else {
			set ..Builder.BlackList = ..Builder.BlackList_","_blacklist
		}
		
	} Catch(ex) {
		set sc = ex.AsStatus()
		break
	}
	
	Quit sc
}

Method optimizeTerms(conf As %DeepSee.extensions.iKnow.conf.Config, cutoff As %Double = 0.99) As %Status
{
	#dim sc 	As %Status = $$$OK
	#dim ex As %Exception.AbstractException
	
	#dim iter, d1, d2, l As %Integer
	#dim lda As %DeepSee.extensions.utils.LDA
	
	#dim f0, f1 As %Double
	#dim savedBlackList As %String
		
	Try {
		set f0 = 1
		set iter = 0
		While (1) {
			set sc = ..processConfiguration(conf, .lda, .d1, .d2)
			Quit:$$$ISERR(sc)
			
			set f1 = ..F(conf, lda)
			w "F = "_f1, !
			
			if (f0 <= f1) {
				set ..Builder.BlackList = savedBlackList
				Quit
			}
			
			set f0 = f1
			
			set savedBlackList = ..Builder.BlackList
			set sc = ..addToBlackList(conf, cutoff, lda, .l)
			Quit:$$$ISERR(sc)
			
			w "Added "_l_" terms to blacklist. "
			w "Blacklist size is now "_$l(..Builder.BlackList,","), !
			if (l = 0) {
				Quit
			}
			
			set iter = $i(iter)
		}
		Quit:$$$ISERR(sc)
		
		w "Done "_iter_" iterations.", !
	} Catch(ex) {
		set sc = ex.AsStatus()
	}
	
	Quit sc
}

}
