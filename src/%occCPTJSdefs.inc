ROUTINE %occCPTJSdefs [Type=INC]
#;
#; GENERATED USING %CPT.MakeDefsInclude - DO NOT EDIT
#;
 
#include %occCPTconfig
 

#if $$$HPTDYNMETADATA

#define JSNodeArrayExpression $$$CPTIXNODER("JS","ArrayExpression")
 
#define JSNodeAssignmentExpression $$$CPTIXNODER("JS","AssignmentExpression")
#define JSNodeAssignmentExpressionAnnOperator $$$CPTIXNODEANNR("JS",$$$JSNodeAssignmentExpression,"Operator")
#define JSNodeAssignmentExpressionChiLeft $$$CPTIXNODECHILDR("JS",$$$JSNodeAssignmentExpression,"Left")
#define JSNodeAssignmentExpressionChiRight $$$CPTIXNODECHILDR("JS",$$$JSNodeAssignmentExpression,"Right")
 
#define JSNodeBinaryExpression $$$CPTIXNODER("JS","BinaryExpression")
#define JSNodeBinaryExpressionAnnOperator $$$CPTIXNODEANNR("JS",$$$JSNodeBinaryExpression,"Operator")
#define JSNodeBinaryExpressionChiLeft $$$CPTIXNODECHILDR("JS",$$$JSNodeBinaryExpression,"Left")
#define JSNodeBinaryExpressionChiRight $$$CPTIXNODECHILDR("JS",$$$JSNodeBinaryExpression,"Right")
 
#define JSNodeBlockStatement $$$CPTIXNODER("JS","BlockStatement")
 
#define JSNodeBreakStatement $$$CPTIXNODER("JS","BreakStatement")
#define JSNodeBreakStatementChiLabel $$$CPTIXNODECHILDR("JS",$$$JSNodeBreakStatement,"Label")
 
#define JSNodeCallExpression $$$CPTIXNODER("JS","CallExpression")
#define JSNodeCallExpressionChiArguments $$$CPTIXNODECHILDR("JS",$$$JSNodeCallExpression,"Arguments")
#define JSNodeCallExpressionChiCallee $$$CPTIXNODECHILDR("JS",$$$JSNodeCallExpression,"Callee")
 
#define JSNodeCatchClause $$$CPTIXNODER("JS","CatchClause")
#define JSNodeCatchClauseChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeCatchClause,"Body")
#define JSNodeCatchClauseChiGuard $$$CPTIXNODECHILDR("JS",$$$JSNodeCatchClause,"Guard")
#define JSNodeCatchClauseChiParam $$$CPTIXNODECHILDR("JS",$$$JSNodeCatchClause,"Param")
 
#define JSNodeCatchClauseList $$$CPTIXNODER("JS","CatchClauseList")
 
#define JSNodeConditionalExpression $$$CPTIXNODER("JS","ConditionalExpression")
#define JSNodeConditionalExpressionChiAlternate $$$CPTIXNODECHILDR("JS",$$$JSNodeConditionalExpression,"Alternate")
#define JSNodeConditionalExpressionChiConsequent $$$CPTIXNODECHILDR("JS",$$$JSNodeConditionalExpression,"Consequent")
#define JSNodeConditionalExpressionChiTest $$$CPTIXNODECHILDR("JS",$$$JSNodeConditionalExpression,"Test")
 
#define JSNodeContinueStatement $$$CPTIXNODER("JS","ContinueStatement")
#define JSNodeContinueStatementChiLabel $$$CPTIXNODECHILDR("JS",$$$JSNodeContinueStatement,"Label")
 
#define JSNodeDebuggerStatement $$$CPTIXNODER("JS","DebuggerStatement")
 
#define JSNodeDoWhileStatement $$$CPTIXNODER("JS","DoWhileStatement")
#define JSNodeDoWhileStatementChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeDoWhileStatement,"Body")
#define JSNodeDoWhileStatementChiTest $$$CPTIXNODECHILDR("JS",$$$JSNodeDoWhileStatement,"Test")
 
#define JSNodeEmptyStatement $$$CPTIXNODER("JS","EmptyStatement")
 
