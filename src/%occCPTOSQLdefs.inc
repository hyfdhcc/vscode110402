ROUTINE %occCPTOSQLdefs [Type=INC]
#;
#; GENERATED USING %CPT.MakeDefsInclude - DO NOT EDIT
#;
 
#include %occCPTconfig
 

#if $$$HPTDYNMETADATA

#define OSQLNodeAPivotInClauseBody $$$CPTIXNODER("OSQL","APivotInClauseBody")
 
#define OSQLNodeAsConstantOrParenList $$$CPTIXNODER("OSQL","AsConstantOrParenList")
#define OSQLNodeAsConstantOrParenListChiConstantOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeAsConstantOrParenList,"ConstantOrParenList")
 
#define OSQLNodeAsSuffix $$$CPTIXNODER("OSQL","AsSuffix")
#define OSQLNodeAsSuffixAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeAsSuffix,"Literal")
#define OSQLNodeAsSuffixChiColumnAlias $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeAsSuffix,"ColumnAlias")
 
#define OSQLNodeAtDBLink $$$CPTIXNODER("OSQL","AtDBLink")
#define OSQLNodeAtDBLinkChiDBLink $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeAtDBLink,"DBLink")
 
#define OSQLNodeBlock $$$CPTIXNODER("OSQL","Block")
#define OSQLNodeBlockChiDeclSection $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeBlock,"DeclSection")
#define OSQLNodeBlockChiSimpleBlock $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeBlock,"SimpleBlock")
 
#define OSQLNodeCASingleList $$$CPTIXNODER("OSQL","CASingleList")
 
#define OSQLNodeCRODimPartDim $$$CPTIXNODER("OSQL","CRODimPartDim")
 
#define OSQLNodeCRODimPartSing $$$CPTIXNODER("OSQL","CRODimPartSing")
 
#define OSQLNodeCRONavPart $$$CPTIXNODER("OSQL","CRONavPart")
#define OSQLNodeCRONavPartAnnCROIgnoreOrKeep $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeCRONavPart,"CROIgnoreOrKeep")
 
#define OSQLNodeCROUniquePart $$$CPTIXNODER("OSQL","CROUniquePart")
#define OSQLNodeCROUniquePartChiCRODimPart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeCROUniquePart,"CRODimPart")
 
#define OSQLNodeCellAssignment $$$CPTIXNODER("OSQL","CellAssignment")
#define OSQLNodeCellAssignmentChiMeasureColumn $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeCellAssignment,"MeasureColumn")
#define OSQLNodeCellAssignmentChiCABody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeCellAssignment,"CABody")
 
#define OSQLNodeCellReferenceOptions $$$CPTIXNODER("OSQL","CellReferenceOptions")
#define OSQLNodeCellReferenceOptionsChiCRONavPart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeCellReferenceOptions,"CRONavPart")
#define OSQLNodeCellReferenceOptionsChiCROUniquePart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeCellReferenceOptions,"CROUniquePart")
 
#define OSQLNodeCollectionExpression $$$CPTIXNODER("OSQL","CollectionExpression")
#define OSQLNodeCollectionExpressionChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeCollectionExpression,"STUB")
 
#define OSQLNodeColumn $$$CPTIXNODER("OSQL","Column")
#define OSQLNodeColumnAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeColumn,"Name")
 
#define OSQLNodeColumnAlias $$$CPTIXNODER("OSQL","ColumnAlias")
#define OSQLNodeColumnAliasAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeColumnAlias,"Name")
 
#define OSQLNodeCondition $$$CPTIXNODER("OSQL","Condition")
#define OSQLNodeConditionAnnString $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeCondition,"String")
 
#define OSQLNodeConstant $$$CPTIXNODER("OSQL","Constant")
#define OSQLNodeConstantAnnString $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeConstant,"String")
 
#define OSQLNodeConstraint $$$CPTIXNODER("OSQL","Constraint")
#define OSQLNodeConstraintChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeConstraint,"STUB")
 
#define OSQLNodeDBLink $$$CPTIXNODER("OSQL","DBLink")
#define OSQLNodeDBLinkChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeDBLink,"STUB")
 
#define OSQLNodeDecl $$$CPTIXNODER("OSQL","Decl")
#define OSQLNodeDeclAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeDecl,"Name")
#define OSQLNodeDeclChiDeclType $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeDecl,"DeclType")
 
#define OSQLNodeDeclSection $$$CPTIXNODER("OSQL","DeclSection")
 
#define OSQLNodeDeclType $$$CPTIXNODER("OSQL","DeclType")
#define OSQLNodeDeclTypeAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeDeclType,"Name")
 
#define OSQLNodeDimensionColumn $$$CPTIXNODER("OSQL","DimensionColumn")
#define OSQLNodeDimensionColumnChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeDimensionColumn,"STUB")
 
#define OSQLNodeDimensionColumnList $$$CPTIXNODER("OSQL","DimensionColumnList")
 
#define OSQLNodeEPivotInClauseBody $$$CPTIXNODER("OSQL","EPivotInClauseBody")
 
#define OSQLNodeEPivotInClauseTerm $$$CPTIXNODER("OSQL","EPivotInClauseTerm")
#define OSQLNodeEPivotInClauseTermChiExprOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeEPivotInClauseTerm,"ExprOrParenList")
#define OSQLNodeEPivotInClauseTermChiAsSuffix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeEPivotInClauseTerm,"AsSuffix")
 
#define OSQLNodeExcpHandler $$$CPTIXNODER("OSQL","ExcpHandler")
#define OSQLNodeExcpHandlerChiExcpWhen $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExcpHandler,"ExcpWhen")
#define OSQLNodeExcpHandlerChiStatements $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExcpHandler,"Statements")
 
#define OSQLNodeExcpSection $$$CPTIXNODER("OSQL","ExcpSection")
 
#define OSQLNodeExcpWhenNameList $$$CPTIXNODER("OSQL","ExcpWhenNameList")
 
#define OSQLNodeExcpWhenOthers $$$CPTIXNODER("OSQL","ExcpWhenOthers")
 
#define OSQLNodeExprDAnd $$$CPTIXNODER("OSQL","ExprDAnd")
#define OSQLNodeExprDAndChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDAnd,"Lhs")
#define OSQLNodeExprDAndChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDAnd,"Rhs")
 
#define OSQLNodeExprDConcat $$$CPTIXNODER("OSQL","ExprDConcat")
#define OSQLNodeExprDConcatChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDConcat,"Lhs")
#define OSQLNodeExprDConcatChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDConcat,"Rhs")
 
#define OSQLNodeExprDDivide $$$CPTIXNODER("OSQL","ExprDDivide")
#define OSQLNodeExprDDivideChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDDivide,"Lhs")
#define OSQLNodeExprDDivideChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDDivide,"Rhs")
 
#define OSQLNodeExprDEqual $$$CPTIXNODER("OSQL","ExprDEqual")
#define OSQLNodeExprDEqualChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDEqual,"Lhs")
#define OSQLNodeExprDEqualChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDEqual,"Rhs")
 
#define OSQLNodeExprDGreaterThan $$$CPTIXNODER("OSQL","ExprDGreaterThan")
#define OSQLNodeExprDGreaterThanChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDGreaterThan,"Lhs")
#define OSQLNodeExprDGreaterThanChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDGreaterThan,"Rhs")
 
#define OSQLNodeExprDGreaterThanOrEqual $$$CPTIXNODER("OSQL","ExprDGreaterThanOrEqual")
#define OSQLNodeExprDGreaterThanOrEqualChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDGreaterThanOrEqual,"Lhs")
#define OSQLNodeExprDGreaterThanOrEqualChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDGreaterThanOrEqual,"Rhs")
 
#define OSQLNodeExprDLessThan $$$CPTIXNODER("OSQL","ExprDLessThan")
#define OSQLNodeExprDLessThanChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDLessThan,"Lhs")
#define OSQLNodeExprDLessThanChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDLessThan,"Rhs")
 
#define OSQLNodeExprDLessThanOrEqual $$$CPTIXNODER("OSQL","ExprDLessThanOrEqual")
#define OSQLNodeExprDLessThanOrEqualChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDLessThanOrEqual,"Lhs")
#define OSQLNodeExprDLessThanOrEqualChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDLessThanOrEqual,"Rhs")
 
#define OSQLNodeExprDMinus $$$CPTIXNODER("OSQL","ExprDMinus")
#define OSQLNodeExprDMinusChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDMinus,"Lhs")
#define OSQLNodeExprDMinusChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDMinus,"Rhs")
 
#define OSQLNodeExprDNotEqual $$$CPTIXNODER("OSQL","ExprDNotEqual")
#define OSQLNodeExprDNotEqualChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDNotEqual,"Lhs")
#define OSQLNodeExprDNotEqualChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDNotEqual,"Rhs")
 
#define OSQLNodeExprDOr $$$CPTIXNODER("OSQL","ExprDOr")
#define OSQLNodeExprDOrChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDOr,"Lhs")
#define OSQLNodeExprDOrChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDOr,"Rhs")
 
#define OSQLNodeExprDPlus $$$CPTIXNODER("OSQL","ExprDPlus")
#define OSQLNodeExprDPlusChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDPlus,"Lhs")
#define OSQLNodeExprDPlusChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDPlus,"Rhs")
 
#define OSQLNodeExprDTimes $$$CPTIXNODER("OSQL","ExprDTimes")
#define OSQLNodeExprDTimesChiLhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDTimes,"Lhs")
#define OSQLNodeExprDTimesChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprDTimes,"Rhs")
 
#define OSQLNodeExprList $$$CPTIXNODER("OSQL","ExprList")
 
#define OSQLNodeExprMMinus $$$CPTIXNODER("OSQL","ExprMMinus")
#define OSQLNodeExprMMinusChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprMMinus,"Rhs")
 
#define OSQLNodeExprMPlus $$$CPTIXNODER("OSQL","ExprMPlus")
#define OSQLNodeExprMPlusChiRhs $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprMPlus,"Rhs")
 
#define OSQLNodeExprNode $$$CPTIXNODER("OSQL","ExprNode")
#define OSQLNodeExprNodeChiExpr $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprNode,"Expr")
 
#define OSQLNodeExprParen $$$CPTIXNODER("OSQL","ExprParen")
#define OSQLNodeExprParenChiExpr $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeExprParen,"Expr")
 
#define OSQLNodeFUCOfPart $$$CPTIXNODER("OSQL","FUCOfPart")
#define OSQLNodeFUCOfPartChiFUCOfTermList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFUCOfPart,"FUCOfTermList")
 
#define OSQLNodeFUCOfTerm $$$CPTIXNODER("OSQL","FUCOfTerm")
#define OSQLNodeFUCOfTermChiFUCOfTermTablePart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFUCOfTerm,"FUCOfTermTablePart")
#define OSQLNodeFUCOfTermChiColumn $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFUCOfTerm,"Column")
 
