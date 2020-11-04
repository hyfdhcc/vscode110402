/// This class provides the external interface for retrieving, storing, and compiling
/// documents representing classes, routines, and include files (amongst others).
Class %Atelier.v1.Utils.TextServices
{

/// Given a name, return an array of strings representing the document. On success the
/// returned TextArray will have the 0 subscript set to the number of
/// lines and the subscripts 1-n will contain the actual text.<br>
/// Or, if the pBinary flag is set, the returned TextArray will contain chunks of Base64-encoded data.
/// and the node TextArray("bin") will be set to 1.
ClassMethod GetTextAsArray(pFullName As %String, pFlags As %Integer = 0, Output pTextArray As %String, pBinary As %Boolean = 0) As %Status
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tType As %String
    
    Try {
        
        #; Initialize outputs
        Kill pTextArray
        
        #; Normalize
        Set pFullName=##class(%Atelier.v1.Utils.General).NormalizeDocName(pFullName)
        
        #; No type for csp files
        Set tType=$select(pFullName["/":"", 1:$Piece(pFullName,".",*))
        
        If tType="cls" {
            Set tSC=..getClsTextAsArray(pFullName,pFlags,.pTextArray,pBinary)
        } ElseIf tType="%RULE" {
            Set tSC=..getRuleTextAsArray(pFullName,pFlags,.pTextArray,pBinary)
        } else {
            Set tSC=..getRtnTextAsArray(pFullName,pFlags,.pTextArray,pBinary)
        }
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    Quit tSC
}

/// Get a class as an array
ClassMethod getClsTextAsArray(pFullName As %String, pFlags As %Integer = 0, Output pTextArray As %String, pBinary As %Boolean = 0) As %Status [ Internal, Private, PublicList = serialized ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tErrList,tResultCode As %String
    #dim tI As %Integer
    
    #; Base64 encoding must be in chunk size multiple of 3
    #; Output is 4 chars for each 3 input, so 24573/3*4 = 32764
    #define Base64Chunk 24573
    
    #; Turn off TNode Cache
    Set ^||%oddDEF="nocache"
    
    #; Hide the public variable set by Run method of %qccServer
    New serialized
    
    Try {
            
        #; Call the pre-processor to turn .cls item into UDL array
        Set tResultCode=$preprocess(pFullName,pFlags,pTextArray,tErrList)
        If tResultCode {
      
            Kill pTextArray
            
            Set tSC=$$$ERROR($$$GeneralError,"Couldn't get text for "_pFullName)
            
            #; Decompose the error array
            For tI=1:1:$ll(tErrList) {
                Set tSC=$$$ADDSC(tSC,..ErrToStatus($list(tErrList,tI)))
            }
            
        } ElseIf pBinary {
            
            #; We must do the encoding in pieces with length a multiple of 3.
            
            Set tData=""
            Set tI=1,limit=pTextArray(0),tNewCnt=0
            
            While tI<=limit {
                Set tData=tData_pTextArray(tI)
                #; Last line does not have a delimiter
                Set:tI'=limit tData=tData_$C(10)
                If $Length(tData)>=$$$Base64Chunk {
                    Set tBase64=$SYSTEM.Encryption.Base64Encode($Extract(tData,1,$$$Base64Chunk),1)
                    Set tNewCnt=tNewCnt+1,tNewArray(tNewCnt)=tBase64
                    Set tData=$Extract(tData,$$$Base64Chunk+1,*)
                }
                Set tI=tI+1
            }
            If $Length(tData) {
                Set tBase64=$SYSTEM.Encryption.Base64Encode(tData,1)
                Set tNewCnt=tNewCnt+1,tNewArray(tNewCnt)=tBase64
            }
            
            Set tNewArray(0)=tNewCnt
            Set tNewArray("bin")=1
            
            Kill pTextArray
            Merge pTextArray=tNewArray
            
        } Else {
            Set pTextArray("bin")=0
        }
        
    } Catch(e) {
        Set tSC=e.AsStatus()
    }
    
    #; Good to restore this
    Set ^||%oddDEF=""
    
    Quit tSC
}

/// Get a routine (or any other document except class) as an array
ClassMethod getRtnTextAsArray(pName As %String, pFlags As %Integer = 0, Output pTextArray As %String, pBinary As %Boolean = 0) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tRtnMgr As %RoutineMgr
    #dim tI As %Integer
    #dim tHeader,tKeywords As %String
    
    #; A stream (%Routine or %CSP.Routine) containing the routine associated with this object.
    #dim tCode as %Routine
    
    Try {
        
        #; Attempt to open the routine
        Kill %objlasterror
        Set tRtnMgr=##class(%RoutineMgr).%OpenId(pName)
        
        If '$IsObject(tRtnMgr) {
             Set tSC=$Get(%objlasterror,$$$ERROR($$$UnableToOpenDocument,pName))
            Quit
        }
        
        Set tCode=tRtnMgr.Code
        
        #; Clear the output arguments
        Kill pTextArray
        
        #; No header for CSP or Other
        If tRtnMgr.IsCSP=0,'##class(%RoutineMgr).UserType(tRtnMgr.Name) {
            
            #; Construct header (name always required)
            #; Note this almost-the-same code is in %Atelier.v1.Utils.General.CreateDocumentObject
            Set tHeader="ROUTINE "_$Piece(tRtnMgr.Name,".",1,*-1),tKeywords=""
            
            #; The default is MAC, so only set the type if needed
            If $Piece(tRtnMgr.Name,".",*)'="MAC" Set tKeywords=tKeywords_",Type="_$Piece(tRtnMgr.Name,".",*)
            If tRtnMgr.LanguageModeGet()>0 {
                Set tKeywords=tKeywords_",LanguageMode="_tRtnMgr.LanguageModeGet()
            }
            If tRtnMgr.Generated {
                Set tKeywords=tKeywords_",Generated"
            }
            
            If tKeywords'="" Set tHeader=tHeader_" ["_$Extract(tKeywords,2,*)_"]"
            Set tI=1,pTextArray(tI)=tHeader
            
        } Else {
            Set tI=0
        }
        
        If pBinary {
            #; If we are reading from a CSP file, make sure it is RAW mode
            If tCode.%IsA("%FileCharacterStream") Set tCode.TranslateTable="RAW"
            
            Set tData=$Select(tI=1:tHeader_$C(10),1:""), tI=0
            
            #; We must do the encoding in pieces with length a multiple of 3.
            Do {
                Set tData=tData_tCode.Read($$$Base64Chunk,.tSC)
                Quit:$$$ISERR(tSC)
                Set tBase64=$SYSTEM.Encryption.Base64Encode($Extract(tData,1,$$$Base64Chunk),1)
                Set tI=tI+1, pTextArray(tI)=tBase64
                Set tData=$Extract(tData,$$$Base64Chunk+1,*)
            } While tCode.AtEnd=0
            
            If $Length(tData) {
                Set tBase64=$SYSTEM.Encryption.Base64Encode(tData,1)
                Set tI=tI+1, pTextArray(tI)=tBase64
            }
            
            Set pTextArray("bin")=1
            
        } Else {
        
            #; Now fill in the output array
            While tCode.AtEnd=0 {
                Set tI=tI+1, pTextArray(tI)=tCode.ReadLine()  
            }
            
            Set pTextArray("bin")=0
        }
        
        #; Fill in the count
        Set pTextArray(0)=tI
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    Quit tSC
}