#define JSNodeExpressionList $$$CPTIXNODER("JS","ExpressionList")
 
#define JSNodeExpressionStatement $$$CPTIXNODER("JS","ExpressionStatement")
#define JSNodeExpressionStatementChiExpression $$$CPTIXNODECHILDR("JS",$$$JSNodeExpressionStatement,"Expression")
 
#define JSNodeForInStatement $$$CPTIXNODER("JS","ForInStatement")
#define JSNodeForInStatementAnnEach $$$CPTIXNODEANNR("JS",$$$JSNodeForInStatement,"Each")
#define JSNodeForInStatementChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeForInStatement,"Body")
#define JSNodeForInStatementChiLeft $$$CPTIXNODECHILDR("JS",$$$JSNodeForInStatement,"Left")
#define JSNodeForInStatementChiRight $$$CPTIXNODECHILDR("JS",$$$JSNodeForInStatement,"Right")
 
#define JSNodeForStatement $$$CPTIXNODER("JS","ForStatement")
#define JSNodeForStatementChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeForStatement,"Body")
#define JSNodeForStatementChiInit $$$CPTIXNODECHILDR("JS",$$$JSNodeForStatement,"Init")
#define JSNodeForStatementChiTest $$$CPTIXNODECHILDR("JS",$$$JSNodeForStatement,"Test")
#define JSNodeForStatementChiUpdate $$$CPTIXNODECHILDR("JS",$$$JSNodeForStatement,"Update")
 
#define JSNodeFunctionDeclaration $$$CPTIXNODER("JS","FunctionDeclaration")
#define JSNodeFunctionDeclarationChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionDeclaration,"Body")
#define JSNodeFunctionDeclarationChiId $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionDeclaration,"Id")
#define JSNodeFunctionDeclarationChiMeta $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionDeclaration,"Meta")
#define JSNodeFunctionDeclarationChiParams $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionDeclaration,"Params")
 
#define JSNodeFunctionExpression $$$CPTIXNODER("JS","FunctionExpression")
#define JSNodeFunctionExpressionChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionExpression,"Body")
#define JSNodeFunctionExpressionChiId $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionExpression,"Id")
#define JSNodeFunctionExpressionChiMeta $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionExpression,"Meta")
#define JSNodeFunctionExpressionChiParams $$$CPTIXNODECHILDR("JS",$$$JSNodeFunctionExpression,"Params")
 
#define JSNodeFunctionMeta $$$CPTIXNODER("JS","FunctionMeta")
#define JSNodeFunctionMetaAnnIsThunk $$$CPTIXNODEANNR("JS",$$$JSNodeFunctionMeta,"IsThunk")
#define JSNodeFunctionMetaAnnIsClosed $$$CPTIXNODEANNR("JS",$$$JSNodeFunctionMeta,"IsClosed")
#define JSNodeFunctionMetaAnnIsGenerator $$$CPTIXNODEANNR("JS",$$$JSNodeFunctionMeta,"IsGenerator")
#define JSNodeFunctionMetaAnnIsExpression $$$CPTIXNODEANNR("JS",$$$JSNodeFunctionMeta,"IsExpression")
 
#define JSNodeIdentifier $$$CPTIXNODER("JS","Identifier")
#define JSNodeIdentifierAnnName $$$CPTIXNODEANNR("JS",$$$JSNodeIdentifier,"Name")
 
#define JSNodeIfStatement $$$CPTIXNODER("JS","IfStatement")
#define JSNodeIfStatementChiAlternate $$$CPTIXNODECHILDR("JS",$$$JSNodeIfStatement,"Alternate")
#define JSNodeIfStatementChiConsequent $$$CPTIXNODECHILDR("JS",$$$JSNodeIfStatement,"Consequent")
#define JSNodeIfStatementChiTest $$$CPTIXNODECHILDR("JS",$$$JSNodeIfStatement,"Test")
 
#define JSNodeIncompleteParseNode $$$CPTIXNODER("JS","IncompleteParseNode")
 