#define OSQLNodeFUCOfTermList $$$CPTIXNODER("OSQL","FUCOfTermList")
 
#define OSQLNodeFUCOfTermTablePart $$$CPTIXNODER("OSQL","FUCOfTermTablePart")
#define OSQLNodeFUCOfTermTablePartChiSchemaPrefix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFUCOfTermTablePart,"SchemaPrefix")
#define OSQLNodeFUCOfTermTablePartChiTVName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFUCOfTermTablePart,"TVName")
 
#define OSQLNodeFUCTailNowait $$$CPTIXNODER("OSQL","FUCTailNowait")
 
#define OSQLNodeFUCTailSkip $$$CPTIXNODER("OSQL","FUCTailSkip")
 
#define OSQLNodeFUCTailWait $$$CPTIXNODER("OSQL","FUCTailWait")
#define OSQLNodeFUCTailWaitChiInteger $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFUCTailWait,"Integer")
 
#define OSQLNodeFlashbackQueryClause $$$CPTIXNODER("OSQL","FlashbackQueryClause")
#define OSQLNodeFlashbackQueryClauseAnnScnOrTimestamp $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeFlashbackQueryClause,"ScnOrTimestamp")
#define OSQLNodeFlashbackQueryClauseChiExprOrMinValue $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFlashbackQueryClause,"ExprOrMinValue")
#define OSQLNodeFlashbackQueryClauseChiExprOrMaxValue $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeFlashbackQueryClause,"ExprOrMaxValue")
 
#define OSQLNodeForUpdateClause $$$CPTIXNODER("OSQL","ForUpdateClause")
#define OSQLNodeForUpdateClauseChiFUCOfPart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeForUpdateClause,"FUCOfPart")
#define OSQLNodeForUpdateClauseChiFUCTail $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeForUpdateClause,"FUCTail")
 
#define OSQLNodeFromClause $$$CPTIXNODER("OSQL","FromClause")
 
#define OSQLNodeGBCBodyList $$$CPTIXNODER("OSQL","GBCBodyList")
 
#define OSQLNodeGBCHaving $$$CPTIXNODER("OSQL","GBCHaving")
#define OSQLNodeGBCHavingChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeGBCHaving,"Condition")
 
#define OSQLNodeGSCBodyList $$$CPTIXNODER("OSQL","GSCBodyList")
 
#define OSQLNodeGroupByClause $$$CPTIXNODER("OSQL","GroupByClause")
#define OSQLNodeGroupByClauseChiGBCBodyList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeGroupByClause,"GBCBodyList")
#define OSQLNodeGroupByClauseChiGBCHaving $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeGroupByClause,"GBCHaving")
 
#define OSQLNodeGroupingExpressionList $$$CPTIXNODER("OSQL","GroupingExpressionList")
 
#define OSQLNodeGroupingSetsClause $$$CPTIXNODER("OSQL","GroupingSetsClause")
#define OSQLNodeGroupingSetsClauseChiGSCBodyList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeGroupingSetsClause,"GSCBodyList")
 
#define OSQLNodeHQCConnect $$$CPTIXNODER("OSQL","HQCConnect")
#define OSQLNodeHQCConnectAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeHQCConnect,"Literal")
#define OSQLNodeHQCConnectChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHQCConnect,"Condition")
 
#define OSQLNodeHQCConnectStart $$$CPTIXNODER("OSQL","HQCConnectStart")
#define OSQLNodeHQCConnectStartChiHQCConnect $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHQCConnectStart,"HQCConnect")
#define OSQLNodeHQCConnectStartChiHQCStart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHQCConnectStart,"HQCStart")
 
#define OSQLNodeHQCStart $$$CPTIXNODER("OSQL","HQCStart")
#define OSQLNodeHQCStartChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHQCStart,"Condition")
 
#define OSQLNodeHQCStartConnect $$$CPTIXNODER("OSQL","HQCStartConnect")
#define OSQLNodeHQCStartConnectChiHQCStart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHQCStartConnect,"HQCStart")
#define OSQLNodeHQCStartConnectChiHQCConnect $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHQCStartConnect,"HQCConnect")
 
#define OSQLNodeHavingClause $$$CPTIXNODER("OSQL","HavingClause")
#define OSQLNodeHavingClauseChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeHavingClause,"STUB")
 
#define OSQLNodeICJCCross $$$CPTIXNODER("OSQL","ICJCCross")
#define OSQLNodeICJCCrossChiICJCCrossStart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeICJCCross,"ICJCCrossStart")
#define OSQLNodeICJCCrossChiTableReference $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeICJCCross,"TableReference")
 
#define OSQLNodeICJCCrossCross $$$CPTIXNODER("OSQL","ICJCCrossCross")
 
#define OSQLNodeICJCCrossNatural $$$CPTIXNODER("OSQL","ICJCCrossNatural")
#define OSQLNodeICJCCrossNaturalAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeICJCCrossNatural,"Literal")
 
#define OSQLNodeICJCInner $$$CPTIXNODER("OSQL","ICJCInner")
#define OSQLNodeICJCInnerAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeICJCInner,"Literal")
#define OSQLNodeICJCInnerChiTableReference $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeICJCInner,"TableReference")
#define OSQLNodeICJCInnerChiICJCInnerTail $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeICJCInner,"ICJCInnerTail")
 
#define OSQLNodeICJCInnerTailOn $$$CPTIXNODER("OSQL","ICJCInnerTailOn")
#define OSQLNodeICJCInnerTailOnChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeICJCInnerTailOn,"Condition")
 
#define OSQLNodeICJCInnerTailUsing $$$CPTIXNODER("OSQL","ICJCInnerTailUsing")
 
#define OSQLNodeInclExclNulls $$$CPTIXNODER("OSQL","InclExclNulls")
#define OSQLNodeInclExclNullsAnnInclExcl $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeInclExclNulls,"InclExcl")
 
#define OSQLNodeInteger $$$CPTIXNODER("OSQL","Integer")
#define OSQLNodeIntegerChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeInteger,"STUB")
 
#define OSQLNodeJCSuffixList $$$CPTIXNODER("OSQL","JCSuffixList")
 
#define OSQLNodeJoinClause $$$CPTIXNODER("OSQL","JoinClause")
#define OSQLNodeJoinClauseChiTableReference $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeJoinClause,"TableReference")
#define OSQLNodeJoinClauseChiJCSuffixList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeJoinClause,"JCSuffixList")
 
#define OSQLNodeLiteral $$$CPTIXNODER("OSQL","Literal")
#define OSQLNodeLiteralChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeLiteral,"STUB")
 
#define OSQLNodeLiteralList $$$CPTIXNODER("OSQL","LiteralList")
 
#define OSQLNodeMCCHeader $$$CPTIXNODER("OSQL","MCCHeader")
#define OSQLNodeMCCHeaderChiQueryPartitionClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMCCHeader,"QueryPartitionClause")
#define OSQLNodeMCCHeaderChiColumnAlias $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMCCHeader,"ColumnAlias")
 
#define OSQLNodeMCFLLiterals $$$CPTIXNODER("OSQL","MCFLLiterals")
 
#define OSQLNodeMMHeader $$$CPTIXNODER("OSQL","MMHeader")
#define OSQLNodeMMHeaderChiMainModelName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMMHeader,"MainModelName")
 
#define OSQLNodeMRRBody $$$CPTIXNODER("OSQL","MRRBody")
#define OSQLNodeMRRBodyChiMRRUpdateOrUpsertAll $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRBody,"MRRUpdateOrUpsertAll")
#define OSQLNodeMRRBodyChiCellAssignment $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRBody,"CellAssignment")
#define OSQLNodeMRRBodyChiOrderByClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRBody,"OrderByClause")
#define OSQLNodeMRRBodyChiExpr $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRBody,"Expr")
 
#define OSQLNodeMRRBodyList $$$CPTIXNODER("OSQL","MRRBodyList")
 
#define OSQLNodeMRRIteratePart $$$CPTIXNODER("OSQL","MRRIteratePart")
#define OSQLNodeMRRIteratePartChiNumber $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRIteratePart,"Number")
#define OSQLNodeMRRIteratePartChiMRRUntil $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRIteratePart,"MRRUntil")
 
#define OSQLNodeMRRRulesPart $$$CPTIXNODER("OSQL","MRRRulesPart")
#define OSQLNodeMRRRulesPartAnnMRRAutoOrSeq $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeMRRRulesPart,"MRRAutoOrSeq")
#define OSQLNodeMRRRulesPartChiMRRUpdateOrUpsertAll $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRRulesPart,"MRRUpdateOrUpsertAll")
 
#define OSQLNodeMRRUntil $$$CPTIXNODER("OSQL","MRRUntil")
#define OSQLNodeMRRUntilChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMRRUntil,"Condition")
 
#define OSQLNodeMRRUpdate $$$CPTIXNODER("OSQL","MRRUpdate")
 
#define OSQLNodeMRRUpsertAll $$$CPTIXNODER("OSQL","MRRUpsertAll")
 
#define OSQLNodeMainModel $$$CPTIXNODER("OSQL","MainModel")
#define OSQLNodeMainModelChiMMHeader $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMainModel,"MMHeader")
#define OSQLNodeMainModelChiModelColumnClauses $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMainModel,"ModelColumnClauses")
#define OSQLNodeMainModelChiCellReferenceOptions $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMainModel,"CellReferenceOptions")
#define OSQLNodeMainModelChiModelRulesClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMainModel,"ModelRulesClause")
 
#define OSQLNodeMainModelName $$$CPTIXNODER("OSQL","MainModelName")
#define OSQLNodeMainModelNameChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMainModelName,"STUB")
 
#define OSQLNodeMaxValue $$$CPTIXNODER("OSQL","MaxValue")
 
#define OSQLNodeMeasureColumn $$$CPTIXNODER("OSQL","MeasureColumn")
#define OSQLNodeMeasureColumnChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMeasureColumn,"STUB")
 
#define OSQLNodeMinValue $$$CPTIXNODER("OSQL","MinValue")
 
#define OSQLNodeModelClause $$$CPTIXNODER("OSQL","ModelClause")
#define OSQLNodeModelClauseChiCellReferenceOptions $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelClause,"CellReferenceOptions")
#define OSQLNodeModelClauseChiReturnRowsClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelClause,"ReturnRowsClause")
#define OSQLNodeModelClauseChiReferenceModelList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelClause,"ReferenceModelList")
#define OSQLNodeModelClauseChiMainModel $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelClause,"MainModel")
 
#define OSQLNodeModelColumn $$$CPTIXNODER("OSQL","ModelColumn")
#define OSQLNodeModelColumnChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelColumn,"STUB")
 
