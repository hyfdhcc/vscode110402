ROUTINE %Identity.common [Type=INC]

#define AdaptorProgramVersion			"2010.8.1"

#define IMTSourceLinkDefaults		0
#define IMTSourcePreviousLinkage	1
#define IMTSourceJoinIndex			2	
#define IMTSourceClassifiedPairs	3
#define IMTSourceSelectivity		4

#define IMTDllExt	$s(##class(%Identity.API).GetUserSetting("dllext")'="":##class(%Identity.API).GetUserSetting("dllext"),$$$isWINDOWS:"dll",$$$isUNIX:$s($zv["Mac OS X":"dylib",$zv["HP HP-UX":"sl",1:"so"),$$$isVMS:"exe",1:"dll")
 
#define IMTFnEditexSimilarity		1
#define IMTFnHammingSimilarity		2
#define IMTFnJaroSimilarity			3
#define IMTFnWinklerSimilarity		4
#define IMTFnEditSimilarity			5
#define IMTFnEditDistance			6
#define	IMTFnMetaphone				7
#define IMTFnCompareStreetAddress 	8
#define IMTFnAffineGapSimilarity    9
#define IMTDLLMAXSTRING				128
 
#define IMTAgreeWeightMarker 	"w.agree"
#define IMTDisagreeWeightMarker "w.disagree"
 
#define IMTNullNeqAny 		1
#define IMTNullEqlNull 		2
#define IMTNullEqlAny 		3
 
#define IMTReplacePctClnXPctWithXBoolean		1
#define IMTReplacePctClnADotXPctWithQmk			2
#define IMTReplacePctClnXPctWithX				3
#define IMTReplacePctClnADotTypePctWithSqlProp	4
#define IMTReplacePctClnBDotTypePctWithSqlProp	5
#define IMTReplacePctClnAorBDotXPctWithQmk		6

#define IMTLinkReasonUnknown	""
#define IMTLinkedByLinkweight	0
#define IMTLinkedByRule			1
#define IMTLinkedByControlledID	2
#define IMTLinkedByInspection	3
 
#define IMTAgreement 			"1"
#define IMTDisagreement 		"0"
#define IMTIndifference 		"-"
 
#define IMTDate120YearsAgo ($p($h,",")-43830) 
#define IMTPrecision 		7
#define IMTMaxStringLength 	8096
#define IMTMaxLinkweight 	999
#define IMTMinLinkweight 	-999
  
#define IMTDictCategoricalName 	-110
#define IMTDictCompoundName 	-101
#define IMTDictEntityAttribute 	-100
#define IMTDictFemalename 		-105
#define IMTDictGivenname 		-103
#define IMTDictMalename 		-104
#define IMTDictNickname 		-107
#define IMTDictStreetAddress 	-102
#define IMTDictSurname 			-106
#define IMTDictStatesUSA 		-114
#define IMTMedicalTerm			-150
 
#define IMTNoTuning 		0
#define IMTInheritTuning	1
#define IMTSemiAutoTuning 	2
#define IMTAutoTuning 		3
#define IMTTuneTableTuning 	4
 
#define IMTPartialAgreement		0
#define IMTSimpleAgreement		2
#; Deprecated agreement model values
#define IMTWeightedAgreement	0
#define IMTBinaryAgreement		1

#define IMTFreqAdjust(%str1,%str2,%cls,%agrWgt,%sim)	(%sim*%agrWgt*$s(%cls="":1,1:$ClassMethod(%cls,"freqAdjFactor",%str1,%str2)))

#Include %occMessages
#define IMTMsgLanguage				$s(",en,es,fr,de,"[$e($$$DefaultLanguageNode,1,2):$e($$$DefaultLanguageNode,1,2),1:"en")
#define IMTErrNoEligiblePairs 		1001
#define IMTErrUndefinedGlobalRef	1002
#define IMTErrUnknownProperty		1003
#define IMTErrRelationBNotFound		1004
#define IMTErrNoPriorLinkage		1005
#define IMTErrInvalidLinkageID		1006
#define IMTErrNoMatchingProperty	1007
#define IMTErrNullEntityID			1008
#define IMTErrNullGamma				1009
#define IMTErrMissingMissing		1010
#define IMTErrInvalidParameter		1011
#define IMTErrRequiredParameter		1012
#define IMTErrInvalidProperty		1013
#define IMTErrUnknownTable			1014
#define IMTErrPrepare				1015
#define IMTErrNext					1016
#define IMTErrInsuffPrivilege		1017

