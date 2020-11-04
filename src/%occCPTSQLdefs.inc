ROUTINE %occCPTSQLdefs [Type=INC]
#;
#; GENERATED USING %CPT.MakeDefsInclude - DO NOT EDIT
#;
 
#include %occCPTconfig
 

#if $$$HPTDYNMETADATA

#define SQLNodeAddAction $$$CPTIXNODER("SQL","AddAction")
#define SQLNodeAddActionChiConstraint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddAction,"Constraint")
#define SQLNodeAddActionChiAddBody $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddAction,"AddBody")
 
#define SQLNodeAddBodyCheck $$$CPTIXNODER("SQL","AddBodyCheck")
#define SQLNodeAddBodyCheckChiChkparse $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyCheck,"Chkparse")
 
#define SQLNodeAddBodyColdef $$$CPTIXNODER("SQL","AddBodyColdef")
#define SQLNodeAddBodyColdefChiColdef $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyColdef,"Coldef")
 
#define SQLNodeAddBodyDefault $$$CPTIXNODER("SQL","AddBodyDefault")
#define SQLNodeAddBodyDefaultChiDefSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyDefault,"DefSpec")
#define SQLNodeAddBodyDefaultChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyDefault,"Ident")
 
#define SQLNodeAddBodyFkey $$$CPTIXNODER("SQL","AddBodyFkey")
#define SQLNodeAddBodyFkeyChiAltFkeySpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyFkey,"AltFkeySpec")
#define SQLNodeAddBodyFkeyChiOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyFkey,"On")
 
#define SQLNodeAddBodyPkey $$$CPTIXNODER("SQL","AddBodyPkey")
#define SQLNodeAddBodyPkeyChiAltPkey $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyPkey,"AltPkey")
#define SQLNodeAddBodyPkeyChiOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyPkey,"On")
 
#define SQLNodeAddBodyUnique $$$CPTIXNODER("SQL","AddBodyUnique")
#define SQLNodeAddBodyUniqueChiAltUnique $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyUnique,"AltUnique")
#define SQLNodeAddBodyUniqueChiFillFactor $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyUnique,"FillFactor")
#define SQLNodeAddBodyUniqueChiOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAddBodyUnique,"On")
 
#define SQLNodeAdminPriv $$$CPTIXNODER("SQL","AdminPriv")
#define SQLNodeAdminPrivAnnName $$$CPTIXNODEANNR("SQL",$$$SQLNodeAdminPriv,"Name")
 
#define SQLNodeAdminPrivList $$$CPTIXNODER("SQL","AdminPrivList")
 
#define SQLNodeAgg $$$CPTIXNODER("SQL","Agg")
#define SQLNodeAggAnnAggFunc $$$CPTIXNODEANNR("SQL",$$$SQLNodeAgg,"AggFunc")
#define SQLNodeAggChiAggArgOrStar $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAgg,"AggArgOrStar")
 
#define SQLNodeAggArg $$$CPTIXNODER("SQL","AggArg")
#define SQLNodeAggArgAnnAfterHaving $$$CPTIXNODEANNR("SQL",$$$SQLNodeAggArg,"AfterHaving")
#define SQLNodeAggArgChiDist $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAggArg,"Dist")
#define SQLNodeAggArgChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAggArg,"Scalx")
#define SQLNodeAggArgChiForEach $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAggArg,"ForEach")
 
#define SQLNodeAllPrivileges $$$CPTIXNODER("SQL","AllPrivileges")
 
#define SQLNodeAltFkeySpec $$$CPTIXNODER("SQL","AltFkeySpec")
#define SQLNodeAltFkeySpecChiForeignKey $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltFkeySpec,"ForeignKey")
#define SQLNodeAltFkeySpecChiFlist2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltFkeySpec,"Flist2")
#define SQLNodeAltFkeySpecChiReferences $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltFkeySpec,"References")
 
#define SQLNodeAltPKey1 $$$CPTIXNODER("SQL","AltPKey1")
#define SQLNodeAltPKey1ChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltPKey1,"Ident")
#define SQLNodeAltPKey1ChiFlist2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltPKey1,"Flist2")
 
#define SQLNodeAltPKey2 $$$CPTIXNODER("SQL","AltPKey2")
#define SQLNodeAltPKey2ChiFlist1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltPKey2,"Flist1")
 
#define SQLNodeAltUnique $$$CPTIXNODER("SQL","AltUnique")
#define SQLNodeAltUniqueAnnClustered $$$CPTIXNODEANNR("SQL",$$$SQLNodeAltUnique,"Clustered")
#define SQLNodeAltUniqueChiFlist2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAltUnique,"Flist2")
 
#define SQLNodeAlterActionAdd $$$CPTIXNODER("SQL","AlterActionAdd")
 
#define SQLNodeAlterActionAlter $$$CPTIXNODER("SQL","AlterActionAlter")
#define SQLNodeAlterActionAlterChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterActionAlter,"Ident")
#define SQLNodeAlterActionAlterChiAlterCol $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterActionAlter,"AlterCol")
 
#define SQLNodeAlterActionConstraint $$$CPTIXNODER("SQL","AlterActionConstraint")
#define SQLNodeAlterActionConstraintAnnCheckSpec $$$CPTIXNODEANNR("SQL",$$$SQLNodeAlterActionConstraint,"CheckSpec")
 
#define SQLNodeAlterActionDrop $$$CPTIXNODER("SQL","AlterActionDrop")
#define SQLNodeAlterActionDropChiDropAction $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterActionDrop,"DropAction")
 
#define SQLNodeAlterActionLock $$$CPTIXNODER("SQL","AlterActionLock")
#define SQLNodeAlterActionLockAnnRowPage $$$CPTIXNODEANNR("SQL",$$$SQLNodeAlterActionLock,"RowPage")
 
#define SQLNodeAlterActionModify $$$CPTIXNODER("SQL","AlterActionModify")
 
#define SQLNodeAlterTable $$$CPTIXNODER("SQL","AlterTable")
#define SQLNodeAlterTableAnnCheckSpec $$$CPTIXNODEANNR("SQL",$$$SQLNodeAlterTable,"CheckSpec")
#define SQLNodeAlterTableChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterTable,"Tname")
#define SQLNodeAlterTableChiAlterAction $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterTable,"AlterAction")
 
#define SQLNodeAlterUser $$$CPTIXNODER("SQL","AlterUser")
#define SQLNodeAlterUserChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterUser,"Ident")
#define SQLNodeAlterUserChiIdentifiedBy $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterUser,"IdentifiedBy")
#define SQLNodeAlterUserChiCreateUserDefault $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterUser,"CreateUserDefault")
#define SQLNodeAlterUserChiCreateUserTemporary $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterUser,"CreateUserTemporary")
 
#define SQLNodeAlterView $$$CPTIXNODER("SQL","AlterView")
#define SQLNodeAlterViewChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterView,"Tname")
#define SQLNodeAlterViewChiIdentList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterView,"IdentList")
#define SQLNodeAlterViewChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterView,"Query")
#define SQLNodeAlterViewChiAlterViewWith $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterView,"AlterViewWith")
 
#define SQLNodeAlterViewWithCheckOption $$$CPTIXNODER("SQL","AlterViewWithCheckOption")
#define SQLNodeAlterViewWithCheckOptionChiConstraint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAlterViewWithCheckOption,"Constraint")
 
#define SQLNodeAlterViewWithReadOnly $$$CPTIXNODER("SQL","AlterViewWithReadOnly")
 
#define SQLNodeAnd $$$CPTIXNODER("SQL","And")
#define SQLNodeAndChiCond $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAnd,"Cond")
#define SQLNodeAndChiAndTail $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAnd,"AndTail")
 
#define SQLNodeAndTail $$$CPTIXNODER("SQL","AndTail")
 
#define SQLNodeAndTerm $$$CPTIXNODER("SQL","AndTerm")
#define SQLNodeAndTermAnnAndOperator $$$CPTIXNODEANNR("SQL",$$$SQLNodeAndTerm,"AndOperator")
#define SQLNodeAndTermChiCond $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAndTerm,"Cond")
 
#define SQLNodeAsignDefault $$$CPTIXNODER("SQL","AsignDefault")
 
#define SQLNodeAsignSet $$$CPTIXNODER("SQL","AsignSet")
 
#define SQLNodeAsignValue $$$CPTIXNODER("SQL","AsignValue")
#define SQLNodeAsignValueChiColmnList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAsignValue,"ColmnList")
#define SQLNodeAsignValueChiValueSource $$$CPTIXNODECHILDR("SQL",$$$SQLNodeAsignValue,"ValueSource")
 
#define SQLNodeBatch $$$CPTIXNODER("SQL","Batch")
 
#define SQLNodeBlobSupport $$$CPTIXNODER("SQL","BlobSupport")
#define SQLNodeBlobSupportAnnSetting $$$CPTIXNODEANNR("SQL",$$$SQLNodeBlobSupport,"Setting")
 
#define SQLNodeCOSMethodBody $$$CPTIXNODER("SQL","COSMethodBody")
#define SQLNodeCOSMethodBodyChiCodeLines $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCOSMethodBody,"CodeLines")
 
#define SQLNodeCOSQueryBody $$$CPTIXNODER("SQL","COSQueryBody")
 
#define SQLNodeCOSQueryPart $$$CPTIXNODER("SQL","COSQueryPart")
#define SQLNodeCOSQueryPartAnnQueryPartType $$$CPTIXNODEANNR("SQL",$$$SQLNodeCOSQueryPart,"QueryPartType")
#define SQLNodeCOSQueryPartChiParameterList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCOSQueryPart,"ParameterList")
#define SQLNodeCOSQueryPartChiCOSMethodBody $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCOSQueryPart,"COSMethodBody")
 
#define SQLNodeCSPOrPPAndTerm $$$CPTIXNODER("SQL","CSPOrPPAndTerm")
#define SQLNodeCSPOrPPAndTermAnnCSPOrPP $$$CPTIXNODEANNR("SQL",$$$SQLNodeCSPOrPPAndTerm,"CSPOrPP")
 
#define SQLNodeCSPOrPPStat $$$CPTIXNODER("SQL","CSPOrPPStat")
#define SQLNodeCSPOrPPStatAnnCSPOrPP $$$CPTIXNODEANNR("SQL",$$$SQLNodeCSPOrPPStat,"CSPOrPP")
 
#define SQLNodeCSPOrPPTables $$$CPTIXNODER("SQL","CSPOrPPTables")
#define SQLNodeCSPOrPPTablesAnnCSPOrPP $$$CPTIXNODEANNR("SQL",$$$SQLNodeCSPOrPPTables,"CSPOrPP")
 
#define SQLNodeCSPOrPPWhereAll $$$CPTIXNODER("SQL","CSPOrPPWhereAll")
#define SQLNodeCSPOrPPWhereAllAnnCSPOrPP $$$CPTIXNODEANNR("SQL",$$$SQLNodeCSPOrPPWhereAll,"CSPOrPP")
 
#define SQLNodeCSPOrPPWhereCond $$$CPTIXNODER("SQL","CSPOrPPWhereCond")
#define SQLNodeCSPOrPPWhereCondAnnCSPOrPPBefore $$$CPTIXNODEANNR("SQL",$$$SQLNodeCSPOrPPWhereCond,"CSPOrPPBefore")
#define SQLNodeCSPOrPPWhereCondAnnCSPOrPPAfter $$$CPTIXNODEANNR("SQL",$$$SQLNodeCSPOrPPWhereCond,"CSPOrPPAfter")
#define SQLNodeCSPOrPPWhereCondChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCSPOrPPWhereCond,"Prdct")
 
#define SQLNodeCacheSpecialVariable $$$CPTIXNODER("SQL","CacheSpecialVariable")
#define SQLNodeCacheSpecialVariableAnnVariableName $$$CPTIXNODEANNR("SQL",$$$SQLNodeCacheSpecialVariable,"VariableName")
 
#define SQLNodeCall $$$CPTIXNODER("SQL","Call")
#define SQLNodeCallChiHostVariableArgument $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCall,"HostVariableArgument")
#define SQLNodeCallChiCallTarget $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCall,"CallTarget")
#define SQLNodeCallChiSqlArgumentList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCall,"SqlArgumentList")
#define SQLNodeCallChiUsing $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCall,"Using")
 
#define SQLNodeCase $$$CPTIXNODER("SQL","Case")
#define SQLNodeCaseChiCase $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCase,"Case")
#define SQLNodeCaseChiCaseWhenList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCase,"CaseWhenList")
#define SQLNodeCaseChiElse $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCase,"Else")
 
#define SQLNodeCaseWhen $$$CPTIXNODER("SQL","CaseWhen")
#define SQLNodeCaseWhenChiWhen $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCaseWhen,"When")
#define SQLNodeCaseWhenChiThen $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCaseWhen,"Then")
 
#define SQLNodeCaseWhenList $$$CPTIXNODER("SQL","CaseWhenList")
 
#define SQLNodeCheckCnstr $$$CPTIXNODER("SQL","CheckCnstr")
#define SQLNodeCheckCnstrChiChkparse $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCheckCnstr,"Chkparse")
 
#define SQLNodeChkPrvCmdOn $$$CPTIXNODER("SQL","ChkPrvCmdOn")
#define SQLNodeChkPrvCmdOnChiPrivSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeChkPrvCmdOn,"PrivSpec")
#define SQLNodeChkPrvCmdOnChiObject $$$CPTIXNODECHILDR("SQL",$$$SQLNodeChkPrvCmdOn,"Object")
 
#define SQLNodeChkparse $$$CPTIXNODER("SQL","Chkparse")
#define SQLNodeChkparseAnnTokens $$$CPTIXNODEANNR("SQL",$$$SQLNodeChkparse,"Tokens")
 
#define SQLNodeChkprv $$$CPTIXNODER("SQL","Chkprv")
#define SQLNodeChkprvAnnGrantOpt $$$CPTIXNODEANNR("SQL",$$$SQLNodeChkprv,"GrantOpt")
#define SQLNodeChkprvChiChkPrvCmd $$$CPTIXNODECHILDR("SQL",$$$SQLNodeChkprv,"ChkPrvCmd")
 
#define SQLNodeClose $$$CPTIXNODER("SQL","Close")
#define SQLNodeCloseChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeClose,"Ident")
 
#define SQLNodeCodeLines $$$CPTIXNODER("SQL","CodeLines")
 
#define SQLNodeCodeSpecification $$$CPTIXNODER("SQL","CodeSpecification")
#define SQLNodeCodeSpecificationChiParameterList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCodeSpecification,"ParameterList")
#define SQLNodeCodeSpecificationChiMethodQueryCharacteristicsList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCodeSpecification,"MethodQueryCharacteristicsList")
#define SQLNodeCodeSpecificationChiCodeBody $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCodeSpecification,"CodeBody")
 
#define SQLNodeColdef $$$CPTIXNODER("SQL","Coldef")
#define SQLNodeColdefChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColdef,"Ident")
#define SQLNodeColdefChiDatyp $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColdef,"Datyp")
#define SQLNodeColdefChiFldQualifierList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColdef,"FldQualifierList")
 
#define SQLNodeColmn $$$CPTIXNODER("SQL","Colmn")
#define SQLNodeColmnAnnBase $$$CPTIXNODEANNR("SQL",$$$SQLNodeColmn,"Base")
#define SQLNodeColmnChiColmnDot $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColmn,"ColmnDot")
#define SQLNodeColmnChiColmnArrow $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColmn,"ColmnArrow")
 
#define SQLNodeColmnAssignment $$$CPTIXNODER("SQL","ColmnAssignment")
#define SQLNodeColmnAssignmentChiColmn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColmnAssignment,"Colmn")
#define SQLNodeColmnAssignmentChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeColmnAssignment,"Scalx")
 
#define SQLNodeColmnList $$$CPTIXNODER("SQL","ColmnList")
 
#define SQLNodeComparisonBetween $$$CPTIXNODER("SQL","ComparisonBetween")
#define SQLNodeComparisonBetweenAnnNot $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonBetween,"Not")
#define SQLNodeComparisonBetweenChiBetween $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonBetween,"Between")
#define SQLNodeComparisonBetweenChiAnd $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonBetween,"And")
 
#define SQLNodeComparisonCmpOp $$$CPTIXNODER("SQL","ComparisonCmpOp")
#define SQLNodeComparisonCmpOpAnnCmpOp $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonCmpOp,"CmpOp")
#define SQLNodeComparisonCmpOpChiComparisonCmpOpRhs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonCmpOp,"ComparisonCmpOpRhs")
#define SQLNodeComparisonCmpOpChiSizeHint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonCmpOp,"SizeHint")
 
#define SQLNodeComparisonCmpOpQuery $$$CPTIXNODER("SQL","ComparisonCmpOpQuery")
#define SQLNodeComparisonCmpOpQueryAnnSubqueryScope $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonCmpOpQuery,"SubqueryScope")
#define SQLNodeComparisonCmpOpQueryChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonCmpOpQuery,"Query")
 
#define SQLNodeComparisonContains $$$CPTIXNODER("SQL","ComparisonContains")
#define SQLNodeComparisonContainsAnnNot $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonContains,"Not")
#define SQLNodeComparisonContainsAnnIsContainsTerm $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonContains,"IsContainsTerm")
#define SQLNodeComparisonContainsChiContainsSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonContains,"ContainsSpec")
 
#define SQLNodeComparisonIn $$$CPTIXNODER("SQL","ComparisonIn")
#define SQLNodeComparisonInAnnNot $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonIn,"Not")
#define SQLNodeComparisonInChiInSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonIn,"InSpec")
 
#define SQLNodeComparisonInlist $$$CPTIXNODER("SQL","ComparisonInlist")
#define SQLNodeComparisonInlistAnnNot $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonInlist,"Not")
#define SQLNodeComparisonInlistChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonInlist,"Scalx")
#define SQLNodeComparisonInlistChiSize $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonInlist,"Size")
 
#define SQLNodeComparisonIsNull $$$CPTIXNODER("SQL","ComparisonIsNull")
#define SQLNodeComparisonIsNullAnnNot $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonIsNull,"Not")
 
#define SQLNodeComparisonLikeOrMatches $$$CPTIXNODER("SQL","ComparisonLikeOrMatches")
#define SQLNodeComparisonLikeOrMatchesAnnNot $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonLikeOrMatches,"Not")
#define SQLNodeComparisonLikeOrMatchesChiLike $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonLikeOrMatches,"Like")
#define SQLNodeComparisonLikeOrMatchesChiEscape $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonLikeOrMatches,"Escape")
 
#define SQLNodeComparisonWithScalx $$$CPTIXNODER("SQL","ComparisonWithScalx")
#define SQLNodeComparisonWithScalxAnnOp $$$CPTIXNODEANNR("SQL",$$$SQLNodeComparisonWithScalx,"Op")
#define SQLNodeComparisonWithScalxChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComparisonWithScalx,"Scalx")
 
#define SQLNodeCompileOption $$$CPTIXNODER("SQL","CompileOption")
#define SQLNodeCompileOptionAnnCompileOptionSetting $$$CPTIXNODEANNR("SQL",$$$SQLNodeCompileOption,"CompileOptionSetting")
 
#define SQLNodeComponentSpec $$$CPTIXNODER("SQL","ComponentSpec")
#define SQLNodeComponentSpecAnnAscDesc $$$CPTIXNODEANNR("SQL",$$$SQLNodeComponentSpec,"AscDesc")
#define SQLNodeComponentSpecChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeComponentSpec,"Ident")
 
#define SQLNodeComponentSpecList $$$CPTIXNODER("SQL","ComponentSpecList")
 
#define SQLNodeCond $$$CPTIXNODER("SQL","Cond")
#define SQLNodeCondChiCondTermHint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCond,"CondTermHint")
#define SQLNodeCondChiCondTerm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCond,"CondTerm")
#define SQLNodeCondChiComparison $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCond,"Comparison")
 
#define SQLNodeCondTermExists $$$CPTIXNODER("SQL","CondTermExists")
#define SQLNodeCondTermExistsChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermExists,"Query")
 
#define SQLNodeCondTermFor $$$CPTIXNODER("SQL","CondTermFor")
#define SQLNodeCondTermForChiTables $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermFor,"Tables")
#define SQLNodeCondTermForChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermFor,"Prdct")
 