/// Get an Ensemble Business Rule
ClassMethod getRuleTextAsArray(pName As %String, pFlags As %Integer = 0, Output pTextArray As %String, pBinary As %Boolean = 0) As %Status [ Internal, Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tI As %Integer
    #dim tRulMgr As Ens.Atelier.v1.RuleDocument
    
    #; A stream containing the url associated with this object.
    #dim tCode as %AbstractStream
    
    Try {
        
        #; See if it is a Rules class
        Kill %objlasterror
        If '##class(%RoutineMgr).Exists(pName) {
            Set tSC=$Get(%objlasterror,$$$ERROR($$$UnableToOpenDocument,pName))
            Quit
        }
        
        #; If it exists, we must be in an Ensemble namespace, so
        Set tRulMgr=##class(Ens.Atelier.v1.RuleDocument).%New(pName)
        
        Set tCode=tRulMgr.Code
        
        #; Clear the output arguments
        Kill pTextArray
        
        Set tI=0
        
        If pBinary {
            #; If we are reading from a file, make sure it is RAW mode
            If tCode.%IsA("%FileCharacterStream") Set tCode.TranslateTable="RAW"
            
            Set tData=""
            
            #; We must do the encoding in pieces with length a multiple of 3.
            Do {
                Set tData=tData_tCode.Read($$$Base64Chunk,.tSC)
                Quit:$$$ISERR(tSC)
                Set tBase64=$SYSTEM.Encryption.Base64Encode($Extract(tData,1,$$$Base64Chunk),1)
                Set tI=tI+1, pTextArray(tI)=tBase64
                Set tData=$Extract(tData,$$$Base64Chunk+1,*)
            } While tCode.AtEnd=0
            
            If $Length(tData) {
                Set tBase64=$SYSTEM.Encryption.Base64Encode(tData,1)
                Set tI=tI+1, pTextArray(tI)=tBase64
            }
            
            Set pTextArray("bin")=1
            
        } Else {
        
            #; Now fill in the output array
            While tCode.AtEnd=0 {
                Set tI=tI+1, pTextArray(tI)=tCode.ReadLine()  
            }
            
            Set pTextArray("bin")=0
        }
        
        #; Fill in the count
        Set pTextArray(0)=tI
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    
    Quit tSC
}

