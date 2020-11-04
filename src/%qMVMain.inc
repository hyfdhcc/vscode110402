ROUTINE %qMVMain [Type=INC]
#IF 0   ;------------------------------------------------------------------------------
 ; Description:   %qMVMain: Main Multi-Value Conversion Include File
 ; Author:        Michael R. Pantaleo
 ; Copywrite:     InterSystems Corporation
 ; Date Started:  24 February 2003
 ; Maintenance History: [ XXXnnn (DD MMM YYYY) - Description ]
 ;
 ;LFT1320 11/02/04 Laura Tillem, %SYS.GLO
 ; SJ1552  7/14/04 Scott Jones, cleanup, MVQuery name change
 ;    MRP*** (24 February 2003) - Main Multi-Value Conversion Include File...
#ENDIF  ;------------------------------------------------------------------------------        
 
#INCLUDE %qMVCopyright
         
 ;---------------------------------------------------------------------
 ;                   General Multi-Purpose Macros
 ;---------------------------------------------------------------------
 
#DEFINE invalidEntryPoint x "**THIS IS NOT A VALID ENTRY POINT**" QUIT
#DEFINE abort x "**ABORT**"
#DEFINE forceAbort(%type) x "***"_%type_"***"
#DEFINE CRLF $c(13,10)        
 
#DEFINE UserInterface %qMVui
#DEFINE UserInterfaceQuoted "%qMVui"
#DEFINE getUserInterface $g($$$UserInterface)
#DEFINE setUserInterface(%val) s $$$UserInterface=%val
#DEFINE WebUI ($$$getUserInterface="web")
 
#DEFINE rtnName $zn
#DEFINE SystemDirectory $$defdir^%SYS.GLO("%SYS")
#DEFINE clearScreen w #
#DEFINE TimeStamp(%dt) $zdt(%dt,2,1)
#DEFINE INCREMENT(%var) s %var=$G(%var)+1
#DEFINE INCREMENTFx(%var) $INCREMENT(%var)
#DEFINE reverse(%string) $re(%string)
 
#DEFINE UPPER(%string) $ZCVT(%string,"U")
#DEFINE LOWER(%string) $ZCVT(%string,"L")
 
 ;---------------------------------------------------------------------
 ;                   Vendor Specific Macros
 ;---------------------------------------------------------------------
 
#IF ",,UniData,"[(","_$g(%MVVendor)_",")  ; --- UniData Specific Macros [DEFAULT] ---
 
#DEFINE recordDelim $c(255)
#DEFINE attributeDelim $c(254)
#DEFINE valueDelim $c(253)
#DEFINE subvalueDelim $c(252)
#DEFINE textDelim $c(251)
#DEFINE emptyDelim $c(0)
 
#ELSEIF $g(%MVVendor)="PICK" ; --- PICK Specific Macros ---
 
#DEFINE recordDelim ""
#DEFINE attributeDelim $c(228)
#DEFINE valueDelim $c(253)
#DEFINE subvalueDelim $c(252)
#DEFINE textDelim ""
#DEFINE emptyDelim $c(0)
 
#ENDIF
 
 ;---------------------------------------------------------------------
 ;                   Conversion Global References
 ;---------------------------------------------------------------------
 
#DEFINE defaultPackage ^qMVconv("default","package")
#DEFINE getDefaultPackage $g($$$defaultPackage)
#DEFINE setDefaultPackage(%packageName) s $$$defaultPackage=%packageName
 
#DEFINE normalizeCharRef(%char) ^qMVconv("normalize",%char)
#DEFINE getNormalizeChar(%char) $g($$$normalizeCharRef(%char))
#DEFINE setNormalizeChar(%char,%normChar) s $$$normalizeCharRef(%char)=%normChar
 