#define JSNodeLabeledStatement $$$CPTIXNODER("JS","LabeledStatement")
#define JSNodeLabeledStatementChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeLabeledStatement,"Body")
#define JSNodeLabeledStatementChiLabel $$$CPTIXNODECHILDR("JS",$$$JSNodeLabeledStatement,"Label")
 
#define JSNodeLiteral $$$CPTIXNODER("JS","Literal")
#define JSNodeLiteralAnnValue $$$CPTIXNODEANNR("JS",$$$JSNodeLiteral,"Value")
#define JSNodeLiteralAnnLiteralType $$$CPTIXNODEANNR("JS",$$$JSNodeLiteral,"LiteralType")
 
#define JSNodeLogicalExpression $$$CPTIXNODER("JS","LogicalExpression")
#define JSNodeLogicalExpressionAnnOperator $$$CPTIXNODEANNR("JS",$$$JSNodeLogicalExpression,"Operator")
#define JSNodeLogicalExpressionChiLeft $$$CPTIXNODECHILDR("JS",$$$JSNodeLogicalExpression,"Left")
#define JSNodeLogicalExpressionChiRight $$$CPTIXNODECHILDR("JS",$$$JSNodeLogicalExpression,"Right")
 
#define JSNodeMemberExpression $$$CPTIXNODER("JS","MemberExpression")
#define JSNodeMemberExpressionAnnComputed $$$CPTIXNODEANNR("JS",$$$JSNodeMemberExpression,"Computed")
#define JSNodeMemberExpressionChiObject $$$CPTIXNODECHILDR("JS",$$$JSNodeMemberExpression,"Object")
#define JSNodeMemberExpressionChiProperty $$$CPTIXNODECHILDR("JS",$$$JSNodeMemberExpression,"Property")
 
#define JSNodeMissing $$$CPTIXNODER("JS","Missing")
 
#define JSNodeNewExpression $$$CPTIXNODER("JS","NewExpression")
#define JSNodeNewExpressionChiArguments $$$CPTIXNODECHILDR("JS",$$$JSNodeNewExpression,"Arguments")
#define JSNodeNewExpressionChiCallee $$$CPTIXNODECHILDR("JS",$$$JSNodeNewExpression,"Callee")
 
#define JSNodeNull $$$CPTIXNODER("JS","Null")
 
#define JSNodeObjectExpression $$$CPTIXNODER("JS","ObjectExpression")
 
#define JSNodePatternList $$$CPTIXNODER("JS","PatternList")
 
#define JSNodeProgram $$$CPTIXNODER("JS","Program")
 
#define JSNodeProperty $$$CPTIXNODER("JS","Property")
#define JSNodePropertyAnnKind $$$CPTIXNODEANNR("JS",$$$JSNodeProperty,"Kind")
#define JSNodePropertyChiKey $$$CPTIXNODECHILDR("JS",$$$JSNodeProperty,"Key")
#define JSNodePropertyChiValue $$$CPTIXNODECHILDR("JS",$$$JSNodeProperty,"Value")
 
#define JSNodeReturnStatement $$$CPTIXNODER("JS","ReturnStatement")
#define JSNodeReturnStatementChiArgument $$$CPTIXNODECHILDR("JS",$$$JSNodeReturnStatement,"Argument")
 
#define JSNodeSequenceExpression $$$CPTIXNODER("JS","SequenceExpression")
 
#define JSNodeStatementList $$$CPTIXNODER("JS","StatementList")
 
#define JSNodeSwitchCase $$$CPTIXNODER("JS","SwitchCase")
#define JSNodeSwitchCaseChiConsequent $$$CPTIXNODECHILDR("JS",$$$JSNodeSwitchCase,"Consequent")
#define JSNodeSwitchCaseChiTest $$$CPTIXNODECHILDR("JS",$$$JSNodeSwitchCase,"Test")
 
#define JSNodeSwitchCaseList $$$CPTIXNODER("JS","SwitchCaseList")
 
#define JSNodeSwitchStatement $$$CPTIXNODER("JS","SwitchStatement")
#define JSNodeSwitchStatementChiCases $$$CPTIXNODECHILDR("JS",$$$JSNodeSwitchStatement,"Cases")
#define JSNodeSwitchStatementChiDiscriminant $$$CPTIXNODECHILDR("JS",$$$JSNodeSwitchStatement,"Discriminant")
 