#define OSQLNodeModelColumnClauses $$$CPTIXNODER("OSQL","ModelColumnClauses")
#define OSQLNodeModelColumnClausesChiMCCHeader $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelColumnClauses,"MCCHeader")
#define OSQLNodeModelColumnClausesChiModelColumnList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelColumnClauses,"ModelColumnList")
#define OSQLNodeModelColumnClausesChiModelColumnList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelColumnClauses,"ModelColumnList")
#define OSQLNodeModelColumnClausesChiExpr $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelColumnClauses,"Expr")
#define OSQLNodeModelColumnClausesChiAsSuffix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelColumnClauses,"AsSuffix")
 
#define OSQLNodeModelColumnList $$$CPTIXNODER("OSQL","ModelColumnList")
 
#define OSQLNodeModelRulesClause $$$CPTIXNODER("OSQL","ModelRulesClause")
#define OSQLNodeModelRulesClauseChiMRRRulesPart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelRulesClause,"MRRRulesPart")
#define OSQLNodeModelRulesClauseChiMRRIteratePart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelRulesClause,"MRRIteratePart")
#define OSQLNodeModelRulesClauseChiMRRBodyList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeModelRulesClause,"MRRBodyList")
 
#define OSQLNodeMultiColumnForLoop $$$CPTIXNODER("OSQL","MultiColumnForLoop")
#define OSQLNodeMultiColumnForLoopChiDimensionColumnList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMultiColumnForLoop,"DimensionColumnList")
#define OSQLNodeMultiColumnForLoopChiMCFLInPart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeMultiColumnForLoop,"MCFLInPart")
 
#define OSQLNodeNullStatement $$$CPTIXNODER("OSQL","NullStatement")
 
#define OSQLNodeNumber $$$CPTIXNODER("OSQL","Number")
#define OSQLNodeNumberChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeNumber,"STUB")
 
#define OSQLNodeOBCBody $$$CPTIXNODER("OSQL","OBCBody")
#define OSQLNodeOBCBodyAnnOBCAscOrDesc $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeOBCBody,"OBCAscOrDesc")
#define OSQLNodeOBCBodyChiOBCTerm $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOBCBody,"OBCTerm")
#define OSQLNodeOBCBodyChiOBCNulls $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOBCBody,"OBCNulls")
 
#define OSQLNodeOBCBodyList $$$CPTIXNODER("OSQL","OBCBodyList")
 
#define OSQLNodeOBCNulls $$$CPTIXNODER("OSQL","OBCNulls")
#define OSQLNodeOBCNullsAnnOBCFirstOrLast $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeOBCNulls,"OBCFirstOrLast")
 
#define OSQLNodeOJCJoinPartNatural $$$CPTIXNODER("OSQL","OJCJoinPartNatural")
#define OSQLNodeOJCJoinPartNaturalChiOuterJoinType $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOJCJoinPartNatural,"OuterJoinType")
 
#define OSQLNodeOJCJoinPartOuter $$$CPTIXNODER("OSQL","OJCJoinPartOuter")
#define OSQLNodeOJCJoinPartOuterChiOuterJoinType $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOJCJoinPartOuter,"OuterJoinType")
 
#define OSQLNodeOJCOn $$$CPTIXNODER("OSQL","OJCOn")
#define OSQLNodeOJCOnChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOJCOn,"Condition")
 
#define OSQLNodeOJCUsing $$$CPTIXNODER("OSQL","OJCUsing")
 
#define OSQLNodeOrderByClause $$$CPTIXNODER("OSQL","OrderByClause")
#define OSQLNodeOrderByClauseAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeOrderByClause,"Literal")
#define OSQLNodeOrderByClauseChiOBCBodyList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOrderByClause,"OBCBodyList")
 
#define OSQLNodeOuterJoinClause $$$CPTIXNODER("OSQL","OuterJoinClause")
#define OSQLNodeOuterJoinClauseChiQueryPartitionClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOuterJoinClause,"QueryPartitionClause")
#define OSQLNodeOuterJoinClauseChiOJCJoinPart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOuterJoinClause,"OJCJoinPart")
#define OSQLNodeOuterJoinClauseChiTableReference $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOuterJoinClause,"TableReference")
#define OSQLNodeOuterJoinClauseChiQueryPartitionClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOuterJoinClause,"QueryPartitionClause")
#define OSQLNodeOuterJoinClauseChiOJCOnOrUsing $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeOuterJoinClause,"OJCOnOrUsing")
 
#define OSQLNodeOuterJoinType $$$CPTIXNODER("OSQL","OuterJoinType")
#define OSQLNodeOuterJoinTypeAnnOuterJoinWhich $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeOuterJoinType,"OuterJoinWhich")
#define OSQLNodeOuterJoinTypeAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeOuterJoinType,"Literal")
 
#define OSQLNodePECPartition $$$CPTIXNODER("OSQL","PECPartition")
#define OSQLNodePECPartitionChiPECPartitionBody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePECPartition,"PECPartitionBody")
 
#define OSQLNodePECPartitionFor $$$CPTIXNODER("OSQL","PECPartitionFor")
 
#define OSQLNodePECPartitionOnly $$$CPTIXNODER("OSQL","PECPartitionOnly")
#define OSQLNodePECPartitionOnlyChiPartition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePECPartitionOnly,"Partition")
 
#define OSQLNodePECSubpartition $$$CPTIXNODER("OSQL","PECSubpartition")
#define OSQLNodePECSubpartitionChiPECSubpartitionBody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePECSubpartition,"PECSubpartitionBody")
 
#define OSQLNodePECSubpartitionFor $$$CPTIXNODER("OSQL","PECSubpartitionFor")
 
#define OSQLNodePECSubpartitionOnly $$$CPTIXNODER("OSQL","PECSubpartitionOnly")
#define OSQLNodePECSubpartitionOnlyChiSubpartition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePECSubpartitionOnly,"Subpartition")
 
#define OSQLNodeParenColumnList $$$CPTIXNODER("OSQL","ParenColumnList")
 
#define OSQLNodeParenConstantList $$$CPTIXNODER("OSQL","ParenConstantList")
 
#define OSQLNodeParenExprList $$$CPTIXNODER("OSQL","ParenExprList")
 
#define OSQLNodeParenJoinClause $$$CPTIXNODER("OSQL","ParenJoinClause")
#define OSQLNodeParenJoinClauseChiJoinClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeParenJoinClause,"JoinClause")
 
#define OSQLNodeParenLiteralList $$$CPTIXNODER("OSQL","ParenLiteralList")
#define OSQLNodeParenLiteralListChiLiteralList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeParenLiteralList,"LiteralList")
 
#define OSQLNodeParenSubquery $$$CPTIXNODER("OSQL","ParenSubquery")
#define OSQLNodeParenSubqueryChiSubquery $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeParenSubquery,"Subquery")
 
#define OSQLNodePartition $$$CPTIXNODER("OSQL","Partition")
#define OSQLNodePartitionChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePartition,"STUB")
 
#define OSQLNodePartitionKeyValue $$$CPTIXNODER("OSQL","PartitionKeyValue")
#define OSQLNodePartitionKeyValueChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePartitionKeyValue,"STUB")
 
#define OSQLNodePattern $$$CPTIXNODER("OSQL","Pattern")
#define OSQLNodePatternChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePattern,"STUB")
 
#define OSQLNodePivotClause $$$CPTIXNODER("OSQL","PivotClause")
#define OSQLNodePivotClauseAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodePivotClause,"Literal")
#define OSQLNodePivotClauseChiPivotClauseBodyList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotClause,"PivotClauseBodyList")
#define OSQLNodePivotClauseChiPivotForClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotClause,"PivotForClause")
#define OSQLNodePivotClauseChiPivotInClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotClause,"PivotInClause")
 
#define OSQLNodePivotClauseBody $$$CPTIXNODER("OSQL","PivotClauseBody")
#define OSQLNodePivotClauseBodyAnnAggregateFunction $$$CPTIXNODEANNR("OSQL",$$$OSQLNodePivotClauseBody,"AggregateFunction")
#define OSQLNodePivotClauseBodyChiExpr $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotClauseBody,"Expr")
#define OSQLNodePivotClauseBodyChiAsSuffix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotClauseBody,"AsSuffix")
 
#define OSQLNodePivotClauseBodyList $$$CPTIXNODER("OSQL","PivotClauseBodyList")
 
#define OSQLNodePivotForClause $$$CPTIXNODER("OSQL","PivotForClause")
#define OSQLNodePivotForClauseChiColumnOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotForClause,"ColumnOrParenList")
 
#define OSQLNodePivotInClause $$$CPTIXNODER("OSQL","PivotInClause")
#define OSQLNodePivotInClauseChiPivotInClauseBody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePivotInClause,"PivotInClauseBody")
 
#define OSQLNodePosition $$$CPTIXNODER("OSQL","Position")
#define OSQLNodePositionChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodePosition,"STUB")
 
#define OSQLNodeQualifiedName $$$CPTIXNODER("OSQL","QualifiedName")
#define OSQLNodeQualifiedNameAnnSchemaName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeQualifiedName,"SchemaName")
#define OSQLNodeQualifiedNameAnnBaseName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeQualifiedName,"BaseName")
 
#define OSQLNodeQueryBlock $$$CPTIXNODER("OSQL","QueryBlock")
#define OSQLNodeQueryBlockAnnSelectWhich $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeQueryBlock,"SelectWhich")
#define OSQLNodeQueryBlockChiSelectList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"SelectList")
#define OSQLNodeQueryBlockChiFromClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"FromClause")
#define OSQLNodeQueryBlockChiWhereClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"WhereClause")
#define OSQLNodeQueryBlockChiHierQueryClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"HierQueryClause")
#define OSQLNodeQueryBlockChiGroupByClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"GroupByClause")
#define OSQLNodeQueryBlockChiHavingClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"HavingClause")
#define OSQLNodeQueryBlockChiModelClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryBlock,"ModelClause")
 
#define OSQLNodeQueryName $$$CPTIXNODER("OSQL","QueryName")
#define OSQLNodeQueryNameAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeQueryName,"Name")
 
#define OSQLNodeQueryPartitionClause $$$CPTIXNODER("OSQL","QueryPartitionClause")
#define OSQLNodeQueryPartitionClauseChiExprOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeQueryPartitionClause,"ExprOrParenList")
 
#define OSQLNodeReferenceModel $$$CPTIXNODER("OSQL","ReferenceModel")
#define OSQLNodeReferenceModelChiReferenceModelName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeReferenceModel,"ReferenceModelName")
#define OSQLNodeReferenceModelChiSubquery $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeReferenceModel,"Subquery")
#define OSQLNodeReferenceModelChiModelColumnClauses $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeReferenceModel,"ModelColumnClauses")
#define OSQLNodeReferenceModelChiCellReferenceOptions $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeReferenceModel,"CellReferenceOptions")
 
