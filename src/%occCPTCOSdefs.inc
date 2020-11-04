ROUTINE %occCPTCOSdefs [Type=INC]
#;
#; GENERATED USING %CPT.MakeDefsInclude - DO NOT EDIT
#;
 
#include %occCPTconfig
 

#if $$$HPTDYNMETADATA

#define HPTNodeActualParameters $$$CPTIXNODER("COS","ActualParameters")
 
#define HPTNodeArgument $$$CPTIXNODER("COS","Argument")
#define HPTNodeArgumentAnnSnarf $$$CPTIXNODEANNR("COS",$$$HPTNodeArgument,"Snarf")
 
#define HPTNodeBraceBlock $$$CPTIXNODER("COS","BraceBlock")
 
#define HPTNodeByRefLvn $$$CPTIXNODER("COS","ByRefLvn")
#define HPTNodeByRefLvnChiLvnRef $$$CPTIXNODECHILDR("COS",$$$HPTNodeByRefLvn,"LvnRef")
 
#define HPTNodeClassNameComponent $$$CPTIXNODER("COS","ClassNameComponent")
#define HPTNodeClassNameComponentAnnName $$$CPTIXNODEANNR("COS",$$$HPTNodeClassNameComponent,"Name")
 
#define HPTNodeCommandDO $$$CPTIXNODER("COS","CommandDO")
#define HPTNodeCommandDOAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandDO,"CommandName")
#define HPTNodeCommandDOChiPostCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandDO,"PostCondition")
#define HPTNodeCommandDOChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandDO,"Arguments")
 
#define HPTNodeCommandDOArguments $$$CPTIXNODER("COS","CommandDOArguments")
 
#define HPTNodeCommandDOBlock $$$CPTIXNODER("COS","CommandDOBlock")
#define HPTNodeCommandDOBlockAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandDOBlock,"CommandName")
#define HPTNodeCommandDOBlockChiBraceBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandDOBlock,"BraceBlock")
#define HPTNodeCommandDOBlockChiWhilePart $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandDOBlock,"WhilePart")
 
#define HPTNodeCommandDOBlockWhile $$$CPTIXNODER("COS","CommandDOBlockWhile")
#define HPTNodeCommandDOBlockWhileAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandDOBlockWhile,"CommandName")
#define HPTNodeCommandDOBlockWhileChiConditions $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandDOBlockWhile,"Conditions")
 
#define HPTNodeCommandDOTagArgument $$$CPTIXNODER("COS","CommandDOTagArgument")
#define HPTNodeCommandDOTagArgumentAnnRoutineRef $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandDOTagArgument,"RoutineRef")
#define HPTNodeCommandDOTagArgumentChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandDOTagArgument,"Arguments")
 
#define HPTNodeCommandELSELine $$$CPTIXNODER("COS","CommandELSELine")
#define HPTNodeCommandELSELineAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandELSELine,"CommandName")
#define HPTNodeCommandELSELineChiRestOfLine $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandELSELine,"RestOfLine")
 
#define HPTNodeCommandFORArguments $$$CPTIXNODER("COS","CommandFORArguments")
#define HPTNodeCommandFORArgumentsChiVar $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORArguments,"Var")
#define HPTNodeCommandFORArgumentsChiRhsList $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORArguments,"RhsList")
 
#define HPTNodeCommandFORBlock $$$CPTIXNODER("COS","CommandFORBlock")
#define HPTNodeCommandFORBlockAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandFORBlock,"CommandName")
#define HPTNodeCommandFORBlockChiImpl $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORBlock,"Impl")
 
#define HPTNodeCommandFORBlockImplMain $$$CPTIXNODER("COS","CommandFORBlockImplMain")
#define HPTNodeCommandFORBlockImplMainChiArgs $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORBlockImplMain,"Args")
#define HPTNodeCommandFORBlockImplMainChiBraceBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORBlockImplMain,"BraceBlock")
 
#define HPTNodeCommandFORLine $$$CPTIXNODER("COS","CommandFORLine")
#define HPTNodeCommandFORLineAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandFORLine,"CommandName")
#define HPTNodeCommandFORLineChiImpl $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORLine,"Impl")
 
#define HPTNodeCommandFORLineImplMain $$$CPTIXNODER("COS","CommandFORLineImplMain")
#define HPTNodeCommandFORLineImplMainChiArgs $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORLineImplMain,"Args")
#define HPTNodeCommandFORLineImplMainChiLineBody $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORLineImplMain,"LineBody")
 
#define HPTNodeCommandFORRhs $$$CPTIXNODER("COS","CommandFORRhs")
#define HPTNodeCommandFORRhsChiFrom $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORRhs,"From")
#define HPTNodeCommandFORRhsChiIncrement $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORRhs,"Increment")
#define HPTNodeCommandFORRhsChiTo $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandFORRhs,"To")
 
#define HPTNodeCommandGeneral $$$CPTIXNODER("COS","CommandGeneral")
#define HPTNodeCommandGeneralAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandGeneral,"CommandName")
#define HPTNodeCommandGeneralChiPostCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandGeneral,"PostCondition")
#define HPTNodeCommandGeneralChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandGeneral,"Arguments")
 
#define HPTNodeCommandGeneralArguments $$$CPTIXNODER("COS","CommandGeneralArguments")
 
#define HPTNodeCommandIFBlock $$$CPTIXNODER("COS","CommandIFBlock")
#define HPTNodeCommandIFBlockChiIf $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlock,"If")
#define HPTNodeCommandIFBlockChiListElseIf $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlock,"ListElseIf")
#define HPTNodeCommandIFBlockChiElse $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlock,"Else")
 
#define HPTNodeCommandIFBlockElse $$$CPTIXNODER("COS","CommandIFBlockElse")
#define HPTNodeCommandIFBlockElseAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandIFBlockElse,"CommandName")
#define HPTNodeCommandIFBlockElseChiBraceBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlockElse,"BraceBlock")
 
#define HPTNodeCommandIFBlockElseIf $$$CPTIXNODER("COS","CommandIFBlockElseIf")
#define HPTNodeCommandIFBlockElseIfAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandIFBlockElseIf,"CommandName")
#define HPTNodeCommandIFBlockElseIfChiConditions $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlockElseIf,"Conditions")
#define HPTNodeCommandIFBlockElseIfChiBraceBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlockElseIf,"BraceBlock")
 
#define HPTNodeCommandIFBlockIf $$$CPTIXNODER("COS","CommandIFBlockIf")
#define HPTNodeCommandIFBlockIfAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandIFBlockIf,"CommandName")
#define HPTNodeCommandIFBlockIfChiConditions $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlockIf,"Conditions")
#define HPTNodeCommandIFBlockIfChiBraceBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFBlockIf,"BraceBlock")
 