#define JSNodeThisExpression $$$CPTIXNODER("JS","ThisExpression")
 
#define JSNodeThrowStatement $$$CPTIXNODER("JS","ThrowStatement")
#define JSNodeThrowStatementChiArgument $$$CPTIXNODECHILDR("JS",$$$JSNodeThrowStatement,"Argument")
 
#define JSNodeTryStatement $$$CPTIXNODER("JS","TryStatement")
#define JSNodeTryStatementChiBlock $$$CPTIXNODECHILDR("JS",$$$JSNodeTryStatement,"Block")
#define JSNodeTryStatementChiFinalizer $$$CPTIXNODECHILDR("JS",$$$JSNodeTryStatement,"Finalizer")
#define JSNodeTryStatementChiHandlers $$$CPTIXNODECHILDR("JS",$$$JSNodeTryStatement,"Handlers")
 
#define JSNodeUnaryExpression $$$CPTIXNODER("JS","UnaryExpression")
#define JSNodeUnaryExpressionAnnOperator $$$CPTIXNODEANNR("JS",$$$JSNodeUnaryExpression,"Operator")
#define JSNodeUnaryExpressionAnnPrefix $$$CPTIXNODEANNR("JS",$$$JSNodeUnaryExpression,"Prefix")
#define JSNodeUnaryExpressionChiArgument $$$CPTIXNODECHILDR("JS",$$$JSNodeUnaryExpression,"Argument")
 
#define JSNodeUnresolvedNode $$$CPTIXNODER("JS","UnresolvedNode")
#define JSNodeUnresolvedNodeAnnErrorMessage $$$CPTIXNODEANNR("JS",$$$JSNodeUnresolvedNode,"ErrorMessage")
 
#define JSNodeUpdateExpression $$$CPTIXNODER("JS","UpdateExpression")
#define JSNodeUpdateExpressionAnnOperator $$$CPTIXNODEANNR("JS",$$$JSNodeUpdateExpression,"Operator")
#define JSNodeUpdateExpressionAnnPrefix $$$CPTIXNODEANNR("JS",$$$JSNodeUpdateExpression,"Prefix")
#define JSNodeUpdateExpressionChiArgument $$$CPTIXNODECHILDR("JS",$$$JSNodeUpdateExpression,"Argument")
 
#define JSNodeVariableDeclaration $$$CPTIXNODER("JS","VariableDeclaration")
#define JSNodeVariableDeclarationAnnKind $$$CPTIXNODEANNR("JS",$$$JSNodeVariableDeclaration,"Kind")
 
#define JSNodeVariableDeclarator $$$CPTIXNODER("JS","VariableDeclarator")
#define JSNodeVariableDeclaratorChiId $$$CPTIXNODECHILDR("JS",$$$JSNodeVariableDeclarator,"Id")
#define JSNodeVariableDeclaratorChiInit $$$CPTIXNODECHILDR("JS",$$$JSNodeVariableDeclarator,"Init")
 
#define JSNodeWhileStatement $$$CPTIXNODER("JS","WhileStatement")
#define JSNodeWhileStatementChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeWhileStatement,"Body")
#define JSNodeWhileStatementChiTest $$$CPTIXNODECHILDR("JS",$$$JSNodeWhileStatement,"Test")
 
#define JSNodeWithStatement $$$CPTIXNODER("JS","WithStatement")
#define JSNodeWithStatementChiBody $$$CPTIXNODECHILDR("JS",$$$JSNodeWithStatement,"Body")
#define JSNodeWithStatementChiObject $$$CPTIXNODECHILDR("JS",$$$JSNodeWithStatement,"Object")
 