#define OSQLNodeReferenceModelList $$$CPTIXNODER("OSQL","ReferenceModelList")
 
#define OSQLNodeReferenceModelName $$$CPTIXNODER("OSQL","ReferenceModelName")
#define OSQLNodeReferenceModelNameChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeReferenceModelName,"STUB")
 
#define OSQLNodeReturnRowsClause $$$CPTIXNODER("OSQL","ReturnRowsClause")
#define OSQLNodeReturnRowsClauseAnnRRCUpdatedOrAll $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeReturnRowsClause,"RRCUpdatedOrAll")
 
#define OSQLNodeRollupCubeClause $$$CPTIXNODER("OSQL","RollupCubeClause")
#define OSQLNodeRollupCubeClauseAnnRCCRollupOrCube $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeRollupCubeClause,"RCCRollupOrCube")
#define OSQLNodeRollupCubeClauseChiGroupingExpressionList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeRollupCubeClause,"GroupingExpressionList")
 
#define OSQLNodeSCFLIn $$$CPTIXNODER("OSQL","SCFLIn")
#define OSQLNodeSCFLInChiSCFLInTermList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSCFLIn,"SCFLInTermList")
 
#define OSQLNodeSCFLLike $$$CPTIXNODER("OSQL","SCFLLike")
#define OSQLNodeSCFLLikeAnnSCFLIncOrDec $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeSCFLLike,"SCFLIncOrDec")
#define OSQLNodeSCFLLikeChiSCFLLikePart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSCFLLike,"SCFLLikePart")
#define OSQLNodeSCFLLikeChiLiteral $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSCFLLike,"Literal")
#define OSQLNodeSCFLLikeChiLiteral $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSCFLLike,"Literal")
#define OSQLNodeSCFLLikeChiLiteral $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSCFLLike,"Literal")
 
#define OSQLNodeSCFLLikePart $$$CPTIXNODER("OSQL","SCFLLikePart")
#define OSQLNodeSCFLLikePartChiPattern $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSCFLLikePart,"Pattern")
 
#define OSQLNodeSFCTerm $$$CPTIXNODER("OSQL","SFCTerm")
#define OSQLNodeSFCTermChiQueryName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSFCTerm,"QueryName")
#define OSQLNodeSFCTermChiParenSubquery $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSFCTerm,"ParenSubquery")
 
#define OSQLNodeSLExpr $$$CPTIXNODER("OSQL","SLExpr")
#define OSQLNodeSLExprChiExpr $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSLExpr,"Expr")
#define OSQLNodeSLExprChiAsSuffix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSLExpr,"AsSuffix")
 
#define OSQLNodeSLQueryNameDS $$$CPTIXNODER("OSQL","SLQueryNameDS")
#define OSQLNodeSLQueryNameDSChiQueryName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSLQueryNameDS,"QueryName")
 
#define OSQLNodeSLTableRef $$$CPTIXNODER("OSQL","SLTableRef")
#define OSQLNodeSLTableRefChiSchemaPrefix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSLTableRef,"SchemaPrefix")
#define OSQLNodeSLTableRefChiTVName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSLTableRef,"TVName")
 
#define OSQLNodeSLTableRefDS $$$CPTIXNODER("OSQL","SLTableRefDS")
#define OSQLNodeSLTableRefDSChiSLTableRef $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSLTableRefDS,"SLTableRef")
 
#define OSQLNodeSQQueryTableExpression $$$CPTIXNODER("OSQL","SQQueryTableExpression")
#define OSQLNodeSQQueryTableExpressionChiSubquery $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSQQueryTableExpression,"Subquery")
#define OSQLNodeSQQueryTableExpressionChiSubqueryRestrictionClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSQQueryTableExpression,"SubqueryRestrictionClause")
 
#define OSQLNodeSQRCheckOption $$$CPTIXNODER("OSQL","SQRCheckOption")
#define OSQLNodeSQRCheckOptionChiSQRConstraint $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSQRCheckOption,"SQRConstraint")
 
#define OSQLNodeSQRConstraint $$$CPTIXNODER("OSQL","SQRConstraint")
#define OSQLNodeSQRConstraintChiConstraint $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSQRConstraint,"Constraint")
 
#define OSQLNodeSQRReadOnly $$$CPTIXNODER("OSQL","SQRReadOnly")
 
#define OSQLNodeSTUB $$$CPTIXNODER("OSQL","STUB")
#define OSQLNodeSTUBAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeSTUB,"Literal")
 
#define OSQLNodeSampleClause $$$CPTIXNODER("OSQL","SampleClause")
#define OSQLNodeSampleClauseAnnLiteral $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeSampleClause,"Literal")
#define OSQLNodeSampleClauseChiSamplePercent $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSampleClause,"SamplePercent")
#define OSQLNodeSampleClauseChiSampleClauseSeed $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSampleClause,"SampleClauseSeed")
 
#define OSQLNodeSampleClauseSeed $$$CPTIXNODER("OSQL","SampleClauseSeed")
#define OSQLNodeSampleClauseSeedChiSeedValue $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSampleClauseSeed,"SeedValue")
 
#define OSQLNodeSamplePercent $$$CPTIXNODER("OSQL","SamplePercent")
#define OSQLNodeSamplePercentAnnNumber $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeSamplePercent,"Number")
 
#define OSQLNodeSchemaName $$$CPTIXNODER("OSQL","SchemaName")
#define OSQLNodeSchemaNameAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeSchemaName,"Name")
 
#define OSQLNodeSchemaPrefix $$$CPTIXNODER("OSQL","SchemaPrefix")
#define OSQLNodeSchemaPrefixChiSchemaName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSchemaPrefix,"SchemaName")
 
#define OSQLNodeSeedValue $$$CPTIXNODER("OSQL","SeedValue")
#define OSQLNodeSeedValueChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSeedValue,"STUB")
 
#define OSQLNodeSelectHint $$$CPTIXNODER("OSQL","SelectHint")
#define OSQLNodeSelectHintChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSelectHint,"STUB")
 
#define OSQLNodeSelectListItemList $$$CPTIXNODER("OSQL","SelectListItemList")
 
#define OSQLNodeSelectStatement $$$CPTIXNODER("OSQL","SelectStatement")
#define OSQLNodeSelectStatementChiSubqueryFactoringClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSelectStatement,"SubqueryFactoringClause")
#define OSQLNodeSelectStatementChiSubquery $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSelectStatement,"Subquery")
#define OSQLNodeSelectStatementChiForUpdateClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSelectStatement,"ForUpdateClause")
 
#define OSQLNodeSimpleBlock $$$CPTIXNODER("OSQL","SimpleBlock")
#define OSQLNodeSimpleBlockChiStatements $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSimpleBlock,"Statements")
#define OSQLNodeSimpleBlockChiExcpSection $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSimpleBlock,"ExcpSection")
 
#define OSQLNodeSimpleName $$$CPTIXNODER("OSQL","SimpleName")
#define OSQLNodeSimpleNameAnnBaseName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeSimpleName,"BaseName")
 
#define OSQLNodeSingleColumnForLoop $$$CPTIXNODER("OSQL","SingleColumnForLoop")
#define OSQLNodeSingleColumnForLoopChiDimensionColumn $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSingleColumnForLoop,"DimensionColumn")
#define OSQLNodeSingleColumnForLoopChiSCFLBody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSingleColumnForLoop,"SCFLBody")
 
#define OSQLNodeStar $$$CPTIXNODER("OSQL","Star")
 
#define OSQLNodeStatement $$$CPTIXNODER("OSQL","Statement")
#define OSQLNodeStatementChiStatement1 $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeStatement,"Statement1")
 
#define OSQLNodeStatements $$$CPTIXNODER("OSQL","Statements")
 
#define OSQLNodeSubpartition $$$CPTIXNODER("OSQL","Subpartition")
#define OSQLNodeSubpartitionChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSubpartition,"STUB")
 
#define OSQLNodeSubpartitionKeyValue $$$CPTIXNODER("OSQL","SubpartitionKeyValue")
#define OSQLNodeSubpartitionKeyValueChiSTUB $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSubpartitionKeyValue,"STUB")
 
#define OSQLNodeSubquery $$$CPTIXNODER("OSQL","Subquery")
#define OSQLNodeSubqueryChiSubqueryMain $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSubquery,"SubqueryMain")
#define OSQLNodeSubqueryChiOrderByClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSubquery,"OrderByClause")
 
#define OSQLNodeSubqueryFactoringClause $$$CPTIXNODER("OSQL","SubqueryFactoringClause")
 
#define OSQLNodeSubqueryMain $$$CPTIXNODER("OSQL","SubqueryMain")
#define OSQLNodeSubqueryMainChiQueryBlock $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSubqueryMain,"QueryBlock")
 
#define OSQLNodeSubqueryRestrictionClause $$$CPTIXNODER("OSQL","SubqueryRestrictionClause")
#define OSQLNodeSubqueryRestrictionClauseChiSQRBody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeSubqueryRestrictionClause,"SQRBody")
 
#define OSQLNodeTCETail $$$CPTIXNODER("OSQL","TCETail")
 
#define OSQLNodeTVName $$$CPTIXNODER("OSQL","TVName")
#define OSQLNodeTVNameAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeTVName,"Name")
 
#define OSQLNodeTVQueryTableExpression $$$CPTIXNODER("OSQL","TVQueryTableExpression")
#define OSQLNodeTVQueryTableExpressionChiSchemaPrefix $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTVQueryTableExpression,"SchemaPrefix")
#define OSQLNodeTVQueryTableExpressionChiTVName $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTVQueryTableExpression,"TVName")
#define OSQLNodeTVQueryTableExpressionChiPECOrATDBL $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTVQueryTableExpression,"PECOrATDBL")
#define OSQLNodeTVQueryTableExpressionChiSampleClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTVQueryTableExpression,"SampleClause")
 
#define OSQLNodeTableAlias $$$CPTIXNODER("OSQL","TableAlias")
#define OSQLNodeTableAliasAnnName $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeTableAlias,"Name")
 
#define OSQLNodeTableCollectionExpression $$$CPTIXNODER("OSQL","TableCollectionExpression")
#define OSQLNodeTableCollectionExpressionChiCollectionExpression $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableCollectionExpression,"CollectionExpression")
#define OSQLNodeTableCollectionExpressionChiTCETail $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableCollectionExpression,"TCETail")
 
#define OSQLNodeTableReference $$$CPTIXNODER("OSQL","TableReference")
#define OSQLNodeTableReferenceChiTableReferenceStart $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableReference,"TableReferenceStart")
#define OSQLNodeTableReferenceChiFlashbackQueryClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableReference,"FlashbackQueryClause")
#define OSQLNodeTableReferenceChiTableAlias $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableReference,"TableAlias")
 
