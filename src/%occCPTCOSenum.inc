ROUTINE %occCPTCOSenum [Type=INC]
 
#;
#; GENERATED USING extractenuminc.pl - DO NOT EDIT
#;
 
#; VarKind
#define CPTCOSEVarKindzNone 0
#define CPTCOSEVarKindzUnknown 1
#define CPTCOSEVarKindzPrivate 2
#define CPTCOSEVarKindzPublic 3
#define CPTCOSEVarKindzParameter 4
#define CPTCOSEVarKindzMacro 5
#define CPTCOSEVarKind(%index) $LG($LB("None","Unknown","Private","Public","Parameter","Macro"),%index+1,"?index="_%index)
 
#; ValueContext
#define CPTCOSEValueContextzNeutral 1
#define CPTCOSEValueContextzRead 2
#define CPTCOSEValueContextzWrite 3
#define CPTCOSEValueContextzKill 4
#define CPTCOSEValueContextzAny 5
#define CPTCOSEValueContext(%index) $LG($LB("None","Neutral","Read","Write","Kill","Any"),%index+1,"?index="_%index)
 
#; MemberType
#define CPTCOSEMemberTypezMemberMethod 1
#define CPTCOSEMemberTypezMemberSProperty 2
#define CPTCOSEMemberTypezMemberMPropertyOrMethod 3
#define CPTCOSEMemberTypezMemberMProperty 4
#define CPTCOSEMemberType(%index) $LG($LB("None","MemberMethod","MemberSProperty","MemberMPropertyOrMethod","MemberMProperty"),%index+1,"?index="_%index)
 
#; PubPriEnum
#define CPTCOSEPubPriEnumzNone 0
#define CPTCOSEPubPriEnumzNeither 1
#define CPTCOSEPubPriEnumzPublic 2
#define CPTCOSEPubPriEnumzPrivate 3
#define CPTCOSEPubPriEnum(%index) $LG($LB("None","Neither","Public","Private"),%index+1,"?index="_%index)
 
 