#define SQLNodeCondTermForElement $$$CPTIXNODER("SQL","CondTermForElement")
#define SQLNodeCondTermForElementChiColmn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermForElement,"Colmn")
#define SQLNodeCondTermForElementChiAlias $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermForElement,"Alias")
#define SQLNodeCondTermForElementChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermForElement,"Prdct")
 
#define SQLNodeCondTermHint $$$CPTIXNODER("SQL","CondTermHint")
#define SQLNodeCondTermHintAnnNOINDEX $$$CPTIXNODEANNR("SQL",$$$SQLNodeCondTermHint,"NOINDEX")
 
#define SQLNodeCondTermNot $$$CPTIXNODER("SQL","CondTermNot")
#define SQLNodeCondTermNotChiCond $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermNot,"Cond")
 
#define SQLNodeCondTermScalx $$$CPTIXNODER("SQL","CondTermScalx")
#define SQLNodeCondTermScalxChiValue $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCondTermScalx,"Value")
 
#define SQLNodeConstant $$$CPTIXNODER("SQL","Constant")
#define SQLNodeConstantAnnParenCount $$$CPTIXNODEANNR("SQL",$$$SQLNodeConstant,"ParenCount")
#define SQLNodeConstantChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeConstant,"Literal")
 
#define SQLNodeContainsSpec $$$CPTIXNODER("SQL","ContainsSpec")
#define SQLNodeContainsSpecChiList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeContainsSpec,"List")
 
#define SQLNodeConvertArgs $$$CPTIXNODER("SQL","ConvertArgs")
#define SQLNodeConvertArgsChiCast $$$CPTIXNODECHILDR("SQL",$$$SQLNodeConvertArgs,"Cast")
#define SQLNodeConvertArgsChiValue1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeConvertArgs,"Value1")
#define SQLNodeConvertArgsChiValue2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeConvertArgs,"Value2")
 
#define SQLNodeCreateDatabase $$$CPTIXNODER("SQL","CreateDatabase")
#define SQLNodeCreateDatabaseAnnDatabaseName $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateDatabase,"DatabaseName")
#define SQLNodeCreateDatabaseAnnDirectoryName $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateDatabase,"DirectoryName")
#define SQLNodeCreateDatabaseChiCreateDatabaseWith $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateDatabase,"CreateDatabaseWith")
 
#define SQLNodeCreateDatabaseWith $$$CPTIXNODER("SQL","CreateDatabaseWith")
#define SQLNodeCreateDatabaseWithAnnEncryptedDB $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateDatabaseWith,"EncryptedDB")
#define SQLNodeCreateDatabaseWithAnnGlobalJournalState $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateDatabaseWith,"GlobalJournalState")
 
#define SQLNodeCreateFunction $$$CPTIXNODER("SQL","CreateFunction")
#define SQLNodeCreateFunctionChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateFunction,"QualifiedSpname")
#define SQLNodeCreateFunctionChiCodeSpecification $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateFunction,"CodeSpecification")
 
#define SQLNodeCreateIndex $$$CPTIXNODER("SQL","CreateIndex")
#define SQLNodeCreateIndexChiIndexQualifiers $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndex,"IndexQualifiers")
#define SQLNodeCreateIndexChiIndexname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndex,"Indexname")
#define SQLNodeCreateIndexChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndex,"Tname")
#define SQLNodeCreateIndexChiComponentSpecList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndex,"ComponentSpecList")
#define SQLNodeCreateIndexChiCreateIndexWithList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndex,"CreateIndexWithList")
#define SQLNodeCreateIndexChiInOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndex,"InOn")
 
#define SQLNodeCreateIndexWithData $$$CPTIXNODER("SQL","CreateIndexWithData")
 
#define SQLNodeCreateIndexWithDropExisting $$$CPTIXNODER("SQL","CreateIndexWithDropExisting")
 
#define SQLNodeCreateIndexWithFillFactor $$$CPTIXNODER("SQL","CreateIndexWithFillFactor")
#define SQLNodeCreateIndexWithFillFactorChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateIndexWithFillFactor,"Literal")
 
#define SQLNodeCreateIndexWithIgnoreDupKey $$$CPTIXNODER("SQL","CreateIndexWithIgnoreDupKey")
 
#define SQLNodeCreateIndexWithList $$$CPTIXNODER("SQL","CreateIndexWithList")
 
#define SQLNodeCreateIndexWithPadIndex $$$CPTIXNODER("SQL","CreateIndexWithPadIndex")
 
#define SQLNodeCreateIndexWithStatisticsNorecompute $$$CPTIXNODER("SQL","CreateIndexWithStatisticsNorecompute")
 
#define SQLNodeCreateMethod $$$CPTIXNODER("SQL","CreateMethod")
#define SQLNodeCreateMethodAnnStatic $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateMethod,"Static")
#define SQLNodeCreateMethodChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateMethod,"QualifiedSpname")
#define SQLNodeCreateMethodChiCodeSpecification $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateMethod,"CodeSpecification")
 
#define SQLNodeCreateProcedure $$$CPTIXNODER("SQL","CreateProcedure")
#define SQLNodeCreateProcedureChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateProcedure,"QualifiedSpname")
#define SQLNodeCreateProcedureChiCodeSpecification $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateProcedure,"CodeSpecification")
 
#define SQLNodeCreateQuery $$$CPTIXNODER("SQL","CreateQuery")
#define SQLNodeCreateQueryChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateQuery,"QualifiedSpname")
#define SQLNodeCreateQueryChiCodeSpecification $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateQuery,"CodeSpecification")
 
#define SQLNodeCreateRole $$$CPTIXNODER("SQL","CreateRole")
#define SQLNodeCreateRoleChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateRole,"Ident")
 
#define SQLNodeCreateTable $$$CPTIXNODER("SQL","CreateTable")
#define SQLNodeCreateTableAnnTableScope $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateTable,"TableScope")
#define SQLNodeCreateTableAnnLockMode $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateTable,"LockMode")
#define SQLNodeCreateTableChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTable,"Tname")
#define SQLNodeCreateTableChiTelemList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTable,"TelemList")
#define SQLNodeCreateTableChiInOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTable,"InOn")
#define SQLNodeCreateTableChiTextimageOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTable,"TextimageOn")
#define SQLNodeCreateTableChiExtentSize $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTable,"ExtentSize")
#define SQLNodeCreateTableChiNextSize $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTable,"NextSize")
 
#define SQLNodeCreateTrigger $$$CPTIXNODER("SQL","CreateTrigger")
#define SQLNodeCreateTriggerAnnBeforeAfter $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateTrigger,"BeforeAfter")
#define SQLNodeCreateTriggerAnnOrderIndex $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateTrigger,"OrderIndex")
#define SQLNodeCreateTriggerChiTriggerName $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTrigger,"TriggerName")
#define SQLNodeCreateTriggerChiTriggerEvent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTrigger,"TriggerEvent")
#define SQLNodeCreateTriggerChiOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTrigger,"On")
#define SQLNodeCreateTriggerChiReferencing $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTrigger,"Referencing")
#define SQLNodeCreateTriggerChiTriggeredAction1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateTrigger,"TriggeredAction1")
 
#define SQLNodeCreateUser $$$CPTIXNODER("SQL","CreateUser")
#define SQLNodeCreateUserChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUser,"Ident")
#define SQLNodeCreateUserChiIdentifiedBy $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUser,"IdentifiedBy")
#define SQLNodeCreateUserChiCreateUserDefault $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUser,"CreateUserDefault")
#define SQLNodeCreateUserChiCreateUserTemporary $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUser,"CreateUserTemporary")
 
#define SQLNodeCreateUserDefault $$$CPTIXNODER("SQL","CreateUserDefault")
#define SQLNodeCreateUserDefaultChiIdent1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUserDefault,"Ident1")
#define SQLNodeCreateUserDefaultChiIdent2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUserDefault,"Ident2")
 
#define SQLNodeCreateUserTemporary $$$CPTIXNODER("SQL","CreateUserTemporary")
#define SQLNodeCreateUserTemporaryChiIdent1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUserTemporary,"Ident1")
#define SQLNodeCreateUserTemporaryChiIdent2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateUserTemporary,"Ident2")
 
#define SQLNodeCreateView $$$CPTIXNODER("SQL","CreateView")
#define SQLNodeCreateViewAnnOrReplace $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateView,"OrReplace")
#define SQLNodeCreateViewChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateView,"Tname")
#define SQLNodeCreateViewChiIdentList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateView,"IdentList")
#define SQLNodeCreateViewChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateView,"Query")
#define SQLNodeCreateViewChiCreateViewWith $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateView,"CreateViewWith")
 
#define SQLNodeCreateViewWithCheckOption $$$CPTIXNODER("SQL","CreateViewWithCheckOption")
#define SQLNodeCreateViewWithCheckOptionAnnLevelsClause $$$CPTIXNODEANNR("SQL",$$$SQLNodeCreateViewWithCheckOption,"LevelsClause")
#define SQLNodeCreateViewWithCheckOptionChiConstraint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCreateViewWithCheckOption,"Constraint")
 
#define SQLNodeCreateViewWithReadOnly $$$CPTIXNODER("SQL","CreateViewWithReadOnly")
 
#define SQLNodeCrossJoin $$$CPTIXNODER("SQL","CrossJoin")
#define SQLNodeCrossJoinChiJtab $$$CPTIXNODECHILDR("SQL",$$$SQLNodeCrossJoin,"Jtab")
 
#define SQLNodeCurrentDate $$$CPTIXNODER("SQL","CurrentDate")
 
#define SQLNodeDataType $$$CPTIXNODER("SQL","DataType")
#define SQLNodeDataTypeAnnCompleteDataType $$$CPTIXNODEANNR("SQL",$$$SQLNodeDataType,"CompleteDataType")
 
#define SQLNodeDatePart1Scalx $$$CPTIXNODER("SQL","DatePart1Scalx")
#define SQLNodeDatePart1ScalxChiDatePart $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatePart1Scalx,"DatePart")
#define SQLNodeDatePart1ScalxChiValue $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatePart1Scalx,"Value")
 
#define SQLNodeDatePart2Scalx $$$CPTIXNODER("SQL","DatePart2Scalx")
#define SQLNodeDatePart2ScalxChiDatePart $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatePart2Scalx,"DatePart")
#define SQLNodeDatePart2ScalxChiValue1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatePart2Scalx,"Value1")
#define SQLNodeDatePart2ScalxChiValue2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatePart2Scalx,"Value2")
 
#define SQLNodeDatePartKeyword $$$CPTIXNODER("SQL","DatePartKeyword")
#define SQLNodeDatePartKeywordAnnDatePartName $$$CPTIXNODEANNR("SQL",$$$SQLNodeDatePartKeyword,"DatePartName")
 
#define SQLNodeDatyp $$$CPTIXNODER("SQL","Datyp")
#define SQLNodeDatypChiDatypSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatyp,"DatypSpec")
#define SQLNodeDatypChiDatypParen $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDatyp,"DatypParen")
 
#define SQLNodeDatypParen $$$CPTIXNODER("SQL","DatypParen")
#define SQLNodeDatypParenAnnInsideParen $$$CPTIXNODEANNR("SQL",$$$SQLNodeDatypParen,"InsideParen")
 
#define SQLNodeDecl $$$CPTIXNODER("SQL","Decl")
#define SQLNodeDeclChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDecl,"Ident")
#define SQLNodeDeclChiSelct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDecl,"Selct")
#define SQLNodeDeclChiUpdtcls $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDecl,"Updtcls")
 
#define SQLNodeDefSpecCOS $$$CPTIXNODER("SQL","DefSpecCOS")
#define SQLNodeDefSpecCOSChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDefSpecCOS,"Literal")
 
#define SQLNodeDefSpecCTS $$$CPTIXNODER("SQL","DefSpecCTS")
#define SQLNodeDefSpecCTSAnnValue $$$CPTIXNODEANNR("SQL",$$$SQLNodeDefSpecCTS,"Value")
 
#define SQLNodeDefSpecEnv $$$CPTIXNODER("SQL","DefSpecEnv")
#define SQLNodeDefSpecEnvAnnEnvKeyword $$$CPTIXNODEANNR("SQL",$$$SQLNodeDefSpecEnv,"EnvKeyword")
 
#define SQLNodeDefSpecTD $$$CPTIXNODER("SQL","DefSpecTD")
#define SQLNodeDefSpecTDChiValue1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDefSpecTD,"Value1")
#define SQLNodeDefSpecTDChiValue2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDefSpecTD,"Value2")
 
#define SQLNodeDelet $$$CPTIXNODER("SQL","Delet")
#define SQLNodeDeletChiIud $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDelet,"Iud")
#define SQLNodeDeletChiIUDTarget $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDelet,"IUDTarget")
#define SQLNodeDeletChiSecondary $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDelet,"Secondary")
#define SQLNodeDeletChiWerop $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDelet,"Werop")
 
#define SQLNodeDist $$$CPTIXNODER("SQL","Dist")
#define SQLNodeDistAnnIsDistinct $$$CPTIXNODEANNR("SQL",$$$SQLNodeDist,"IsDistinct")
#define SQLNodeDistChiBy $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDist,"By")
 
#define SQLNodeDropActionColumn $$$CPTIXNODER("SQL","DropActionColumn")
#define SQLNodeDropActionColumnAnnCascadeOpt $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropActionColumn,"CascadeOpt")
#define SQLNodeDropActionColumnAnnDataOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropActionColumn,"DataOption")
#define SQLNodeDropActionColumnChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropActionColumn,"Ident")
 
#define SQLNodeDropActionConstraint $$$CPTIXNODER("SQL","DropActionConstraint")
#define SQLNodeDropActionConstraintChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropActionConstraint,"Ident")
 
#define SQLNodeDropActionForeignKey $$$CPTIXNODER("SQL","DropActionForeignKey")
#define SQLNodeDropActionForeignKeyChiFlist2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropActionForeignKey,"Flist2")
 
#define SQLNodeDropActionPrimaryKey $$$CPTIXNODER("SQL","DropActionPrimaryKey")
 
#define SQLNodeDropDatabase $$$CPTIXNODER("SQL","DropDatabase")
#define SQLNodeDropDatabaseAnnDatabaseName $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropDatabase,"DatabaseName")
#define SQLNodeDropDatabaseAnnRetainFiles $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropDatabase,"RetainFiles")
 
#define SQLNodeDropDef $$$CPTIXNODER("SQL","DropDef")
 
#define SQLNodeDropFunction $$$CPTIXNODER("SQL","DropFunction")
#define SQLNodeDropFunctionChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropFunction,"QualifiedSpname")
#define SQLNodeDropFunctionChiClassname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropFunction,"Classname")
 
#define SQLNodeDropIndex $$$CPTIXNODER("SQL","DropIndex")
#define SQLNodeDropIndexAnnIndexname $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropIndex,"Indexname")
#define SQLNodeDropIndexChiOn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropIndex,"On")
 
#define SQLNodeDropMethod $$$CPTIXNODER("SQL","DropMethod")
#define SQLNodeDropMethodChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropMethod,"QualifiedSpname")
#define SQLNodeDropMethodChiClassname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropMethod,"Classname")
 
#define SQLNodeDropOrReplaceView $$$CPTIXNODER("SQL","DropOrReplaceView")
#define SQLNodeDropOrReplaceViewChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropOrReplaceView,"Tname")
#define SQLNodeDropOrReplaceViewChiIdentList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropOrReplaceView,"IdentList")
#define SQLNodeDropOrReplaceViewChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropOrReplaceView,"Query")
#define SQLNodeDropOrReplaceViewChiAlterViewWith $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropOrReplaceView,"AlterViewWith")
 
#define SQLNodeDropProcedure $$$CPTIXNODER("SQL","DropProcedure")
#define SQLNodeDropProcedureChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropProcedure,"QualifiedSpname")
#define SQLNodeDropProcedureChiClassname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropProcedure,"Classname")
 
#define SQLNodeDropQuery $$$CPTIXNODER("SQL","DropQuery")
#define SQLNodeDropQueryChiQualifiedSpname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropQuery,"QualifiedSpname")
#define SQLNodeDropQueryChiClassname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropQuery,"Classname")
 
#define SQLNodeDropRole $$$CPTIXNODER("SQL","DropRole")
#define SQLNodeDropRoleChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropRole,"Ident")
 
#define SQLNodeDropTable $$$CPTIXNODER("SQL","DropTable")
#define SQLNodeDropTableAnnCascadeOpt $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropTable,"CascadeOpt")
#define SQLNodeDropTableAnnDataOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropTable,"DataOption")
#define SQLNodeDropTableChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropTable,"Tname")
 
#define SQLNodeDropTrigger $$$CPTIXNODER("SQL","DropTrigger")
#define SQLNodeDropTriggerChiTriggerName $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropTrigger,"TriggerName")
#define SQLNodeDropTriggerChiFrom $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropTrigger,"From")
 
#define SQLNodeDropUser $$$CPTIXNODER("SQL","DropUser")
#define SQLNodeDropUserAnnCascade $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropUser,"Cascade")
#define SQLNodeDropUserChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropUser,"Ident")
 
#define SQLNodeDropView $$$CPTIXNODER("SQL","DropView")
#define SQLNodeDropViewAnnCascadeOpt $$$CPTIXNODEANNR("SQL",$$$SQLNodeDropView,"CascadeOpt")
#define SQLNodeDropViewChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDropView,"Tname")
 
#define SQLNodeDtsVal $$$CPTIXNODER("SQL","DtsVal")
#define SQLNodeDtsValAnnDts $$$CPTIXNODEANNR("SQL",$$$SQLNodeDtsVal,"Dts")
#define SQLNodeDtsValChiValSpec1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeDtsVal,"ValSpec1")
 
#define SQLNodeFetch $$$CPTIXNODER("SQL","Fetch")
#define SQLNodeFetchChiRowCount $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFetch,"RowCount")
#define SQLNodeFetchChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFetch,"Ident")
#define SQLNodeFetchChiHostList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFetch,"HostList")
 
#define SQLNodeFirstTableHint $$$CPTIXNODER("SQL","FirstTableHint")
#define SQLNodeFirstTableHintAnnSimpleName $$$CPTIXNODEANNR("SQL",$$$SQLNodeFirstTableHint,"SimpleName")
 
#define SQLNodeFldQualifierCalculated $$$CPTIXNODER("SQL","FldQualifierCalculated")
 
#define SQLNodeFldQualifierCharacterSet $$$CPTIXNODER("SQL","FldQualifierCharacterSet")
#define SQLNodeFldQualifierCharacterSetChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierCharacterSet,"Ident")
 
#define SQLNodeFldQualifierCheck $$$CPTIXNODER("SQL","FldQualifierCheck")
#define SQLNodeFldQualifierCheckChiCheckCnstr $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierCheck,"CheckCnstr")
 
#define SQLNodeFldQualifierComputeCode $$$CPTIXNODER("SQL","FldQualifierComputeCode")
#define SQLNodeFldQualifierComputeCodeChiCodeLines $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierComputeCode,"CodeLines")
 
#define SQLNodeFldQualifierComputeOnChange $$$CPTIXNODER("SQL","FldQualifierComputeOnChange")
 
#define SQLNodeFldQualifierConstraint $$$CPTIXNODER("SQL","FldQualifierConstraint")
#define SQLNodeFldQualifierConstraintChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierConstraint,"Tname")
#define SQLNodeFldQualifierConstraintChiNamedFconSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierConstraint,"NamedFconSpec")
 
#define SQLNodeFldQualifierDefault $$$CPTIXNODER("SQL","FldQualifierDefault")
#define SQLNodeFldQualifierDefaultChiDefSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierDefault,"DefSpec")
 
#define SQLNodeFldQualifierDescription $$$CPTIXNODER("SQL","FldQualifierDescription")
#define SQLNodeFldQualifierDescriptionChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierDescription,"Literal")
 
#define SQLNodeFldQualifierList $$$CPTIXNODER("SQL","FldQualifierList")
 