#DEFINE MVDictionaryRef(%fileName) ^qMVconv("dict",%fileName)
#DEFINE removeMVDictionary(%fileName) k $$$MVDictionaryRef(%fileName)
#DEFINE MVDictionaryFileRef(%fileName) ^qMVconv("dict",%fileName,"file")
#DEFINE removeMVDictionaryFile(%fileName) k $$$MVDictionaryFileRef(%fileName)
#DEFINE MVDictionaryAttrRecRef(%fileName,%attrRecNum) ^qMVconv("dict",%fileName,"attr",%attrRecNum)
#DEFINE MVDictionaryAttrRef(%fileName,%attrRecNum,%attrNum) ^qMVconv("dict",%fileName,"attr",%attrRecNum,%attrNum)
#DEFINE getMVDictionaryAttr(%fileName,%attrRecNum,%attrNum) $g($$$MVDictionaryAttrRef(%fileName,%attrRecNum,%attrNum))
 
#DEFINE MVDataRef(%fileName) ^qMVconv("data",%fileName)
#DEFINE removeMVData(%fileName) k $$$MVDataRef(%fileName)
#DEFINE MVDataRecordCountRef(%fileName) ^qMVconv("data",%fileName,"recNum")
#DEFINE getNextMVDataRecord(%fileName) $$$INCREMENTFx($$$MVDataRecordCountRef(%fileName))
#DEFINE MVDataRecordRef(%fileName,%recNum) ^qMVconv("data",%fileName,"recNum",%recNum)
#DEFINE getMVDataRecord(%fileName,%recNum) $g($$$MVDataRecordRef(%fileName,%recNum))
#DEFINE setMVDataRecord(%fileName,%recNum,%recID) s $$$MVDataRecordRef(%fileName,%recNum)=%recID
 
#DEFINE MVEmptyRecordRef(%queryID) ^qMVconv("empty",%queryID)
#DEFINE removeMVEmptyRecord(%queryID) k $$$MVEmptyRecordRef(%queryID)
#DEFINE existsMVEmptyRecord(%queryID) $d($$$MVEmptyRecordRef(%queryID))
#DEFINE MVEmptyRecordIDRef(%queryID,%recordID) ^qMVconv("empty",%queryID,%recordID)
#DEFINE removeMVEmptyRecordID(%queryID,%recordID) k $$$MVEmptyRecordIDRef(%queryID,%recordID)
#DEFINE existsMVEmptyRecordID(%queryID,%recordID) $d($$$MVEmptyRecordIDRef(%queryID,%recordID))
#DEFINE setMVEmptyRecordID(%queryID,%recordID,%value) s $$$MVEmptyRecordIDRef(%queryID,%recordID)=%value
 
#DEFINE dirFilesListRef ^qMVconv("dir-files")
#DEFINE removedirFilesList k $$$dirFilesListRef
#DEFINE dirFileRef(%fileName) ^qMVconv("dir-files",%fileName)
 
 ;---------------------------------------------------------------------
 ;                      Object Global References
 ;---------------------------------------------------------------------
 
#DEFINE classRef(%className) ^oddDEF(%className)
#DEFINE classExists(%className) $d($$$classRef(%className))
#DEFINE classInfoRef(%className,%node) ^oddDEF(%className,%node)
#DEFINE getClassInfo(%className,%node) $g($$$classInfoRef(%className,%node))
 
#DEFINE attributeRef(%className,%attributeName) ^oddDEF(%className,"a",%attributeName)
#DEFINE attributeExists(%className,%attributeName) $d($$$attributeRef(%className,%attributeName))
#DEFINE attributeInfoRef(%className,%attributeName,%node) ^oddDEF(%className,"a",%attributeName,%node)
#DEFINE getAttributeInfo(%className,%attributeName,%node) $g($$$attributeInfoRef(%className,%attributeName,%node))
#DEFINE attributeParamRef(%className,%attributeName,%paramName) ^oddDEF(%className,"a",%attributeName,"P",%paramName)
#DEFINE getAttributeParam(%className,%attributeName,%paramName) $g($$$attributeParamRef(%className,%attributeName,%paramName))
#DEFINE getAttributeMVLocation(%className,%attributeName) ($$$getAttributeInfo(%className,%attributeName,43)-2)
 