#define JSEnumAssignmentOperatorTokenNone $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","None")
#define JSEnumAssignmentOperatorTokenOpEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpEquals")
#define JSEnumAssignmentOperatorTokenOpPlusEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpPlusEquals")
#define JSEnumAssignmentOperatorTokenOpMinusEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpMinusEquals")
#define JSEnumAssignmentOperatorTokenOpTimesEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpTimesEquals")
#define JSEnumAssignmentOperatorTokenOpDivideEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpDivideEquals")
#define JSEnumAssignmentOperatorTokenOpModulusEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpModulusEquals")
#define JSEnumAssignmentOperatorTokenOpLeftShiftEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpLeftShiftEquals")
#define JSEnumAssignmentOperatorTokenOpSignedRightShiftEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpSignedRightShiftEquals")
#define JSEnumAssignmentOperatorTokenOpZerofillRightShiftEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpZerofillRightShiftEquals")
#define JSEnumAssignmentOperatorTokenOpBitwiseOrEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpBitwiseOrEquals")
#define JSEnumAssignmentOperatorTokenOpBitwiseXorEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpBitwiseXorEquals")
#define JSEnumAssignmentOperatorTokenOpBitwiseAndEquals $$$CPTIXENUMVALUER("JS","AssignmentOperatorToken","OpBitwiseAndEquals")
 
#define JSEnumBinaryOperatorTokenNone $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","None")
#define JSEnumBinaryOperatorTokenOpEqualsEquals $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpEqualsEquals")
#define JSEnumBinaryOperatorTokenOpNotEquals $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpNotEquals")
#define JSEnumBinaryOperatorTokenOpEqualsEqualsEquals $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpEqualsEqualsEquals")
#define JSEnumBinaryOperatorTokenOpNotEqualsEquals $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpNotEqualsEquals")
#define JSEnumBinaryOperatorTokenOpLess $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpLess")
#define JSEnumBinaryOperatorTokenOpLessEquals $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpLessEquals")
#define JSEnumBinaryOperatorTokenOpGreater $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpGreater")
#define JSEnumBinaryOperatorTokenOpGreaterEquals $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpGreaterEquals")
#define JSEnumBinaryOperatorTokenOpLeftShift $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpLeftShift")
#define JSEnumBinaryOperatorTokenOpSignedRightShift $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpSignedRightShift")
#define JSEnumBinaryOperatorTokenOpZerofillRightShift $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpZerofillRightShift")
#define JSEnumBinaryOperatorTokenOpPlus $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpPlus")
#define JSEnumBinaryOperatorTokenOpMinus $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpMinus")
#define JSEnumBinaryOperatorTokenOpTimes $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpTimes")
#define JSEnumBinaryOperatorTokenOpDivide $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpDivide")
#define JSEnumBinaryOperatorTokenOpModulus $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpModulus")
#define JSEnumBinaryOperatorTokenOpBitwiseOr $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpBitwiseOr")
#define JSEnumBinaryOperatorTokenOpBitwiseXor $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpBitwiseXor")
#define JSEnumBinaryOperatorTokenOpBitwiseAnd $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpBitwiseAnd")
#define JSEnumBinaryOperatorTokenin $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","in")
#define JSEnumBinaryOperatorTokeninstanceof $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","instanceof")
#define JSEnumBinaryOperatorTokenOpDotDot $$$CPTIXENUMVALUER("JS","BinaryOperatorToken","OpDotDot")
 
#define JSEnumLogicalOperatorTokenNone $$$CPTIXENUMVALUER("JS","LogicalOperatorToken","None")
#define JSEnumLogicalOperatorTokenOpLogicalAnd $$$CPTIXENUMVALUER("JS","LogicalOperatorToken","OpLogicalAnd")
#define JSEnumLogicalOperatorTokenOpLogicalOr $$$CPTIXENUMVALUER("JS","LogicalOperatorToken","OpLogicalOr")
 
#define JSEnumPropertyKindNone $$$CPTIXENUMVALUER("JS","PropertyKind","None")
#define JSEnumPropertyKindinit $$$CPTIXENUMVALUER("JS","PropertyKind","init")
#define JSEnumPropertyKindget $$$CPTIXENUMVALUER("JS","PropertyKind","get")
#define JSEnumPropertyKindset $$$CPTIXENUMVALUER("JS","PropertyKind","set")
 