#define SQLNodeFldQualifierPKU $$$CPTIXNODER("SQL","FldQualifierPKU")
#define SQLNodeFldQualifierPKUAnnPKU $$$CPTIXNODEANNR("SQL",$$$SQLNodeFldQualifierPKU,"PKU")
#define SQLNodeFldQualifierPKUAnnClustered $$$CPTIXNODEANNR("SQL",$$$SQLNodeFldQualifierPKU,"Clustered")
 
#define SQLNodeFldQualifierReferences $$$CPTIXNODER("SQL","FldQualifierReferences")
#define SQLNodeFldQualifierReferencesChiRef $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFldQualifierReferences,"Ref")
 
#define SQLNodeFldQualifierTransient $$$CPTIXNODER("SQL","FldQualifierTransient")
 
#define SQLNodeFlist1 $$$CPTIXNODER("SQL","Flist1")
 
#define SQLNodeFlist2 $$$CPTIXNODER("SQL","Flist2")
#define SQLNodeFlist2ChiIdentList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFlist2,"IdentList")
#define SQLNodeFlist2ChiFlist1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFlist2,"Flist1")
 
#define SQLNodeFrmitQuery $$$CPTIXNODER("SQL","FrmitQuery")
#define SQLNodeFrmitQueryChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFrmitQuery,"Query")
#define SQLNodeFrmitQueryChiAs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFrmitQuery,"As")
 
#define SQLNodeFrmitTable $$$CPTIXNODER("SQL","FrmitTable")
#define SQLNodeFrmitTableChiTable $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFrmitTable,"Table")
#define SQLNodeFrmitTableChiAs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFrmitTable,"As")
 
#define SQLNodeFromClause $$$CPTIXNODER("SQL","FromClause")
#define SQLNodeFromClauseChiFromHints $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFromClause,"FromHints")
#define SQLNodeFromClauseChiTables $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFromClause,"Tables")
 
#define SQLNodeFromHints $$$CPTIXNODER("SQL","FromHints")
#define SQLNodeFromHintsAnnpcALLINDEX $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcALLINDEX")
#define SQLNodeFromHintsAnnpcDBUGFULL $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcDBUGFULL")
#define SQLNodeFromHintsAnnpcFLATTEN $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcFLATTEN")
#define SQLNodeFromHintsAnnpcFULL $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcFULL")
#define SQLNodeFromHintsAnnpcINORDER $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcINORDER")
#define SQLNodeFromHintsAnnpcNOFACTORANDFROMOR $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOFACTORANDFROMOR")
#define SQLNodeFromHintsAnnpcNOFACTORORDERBYOR $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOFACTORORDERBYOR")
#define SQLNodeFromHintsAnnpcNOFLATTEN $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOFLATTEN")
#define SQLNodeFromHintsAnnpcNOMERGE $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOMERGE")
#define SQLNodeFromHintsAnnpcNOMERGEEQUIVAGG $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOMERGEEQUIVAGG")
#define SQLNodeFromHintsAnnpcNOSVSO $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOSVSO")
#define SQLNodeFromHintsAnnpcNOTOPOPT $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOTOPOPT")
#define SQLNodeFromHintsAnnpcNOUNIONOROPT $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOUNIONOROPT")
#define SQLNodeFromHintsAnnpcSTARTTABLE $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcSTARTTABLE")
#define SQLNodeFromHintsAnnpcNOREDUCE $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOREDUCE")
#define SQLNodeFromHintsAnnpcPARALLEL $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcPARALLEL")
#define SQLNodeFromHintsAnnpcNOPARALLEL $$$CPTIXNODEANNR("SQL",$$$SQLNodeFromHints,"pcNOPARALLEL")
#define SQLNodeFromHintsChiFirstTableHint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFromHints,"FirstTableHint")
#define SQLNodeFromHintsChiIgnoreIndexHint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeFromHints,"IgnoreIndexHint")
 
#define SQLNodeGet $$$CPTIXNODER("SQL","Get")
#define SQLNodeGetChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGet,"Ident")
#define SQLNodeGetChiVar $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGet,"Var")
 
#define SQLNodeGrantAccess $$$CPTIXNODER("SQL","GrantAccess")
#define SQLNodeGrantAccessAnnWithGrantOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeGrantAccess,"WithGrantOption")
#define SQLNodeGrantAccessChiAccessList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantAccess,"AccessList")
#define SQLNodeGrantAccessChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantAccess,"Grntee")
 
#define SQLNodeGrantAdminPrivs $$$CPTIXNODER("SQL","GrantAdminPrivs")
#define SQLNodeGrantAdminPrivsAnnWithAdminOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeGrantAdminPrivs,"WithAdminOption")
#define SQLNodeGrantAdminPrivsChiAdminPrivList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantAdminPrivs,"AdminPrivList")
#define SQLNodeGrantAdminPrivsChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantAdminPrivs,"Grntee")
 
#define SQLNodeGrantRole $$$CPTIXNODER("SQL","GrantRole")
#define SQLNodeGrantRoleAnnWithAdminOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeGrantRole,"WithAdminOption")
#define SQLNodeGrantRoleChiRoles $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantRole,"Roles")
#define SQLNodeGrantRoleChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantRole,"Grntee")
 
#define SQLNodeGrantSimplePrivs $$$CPTIXNODER("SQL","GrantSimplePrivs")
#define SQLNodeGrantSimplePrivsAnnWithGrantOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeGrantSimplePrivs,"WithGrantOption")
#define SQLNodeGrantSimplePrivsChiSimplePrivs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantSimplePrivs,"SimplePrivs")
#define SQLNodeGrantSimplePrivsChiObjcts $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantSimplePrivs,"Objcts")
#define SQLNodeGrantSimplePrivsChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantSimplePrivs,"Grntee")
 
#define SQLNodeGrantThreshold $$$CPTIXNODER("SQL","GrantThreshold")
#define SQLNodeGrantThresholdAnnWithAdminOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeGrantThreshold,"WithAdminOption")
#define SQLNodeGrantThresholdChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantThreshold,"Literal")
#define SQLNodeGrantThresholdChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantThreshold,"Grntee")
 
#define SQLNodeGrantedOptionAccess $$$CPTIXNODER("SQL","GrantedOptionAccess")
#define SQLNodeGrantedOptionAccessChiAccessList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionAccess,"AccessList")
#define SQLNodeGrantedOptionAccessChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionAccess,"Grntee")
 
#define SQLNodeGrantedOptionSimplePrivs $$$CPTIXNODER("SQL","GrantedOptionSimplePrivs")
#define SQLNodeGrantedOptionSimplePrivsAnnCascadeOpt $$$CPTIXNODEANNR("SQL",$$$SQLNodeGrantedOptionSimplePrivs,"CascadeOpt")
#define SQLNodeGrantedOptionSimplePrivsChiSimplePrivs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionSimplePrivs,"SimplePrivs")
#define SQLNodeGrantedOptionSimplePrivsChiObjcts $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionSimplePrivs,"Objcts")
#define SQLNodeGrantedOptionSimplePrivsChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionSimplePrivs,"Grntee")
#define SQLNodeGrantedOptionSimplePrivsChiAs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionSimplePrivs,"As")
 
#define SQLNodeGrantedOptionThreshold $$$CPTIXNODER("SQL","GrantedOptionThreshold")
#define SQLNodeGrantedOptionThresholdChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeGrantedOptionThreshold,"Grntee")
 
#define SQLNodeGroup $$$CPTIXNODER("SQL","Group")
 
#define SQLNodeHaving $$$CPTIXNODER("SQL","Having")
#define SQLNodeHavingChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeHaving,"Prdct")
 
#define SQLNodeHostList $$$CPTIXNODER("SQL","HostList")
 
#define SQLNodeHostVar $$$CPTIXNODER("SQL","HostVar")
#define SQLNodeHostVarChiHostRef $$$CPTIXNODECHILDR("SQL",$$$SQLNodeHostVar,"HostRef")
#define SQLNodeHostVarChiSubList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeHostVar,"SubList")
 
#define SQLNodeIUDTarget $$$CPTIXNODER("SQL","IUDTarget")
#define SQLNodeIUDTargetChiTnameOrQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeIUDTarget,"TnameOrQuery")
#define SQLNodeIUDTargetChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeIUDTarget,"Ident")
 
#define SQLNodeIdSpecList $$$CPTIXNODER("SQL","IdSpecList")
 
#define SQLNodeIdent $$$CPTIXNODER("SQL","Ident")
#define SQLNodeIdentAnnName $$$CPTIXNODEANNR("SQL",$$$SQLNodeIdent,"Name")
 
#define SQLNodeIdentList $$$CPTIXNODER("SQL","IdentList")
 
#define SQLNodeIdentity $$$CPTIXNODER("SQL","Identity")
#define SQLNodeIdentityAnnSeed $$$CPTIXNODEANNR("SQL",$$$SQLNodeIdentity,"Seed")
#define SQLNodeIdentityAnnIncrement $$$CPTIXNODEANNR("SQL",$$$SQLNodeIdentity,"Increment")
 
#define SQLNodeIgnoreIndexHint $$$CPTIXNODER("SQL","IgnoreIndexHint")
 
#define SQLNodeIndexQualifiers $$$CPTIXNODER("SQL","IndexQualifiers")
#define SQLNodeIndexQualifiersAnnIndexQualifierFirst $$$CPTIXNODEANNR("SQL",$$$SQLNodeIndexQualifiers,"IndexQualifierFirst")
#define SQLNodeIndexQualifiersAnnClustered $$$CPTIXNODEANNR("SQL",$$$SQLNodeIndexQualifiers,"Clustered")
 
#define SQLNodeIndexRef $$$CPTIXNODER("SQL","IndexRef")
#define SQLNodeIndexRefAnnName $$$CPTIXNODEANNR("SQL",$$$SQLNodeIndexRef,"Name")
 
#define SQLNodeInsrt $$$CPTIXNODER("SQL","Insrt")
#define SQLNodeInsrtAnnOrUpdate $$$CPTIXNODEANNR("SQL",$$$SQLNodeInsrt,"OrUpdate")
#define SQLNodeInsrtChiIud $$$CPTIXNODECHILDR("SQL",$$$SQLNodeInsrt,"Iud")
#define SQLNodeInsrtChiIUDTarget $$$CPTIXNODECHILDR("SQL",$$$SQLNodeInsrt,"IUDTarget")
#define SQLNodeInsrtChiAsign $$$CPTIXNODECHILDR("SQL",$$$SQLNodeInsrt,"Asign")
 
#define SQLNodeInstanceVariableHostRef $$$CPTIXNODER("SQL","InstanceVariableHostRef")
#define SQLNodeInstanceVariableHostRefAnnHostInstName $$$CPTIXNODEANNR("SQL",$$$SQLNodeInstanceVariableHostRef,"HostInstName")
 
#define SQLNodeIsAllQterm $$$CPTIXNODER("SQL","IsAllQterm")
#define SQLNodeIsAllQtermAnnIsAll $$$CPTIXNODEANNR("SQL",$$$SQLNodeIsAllQterm,"IsAll")
#define SQLNodeIsAllQtermAnnIsParallel $$$CPTIXNODEANNR("SQL",$$$SQLNodeIsAllQterm,"IsParallel")
#define SQLNodeIsAllQtermChiQterm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeIsAllQterm,"Qterm")
 
#define SQLNodeIud $$$CPTIXNODER("SQL","Iud")
#define SQLNodeIudAnnNOCHECK $$$CPTIXNODEANNR("SQL",$$$SQLNodeIud,"NOCHECK")
#define SQLNodeIudAnnNOLOCK $$$CPTIXNODEANNR("SQL",$$$SQLNodeIud,"NOLOCK")
#define SQLNodeIudAnnNOINDEX $$$CPTIXNODEANNR("SQL",$$$SQLNodeIud,"NOINDEX")
#define SQLNodeIudAnnNOTRIGGER $$$CPTIXNODEANNR("SQL",$$$SQLNodeIud,"NOTRIGGER")
 
#define SQLNodeJoins $$$CPTIXNODER("SQL","Joins")
 
#define SQLNodeJspecOn $$$CPTIXNODER("SQL","JspecOn")
#define SQLNodeJspecOnChiJcond $$$CPTIXNODECHILDR("SQL",$$$SQLNodeJspecOn,"Jcond")
 
#define SQLNodeJspecUsing $$$CPTIXNODER("SQL","JspecUsing")
#define SQLNodeJspecUsingChiFlist1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeJspecUsing,"Flist1")
 
#define SQLNodeJtab $$$CPTIXNODER("SQL","Jtab")
#define SQLNodeJtabChiFrmit $$$CPTIXNODECHILDR("SQL",$$$SQLNodeJtab,"Frmit")
#define SQLNodeJtabChiJoins $$$CPTIXNODECHILDR("SQL",$$$SQLNodeJtab,"Joins")
 
#define SQLNodeLanguageClauseCOS $$$CPTIXNODER("SQL","LanguageClauseCOS")
#define SQLNodeLanguageClauseCOSChiCodeLines $$$CPTIXNODECHILDR("SQL",$$$SQLNodeLanguageClauseCOS,"CodeLines")
 
#define SQLNodeLanguageClauseSQL $$$CPTIXNODER("SQL","LanguageClauseSQL")
#define SQLNodeLanguageClauseSQLChiCodeLines $$$CPTIXNODECHILDR("SQL",$$$SQLNodeLanguageClauseSQL,"CodeLines")
 
#define SQLNodeList $$$CPTIXNODER("SQL","List")
 
#define SQLNodeLiteral $$$CPTIXNODER("SQL","Literal")
#define SQLNodeLiteralAnnValue $$$CPTIXNODEANNR("SQL",$$$SQLNodeLiteral,"Value")
 
#define SQLNodeLocalVariableHostRef $$$CPTIXNODER("SQL","LocalVariableHostRef")
#define SQLNodeLocalVariableHostRefAnnHostVarName $$$CPTIXNODEANNR("SQL",$$$SQLNodeLocalVariableHostRef,"HostVarName")
 
#define SQLNodeLocaleOption $$$CPTIXNODER("SQL","LocaleOption")
#define SQLNodeLocaleOptionAnnLocaleSetting $$$CPTIXNODEANNR("SQL",$$$SQLNodeLocaleOption,"LocaleSetting")
#define SQLNodeLocaleOptionChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeLocaleOption,"Literal")
 
#define SQLNodeLock $$$CPTIXNODER("SQL","Lock")
#define SQLNodeLockAnnShareExclusive $$$CPTIXNODEANNR("SQL",$$$SQLNodeLock,"ShareExclusive")
#define SQLNodeLockChiTref $$$CPTIXNODECHILDR("SQL",$$$SQLNodeLock,"Tref")
#define SQLNodeLockChiWait $$$CPTIXNODECHILDR("SQL",$$$SQLNodeLock,"Wait")
 
#define SQLNodeLockTimeout $$$CPTIXNODER("SQL","LockTimeout")
#define SQLNodeLockTimeoutAnnSetting $$$CPTIXNODEANNR("SQL",$$$SQLNodeLockTimeout,"Setting")
 
#define SQLNodeMQCContainId $$$CPTIXNODER("SQL","MQCContainId")
#define SQLNodeMQCContainIdAnnId $$$CPTIXNODEANNR("SQL",$$$SQLNodeMQCContainId,"Id")
 
#define SQLNodeMQCFinal $$$CPTIXNODER("SQL","MQCFinal")
 
#define SQLNodeMQCFor $$$CPTIXNODER("SQL","MQCFor")
#define SQLNodeMQCForChiTable $$$CPTIXNODECHILDR("SQL",$$$SQLNodeMQCFor,"Table")
 
#define SQLNodeMQCPrivate $$$CPTIXNODER("SQL","MQCPrivate")
 
#define SQLNodeMQCProcedure $$$CPTIXNODER("SQL","MQCProcedure")
 
#define SQLNodeMQCResultSets $$$CPTIXNODER("SQL","MQCResultSets")
 
#define SQLNodeMQCResults $$$CPTIXNODER("SQL","MQCResults")
 
#define SQLNodeMQCReturns $$$CPTIXNODER("SQL","MQCReturns")
#define SQLNodeMQCReturnsChiDatyp $$$CPTIXNODECHILDR("SQL",$$$SQLNodeMQCReturns,"Datyp")
 
#define SQLNodeMQCSelectMode $$$CPTIXNODER("SQL","MQCSelectMode")
#define SQLNodeMQCSelectModeAnnSelectMode $$$CPTIXNODEANNR("SQL",$$$SQLNodeMQCSelectMode,"SelectMode")
 
#define SQLNodeMethodQueryCharacteristicsList $$$CPTIXNODER("SQL","MethodQueryCharacteristicsList")
 
#define SQLNodeModCol $$$CPTIXNODER("SQL","ModCol")
#define SQLNodeModColAnnNullNotNull $$$CPTIXNODEANNR("SQL",$$$SQLNodeModCol,"NullNotNull")
#define SQLNodeModColChiDefSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeModCol,"DefSpec")
#define SQLNodeModColChiConstraint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeModCol,"Constraint")
 
#define SQLNodeModSpec $$$CPTIXNODER("SQL","ModSpec")
#define SQLNodeModSpecChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeModSpec,"Ident")
#define SQLNodeModSpecChiDatyp $$$CPTIXNODECHILDR("SQL",$$$SQLNodeModSpec,"Datyp")
#define SQLNodeModSpecChiModCol $$$CPTIXNODECHILDR("SQL",$$$SQLNodeModSpec,"ModCol")
 
#define SQLNodeNamedFconSpecCheck $$$CPTIXNODER("SQL","NamedFconSpecCheck")
#define SQLNodeNamedFconSpecCheckChiChkparse $$$CPTIXNODECHILDR("SQL",$$$SQLNodeNamedFconSpecCheck,"Chkparse")
 
#define SQLNodeNamedFconSpecDefault $$$CPTIXNODER("SQL","NamedFconSpecDefault")
#define SQLNodeNamedFconSpecDefaultChiDefSpec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeNamedFconSpecDefault,"DefSpec")
 
#define SQLNodeNamedFconSpecPKU $$$CPTIXNODER("SQL","NamedFconSpecPKU")
#define SQLNodeNamedFconSpecPKUAnnPKU $$$CPTIXNODEANNR("SQL",$$$SQLNodeNamedFconSpecPKU,"PKU")
#define SQLNodeNamedFconSpecPKUAnnClustered $$$CPTIXNODEANNR("SQL",$$$SQLNodeNamedFconSpecPKU,"Clustered")
 
#define SQLNodeNamedFconSpecReferences $$$CPTIXNODER("SQL","NamedFconSpecReferences")
#define SQLNodeNamedFconSpecReferencesChiRef $$$CPTIXNODECHILDR("SQL",$$$SQLNodeNamedFconSpecReferences,"Ref")
 
#define SQLNodeNaturalJoin $$$CPTIXNODER("SQL","NaturalJoin")
#define SQLNodeNaturalJoinAnnJop $$$CPTIXNODEANNR("SQL",$$$SQLNodeNaturalJoin,"Jop")
#define SQLNodeNaturalJoinChiJtab $$$CPTIXNODECHILDR("SQL",$$$SQLNodeNaturalJoin,"Jtab")
 
#define SQLNodeNegNumber $$$CPTIXNODER("SQL","NegNumber")
#define SQLNodeNegNumberAnnValue $$$CPTIXNODEANNR("SQL",$$$SQLNodeNegNumber,"Value")
 
#define SQLNodeNotNull $$$CPTIXNODER("SQL","NotNull")
 
#define SQLNodeNull $$$CPTIXNODER("SQL","Null")
 
#define SQLNodeObjectKeyword $$$CPTIXNODER("SQL","ObjectKeyword")
#define SQLNodeObjectKeywordAnnKeyword $$$CPTIXNODEANNR("SQL",$$$SQLNodeObjectKeyword,"Keyword")
#define SQLNodeObjectKeywordChiBase $$$CPTIXNODECHILDR("SQL",$$$SQLNodeObjectKeyword,"Base")
 
#define SQLNodeOdbcFunc $$$CPTIXNODER("SQL","OdbcFunc")
#define SQLNodeOdbcFuncAnnFunctionName $$$CPTIXNODEANNR("SQL",$$$SQLNodeOdbcFunc,"FunctionName")
#define SQLNodeOdbcFuncChiOdbcFunctionArgs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOdbcFunc,"OdbcFunctionArgs")
 
