Class %Atelier.v1.Utils.MetaData Extends %RegisteredObject
{

/// This method is used to create the indices in {system_install}/dev/atelier/dbname.
/// Once written the contents of the directory should be added to a zip file with the same name as the directory.
/// In this manner Atelier can take advantage of the pre-index information for providing code completion and other
/// facilities.
ClassMethod Build(pDataBaseName As %String)
{
    #dim tDir As %String 
    
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Try {
        
        #; Check database name
        If pDataBaseName="" Set tSC=$$$ERROR($$$DatabaseNameInvalid) Quit
            
        #; upcase
        Set pDataBaseName=$ZCVT(pDataBaseName,"U")
            
        #; Form (and create) installation directory
        Set tDir=##class(%File).ParentDirectoryName($System.Util.ManagerDirectory())
        Set tDir=tDir_"dev/atelier/"_pDataBaseName 
        If '##class(%File).CreateDirectoryChain(tDir) {
            
            Set tSC=$$$ERROR($$$GeneralError,"Failed To Create Directory: "_tDir)
            Quit
        }
        
        Set tSC=..Export(pDataBaseName, tDir)
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

ClassMethod Export(pDataBaseName As %String, pTargetDirectory As %String) As %Status [ Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tDIR
    
    Try {
       
        Set tDIR=$G(^%SYS("DBRefByName",pDataBaseName))
        If tDIR="" Set tSC=$$$ERROR($$$DatabaseNotThere) Quit
        
        #; Check for target directory existance
        If '##class(%File).DirectoryExists(pTargetDirectory) {
            If '##class(%File).CreateDirectory(pTargetDirectory) {
                Set tSC=$$$ERROR($$$GeneralError,"Failed to create directory: "_pTargetDirectory)
                Quit
            }
        }
        
        #; First, Modified
        Set tSC=..ExportModified(pDataBaseName,pTargetDirectory,tDIR)
        If $$$ISERR(tSC) Quit
        
        #; Second, Index
        Set tSC=..ExportIndex(pDataBaseName,pTargetDirectory,tDIR)
        If $$$ISERR(tSC) Quit
        
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// Export the modified file information
ClassMethod ExportModified(pDataBaseName As %String, pTargetDirectory As %String, pDataBaseDir As %String) [ Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tCls,tHash As %String = ""
    #dim tFileName,tModified,tHashNow As %String
    #dim tFirst As %Boolean
    
    #dim tFile As %File
    #dim tDoc As %DynamicObject
    
    Try {
        
        #; Get all the modified info for classes in the database (but not those generated)
        Set tHash=""
        Set tSC=##class(%Atelier.v1.Utils.General).GetModifiedDocumentsDB(pDataBaseName,.tHash,"CLS",.tModified)
        If $$$ISERR(tSC) Quit
       
        #; Construct the filename
        Set tFileName=##class(%File).NormalizeFilename("Modified.json",pTargetDirectory)
        
        Kill %objlasterror
        Set tFile=##class(%FileCharacterStream).%New()
        If '$IsObject(tFile) Set tSC=%objlasterror Quit
        
        #; Set the file name
        Set tFile.Filename=tFileName
        
        #; Want UTF-8
        Set tFile.TranslateTable="UTF8"
        
        Set tSC=tFile.Write("{ ""version"":"""_$ZV_""", ""dbname"":"""_pDataBaseName_""", ""dbhash"": """_tHash_""",""docs"" : [")
        If $$$ISERR(tSC) Quit
        
        #; Walk the list of classes
        Set tFirst=1
        For {
            
            Set tCls=$Order(tModified("CLS",tCls)) If tCls="" Quit
            
            If tFirst=0 {
                Set tSC=tFile.Write(",")
                If $$$ISERR(tSC) Quit
            } else {
                Set tFirst=0
            }
            
            #; construct one object
            Set tDoc = {},tDoc.name=tCls_".CLS",tDoc.ts=tModified("CLS",tCls,"ts")
            Do tDoc.%Set("gen",tDoc.gen=tModified("CLS",tCls,"gen"),"boolean")
            
            #; Write it to the file (we do this because we don't want thousands of %DynamicObjects in memory)
            Set tSC=tFile.Write(tDoc.%ToJSON())
            If $$$ISERR(tSC) Quit
        }
        
        Set tSC=tFile.Write("]}")
        If $$$ISERR(tSC) Quit
        
        #; Save
        Set tSC=tFile.SaveStream()
        If $$$ISERR(tSC) Quit
       
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

/// This entry point will index all the objects in a database and create a file for each in the specified
/// target directory. The database name and target directory will be tested for existence.
ClassMethod ExportIndex(pDataBaseName As %String, pTargetDirectory As %String, tDataBaseDirectory As %String) [ Private ]
{
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    #dim tClassName,tDB,tFileName,tOthers,tZIP As %String
    #dim tDoc,tIndex,tMetaData As %DynamicObject
    #dim tRtnMgr As %RoutineMgr
    #dim tI As %Integer
    
    Try {
        
        #; Need a routine manager
        Set tRtnMgr=##class(%RoutineMgr).%New()
        
        #; Now walk oddDEF for the classes and generate the index metadata
        Set tClassName="" For {
            
            Set tClassName=$Order(^|tDataBaseDirectory|oddDEF(tClassName)) If tClassName="" Quit
            
            #; Create the document
            Set tDoc={},tDoc.name=tClassName_".cls",tDoc.db=pDataBaseName
            Set tDoc.ts=##class(%Atelier.v1.Utils.General).TS(tClassName_".cls"),tDoc.cat="CLS"
            Do tDoc.%Set("gen",+tRtnMgr.IsGenerated(tClassName_".cls"),"boolean")
            
            #; Add the list of others
            Set tDoc.others = []
            Set tOthers=tRtnMgr.GetOther(tClassName,"cls")
            If tOthers'="" {
                For tI=1:1:$Length(tOthers,",") Do tDoc.others.%Push($Piece(tOthers,",",tI))
            }
           
            Set tDoc.status=$$$OK
            Set tDoc.content={}
            
            Set tSC=##class(%Atelier.v1.Utils.Indexer).Index(tDoc.name,tDoc.cat,.tIndex)
            If $$$ISERR(tSC) Set tDoc.status=$System.Status.GetOneErrorText(tSC)
            Set tDoc.content=tIndex
            
            #; Find the filename
            Set tFileName=##class(%File).NormalizeFilename(tClassName_".cls",pTargetDirectory)
            
            Kill %objlasterror
            Set tFile=##class(%FileCharacterStream).%New()
            If '$IsObject(tFile) Set tSC=%objlasterror Quit
            
            #; Set the filename
            Set tFile.Filename=tFileName
            
            #; Want UTF8
            Set tFile.TranslateTable="UTF8"
            
            Set tSC=tFile.Write(tDoc.%ToJSON())
            If $$$ISERR(tSC) Quit
            
            #; Save
            Set tSC=tFile.SaveStream()
            If $$$ISERR(tSC) Quit
        }
    } Catch (e) {
        Set tSC=e.AsStatus()
    }
    Quit tSC
}

}