#DEFINE methodRef(%className,%methodName) ^oddDEF(%className,"m",%methodName)
#DEFINE methodExists(%className,%methodName) $d($$$methodRef(%className,%methodName))
#DEFINE methodInfoRef(%className,%methodName,%node) ^oddDEF(%className,"m",%methodName,%node)
#DEFINE getMethodInfo(%className,%methodName,%node) $g($$$methodInfoRef(%className,%methodName,%node))
 
 ;---------------------------------------------------------------------
 ;                 Lexical Analyzer Macro Variables
 ;---------------------------------------------------------------------
 
#DEFINE inputRef %MVinputRef
#DEFINE inputLineNum %MVinputLN
#DEFINE currentPointer %MVpointerC
#DEFINE previousPointer %MVpointerP
#DEFINE currentLine %MVline
#DEFINE currentToken %MVtokenC
#DEFINE currentTokenUPPER %MVtokenCU
#DEFINE previousToken %MVtokenP
#DEFINE previousTokenUPPER %MVtokenPU
#DEFINE nextToken %MVtokenN
#DEFINE nextTokenUPPER %MVtokenNU
#DEFINE nextInLine %MVinLineN
#DEFINE parserError %MVerror
#DEFINE currentWhitespace %MVwhitespaceC
#DEFINE previousWhitespace %MVwhitespaceP
#DEFINE parsingLang %MVparsingLang
#DEFINE embeddedLang %MVembeddedLang
#DEFINE inLine %MVinLine
 
#DEFINE newParserVars  n $$$currentLine,$$$currentPointer,$$$currentToken,$$$currentTokenUPPER,$$$currentWhitespace,$$$embeddedLang,$$$inLine,$$$inputLineNum,$$$inputRef,$$$nextInLine,$$$nextToken,$$$nextTokenUPPER,$$$parserError,$$$parsingLang,$$$previousToken,$$$previousTokenUPPER,$$$previousPointer,$$$previousWhitespace
 
 ;---------------------------------------------------------------------
 ;                     Lexical Analyzer Methods
 ;---------------------------------------------------------------------
 
#DEFINE parserException(%parseinfo,%error,%MVerrmsg,%errmsg,%prevpointer,%currpointer,%prevtoken,%currtoken,%fill2,%fill3) s $$$parserError="MVQuery Parsing"_$c(2)_%error_$c(2)_%MVerrmsg_$c(2)_%errmsg_$c(2)_%prevpointer_$c(2)_%currpointer_$c(2)_%prevtoken_$c(2)_%currtoken_$c(2)_$$$rtnName_$c(2)_%fill2_$c(2)_%fill3 $$$forceAbort("Parsing Error")
 
#DEFINE parserInitTAG parserInit(parsingLang,embeddedLang,inputRef,inputLineNum,pos,pend)
#DEFINE parserInit(%parsingLang,%embeddedLang,%inputRef,%inputLineNum,%pos,%pend) $$parserInit^%qMVParser(%parsingLang,%embeddedLang,%inputRef,%inputLineNum,%pos,%pend)
 
#DEFINE getNextTokenTAG getNextToken($$$parsingLang,$$$embeddedLang,$$$inputRef,$$$currentPointer,$$$previousPointer,$$$inLine,$$$currentLine,$$$currentToken,$$$currentTokenUPPER,$$$previousToken,$$$previousTokenUPPER,$$$currentWhitespace,$$$previousWhitespace,$$$parserError,qInfo,getNextToken,$$$nextToken,$$$nextTokenUPPER,$$$nextInLine)
#DEFINE getNextToken $$getNextToken^%qMVParser($$$parsingLang,$$$embeddedLang,$$$inputRef,.$$$currentPointer,.$$$previousPointer,.$$$inLine,.$$$currentLine,.$$$currentToken,.$$$currentTokenUPPER,.$$$previousToken,.$$$previousTokenUPPER,.$$$currentWhitespace,.$$$previousWhitespace,.$$$parserError,.qInfo,1,.$$$nextToken,.$$$nextTokenUPPER,.$$$nextInLine)
 