#define SQLNodeOldOrNewValuesAlias $$$CPTIXNODER("SQL","OldOrNewValuesAlias")
#define SQLNodeOldOrNewValuesAliasAnnIsNew $$$CPTIXNODEANNR("SQL",$$$SQLNodeOldOrNewValuesAlias,"IsNew")
#define SQLNodeOldOrNewValuesAliasChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOldOrNewValuesAlias,"Ident")
 
#define SQLNodeOldOrNewValuesAliasList $$$CPTIXNODER("SQL","OldOrNewValuesAliasList")
 
#define SQLNodeOpen $$$CPTIXNODER("SQL","Open")
#define SQLNodeOpenChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOpen,"Ident")
 
#define SQLNodeOptScalx $$$CPTIXNODER("SQL","OptScalx")
#define SQLNodeOptScalxChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOptScalx,"Scalx")
 
#define SQLNodeOptScalxList $$$CPTIXNODER("SQL","OptScalxList")
 
#define SQLNodeOption $$$CPTIXNODER("SQL","Option")
#define SQLNodeOptionChiOptionSetting $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOption,"OptionSetting")
 
#define SQLNodeOptionalSqlArgument $$$CPTIXNODER("SQL","OptionalSqlArgument")
#define SQLNodeOptionalSqlArgumentChiSqlArgument $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOptionalSqlArgument,"SqlArgument")
 
#define SQLNodeOptionalValSpec1 $$$CPTIXNODER("SQL","OptionalValSpec1")
#define SQLNodeOptionalValSpec1ChiValSpec1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOptionalValSpec1,"ValSpec1")
 
#define SQLNodeOrder $$$CPTIXNODER("SQL","Order")
 
#define SQLNodeOrdir $$$CPTIXNODER("SQL","Ordir")
#define SQLNodeOrdirAnnAscDesc $$$CPTIXNODEANNR("SQL",$$$SQLNodeOrdir,"AscDesc")
#define SQLNodeOrdirChiOrdit $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOrdir,"Ordit")
 
#define SQLNodeOrdit $$$CPTIXNODER("SQL","Ordit")
#define SQLNodeOrditChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOrdit,"Scalx")
 
#define SQLNodeOtherJoin $$$CPTIXNODER("SQL","OtherJoin")
#define SQLNodeOtherJoinAnnJop $$$CPTIXNODEANNR("SQL",$$$SQLNodeOtherJoin,"Jop")
#define SQLNodeOtherJoinChiJtab $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOtherJoin,"Jtab")
#define SQLNodeOtherJoinChiJspec $$$CPTIXNODECHILDR("SQL",$$$SQLNodeOtherJoin,"Jspec")
 
#define SQLNodeOtherOption $$$CPTIXNODER("SQL","OtherOption")
#define SQLNodeOtherOptionAnnSetting $$$CPTIXNODEANNR("SQL",$$$SQLNodeOtherOption,"Setting")
 
#define SQLNodeParam $$$CPTIXNODER("SQL","Param")
#define SQLNodeParamChiVar $$$CPTIXNODECHILDR("SQL",$$$SQLNodeParam,"Var")
#define SQLNodeParamChiSubList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeParam,"SubList")
 
#define SQLNodeParameterDeclaration $$$CPTIXNODER("SQL","ParameterDeclaration")
#define SQLNodeParameterDeclarationAnnInOut $$$CPTIXNODEANNR("SQL",$$$SQLNodeParameterDeclaration,"InOut")
#define SQLNodeParameterDeclarationChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeParameterDeclaration,"Ident")
#define SQLNodeParameterDeclarationChiDatyp $$$CPTIXNODECHILDR("SQL",$$$SQLNodeParameterDeclaration,"Datyp")
#define SQLNodeParameterDeclarationChiDefaultClause $$$CPTIXNODECHILDR("SQL",$$$SQLNodeParameterDeclaration,"DefaultClause")
 
#define SQLNodeParameterList $$$CPTIXNODER("SQL","ParameterList")
 
#define SQLNodeParameterMarker $$$CPTIXNODER("SQL","ParameterMarker")
 
#define SQLNodeParenPrdct $$$CPTIXNODER("SQL","ParenPrdct")
#define SQLNodeParenPrdctChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeParenPrdct,"Prdct")
 
#define SQLNodePrdct $$$CPTIXNODER("SQL","Prdct")
#define SQLNodePrdctChiAnd $$$CPTIXNODECHILDR("SQL",$$$SQLNodePrdct,"And")
#define SQLNodePrdctChiPrdctTail $$$CPTIXNODECHILDR("SQL",$$$SQLNodePrdct,"PrdctTail")
 
#define SQLNodePrdctTail $$$CPTIXNODER("SQL","PrdctTail")
 
#define SQLNodePrdctTailTerm $$$CPTIXNODER("SQL","PrdctTailTerm")
#define SQLNodePrdctTailTermAnnOrOperator $$$CPTIXNODEANNR("SQL",$$$SQLNodePrdctTailTerm,"OrOperator")
#define SQLNodePrdctTailTermChiAnd $$$CPTIXNODECHILDR("SQL",$$$SQLNodePrdctTailTerm,"And")
 
#define SQLNodePrivSpecAction $$$CPTIXNODER("SQL","PrivSpecAction")
#define SQLNodePrivSpecActionAnnAction $$$CPTIXNODEANNR("SQL",$$$SQLNodePrivSpecAction,"Action")
#define SQLNodePrivSpecActionChiFlist1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodePrivSpecAction,"Flist1")
 
#define SQLNodePrivSpecThreshold $$$CPTIXNODER("SQL","PrivSpecThreshold")
 
#define SQLNodeQualifiedName $$$CPTIXNODER("SQL","QualifiedName")
#define SQLNodeQualifiedNameAnnName $$$CPTIXNODEANNR("SQL",$$$SQLNodeQualifiedName,"Name")
 
#define SQLNodeQualifiedSpname $$$CPTIXNODER("SQL","QualifiedSpname")
#define SQLNodeQualifiedSpnameAnnCompleteName $$$CPTIXNODEANNR("SQL",$$$SQLNodeQualifiedSpname,"CompleteName")
 
#define SQLNodeQuery $$$CPTIXNODER("SQL","Query")
#define SQLNodeQueryChiQterm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeQuery,"Qterm")
#define SQLNodeQueryChiQueryTail $$$CPTIXNODECHILDR("SQL",$$$SQLNodeQuery,"QueryTail")
 
#define SQLNodeQueryTail $$$CPTIXNODER("SQL","QueryTail")
 
#define SQLNodeRef $$$CPTIXNODER("SQL","Ref")
#define SQLNodeRefAnnMatch $$$CPTIXNODEANNR("SQL",$$$SQLNodeRef,"Match")
#define SQLNodeRefChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRef,"Tname")
#define SQLNodeRefChiFlist1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRef,"Flist1")
#define SQLNodeRefChiTriggeredAction2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRef,"TriggeredAction2")
 
#define SQLNodeReferenceVariableHostRef $$$CPTIXNODER("SQL","ReferenceVariableHostRef")
#define SQLNodeReferenceVariableHostRefAnnHostRefvarName $$$CPTIXNODEANNR("SQL",$$$SQLNodeReferenceVariableHostRef,"HostRefvarName")
 
#define SQLNodeResultColumn $$$CPTIXNODER("SQL","ResultColumn")
#define SQLNodeResultColumnChiColmn $$$CPTIXNODECHILDR("SQL",$$$SQLNodeResultColumn,"Colmn")
#define SQLNodeResultColumnChiDatyp $$$CPTIXNODECHILDR("SQL",$$$SQLNodeResultColumn,"Datyp")
 
#define SQLNodeRevokeAdminPrivs $$$CPTIXNODER("SQL","RevokeAdminPrivs")
#define SQLNodeRevokeAdminPrivsChiAdminPrivList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRevokeAdminPrivs,"AdminPrivList")
#define SQLNodeRevokeAdminPrivsChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRevokeAdminPrivs,"Grntee")
 
#define SQLNodeRevokeGrantedOption $$$CPTIXNODER("SQL","RevokeGrantedOption")
#define SQLNodeRevokeGrantedOptionChiGrantedOption $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRevokeGrantedOption,"GrantedOption")
 
#define SQLNodeRevokeRole $$$CPTIXNODER("SQL","RevokeRole")
#define SQLNodeRevokeRoleChiRoles $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRevokeRole,"Roles")
#define SQLNodeRevokeRoleChiGrntee $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRevokeRole,"Grntee")
 
#define SQLNodeRollb $$$CPTIXNODER("SQL","Rollb")
#define SQLNodeRollbAnnToSavepoint $$$CPTIXNODEANNR("SQL",$$$SQLNodeRollb,"ToSavepoint")
#define SQLNodeRollbChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeRollb,"Ident")
 
#define SQLNodeSQLMethodBody $$$CPTIXNODER("SQL","SQLMethodBody")
 
#define SQLNodeSavePoint $$$CPTIXNODER("SQL","SavePoint")
#define SQLNodeSavePointChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSavePoint,"Ident")
 
#define SQLNodeScalarFunction $$$CPTIXNODER("SQL","ScalarFunction")
#define SQLNodeScalarFunctionAnnFunctionName $$$CPTIXNODEANNR("SQL",$$$SQLNodeScalarFunction,"FunctionName")
#define SQLNodeScalarFunctionChiScalarFunctionArgs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalarFunction,"ScalarFunctionArgs")
 
#define SQLNodeScalx $$$CPTIXNODER("SQL","Scalx")
#define SQLNodeScalxChiTerm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalx,"Term")
#define SQLNodeScalxChiScalxTail $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalx,"ScalxTail")
 
#define SQLNodeScalxAsCastType $$$CPTIXNODER("SQL","ScalxAsCastType")
#define SQLNodeScalxAsCastTypeChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxAsCastType,"Scalx")
#define SQLNodeScalxAsCastTypeChiCast $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxAsCastType,"Cast")
 
#define SQLNodeScalxConvertType $$$CPTIXNODER("SQL","ScalxConvertType")
#define SQLNodeScalxConvertTypeAnnConvertType $$$CPTIXNODEANNR("SQL",$$$SQLNodeScalxConvertType,"ConvertType")
#define SQLNodeScalxConvertTypeChiValue $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxConvertType,"Value")
 
#define SQLNodeScalxInScalx $$$CPTIXNODER("SQL","ScalxInScalx")
#define SQLNodeScalxInScalxChiValue1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxInScalx,"Value1")
#define SQLNodeScalxInScalxChiValue2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxInScalx,"Value2")
 
#define SQLNodeScalxOptAS $$$CPTIXNODER("SQL","ScalxOptAS")
#define SQLNodeScalxOptASChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxOptAS,"Scalx")
#define SQLNodeScalxOptASChiAs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxOptAS,"As")
 
#define SQLNodeScalxOptASList $$$CPTIXNODER("SQL","ScalxOptASList")
 
#define SQLNodeScalxTail $$$CPTIXNODER("SQL","ScalxTail")
 
#define SQLNodeScalxTailTerm $$$CPTIXNODER("SQL","ScalxTailTerm")
#define SQLNodeScalxTailTermAnnScalop $$$CPTIXNODEANNR("SQL",$$$SQLNodeScalxTailTerm,"Scalop")
#define SQLNodeScalxTailTermChiTerm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeScalxTailTerm,"Term")
 
#define SQLNodeSchemaList $$$CPTIXNODER("SQL","SchemaList")
 
#define SQLNodeSelct $$$CPTIXNODER("SQL","Selct")
#define SQLNodeSelctChiQuery $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelct,"Query")
#define SQLNodeSelctChiOrder $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelct,"Order")
 
#define SQLNodeSelectList $$$CPTIXNODER("SQL","SelectList")
 
#define SQLNodeSelex $$$CPTIXNODER("SQL","Selex")
#define SQLNodeSelexChiSelst $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelex,"Selst")
#define SQLNodeSelexChiFromClause $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelex,"FromClause")
#define SQLNodeSelexChiWhereClause $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelex,"WhereClause")
#define SQLNodeSelexChiGroup $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelex,"Group")
#define SQLNodeSelexChiHaving $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelex,"Having")
#define SQLNodeSelexChiOrder $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelex,"Order")
 
#define SQLNodeSelst $$$CPTIXNODER("SQL","Selst")
#define SQLNodeSelstAnnPercentNolock $$$CPTIXNODEANNR("SQL",$$$SQLNodeSelst,"PercentNolock")
#define SQLNodeSelstChiDist $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelst,"Dist")
#define SQLNodeSelstChiTopClause $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelst,"TopClause")
#define SQLNodeSelstChiSelectList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelst,"SelectList")
#define SQLNodeSelstChiInto $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSelst,"Into")
 
#define SQLNodeSettp $$$CPTIXNODER("SQL","Settp")
#define SQLNodeSettpAnnCommitMode $$$CPTIXNODEANNR("SQL",$$$SQLNodeSettp,"CommitMode")
 
#define SQLNodeSimplePriv $$$CPTIXNODER("SQL","SimplePriv")
#define SQLNodeSimplePrivAnnName $$$CPTIXNODEANNR("SQL",$$$SQLNodeSimplePriv,"Name")
 
#define SQLNodeSimplePrivList $$$CPTIXNODER("SQL","SimplePrivList")
 
#define SQLNodeSql $$$CPTIXNODER("SQL","Sql")
#define SQLNodeSqlChiViewColumnList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSql,"ViewColumnList")
#define SQLNodeSqlChiStatPart $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSql,"StatPart")
 
#define SQLNodeSqlArgumentList $$$CPTIXNODER("SQL","SqlArgumentList")
 
#define SQLNodeSqlStatementBlock $$$CPTIXNODER("SQL","SqlStatementBlock")
#define SQLNodeSqlStatementBlockAnnAtomic $$$CPTIXNODEANNR("SQL",$$$SQLNodeSqlStatementBlock,"Atomic")
 
#define SQLNodeSqlcollation $$$CPTIXNODER("SQL","Sqlcollation")
#define SQLNodeSqlcollationAnnSqlcollationType $$$CPTIXNODEANNR("SQL",$$$SQLNodeSqlcollation,"SqlcollationType")
#define SQLNodeSqlcollationChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSqlcollation,"Literal")
 
#define SQLNodeStar $$$CPTIXNODER("SQL","Star")
 
#define SQLNodeStarttp $$$CPTIXNODER("SQL","Starttp")
#define SQLNodeStarttpAnnTpOption $$$CPTIXNODEANNR("SQL",$$$SQLNodeStarttp,"TpOption")
 
#define SQLNodeStringOperation $$$CPTIXNODER("SQL","StringOperation")
#define SQLNodeStringOperationAnnStringOp $$$CPTIXNODEANNR("SQL",$$$SQLNodeStringOperation,"StringOp")
#define SQLNodeStringOperationChiStringOperationTerm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeStringOperation,"StringOperationTerm")
 
#define SQLNodeStringOperationLT $$$CPTIXNODER("SQL","StringOperationLT")
#define SQLNodeStringOperationLTChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeStringOperationLT,"Literal")
#define SQLNodeStringOperationLTChiTerm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeStringOperationLT,"Term")
 
#define SQLNodeStringOperationSL $$$CPTIXNODER("SQL","StringOperationSL")
#define SQLNodeStringOperationSLChiScalx $$$CPTIXNODECHILDR("SQL",$$$SQLNodeStringOperationSL,"Scalx")
#define SQLNodeStringOperationSLChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeStringOperationSL,"Literal")
 
#define SQLNodeSubList $$$CPTIXNODER("SQL","SubList")
 
#define SQLNodeSubstringArgs $$$CPTIXNODER("SQL","SubstringArgs")
#define SQLNodeSubstringArgsChiBase $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSubstringArgs,"Base")
#define SQLNodeSubstringArgsChiStart $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSubstringArgs,"Start")
#define SQLNodeSubstringArgsChiLength $$$CPTIXNODECHILDR("SQL",$$$SQLNodeSubstringArgs,"Length")
 
#define SQLNodeTableValuedFunction $$$CPTIXNODER("SQL","TableValuedFunction")
#define SQLNodeTableValuedFunctionChiQualifiedName $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTableValuedFunction,"QualifiedName")
#define SQLNodeTableValuedFunctionChiTableValuedFunctionArgumentList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTableValuedFunction,"TableValuedFunctionArgumentList")
#define SQLNodeTableValuedFunctionChiAs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTableValuedFunction,"As")
 
#define SQLNodeTableValuedFunctionArgumentList $$$CPTIXNODER("SQL","TableValuedFunctionArgumentList")
 
#define SQLNodeTables $$$CPTIXNODER("SQL","Tables")
#define SQLNodeTablesChiCSPOrPPTables $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTables,"CSPOrPPTables")
#define SQLNodeTablesChiTrefList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTables,"TrefList")
 
#define SQLNodeTecdef $$$CPTIXNODER("SQL","Tecdef")
#define SQLNodeTecdefChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTecdef,"Ident")
#define SQLNodeTecdefChiDatyp $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTecdef,"Datyp")
#define SQLNodeTecdefChiIdentity $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTecdef,"Identity")
#define SQLNodeTecdefChiFldQualifierList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTecdef,"FldQualifierList")
 
#define SQLNodeTelem $$$CPTIXNODER("SQL","Telem")
#define SQLNodeTelemChiConstraint $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelem,"Constraint")
#define SQLNodeTelemChiTelemOption $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelem,"TelemOption")
 
#define SQLNodeTelemList $$$CPTIXNODER("SQL","TelemList")
 
#define SQLNodeTelemOptionClassParameter $$$CPTIXNODER("SQL","TelemOptionClassParameter")
#define SQLNodeTelemOptionClassParameterChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionClassParameter,"Ident")
#define SQLNodeTelemOptionClassParameterChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionClassParameter,"Literal")
 
#define SQLNodeTelemOptionForeignKey $$$CPTIXNODER("SQL","TelemOptionForeignKey")
#define SQLNodeTelemOptionForeignKeyChiFlist2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionForeignKey,"Flist2")
#define SQLNodeTelemOptionForeignKeyChiRef $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionForeignKey,"Ref")
 
#define SQLNodeTelemOptionPKU $$$CPTIXNODER("SQL","TelemOptionPKU")
#define SQLNodeTelemOptionPKUAnnPKU $$$CPTIXNODEANNR("SQL",$$$SQLNodeTelemOptionPKU,"PKU")
#define SQLNodeTelemOptionPKUAnnClustered $$$CPTIXNODEANNR("SQL",$$$SQLNodeTelemOptionPKU,"Clustered")
#define SQLNodeTelemOptionPKUChiFlist2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionPKU,"Flist2")
#define SQLNodeTelemOptionPKUChiWithFillFactor $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionPKU,"WithFillFactor")
 
#define SQLNodeTelemOptionPercent $$$CPTIXNODER("SQL","TelemOptionPercent")
#define SQLNodeTelemOptionPercentAnnTelemOptionPercentKWs $$$CPTIXNODEANNR("SQL",$$$SQLNodeTelemOptionPercent,"TelemOptionPercentKWs")
#define SQLNodeTelemOptionPercentChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTelemOptionPercent,"Literal")
 
#define SQLNodeTelemOptionPublicRowid $$$CPTIXNODER("SQL","TelemOptionPublicRowid")
 
#define SQLNodeTname $$$CPTIXNODER("SQL","Tname")
#define SQLNodeTnameChiQualifiedName $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTname,"QualifiedName")
 
#define SQLNodeTnameList $$$CPTIXNODER("SQL","TnameList")
 
#define SQLNodeTnameOptAlias $$$CPTIXNODER("SQL","TnameOptAlias")
#define SQLNodeTnameOptAliasChiQualifiedName $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTnameOptAlias,"QualifiedName")
#define SQLNodeTnameOptAliasChiAlias $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTnameOptAlias,"Alias")
 
#define SQLNodeTnameQualifierDropExisting $$$CPTIXNODER("SQL","TnameQualifierDropExisting")
 
#define SQLNodeTnameQualifierFillFactor $$$CPTIXNODER("SQL","TnameQualifierFillFactor")
#define SQLNodeTnameQualifierFillFactorChiLiteral $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTnameQualifierFillFactor,"Literal")
 
#define SQLNodeTnameQualifierIgnoreDupKey $$$CPTIXNODER("SQL","TnameQualifierIgnoreDupKey")
 
#define SQLNodeTnameQualifierPadIndex $$$CPTIXNODER("SQL","TnameQualifierPadIndex")
 