#define OSQLNodeTableReferenceOnly $$$CPTIXNODER("OSQL","TableReferenceOnly")
#define OSQLNodeTableReferenceOnlyChiQueryTableExpression $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableReferenceOnly,"QueryTableExpression")
 
#define OSQLNodeTableReferenceQueryTable $$$CPTIXNODER("OSQL","TableReferenceQueryTable")
#define OSQLNodeTableReferenceQueryTableChiQueryTableExpression $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableReferenceQueryTable,"QueryTableExpression")
#define OSQLNodeTableReferenceQueryTableChiPivotTypeClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeTableReferenceQueryTable,"PivotTypeClause")
 
#define OSQLNodeTermNumber $$$CPTIXNODER("OSQL","TermNumber")
#define OSQLNodeTermNumberAnnNumber $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeTermNumber,"Number")
 
#define OSQLNodeTermString $$$CPTIXNODER("OSQL","TermString")
#define OSQLNodeTermStringAnnString $$$CPTIXNODEANNR("OSQL",$$$OSQLNodeTermString,"String")
 
#define OSQLNodeUnpivotClause $$$CPTIXNODER("OSQL","UnpivotClause")
#define OSQLNodeUnpivotClauseChiInclExclNulls $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotClause,"InclExclNulls")
#define OSQLNodeUnpivotClauseChiColumnOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotClause,"ColumnOrParenList")
#define OSQLNodeUnpivotClauseChiPivotForClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotClause,"PivotForClause")
#define OSQLNodeUnpivotClauseChiUnpivotInClause $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotClause,"UnpivotInClause")
 
#define OSQLNodeUnpivotInClause $$$CPTIXNODER("OSQL","UnpivotInClause")
#define OSQLNodeUnpivotInClauseChiUnpivotInClauseBody $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotInClause,"UnpivotInClauseBody")
 
#define OSQLNodeUnpivotInClauseBody $$$CPTIXNODER("OSQL","UnpivotInClauseBody")
 
#define OSQLNodeUnpivotInClauseTerm $$$CPTIXNODER("OSQL","UnpivotInClauseTerm")
#define OSQLNodeUnpivotInClauseTermChiColumnOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotInClauseTerm,"ColumnOrParenList")
#define OSQLNodeUnpivotInClauseTermChiAsConstantOrParenList $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeUnpivotInClauseTerm,"AsConstantOrParenList")
 
#define OSQLNodeWhereClause $$$CPTIXNODER("OSQL","WhereClause")
#define OSQLNodeWhereClauseChiCondition $$$CPTIXNODECHILDR("OSQL",$$$OSQLNodeWhereClause,"Condition")
 
#define OSQLEnumAggregateFunctionNone $$$CPTIXENUMVALUER("OSQL","AggregateFunction","None")
#define OSQLEnumAggregateFunctionAVG $$$CPTIXENUMVALUER("OSQL","AggregateFunction","AVG")
#define OSQLEnumAggregateFunctionCORR $$$CPTIXENUMVALUER("OSQL","AggregateFunction","CORR")
#define OSQLEnumAggregateFunctionCOUNT $$$CPTIXENUMVALUER("OSQL","AggregateFunction","COUNT")
#define OSQLEnumAggregateFunctionCOVAR_POP $$$CPTIXENUMVALUER("OSQL","AggregateFunction","COVAR_POP")
#define OSQLEnumAggregateFunctionCOVAR_SAMP $$$CPTIXENUMVALUER("OSQL","AggregateFunction","COVAR_SAMP")
#define OSQLEnumAggregateFunctionCUME_DIST $$$CPTIXENUMVALUER("OSQL","AggregateFunction","CUME_DIST")
#define OSQLEnumAggregateFunctionDENSE_RANK $$$CPTIXENUMVALUER("OSQL","AggregateFunction","DENSE_RANK")
#define OSQLEnumAggregateFunctionFIRST $$$CPTIXENUMVALUER("OSQL","AggregateFunction","FIRST")
#define OSQLEnumAggregateFunctionGROUP_ID $$$CPTIXENUMVALUER("OSQL","AggregateFunction","GROUP_ID")
#define OSQLEnumAggregateFunctionGROUPING $$$CPTIXENUMVALUER("OSQL","AggregateFunction","GROUPING")
#define OSQLEnumAggregateFunctionGROUPING_ID $$$CPTIXENUMVALUER("OSQL","AggregateFunction","GROUPING_ID")
#define OSQLEnumAggregateFunctionLAST $$$CPTIXENUMVALUER("OSQL","AggregateFunction","LAST")
#define OSQLEnumAggregateFunctionMAX $$$CPTIXENUMVALUER("OSQL","AggregateFunction","MAX")
#define OSQLEnumAggregateFunctionMIN $$$CPTIXENUMVALUER("OSQL","AggregateFunction","MIN")
#define OSQLEnumAggregateFunctionPERCENTILE_CONT $$$CPTIXENUMVALUER("OSQL","AggregateFunction","PERCENTILE_CONT")
#define OSQLEnumAggregateFunctionPERCENTILE_DISC $$$CPTIXENUMVALUER("OSQL","AggregateFunction","PERCENTILE_DISC")
#define OSQLEnumAggregateFunctionPERCENT_RANK $$$CPTIXENUMVALUER("OSQL","AggregateFunction","PERCENT_RANK")
#define OSQLEnumAggregateFunctionRANK $$$CPTIXENUMVALUER("OSQL","AggregateFunction","RANK")
#define OSQLEnumAggregateFunctionREGR_SLOPE $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_SLOPE")
#define OSQLEnumAggregateFunctionREGR_INTERCEPT $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_INTERCEPT")
#define OSQLEnumAggregateFunctionREGR_COUNT $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_COUNT")
#define OSQLEnumAggregateFunctionREGR_R2 $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_R2")
#define OSQLEnumAggregateFunctionREGR_AVGX $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_AVGX")
#define OSQLEnumAggregateFunctionREGR_AVGY $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_AVGY")
#define OSQLEnumAggregateFunctionREGR_SXX $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_SXX")
#define OSQLEnumAggregateFunctionREGR_SYY $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_SYY")
#define OSQLEnumAggregateFunctionREGR_SXY $$$CPTIXENUMVALUER("OSQL","AggregateFunction","REGR_SXY")
#define OSQLEnumAggregateFunctionSTDDEV $$$CPTIXENUMVALUER("OSQL","AggregateFunction","STDDEV")
#define OSQLEnumAggregateFunctionSTDDEV_POP $$$CPTIXENUMVALUER("OSQL","AggregateFunction","STDDEV_POP")
#define OSQLEnumAggregateFunctionSTDDEV_SAMP $$$CPTIXENUMVALUER("OSQL","AggregateFunction","STDDEV_SAMP")
#define OSQLEnumAggregateFunctionSUM $$$CPTIXENUMVALUER("OSQL","AggregateFunction","SUM")
#define OSQLEnumAggregateFunctionVAR_POP $$$CPTIXENUMVALUER("OSQL","AggregateFunction","VAR_POP")
#define OSQLEnumAggregateFunctionVAR_SAMP $$$CPTIXENUMVALUER("OSQL","AggregateFunction","VAR_SAMP")
#define OSQLEnumAggregateFunctionVARIANCE $$$CPTIXENUMVALUER("OSQL","AggregateFunction","VARIANCE")
 
#define OSQLEnumCROIgnoreOrKeepNone $$$CPTIXENUMVALUER("OSQL","CROIgnoreOrKeep","None")
#define OSQLEnumCROIgnoreOrKeepIGNORE $$$CPTIXENUMVALUER("OSQL","CROIgnoreOrKeep","IGNORE")
#define OSQLEnumCROIgnoreOrKeepKEEP $$$CPTIXENUMVALUER("OSQL","CROIgnoreOrKeep","KEEP")
 
#define OSQLEnumInclExclNone $$$CPTIXENUMVALUER("OSQL","InclExcl","None")
#define OSQLEnumInclExclINCLUDE $$$CPTIXENUMVALUER("OSQL","InclExcl","INCLUDE")
#define OSQLEnumInclExclEXCLUDE $$$CPTIXENUMVALUER("OSQL","InclExcl","EXCLUDE")
 
#define OSQLEnumMRRAutoOrSeqNone $$$CPTIXENUMVALUER("OSQL","MRRAutoOrSeq","None")
#define OSQLEnumMRRAutoOrSeqAUTOMATIC $$$CPTIXENUMVALUER("OSQL","MRRAutoOrSeq","AUTOMATIC")
#define OSQLEnumMRRAutoOrSeqSEQUENTIAL $$$CPTIXENUMVALUER("OSQL","MRRAutoOrSeq","SEQUENTIAL")
 
#define OSQLEnumOBCAscOrDescNone $$$CPTIXENUMVALUER("OSQL","OBCAscOrDesc","None")
#define OSQLEnumOBCAscOrDescASC $$$CPTIXENUMVALUER("OSQL","OBCAscOrDesc","ASC")
#define OSQLEnumOBCAscOrDescDESC $$$CPTIXENUMVALUER("OSQL","OBCAscOrDesc","DESC")
 
#define OSQLEnumOBCFirstOrLastNone $$$CPTIXENUMVALUER("OSQL","OBCFirstOrLast","None")
#define OSQLEnumOBCFirstOrLastFIRST $$$CPTIXENUMVALUER("OSQL","OBCFirstOrLast","FIRST")
#define OSQLEnumOBCFirstOrLastLAST $$$CPTIXENUMVALUER("OSQL","OBCFirstOrLast","LAST")
 
#define OSQLEnumOuterJoinWhichNone $$$CPTIXENUMVALUER("OSQL","OuterJoinWhich","None")
#define OSQLEnumOuterJoinWhichFULL $$$CPTIXENUMVALUER("OSQL","OuterJoinWhich","FULL")
#define OSQLEnumOuterJoinWhichLEFT $$$CPTIXENUMVALUER("OSQL","OuterJoinWhich","LEFT")
#define OSQLEnumOuterJoinWhichRIGHT $$$CPTIXENUMVALUER("OSQL","OuterJoinWhich","RIGHT")
 
#define OSQLEnumRCCRollupOrCubeNone $$$CPTIXENUMVALUER("OSQL","RCCRollupOrCube","None")
#define OSQLEnumRCCRollupOrCubeROLLUP $$$CPTIXENUMVALUER("OSQL","RCCRollupOrCube","ROLLUP")
#define OSQLEnumRCCRollupOrCubeCUBE $$$CPTIXENUMVALUER("OSQL","RCCRollupOrCube","CUBE")
 