#define HPTNodeCommandIFLine $$$CPTIXNODER("COS","CommandIFLine")
#define HPTNodeCommandIFLineAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandIFLine,"CommandName")
#define HPTNodeCommandIFLineChiConditions $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFLine,"Conditions")
#define HPTNodeCommandIFLineChiRestOfLine $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandIFLine,"RestOfLine")
 
#define HPTNodeCommandLOCK $$$CPTIXNODER("COS","CommandLOCK")
#define HPTNodeCommandLOCKAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandLOCK,"CommandName")
#define HPTNodeCommandLOCKChiPostCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandLOCK,"PostCondition")
#define HPTNodeCommandLOCKChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandLOCK,"Arguments")
 
#define HPTNodeCommandLOCKArgument $$$CPTIXNODER("COS","CommandLOCKArgument")
#define HPTNodeCommandLOCKArgumentAnnPrefix $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandLOCKArgument,"Prefix")
#define HPTNodeCommandLOCKArgumentChiReference $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandLOCKArgument,"Reference")
#define HPTNodeCommandLOCKArgumentChiSuffix $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandLOCKArgument,"Suffix")
#define HPTNodeCommandLOCKArgumentChiTimeout $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandLOCKArgument,"Timeout")
 
#define HPTNodeCommandLOCKArguments $$$CPTIXNODER("COS","CommandLOCKArguments")
 
#define HPTNodeCommandSET $$$CPTIXNODER("COS","CommandSET")
#define HPTNodeCommandSETAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandSET,"CommandName")
#define HPTNodeCommandSETChiPostCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandSET,"PostCondition")
#define HPTNodeCommandSETChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandSET,"Arguments")
 
#define HPTNodeCommandSETArgLhs $$$CPTIXNODER("COS","CommandSETArgLhs")
#define HPTNodeCommandSETArgLhsAnnIsMultiple $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandSETArgLhs,"IsMultiple")
 
#define HPTNodeCommandSETArgument $$$CPTIXNODER("COS","CommandSETArgument")
#define HPTNodeCommandSETArgumentChiLhs $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandSETArgument,"Lhs")
#define HPTNodeCommandSETArgumentChiRhs $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandSETArgument,"Rhs")
 
#define HPTNodeCommandSETArguments $$$CPTIXNODER("COS","CommandSETArguments")
 
#define HPTNodeCommandTRYBlock $$$CPTIXNODER("COS","CommandTRYBlock")
#define HPTNodeCommandTRYBlockAnnTryCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandTRYBlock,"TryCommandName")
#define HPTNodeCommandTRYBlockAnnCatchCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandTRYBlock,"CatchCommandName")
#define HPTNodeCommandTRYBlockChiTryBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandTRYBlock,"TryBlock")
#define HPTNodeCommandTRYBlockChiCatchVar $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandTRYBlock,"CatchVar")
#define HPTNodeCommandTRYBlockChiCatchBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandTRYBlock,"CatchBlock")
 
#define HPTNodeCommandTRYBlockVar $$$CPTIXNODER("COS","CommandTRYBlockVar")
#define HPTNodeCommandTRYBlockVarAnnLeftParen $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandTRYBlockVar,"LeftParen")
#define HPTNodeCommandTRYBlockVarAnnRightParen $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandTRYBlockVar,"RightParen")
#define HPTNodeCommandTRYBlockVarChiLvnRef $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandTRYBlockVar,"LvnRef")
 
#define HPTNodeCommandWHILEBlock $$$CPTIXNODER("COS","CommandWHILEBlock")
#define HPTNodeCommandWHILEBlockAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandWHILEBlock,"CommandName")
#define HPTNodeCommandWHILEBlockChiConditions $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandWHILEBlock,"Conditions")
#define HPTNodeCommandWHILEBlockChiBraceBlock $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandWHILEBlock,"BraceBlock")
 
#define HPTNodeCommandWRITE $$$CPTIXNODER("COS","CommandWRITE")
#define HPTNodeCommandWRITEAnnCommandName $$$CPTIXNODEANNR("COS",$$$HPTNodeCommandWRITE,"CommandName")
#define HPTNodeCommandWRITEChiPostCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandWRITE,"PostCondition")
#define HPTNodeCommandWRITEChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeCommandWRITE,"Arguments")
 
#define HPTNodeCommandWRITEArguments $$$CPTIXNODER("COS","CommandWRITEArguments")
 
#define HPTNodeDotDotBase $$$CPTIXNODER("COS","DotDotBase")
#define HPTNodeDotDotBaseChiMemberRef $$$CPTIXNODECHILDR("COS",$$$HPTNodeDotDotBase,"MemberRef")
 
#define HPTNodeEmbedding $$$CPTIXNODER("COS","Embedding")
#define HPTNodeEmbeddingAnnLanguage $$$CPTIXNODEANNR("COS",$$$HPTNodeEmbedding,"Language")
#define HPTNodeEmbeddingAnnOpener $$$CPTIXNODEANNR("COS",$$$HPTNodeEmbedding,"Opener")
#define HPTNodeEmbeddingAnnBody $$$CPTIXNODEANNR("COS",$$$HPTNodeEmbedding,"Body")
#define HPTNodeEmbeddingAnnBodyExtent $$$CPTIXNODEANNR("COS",$$$HPTNodeEmbedding,"BodyExtent")
#define HPTNodeEmbeddingAnnCloser $$$CPTIXNODEANNR("COS",$$$HPTNodeEmbedding,"Closer")
 
#define HPTNodeEnvironment $$$CPTIXNODER("COS","Environment")
#define HPTNodeEnvironmentAnnBracketsUsed $$$CPTIXNODEANNR("COS",$$$HPTNodeEnvironment,"BracketsUsed")
#define HPTNodeEnvironmentChiEnv1 $$$CPTIXNODECHILDR("COS",$$$HPTNodeEnvironment,"Env1")
#define HPTNodeEnvironmentChiEnv2 $$$CPTIXNODECHILDR("COS",$$$HPTNodeEnvironment,"Env2")
 
#define HPTNodeExpression $$$CPTIXNODER("COS","Expression")
#define HPTNodeExpressionAnnDyOp $$$CPTIXNODEANNR("COS",$$$HPTNodeExpression,"DyOp")
#define HPTNodeExpressionChiLhs $$$CPTIXNODECHILDR("COS",$$$HPTNodeExpression,"Lhs")
#define HPTNodeExpressionChiRhs $$$CPTIXNODECHILDR("COS",$$$HPTNodeExpression,"Rhs")
 