#define SQLNodeTnameQualifierStatisticsNoRecompute $$$CPTIXNODER("SQL","TnameQualifierStatisticsNoRecompute")
 
#define SQLNodeTnameQualifiers $$$CPTIXNODER("SQL","TnameQualifiers")
 
#define SQLNodeTopAll $$$CPTIXNODER("SQL","TopAll")
 
#define SQLNodeTopClause $$$CPTIXNODER("SQL","TopClause")
#define SQLNodeTopClauseAnnParenCount $$$CPTIXNODEANNR("SQL",$$$SQLNodeTopClause,"ParenCount")
#define SQLNodeTopClauseChiValSpec1A $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTopClause,"ValSpec1A")
 
#define SQLNodeTref $$$CPTIXNODER("SQL","Tref")
#define SQLNodeTrefAnnOJSyntax $$$CPTIXNODEANNR("SQL",$$$SQLNodeTref,"OJSyntax")
#define SQLNodeTrefChiJtab $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTref,"Jtab")
 
#define SQLNodeTrefList $$$CPTIXNODER("SQL","TrefList")
 
#define SQLNodeTriggerEventDELETE $$$CPTIXNODER("SQL","TriggerEventDELETE")
 
#define SQLNodeTriggerEventINSERT $$$CPTIXNODER("SQL","TriggerEventINSERT")
 
#define SQLNodeTriggerEventUPDATE $$$CPTIXNODER("SQL","TriggerEventUPDATE")
#define SQLNodeTriggerEventUPDATEChiColmnList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTriggerEventUPDATE,"ColmnList")
 
#define SQLNodeTriggeredAction1 $$$CPTIXNODER("SQL","TriggeredAction1")
#define SQLNodeTriggeredAction1AnnRowStatement $$$CPTIXNODEANNR("SQL",$$$SQLNodeTriggeredAction1,"RowStatement")
#define SQLNodeTriggeredAction1ChiWhen $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTriggeredAction1,"When")
#define SQLNodeTriggeredAction1ChiLanguageClause $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTriggeredAction1,"LanguageClause")
 
#define SQLNodeTriggeredAction2 $$$CPTIXNODER("SQL","TriggeredAction2")
#define SQLNodeTriggeredAction2AnnUpdate $$$CPTIXNODEANNR("SQL",$$$SQLNodeTriggeredAction2,"Update")
#define SQLNodeTriggeredAction2AnnDelete $$$CPTIXNODEANNR("SQL",$$$SQLNodeTriggeredAction2,"Delete")
 
#define SQLNodeTrimArgs $$$CPTIXNODER("SQL","TrimArgs")
#define SQLNodeTrimArgsAnnTrimspec $$$CPTIXNODEANNR("SQL",$$$SQLNodeTrimArgs,"Trimspec")
#define SQLNodeTrimArgsChiLhs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTrimArgs,"Lhs")
#define SQLNodeTrimArgsChiRhs $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTrimArgs,"Rhs")
 
#define SQLNodeTrmodeDiagnostics $$$CPTIXNODER("SQL","TrmodeDiagnostics")
#define SQLNodeTrmodeDiagnosticsChiSize $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTrmodeDiagnostics,"Size")
 
#define SQLNodeTrmodeIsolationLevel $$$CPTIXNODER("SQL","TrmodeIsolationLevel")
#define SQLNodeTrmodeIsolationLevelAnnIsolationLevel $$$CPTIXNODEANNR("SQL",$$$SQLNodeTrmodeIsolationLevel,"IsolationLevel")
 
#define SQLNodeTrmodeReadOnly $$$CPTIXNODER("SQL","TrmodeReadOnly")
 
#define SQLNodeTrmodeReadWrite $$$CPTIXNODER("SQL","TrmodeReadWrite")
 
#define SQLNodeTruncate $$$CPTIXNODER("SQL","Truncate")
#define SQLNodeTruncateChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTruncate,"Tname")
 
#define SQLNodeTsInterval2Scalx $$$CPTIXNODER("SQL","TsInterval2Scalx")
#define SQLNodeTsInterval2ScalxAnnIntervalKeyword $$$CPTIXNODEANNR("SQL",$$$SQLNodeTsInterval2Scalx,"IntervalKeyword")
#define SQLNodeTsInterval2ScalxChiValue1 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTsInterval2Scalx,"Value1")
#define SQLNodeTsInterval2ScalxChiValue2 $$$CPTIXNODECHILDR("SQL",$$$SQLNodeTsInterval2Scalx,"Value2")
 
#define SQLNodeUSER $$$CPTIXNODER("SQL","USER")
 
#define SQLNodeUnaryTerm $$$CPTIXNODER("SQL","UnaryTerm")
#define SQLNodeUnaryTermAnnUnaryOp $$$CPTIXNODEANNR("SQL",$$$SQLNodeUnaryTerm,"UnaryOp")
#define SQLNodeUnaryTermChiTerm $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUnaryTerm,"Term")
 
#define SQLNodeUnlock $$$CPTIXNODER("SQL","Unlock")
#define SQLNodeUnlockAnnShareExclusive $$$CPTIXNODEANNR("SQL",$$$SQLNodeUnlock,"ShareExclusive")
#define SQLNodeUnlockAnnImmediate $$$CPTIXNODEANNR("SQL",$$$SQLNodeUnlock,"Immediate")
#define SQLNodeUnlockChiTref $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUnlock,"Tref")
 
#define SQLNodeUpdat $$$CPTIXNODER("SQL","Updat")
#define SQLNodeUpdatChiIud $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUpdat,"Iud")
#define SQLNodeUpdatChiIUDTarget $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUpdat,"IUDTarget")
#define SQLNodeUpdatChiAsign $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUpdat,"Asign")
#define SQLNodeUpdatChiSecondary $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUpdat,"Secondary")
#define SQLNodeUpdatChiWerop $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUpdat,"Werop")
 
#define SQLNodeUpdateStats $$$CPTIXNODER("SQL","UpdateStats")
#define SQLNodeUpdateStatsChiTname $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUpdateStats,"Tname")
 
#define SQLNodeUpdtcls $$$CPTIXNODER("SQL","Updtcls")
#define SQLNodeUpdtclsAnnIsReadOnly $$$CPTIXNODEANNR("SQL",$$$SQLNodeUpdtcls,"IsReadOnly")
 
#define SQLNodeUserDefinedFunction $$$CPTIXNODER("SQL","UserDefinedFunction")
#define SQLNodeUserDefinedFunctionChiFunction $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUserDefinedFunction,"Function")
#define SQLNodeUserDefinedFunctionChiList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeUserDefinedFunction,"List")
 
#define SQLNodeUserList $$$CPTIXNODER("SQL","UserList")
 
#define SQLNodeUserName $$$CPTIXNODER("SQL","UserName")
#define SQLNodeUserNameAnnValue $$$CPTIXNODEANNR("SQL",$$$SQLNodeUserName,"Value")
 
#define SQLNodeValspec2Scalars $$$CPTIXNODER("SQL","Valspec2Scalars")
 
#define SQLNodeWeropCurrentOf $$$CPTIXNODER("SQL","WeropCurrentOf")
#define SQLNodeWeropCurrentOfChiIdent $$$CPTIXNODECHILDR("SQL",$$$SQLNodeWeropCurrentOf,"Ident")
#define SQLNodeWeropCurrentOfChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeWeropCurrentOf,"Prdct")
 
#define SQLNodeWeropPrdct $$$CPTIXNODER("SQL","WeropPrdct")
#define SQLNodeWeropPrdctChiPrdct $$$CPTIXNODECHILDR("SQL",$$$SQLNodeWeropPrdct,"Prdct")
 
#define SQLNodeXtfun $$$CPTIXNODER("SQL","Xtfun")
#define SQLNodeXtfunAnnXtfuncref $$$CPTIXNODEANNR("SQL",$$$SQLNodeXtfun,"Xtfuncref")
#define SQLNodeXtfunChiList $$$CPTIXNODECHILDR("SQL",$$$SQLNodeXtfun,"List")
 
#define SQLEnumAggFuncNone $$$CPTIXENUMVALUER("SQL","AggFunc","None")
#define SQLEnumAggFuncAVG $$$CPTIXENUMVALUER("SQL","AggFunc","AVG")
#define SQLEnumAggFuncSUM $$$CPTIXENUMVALUER("SQL","AggFunc","SUM")
#define SQLEnumAggFuncMAX $$$CPTIXENUMVALUER("SQL","AggFunc","MAX")
#define SQLEnumAggFuncMIN $$$CPTIXENUMVALUER("SQL","AggFunc","MIN")
#define SQLEnumAggFuncCOUNT $$$CPTIXENUMVALUER("SQL","AggFunc","COUNT")
#define SQLEnumAggFuncLIST $$$CPTIXENUMVALUER("SQL","AggFunc","LIST")
#define SQLEnumAggFuncXMLAGG $$$CPTIXENUMVALUER("SQL","AggFunc","XMLAGG")
#define SQLEnumAggFuncpcDLIST $$$CPTIXENUMVALUER("SQL","AggFunc","pcDLIST")
 
#define SQLEnumAscDescNone $$$CPTIXENUMVALUER("SQL","AscDesc","None")
#define SQLEnumAscDescASC $$$CPTIXENUMVALUER("SQL","AscDesc","ASC")
#define SQLEnumAscDescDESC $$$CPTIXENUMVALUER("SQL","AscDesc","DESC")
 
#define SQLEnumBeforeAfterNone $$$CPTIXENUMVALUER("SQL","BeforeAfter","None")
#define SQLEnumBeforeAfterBEFORE $$$CPTIXENUMVALUER("SQL","BeforeAfter","BEFORE")
#define SQLEnumBeforeAfterAFTER $$$CPTIXENUMVALUER("SQL","BeforeAfter","AFTER")
 
#define SQLEnumCascadeOptNone $$$CPTIXENUMVALUER("SQL","CascadeOpt","None")
#define SQLEnumCascadeOptRESTRICT $$$CPTIXENUMVALUER("SQL","CascadeOpt","RESTRICT")
#define SQLEnumCascadeOptCASCADE $$$CPTIXENUMVALUER("SQL","CascadeOpt","CASCADE")
 
#define SQLEnumCascadeRestrictNone $$$CPTIXENUMVALUER("SQL","CascadeRestrict","None")
#define SQLEnumCascadeRestrictCASCADE $$$CPTIXENUMVALUER("SQL","CascadeRestrict","CASCADE")
#define SQLEnumCascadeRestrictRESTRICT $$$CPTIXENUMVALUER("SQL","CascadeRestrict","RESTRICT")
 
#define SQLEnumCheckSpecNone $$$CPTIXENUMVALUER("SQL","CheckSpec","None")
#define SQLEnumCheckSpecCHECK $$$CPTIXENUMVALUER("SQL","CheckSpec","CHECK")
#define SQLEnumCheckSpecNOCHECK $$$CPTIXENUMVALUER("SQL","CheckSpec","NOCHECK")
 
#define SQLEnumClusteredNone $$$CPTIXENUMVALUER("SQL","Clustered","None")
#define SQLEnumClusteredCLUSTERED $$$CPTIXENUMVALUER("SQL","Clustered","CLUSTERED")
#define SQLEnumClusteredNONCLUSTERED $$$CPTIXENUMVALUER("SQL","Clustered","NONCLUSTERED")
 
#define SQLEnumCommitModeNone $$$CPTIXENUMVALUER("SQL","CommitMode","None")
#define SQLEnumCommitModeIMPLICIT $$$CPTIXENUMVALUER("SQL","CommitMode","IMPLICIT")
#define SQLEnumCommitModeEXPLICIT $$$CPTIXENUMVALUER("SQL","CommitMode","EXPLICIT")
#define SQLEnumCommitModeKWNONE $$$CPTIXENUMVALUER("SQL","CommitMode","KWNONE")
 
#define SQLEnumCompileOptionSettingNone $$$CPTIXENUMVALUER("SQL","CompileOptionSetting","None")
#define SQLEnumCompileOptionSettingCOMPILEMODE $$$CPTIXENUMVALUER("SQL","CompileOptionSetting","COMPILEMODE")
#define SQLEnumCompileOptionSettingDEFERRED $$$CPTIXENUMVALUER("SQL","CompileOptionSetting","DEFERRED")
#define SQLEnumCompileOptionSettingIMMEDIATE $$$CPTIXENUMVALUER("SQL","CompileOptionSetting","IMMEDIATE")
#define SQLEnumCompileOptionSettingINSTALL $$$CPTIXENUMVALUER("SQL","CompileOptionSetting","INSTALL")
 
#define SQLEnumDataOptionNone $$$CPTIXENUMVALUER("SQL","DataOption","None")
#define SQLEnumDataOptionpcDELDATA $$$CPTIXENUMVALUER("SQL","DataOption","pcDELDATA")
#define SQLEnumDataOptionpcNODELDATA $$$CPTIXENUMVALUER("SQL","DataOption","pcNODELDATA")
 
#define SQLEnumDtsNone $$$CPTIXENUMVALUER("SQL","Dts","None")
#define SQLEnumDtsD $$$CPTIXENUMVALUER("SQL","Dts","D")
#define SQLEnumDtsT $$$CPTIXENUMVALUER("SQL","Dts","T")
#define SQLEnumDtsTS $$$CPTIXENUMVALUER("SQL","Dts","TS")
 
#define SQLEnumEnvKeywordNone $$$CPTIXENUMVALUER("SQL","EnvKeyword","None")
#define SQLEnumEnvKeywordCURRENTDATE $$$CPTIXENUMVALUER("SQL","EnvKeyword","CURRENTDATE")
#define SQLEnumEnvKeywordCURRENTTIME $$$CPTIXENUMVALUER("SQL","EnvKeyword","CURRENTTIME")
#define SQLEnumEnvKeywordSYSDATE $$$CPTIXENUMVALUER("SQL","EnvKeyword","SYSDATE")
#define SQLEnumEnvKeywordUSER $$$CPTIXENUMVALUER("SQL","EnvKeyword","USER")
#define SQLEnumEnvKeywordCURRENTUSER $$$CPTIXENUMVALUER("SQL","EnvKeyword","CURRENTUSER")
#define SQLEnumEnvKeywordSESSIONUSER $$$CPTIXENUMVALUER("SQL","EnvKeyword","SESSIONUSER")
#define SQLEnumEnvKeywordSYSTEMUSER $$$CPTIXENUMVALUER("SQL","EnvKeyword","SYSTEMUSER")
#define SQLEnumEnvKeywordGETDATE $$$CPTIXENUMVALUER("SQL","EnvKeyword","GETDATE")
 
#define SQLEnumGrantOptNone $$$CPTIXENUMVALUER("SQL","GrantOpt","None")
#define SQLEnumGrantOptGRANT $$$CPTIXENUMVALUER("SQL","GrantOpt","GRANT")
#define SQLEnumGrantOptADMIN $$$CPTIXENUMVALUER("SQL","GrantOpt","ADMIN")
 
#define SQLEnumInOutNone $$$CPTIXENUMVALUER("SQL","InOut","None")
#define SQLEnumInOutIN $$$CPTIXENUMVALUER("SQL","InOut","IN")
#define SQLEnumInOutINOUT $$$CPTIXENUMVALUER("SQL","InOut","INOUT")
#define SQLEnumInOutOUT $$$CPTIXENUMVALUER("SQL","InOut","OUT")
 
#define SQLEnumIndexQualifierFirstNone $$$CPTIXENUMVALUER("SQL","IndexQualifierFirst","None")
#define SQLEnumIndexQualifierFirstUNIQUE $$$CPTIXENUMVALUER("SQL","IndexQualifierFirst","UNIQUE")
#define SQLEnumIndexQualifierFirstBITMAP $$$CPTIXENUMVALUER("SQL","IndexQualifierFirst","BITMAP")
#define SQLEnumIndexQualifierFirstBITSLICE $$$CPTIXENUMVALUER("SQL","IndexQualifierFirst","BITSLICE")
 
#define SQLEnumIsolationLevelNone $$$CPTIXENUMVALUER("SQL","IsolationLevel","None")
#define SQLEnumIsolationLevelREADUNCOMMITTED $$$CPTIXENUMVALUER("SQL","IsolationLevel","READUNCOMMITTED")
#define SQLEnumIsolationLevelREADCOMMITTED $$$CPTIXENUMVALUER("SQL","IsolationLevel","READCOMMITTED")
#define SQLEnumIsolationLevelREPEATABLEREAD $$$CPTIXENUMVALUER("SQL","IsolationLevel","REPEATABLEREAD")
#define SQLEnumIsolationLevelSERIALIZABLE $$$CPTIXENUMVALUER("SQL","IsolationLevel","SERIALIZABLE")
 
#define SQLEnumJopNone $$$CPTIXENUMVALUER("SQL","Jop","None")
#define SQLEnumJopJOIN $$$CPTIXENUMVALUER("SQL","Jop","JOIN")
#define SQLEnumJopINNERJOIN $$$CPTIXENUMVALUER("SQL","Jop","INNERJOIN")
#define SQLEnumJopLEFTJOIN $$$CPTIXENUMVALUER("SQL","Jop","LEFTJOIN")
#define SQLEnumJopRIGHTJOIN $$$CPTIXENUMVALUER("SQL","Jop","RIGHTJOIN")
#define SQLEnumJopFULLJOIN $$$CPTIXENUMVALUER("SQL","Jop","FULLJOIN")
 
#define SQLEnumLevelsClauseNone $$$CPTIXENUMVALUER("SQL","LevelsClause","None")
#define SQLEnumLevelsClauseCASCADE $$$CPTIXENUMVALUER("SQL","LevelsClause","CASCADE")
#define SQLEnumLevelsClauseLOCAL $$$CPTIXENUMVALUER("SQL","LevelsClause","LOCAL")
 
#define SQLEnumLockModeNone $$$CPTIXENUMVALUER("SQL","LockMode","None")
#define SQLEnumLockModeROW $$$CPTIXENUMVALUER("SQL","LockMode","ROW")
#define SQLEnumLockModePAGE $$$CPTIXENUMVALUER("SQL","LockMode","PAGE")
 
#define SQLEnumMatchNone $$$CPTIXENUMVALUER("SQL","Match","None")
#define SQLEnumMatchFULL $$$CPTIXENUMVALUER("SQL","Match","FULL")
#define SQLEnumMatchPARTIAL $$$CPTIXENUMVALUER("SQL","Match","PARTIAL")
 
#define SQLEnumNullNotNullNone $$$CPTIXENUMVALUER("SQL","NullNotNull","None")
#define SQLEnumNullNotNullNULL $$$CPTIXENUMVALUER("SQL","NullNotNull","NULL")
#define SQLEnumNullNotNullNOTNULL $$$CPTIXENUMVALUER("SQL","NullNotNull","NOTNULL")
 
#define SQLEnumPKUNone $$$CPTIXENUMVALUER("SQL","PKU","None")
#define SQLEnumPKUUNIQUE $$$CPTIXENUMVALUER("SQL","PKU","UNIQUE")
#define SQLEnumPKUPRIMARYKEY $$$CPTIXENUMVALUER("SQL","PKU","PRIMARYKEY")
 
#define SQLEnumQueryPartTypeNone $$$CPTIXENUMVALUER("SQL","QueryPartType","None")
#define SQLEnumQueryPartTypeGETINFO $$$CPTIXENUMVALUER("SQL","QueryPartType","GETINFO")
#define SQLEnumQueryPartTypeEXECUTE $$$CPTIXENUMVALUER("SQL","QueryPartType","EXECUTE")
#define SQLEnumQueryPartTypeFETCH $$$CPTIXENUMVALUER("SQL","QueryPartType","FETCH")
#define SQLEnumQueryPartTypeFETCHODBC $$$CPTIXENUMVALUER("SQL","QueryPartType","FETCHODBC")
#define SQLEnumQueryPartTypeFETCHROWS $$$CPTIXENUMVALUER("SQL","QueryPartType","FETCHROWS")
#define SQLEnumQueryPartTypeCLOSE $$$CPTIXENUMVALUER("SQL","QueryPartType","CLOSE")
 