#define OSQLEnumRRCUpdatedOrAllNone $$$CPTIXENUMVALUER("OSQL","RRCUpdatedOrAll","None")
#define OSQLEnumRRCUpdatedOrAllUPDATED $$$CPTIXENUMVALUER("OSQL","RRCUpdatedOrAll","UPDATED")
#define OSQLEnumRRCUpdatedOrAllALL $$$CPTIXENUMVALUER("OSQL","RRCUpdatedOrAll","ALL")
 
#define OSQLEnumSCFLIncOrDecNone $$$CPTIXENUMVALUER("OSQL","SCFLIncOrDec","None")
#define OSQLEnumSCFLIncOrDecINCREMENT $$$CPTIXENUMVALUER("OSQL","SCFLIncOrDec","INCREMENT")
#define OSQLEnumSCFLIncOrDecDECREMENT $$$CPTIXENUMVALUER("OSQL","SCFLIncOrDec","DECREMENT")
 
#define OSQLEnumScnOrTimestampNone $$$CPTIXENUMVALUER("OSQL","ScnOrTimestamp","None")
#define OSQLEnumScnOrTimestampSCN $$$CPTIXENUMVALUER("OSQL","ScnOrTimestamp","SCN")
#define OSQLEnumScnOrTimestampTIMESTAMP $$$CPTIXENUMVALUER("OSQL","ScnOrTimestamp","TIMESTAMP")
 
#define OSQLEnumSelectWhichNone $$$CPTIXENUMVALUER("OSQL","SelectWhich","None")
#define OSQLEnumSelectWhichALL $$$CPTIXENUMVALUER("OSQL","SelectWhich","ALL")
#define OSQLEnumSelectWhichDISTINCT $$$CPTIXENUMVALUER("OSQL","SelectWhich","DISTINCT")
#define OSQLEnumSelectWhichUNIQUE $$$CPTIXENUMVALUER("OSQL","SelectWhich","UNIQUE")
 

#else

#define OSQLNodeAPivotInClauseBody 1
 
#define OSQLNodeAsConstantOrParenList 2
#define OSQLNodeAsConstantOrParenListChiConstantOrParenList 1
 
#define OSQLNodeAsSuffix 3
#define OSQLNodeAsSuffixAnnLiteral 1
#define OSQLNodeAsSuffixChiColumnAlias 1
 
#define OSQLNodeAtDBLink 4
#define OSQLNodeAtDBLinkChiDBLink 1
 
#define OSQLNodeBlock 5
#define OSQLNodeBlockChiDeclSection 1
#define OSQLNodeBlockChiSimpleBlock 2
 
#define OSQLNodeCASingleList 6
 
#define OSQLNodeCRODimPartDim 7
 
#define OSQLNodeCRODimPartSing 8
 
#define OSQLNodeCRONavPart 9
#define OSQLNodeCRONavPartAnnCROIgnoreOrKeep 1
 
#define OSQLNodeCROUniquePart 10
#define OSQLNodeCROUniquePartChiCRODimPart 1
 
#define OSQLNodeCellAssignment 11
#define OSQLNodeCellAssignmentChiMeasureColumn 1
#define OSQLNodeCellAssignmentChiCABody 2
 
#define OSQLNodeCellReferenceOptions 12
#define OSQLNodeCellReferenceOptionsChiCRONavPart 1
#define OSQLNodeCellReferenceOptionsChiCROUniquePart 2
 
#define OSQLNodeCollectionExpression 13
#define OSQLNodeCollectionExpressionChiSTUB 1
 
#define OSQLNodeColumn 14
#define OSQLNodeColumnAnnName 1
 
#define OSQLNodeColumnAlias 15
#define OSQLNodeColumnAliasAnnName 1
 
#define OSQLNodeCondition 16
#define OSQLNodeConditionAnnString 1
 
#define OSQLNodeConstant 17
#define OSQLNodeConstantAnnString 1
 
#define OSQLNodeConstraint 18
#define OSQLNodeConstraintChiSTUB 1
 
#define OSQLNodeDBLink 19
#define OSQLNodeDBLinkChiSTUB 1
 
#define OSQLNodeDecl 20
#define OSQLNodeDeclAnnName 1
#define OSQLNodeDeclChiDeclType 1
 
#define OSQLNodeDeclSection 21
 
#define OSQLNodeDeclType 22
#define OSQLNodeDeclTypeAnnName 1
 
#define OSQLNodeDimensionColumn 23
#define OSQLNodeDimensionColumnChiSTUB 1
 
#define OSQLNodeDimensionColumnList 24
 
#define OSQLNodeEPivotInClauseBody 25
 
#define OSQLNodeEPivotInClauseTerm 26
#define OSQLNodeEPivotInClauseTermChiExprOrParenList 1
#define OSQLNodeEPivotInClauseTermChiAsSuffix 2
 
#define OSQLNodeExcpHandler 27
#define OSQLNodeExcpHandlerChiExcpWhen 1
#define OSQLNodeExcpHandlerChiStatements 2
 
#define OSQLNodeExcpSection 28
 
#define OSQLNodeExcpWhenNameList 29
 
#define OSQLNodeExcpWhenOthers 30
 
#define OSQLNodeExprDAnd 44
#define OSQLNodeExprDAndChiLhs 1
#define OSQLNodeExprDAndChiRhs 2
 
#define OSQLNodeExprDConcat 35
#define OSQLNodeExprDConcatChiLhs 1
#define OSQLNodeExprDConcatChiRhs 2
 
#define OSQLNodeExprDDivide 34
#define OSQLNodeExprDDivideChiLhs 1
#define OSQLNodeExprDDivideChiRhs 2
 
#define OSQLNodeExprDEqual 36
#define OSQLNodeExprDEqualChiLhs 1
#define OSQLNodeExprDEqualChiRhs 2
 
#define OSQLNodeExprDGreaterThan 39
#define OSQLNodeExprDGreaterThanChiLhs 1
#define OSQLNodeExprDGreaterThanChiRhs 2
 
#define OSQLNodeExprDGreaterThanOrEqual 41
#define OSQLNodeExprDGreaterThanOrEqualChiLhs 1
#define OSQLNodeExprDGreaterThanOrEqualChiRhs 2
 
#define OSQLNodeExprDLessThan 38
#define OSQLNodeExprDLessThanChiLhs 1
#define OSQLNodeExprDLessThanChiRhs 2
 
#define OSQLNodeExprDLessThanOrEqual 40
#define OSQLNodeExprDLessThanOrEqualChiLhs 1
#define OSQLNodeExprDLessThanOrEqualChiRhs 2
 
#define OSQLNodeExprDMinus 32
#define OSQLNodeExprDMinusChiLhs 1
#define OSQLNodeExprDMinusChiRhs 2
 
#define OSQLNodeExprDNotEqual 37
#define OSQLNodeExprDNotEqualChiLhs 1
#define OSQLNodeExprDNotEqualChiRhs 2
 
#define OSQLNodeExprDOr 45
#define OSQLNodeExprDOrChiLhs 1
#define OSQLNodeExprDOrChiRhs 2
 
#define OSQLNodeExprDPlus 31
#define OSQLNodeExprDPlusChiLhs 1
#define OSQLNodeExprDPlusChiRhs 2
 
#define OSQLNodeExprDTimes 33
#define OSQLNodeExprDTimesChiLhs 1
#define OSQLNodeExprDTimesChiRhs 2
 
#define OSQLNodeExprList 48
 
#define OSQLNodeExprMMinus 43
#define OSQLNodeExprMMinusChiRhs 1
 
#define OSQLNodeExprMPlus 42
#define OSQLNodeExprMPlusChiRhs 1
 
#define OSQLNodeExprNode 47
#define OSQLNodeExprNodeChiExpr 1
 
#define OSQLNodeExprParen 46
#define OSQLNodeExprParenChiExpr 1
 
#define OSQLNodeFUCOfPart 49
#define OSQLNodeFUCOfPartChiFUCOfTermList 1
 
#define OSQLNodeFUCOfTerm 50
#define OSQLNodeFUCOfTermChiFUCOfTermTablePart 1
#define OSQLNodeFUCOfTermChiColumn 2
 
#define OSQLNodeFUCOfTermList 51
 
#define OSQLNodeFUCOfTermTablePart 52
#define OSQLNodeFUCOfTermTablePartChiSchemaPrefix 1
#define OSQLNodeFUCOfTermTablePartChiTVName 2
 
#define OSQLNodeFUCTailNowait 53
 
#define OSQLNodeFUCTailSkip 54
 
#define OSQLNodeFUCTailWait 55
#define OSQLNodeFUCTailWaitChiInteger 1
 
#define OSQLNodeFlashbackQueryClause 56
#define OSQLNodeFlashbackQueryClauseAnnScnOrTimestamp 1
#define OSQLNodeFlashbackQueryClauseChiExprOrMinValue 1
#define OSQLNodeFlashbackQueryClauseChiExprOrMaxValue 2
 
#define OSQLNodeForUpdateClause 57
#define OSQLNodeForUpdateClauseChiFUCOfPart 1
#define OSQLNodeForUpdateClauseChiFUCTail 2
 
#define OSQLNodeFromClause 58
 
#define OSQLNodeGBCBodyList 59
 
#define OSQLNodeGBCHaving 60
#define OSQLNodeGBCHavingChiCondition 1
 
#define OSQLNodeGSCBodyList 61
 
#define OSQLNodeGroupByClause 62
#define OSQLNodeGroupByClauseChiGBCBodyList 1
#define OSQLNodeGroupByClauseChiGBCHaving 2
 
#define OSQLNodeGroupingExpressionList 63
 
#define OSQLNodeGroupingSetsClause 64
#define OSQLNodeGroupingSetsClauseChiGSCBodyList 1
 
#define OSQLNodeHQCConnect 65
#define OSQLNodeHQCConnectAnnLiteral 1
#define OSQLNodeHQCConnectChiCondition 1
 
#define OSQLNodeHQCConnectStart 66
#define OSQLNodeHQCConnectStartChiHQCConnect 1
#define OSQLNodeHQCConnectStartChiHQCStart 2
 
#define OSQLNodeHQCStart 67
#define OSQLNodeHQCStartChiCondition 1
 
#define OSQLNodeHQCStartConnect 68
#define OSQLNodeHQCStartConnectChiHQCStart 1
#define OSQLNodeHQCStartConnectChiHQCConnect 2
 
#define OSQLNodeHavingClause 69
#define OSQLNodeHavingClauseChiSTUB 1
 
#define OSQLNodeICJCCross 70
#define OSQLNodeICJCCrossChiICJCCrossStart 1
#define OSQLNodeICJCCrossChiTableReference 2
 
#define OSQLNodeICJCCrossCross 71
 
#define OSQLNodeICJCCrossNatural 72
#define OSQLNodeICJCCrossNaturalAnnLiteral 1
 
#define OSQLNodeICJCInner 73
#define OSQLNodeICJCInnerAnnLiteral 1
#define OSQLNodeICJCInnerChiTableReference 1
#define OSQLNodeICJCInnerChiICJCInnerTail 2
 