/// This method requires an integer subscripted array containing lines of text which represent a
/// cache 'document' (class, include, routine etc). Subscript value 0 should contain a count
/// of lines of text which are defined as subscript value 1 ... n in the array
/// 
/// The method will parse the representation and if it is syntactically valid will attempt to 
/// save the resultant document. It returns $$$OK on success and a (possibly composite) error status on
/// failure. Note: a syntactically valid represention may fail to save due to failure to obtain a lock.
/// 
/// It is important to realize that this method will replace the existing document if present and therefore
/// must contain a full representation of the document. Also note that the name of the document will be derived from
/// within the text, unless pCategory is CSP or OTH.
/// 
/// If the binary flag is specified, the document array contains Base64-encoded chunks of data.
ClassMethod SetTextFromArray(ByRef pDocumentArray As %String, pFlags As %Integer = 0, pDocName As %String, pCategory As %String, pBinary As %Boolean = 0) As %Status [ Internal ]
{
    #; N.B. If the signature or behavior changes, update LoadUDL^%apiOBJ.
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tName,tType,tValue,tLine As %String
    #dim tErrList,tFirstErr,tOneErr,tKeywords As %String
    #dim tData As %String
    #dim tResultCode,tI,tJ As %Integer
    #dim tCspRtn as %CSP.Routine
    #dim tRtnMgr As %RoutineMgr
    
    #; A stream (%Routine or %CSP.Routine) containing the routine associated with this object.
    #dim tCode as %Routine

    #; Look for CSP document
    If $Get(pCategory)="CSP" {
        Try {
            Set tCspRtn=##class(%CSP.Routine).%New(pDocName)
            If '$IsObject(tCspRtn) Set tSC=$Get(%objlasterror,0) Quit
            Set tSC=tCspRtn.Rewind()
            If $$$ISERR(tSC) Quit
            
            If pBinary {
                #; If we are writing to a file, make sure it is RAW mode and not STREAM
                If tCspRtn.%IsA("%FileCharacterStream") {
                    Set tCspRtn.TranslateTable="RAW"
                    Set tCspRtn.StreamFormatWrite=0
                }
                
                For tI=1:1:pDocumentArray(0) {
                    Set tData=$SYSTEM.Encryption.Base64Decode(pDocumentArray(tI))
                    Set tSC=tCspRtn.Write(tData)
                    If $$$ISERR(tSC) Quit
                }
                
            } Else {
                For tI=1:1:pDocumentArray(0) {
                    Set tSC=tCspRtn.WriteLine(pDocumentArray(tI))
                    If $$$ISERR(tSC) Quit
                }
            }
            If $$$ISERR(tSC) Quit
            
            Set tSC=tCspRtn.%Save()
            If $$$ISERR(tSC) Quit
            
        } Catch e {
            Set tSC=e.AsStatus()
        }
        Quit tSC
    }

    #; Look for a user-defined document type
    If $Get(pCategory)="OTH" {
        Try {
            Kill %objlasterror
            Set tRtnMgr=##class(%RoutineMgr).%OpenId(pDocName)

            If '$IsObject(tRtnMgr) {
                Set tSC=$Get(%objlasterror,$$$ERROR($$$UnableToOpenDocument,pDocName))
                Quit
            }
            
            Set tCode=tRtnMgr.Code
            Set tSC=tCode.Rewind()
            If $$$ISERR(tSC) Quit
            
            If pBinary {
                
                For tI=1:1:pDocumentArray(0) {
                    Set tData=$SYSTEM.Encryption.Base64Decode(pDocumentArray(tI))
                    Set tSC=tCode.Write(tData)
                    If $$$ISERR(tSC) Quit
                }
                
            } Else {
                
                For tI=1:1:pDocumentArray(0) {
                    Set tSC=tCode.WriteLine(pDocumentArray(tI))
                    If $$$ISERR(tSC) Quit
                }
            }
            If $$$ISERR(tSC) Quit
            
            Set tSC=tRtnMgr.%Save()
            If $$$ISERR(tSC) Quit
            
        } Catch e {
            Set tSC=e.AsStatus()
        }
        Quit tSC
    }

    Try {
        
        #; If it is binay class or routine, we have to decode it
        #; into a line array
        If pBinary {
            
            Kill tDocArray
            Set tCode="", tLineNo=0, tLastNull=0
            
            For tI=1:1:pDocumentArray(0) {
                Set tData=$SYSTEM.Encryption.Base64Decode(pDocumentArray(tI))
                Set tCode=tCode_tData, tLF=0, tLineStart=1
                For {
                    Set tLF=$Find(tCode,$C(10),tLF) Quit:'tLF
                    Set tDocArray($Increment(tLineNo))=$Extract(tCode,tLineStart,tLF-2)
                    Set tLineStart=tLF
                }
                #; If last char is $C(10) need a null last line
                Set tLastNull=$Length(tCode)+1=tLineStart
                Set tCode=$Extract(tCode,tLineStart,*)
            }
            
            If tCode'="" || tLastNull Set tDocArray($Increment(tLineNo))=tCode
            
            Set tDocArray(0)=tLineNo
            Kill pDocumentArray
            Merge pDocumentArray=tDocArray
            Kill tDocArray,tCode,tData
        }
        
        Set tSC=##class(%Atelier.v1.Utils.General).GetMetaDataFromDocArray(.pDocumentArray,.tName,.tKeywords)
        If $$$ISERR(tSC) Quit
        
        Set tType=tKeywords("type")

        If tType="CLS" {
            
            #; Save the definition (just saves, doesn't compile)
            Set tFlags=16777216 ; 0x01000000 = IPARSE_UDL_SAVEWITHERRORS save even if parse errors
            Set tResultCode=$compile(pDocumentArray,128,tErrList,,,tFlags)
            If tResultCode {
              
                Set tSC=$$$ERROR($$$GeneralError,"Couldn't set text for "_tName)
                
                #; Decompose the error array
                For tI=1:1:$ll(tErrList) {
                    Set tSC=$$$ADDSC(tSC,..ErrToStatus($list(tErrList,tI)))
                } 
            }
            
        } else {

            #; Call Routine api
            Set tSC=$$Import^%apiRTN(,"replace,compile=no,lock=no",,,.tRtnResult,"/nodisplaylog",,,.pDocumentArray)
            If $$$ISOK(tSC),$Data(tRtnResult)>1 {
                Set tName=$Order(tRtnResult(""))
                If tName'="",tRtnResult(tName)'="",tRtnResult(tName)'="Loaded" {
                    #; Probably invalid name
                    Set tSC=$$$ERROR($$$GeneralError,tRtnResult(tName))
                }
            }
        }

    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

ClassMethod ErrToStatus(pErr) As %Status
{
    Quit $$$ERROR($$$SourceErrorLocation,"Line: "_$List(pErr,1)_" Offset: "_$List(pErr,2)_" "_$List(pErr,4))
}

}