#define SQLEnumRefActionNone $$$CPTIXENUMVALUER("SQL","RefAction","None")
#define SQLEnumRefActionNOACTION $$$CPTIXENUMVALUER("SQL","RefAction","NOACTION")
#define SQLEnumRefActionCASCADE $$$CPTIXENUMVALUER("SQL","RefAction","CASCADE")
#define SQLEnumRefActionSETNULL $$$CPTIXENUMVALUER("SQL","RefAction","SETNULL")
#define SQLEnumRefActionSETDEFAULT $$$CPTIXENUMVALUER("SQL","RefAction","SETDEFAULT")
 
#define SQLEnumRowPageNone $$$CPTIXENUMVALUER("SQL","RowPage","None")
#define SQLEnumRowPageROW $$$CPTIXENUMVALUER("SQL","RowPage","ROW")
#define SQLEnumRowPagePAGE $$$CPTIXENUMVALUER("SQL","RowPage","PAGE")
 
#define SQLEnumRowStatementNone $$$CPTIXENUMVALUER("SQL","RowStatement","None")
#define SQLEnumRowStatementROW $$$CPTIXENUMVALUER("SQL","RowStatement","ROW")
#define SQLEnumRowStatementSTATEMENT $$$CPTIXENUMVALUER("SQL","RowStatement","STATEMENT")
#define SQLEnumRowStatementROW_AND_OBJECT $$$CPTIXENUMVALUER("SQL","RowStatement","ROW_AND_OBJECT")
 
#define SQLEnumSelectModeNone $$$CPTIXENUMVALUER("SQL","SelectMode","None")
#define SQLEnumSelectModeRUNTIME $$$CPTIXENUMVALUER("SQL","SelectMode","RUNTIME")
#define SQLEnumSelectModeODBC $$$CPTIXENUMVALUER("SQL","SelectMode","ODBC")
#define SQLEnumSelectModeLOGICAL $$$CPTIXENUMVALUER("SQL","SelectMode","LOGICAL")
#define SQLEnumSelectModeDISPLAY $$$CPTIXENUMVALUER("SQL","SelectMode","DISPLAY")
 
#define SQLEnumShareExclusiveNone $$$CPTIXENUMVALUER("SQL","ShareExclusive","None")
#define SQLEnumShareExclusiveSHARE $$$CPTIXENUMVALUER("SQL","ShareExclusive","SHARE")
#define SQLEnumShareExclusiveEXCLUSIVE $$$CPTIXENUMVALUER("SQL","ShareExclusive","EXCLUSIVE")
 
#define SQLEnumSqlcollationTypeNone $$$CPTIXENUMVALUER("SQL","SqlcollationType","None")
#define SQLEnumSqlcollationTypepcALPHAUP $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcALPHAUP")
#define SQLEnumSqlcollationTypepcEXACT $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcEXACT")
#define SQLEnumSqlcollationTypepcMINUS $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcMINUS")
#define SQLEnumSqlcollationTypepcPLUS $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcPLUS")
#define SQLEnumSqlcollationTypepcSPACE $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcSPACE")
#define SQLEnumSqlcollationTypepcUPPER $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcUPPER")
#define SQLEnumSqlcollationTypepcSQLSTRING $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcSQLSTRING")
#define SQLEnumSqlcollationTypepcSQLUPPER $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcSQLUPPER")
#define SQLEnumSqlcollationTypepcSTRING $$$CPTIXENUMVALUER("SQL","SqlcollationType","pcSTRING")
 
#define SQLEnumSubqueryScopeNone $$$CPTIXENUMVALUER("SQL","SubqueryScope","None")
#define SQLEnumSubqueryScopeALL $$$CPTIXENUMVALUER("SQL","SubqueryScope","ALL")
#define SQLEnumSubqueryScopeANY $$$CPTIXENUMVALUER("SQL","SubqueryScope","ANY")
#define SQLEnumSubqueryScopeSOME $$$CPTIXENUMVALUER("SQL","SubqueryScope","SOME")
 
#define SQLEnumTableScopeNone $$$CPTIXENUMVALUER("SQL","TableScope","None")
#define SQLEnumTableScopePRIVATE $$$CPTIXENUMVALUER("SQL","TableScope","PRIVATE")
#define SQLEnumTableScopeGLOBAL $$$CPTIXENUMVALUER("SQL","TableScope","GLOBAL")
 
#define SQLEnumTelemOptionPercentKWsNone $$$CPTIXENUMVALUER("SQL","TelemOptionPercentKWs","None")
#define SQLEnumTelemOptionPercentKWspcDESCRIPTION $$$CPTIXENUMVALUER("SQL","TelemOptionPercentKWs","pcDESCRIPTION")
#define SQLEnumTelemOptionPercentKWspcFILE $$$CPTIXENUMVALUER("SQL","TelemOptionPercentKWs","pcFILE")
#define SQLEnumTelemOptionPercentKWspcNUMROWS $$$CPTIXENUMVALUER("SQL","TelemOptionPercentKWs","pcNUMROWS")
#define SQLEnumTelemOptionPercentKWspcROUTINE $$$CPTIXENUMVALUER("SQL","TelemOptionPercentKWs","pcROUTINE")
#define SQLEnumTelemOptionPercentKWspcEXTENTSIZE $$$CPTIXENUMVALUER("SQL","TelemOptionPercentKWs","pcEXTENTSIZE")
 
#define SQLEnumTpOptionNone $$$CPTIXENUMVALUER("SQL","TpOption","None")
#define SQLEnumTpOptionpcINTRANSACTION $$$CPTIXENUMVALUER("SQL","TpOption","pcINTRANSACTION")
#define SQLEnumTpOptionpcBEGTRANS $$$CPTIXENUMVALUER("SQL","TpOption","pcBEGTRANS")
#define SQLEnumTpOptionpcINTRANS $$$CPTIXENUMVALUER("SQL","TpOption","pcINTRANS")
#define SQLEnumTpOptionCOMMIT $$$CPTIXENUMVALUER("SQL","TpOption","COMMIT")
 
#define SQLEnumTrimspecNone $$$CPTIXENUMVALUER("SQL","Trimspec","None")
#define SQLEnumTrimspecLEADING $$$CPTIXENUMVALUER("SQL","Trimspec","LEADING")
#define SQLEnumTrimspecTRAILING $$$CPTIXENUMVALUER("SQL","Trimspec","TRAILING")
#define SQLEnumTrimspecBOTH $$$CPTIXENUMVALUER("SQL","Trimspec","BOTH")
 

#else

#define SQLNodeAddAction 243
#define SQLNodeAddActionChiConstraint 1
#define SQLNodeAddActionChiAddBody 2
 
#define SQLNodeAddBodyCheck 245
#define SQLNodeAddBodyCheckChiChkparse 1
 
#define SQLNodeAddBodyColdef 253
#define SQLNodeAddBodyColdefChiColdef 1
 
#define SQLNodeAddBodyDefault 244
#define SQLNodeAddBodyDefaultChiDefSpec 1
#define SQLNodeAddBodyDefaultChiIdent 2
 
#define SQLNodeAddBodyFkey 246
#define SQLNodeAddBodyFkeyChiAltFkeySpec 1
#define SQLNodeAddBodyFkeyChiOn 2
 
#define SQLNodeAddBodyPkey 250
#define SQLNodeAddBodyPkeyChiAltPkey 1
#define SQLNodeAddBodyPkeyChiOn 2
 
#define SQLNodeAddBodyUnique 248
#define SQLNodeAddBodyUniqueChiAltUnique 1
#define SQLNodeAddBodyUniqueChiFillFactor 2
#define SQLNodeAddBodyUniqueChiOn 3
 
#define SQLNodeAdminPriv 276
#define SQLNodeAdminPrivAnnName 1
 
#define SQLNodeAdminPrivList 275
 
#define SQLNodeAgg 129
#define SQLNodeAggAnnAggFunc 1
#define SQLNodeAggChiAggArgOrStar 1
 
#define SQLNodeAggArg 130
#define SQLNodeAggArgAnnAfterHaving 1
#define SQLNodeAggArgChiDist 1
#define SQLNodeAggArgChiScalx 2
#define SQLNodeAggArgChiForEach 3
 
#define SQLNodeAllPrivileges 280
 
#define SQLNodeAltFkeySpec 247
#define SQLNodeAltFkeySpecChiForeignKey 1
#define SQLNodeAltFkeySpecChiFlist2 2
#define SQLNodeAltFkeySpecChiReferences 3
 
#define SQLNodeAltPKey1 251
#define SQLNodeAltPKey1ChiIdent 1
#define SQLNodeAltPKey1ChiFlist2 2
 
#define SQLNodeAltPKey2 252
#define SQLNodeAltPKey2ChiFlist1 1
 
#define SQLNodeAltUnique 249
#define SQLNodeAltUniqueAnnClustered 1
#define SQLNodeAltUniqueChiFlist2 1
 
#define SQLNodeAlterActionAdd 241
 
#define SQLNodeAlterActionAlter 262
#define SQLNodeAlterActionAlterChiIdent 1
#define SQLNodeAlterActionAlterChiAlterCol 2
 
#define SQLNodeAlterActionConstraint 261
#define SQLNodeAlterActionConstraintAnnCheckSpec 1
 
#define SQLNodeAlterActionDrop 255
#define SQLNodeAlterActionDropChiDropAction 1
 
#define SQLNodeAlterActionLock 260
#define SQLNodeAlterActionLockAnnRowPage 1
 
#define SQLNodeAlterActionModify 264
 
#define SQLNodeAlterTable 23
#define SQLNodeAlterTableAnnCheckSpec 1
#define SQLNodeAlterTableChiTname 1
#define SQLNodeAlterTableChiAlterAction 2
 
#define SQLNodeAlterUser 25
#define SQLNodeAlterUserChiIdent 1
#define SQLNodeAlterUserChiIdentifiedBy 2
#define SQLNodeAlterUserChiCreateUserDefault 3
#define SQLNodeAlterUserChiCreateUserTemporary 4
 
#define SQLNodeAlterView 24
#define SQLNodeAlterViewChiTname 1
#define SQLNodeAlterViewChiIdentList 2
#define SQLNodeAlterViewChiQuery 3
#define SQLNodeAlterViewChiAlterViewWith 4
 
#define SQLNodeAlterViewWithCheckOption 240
#define SQLNodeAlterViewWithCheckOptionChiConstraint 1
 
#define SQLNodeAlterViewWithReadOnly 239
 
#define SQLNodeAnd 93
#define SQLNodeAndChiCond 1
#define SQLNodeAndChiAndTail 2
 
#define SQLNodeAndTail 109
 
#define SQLNodeAndTerm 111
#define SQLNodeAndTermAnnAndOperator 1
#define SQLNodeAndTermChiCond 1
 
#define SQLNodeAsignDefault 79
 
#define SQLNodeAsignSet 77
 
#define SQLNodeAsignValue 80
#define SQLNodeAsignValueChiColmnList 1
#define SQLNodeAsignValueChiValueSource 2
 
#define SQLNodeBatch 1
 
#define SQLNodeBlobSupport 269
#define SQLNodeBlobSupportAnnSetting 1
 
#define SQLNodeCOSMethodBody 227
#define SQLNodeCOSMethodBodyChiCodeLines 1
 
#define SQLNodeCOSQueryBody 228
 
#define SQLNodeCOSQueryPart 229
#define SQLNodeCOSQueryPartAnnQueryPartType 1
#define SQLNodeCOSQueryPartChiParameterList 1
#define SQLNodeCOSQueryPartChiCOSMethodBody 2
 
#define SQLNodeCSPOrPPAndTerm 110
#define SQLNodeCSPOrPPAndTermAnnCSPOrPP 1
 
#define SQLNodeCSPOrPPStat 3
#define SQLNodeCSPOrPPStatAnnCSPOrPP 1
 
#define SQLNodeCSPOrPPTables 57
#define SQLNodeCSPOrPPTablesAnnCSPOrPP 1
 
#define SQLNodeCSPOrPPWhereAll 307
#define SQLNodeCSPOrPPWhereAllAnnCSPOrPP 1
 
#define SQLNodeCSPOrPPWhereCond 308
#define SQLNodeCSPOrPPWhereCondAnnCSPOrPPBefore 1
#define SQLNodeCSPOrPPWhereCondAnnCSPOrPPAfter 2
#define SQLNodeCSPOrPPWhereCondChiPrdct 1
 
#define SQLNodeCacheSpecialVariable 116
#define SQLNodeCacheSpecialVariableAnnVariableName 1
 
#define SQLNodeCall 42
#define SQLNodeCallChiHostVariableArgument 1
#define SQLNodeCallChiCallTarget 2
#define SQLNodeCallChiSqlArgumentList 3
#define SQLNodeCallChiUsing 4
 
#define SQLNodeCase 139
#define SQLNodeCaseChiCase 1
#define SQLNodeCaseChiCaseWhenList 2
#define SQLNodeCaseChiElse 3
 
#define SQLNodeCaseWhen 141
#define SQLNodeCaseWhenChiWhen 1
#define SQLNodeCaseWhenChiThen 2
 
#define SQLNodeCaseWhenList 140
 
#define SQLNodeCheckCnstr 187
#define SQLNodeCheckCnstrChiChkparse 1
 
#define SQLNodeChkPrvCmdOn 292
#define SQLNodeChkPrvCmdOnChiPrivSpec 1
#define SQLNodeChkPrvCmdOnChiObject 2
 
#define SQLNodeChkparse 181
#define SQLNodeChkparseAnnTokens 1
 
#define SQLNodeChkprv 39
#define SQLNodeChkprvAnnGrantOpt 1
#define SQLNodeChkprvChiChkPrvCmd 1
 
#define SQLNodeClose 8
#define SQLNodeCloseChiIdent 1
 
#define SQLNodeCodeLines 226
 
#define SQLNodeCodeSpecification 212
#define SQLNodeCodeSpecificationChiParameterList 1
#define SQLNodeCodeSpecificationChiMethodQueryCharacteristicsList 2
#define SQLNodeCodeSpecificationChiCodeBody 3
 
#define SQLNodeColdef 254
#define SQLNodeColdefChiIdent 1
#define SQLNodeColdefChiDatyp 2
#define SQLNodeColdefChiFldQualifierList 3
 
#define SQLNodeColmn 82
#define SQLNodeColmnAnnBase 1
#define SQLNodeColmnChiColmnDot 1
#define SQLNodeColmnChiColmnArrow 2
 
#define SQLNodeColmnAssignment 78
#define SQLNodeColmnAssignmentChiColmn 1
#define SQLNodeColmnAssignmentChiScalx 2
 
#define SQLNodeColmnList 81
 
#define SQLNodeComparisonBetween 102
#define SQLNodeComparisonBetweenAnnNot 1
#define SQLNodeComparisonBetweenChiBetween 1
#define SQLNodeComparisonBetweenChiAnd 2
 
#define SQLNodeComparisonCmpOp 107
#define SQLNodeComparisonCmpOpAnnCmpOp 1
#define SQLNodeComparisonCmpOpChiComparisonCmpOpRhs 1
#define SQLNodeComparisonCmpOpChiSizeHint 2
 
#define SQLNodeComparisonCmpOpQuery 108
#define SQLNodeComparisonCmpOpQueryAnnSubqueryScope 1
#define SQLNodeComparisonCmpOpQueryChiQuery 1
 
#define SQLNodeComparisonContains 105
#define SQLNodeComparisonContainsAnnNot 1
#define SQLNodeComparisonContainsAnnIsContainsTerm 2
#define SQLNodeComparisonContainsChiContainsSpec 1
 
#define SQLNodeComparisonIn 104
#define SQLNodeComparisonInAnnNot 1
#define SQLNodeComparisonInChiInSpec 1
 
#define SQLNodeComparisonInlist 53
#define SQLNodeComparisonInlistAnnNot 1
#define SQLNodeComparisonInlistChiScalx 1
#define SQLNodeComparisonInlistChiSize 2
 
#define SQLNodeComparisonIsNull 101
#define SQLNodeComparisonIsNullAnnNot 1
 
#define SQLNodeComparisonLikeOrMatches 103
#define SQLNodeComparisonLikeOrMatchesAnnNot 1
#define SQLNodeComparisonLikeOrMatchesChiLike 1
#define SQLNodeComparisonLikeOrMatchesChiEscape 2
 
#define SQLNodeComparisonWithScalx 100
#define SQLNodeComparisonWithScalxAnnOp 1
#define SQLNodeComparisonWithScalxChiScalx 1
 
#define SQLNodeCompileOption 267
#define SQLNodeCompileOptionAnnCompileOptionSetting 1
 
#define SQLNodeComponentSpec 204
#define SQLNodeComponentSpecAnnAscDesc 1
#define SQLNodeComponentSpecChiIdent 1
 
#define SQLNodeComponentSpecList 203
 
#define SQLNodeCond 94
#define SQLNodeCondChiCondTermHint 1
#define SQLNodeCondChiCondTerm 2
#define SQLNodeCondChiComparison 3
 
#define SQLNodeCondTermExists 96
#define SQLNodeCondTermExistsChiQuery 1
 
#define SQLNodeCondTermFor 98
#define SQLNodeCondTermForChiTables 1
#define SQLNodeCondTermForChiPrdct 2
 
#define SQLNodeCondTermForElement 97
#define SQLNodeCondTermForElementChiColmn 1
#define SQLNodeCondTermForElementChiAlias 2
#define SQLNodeCondTermForElementChiPrdct 3
 
#define SQLNodeCondTermHint 322
#define SQLNodeCondTermHintAnnNOINDEX 1
 
#define SQLNodeCondTermNot 95
#define SQLNodeCondTermNotChiCond 1
 
#define SQLNodeCondTermScalx 99
#define SQLNodeCondTermScalxChiValue 1
 
#define SQLNodeConstant 306
#define SQLNodeConstantAnnParenCount 1
#define SQLNodeConstantChiLiteral 1
 
#define SQLNodeContainsSpec 106
#define SQLNodeContainsSpecChiList 1
 
#define SQLNodeConvertArgs 126
#define SQLNodeConvertArgsChiCast 1
#define SQLNodeConvertArgsChiValue1 2
#define SQLNodeConvertArgsChiValue2 3
 
#define SQLNodeCreateDatabase 323
#define SQLNodeCreateDatabaseAnnDatabaseName 1
#define SQLNodeCreateDatabaseAnnDirectoryName 2
#define SQLNodeCreateDatabaseChiCreateDatabaseWith 1
 
#define SQLNodeCreateDatabaseWith 324
#define SQLNodeCreateDatabaseWithAnnEncryptedDB 1
#define SQLNodeCreateDatabaseWithAnnGlobalJournalState 2
 
#define SQLNodeCreateFunction 19
#define SQLNodeCreateFunctionChiQualifiedSpname 1
#define SQLNodeCreateFunctionChiCodeSpecification 2
 
#define SQLNodeCreateIndex 17
#define SQLNodeCreateIndexChiIndexQualifiers 1
#define SQLNodeCreateIndexChiIndexname 2
#define SQLNodeCreateIndexChiTname 3
#define SQLNodeCreateIndexChiComponentSpecList 4
#define SQLNodeCreateIndexChiCreateIndexWithList 5
#define SQLNodeCreateIndexChiInOn 6
 
#define SQLNodeCreateIndexWithData 312
 
#define SQLNodeCreateIndexWithDropExisting 209
 
#define SQLNodeCreateIndexWithFillFactor 207
#define SQLNodeCreateIndexWithFillFactorChiLiteral 1
 
#define SQLNodeCreateIndexWithIgnoreDupKey 208
 
#define SQLNodeCreateIndexWithList 205
 
#define SQLNodeCreateIndexWithPadIndex 206
 
#define SQLNodeCreateIndexWithStatisticsNorecompute 210
 
#define SQLNodeCreateMethod 18
#define SQLNodeCreateMethodAnnStatic 1
#define SQLNodeCreateMethodChiQualifiedSpname 1
#define SQLNodeCreateMethodChiCodeSpecification 2
 
#define SQLNodeCreateProcedure 21
#define SQLNodeCreateProcedureChiQualifiedSpname 1
#define SQLNodeCreateProcedureChiCodeSpecification 2
 
#define SQLNodeCreateQuery 20
#define SQLNodeCreateQueryChiQualifiedSpname 1
#define SQLNodeCreateQueryChiCodeSpecification 2
 
#define SQLNodeCreateRole 14
#define SQLNodeCreateRoleChiIdent 1
 