#define IMTTypeSurname				"surname"
#define IMTTypeMothersMaidenName	"mothersmaidenname"
#define IMTTypeBirthOrder			"birthorder"
#define IMTTypeGivenName			"givenname"
#define IMTTypeOtherName			"othername"
#define IMTTypeTitle				"title"
#define IMTTypeSuffixTitle			"suffixtitle"
#define IMTTypeStreetNumber			"streetnumber"
#define IMTTypeStdStreetAddress		"stdstreetaddress"
#define IMTTypeStreetName			"streetname"
#define IMTTypeAddress1				"address1"
#define IMTTypeAddress2				"address2"
#define IMTTypeHPhone				"homephone"
#define IMTTypeWPhone				"workphone"
#define IMTTypeCPhone				"mobilephone"
#define IMTTypeMPhone				"mobilephone"
#define IMTTypePhoneList			"phonelist"
#define IMTTypeDateOfBirth			"dateofbirth"
#define IMTTypeRelToHeadOfHousehold	"relationtoheadofhousehold"
#define IMTTypeMaritalStatus		"maritalstatus"
#define IMTTypeGender				"gender"
#define IMTTypeEthnicity			"ethnicity"
#define IMTTypeNationality			"nationality"
#define IMTTypeGovernmentID			"govtid"
#define IMTTypeNationalID			"nationalid"
#define IMTTypeStateID				"stateid"
#define IMTTypeLicenseNumber		"licensenumber"
#define IMTTypeCity					"city"
#define IMTTypeCityOfBirth			"cityofbirth"
#define IMTTypePostcode				"postcode"
#define IMTTypeState				"state"
#define IMTTypeEmail				"email"
#define IMTTypeOccupation			"occupation"
#define IMTTypeURL					"url"
#define IMTTypeEntityName			"entityname"
#define IMTTypeBoxIndicator			"boxindicator"
#define IMTTypeRuralRouteIndicator	"ruralrouteindicator"
#define IMTTypeWithinStructureDes	"withinstructuredes"
#define IMTTypeWithinStructureInd	"withinstructureind"
#define IMTTypeStreetNamePrefixDir	"streetnameprefixdir"
#define IMTTypeStringDateODBC		"stringdateodbc"
#define IMTTypeGenericString		"string"
#define IMTTypeGenericDate			"date"
#define IMTTypeGenericInteger		"integer"
#define IMTTypeGenericNumber		"number"
#define IMTTypeLastVisitDateTime	"lastvisitdatetime"
#define IMTTypeLastUpdateFacility	"lastupdatefacility"

#define IMTCategoryPossibleTwins			-4
#define IMTCategoryDiffBirthday 			-3
#define IMTCategoryNonHouseholdNonLinks		-2
#define IMTCategoryNonLinkPairs				-1
#define IMTCategoryUnknown					0
#define IMTCategoryLinkPairs				1
#define IMTCategoryCommonAddr				2
#define IMTCategoryPhonetic					4
#define IMTCategorySpecialNames				5
#define IMTCategoryContradictory			6
#define IMTCategoryAmbiguous				7
#define IMTCategoryPossibleNickname			8
#define IMTCategoryMissingName				9

#define IMTEntityID			1
#define	IMTRowID			2
#define	IMTLinkweight		3
#define IMTAgreePat			4

#define IdentityMgrActionDisabled 	-1
#define IdentityMgrActionNoChange 	0
#define IdentityMgrActionAdded    	1
#define IdentityMgrActionUpdated  	2
#define IdentityMgrActionDeleted  	3
#define IdentityMgrActionMerged   	4
#define IdentityMgrActionLinked		5
#define IdentityMgrActionSplit   	6
#define IdentityMgrActionAddedDup   7

#define IdentityMgrRetryIgnore			0
#define IdentityMgrRetryNone			1
#define IdentityMgrRetryYes				2
#define IdentityMgrRetrySuspendMsg		3
#define IdentityMgrRetrySuspendAdapter	4

#define IMTProgramVersion			"2010.8.1"
#define IMTAppID					8900
#define IMTStandAloneMode			1
#define IMTTerminalMode 			0

#define IMTDictionaryOffset 		0
#define IMTPhoneticAlgorithm $$metaphone^%Identity.cmp
#define IMTPhoneticAlgorithmQ "$$metaphone^%Identity.cmp"


#def1arg IMTGetUserSetting(%args) ##class(%Identity.API).GetUserSetting(%args)
#def1arg IMTSetUserSetting(%args) Do ##class(%Identity.API).SetUserSetting(%args)
#define IMTDefaultLinkageID ##class(%Identity.API).GetDefaultLinkageID()