#define HPTNodeExtrinsicFunctionCall $$$CPTIXNODER("COS","ExtrinsicFunctionCall")
#define HPTNodeExtrinsicFunctionCallAnnDollar2 $$$CPTIXNODEANNR("COS",$$$HPTNodeExtrinsicFunctionCall,"Dollar2")
#define HPTNodeExtrinsicFunctionCallAnnRoutineRef $$$CPTIXNODEANNR("COS",$$$HPTNodeExtrinsicFunctionCall,"RoutineRef")
#define HPTNodeExtrinsicFunctionCallChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeExtrinsicFunctionCall,"Arguments")
 
#define HPTNodeFormal $$$CPTIXNODER("COS","Formal")
#define HPTNodeFormalAnnAmpersand $$$CPTIXNODEANNR("COS",$$$HPTNodeFormal,"Ampersand")
#define HPTNodeFormalAnnName $$$CPTIXNODEANNR("COS",$$$HPTNodeFormal,"Name")
#define HPTNodeFormalAnnScoop $$$CPTIXNODEANNR("COS",$$$HPTNodeFormal,"Scoop")
#define HPTNodeFormalChiDefault $$$CPTIXNODECHILDR("COS",$$$HPTNodeFormal,"Default")
 
#define HPTNodeGvnRef $$$CPTIXNODER("COS","GvnRef")
#define HPTNodeGvnRefAnnName $$$CPTIXNODEANNR("COS",$$$HPTNodeGvnRef,"Name")
#define HPTNodeGvnRefChiEnvironment $$$CPTIXNODECHILDR("COS",$$$HPTNodeGvnRef,"Environment")
#define HPTNodeGvnRefChiSubscripts $$$CPTIXNODECHILDR("COS",$$$HPTNodeGvnRef,"Subscripts")
 
#define HPTNodeIOAscii $$$CPTIXNODER("COS","IOAscii")
#define HPTNodeIOAsciiChiAscii $$$CPTIXNODECHILDR("COS",$$$HPTNodeIOAscii,"Ascii")
 
#define HPTNodeIOFormat $$$CPTIXNODER("COS","IOFormat")
 
#define HPTNodeIOFormatFormfeed $$$CPTIXNODER("COS","IOFormatFormfeed")
 
#define HPTNodeIOFormatFormfeed2 $$$CPTIXNODER("COS","IOFormatFormfeed2")
 
#define HPTNodeIOFormatLinefeed $$$CPTIXNODER("COS","IOFormatLinefeed")
 
#define HPTNodeIOFormatTab $$$CPTIXNODER("COS","IOFormatTab")
#define HPTNodeIOFormatTabChiPosition $$$CPTIXNODECHILDR("COS",$$$HPTNodeIOFormatTab,"Position")
 
#define HPTNodeIOMnemonic $$$CPTIXNODER("COS","IOMnemonic")
#define HPTNodeIOMnemonicAnnMnemonicName $$$CPTIXNODEANNR("COS",$$$HPTNodeIOMnemonic,"MnemonicName")
#define HPTNodeIOMnemonicChiActualParameters $$$CPTIXNODECHILDR("COS",$$$HPTNodeIOMnemonic,"ActualParameters")
 
#define HPTNodeIndirection $$$CPTIXNODER("COS","Indirection")
#define HPTNodeIndirectionChiExpression $$$CPTIXNODECHILDR("COS",$$$HPTNodeIndirection,"Expression")
#define HPTNodeIndirectionChiSubscripts $$$CPTIXNODECHILDR("COS",$$$HPTNodeIndirection,"Subscripts")
 
#define HPTNodeLineBody $$$CPTIXNODER("COS","LineBody")
#define HPTNodeLineBodyChiListLineElements $$$CPTIXNODECHILDR("COS",$$$HPTNodeLineBody,"ListLineElements")
 
#define HPTNodeListClassNameComponents $$$CPTIXNODER("COS","ListClassNameComponents")
 
#define HPTNodeListCommandFORRhs $$$CPTIXNODER("COS","ListCommandFORRhs")
 
#define HPTNodeListCommandIFBlockElseIf $$$CPTIXNODER("COS","ListCommandIFBlockElseIf")
 
#define HPTNodeListExpressions $$$CPTIXNODER("COS","ListExpressions")
 
#define HPTNodeListFormals $$$CPTIXNODER("COS","ListFormals")
 
#define HPTNodeListLineElements $$$CPTIXNODER("COS","ListLineElements")
 
#define HPTNodeListLvns $$$CPTIXNODER("COS","ListLvns")
 
#define HPTNodeListMacroArgs $$$CPTIXNODER("COS","ListMacroArgs")
 
#define HPTNodeListMacroFormals $$$CPTIXNODER("COS","ListMacroFormals")
 
#define HPTNodeListMemberRefs $$$CPTIXNODER("COS","ListMemberRefs")
 
#define HPTNodeListSystemFunCASEItems $$$CPTIXNODER("COS","ListSystemFunCASEItems")
 
#define HPTNodeListSystemFunLISTUPDATEAssigns $$$CPTIXNODER("COS","ListSystemFunLISTUPDATEAssigns")
 
#define HPTNodeLiteralNumber $$$CPTIXNODER("COS","LiteralNumber")
#define HPTNodeLiteralNumberAnnValue $$$CPTIXNODEANNR("COS",$$$HPTNodeLiteralNumber,"Value")
 
#define HPTNodeLiteralString $$$CPTIXNODER("COS","LiteralString")
#define HPTNodeLiteralStringAnnValue $$$CPTIXNODEANNR("COS",$$$HPTNodeLiteralString,"Value")
 
#define HPTNodeLvn $$$CPTIXNODER("COS","Lvn")
#define HPTNodeLvnAnnName $$$CPTIXNODEANNR("COS",$$$HPTNodeLvn,"Name")
 
#define HPTNodeLvnRef $$$CPTIXNODER("COS","LvnRef")
#define HPTNodeLvnRefAnnName $$$CPTIXNODEANNR("COS",$$$HPTNodeLvnRef,"Name")
#define HPTNodeLvnRefAnnLvnType $$$CPTIXNODEANNR("COS",$$$HPTNodeLvnRef,"LvnType")
#define HPTNodeLvnRefChiSubscripts $$$CPTIXNODECHILDR("COS",$$$HPTNodeLvnRef,"Subscripts")
 
#define HPTNodeMacroArg $$$CPTIXNODER("COS","MacroArg")
#define HPTNodeMacroArgAnnText $$$CPTIXNODEANNR("COS",$$$HPTNodeMacroArg,"Text")
 
#define HPTNodeMacroCall $$$CPTIXNODER("COS","MacroCall")
#define HPTNodeMacroCallAnnMacroName $$$CPTIXNODEANNR("COS",$$$HPTNodeMacroCall,"MacroName")
#define HPTNodeMacroCallChiMacroArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeMacroCall,"MacroArguments")
 