#define SQLNodeCreateTable 13
#define SQLNodeCreateTableAnnTableScope 1
#define SQLNodeCreateTableAnnLockMode 2
#define SQLNodeCreateTableChiTname 1
#define SQLNodeCreateTableChiTelemList 2
#define SQLNodeCreateTableChiInOn 3
#define SQLNodeCreateTableChiTextimageOn 4
#define SQLNodeCreateTableChiExtentSize 5
#define SQLNodeCreateTableChiNextSize 6
 
#define SQLNodeCreateTrigger 22
#define SQLNodeCreateTriggerAnnBeforeAfter 1
#define SQLNodeCreateTriggerAnnOrderIndex 2
#define SQLNodeCreateTriggerChiTriggerName 1
#define SQLNodeCreateTriggerChiTriggerEvent 2
#define SQLNodeCreateTriggerChiOn 3
#define SQLNodeCreateTriggerChiReferencing 4
#define SQLNodeCreateTriggerChiTriggeredAction1 5
 
#define SQLNodeCreateUser 16
#define SQLNodeCreateUserChiIdent 1
#define SQLNodeCreateUserChiIdentifiedBy 2
#define SQLNodeCreateUserChiCreateUserDefault 3
#define SQLNodeCreateUserChiCreateUserTemporary 4
 
#define SQLNodeCreateUserDefault 194
#define SQLNodeCreateUserDefaultChiIdent1 1
#define SQLNodeCreateUserDefaultChiIdent2 2
 
#define SQLNodeCreateUserTemporary 195
#define SQLNodeCreateUserTemporaryChiIdent1 1
#define SQLNodeCreateUserTemporaryChiIdent2 2
 
#define SQLNodeCreateView 15
#define SQLNodeCreateViewAnnOrReplace 1
#define SQLNodeCreateViewChiTname 1
#define SQLNodeCreateViewChiIdentList 2
#define SQLNodeCreateViewChiQuery 3
#define SQLNodeCreateViewChiCreateViewWith 4
 
#define SQLNodeCreateViewWithCheckOption 193
#define SQLNodeCreateViewWithCheckOptionAnnLevelsClause 1
#define SQLNodeCreateViewWithCheckOptionChiConstraint 1
 
#define SQLNodeCreateViewWithReadOnly 192
 
#define SQLNodeCrossJoin 65
#define SQLNodeCrossJoinChiJtab 1
 
#define SQLNodeCurrentDate 115
 
#define SQLNodeDataType 119
#define SQLNodeDataTypeAnnCompleteDataType 1
 
#define SQLNodeDatePart1Scalx 122
#define SQLNodeDatePart1ScalxChiDatePart 1
#define SQLNodeDatePart1ScalxChiValue 2
 
#define SQLNodeDatePart2Scalx 120
#define SQLNodeDatePart2ScalxChiDatePart 1
#define SQLNodeDatePart2ScalxChiValue1 2
#define SQLNodeDatePart2ScalxChiValue2 3
 
#define SQLNodeDatePartKeyword 121
#define SQLNodeDatePartKeywordAnnDatePartName 1
 
#define SQLNodeDatyp 167
#define SQLNodeDatypChiDatypSpec 1
#define SQLNodeDatypChiDatypParen 2
 
#define SQLNodeDatypParen 168
#define SQLNodeDatypParenAnnInsideParen 1
 
#define SQLNodeDecl 5
#define SQLNodeDeclChiIdent 1
#define SQLNodeDeclChiSelct 2
#define SQLNodeDeclChiUpdtcls 3
 
#define SQLNodeDefSpecCOS 176
#define SQLNodeDefSpecCOSChiLiteral 1
 
#define SQLNodeDefSpecCTS 175
#define SQLNodeDefSpecCTSAnnValue 1
 
#define SQLNodeDefSpecEnv 174
#define SQLNodeDefSpecEnvAnnEnvKeyword 1
 
#define SQLNodeDefSpecTD 189
#define SQLNodeDefSpecTDChiValue1 1
#define SQLNodeDefSpecTDChiValue2 2
 
#define SQLNodeDelet 11
#define SQLNodeDeletChiIud 1
#define SQLNodeDeletChiIUDTarget 2
#define SQLNodeDeletChiSecondary 3
#define SQLNodeDeletChiWerop 4
 
#define SQLNodeDist 50
#define SQLNodeDistAnnIsDistinct 1
#define SQLNodeDistChiBy 1
 
#define SQLNodeDropActionColumn 259
#define SQLNodeDropActionColumnAnnCascadeOpt 1
#define SQLNodeDropActionColumnAnnDataOption 2
#define SQLNodeDropActionColumnChiIdent 1
 
#define SQLNodeDropActionConstraint 258
#define SQLNodeDropActionConstraintChiIdent 1
 
#define SQLNodeDropActionForeignKey 256
#define SQLNodeDropActionForeignKeyChiFlist2 1
 
#define SQLNodeDropActionPrimaryKey 257
 
#define SQLNodeDropDatabase 325
#define SQLNodeDropDatabaseAnnDatabaseName 1
#define SQLNodeDropDatabaseAnnRetainFiles 2
 
#define SQLNodeDropDef 263
 
#define SQLNodeDropFunction 36
#define SQLNodeDropFunctionChiQualifiedSpname 1
#define SQLNodeDropFunctionChiClassname 2
 
#define SQLNodeDropIndex 31
#define SQLNodeDropIndexAnnIndexname 1
#define SQLNodeDropIndexChiOn 1
 
#define SQLNodeDropMethod 35
#define SQLNodeDropMethodChiQualifiedSpname 1
#define SQLNodeDropMethodChiClassname 2
 
#define SQLNodeDropOrReplaceView 28
#define SQLNodeDropOrReplaceViewChiTname 1
#define SQLNodeDropOrReplaceViewChiIdentList 2
#define SQLNodeDropOrReplaceViewChiQuery 3
#define SQLNodeDropOrReplaceViewChiAlterViewWith 4
 
#define SQLNodeDropProcedure 33
#define SQLNodeDropProcedureChiQualifiedSpname 1
#define SQLNodeDropProcedureChiClassname 2
 
#define SQLNodeDropQuery 34
#define SQLNodeDropQueryChiQualifiedSpname 1
#define SQLNodeDropQueryChiClassname 2
 
#define SQLNodeDropRole 27
#define SQLNodeDropRoleChiIdent 1
 
#define SQLNodeDropTable 26
#define SQLNodeDropTableAnnCascadeOpt 1
#define SQLNodeDropTableAnnDataOption 2
#define SQLNodeDropTableChiTname 1
 
#define SQLNodeDropTrigger 32
#define SQLNodeDropTriggerChiTriggerName 1
#define SQLNodeDropTriggerChiFrom 2
 
#define SQLNodeDropUser 30
#define SQLNodeDropUserAnnCascade 1
#define SQLNodeDropUserChiIdent 1
 
#define SQLNodeDropView 29
#define SQLNodeDropViewAnnCascadeOpt 1
#define SQLNodeDropViewChiTname 1
 
#define SQLNodeDtsVal 145
#define SQLNodeDtsValAnnDts 1
#define SQLNodeDtsValChiValSpec1 1
 
#define SQLNodeFetch 7
#define SQLNodeFetchChiRowCount 1
#define SQLNodeFetchChiIdent 2
#define SQLNodeFetchChiHostList 3
 
#define SQLNodeFirstTableHint 318
#define SQLNodeFirstTableHintAnnSimpleName 1
 
#define SQLNodeFldQualifierCalculated 314
 
#define SQLNodeFldQualifierCharacterSet 185
#define SQLNodeFldQualifierCharacterSetChiIdent 1
 
#define SQLNodeFldQualifierCheck 186
#define SQLNodeFldQualifierCheckChiCheckCnstr 1
 
#define SQLNodeFldQualifierComputeCode 315
#define SQLNodeFldQualifierComputeCodeChiCodeLines 1
 
#define SQLNodeFldQualifierComputeOnChange 316
 
#define SQLNodeFldQualifierConstraint 172
#define SQLNodeFldQualifierConstraintChiTname 1
#define SQLNodeFldQualifierConstraintChiNamedFconSpec 2
 
#define SQLNodeFldQualifierDefault 184
#define SQLNodeFldQualifierDefaultChiDefSpec 1
 
#define SQLNodeFldQualifierDescription 183
#define SQLNodeFldQualifierDescriptionChiLiteral 1
 
#define SQLNodeFldQualifierList 169
 
#define SQLNodeFldQualifierPKU 188
#define SQLNodeFldQualifierPKUAnnPKU 1
#define SQLNodeFldQualifierPKUAnnClustered 2
 
#define SQLNodeFldQualifierReferences 190
#define SQLNodeFldQualifierReferencesChiRef 1
 
#define SQLNodeFldQualifierTransient 313
 
#define SQLNodeFlist1 70
 
#define SQLNodeFlist2 161
#define SQLNodeFlist2ChiIdentList 1
#define SQLNodeFlist2ChiFlist1 2
 
#define SQLNodeFrmitQuery 63
#define SQLNodeFrmitQueryChiQuery 1
#define SQLNodeFrmitQueryChiAs 2
 
#define SQLNodeFrmitTable 61
#define SQLNodeFrmitTableChiTable 1
#define SQLNodeFrmitTableChiAs 2
 
#define SQLNodeFromClause 54
#define SQLNodeFromClauseChiFromHints 1
#define SQLNodeFromClauseChiTables 2
 
#define SQLNodeFromHints 55
#define SQLNodeFromHintsAnnpcALLINDEX 1
#define SQLNodeFromHintsAnnpcDBUGFULL 2
#define SQLNodeFromHintsAnnpcFLATTEN 3
#define SQLNodeFromHintsAnnpcFULL 4
#define SQLNodeFromHintsAnnpcINORDER 5
#define SQLNodeFromHintsAnnpcNOFACTORANDFROMOR 6
#define SQLNodeFromHintsAnnpcNOFACTORORDERBYOR 7
#define SQLNodeFromHintsAnnpcNOFLATTEN 8
#define SQLNodeFromHintsAnnpcNOMERGE 9
#define SQLNodeFromHintsAnnpcNOMERGEEQUIVAGG 10
#define SQLNodeFromHintsAnnpcNOSVSO 11
#define SQLNodeFromHintsAnnpcNOTOPOPT 12
#define SQLNodeFromHintsAnnpcNOUNIONOROPT 13
#define SQLNodeFromHintsAnnpcSTARTTABLE 14
#define SQLNodeFromHintsAnnpcNOREDUCE 15
#define SQLNodeFromHintsAnnpcPARALLEL 16
#define SQLNodeFromHintsAnnpcNOPARALLEL 17
#define SQLNodeFromHintsChiFirstTableHint 1
#define SQLNodeFromHintsChiIgnoreIndexHint 2
 
#define SQLNodeGet 41
#define SQLNodeGetChiIdent 1
#define SQLNodeGetChiVar 2
 
#define SQLNodeGrantAccess 272
#define SQLNodeGrantAccessAnnWithGrantOption 1
#define SQLNodeGrantAccessChiAccessList 1
#define SQLNodeGrantAccessChiGrntee 2
 
#define SQLNodeGrantAdminPrivs 274
#define SQLNodeGrantAdminPrivsAnnWithAdminOption 1
#define SQLNodeGrantAdminPrivsChiAdminPrivList 1
#define SQLNodeGrantAdminPrivsChiGrntee 2
 
#define SQLNodeGrantRole 277
#define SQLNodeGrantRoleAnnWithAdminOption 1
#define SQLNodeGrantRoleChiRoles 1
#define SQLNodeGrantRoleChiGrntee 2
 
#define SQLNodeGrantSimplePrivs 279
#define SQLNodeGrantSimplePrivsAnnWithGrantOption 1
#define SQLNodeGrantSimplePrivsChiSimplePrivs 1
#define SQLNodeGrantSimplePrivsChiObjcts 2
#define SQLNodeGrantSimplePrivsChiGrntee 3
 
#define SQLNodeGrantThreshold 278
#define SQLNodeGrantThresholdAnnWithAdminOption 1
#define SQLNodeGrantThresholdChiLiteral 1
#define SQLNodeGrantThresholdChiGrntee 2
 
#define SQLNodeGrantedOptionAccess 287
#define SQLNodeGrantedOptionAccessChiAccessList 1
#define SQLNodeGrantedOptionAccessChiGrntee 2
 
#define SQLNodeGrantedOptionSimplePrivs 289
#define SQLNodeGrantedOptionSimplePrivsAnnCascadeOpt 1
#define SQLNodeGrantedOptionSimplePrivsChiSimplePrivs 1
#define SQLNodeGrantedOptionSimplePrivsChiObjcts 2
#define SQLNodeGrantedOptionSimplePrivsChiGrntee 3
#define SQLNodeGrantedOptionSimplePrivsChiAs 4
 
#define SQLNodeGrantedOptionThreshold 288
#define SQLNodeGrantedOptionThresholdChiGrntee 1
 
#define SQLNodeGroup 71
 
#define SQLNodeHaving 72
#define SQLNodeHavingChiPrdct 1
 
#define SQLNodeHostList 157
 
#define SQLNodeHostVar 135
#define SQLNodeHostVarChiHostRef 1
#define SQLNodeHostVarChiSubList 2
 
#define SQLNodeIUDTarget 309
#define SQLNodeIUDTargetChiTnameOrQuery 1
#define SQLNodeIUDTargetChiIdent 2
 
#define SQLNodeIdSpecList 83
 
#define SQLNodeIdent 153
#define SQLNodeIdentAnnName 1
 
#define SQLNodeIdentList 152
 
#define SQLNodeIdentity 191
#define SQLNodeIdentityAnnSeed 1
#define SQLNodeIdentityAnnIncrement 2
 
#define SQLNodeIgnoreIndexHint 319
 
#define SQLNodeIndexQualifiers 196
#define SQLNodeIndexQualifiersAnnIndexQualifierFirst 1
#define SQLNodeIndexQualifiersAnnClustered 2
 
#define SQLNodeIndexRef 320
#define SQLNodeIndexRefAnnName 1
 
#define SQLNodeInsrt 9
#define SQLNodeInsrtAnnOrUpdate 1
#define SQLNodeInsrtChiIud 1
#define SQLNodeInsrtChiIUDTarget 2
#define SQLNodeInsrtChiAsign 3
 
#define SQLNodeInstanceVariableHostRef 87
#define SQLNodeInstanceVariableHostRefAnnHostInstName 1
 
#define SQLNodeIsAllQterm 47
#define SQLNodeIsAllQtermAnnIsAll 1
#define SQLNodeIsAllQtermAnnIsParallel 2
#define SQLNodeIsAllQtermChiQterm 1
 
#define SQLNodeIud 76
#define SQLNodeIudAnnNOCHECK 1
#define SQLNodeIudAnnNOLOCK 2
#define SQLNodeIudAnnNOINDEX 3
#define SQLNodeIudAnnNOTRIGGER 4
 
#define SQLNodeJoins 64
 
#define SQLNodeJspecOn 68
#define SQLNodeJspecOnChiJcond 1
 
#define SQLNodeJspecUsing 69
#define SQLNodeJspecUsingChiFlist1 1
 
#define SQLNodeJtab 60
#define SQLNodeJtabChiFrmit 1
#define SQLNodeJtabChiJoins 2
 
#define SQLNodeLanguageClauseCOS 237
#define SQLNodeLanguageClauseCOSChiCodeLines 1
 
#define SQLNodeLanguageClauseSQL 236
#define SQLNodeLanguageClauseSQLChiCodeLines 1
 
#define SQLNodeList 113
 
#define SQLNodeLiteral 89
#define SQLNodeLiteralAnnValue 1
 
#define SQLNodeLocalVariableHostRef 86
#define SQLNodeLocalVariableHostRefAnnHostVarName 1
 
#define SQLNodeLocaleOption 268
#define SQLNodeLocaleOptionAnnLocaleSetting 1
#define SQLNodeLocaleOptionChiLiteral 1
 
#define SQLNodeLock 290
#define SQLNodeLockAnnShareExclusive 1
#define SQLNodeLockChiTref 1
#define SQLNodeLockChiWait 2
 
#define SQLNodeLockTimeout 270
#define SQLNodeLockTimeoutAnnSetting 1
 
#define SQLNodeMQCContainId 219
#define SQLNodeMQCContainIdAnnId 1
 
#define SQLNodeMQCFinal 222
 
#define SQLNodeMQCFor 221
#define SQLNodeMQCForChiTable 1
 
#define SQLNodeMQCPrivate 223
 
#define SQLNodeMQCProcedure 224
 
#define SQLNodeMQCResultSets 321
 
#define SQLNodeMQCResults 217
 
#define SQLNodeMQCReturns 216
#define SQLNodeMQCReturnsChiDatyp 1
 
#define SQLNodeMQCSelectMode 220
#define SQLNodeMQCSelectModeAnnSelectMode 1
 
#define SQLNodeMethodQueryCharacteristicsList 215
 
#define SQLNodeModCol 266
#define SQLNodeModColAnnNullNotNull 1
#define SQLNodeModColChiDefSpec 1
#define SQLNodeModColChiConstraint 2
 
#define SQLNodeModSpec 265
#define SQLNodeModSpecChiIdent 1
#define SQLNodeModSpecChiDatyp 2
#define SQLNodeModSpecChiModCol 3
 
#define SQLNodeNamedFconSpecCheck 180
#define SQLNodeNamedFconSpecCheckChiChkparse 1
 
#define SQLNodeNamedFconSpecDefault 173
#define SQLNodeNamedFconSpecDefaultChiDefSpec 1
 
#define SQLNodeNamedFconSpecPKU 178
#define SQLNodeNamedFconSpecPKUAnnPKU 1
#define SQLNodeNamedFconSpecPKUAnnClustered 2
 
#define SQLNodeNamedFconSpecReferences 179
#define SQLNodeNamedFconSpecReferencesChiRef 1
 
#define SQLNodeNaturalJoin 66
#define SQLNodeNaturalJoinAnnJop 1
#define SQLNodeNaturalJoinChiJtab 1
 
#define SQLNodeNegNumber 177
#define SQLNodeNegNumberAnnValue 1
 
#define SQLNodeNotNull 170
 
#define SQLNodeNull 138
 
#define SQLNodeObjectKeyword 148
#define SQLNodeObjectKeywordAnnKeyword 1
#define SQLNodeObjectKeywordChiBase 1
 
#define SQLNodeOdbcFunc 142
#define SQLNodeOdbcFuncAnnFunctionName 1
#define SQLNodeOdbcFuncChiOdbcFunctionArgs 1
 
#define SQLNodeOldOrNewValuesAlias 234
#define SQLNodeOldOrNewValuesAliasAnnIsNew 1
#define SQLNodeOldOrNewValuesAliasChiIdent 1
 
#define SQLNodeOldOrNewValuesAliasList 233
 
#define SQLNodeOpen 6
#define SQLNodeOpenChiIdent 1
 
#define SQLNodeOptScalx 305
#define SQLNodeOptScalxChiScalx 1
 
#define SQLNodeOptScalxList 304
 
#define SQLNodeOption 37
#define SQLNodeOptionChiOptionSetting 1
 
#define SQLNodeOptionalSqlArgument 301
#define SQLNodeOptionalSqlArgumentChiSqlArgument 1
 
#define SQLNodeOptionalValSpec1 329
#define SQLNodeOptionalValSpec1ChiValSpec1 1
 
#define SQLNodeOrder 73
 
#define SQLNodeOrdir 74
#define SQLNodeOrdirAnnAscDesc 1
#define SQLNodeOrdirChiOrdit 1
 
#define SQLNodeOrdit 75
#define SQLNodeOrditChiScalx 1
 
#define SQLNodeOtherJoin 67
#define SQLNodeOtherJoinAnnJop 1
#define SQLNodeOtherJoinChiJtab 1
#define SQLNodeOtherJoinChiJspec 2
 
#define SQLNodeOtherOption 271
#define SQLNodeOtherOptionAnnSetting 1
 
#define SQLNodeParam 85
#define SQLNodeParamChiVar 1
#define SQLNodeParamChiSubList 2
 
#define SQLNodeParameterDeclaration 214
#define SQLNodeParameterDeclarationAnnInOut 1
#define SQLNodeParameterDeclarationChiIdent 1
#define SQLNodeParameterDeclarationChiDatyp 2
#define SQLNodeParameterDeclarationChiDefaultClause 3
 
#define SQLNodeParameterList 213
 
#define SQLNodeParameterMarker 137
 
#define SQLNodeParenPrdct 147
#define SQLNodeParenPrdctChiPrdct 1
 