#define JSEnumUnaryOperatorTokenNone $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","None")
#define JSEnumUnaryOperatorTokenOpMinus $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","OpMinus")
#define JSEnumUnaryOperatorTokenOpPlus $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","OpPlus")
#define JSEnumUnaryOperatorTokenOpLogicalNot $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","OpLogicalNot")
#define JSEnumUnaryOperatorTokenOpBitwiseNot $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","OpBitwiseNot")
#define JSEnumUnaryOperatorTokentypeof $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","typeof")
#define JSEnumUnaryOperatorTokenvoid $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","void")
#define JSEnumUnaryOperatorTokendelete $$$CPTIXENUMVALUER("JS","UnaryOperatorToken","delete")
 
#define JSEnumUpdateOperatorTokenNone $$$CPTIXENUMVALUER("JS","UpdateOperatorToken","None")
#define JSEnumUpdateOperatorTokenOpIncrement $$$CPTIXENUMVALUER("JS","UpdateOperatorToken","OpIncrement")
#define JSEnumUpdateOperatorTokenOpDecrement $$$CPTIXENUMVALUER("JS","UpdateOperatorToken","OpDecrement")
 
#define JSEnumVariableDeclarationKindNone $$$CPTIXENUMVALUER("JS","VariableDeclarationKind","None")
#define JSEnumVariableDeclarationKindvar $$$CPTIXENUMVALUER("JS","VariableDeclarationKind","var")
#define JSEnumVariableDeclarationKindlet $$$CPTIXENUMVALUER("JS","VariableDeclarationKind","let")
#define JSEnumVariableDeclarationKindconst $$$CPTIXENUMVALUER("JS","VariableDeclarationKind","const")
 

#else

#define JSNodeArrayExpression 1
 
#define JSNodeAssignmentExpression 4
#define JSNodeAssignmentExpressionAnnOperator 1
#define JSNodeAssignmentExpressionChiLeft 1
#define JSNodeAssignmentExpressionChiRight 2
 
#define JSNodeBinaryExpression 6
#define JSNodeBinaryExpressionAnnOperator 1
#define JSNodeBinaryExpressionChiLeft 1
#define JSNodeBinaryExpressionChiRight 2
 
#define JSNodeBlockStatement 8
 
#define JSNodeBreakStatement 9
#define JSNodeBreakStatementChiLabel 1
 
#define JSNodeCallExpression 10
#define JSNodeCallExpressionChiArguments 1
#define JSNodeCallExpressionChiCallee 2
 
#define JSNodeCatchClause 12
#define JSNodeCatchClauseChiBody 1
#define JSNodeCatchClauseChiGuard 2
#define JSNodeCatchClauseChiParam 3
 
#define JSNodeCatchClauseList 58
 
#define JSNodeConditionalExpression 16
#define JSNodeConditionalExpressionChiAlternate 1
#define JSNodeConditionalExpressionChiConsequent 2
#define JSNodeConditionalExpressionChiTest 3
 
#define JSNodeContinueStatement 17
#define JSNodeContinueStatementChiLabel 1
 
#define JSNodeDebuggerStatement 18
 
#define JSNodeDoWhileStatement 19
#define JSNodeDoWhileStatementChiBody 1
#define JSNodeDoWhileStatementChiTest 2
 
#define JSNodeEmptyStatement 20
 
#define JSNodeExpressionList 11
 
#define JSNodeExpressionStatement 21
#define JSNodeExpressionStatementChiExpression 1
 
#define JSNodeForInStatement 22
#define JSNodeForInStatementAnnEach 1
#define JSNodeForInStatementChiBody 1
#define JSNodeForInStatementChiLeft 2
#define JSNodeForInStatementChiRight 3
 
#define JSNodeForStatement 23
#define JSNodeForStatementChiBody 1
#define JSNodeForStatementChiInit 2
#define JSNodeForStatementChiTest 3
#define JSNodeForStatementChiUpdate 4
 
#define JSNodeFunctionDeclaration 26
#define JSNodeFunctionDeclarationChiBody 1
#define JSNodeFunctionDeclarationChiId 2
#define JSNodeFunctionDeclarationChiMeta 3
#define JSNodeFunctionDeclarationChiParams 4
 