#define HPTNodeMacroFormal $$$CPTIXNODER("COS","MacroFormal")
#define HPTNodeMacroFormalAnnName $$$CPTIXNODEANNR("COS",$$$HPTNodeMacroFormal,"Name")
 
#define HPTNodeMemberRef $$$CPTIXNODER("COS","MemberRef")
#define HPTNodeMemberRefAnnMemberName $$$CPTIXNODEANNR("COS",$$$HPTNodeMemberRef,"MemberName")
#define HPTNodeMemberRefAnnMemberType $$$CPTIXNODEANNR("COS",$$$HPTNodeMemberRef,"MemberType")
#define HPTNodeMemberRefChiActualParameters $$$CPTIXNODECHILDR("COS",$$$HPTNodeMemberRef,"ActualParameters")
 
#define HPTNodeMissing $$$CPTIXNODER("COS","Missing")
 
#define HPTNodeMonOpExpression $$$CPTIXNODER("COS","MonOpExpression")
#define HPTNodeMonOpExpressionAnnMonOp $$$CPTIXNODEANNR("COS",$$$HPTNodeMonOpExpression,"MonOp")
#define HPTNodeMonOpExpressionChiExpr $$$CPTIXNODECHILDR("COS",$$$HPTNodeMonOpExpression,"Expr")
 
#define HPTNodeObjectRef $$$CPTIXNODER("COS","ObjectRef")
#define HPTNodeObjectRefChiObjectRefBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeObjectRef,"ObjectRefBase")
#define HPTNodeObjectRefChiListMemberRefs $$$CPTIXNODECHILDR("COS",$$$HPTNodeObjectRef,"ListMemberRefs")
 
#define HPTNodeOffset $$$CPTIXNODER("COS","Offset")
#define HPTNodeOffsetAnnStar $$$CPTIXNODEANNR("COS",$$$HPTNodeOffset,"Star")
#define HPTNodeOffsetAnnPlusMinus $$$CPTIXNODEANNR("COS",$$$HPTNodeOffset,"PlusMinus")
#define HPTNodeOffsetChiExpression $$$CPTIXNODECHILDR("COS",$$$HPTNodeOffset,"Expression")
 
#define HPTNodeOmitted $$$CPTIXNODER("COS","Omitted")
 
#define HPTNodePPClass $$$CPTIXNODER("COS","PPClass")
#define HPTNodePPClassAnnClassKeywordName $$$CPTIXNODEANNR("COS",$$$HPTNodePPClass,"ClassKeywordName")
#define HPTNodePPClassChiListClassNameComponents $$$CPTIXNODECHILDR("COS",$$$HPTNodePPClass,"ListClassNameComponents")
 
#define HPTNodePPDefine $$$CPTIXNODER("COS","PPDefine")
#define HPTNodePPDefineAnnDefineName $$$CPTIXNODEANNR("COS",$$$HPTNodePPDefine,"DefineName")
#define HPTNodePPDefineAnnMacroName $$$CPTIXNODEANNR("COS",$$$HPTNodePPDefine,"MacroName")
#define HPTNodePPDefineAnnMacroDefinition $$$CPTIXNODEANNR("COS",$$$HPTNodePPDefine,"MacroDefinition")
#define HPTNodePPDefineAnnMacroComments $$$CPTIXNODEANNR("COS",$$$HPTNodePPDefine,"MacroComments")
#define HPTNodePPDefineChiListMacroFormals $$$CPTIXNODECHILDR("COS",$$$HPTNodePPDefine,"ListMacroFormals")
 
#define HPTNodePPDim $$$CPTIXNODER("COS","PPDim")
#define HPTNodePPDimAnnDimName $$$CPTIXNODEANNR("COS",$$$HPTNodePPDim,"DimName")
#define HPTNodePPDimChiListLvns $$$CPTIXNODECHILDR("COS",$$$HPTNodePPDim,"ListLvns")
#define HPTNodePPDimChiAs $$$CPTIXNODECHILDR("COS",$$$HPTNodePPDim,"As")
#define HPTNodePPDimChiAssign $$$CPTIXNODECHILDR("COS",$$$HPTNodePPDim,"Assign")
 
#define HPTNodePPDimAs $$$CPTIXNODER("COS","PPDimAs")
#define HPTNodePPDimAsAnnAsName $$$CPTIXNODEANNR("COS",$$$HPTNodePPDimAs,"AsName")
#define HPTNodePPDimAsAnnCollectionTypeName $$$CPTIXNODEANNR("COS",$$$HPTNodePPDimAs,"CollectionTypeName")
#define HPTNodePPDimAsAnnOfName $$$CPTIXNODEANNR("COS",$$$HPTNodePPDimAs,"OfName")
#define HPTNodePPDimAsAnnCollectionType $$$CPTIXNODEANNR("COS",$$$HPTNodePPDimAs,"CollectionType")
#define HPTNodePPDimAsChiClass $$$CPTIXNODECHILDR("COS",$$$HPTNodePPDimAs,"Class")
 
#define HPTNodePPDimAssign $$$CPTIXNODER("COS","PPDimAssign")
#define HPTNodePPDimAssignChiExpression $$$CPTIXNODECHILDR("COS",$$$HPTNodePPDimAssign,"Expression")
 
#define HPTNodePPFuncSUPER $$$CPTIXNODER("COS","PPFuncSUPER")
#define HPTNodePPFuncSUPERAnnSuperKeywordName $$$CPTIXNODEANNR("COS",$$$HPTNodePPFuncSUPER,"SuperKeywordName")
#define HPTNodePPFuncSUPERChiActualParameters $$$CPTIXNODECHILDR("COS",$$$HPTNodePPFuncSUPER,"ActualParameters")
 
#define HPTNodeParenExpr $$$CPTIXNODER("COS","ParenExpr")
#define HPTNodeParenExprChiExpr $$$CPTIXNODECHILDR("COS",$$$HPTNodeParenExpr,"Expr")
 
#define HPTNodeParenObjectRefBase $$$CPTIXNODER("COS","ParenObjectRefBase")
#define HPTNodeParenObjectRefBaseChiObjectRefBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeParenObjectRefBase,"ObjectRefBase")
 
#define HPTNodePlainBlock $$$CPTIXNODER("COS","PlainBlock")
 
#define HPTNodePlainLine $$$CPTIXNODER("COS","PlainLine")
#define HPTNodePlainLineAnnLabel $$$CPTIXNODEANNR("COS",$$$HPTNodePlainLine,"Label")
#define HPTNodePlainLineChiListFormals $$$CPTIXNODECHILDR("COS",$$$HPTNodePlainLine,"ListFormals")
#define HPTNodePlainLineChiBody $$$CPTIXNODECHILDR("COS",$$$HPTNodePlainLine,"Body")
 