#define SQLNodePrdct 92
#define SQLNodePrdctChiAnd 1
#define SQLNodePrdctChiPrdctTail 2
 
#define SQLNodePrdctTail 112
 
#define SQLNodePrdctTailTerm 295
#define SQLNodePrdctTailTermAnnOrOperator 1
#define SQLNodePrdctTailTermChiAnd 1
 
#define SQLNodePrivSpecAction 293
#define SQLNodePrivSpecActionAnnAction 1
#define SQLNodePrivSpecActionChiFlist1 1
 
#define SQLNodePrivSpecThreshold 242
 
#define SQLNodeQualifiedName 62
#define SQLNodeQualifiedNameAnnName 1
 
#define SQLNodeQualifiedSpname 211
#define SQLNodeQualifiedSpnameAnnCompleteName 1
 
#define SQLNodeQuery 45
#define SQLNodeQueryChiQterm 1
#define SQLNodeQueryChiQueryTail 2
 
#define SQLNodeQueryTail 46
 
#define SQLNodeRef 163
#define SQLNodeRefAnnMatch 1
#define SQLNodeRefChiTname 1
#define SQLNodeRefChiFlist1 2
#define SQLNodeRefChiTriggeredAction2 3
 
#define SQLNodeReferenceVariableHostRef 317
#define SQLNodeReferenceVariableHostRefAnnHostRefvarName 1
 
#define SQLNodeResultColumn 218
#define SQLNodeResultColumnChiColmn 1
#define SQLNodeResultColumnChiDatyp 2
 
#define SQLNodeRevokeAdminPrivs 284
#define SQLNodeRevokeAdminPrivsChiAdminPrivList 1
#define SQLNodeRevokeAdminPrivsChiGrntee 2
 
#define SQLNodeRevokeGrantedOption 286
#define SQLNodeRevokeGrantedOptionChiGrantedOption 1
 
#define SQLNodeRevokeRole 285
#define SQLNodeRevokeRoleChiRoles 1
#define SQLNodeRevokeRoleChiGrntee 2
 
#define SQLNodeRollb 38
#define SQLNodeRollbAnnToSavepoint 1
#define SQLNodeRollbChiIdent 1
 
#define SQLNodeSQLMethodBody 225
 
#define SQLNodeSavePoint 43
#define SQLNodeSavePointChiIdent 1
 
#define SQLNodeScalarFunction 117
#define SQLNodeScalarFunctionAnnFunctionName 1
#define SQLNodeScalarFunctionChiScalarFunctionArgs 1
 
#define SQLNodeScalx 114
#define SQLNodeScalxChiTerm 1
#define SQLNodeScalxChiScalxTail 2
 
#define SQLNodeScalxAsCastType 118
#define SQLNodeScalxAsCastTypeChiScalx 1
#define SQLNodeScalxAsCastTypeChiCast 2
 
#define SQLNodeScalxConvertType 144
#define SQLNodeScalxConvertTypeAnnConvertType 1
#define SQLNodeScalxConvertTypeChiValue 1
 
#define SQLNodeScalxInScalx 123
#define SQLNodeScalxInScalxChiValue1 1
#define SQLNodeScalxInScalxChiValue2 2
 
#define SQLNodeScalxOptAS 128
#define SQLNodeScalxOptASChiScalx 1
#define SQLNodeScalxOptASChiAs 2
 
#define SQLNodeScalxOptASList 127
 
#define SQLNodeScalxTail 150
 
#define SQLNodeScalxTailTerm 151
#define SQLNodeScalxTailTermAnnScalop 1
#define SQLNodeScalxTailTermChiTerm 1
 
#define SQLNodeSchemaList 326
 
#define SQLNodeSelct 4
#define SQLNodeSelctChiQuery 1
#define SQLNodeSelctChiOrder 2
 
#define SQLNodeSelectList 51
 
#define SQLNodeSelex 48
#define SQLNodeSelexChiSelst 1
#define SQLNodeSelexChiFromClause 2
#define SQLNodeSelexChiWhereClause 3
#define SQLNodeSelexChiGroup 4
#define SQLNodeSelexChiHaving 5
#define SQLNodeSelexChiOrder 6
 
#define SQLNodeSelst 49
#define SQLNodeSelstAnnPercentNolock 1
#define SQLNodeSelstChiDist 1
#define SQLNodeSelstChiTopClause 2
#define SQLNodeSelstChiSelectList 3
#define SQLNodeSelstChiInto 4
 
#define SQLNodeSettp 294
#define SQLNodeSettpAnnCommitMode 1
 
#define SQLNodeSimplePriv 282
#define SQLNodeSimplePrivAnnName 1
 
#define SQLNodeSimplePrivList 281
 
#define SQLNodeSql 2
#define SQLNodeSqlChiViewColumnList 1
#define SQLNodeSqlChiStatPart 2
 
#define SQLNodeSqlArgumentList 300
 
#define SQLNodeSqlStatementBlock 238
#define SQLNodeSqlStatementBlockAnnAtomic 1
 
#define SQLNodeSqlcollation 182
#define SQLNodeSqlcollationAnnSqlcollationType 1
#define SQLNodeSqlcollationChiLiteral 1
 
#define SQLNodeStar 52
 
#define SQLNodeStarttp 40
#define SQLNodeStarttpAnnTpOption 1
 
#define SQLNodeStringOperation 132
#define SQLNodeStringOperationAnnStringOp 1
#define SQLNodeStringOperationChiStringOperationTerm 1
 
#define SQLNodeStringOperationLT 133
#define SQLNodeStringOperationLTChiLiteral 1
#define SQLNodeStringOperationLTChiTerm 2
 
#define SQLNodeStringOperationSL 134
#define SQLNodeStringOperationSLChiScalx 1
#define SQLNodeStringOperationSLChiLiteral 2
 
#define SQLNodeSubList 88
 
#define SQLNodeSubstringArgs 124
#define SQLNodeSubstringArgsChiBase 1
#define SQLNodeSubstringArgsChiStart 2
#define SQLNodeSubstringArgsChiLength 3
 
#define SQLNodeTableValuedFunction 327
#define SQLNodeTableValuedFunctionChiQualifiedName 1
#define SQLNodeTableValuedFunctionChiTableValuedFunctionArgumentList 2
#define SQLNodeTableValuedFunctionChiAs 3
 
#define SQLNodeTableValuedFunctionArgumentList 328
 
#define SQLNodeTables 56
#define SQLNodeTablesChiCSPOrPPTables 1
#define SQLNodeTablesChiTrefList 2
 
#define SQLNodeTecdef 166
#define SQLNodeTecdefChiIdent 1
#define SQLNodeTecdefChiDatyp 2
#define SQLNodeTecdefChiIdentity 3
#define SQLNodeTecdefChiFldQualifierList 4
 
#define SQLNodeTelem 159
#define SQLNodeTelemChiConstraint 1
#define SQLNodeTelemChiTelemOption 2
 
#define SQLNodeTelemList 158
 
#define SQLNodeTelemOptionClassParameter 311
#define SQLNodeTelemOptionClassParameterChiIdent 1
#define SQLNodeTelemOptionClassParameterChiLiteral 2
 
#define SQLNodeTelemOptionForeignKey 162
#define SQLNodeTelemOptionForeignKeyChiFlist2 1
#define SQLNodeTelemOptionForeignKeyChiRef 2
 
#define SQLNodeTelemOptionPKU 160
#define SQLNodeTelemOptionPKUAnnPKU 1
#define SQLNodeTelemOptionPKUAnnClustered 2
#define SQLNodeTelemOptionPKUChiFlist2 1
#define SQLNodeTelemOptionPKUChiWithFillFactor 2
 
#define SQLNodeTelemOptionPercent 165
#define SQLNodeTelemOptionPercentAnnTelemOptionPercentKWs 1
#define SQLNodeTelemOptionPercentChiLiteral 1
 
#define SQLNodeTelemOptionPublicRowid 310
 
#define SQLNodeTname 154
#define SQLNodeTnameChiQualifiedName 1
 
#define SQLNodeTnameList 283
 
#define SQLNodeTnameOptAlias 155
#define SQLNodeTnameOptAliasChiQualifiedName 1
#define SQLNodeTnameOptAliasChiAlias 2
 
#define SQLNodeTnameQualifierDropExisting 201
 
#define SQLNodeTnameQualifierFillFactor 199
#define SQLNodeTnameQualifierFillFactorChiLiteral 1
 
#define SQLNodeTnameQualifierIgnoreDupKey 200
 
#define SQLNodeTnameQualifierPadIndex 198
 
#define SQLNodeTnameQualifierStatisticsNoRecompute 202
 
#define SQLNodeTnameQualifiers 197
 
#define SQLNodeTopAll 302
 
#define SQLNodeTopClause 171
#define SQLNodeTopClauseAnnParenCount 1
#define SQLNodeTopClauseChiValSpec1A 1
 
#define SQLNodeTref 59
#define SQLNodeTrefAnnOJSyntax 1
#define SQLNodeTrefChiJtab 1
 
#define SQLNodeTrefList 58
 
#define SQLNodeTriggerEventDELETE 231
 
#define SQLNodeTriggerEventINSERT 230
 
#define SQLNodeTriggerEventUPDATE 232
#define SQLNodeTriggerEventUPDATEChiColmnList 1
 
#define SQLNodeTriggeredAction1 235
#define SQLNodeTriggeredAction1AnnRowStatement 1
#define SQLNodeTriggeredAction1ChiWhen 1
#define SQLNodeTriggeredAction1ChiLanguageClause 2
 
#define SQLNodeTriggeredAction2 164
#define SQLNodeTriggeredAction2AnnUpdate 1
#define SQLNodeTriggeredAction2AnnDelete 2
 
#define SQLNodeTrimArgs 125
#define SQLNodeTrimArgsAnnTrimspec 1
#define SQLNodeTrimArgsChiLhs 1
#define SQLNodeTrimArgsChiRhs 2
 
#define SQLNodeTrmodeDiagnostics 299
#define SQLNodeTrmodeDiagnosticsChiSize 1
 
#define SQLNodeTrmodeIsolationLevel 296
#define SQLNodeTrmodeIsolationLevelAnnIsolationLevel 1
 
#define SQLNodeTrmodeReadOnly 297
 
#define SQLNodeTrmodeReadWrite 298
 
#define SQLNodeTruncate 44
#define SQLNodeTruncateChiTname 1
 
#define SQLNodeTsInterval2Scalx 143
#define SQLNodeTsInterval2ScalxAnnIntervalKeyword 1
#define SQLNodeTsInterval2ScalxChiValue1 1
#define SQLNodeTsInterval2ScalxChiValue2 2
 
#define SQLNodeUSER 303
 
#define SQLNodeUnaryTerm 131
#define SQLNodeUnaryTermAnnUnaryOp 1
#define SQLNodeUnaryTermChiTerm 1
 
#define SQLNodeUnlock 291
#define SQLNodeUnlockAnnShareExclusive 1
#define SQLNodeUnlockAnnImmediate 2
#define SQLNodeUnlockChiTref 1
 
#define SQLNodeUpdat 10
#define SQLNodeUpdatChiIud 1
#define SQLNodeUpdatChiIUDTarget 2
#define SQLNodeUpdatChiAsign 3
#define SQLNodeUpdatChiSecondary 4
#define SQLNodeUpdatChiWerop 5
 
#define SQLNodeUpdateStats 12
#define SQLNodeUpdateStatsChiTname 1
 
#define SQLNodeUpdtcls 156
#define SQLNodeUpdtclsAnnIsReadOnly 1
 
#define SQLNodeUserDefinedFunction 149
#define SQLNodeUserDefinedFunctionChiFunction 1
#define SQLNodeUserDefinedFunctionChiList 2
 
#define SQLNodeUserList 273
 
#define SQLNodeUserName 146
#define SQLNodeUserNameAnnValue 1
 
#define SQLNodeValspec2Scalars 84
 
#define SQLNodeWeropCurrentOf 90
#define SQLNodeWeropCurrentOfChiIdent 1
#define SQLNodeWeropCurrentOfChiPrdct 2
 
#define SQLNodeWeropPrdct 91
#define SQLNodeWeropPrdctChiPrdct 1
 
#define SQLNodeXtfun 136
#define SQLNodeXtfunAnnXtfuncref 1
#define SQLNodeXtfunChiList 1
 
#define SQLEnumAggFuncNone 0
#define SQLEnumAggFuncAVG 1
#define SQLEnumAggFuncSUM 2
#define SQLEnumAggFuncMAX 3
#define SQLEnumAggFuncMIN 4
#define SQLEnumAggFuncCOUNT 5
#define SQLEnumAggFuncLIST 6
#define SQLEnumAggFuncXMLAGG 7
#define SQLEnumAggFuncpcDLIST 8
 
#define SQLEnumAscDescNone 0
#define SQLEnumAscDescASC 1
#define SQLEnumAscDescDESC 2
 
#define SQLEnumBeforeAfterNone 0
#define SQLEnumBeforeAfterBEFORE 1
#define SQLEnumBeforeAfterAFTER 2
 
#define SQLEnumCascadeOptNone 0
#define SQLEnumCascadeOptRESTRICT 1
#define SQLEnumCascadeOptCASCADE 2
 
#define SQLEnumCascadeRestrictNone 0
#define SQLEnumCascadeRestrictCASCADE 1
#define SQLEnumCascadeRestrictRESTRICT 2
 
#define SQLEnumCheckSpecNone 0
#define SQLEnumCheckSpecCHECK 1
#define SQLEnumCheckSpecNOCHECK 2
 
#define SQLEnumClusteredNone 0
#define SQLEnumClusteredCLUSTERED 1
#define SQLEnumClusteredNONCLUSTERED 2
 
#define SQLEnumCommitModeNone 0
#define SQLEnumCommitModeIMPLICIT 1
#define SQLEnumCommitModeEXPLICIT 2
#define SQLEnumCommitModeKWNONE 3
 
#define SQLEnumCompileOptionSettingNone 0
#define SQLEnumCompileOptionSettingCOMPILEMODE 1
#define SQLEnumCompileOptionSettingDEFERRED 2
#define SQLEnumCompileOptionSettingIMMEDIATE 3
#define SQLEnumCompileOptionSettingINSTALL 4
 
#define SQLEnumDataOptionNone 0
#define SQLEnumDataOptionpcDELDATA 1
#define SQLEnumDataOptionpcNODELDATA 2
 
#define SQLEnumDtsNone 0
#define SQLEnumDtsD 1
#define SQLEnumDtsT 2
#define SQLEnumDtsTS 3
 
#define SQLEnumEnvKeywordNone 0
#define SQLEnumEnvKeywordCURRENTDATE 1
#define SQLEnumEnvKeywordCURRENTTIME 2
#define SQLEnumEnvKeywordSYSDATE 3
#define SQLEnumEnvKeywordUSER 4
#define SQLEnumEnvKeywordCURRENTUSER 5
#define SQLEnumEnvKeywordSESSIONUSER 6
#define SQLEnumEnvKeywordSYSTEMUSER 7
#define SQLEnumEnvKeywordGETDATE 8
 
#define SQLEnumGrantOptNone 0
#define SQLEnumGrantOptGRANT 1
#define SQLEnumGrantOptADMIN 2
 
#define SQLEnumInOutNone 0
#define SQLEnumInOutIN 1
#define SQLEnumInOutINOUT 2
#define SQLEnumInOutOUT 3
 
#define SQLEnumIndexQualifierFirstNone 0
#define SQLEnumIndexQualifierFirstUNIQUE 1
#define SQLEnumIndexQualifierFirstBITMAP 2
#define SQLEnumIndexQualifierFirstBITSLICE 3
 
#define SQLEnumIsolationLevelNone 0
#define SQLEnumIsolationLevelREADUNCOMMITTED 1
#define SQLEnumIsolationLevelREADCOMMITTED 2
#define SQLEnumIsolationLevelREPEATABLEREAD 3
#define SQLEnumIsolationLevelSERIALIZABLE 4
 
#define SQLEnumJopNone 0
#define SQLEnumJopJOIN 1
#define SQLEnumJopINNERJOIN 2
#define SQLEnumJopLEFTJOIN 3
#define SQLEnumJopRIGHTJOIN 4
#define SQLEnumJopFULLJOIN 5
 
#define SQLEnumLevelsClauseNone 0
#define SQLEnumLevelsClauseCASCADE 1
#define SQLEnumLevelsClauseLOCAL 2
 
#define SQLEnumLockModeNone 0
#define SQLEnumLockModeROW 1
#define SQLEnumLockModePAGE 2
 
#define SQLEnumMatchNone 0
#define SQLEnumMatchFULL 1
#define SQLEnumMatchPARTIAL 2
 
#define SQLEnumNullNotNullNone 0
#define SQLEnumNullNotNullNULL 1
#define SQLEnumNullNotNullNOTNULL 2
 
#define SQLEnumPKUNone 0
#define SQLEnumPKUUNIQUE 1
#define SQLEnumPKUPRIMARYKEY 2
 
#define SQLEnumQueryPartTypeNone 0
#define SQLEnumQueryPartTypeGETINFO 1
#define SQLEnumQueryPartTypeEXECUTE 2
#define SQLEnumQueryPartTypeFETCH 3
#define SQLEnumQueryPartTypeFETCHODBC 4
#define SQLEnumQueryPartTypeFETCHROWS 5
#define SQLEnumQueryPartTypeCLOSE 6
 
#define SQLEnumRefActionNone 0
#define SQLEnumRefActionNOACTION 1
#define SQLEnumRefActionCASCADE 2
#define SQLEnumRefActionSETNULL 3
#define SQLEnumRefActionSETDEFAULT 4
 
#define SQLEnumRowPageNone 0
#define SQLEnumRowPageROW 1
#define SQLEnumRowPagePAGE 2
 
#define SQLEnumRowStatementNone 0
#define SQLEnumRowStatementROW 1
#define SQLEnumRowStatementSTATEMENT 2
#define SQLEnumRowStatementROW_AND_OBJECT 3
 
#define SQLEnumSelectModeNone 0
#define SQLEnumSelectModeRUNTIME 1
#define SQLEnumSelectModeODBC 2
#define SQLEnumSelectModeLOGICAL 3
#define SQLEnumSelectModeDISPLAY 4
 
#define SQLEnumShareExclusiveNone 0
#define SQLEnumShareExclusiveSHARE 1
#define SQLEnumShareExclusiveEXCLUSIVE 2
 
#define SQLEnumSqlcollationTypeNone 0
#define SQLEnumSqlcollationTypepcALPHAUP 1
#define SQLEnumSqlcollationTypepcEXACT 2
#define SQLEnumSqlcollationTypepcMINUS 3
#define SQLEnumSqlcollationTypepcPLUS 4
#define SQLEnumSqlcollationTypepcSPACE 5
#define SQLEnumSqlcollationTypepcUPPER 6
#define SQLEnumSqlcollationTypepcSQLSTRING 7
#define SQLEnumSqlcollationTypepcSQLUPPER 8
#define SQLEnumSqlcollationTypepcSTRING 9
 
#define SQLEnumSubqueryScopeNone 0
#define SQLEnumSubqueryScopeALL 1
#define SQLEnumSubqueryScopeANY 2
#define SQLEnumSubqueryScopeSOME 3
 
#define SQLEnumTableScopeNone 0
#define SQLEnumTableScopePRIVATE 1
#define SQLEnumTableScopeGLOBAL 2
 
#define SQLEnumTelemOptionPercentKWsNone 0
#define SQLEnumTelemOptionPercentKWspcDESCRIPTION 1
#define SQLEnumTelemOptionPercentKWspcFILE 2
#define SQLEnumTelemOptionPercentKWspcNUMROWS 3
#define SQLEnumTelemOptionPercentKWspcROUTINE 4
#define SQLEnumTelemOptionPercentKWspcEXTENTSIZE 5
 
#define SQLEnumTpOptionNone 0
#define SQLEnumTpOptionpcINTRANSACTION 1
#define SQLEnumTpOptionpcBEGTRANS 2
#define SQLEnumTpOptionpcINTRANS 3
#define SQLEnumTpOptionCOMMIT 4
 
#define SQLEnumTrimspecNone 0
#define SQLEnumTrimspecLEADING 1
#define SQLEnumTrimspecTRAILING 2
#define SQLEnumTrimspecBOTH 3
 

#endif