#define JSNodeFunctionExpression 28
#define JSNodeFunctionExpressionChiBody 1
#define JSNodeFunctionExpressionChiId 2
#define JSNodeFunctionExpressionChiMeta 3
#define JSNodeFunctionExpressionChiParams 4
 
#define JSNodeFunctionMeta 27
#define JSNodeFunctionMetaAnnIsThunk 1
#define JSNodeFunctionMetaAnnIsClosed 2
#define JSNodeFunctionMetaAnnIsGenerator 3
#define JSNodeFunctionMetaAnnIsExpression 4
 
#define JSNodeIdentifier 32
#define JSNodeIdentifierAnnName 1
 
#define JSNodeIfStatement 33
#define JSNodeIfStatementChiAlternate 1
#define JSNodeIfStatementChiConsequent 2
#define JSNodeIfStatementChiTest 3
 
#define JSNodeIncompleteParseNode 24
 
#define JSNodeLabeledStatement 34
#define JSNodeLabeledStatementChiBody 1
#define JSNodeLabeledStatementChiLabel 2
 
#define JSNodeLiteral 68
#define JSNodeLiteralAnnValue 1
#define JSNodeLiteralAnnLiteralType 2
 
#define JSNodeLogicalExpression 43
#define JSNodeLogicalExpressionAnnOperator 1
#define JSNodeLogicalExpressionChiLeft 1
#define JSNodeLogicalExpressionChiRight 2
 
#define JSNodeMemberExpression 44
#define JSNodeMemberExpressionAnnComputed 1
#define JSNodeMemberExpressionChiObject 1
#define JSNodeMemberExpressionChiProperty 2
 
#define JSNodeMissing 3
 
#define JSNodeNewExpression 45
#define JSNodeNewExpressionChiArguments 1
#define JSNodeNewExpressionChiCallee 2
 
#define JSNodeNull 2
 
#define JSNodeObjectExpression 46
 
#define JSNodePatternList 25
 
#define JSNodeProgram 48
 
#define JSNodeProperty 7
#define JSNodePropertyAnnKind 1
#define JSNodePropertyChiKey 1
#define JSNodePropertyChiValue 2
 
#define JSNodeReturnStatement 49
#define JSNodeReturnStatementChiArgument 1
 
#define JSNodeSequenceExpression 50
 
#define JSNodeStatementList 52
 
#define JSNodeSwitchCase 51
#define JSNodeSwitchCaseChiConsequent 1
#define JSNodeSwitchCaseChiTest 2
 
#define JSNodeSwitchCaseList 54
 
#define JSNodeSwitchStatement 53
#define JSNodeSwitchStatementChiCases 1
#define JSNodeSwitchStatementChiDiscriminant 2
 
#define JSNodeThisExpression 55
 
#define JSNodeThrowStatement 56
#define JSNodeThrowStatementChiArgument 1
 
#define JSNodeTryStatement 57
#define JSNodeTryStatementChiBlock 1
#define JSNodeTryStatementChiFinalizer 2
#define JSNodeTryStatementChiHandlers 3
 
#define JSNodeUnaryExpression 59
#define JSNodeUnaryExpressionAnnOperator 1
#define JSNodeUnaryExpressionAnnPrefix 2
#define JSNodeUnaryExpressionChiArgument 1
 
#define JSNodeUnresolvedNode 69
#define JSNodeUnresolvedNodeAnnErrorMessage 1
 
#define JSNodeUpdateExpression 61
#define JSNodeUpdateExpressionAnnOperator 1
#define JSNodeUpdateExpressionAnnPrefix 2
#define JSNodeUpdateExpressionChiArgument 1
 
#define JSNodeVariableDeclaration 63
#define JSNodeVariableDeclarationAnnKind 1
 
#define JSNodeVariableDeclarator 64
#define JSNodeVariableDeclaratorChiId 1
#define JSNodeVariableDeclaratorChiInit 2
 
#define JSNodeWhileStatement 65
#define JSNodeWhileStatementChiBody 1
#define JSNodeWhileStatementChiTest 2
 