#define HPTNodeRawLine $$$CPTIXNODER("COS","RawLine")
#define HPTNodeRawLineAnnLineText $$$CPTIXNODEANNR("COS",$$$HPTNodeRawLine,"LineText")
 
#define HPTNodeSQLField $$$CPTIXNODER("COS","SQLField")
#define HPTNodeSQLFieldAnnFieldName $$$CPTIXNODEANNR("COS",$$$HPTNodeSQLField,"FieldName")
#define HPTNodeSQLFieldAnnStar $$$CPTIXNODEANNR("COS",$$$HPTNodeSQLField,"Star")
#define HPTNodeSQLFieldAnnTriggerQualifier $$$CPTIXNODEANNR("COS",$$$HPTNodeSQLField,"TriggerQualifier")
 
#define HPTNodeSubscripts $$$CPTIXNODER("COS","Subscripts")
#define HPTNodeSubscriptsChiListExpressions $$$CPTIXNODECHILDR("COS",$$$HPTNodeSubscripts,"ListExpressions")
 
#define HPTNodeSystemFunCASE $$$CPTIXNODER("COS","SystemFunCASE")
#define HPTNodeSystemFunCASEAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunCASE,"FunName")
#define HPTNodeSystemFunCASEChiBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunCASE,"Base")
#define HPTNodeSystemFunCASEChiItems $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunCASE,"Items")
 
#define HPTNodeSystemFunCASEItem $$$CPTIXNODER("COS","SystemFunCASEItem")
#define HPTNodeSystemFunCASEItemChiTest $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunCASEItem,"Test")
#define HPTNodeSystemFunCASEItemChiResult $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunCASEItem,"Result")
 
#define HPTNodeSystemFunDATA $$$CPTIXNODER("COS","SystemFunDATA")
#define HPTNodeSystemFunDATAAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunDATA,"FunName")
#define HPTNodeSystemFunDATAChiReference $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunDATA,"Reference")
#define HPTNodeSystemFunDATAChiData $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunDATA,"Data")
 
#define HPTNodeSystemFunEXTRACT $$$CPTIXNODER("COS","SystemFunEXTRACT")
#define HPTNodeSystemFunEXTRACTAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunEXTRACT,"FunName")
#define HPTNodeSystemFunEXTRACTChiBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunEXTRACT,"Base")
#define HPTNodeSystemFunEXTRACTChiStartCol $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunEXTRACT,"StartCol")
#define HPTNodeSystemFunEXTRACTChiEndCol $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunEXTRACT,"EndCol")
 
#define HPTNodeSystemFunGET $$$CPTIXNODER("COS","SystemFunGET")
#define HPTNodeSystemFunGETAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunGET,"FunName")
#define HPTNodeSystemFunGETChiReference $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunGET,"Reference")
#define HPTNodeSystemFunGETChiDefault $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunGET,"Default")
 
#define HPTNodeSystemFunGeneral $$$CPTIXNODER("COS","SystemFunGeneral")
#define HPTNodeSystemFunGeneralAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunGeneral,"FunName")
#define HPTNodeSystemFunGeneralChiArguments $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunGeneral,"Arguments")
 
#define HPTNodeSystemFunINCREMENT $$$CPTIXNODER("COS","SystemFunINCREMENT")
#define HPTNodeSystemFunINCREMENTAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunINCREMENT,"FunName")
#define HPTNodeSystemFunINCREMENTChiReference $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunINCREMENT,"Reference")
#define HPTNodeSystemFunINCREMENTChiIncrement $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunINCREMENT,"Increment")
 
#define HPTNodeSystemFunLIST $$$CPTIXNODER("COS","SystemFunLIST")
#define HPTNodeSystemFunLISTAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunLIST,"FunName")
#define HPTNodeSystemFunLISTChiBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLIST,"Base")
#define HPTNodeSystemFunLISTChiStartIndex $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLIST,"StartIndex")
#define HPTNodeSystemFunLISTChiEndIndex $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLIST,"EndIndex")
 
#define HPTNodeSystemFunLISTGET $$$CPTIXNODER("COS","SystemFunLISTGET")
#define HPTNodeSystemFunLISTGETAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunLISTGET,"FunName")
#define HPTNodeSystemFunLISTGETChiBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTGET,"Base")
#define HPTNodeSystemFunLISTGETChiIndex $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTGET,"Index")
#define HPTNodeSystemFunLISTGETChiDefault $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTGET,"Default")
 
#define HPTNodeSystemFunLISTUPDATE $$$CPTIXNODER("COS","SystemFunLISTUPDATE")
#define HPTNodeSystemFunLISTUPDATEAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunLISTUPDATE,"FunName")
#define HPTNodeSystemFunLISTUPDATEChiArg1 $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTUPDATE,"Arg1")
#define HPTNodeSystemFunLISTUPDATEChiArg2 $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTUPDATE,"Arg2")
#define HPTNodeSystemFunLISTUPDATEChiAssignList $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTUPDATE,"AssignList")
 
#define HPTNodeSystemFunLISTUPDATEAssign $$$CPTIXNODER("COS","SystemFunLISTUPDATEAssign")
#define HPTNodeSystemFunLISTUPDATEAssignChiCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTUPDATEAssign,"Condition")
#define HPTNodeSystemFunLISTUPDATEAssignChiNewValue $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunLISTUPDATEAssign,"NewValue")
 
#define HPTNodeSystemFunORDER $$$CPTIXNODER("COS","SystemFunORDER")
#define HPTNodeSystemFunORDERAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunORDER,"FunName")
#define HPTNodeSystemFunORDERChiReference $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunORDER,"Reference")
#define HPTNodeSystemFunORDERChiDirection $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunORDER,"Direction")
#define HPTNodeSystemFunORDERChiData $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunORDER,"Data")
 
#define HPTNodeSystemFunPIECE $$$CPTIXNODER("COS","SystemFunPIECE")
#define HPTNodeSystemFunPIECEAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunPIECE,"FunName")
#define HPTNodeSystemFunPIECEChiBase $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunPIECE,"Base")
#define HPTNodeSystemFunPIECEChiDelimiter $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunPIECE,"Delimiter")
#define HPTNodeSystemFunPIECEChiStartIndex $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunPIECE,"StartIndex")
#define HPTNodeSystemFunPIECEChiEndIndex $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunPIECE,"EndIndex")
 
#define HPTNodeSystemFunSELECT $$$CPTIXNODER("COS","SystemFunSELECT")
#define HPTNodeSystemFunSELECTAnnFunName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemFunSELECT,"FunName")
 
#define HPTNodeSystemFunSELECTItem $$$CPTIXNODER("COS","SystemFunSELECTItem")
#define HPTNodeSystemFunSELECTItemChiCondition $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunSELECTItem,"Condition")
#define HPTNodeSystemFunSELECTItemChiResult $$$CPTIXNODECHILDR("COS",$$$HPTNodeSystemFunSELECTItem,"Result")
 