#DEFINE skipOverTokenTAG skipOverToken(token)
#DEFINE skipOverToken(%token) $$skipOverToken^%qMVParser(%token)
 
#DEFINE skipOverTokenUPPERTAG skipOverTokenUPPER(token)
#DEFINE skipOverTokenUPPER(%token) $$skipOverTokenUPPER^%qMVParser(%token)
 
#DEFINE tokenInListTAG tokenInList(token,list)
#DEFINE tokenInList(%token,%list) $$tokenInList^%qMVParser(%token,%list)
 
 ;---------------------------------------------------------------------
 ;              Query Global References, Variables & Methods
 ;---------------------------------------------------------------------
 
#DEFINE MVQueryInfo %MVQueryInfo
#DEFINE MVQueryInfoQuote "%MVQueryInfo"
 
#DEFINE MVQueryRef(%queryID) ^MultiVal.Query("queryID",%queryID)
#DEFINE removeMVQuery(%queryID) k $$$MVQueryRef(%queryID)
#DEFINE MVQueryModuleRef(%queryID) ^MultiVal.Query("queryID",%queryID,"module")
#DEFINE getNextMVQueryModule(%queryID) $$$INCREMENTFx($$$MVQueryModuleRef(%queryID))
#DEFINE MVQueryModule(%queryID,%module) ^MultiVal.Query("queryID",%queryID,"module",%module)
#DEFINE getMVQueryModule(%queryID,%module) $g($$$MVQueryModule(%queryID,%module))
#DEFINE MVQueryModuleSQL(%queryID,%module) ^MultiVal.Query("queryID",%queryID,"module",%module,"SQL")
#DEFINE MVQueryModuleInfo(%queryID,%module) ^MultiVal.Query("queryID",%queryID,"module",%module,"info")
#DEFINE getMVQueryModuleInfo(%queryID,%module,%node) $g(^MultiVal.Query("queryID",%queryID,"module",%module,"info",%node))
 
#DEFINE MVQueryReserveListRef ^MultiVal.ReserveWord("MVQuery","word")
#DEFINE removeMVQueryReserveList k $$$MVQueryReserveListRef
#DEFINE MVQueryReserveWordRef(%word) ^MultiVal.ReserveWord("MVQuery","word",%word)
#DEFINE removeMVQueryReserveWord(%word) k $$$MVQueryReserveWordRef(%word)
#DEFINE setMVQueryReserveWord(%word) s $$$MVQueryReserveWordRef(%word)=""
#DEFINE isMVQueryReserveWord(%word) $d($$$MVQueryReserveWordRef(%word))
 
#IF 1	; + 23 July 2003
#DEFINE MVQueryThrowawayListRef ^MultiVal.ReserveWord("MVQuery-Throwaway","word")
#DEFINE removeMVQueryThrowawayList k $$$MVQueryThrowawayListRef
#DEFINE MVQueryThrowawayWordRef(%word) ^MultiVal.ReserveWord("MVQuery-Throwaway","word",%word)
#DEFINE removeMVQueryThrowawayWord(%word) k $$$MVQueryThrowawayWordRef(%word)
#DEFINE setMVQueryThrowawayWord(%word) s $$$MVQueryThrowawayWordRef(%word)=""
#DEFINE isMVQueryThrowawayWord(%word) $d($$$MVQueryThrowawayWordRef(%word))
#ENDIF	; - 23 July 2003
 