#define OSQLNodeICJCInnerTailOn 74
#define OSQLNodeICJCInnerTailOnChiCondition 1
 
#define OSQLNodeICJCInnerTailUsing 75
 
#define OSQLNodeInclExclNulls 76
#define OSQLNodeInclExclNullsAnnInclExcl 1
 
#define OSQLNodeInteger 77
#define OSQLNodeIntegerChiSTUB 1
 
#define OSQLNodeJCSuffixList 78
 
#define OSQLNodeJoinClause 79
#define OSQLNodeJoinClauseChiTableReference 1
#define OSQLNodeJoinClauseChiJCSuffixList 2
 
#define OSQLNodeLiteral 80
#define OSQLNodeLiteralChiSTUB 1
 
#define OSQLNodeLiteralList 81
 
#define OSQLNodeMCCHeader 82
#define OSQLNodeMCCHeaderChiQueryPartitionClause 1
#define OSQLNodeMCCHeaderChiColumnAlias 2
 
#define OSQLNodeMCFLLiterals 83
 
#define OSQLNodeMMHeader 84
#define OSQLNodeMMHeaderChiMainModelName 1
 
#define OSQLNodeMRRBody 85
#define OSQLNodeMRRBodyChiMRRUpdateOrUpsertAll 1
#define OSQLNodeMRRBodyChiCellAssignment 2
#define OSQLNodeMRRBodyChiOrderByClause 3
#define OSQLNodeMRRBodyChiExpr 4
 
#define OSQLNodeMRRBodyList 86
 
#define OSQLNodeMRRIteratePart 87
#define OSQLNodeMRRIteratePartChiNumber 1
#define OSQLNodeMRRIteratePartChiMRRUntil 2
 
#define OSQLNodeMRRRulesPart 88
#define OSQLNodeMRRRulesPartAnnMRRAutoOrSeq 1
#define OSQLNodeMRRRulesPartChiMRRUpdateOrUpsertAll 1
 
#define OSQLNodeMRRUntil 89
#define OSQLNodeMRRUntilChiCondition 1
 
#define OSQLNodeMRRUpdate 90
 
#define OSQLNodeMRRUpsertAll 91
 
#define OSQLNodeMainModel 92
#define OSQLNodeMainModelChiMMHeader 1
#define OSQLNodeMainModelChiModelColumnClauses 2
#define OSQLNodeMainModelChiCellReferenceOptions 3
#define OSQLNodeMainModelChiModelRulesClause 4
 
#define OSQLNodeMainModelName 93
#define OSQLNodeMainModelNameChiSTUB 1
 
#define OSQLNodeMaxValue 94
 
#define OSQLNodeMeasureColumn 95
#define OSQLNodeMeasureColumnChiSTUB 1
 
#define OSQLNodeMinValue 96
 
#define OSQLNodeModelClause 97
#define OSQLNodeModelClauseChiCellReferenceOptions 1
#define OSQLNodeModelClauseChiReturnRowsClause 2
#define OSQLNodeModelClauseChiReferenceModelList 3
#define OSQLNodeModelClauseChiMainModel 4
 
#define OSQLNodeModelColumn 98
#define OSQLNodeModelColumnChiSTUB 1
 
#define OSQLNodeModelColumnClauses 99
#define OSQLNodeModelColumnClausesChiMCCHeader 1
#define OSQLNodeModelColumnClausesChiModelColumnList 2
#define OSQLNodeModelColumnClausesChiModelColumnList 3
#define OSQLNodeModelColumnClausesChiExpr 4
#define OSQLNodeModelColumnClausesChiAsSuffix 5
 
#define OSQLNodeModelColumnList 100
 
#define OSQLNodeModelRulesClause 101
#define OSQLNodeModelRulesClauseChiMRRRulesPart 1
#define OSQLNodeModelRulesClauseChiMRRIteratePart 2
#define OSQLNodeModelRulesClauseChiMRRBodyList 3
 
#define OSQLNodeMultiColumnForLoop 102
#define OSQLNodeMultiColumnForLoopChiDimensionColumnList 1
#define OSQLNodeMultiColumnForLoopChiMCFLInPart 2
 
#define OSQLNodeNullStatement 103
 
#define OSQLNodeNumber 104
#define OSQLNodeNumberChiSTUB 1
 
#define OSQLNodeOBCBody 105
#define OSQLNodeOBCBodyAnnOBCAscOrDesc 1
#define OSQLNodeOBCBodyChiOBCTerm 1
#define OSQLNodeOBCBodyChiOBCNulls 2
 
#define OSQLNodeOBCBodyList 106
 
#define OSQLNodeOBCNulls 107
#define OSQLNodeOBCNullsAnnOBCFirstOrLast 1
 
#define OSQLNodeOJCJoinPartNatural 108
#define OSQLNodeOJCJoinPartNaturalChiOuterJoinType 1
 
#define OSQLNodeOJCJoinPartOuter 109
#define OSQLNodeOJCJoinPartOuterChiOuterJoinType 1
 
#define OSQLNodeOJCOn 110
#define OSQLNodeOJCOnChiCondition 1
 
#define OSQLNodeOJCUsing 111
 
#define OSQLNodeOrderByClause 112
#define OSQLNodeOrderByClauseAnnLiteral 1
#define OSQLNodeOrderByClauseChiOBCBodyList 1
 
#define OSQLNodeOuterJoinClause 113
#define OSQLNodeOuterJoinClauseChiQueryPartitionClause 1
#define OSQLNodeOuterJoinClauseChiOJCJoinPart 2
#define OSQLNodeOuterJoinClauseChiTableReference 3
#define OSQLNodeOuterJoinClauseChiQueryPartitionClause 4
#define OSQLNodeOuterJoinClauseChiOJCOnOrUsing 5
 
#define OSQLNodeOuterJoinType 114
#define OSQLNodeOuterJoinTypeAnnOuterJoinWhich 1
#define OSQLNodeOuterJoinTypeAnnLiteral 2
 
#define OSQLNodePECPartition 115
#define OSQLNodePECPartitionChiPECPartitionBody 1
 
#define OSQLNodePECPartitionFor 116
 
#define OSQLNodePECPartitionOnly 117
#define OSQLNodePECPartitionOnlyChiPartition 1
 
#define OSQLNodePECSubpartition 118
#define OSQLNodePECSubpartitionChiPECSubpartitionBody 1
 
#define OSQLNodePECSubpartitionFor 119
 
#define OSQLNodePECSubpartitionOnly 120
#define OSQLNodePECSubpartitionOnlyChiSubpartition 1
 
#define OSQLNodeParenColumnList 121
 
#define OSQLNodeParenConstantList 122
 
#define OSQLNodeParenExprList 123
 
#define OSQLNodeParenJoinClause 124
#define OSQLNodeParenJoinClauseChiJoinClause 1
 
#define OSQLNodeParenLiteralList 125
#define OSQLNodeParenLiteralListChiLiteralList 1
 
#define OSQLNodeParenSubquery 126
#define OSQLNodeParenSubqueryChiSubquery 1
 
#define OSQLNodePartition 127
#define OSQLNodePartitionChiSTUB 1
 
#define OSQLNodePartitionKeyValue 128
#define OSQLNodePartitionKeyValueChiSTUB 1
 
#define OSQLNodePattern 129
#define OSQLNodePatternChiSTUB 1
 
#define OSQLNodePivotClause 130
#define OSQLNodePivotClauseAnnLiteral 1
#define OSQLNodePivotClauseChiPivotClauseBodyList 1
#define OSQLNodePivotClauseChiPivotForClause 2
#define OSQLNodePivotClauseChiPivotInClause 3
 
#define OSQLNodePivotClauseBody 131
#define OSQLNodePivotClauseBodyAnnAggregateFunction 1
#define OSQLNodePivotClauseBodyChiExpr 1
#define OSQLNodePivotClauseBodyChiAsSuffix 2
 
#define OSQLNodePivotClauseBodyList 132
 
#define OSQLNodePivotForClause 133
#define OSQLNodePivotForClauseChiColumnOrParenList 1
 
#define OSQLNodePivotInClause 134
#define OSQLNodePivotInClauseChiPivotInClauseBody 1
 
#define OSQLNodePosition 135
#define OSQLNodePositionChiSTUB 1
 
#define OSQLNodeQualifiedName 136
#define OSQLNodeQualifiedNameAnnSchemaName 1
#define OSQLNodeQualifiedNameAnnBaseName 2
 
#define OSQLNodeQueryBlock 137
#define OSQLNodeQueryBlockAnnSelectWhich 1
#define OSQLNodeQueryBlockChiSelectList 1
#define OSQLNodeQueryBlockChiFromClause 2
#define OSQLNodeQueryBlockChiWhereClause 3
#define OSQLNodeQueryBlockChiHierQueryClause 4
#define OSQLNodeQueryBlockChiGroupByClause 5
#define OSQLNodeQueryBlockChiHavingClause 6
#define OSQLNodeQueryBlockChiModelClause 7
 
#define OSQLNodeQueryName 138
#define OSQLNodeQueryNameAnnName 1
 
#define OSQLNodeQueryPartitionClause 139
#define OSQLNodeQueryPartitionClauseChiExprOrParenList 1
 
#define OSQLNodeReferenceModel 140
#define OSQLNodeReferenceModelChiReferenceModelName 1
#define OSQLNodeReferenceModelChiSubquery 2
#define OSQLNodeReferenceModelChiModelColumnClauses 3
#define OSQLNodeReferenceModelChiCellReferenceOptions 4
 
#define OSQLNodeReferenceModelList 141
 
#define OSQLNodeReferenceModelName 142
#define OSQLNodeReferenceModelNameChiSTUB 1
 
#define OSQLNodeReturnRowsClause 143
#define OSQLNodeReturnRowsClauseAnnRRCUpdatedOrAll 1
 
#define OSQLNodeRollupCubeClause 144
#define OSQLNodeRollupCubeClauseAnnRCCRollupOrCube 1
#define OSQLNodeRollupCubeClauseChiGroupingExpressionList 1
 
#define OSQLNodeSCFLIn 145
#define OSQLNodeSCFLInChiSCFLInTermList 1
 
#define OSQLNodeSCFLLike 146
#define OSQLNodeSCFLLikeAnnSCFLIncOrDec 1
#define OSQLNodeSCFLLikeChiSCFLLikePart 1
#define OSQLNodeSCFLLikeChiLiteral 2
#define OSQLNodeSCFLLikeChiLiteral 3
#define OSQLNodeSCFLLikeChiLiteral 4
 
#define OSQLNodeSCFLLikePart 147
#define OSQLNodeSCFLLikePartChiPattern 1
 
#define OSQLNodeSFCTerm 148
#define OSQLNodeSFCTermChiQueryName 1
#define OSQLNodeSFCTermChiParenSubquery 2
 