#define HPTNodeSystemVar $$$CPTIXNODER("COS","SystemVar")
#define HPTNodeSystemVarAnnVarName $$$CPTIXNODEANNR("COS",$$$HPTNodeSystemVar,"VarName")
 
#define HPTNodeUnknownPreProcessorCommand $$$CPTIXNODER("COS","UnknownPreProcessorCommand")
#define HPTNodeUnknownPreProcessorCommandAnnSnarf $$$CPTIXNODEANNR("COS",$$$HPTNodeUnknownPreProcessorCommand,"Snarf")
 
#define HPTEnumCollectionTypeNone $$$CPTIXENUMVALUER("COS","CollectionType","None")
#define HPTEnumCollectionTypeList $$$CPTIXENUMVALUER("COS","CollectionType","List")
#define HPTEnumCollectionTypeArray $$$CPTIXENUMVALUER("COS","CollectionType","Array")
 
#define HPTEnumLvnTypeNone $$$CPTIXENUMVALUER("COS","LvnType","None")
#define HPTEnumLvnTypePrivate $$$CPTIXENUMVALUER("COS","LvnType","Private")
#define HPTEnumLvnTypePublic $$$CPTIXENUMVALUER("COS","LvnType","Public")
#define HPTEnumLvnTypeParameter $$$CPTIXENUMVALUER("COS","LvnType","Parameter")
 
#define HPTEnumMemberTypeNone $$$CPTIXENUMVALUER("COS","MemberType","None")
#define HPTEnumMemberTypeMethod $$$CPTIXENUMVALUER("COS","MemberType","Method")
#define HPTEnumMemberTypeProperty $$$CPTIXENUMVALUER("COS","MemberType","Property")
#define HPTEnumMemberTypeUnknown $$$CPTIXENUMVALUER("COS","MemberType","Unknown")
#define HPTEnumMemberTypeParameter $$$CPTIXENUMVALUER("COS","MemberType","Parameter")
 

#else

#define HPTNodeActualParameters 38
 
#define HPTNodeArgument 26
#define HPTNodeArgumentAnnSnarf 1
 
#define HPTNodeBraceBlock 21
 
#define HPTNodeByRefLvn 39
#define HPTNodeByRefLvnChiLvnRef 1
 
#define HPTNodeClassNameComponent 36
#define HPTNodeClassNameComponentAnnName 1
 
#define HPTNodeCommandDO 44
#define HPTNodeCommandDOAnnCommandName 1
#define HPTNodeCommandDOChiPostCondition 1
#define HPTNodeCommandDOChiArguments 2
 
#define HPTNodeCommandDOArguments 45
 
#define HPTNodeCommandDOBlock 24
#define HPTNodeCommandDOBlockAnnCommandName 1
#define HPTNodeCommandDOBlockChiBraceBlock 1
#define HPTNodeCommandDOBlockChiWhilePart 2
 
#define HPTNodeCommandDOBlockWhile 47
#define HPTNodeCommandDOBlockWhileAnnCommandName 1
#define HPTNodeCommandDOBlockWhileChiConditions 1
 
#define HPTNodeCommandDOTagArgument 99
#define HPTNodeCommandDOTagArgumentAnnRoutineRef 1
#define HPTNodeCommandDOTagArgumentChiArguments 1
 
#define HPTNodeCommandELSELine 100
#define HPTNodeCommandELSELineAnnCommandName 1
#define HPTNodeCommandELSELineChiRestOfLine 1
 
#define HPTNodeCommandFORArguments 78
#define HPTNodeCommandFORArgumentsChiVar 1
#define HPTNodeCommandFORArgumentsChiRhsList 2
 
#define HPTNodeCommandFORBlock 76
#define HPTNodeCommandFORBlockAnnCommandName 1
#define HPTNodeCommandFORBlockChiImpl 1
 
#define HPTNodeCommandFORBlockImplMain 77
#define HPTNodeCommandFORBlockImplMainChiArgs 1
#define HPTNodeCommandFORBlockImplMainChiBraceBlock 2
 
#define HPTNodeCommandFORLine 79
#define HPTNodeCommandFORLineAnnCommandName 1
#define HPTNodeCommandFORLineChiImpl 1
 
#define HPTNodeCommandFORLineImplMain 82
#define HPTNodeCommandFORLineImplMainChiArgs 1
#define HPTNodeCommandFORLineImplMainChiLineBody 2
 
#define HPTNodeCommandFORRhs 81
#define HPTNodeCommandFORRhsChiFrom 1
#define HPTNodeCommandFORRhsChiIncrement 2
#define HPTNodeCommandFORRhsChiTo 3
 
#define HPTNodeCommandGeneral 4
#define HPTNodeCommandGeneralAnnCommandName 1
#define HPTNodeCommandGeneralChiPostCondition 1
#define HPTNodeCommandGeneralChiArguments 2
 
#define HPTNodeCommandGeneralArguments 6
 
#define HPTNodeCommandIFBlock 17
#define HPTNodeCommandIFBlockChiIf 1
#define HPTNodeCommandIFBlockChiListElseIf 2
#define HPTNodeCommandIFBlockChiElse 3
 
#define HPTNodeCommandIFBlockElse 19
#define HPTNodeCommandIFBlockElseAnnCommandName 1
#define HPTNodeCommandIFBlockElseChiBraceBlock 1
 
#define HPTNodeCommandIFBlockElseIf 20
#define HPTNodeCommandIFBlockElseIfAnnCommandName 1
#define HPTNodeCommandIFBlockElseIfChiConditions 1
#define HPTNodeCommandIFBlockElseIfChiBraceBlock 2
 
#define HPTNodeCommandIFBlockIf 18
#define HPTNodeCommandIFBlockIfAnnCommandName 1
#define HPTNodeCommandIFBlockIfChiConditions 1
#define HPTNodeCommandIFBlockIfChiBraceBlock 2
 
#define HPTNodeCommandIFLine 15
#define HPTNodeCommandIFLineAnnCommandName 1
#define HPTNodeCommandIFLineChiConditions 1
#define HPTNodeCommandIFLineChiRestOfLine 2
 
#define HPTNodeCommandLOCK 101
#define HPTNodeCommandLOCKAnnCommandName 1
#define HPTNodeCommandLOCKChiPostCondition 1
#define HPTNodeCommandLOCKChiArguments 2
 
#define HPTNodeCommandLOCKArgument 103
#define HPTNodeCommandLOCKArgumentAnnPrefix 1
#define HPTNodeCommandLOCKArgumentChiReference 1
#define HPTNodeCommandLOCKArgumentChiSuffix 2
#define HPTNodeCommandLOCKArgumentChiTimeout 3
 
#define HPTNodeCommandLOCKArguments 102
 