#DEFINE attrExists(%listAttr,%jobID,%listNum) ##class(%MV.ACTIVELISTS).attrExists(%listAttr,%jobID,%listNum)
#DEFINE anyActiveLists(%jobID) ##class(%MV.ACTIVELISTS).anyActiveLists(%jobID)
#DEFINE getCurrentActiveList(%jobID) ##class(%MV.ACTIVELISTS).getCurrentActiveList(%jobID)
#DEFINE getLastActiveList(%jobID) ##class(%MV.ACTIVELISTS).getLastActiveList(%jobID)
#DEFINE countActiveList(%jobID,%listNum) ##class(%MV.ACTIVELISTS).countActiveList(%jobID,%listNum)
#DEFINE setCurrentActiveList(%jobID,%listNum) d ##class(%MV.ACTIVELISTS).setCurrentActiveList(%jobID,%listNum)
#DEFINE clearActiveListsByJobID(%jobID) d ##class(%MV.ACTIVELISTS).clearActiveListsByJobID(%jobID)
#DEFINE clearActiveListsByListNum(%jobID,%listNum) d ##class(%MV.ACTIVELISTS).clearActiveListsByListNum(%jobID,%listNum)
 
#DEFINE anySaveLists ##class(%MV.SAVELISTS).anyActiveLists()
#DEFINE saveListExists(%listName) ##class(%MV.SAVELISTS).saveListExists(%listName)
#DEFINE countSaveList(%listName) ##class(%MV.SAVELISTS).countSaveList(%listName)
#DEFINE setSaveListsFromActiveLists(%jobID,%listNum,%listName) d ##class(%MV.SAVELISTS).setSaveListsFromActiveLists(%jobID,%listNum,%listName)
#DEFINE setActiveListsFromSaveLists(%listName,%jobID,%listNum) d ##class(%MV.SAVELISTS).setActiveListsFromSaveLists(%listName,%jobID,%listNum)
#DEFINE clearSaveListsByListName(%listName) d ##class(%MV.SAVELISTS).clearSaveListsByListName(%listName)
 
#DEFINE setMVQueryReserveListTAG setMVQueryReserveList()
#DEFINE setMVQueryReserveList d setMVQueryReserveList^%qMVQuery()
 
#DEFINE MVQueryStmtTAG MVQueryStmt(mode,langStyle,embeddedLang,rtnName,inputRef,inputLineNum,pos,pend,endPointer)
#DEFINE MVQueryStmt(%mode,%langStyle,%embeddedLang,%rtnName,%inputRef,%inputLineNum,%pos,%pend,%endPointer) $$MVQueryStmt^%qMVQuery(%mode,%langStyle,%embeddedLang,%rtnName,%inputRef,%inputLineNum,%pos,%pend,%endPointer)
 
#DEFINE MVQueryCommandTAG MVQueryCommand(mode,langStyle,embeddedLang,rtnName,inputRef,inputLineNum,pos,pend,endPointer)
#DEFINE MVQueryCommand(%mode,%langStyle,%embeddedLang,%rtnName,%inputRef,%inputLineNum,%pos,%pend,%endPointer) $$MVQueryCommand^%qMVQuery2(%mode,%langStyle,%embeddedLang,%rtnName,%inputRef,%inputLineNum,%pos,%pend,%endPointer)
 
#DEFINE installLISTObjectsTAG installLISTObjects(fileLocation,flags)
#DEFINE installLISTObjects(%fileLocation,%flags) $$installLISTObjects^%qMVQuery(%fileLocation,%flags) 
 
#DEFINE LISTObjectsLoadedTAG LISTObjectsLoaded()
#DEFINE LISTObjectsLoaded() $$LISTObjectsLoaded^%qMVQuery()
 
 ;---------------------------------------------------------------------
 ;              PROC Global References, Variables & Methods
 ;---------------------------------------------------------------------
 
#DEFINE MVPROCRef(%procName) ^qMVconv("proc",%procName)
#DEFINE removeMVPROC(%procName) k $$$MVPROCRef(%procName)
#DEFINE MVPROCFileRef(%procName) ^qMVconv("proc",%procName,"file")
#DEFINE removeMVPROCFile(%procName) k $$$MVPROCFileRef(%procName)
 