#define OSQLNodeSLExpr 149
#define OSQLNodeSLExprChiExpr 1
#define OSQLNodeSLExprChiAsSuffix 2
 
#define OSQLNodeSLQueryNameDS 150
#define OSQLNodeSLQueryNameDSChiQueryName 1
 
#define OSQLNodeSLTableRef 151
#define OSQLNodeSLTableRefChiSchemaPrefix 1
#define OSQLNodeSLTableRefChiTVName 2
 
#define OSQLNodeSLTableRefDS 152
#define OSQLNodeSLTableRefDSChiSLTableRef 1
 
#define OSQLNodeSQQueryTableExpression 153
#define OSQLNodeSQQueryTableExpressionChiSubquery 1
#define OSQLNodeSQQueryTableExpressionChiSubqueryRestrictionClause 2
 
#define OSQLNodeSQRCheckOption 154
#define OSQLNodeSQRCheckOptionChiSQRConstraint 1
 
#define OSQLNodeSQRConstraint 155
#define OSQLNodeSQRConstraintChiConstraint 1
 
#define OSQLNodeSQRReadOnly 156
 
#define OSQLNodeSTUB 157
#define OSQLNodeSTUBAnnLiteral 1
 
#define OSQLNodeSampleClause 158
#define OSQLNodeSampleClauseAnnLiteral 1
#define OSQLNodeSampleClauseChiSamplePercent 1
#define OSQLNodeSampleClauseChiSampleClauseSeed 2
 
#define OSQLNodeSampleClauseSeed 159
#define OSQLNodeSampleClauseSeedChiSeedValue 1
 
#define OSQLNodeSamplePercent 160
#define OSQLNodeSamplePercentAnnNumber 1
 
#define OSQLNodeSchemaName 161
#define OSQLNodeSchemaNameAnnName 1
 
#define OSQLNodeSchemaPrefix 162
#define OSQLNodeSchemaPrefixChiSchemaName 1
 
#define OSQLNodeSeedValue 163
#define OSQLNodeSeedValueChiSTUB 1
 
#define OSQLNodeSelectHint 164
#define OSQLNodeSelectHintChiSTUB 1
 
#define OSQLNodeSelectListItemList 165
 
#define OSQLNodeSelectStatement 166
#define OSQLNodeSelectStatementChiSubqueryFactoringClause 1
#define OSQLNodeSelectStatementChiSubquery 2
#define OSQLNodeSelectStatementChiForUpdateClause 3
 
#define OSQLNodeSimpleBlock 167
#define OSQLNodeSimpleBlockChiStatements 1
#define OSQLNodeSimpleBlockChiExcpSection 2
 
#define OSQLNodeSimpleName 168
#define OSQLNodeSimpleNameAnnBaseName 1
 
#define OSQLNodeSingleColumnForLoop 169
#define OSQLNodeSingleColumnForLoopChiDimensionColumn 1
#define OSQLNodeSingleColumnForLoopChiSCFLBody 2
 
#define OSQLNodeStar 170
 
#define OSQLNodeStatement 171
#define OSQLNodeStatementChiStatement1 1
 
#define OSQLNodeStatements 172
 
#define OSQLNodeSubpartition 173
#define OSQLNodeSubpartitionChiSTUB 1
 
#define OSQLNodeSubpartitionKeyValue 174
#define OSQLNodeSubpartitionKeyValueChiSTUB 1
 
#define OSQLNodeSubquery 175
#define OSQLNodeSubqueryChiSubqueryMain 1
#define OSQLNodeSubqueryChiOrderByClause 2
 
#define OSQLNodeSubqueryFactoringClause 176
 
#define OSQLNodeSubqueryMain 177
#define OSQLNodeSubqueryMainChiQueryBlock 1
 
#define OSQLNodeSubqueryRestrictionClause 178
#define OSQLNodeSubqueryRestrictionClauseChiSQRBody 1
 
#define OSQLNodeTCETail 179
 
#define OSQLNodeTVName 180
#define OSQLNodeTVNameAnnName 1
 
#define OSQLNodeTVQueryTableExpression 181
#define OSQLNodeTVQueryTableExpressionChiSchemaPrefix 1
#define OSQLNodeTVQueryTableExpressionChiTVName 2
#define OSQLNodeTVQueryTableExpressionChiPECOrATDBL 3
#define OSQLNodeTVQueryTableExpressionChiSampleClause 4
 
#define OSQLNodeTableAlias 182
#define OSQLNodeTableAliasAnnName 1
 
#define OSQLNodeTableCollectionExpression 183
#define OSQLNodeTableCollectionExpressionChiCollectionExpression 1
#define OSQLNodeTableCollectionExpressionChiTCETail 2
 
#define OSQLNodeTableReference 184
#define OSQLNodeTableReferenceChiTableReferenceStart 1
#define OSQLNodeTableReferenceChiFlashbackQueryClause 2
#define OSQLNodeTableReferenceChiTableAlias 3
 
#define OSQLNodeTableReferenceOnly 185
#define OSQLNodeTableReferenceOnlyChiQueryTableExpression 1
 
#define OSQLNodeTableReferenceQueryTable 186
#define OSQLNodeTableReferenceQueryTableChiQueryTableExpression 1
#define OSQLNodeTableReferenceQueryTableChiPivotTypeClause 2
 
#define OSQLNodeTermNumber 187
#define OSQLNodeTermNumberAnnNumber 1
 
#define OSQLNodeTermString 188
#define OSQLNodeTermStringAnnString 1
 
#define OSQLNodeUnpivotClause 189
#define OSQLNodeUnpivotClauseChiInclExclNulls 1
#define OSQLNodeUnpivotClauseChiColumnOrParenList 2
#define OSQLNodeUnpivotClauseChiPivotForClause 3
#define OSQLNodeUnpivotClauseChiUnpivotInClause 4
 
#define OSQLNodeUnpivotInClause 190
#define OSQLNodeUnpivotInClauseChiUnpivotInClauseBody 1
 
#define OSQLNodeUnpivotInClauseBody 191
 
#define OSQLNodeUnpivotInClauseTerm 192
#define OSQLNodeUnpivotInClauseTermChiColumnOrParenList 1
#define OSQLNodeUnpivotInClauseTermChiAsConstantOrParenList 2
 
#define OSQLNodeWhereClause 193
#define OSQLNodeWhereClauseChiCondition 1
 
#define OSQLEnumAggregateFunctionNone 0
#define OSQLEnumAggregateFunctionAVG 1
#define OSQLEnumAggregateFunctionCORR 2
#define OSQLEnumAggregateFunctionCOUNT 3
#define OSQLEnumAggregateFunctionCOVAR_POP 4
#define OSQLEnumAggregateFunctionCOVAR_SAMP 5
#define OSQLEnumAggregateFunctionCUME_DIST 6
#define OSQLEnumAggregateFunctionDENSE_RANK 7
#define OSQLEnumAggregateFunctionFIRST 8
#define OSQLEnumAggregateFunctionGROUP_ID 9
#define OSQLEnumAggregateFunctionGROUPING 10
#define OSQLEnumAggregateFunctionGROUPING_ID 11
#define OSQLEnumAggregateFunctionLAST 12
#define OSQLEnumAggregateFunctionMAX 13
#define OSQLEnumAggregateFunctionMIN 14
#define OSQLEnumAggregateFunctionPERCENTILE_CONT 15
#define OSQLEnumAggregateFunctionPERCENTILE_DISC 16
#define OSQLEnumAggregateFunctionPERCENT_RANK 17
#define OSQLEnumAggregateFunctionRANK 18
#define OSQLEnumAggregateFunctionREGR_SLOPE 19
#define OSQLEnumAggregateFunctionREGR_INTERCEPT 20
#define OSQLEnumAggregateFunctionREGR_COUNT 21
#define OSQLEnumAggregateFunctionREGR_R2 22
#define OSQLEnumAggregateFunctionREGR_AVGX 23
#define OSQLEnumAggregateFunctionREGR_AVGY 24
#define OSQLEnumAggregateFunctionREGR_SXX 25
#define OSQLEnumAggregateFunctionREGR_SYY 26
#define OSQLEnumAggregateFunctionREGR_SXY 27
#define OSQLEnumAggregateFunctionSTDDEV 28
#define OSQLEnumAggregateFunctionSTDDEV_POP 29
#define OSQLEnumAggregateFunctionSTDDEV_SAMP 30
#define OSQLEnumAggregateFunctionSUM 31
#define OSQLEnumAggregateFunctionVAR_POP 32
#define OSQLEnumAggregateFunctionVAR_SAMP 33
#define OSQLEnumAggregateFunctionVARIANCE 34
 
#define OSQLEnumCROIgnoreOrKeepNone 0
#define OSQLEnumCROIgnoreOrKeepIGNORE 1
#define OSQLEnumCROIgnoreOrKeepKEEP 2
 
#define OSQLEnumInclExclNone 0
#define OSQLEnumInclExclINCLUDE 1
#define OSQLEnumInclExclEXCLUDE 2
 
#define OSQLEnumMRRAutoOrSeqNone 0
#define OSQLEnumMRRAutoOrSeqAUTOMATIC 1
#define OSQLEnumMRRAutoOrSeqSEQUENTIAL 2
 
#define OSQLEnumOBCAscOrDescNone 0
#define OSQLEnumOBCAscOrDescASC 1
#define OSQLEnumOBCAscOrDescDESC 2
 
#define OSQLEnumOBCFirstOrLastNone 0
#define OSQLEnumOBCFirstOrLastFIRST 1
#define OSQLEnumOBCFirstOrLastLAST 2
 
#define OSQLEnumOuterJoinWhichNone 0
#define OSQLEnumOuterJoinWhichFULL 1
#define OSQLEnumOuterJoinWhichLEFT 2
#define OSQLEnumOuterJoinWhichRIGHT 3
 
#define OSQLEnumRCCRollupOrCubeNone 0
#define OSQLEnumRCCRollupOrCubeROLLUP 1
#define OSQLEnumRCCRollupOrCubeCUBE 2
 
#define OSQLEnumRRCUpdatedOrAllNone 0
#define OSQLEnumRRCUpdatedOrAllUPDATED 1
#define OSQLEnumRRCUpdatedOrAllALL 2
 
#define OSQLEnumSCFLIncOrDecNone 0
#define OSQLEnumSCFLIncOrDecINCREMENT 1
#define OSQLEnumSCFLIncOrDecDECREMENT 2
 
#define OSQLEnumScnOrTimestampNone 0
#define OSQLEnumScnOrTimestampSCN 1
#define OSQLEnumScnOrTimestampTIMESTAMP 2
 
#define OSQLEnumSelectWhichNone 0
#define OSQLEnumSelectWhichALL 1
#define OSQLEnumSelectWhichDISTINCT 2
#define OSQLEnumSelectWhichUNIQUE 3
 

#endif