#define HPTNodeCommandSET 11
#define HPTNodeCommandSETAnnCommandName 1
#define HPTNodeCommandSETChiPostCondition 1
#define HPTNodeCommandSETChiArguments 2
 
#define HPTNodeCommandSETArgLhs 14
#define HPTNodeCommandSETArgLhsAnnIsMultiple 1
 
#define HPTNodeCommandSETArgument 13
#define HPTNodeCommandSETArgumentChiLhs 1
#define HPTNodeCommandSETArgumentChiRhs 2
 
#define HPTNodeCommandSETArguments 12
 
#define HPTNodeCommandTRYBlock 83
#define HPTNodeCommandTRYBlockAnnTryCommandName 1
#define HPTNodeCommandTRYBlockAnnCatchCommandName 2
#define HPTNodeCommandTRYBlockChiTryBlock 1
#define HPTNodeCommandTRYBlockChiCatchVar 2
#define HPTNodeCommandTRYBlockChiCatchBlock 3
 
#define HPTNodeCommandTRYBlockVar 84
#define HPTNodeCommandTRYBlockVarAnnLeftParen 1
#define HPTNodeCommandTRYBlockVarAnnRightParen 2
#define HPTNodeCommandTRYBlockVarChiLvnRef 1
 
#define HPTNodeCommandWHILEBlock 23
#define HPTNodeCommandWHILEBlockAnnCommandName 1
#define HPTNodeCommandWHILEBlockChiConditions 1
#define HPTNodeCommandWHILEBlockChiBraceBlock 2
 
#define HPTNodeCommandWRITE 65
#define HPTNodeCommandWRITEAnnCommandName 1
#define HPTNodeCommandWRITEChiPostCondition 1
#define HPTNodeCommandWRITEChiArguments 2
 
#define HPTNodeCommandWRITEArguments 66
 
#define HPTNodeDotDotBase 37
#define HPTNodeDotDotBaseChiMemberRef 1
 
#define HPTNodeEmbedding 62
#define HPTNodeEmbeddingAnnLanguage 1
#define HPTNodeEmbeddingAnnOpener 2
#define HPTNodeEmbeddingAnnBody 3
#define HPTNodeEmbeddingAnnBodyExtent 4
#define HPTNodeEmbeddingAnnCloser 5
 
#define HPTNodeEnvironment 43
#define HPTNodeEnvironmentAnnBracketsUsed 1
#define HPTNodeEnvironmentChiEnv1 1
#define HPTNodeEnvironmentChiEnv2 2
 
#define HPTNodeExpression 5
#define HPTNodeExpressionAnnDyOp 1
#define HPTNodeExpressionChiLhs 1
#define HPTNodeExpressionChiRhs 2
 
#define HPTNodeExtrinsicFunctionCall 98
#define HPTNodeExtrinsicFunctionCallAnnDollar2 1
#define HPTNodeExtrinsicFunctionCallAnnRoutineRef 2
#define HPTNodeExtrinsicFunctionCallChiArguments 1
 
#define HPTNodeFormal 8
#define HPTNodeFormalAnnAmpersand 1
#define HPTNodeFormalAnnName 2
#define HPTNodeFormalAnnScoop 3
#define HPTNodeFormalChiDefault 1
 
#define HPTNodeGvnRef 42
#define HPTNodeGvnRefAnnName 1
#define HPTNodeGvnRefChiEnvironment 1
#define HPTNodeGvnRefChiSubscripts 2
 
#define HPTNodeIOAscii 72
#define HPTNodeIOAsciiChiAscii 1
 
#define HPTNodeIOFormat 68
 
#define HPTNodeIOFormatFormfeed 70
 
#define HPTNodeIOFormatFormfeed2 73
 
#define HPTNodeIOFormatLinefeed 69
 
#define HPTNodeIOFormatTab 71
#define HPTNodeIOFormatTabChiPosition 1
 
#define HPTNodeIOMnemonic 67
#define HPTNodeIOMnemonicAnnMnemonicName 1
#define HPTNodeIOMnemonicChiActualParameters 1
 
#define HPTNodeIndirection 104
#define HPTNodeIndirectionChiExpression 1
#define HPTNodeIndirectionChiSubscripts 2
 
#define HPTNodeLineBody 3
#define HPTNodeLineBodyChiListLineElements 1
 
#define HPTNodeListClassNameComponents 41
 
#define HPTNodeListCommandFORRhs 80
 
#define HPTNodeListCommandIFBlockElseIf 22
 
#define HPTNodeListExpressions 25
 
#define HPTNodeListFormals 7
 
#define HPTNodeListLineElements 16
 
#define HPTNodeListLvns 58
 
#define HPTNodeListMacroArgs 74
 
#define HPTNodeListMacroFormals 92
 
#define HPTNodeListMemberRefs 33
 
#define HPTNodeListSystemFunCASEItems 54
 
#define HPTNodeListSystemFunLISTUPDATEAssigns 106
 
#define HPTNodeLiteralNumber 28
#define HPTNodeLiteralNumberAnnValue 1
 
#define HPTNodeLiteralString 27
#define HPTNodeLiteralStringAnnValue 1
 
#define HPTNodeLvn 57
#define HPTNodeLvnAnnName 1
 
#define HPTNodeLvnRef 9
#define HPTNodeLvnRefAnnName 1
#define HPTNodeLvnRefAnnLvnType 2
#define HPTNodeLvnRefChiSubscripts 1
 
#define HPTNodeMacroArg 75
#define HPTNodeMacroArgAnnText 1
 
#define HPTNodeMacroCall 63
#define HPTNodeMacroCallAnnMacroName 1
#define HPTNodeMacroCallChiMacroArguments 1
 
#define HPTNodeMacroFormal 93
#define HPTNodeMacroFormalAnnName 1
 
#define HPTNodeMemberRef 34
#define HPTNodeMemberRefAnnMemberName 1
#define HPTNodeMemberRefAnnMemberType 2
#define HPTNodeMemberRefChiActualParameters 1
 
#define HPTNodeMissing 90
 
#define HPTNodeMonOpExpression 86
#define HPTNodeMonOpExpressionAnnMonOp 1
#define HPTNodeMonOpExpressionChiExpr 1
 
#define HPTNodeObjectRef 32
#define HPTNodeObjectRefChiObjectRefBase 1
#define HPTNodeObjectRefChiListMemberRefs 2
 
#define HPTNodeOffset 89
#define HPTNodeOffsetAnnStar 1
#define HPTNodeOffsetAnnPlusMinus 2
#define HPTNodeOffsetChiExpression 1
 
#define HPTNodeOmitted 40
 
#define HPTNodePPClass 35
#define HPTNodePPClassAnnClassKeywordName 1
#define HPTNodePPClassChiListClassNameComponents 1
 