#DEFINE PROCReserveListRef ^MultiVal.ReserveWord("PROC","word")
#DEFINE removePROCReserveList k $$$PROCReserveListRef
#DEFINE PROCReserveWordRef(%word) ^MultiVal.ReserveWord("PROC","word",%word)
#DEFINE removePROCReserveWord(%word) k $$$PROCReserveWordRef(%word)
#DEFINE setPROCReserveWord(%word) s $$$PROCReserveWordRef(%word)=""
#DEFINE isPROCReserveWord(%word) $d($$$PROCReserveWordRef(%word))
 
#DEFINE setPROCReserveListTAG setPROCReserveList()
#DEFINE setPROCReserveList d setPROCReserveList^%qMVProcConv()
 
#DEFINE PROCStmtTAG PROCStmt(mode,embeddedLang,rtnName,inputRef,inputLineNum,pos,pend,endPointer)
#DEFINE PROCStmt(%mode,%embeddedLang,%rtnName,%inputRef,%inputLineNum,%pos,%pend,%endPointer) $$PROCStmt^%qMVPROC(%mode,%embeddedLang,%rtnName,%inputRef,%inputLineNum,%pos,%pend,%endPointer)
 
 ; --- These are PROC Extensions to the MVQuery Language ---
 
#DEFINE PROCMVQueryReserveListRef ^MultiVal.ReserveWord("PROC-MVQuery","word")
#DEFINE removePROCMVQueryReserveList k $$$PROCMVQueryReserveListRef
#DEFINE PROCMVQueryReserveWordRef(%word) ^MultiVal.ReserveWord("PROC-MVQuery","word",%word)
#DEFINE removePROCMVQueryReserveWord(%word) k $$$PROCMVQueryReserveWordRef(%word)
#DEFINE setPROCMVQueryReserveWord(%word) s $$$PROCMVQueryReserveWordRef(%word)=""
#DEFINE isPROCMVQueryReserveWord(%word) $d($$$PROCMVQueryReserveWordRef(%word))
 
#DEFINE setPROCMVQueryReserveListTAG setPROCMVQueryReserveList()
#DEFINE setPROCMVQueryReserveList d setPROCMVQueryReserveList^%qMVQuery()
 
 ;---------------------------------------------------------------------
 ;                   Methods Definitions
 ;---------------------------------------------------------------------
 
#DEFINE normalizeTAG normalize(name)
#DEFINE normalize(%name) $$normalize^%qMVQuery(%name)
 
#DEFINE normalizeSQLTAG normalizeSQL(name)
#DEFINE normalizeSQL(%name) $$normalizeSQL^%qMVQuery(%name)
 
#DEFINE setDefConvOptionsTAG setDefConvOptions()
#DEFINE setDefConvOptions() d setDefConvOptions^%qMVQuery()
 
#DEFINE swapTAG swap(string,from,to)
#DEFINE swap(%string,%from,%to) $$swap^%qMVQuery(%string,%from,%to) 
 
#DEFINE execStringTAG execString(string)
#DEFINE execString(%string) $$execString^%qMVQuery(%string) 
 
#DEFINE getDirFilesTAG getDirFiles(dirPath,filesRef)
#DEFINE getDirFiles(%dirPath,%filesRef) $$getDirFiles^%qMVProcConv(%dirPath,%filesRef)
 
#DEFINE extractFileTAG extractFile(file,outRef,mode,timeout,readLength,maxLength)
#DEFINE extractFile(%file,%outRef,%mode,%timeout,%readLength,%maxLength) $$extractFile^%qMVProcConv(%file,%outRef,%mode,%timeout,%readLength,%maxLength)
 
#DEFINE reservedWordTAG reservedWord(word,language)
#DEFINE reservedWord(%word,%language) $$reservedWord^%qMVQuery(%word,%language)
 
#DEFINE reservedWordStartsWithTAG reservedWordStartsWith(word,language)
#DEFINE reservedWordStartsWith(%word,%language) $$reservedWordStartsWith^%qMVQuery(%word,%language)
 