#define JSNodeWithStatement 66
#define JSNodeWithStatementChiBody 1
#define JSNodeWithStatementChiObject 2
 
#define JSEnumAssignmentOperatorTokenNone 0
#define JSEnumAssignmentOperatorTokenOpEquals 1
#define JSEnumAssignmentOperatorTokenOpPlusEquals 2
#define JSEnumAssignmentOperatorTokenOpMinusEquals 3
#define JSEnumAssignmentOperatorTokenOpTimesEquals 4
#define JSEnumAssignmentOperatorTokenOpDivideEquals 5
#define JSEnumAssignmentOperatorTokenOpModulusEquals 6
#define JSEnumAssignmentOperatorTokenOpLeftShiftEquals 7
#define JSEnumAssignmentOperatorTokenOpSignedRightShiftEquals 8
#define JSEnumAssignmentOperatorTokenOpZerofillRightShiftEquals 9
#define JSEnumAssignmentOperatorTokenOpBitwiseOrEquals 10
#define JSEnumAssignmentOperatorTokenOpBitwiseXorEquals 11
#define JSEnumAssignmentOperatorTokenOpBitwiseAndEquals 12
 
#define JSEnumBinaryOperatorTokenNone 0
#define JSEnumBinaryOperatorTokenOpEqualsEquals 1
#define JSEnumBinaryOperatorTokenOpNotEquals 2
#define JSEnumBinaryOperatorTokenOpEqualsEqualsEquals 3
#define JSEnumBinaryOperatorTokenOpNotEqualsEquals 4
#define JSEnumBinaryOperatorTokenOpLess 5
#define JSEnumBinaryOperatorTokenOpLessEquals 6
#define JSEnumBinaryOperatorTokenOpGreater 7
#define JSEnumBinaryOperatorTokenOpGreaterEquals 8
#define JSEnumBinaryOperatorTokenOpLeftShift 9
#define JSEnumBinaryOperatorTokenOpSignedRightShift 10
#define JSEnumBinaryOperatorTokenOpZerofillRightShift 11
#define JSEnumBinaryOperatorTokenOpPlus 12
#define JSEnumBinaryOperatorTokenOpMinus 13
#define JSEnumBinaryOperatorTokenOpTimes 14
#define JSEnumBinaryOperatorTokenOpDivide 15
#define JSEnumBinaryOperatorTokenOpModulus 16
#define JSEnumBinaryOperatorTokenOpBitwiseOr 17
#define JSEnumBinaryOperatorTokenOpBitwiseXor 18
#define JSEnumBinaryOperatorTokenOpBitwiseAnd 19
#define JSEnumBinaryOperatorTokenin 20
#define JSEnumBinaryOperatorTokeninstanceof 21
#define JSEnumBinaryOperatorTokenOpDotDot 22
 
#define JSEnumLogicalOperatorTokenNone 0
#define JSEnumLogicalOperatorTokenOpLogicalAnd 1
#define JSEnumLogicalOperatorTokenOpLogicalOr 2
 
#define JSEnumPropertyKindNone 0
#define JSEnumPropertyKindinit 1
#define JSEnumPropertyKindget 2
#define JSEnumPropertyKindset 3
 
#define JSEnumUnaryOperatorTokenNone 0
#define JSEnumUnaryOperatorTokenOpMinus 1
#define JSEnumUnaryOperatorTokenOpPlus 2
#define JSEnumUnaryOperatorTokenOpLogicalNot 3
#define JSEnumUnaryOperatorTokenOpBitwiseNot 4
#define JSEnumUnaryOperatorTokentypeof 5
#define JSEnumUnaryOperatorTokenvoid 6
#define JSEnumUnaryOperatorTokendelete 7
 
#define JSEnumUpdateOperatorTokenNone 0
#define JSEnumUpdateOperatorTokenOpIncrement 1
#define JSEnumUpdateOperatorTokenOpDecrement 2
 
#define JSEnumVariableDeclarationKindNone 0
#define JSEnumVariableDeclarationKindvar 1
#define JSEnumVariableDeclarationKindlet 2
#define JSEnumVariableDeclarationKindconst 3
 

#endif