#define HPTNodePPDefine 91
#define HPTNodePPDefineAnnDefineName 1
#define HPTNodePPDefineAnnMacroName 2
#define HPTNodePPDefineAnnMacroDefinition 3
#define HPTNodePPDefineAnnMacroComments 4
#define HPTNodePPDefineChiListMacroFormals 1
 
#define HPTNodePPDim 56
#define HPTNodePPDimAnnDimName 1
#define HPTNodePPDimChiListLvns 1
#define HPTNodePPDimChiAs 2
#define HPTNodePPDimChiAssign 3
 
#define HPTNodePPDimAs 59
#define HPTNodePPDimAsAnnAsName 1
#define HPTNodePPDimAsAnnCollectionTypeName 2
#define HPTNodePPDimAsAnnOfName 3
#define HPTNodePPDimAsAnnCollectionType 4
#define HPTNodePPDimAsChiClass 1
 
#define HPTNodePPDimAssign 60
#define HPTNodePPDimAssignChiExpression 1
 
#define HPTNodePPFuncSUPER 87
#define HPTNodePPFuncSUPERAnnSuperKeywordName 1
#define HPTNodePPFuncSUPERChiActualParameters 1
 
#define HPTNodeParenExpr 29
#define HPTNodeParenExprChiExpr 1
 
#define HPTNodeParenObjectRefBase 64
#define HPTNodeParenObjectRefBaseChiObjectRefBase 1
 
#define HPTNodePlainBlock 1
 
#define HPTNodePlainLine 2
#define HPTNodePlainLineAnnLabel 1
#define HPTNodePlainLineChiListFormals 1
#define HPTNodePlainLineChiBody 2
 
#define HPTNodeRawLine 61
#define HPTNodeRawLineAnnLineText 1
 
#define HPTNodeSQLField 97
#define HPTNodeSQLFieldAnnFieldName 1
#define HPTNodeSQLFieldAnnStar 2
#define HPTNodeSQLFieldAnnTriggerQualifier 3
 
#define HPTNodeSubscripts 31
#define HPTNodeSubscriptsChiListExpressions 1
 
#define HPTNodeSystemFunCASE 53
#define HPTNodeSystemFunCASEAnnFunName 1
#define HPTNodeSystemFunCASEChiBase 1
#define HPTNodeSystemFunCASEChiItems 2
 
#define HPTNodeSystemFunCASEItem 55
#define HPTNodeSystemFunCASEItemChiTest 1
#define HPTNodeSystemFunCASEItemChiResult 2
 
#define HPTNodeSystemFunDATA 49
#define HPTNodeSystemFunDATAAnnFunName 1
#define HPTNodeSystemFunDATAChiReference 1
#define HPTNodeSystemFunDATAChiData 2
 
#define HPTNodeSystemFunEXTRACT 88
#define HPTNodeSystemFunEXTRACTAnnFunName 1
#define HPTNodeSystemFunEXTRACTChiBase 1
#define HPTNodeSystemFunEXTRACTChiStartCol 2
#define HPTNodeSystemFunEXTRACTChiEndCol 3
 
#define HPTNodeSystemFunGET 50
#define HPTNodeSystemFunGETAnnFunName 1
#define HPTNodeSystemFunGETChiReference 1
#define HPTNodeSystemFunGETChiDefault 2
 
#define HPTNodeSystemFunGeneral 46
#define HPTNodeSystemFunGeneralAnnFunName 1
#define HPTNodeSystemFunGeneralChiArguments 1
 
#define HPTNodeSystemFunINCREMENT 85
#define HPTNodeSystemFunINCREMENTAnnFunName 1
#define HPTNodeSystemFunINCREMENTChiReference 1
#define HPTNodeSystemFunINCREMENTChiIncrement 2
 
#define HPTNodeSystemFunLIST 94
#define HPTNodeSystemFunLISTAnnFunName 1
#define HPTNodeSystemFunLISTChiBase 1
#define HPTNodeSystemFunLISTChiStartIndex 2
#define HPTNodeSystemFunLISTChiEndIndex 3
 
#define HPTNodeSystemFunLISTGET 95
#define HPTNodeSystemFunLISTGETAnnFunName 1
#define HPTNodeSystemFunLISTGETChiBase 1
#define HPTNodeSystemFunLISTGETChiIndex 2
#define HPTNodeSystemFunLISTGETChiDefault 3
 
#define HPTNodeSystemFunLISTUPDATE 105
#define HPTNodeSystemFunLISTUPDATEAnnFunName 1
#define HPTNodeSystemFunLISTUPDATEChiArg1 1
#define HPTNodeSystemFunLISTUPDATEChiArg2 2
#define HPTNodeSystemFunLISTUPDATEChiAssignList 3
 
#define HPTNodeSystemFunLISTUPDATEAssign 107
#define HPTNodeSystemFunLISTUPDATEAssignChiCondition 1
#define HPTNodeSystemFunLISTUPDATEAssignChiNewValue 2
 
#define HPTNodeSystemFunORDER 48
#define HPTNodeSystemFunORDERAnnFunName 1
#define HPTNodeSystemFunORDERChiReference 1
#define HPTNodeSystemFunORDERChiDirection 2
#define HPTNodeSystemFunORDERChiData 3
 
#define HPTNodeSystemFunPIECE 96
#define HPTNodeSystemFunPIECEAnnFunName 1
#define HPTNodeSystemFunPIECEChiBase 1
#define HPTNodeSystemFunPIECEChiDelimiter 2
#define HPTNodeSystemFunPIECEChiStartIndex 3
#define HPTNodeSystemFunPIECEChiEndIndex 4
 
#define HPTNodeSystemFunSELECT 51
#define HPTNodeSystemFunSELECTAnnFunName 1
 
#define HPTNodeSystemFunSELECTItem 52
#define HPTNodeSystemFunSELECTItemChiCondition 1
#define HPTNodeSystemFunSELECTItemChiResult 2
 
#define HPTNodeSystemVar 30
#define HPTNodeSystemVarAnnVarName 1
 
#define HPTNodeUnknownPreProcessorCommand 10
#define HPTNodeUnknownPreProcessorCommandAnnSnarf 1
 
#define HPTEnumCollectionTypeNone 0
#define HPTEnumCollectionTypeList 1
#define HPTEnumCollectionTypeArray 2
 
#define HPTEnumLvnTypeNone 0
#define HPTEnumLvnTypePrivate 1
#define HPTEnumLvnTypePublic 2
#define HPTEnumLvnTypeParameter 3
 
#define HPTEnumMemberTypeNone 0
#define HPTEnumMemberTypeMethod 1
#define HPTEnumMemberTypeProperty 2
#define HPTEnumMemberTypeUnknown 3
#define HPTEnumMemberTypeParameter 4
 

#endif
