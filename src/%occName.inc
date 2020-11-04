ROUTINE %occName [Type=INC]
#;
#; some of the extrinsic functions in %occName.MAC are moved here as macros
#;
#define nameBinaryStreamClassNameGet                            $$$envBinaryStreamClassNameGet
#define nameCharacterStreamClassNameGet                         $$$envCharacterStreamClassNameGet
#define nameDefaultDataTypeClassNameGet                         $$$envDefaultDataTypeClassNameGet
#define nameDefaultOHandleClassNameGet                          $$$envDefaultOHandleClassNameGet
#define nameDefaultPropertyClassNameGet                         "%Library.CacheLiteral"
#define nameDefaultObjectClassNameGet                           "%Library.CacheObject"
#define nameDefaultCollectionClassNameGet                       "%Library.CacheCollection"
#define nameDefaultRelationshipClassNameGet                     "%Library.CacheRelationship"
#define nameDefaultRegObjClassNameGet                           "%Library.CacheRegObj"
#define nameDefaultSerialStateClassNameGet                      $$$envDefaultSerialStateClassNameGet
#define nameDefaultStreamPropertyClassNameGet                   $$$envDefaultStreamPropertyClassNameGet
#define nameDefaultStorageClassNameGet                          $$$envDefaultStorageClassNameGet
#define nameDefaultStorageNameGet                               "Default"
#define nameDefaultStreamClassNameGet                           "%Library.Stream"
#define nameIndexSuperClassNameGet                              "%Library.CacheIndex"
	
#define nameClassRoutineBaseGet(%class)                         $zutil(135,23,%class)
#define nameClassRoutineNameGet(%class,%count)                  $zutil(135,23,%class)_"."_(+%count)
#define nameMemberMethodName(%member,%method)                   %member_$translate(%method,"%")
#define nameMethodActuallistGet(%classmethod)                   $select(%classmethod:"($Xargs)",1:"($Xinst,$Xargs)")
#define nameMethodGeneratorFormallistGet                        "()"
#define nameMethodObjectGeneratorFormallistGet                  "(%class,%code,%method,%compiledclass,%compiledmethod,%parameter)"
#define nameTriggerObjectGeneratorFormallistGet                  "(%class,%code,%trigger,%compiledclass,%compiledtrigger,%parameter)"
#define nameMethodGeneratorLabelNameGet(%method)                %method
#define nameMethodGeneratorRtnNameGet(%class,%count)            $zutil(135,23,%class)_".G"_(+%count)
#define nameTableRoutinePrefixGet(%class)                       $zutil(135,23,%class)_".T"
#define namePropertyMethodActuallistGet(%classmethod,%nocontext)        $select(%classmethod:"($Xargs)",1:"($Xinst,$Xargs)")
	
#define nameIsNameInvalid(%name)                                '$zname(%name)

#define cCLASSCLASSTYPESYSTEM                                   "donotuse"
#define cMETHLANGUAGECPP                                        "cpp"
#define getClassType(%class)                                    $s($d($$$comClassKeyRaw(%class,$$$cCLASSclasstype))#2:^($$$cCLASSclasstype),1:$$ClassType^%occName(%class))
#define classIsDataType(%class)									($$$getClassType(%class)=$$$cCLASSCLASSTYPEDATATYPE)
#define classIsPersistent(%class)								($$$getClassType(%class)=$$$cCLASSCLASSTYPEPERSISTENT)
#define classIsSerial(%class)									($$$getClassType(%class)=$$$cCLASSCLASSTYPESERIAL)
#define classIsStream(%class)									($$$getClassType(%class)=$$$cCLASSCLASSTYPESTREAM)
#define classIsView(%class)                                     ($$$getClassType(%class)=$$$cCLASSCLASSTYPEVIEW)
#define classIsSystem(%class)                                   ($$$getClassType(%class)=$$$cCLASSCLASSTYPESYSTEM)

#define setIvarHasRefSlot(%val,%class,%ivar)					$$$comMemberKeyGetLvar(%val,%class,$$$cCLASSproperty,%ivar,$$$cPROPruntimetype) Set %val='$$$classIsDataType(%val)
 
#define NormalizeClassnameByDef(%classes,%origin)               If %classes[","||(%classes'["."),%classes'="" { If $extract(%classes)="%",%classes'["," { Set %classes="%Library."_$extract(%classes,2,*),sc=$$$OK } Else { Set sc=$$NormalizeClassnameByDef^%occName(.%classes,%classes,%origin) } } Else { Set sc=$$$OK }
#define NormalizeClassnameByDefCache(%classes,%origin,%cache)   If %classes[","||(%classes'["."),%classes'="" { If $extract(%classes)="%",%classes'["," { Set %classes="%Library."_$extract(%classes,2,*),sc=$$$OK } Else { Set sc=$$NormalizeClassnameByDef^%occName(.%classes,%classes,%origin,.%cache) } } Else { Set sc=$$$OK }
#define NormalizeClassnameByCom(%classes,%origin)               If %classes[","||(%classes'["."),%classes'="" { If $extract(%classes)="%",%classes'["," { Set %classes="%Library."_$extract(%classes,2,*),sc=$$$OK } Else { Set sc=$$NormalizeClassnameByCom^%occName(.%classes,%classes,%origin) } } Else { Set sc=$$$OK }
#define NormalizeClassnameByImports(%classes,%import)  If %classes[","||(%classes'["."),%classes'="" { If $extract(%classes)="%",%classes'["," { Set %classes="%Library."_$extract(%classes,2,*),sc=$$$OK } Else { Set sc=$$NormalizeClassnameByImports^%occName(.%classes,%classes,%import) } } Else { Set sc=$$$OK }
