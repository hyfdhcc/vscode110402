/// This class contains API method for the DeepSee User Component library.
Class %DeepSee.UserLibrary.Utils Extends %RegisteredObject [ Abstract, System = 4 ]
{

/// Deletes all folders and folder items in the current namespace.
ClassMethod %KillFolders() As %Status
{
	Do ##class(Folder).%KillExtent()
	Do ##class(FolderItem).%KillExtent()
	Quit $$$OK
}

ClassMethod %KillAutosaveFolders(pFolder As %String = "$Temp") As %Status
{
	// Method added by WAL123
	If ($E(pFolder,1,5) '= "$Temp") Quit $$$OK
	// need to delete this folder as well
	Set tSC = ##class(%DeepSee.UserLibrary.Utils).%GetSubFolderList(.tSubFolderList,pFolder) 
	Set tSubFolder = $O(tSubFolderList(""))
	While (tSubFolder '= "") {
		// Recurse
		Set tSC = ..%KillAutosaveFolders(tSubFolderList(tSubFolder)) // + WAL153
		If (($G(tSubFolderList(tSubFolder))'="") && ($E($G(tSubFolderList(tSubFolder)),1,5) = "$Temp")) {
			Set tSC = ##class(%DeepSee.UserLibrary.Utils).%DeleteFolderContents(tSubFolderList(tSubFolder))
			Set tFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder(tSubFolderList(tSubFolder))
			If $IsObject(tFolder) {
				Set tSC = ##class(%DeepSee.UserLibrary.Folder).%DeleteId(tFolder.%Id())
			}
		}
		Set tSubFolder = $O(tSubFolderList(tSubFolder))
	}
	// Delete this folder
	Set tSC = ##class(%DeepSee.UserLibrary.Utils).%DeleteFolderContents(pFolder)
	Set tFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder(pFolder)
	If $IsObject(tFolder) {
		Set tSC = ##class(%DeepSee.UserLibrary.Folder).%DeleteId(tFolder.%Id())
	}
	Quit $$$OK
}

/// Deletes all user preference info in the current namespace.
ClassMethod %KillUserPreferences() As %Status
{
	Kill ^DeepSee.UserPreferences
	Quit $$$OK
}

/// Make note that the given item was accessed recently.
ClassMethod %RegisterRecentItem(pType As %String, pName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If ((pType="")||(pName="")) Quit

		// do not register "system" items
		If (($E(pName,1)="$")&&($E(pName,1,3)'="$$$")) Quit

		Set ^DeepSee.UserPreferences($UserName,"recent",pType,pName) = $ZDT($H,3)

		// clear out old items
		// JMD1211: loop over type
		Set tCount = 0
		Set tType = $O(^DeepSee.UserPreferences($UserName,"recent",""))
		While (tType'="") {
			Set tName = $O(^DeepSee.UserPreferences($UserName,"recent",tType,""),1,t)
			While (tName'="") {
				Set tList(t) = $LB(tType,tName)
				Set tCount = tCount + 1
				Set tName = $O(^DeepSee.UserPreferences($UserName,"recent",tType,tName),1,t)
			}
			Set tType = $O(^DeepSee.UserPreferences($UserName,"recent",tType))
		}
		While (tCount > 30) {
			Set t = $O(tList(""),1,tNode)
			Set tType = $LG(tNode,1)
			Set tName = $LG(tNode,2)
			Kill:tType'=""&&tName'="" ^DeepSee.UserPreferences($UserName,"recent",tType,tName)
			Set tCount = tCount - 1
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get list of recent items for user.
/// This takes the form:<br/>
/// pList(time) = name<br/>
/// If <var>pType</var> is missing, list all types. <var>pType</var> can contain a csv
/// list of types.
ClassMethod %GetRecentItemList(Output pList As %String, pType As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		
		If (pType="") {
			Set tType = $O(^DeepSee.UserPreferences($UserName,"recent",""))
		}
		Else {
			Set p = 1
			Set tType = $P(pType,",",p)
		}
		
		Set n = 0
		While (tType '= "") {
			Set tName = $O(^DeepSee.UserPreferences($UserName,"recent",tType,""),1,t)
			While (tName'="") {
				Set n = n + 1
				Set pList(t_"?"_n) = tName
				Set tName = $O(^DeepSee.UserPreferences($UserName,"recent",tType,tName),1,t)
			}
			If (pType="") {
				Set tType = $O(^DeepSee.UserPreferences($UserName,"recent",tType))
			}
			Else {
				Set p = p + 1
				Set tType = $P(pType,",",p)
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Remove item from recent items list.
ClassMethod %RemoveRecentItem(pName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If (pName="") Quit
		Set tType = $O(^DeepSee.UserPreferences($UserName,"recent",""))
		While (tType '= "") {
			Set tName = $O(^DeepSee.UserPreferences($UserName,"recent",tType,""))
			While (tName'="") {
				If (tName = pName) {
					Kill ^DeepSee.UserPreferences($UserName,"recent",tType,tName)
				}
				Set tName = $O(^DeepSee.UserPreferences($UserName,"recent",tType,tName))
			}
			Set tType = $O(^DeepSee.UserPreferences($UserName,"recent",tType))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Add item to favorites list.
ClassMethod %AddFavorite(pName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If (pName="") Quit
		Set ^DeepSee.UserPreferences($UserName,"favorite",pName) = $ZDT($H,3)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Remove item from favorites list.
ClassMethod %RemoveFavorite(pName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		If (pName="") Quit
		Kill ^DeepSee.UserPreferences($UserName,"favorite",pName)
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Get list of favorite items for user.
/// This takes the form:<br/>
/// pList(name) = time
ClassMethod %GetFavoriteList(Output pList As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tName = $O(^DeepSee.UserPreferences($UserName,"favorite",""),1,t)
		While (tName'="") {
			Set pList(tName) = t
			Set tName = $O(^DeepSee.UserPreferences($UserName,"favorite",tName),1,t)
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Open the folder item with the given full name.
ClassMethod %OpenFolderItem(pFullName As %String, Output pStatus As %Status) As FolderItem
{
	Set tItem = ""
	Kill %objlasterror
	If ((pFullName'="")&&(..%FolderItemExists(pFullName,.tID)=1)) {
		Set:tID'="" tItem = ##class(FolderItem).%OpenId(tID,,.pStatus)
	}
	Quit tItem
}

/// Check if a there is a folder item with the given name.<br/>
/// Returns 0 if the item does not exist; returns 1 if it exists and is visible to the
/// current user; returns 2 if it exists but is not visible to the current user.<br/>
/// Return its id by reference as a convenience.<br/>
ClassMethod %FolderItemExists(pFullName As %String, Output pID As %String) As %Integer
{
	Set pID = ""
	If ($G(pFullName) = "") Quit 0
	Set tSC = ##class(FolderItem).%ParseFullName(pFullName,.tFolderName,.tItemName,.tExt)
	Quit:$$$ISERR(tSC) 0

	Set tFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder(tFolderName)
	Set tFolderId = $S($IsObject(tFolder):tFolder.%Id(),1:"")
	If ((tFolderName'="")&&(tFolderId="")) {
		// if the folder does not yet exist, then the item does not exist!
		Quit 0
	}
	// check each item with given name (but different extension)
	Set tID = ""
	Set SQLCODE = ""
	&sql(DECLARE sql1 CURSOR FOR
		SELECT %ID INTO :tID FROM %DeepSee_UserLibrary.FolderItem 
		WHERE ((folder->fullName = :tFolderName) OR (:tFolderName IS NULL AND folder IS NULL)) 
			AND (name = :tItemName)
			ORDER BY timeModified DESC)

	Set tFound = 0
	&sql(OPEN sql1)
	&sql(FETCH sql1)
	While ('tFound && (SQLCODE = 0)) {
		Set tItem = ##class(FolderItem).%OpenId(tID,,.pStatus)
		If ($$$UPPER(tItem.fullName) = $$$UPPER(pFullName)) {
			Set pID = tID
			If (tItem.%CheckResource()) {
				Set tFound = 1
			}
			Else {
				Set tFound = 2
			}
		}
		&sql(FETCH sql1)
	}
	&sql(CLOSE sql1)
	Quit tFound
}

/// Delete all the items within the given folder.
ClassMethod %DeleteFolderContents(pFolderName As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		// get *all* items in this folder
		Set tSC = ..%GetFolderItemList(.tList,pFolderName,1)
		If $$$ISERR(tSC) Quit

		// n.b. this will delete all items in this folder
		// even those not visible to the current user
		Set k = $O(tList(""))
		
		While (k'="") {
			// JMD1333 make sure to use correct id
			Set tItem = ##class(FolderItem).%OpenId(tList(k))
			If $IsObject(tItem) {
				Set tSC = ..%DeleteFolderItem(tItem.fullName)
				If $$$ISERR(tSC) Quit
			}
			Set k = $O(tList(k))
		}
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Delete the folder item with the given full name.
/// <var>pCount</var> returns the number of items actually deleted.
ClassMethod %DeleteFolderItem(pFullName As %String, Output pCount As %Integer) As %Status
{
	Set tSC = $$$OK
	Set pCount = 0
	// If there are multiple items with the same name, delete all of them!
	While ((pFullName'="")&&(..%FolderItemExists(pFullName,.tID)=1)) {
		// clear any settings for this item
		// if the item is not a dashboard, there is no harm done!
		Do ##class(%DeepSee.UserPortal.Utils).%ClearDashboardSettings(pFullName)
		Set tSC = ##class(FolderItem).%DeleteId(tID)
		If $$$ISOK(tSC) {
			Set pCount = pCount + 1
		}
	}
	Quit tSC
}

/// Return a list of all folder item classes.<br/>
/// pList(n) = $LB(classname,xmlname)
ClassMethod %GetFolderItemClasses(Output pList) As %Status
{
	Set tSC = $$$OK
	Try {
		Kill pList

		// find all subclasses of FolderItem
		Set tRS = ##class(%ResultSet).%New("%Dictionary.ClassDefinition:SubclassOf")
		Set tSC = tRS.Execute("%DeepSee.UserLibrary.FolderItem")
		If $$$ISERR(tSC) Quit
		While (tRS.Next(.tSC)) {
			If $$$ISERR(tSC) Quit
			Set tName = $G(tRS.Data("Name"))
			Set tClasses(tName) = ""
		}

		Set n = 0
		Set tClass = $O(tClasses(""))
		While (tClass'="") {
			Set n = n + 1
			Set tXMLName = $zobjclassmethod(tClass,"%GetParameter","XMLNAME")
			Set pList(n) = $LB(tClass,tXMLName)
			Set tClass = $O(tClasses(tClass))
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Return an array of all folders visible to the current user within the given folder.
/// This list is in the form:<br/>
/// pList(n) = name
ClassMethod %GetFolderList(Output pList As %String, pFolderName As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tFlag = $zu(115,8,0)
		Set tStatement = ##class(%SQL.Statement).%New(,"DEFAULT_SCHEMA")
		Set tSC = tStatement.%Prepare("SELECT ID,fullName FROM %DeepSee_UserLibrary.Folder ORDER BY fullName")
		If $$$ISERR(tSC) Quit

		Set n = 0
		Set tRS = tStatement.%Execute()
		While (tRS.%Next(.tSC)) {
			If $$$ISERR(tSC) Quit
			If (tRS.fullName '="") {
				// names starting with $ are private
				// JMD1344: test localized name
				Set tDName = ##class(%DeepSee.UserPortal.Utils).%ResolveText(tRS.fullName)
				If ($E(tDName,1)'="$") {
					Set tFolder = ##class(%DeepSee.UserLibrary.Folder).%OpenId(tRS.ID)
					If ($IsObject(tFolder)) {
						Set tResource = tFolder.%GetResource()
						If ((tResource="")||$System.Security.Check(tResource,"USE")) {
							Set n = n + 1
							Set pList(n) = tFolder.fullName
						}
					}
				}
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Set tFlag = $zu(115,8,tFlag)
	Quit tSC
}

/// Return an array of all categories that have been assigned to Folder Items.
/// This list is in the form:<br/>
/// pList(n) = category
ClassMethod %GetCategoryList(Output pList) As %Status
{
	// Method added by DTB102
	Kill pList
	Set tSC = $$$OK
	Set tFlag = $zu(115,8,0)
	Try {
		Set tSQL = "SELECT Category FROM %DeepSee_UserLibrary.FolderItem WHERE Category IS NOT NULL GROUP BY %EXACT(Category) ORDER BY Category"
		Set tStatement = ##class(%SQL.Statement).%New(,"DEFAULT_SCHEMA")
		Set tSC = tStatement.%Prepare(tSQL)
		If $$$ISERR(tSC) Quit

		Set n = 0
		Set tRS = tStatement.%Execute()
		While (tRS.%Next(.tSC)) {
			If $$$ISERR(tSC) Quit
			
			Set pList($I(n)) = tRS.%Get("Category")
		}
	}
	Catch ex {
		Set tSC = ex.Status()
	}
	Set tFlag = $zu(115,8,tFlag)
	Quit tSC
}

ClassMethod %GetSubFolderList(Output pList As %String, pFolderName As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tFlag = $zu(115,8,0)
		Set tStatement = ##class(%SQL.Statement).%New(,"DEFAULT_SCHEMA")
		Set tSQL = "SELECT ID,fullName FROM %DeepSee_UserLibrary.Folder WHERE folder->fullname %STARTSWITH '"
		Set tSQL = tSQL _ pFolderName _ "' Order By fullName"
		Set tSC = tStatement.%Prepare(tSQL)
		If $$$ISERR(tSC) Quit

		Set n = 0
		Set tRS = tStatement.%Execute()
		While (tRS.%Next(.tSC)) {
			If $$$ISERR(tSC) Quit
			If (tRS.fullName '="") {
				// names starting with $ are private
				// JMD1344: test localized name
				Set tDName = ##class(%DeepSee.UserPortal.Utils).%ResolveText(tRS.fullName)
				
				/// WAL053 -- show $temp
				If (($E(tDName,1)'="$")||($E(tDName,1,5)="$Temp")) {
					Set tFolder = ##class(%DeepSee.UserLibrary.Folder).%OpenId(tRS.ID)
					If ($IsObject(tFolder)) {
						Set tResource = tFolder.%GetResource()
						If ((tResource="")||$System.Security.Check(tResource,"USE")) {
							Set n = n + 1
							Set pList(n) = tFolder.fullName
						}
					}
				}
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Set tFlag = $zu(115,8,tFlag)
	Quit tSC
}

/// Return an array of all folder items visible to the current user within the given folder.
/// This list is in the form:<br/>
/// pList(n) = id<br/>
/// If <var>pShowAll</var> is true, list items for all users.<br/>
/// If <var>pFolderClass</var> is provided, only list items of the given type.<br/>
ClassMethod %GetFolderItemList(Output pList As %String, pFolderName As %String = "", pShowAll As %Boolean = 0, pFolderClass As %String = "") As %Status [ PublicList = SQLCODE ]
{
	Set tSC = $$$OK
	Try {
		New SQLCODE
		Set tFlag = $zu(115,8,0)
		Set tSQL = "SELECT ID FROM %DeepSee_UserLibrary.FolderItem"
		Set tWHERE = ""
		If (pFolderName'="") {
			Set tWHERE = tWHERE _ $S(tWHERE="":"",1:" AND ") _ "folder->fullName="_ ##class(%ZEN.Auxiliary.QueryInfo).QuoteSQL(pFolderName)
		}
		If (pFolderClass'="") {
			Set tWHERE = tWHERE _ $S(tWHERE="":"",1:" AND ") _ "x__classname['"_pFolderClass_"'"
		}
		Set:tWHERE'="" tSQL = tSQL_" WHERE "_tWHERE

		Set tStatement = ##class(%SQL.Statement).%New(,"DEFAULT_SCHEMA")
		Set tSC = tStatement.%Prepare(tSQL)
		If $$$ISERR(tSC) Quit

		Set n = 0
		Set tRS = tStatement.%Execute()
		While (tRS.%Next(.tSC)) {
			If $$$ISERR(tSC) Quit
			If (tRS.ID '="") {
				Set tItem = ##class(FolderItem).%OpenId(tRS.ID)
				If ($IsObject(tItem)&&(tItem.%IsVisibleToPortal()||pShowAll)) {
					If (pShowAll||tItem.%CheckResource()) {
						Set n = n + 1
						Set pList(n) = tRS.ID
					}
				}
			}
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Set:$D(tFlag) tFlag = $zu(115,8,tFlag)
	Quit tSC
}

/// Find the folder with the given full name.
/// If <var>pCreate</var> is true, then create the folder if it does not exist.
ClassMethod %FindFolder(pName As %String, pCreate As %Boolean = 0, Output pSC As %Status, pParent As Folder = "") As Folder
{
	Set tFolder = ""
	Set pSC = $$$OK
	Try {
		Set tParentId = $S($IsObject(pParent):pParent.%Id(),1:"")
		Set tRoot = $P(pName,"/",1)
		Set tPath = $P(pName,"/",2,$L(pName,"/"))
		If (##class(%DeepSee.UserLibrary.Folder).nameExists(tParentId,tRoot,.tFolderId)) {
			Set tFolder = ##class(%DeepSee.UserLibrary.Folder).nameOpen(tParentId,tRoot)
		}
		If ('$IsObject(tFolder) && pCreate) {
			Set tFolder = ##class(%DeepSee.UserLibrary.Folder).%New()
			Set tFolder.name = tRoot
			Set tFolder.folder = pParent
			Set pSC = tFolder.%Save()
			If $$$ISERR(pSC) Quit
		}

		If ($IsObject(tFolder) && (tPath'="")) {
			// recurse
			Set tFolder = ..%FindFolder(tPath,pCreate,.pSC,tFolder)
			If $$$ISERR(pSC) Quit
		}
	}
	Catch(ex) {
		Set pSC = ex.AsStatus()
	}
	If $$$ISERR(pSC) {
		Set tFolder = ""
	}
	Quit tFolder
}

/// Export FolderItem or Folder information to an XML file.
ClassMethod %Export(pFullName As %String, pFile As %String = "", pVerbose As %Boolean = 1) As %Status
{
	Set tSC = $$$OK
	Set io = ""
	Try {
		Set tItem = ..%OpenFolderItem(pFullName,.tSC)
		If '$IsObject(tItem) {
			// check for folder
			Set tItem = ..%FindFolder(pFullName,,.tSC)
			If '$IsObject(tItem) {
				Set tSC = $$$ERROR($$$GeneralError,"Unable to open folder item: "_pFullName)
				Quit
			}
			Set tItem.%exportName = tItem.fullName
		}

		Set tWriter = ##class(%XML.Writer).%New()
		Set tWriter.Indent = 1

		If $IsObject(pFile) {
			Set tSC = tWriter.OutputToStream(pFile)
			If $$$ISERR(tSC) Quit
		}
		Else {
			// make sure we can open the file
			Open pFile:"WNU":0 Else  Set tSC = $$$ERROR($$$GeneralError,"Unable to open file: "_pFile) Quit
			Close pFile

			Set tWriter = ##class(%XML.Writer).%New()
			Set tWriter.Indent = 1
			Set tSC = tWriter.OutputToFile(pFile)
			If $$$ISERR(tSC) Quit
		}
		Set tSC = tWriter.StartDocument()  
		If $$$ISERR(tSC) Quit
		Set tSC = tWriter.RootObject(tItem)
		If $$$ISERR(tSC) Quit
		Set tSC = tWriter.EndDocument()
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If ($$$ISERR(tSC)&&pVerbose) {
		Write !
		Do $System.Status.DisplayError(tSC)
	}
	Quit tSC
}

/// Import a folder item definition from an XML file.<br/>
/// If <var>pReplace</var> is true, replace an existing item with the same name.<br/>
/// If <var>pVerbose</var> is true, write status to the console.<br/>
/// If <var>pKill</var> is true, then delete all existing items before import!<br/>
/// If <var>pForceItemName</var> is given, import the item using that name.<br/>
/// If type-extension is not present in <var>pForceItemName</var> supply it automatically<br/>
ClassMethod %Import(pFile As %String = "", pReplace As %Boolean = 0, pVerbose As %Boolean = 1, pKill As %Boolean = 0, pForceItemName As %String = "", ByRef pItemsLoaded As %String) As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror

		// Create an instance of %XML.Reader
		Set tReader = ##class(%XML.Reader).%New()
	
		// Begin processing of the file
		If $IsObject(pFile) {
			Set tSC = tReader.OpenStream(pFile)
		} Else {
			Set tSC = tReader.OpenFile(pFile)
		}
		If $$$ISERR(tSC) Quit

		If (pKill) {
			Write:pVerbose "Deleting existing folder contents",!
			Set tSC = ..%KillFolders()
			If $$$ISERR(tSC) Quit
		}

		// Associate possible class names with their XML element names
		Set tSC = ..%GetFolderItemClasses(.tClasses)
		If $$$ISERR(tSC) Quit

		Set n = $O(tClasses(""))
		While (n'="") {
			Set tClassName = $LG(tClasses(n),1)
			Set tXMLName = $LG(tClasses(n),2)
			Do tReader.Correlate(tXMLName,tClassName)
			Set n = $O(tClasses(n))
		}

		Do tReader.Correlate("folder","%DeepSee.UserLibrary.Folder")

		// Read objects (folders or folderItems) from xml file
		While (tReader.Next(.tItem,.tSC)) {
			// JMD1379 reset force name for each item
			Set tForceItemName = pForceItemName
			If (tItem.%IsA("%DeepSee.UserLibrary.Folder")) {
				Set tFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder(tItem.%exportName,1)
				If $IsObject(tFolder) {
					// update
					Write:pVerbose "Updating: ",tFolder.fullName,!
					Set tFolder.resource = tItem.resource
					Set tItem = tFolder
					Set tSC = tItem.%Save()
					If $$$ISERR(tSC) Quit
					Set pItemsLoaded($I(pItemsLoaded)) = tFolder.fullName
				}
			}
			Else { // an item not a folder
				If (""=tForceItemName) {
					Set tForceItemName=tItem.fullName
				}
				Else { // if needed add type extension from item to pForceItemName
					Set tSC = ##class(FolderItem).%ParseFullName(tForceItemName,.tFolderName,.tItemName,.tExt)
					Set:""=tExt tForceItemName=tForceItemName_"."_$$$comMemberKeyGet(tItem.%ClassName(1),$$$cCLASSparameter,"ITEMTYPE",$$$cPARAMdefault)
				}
				Set tExists = ..%FolderItemExists(tForceItemName)
				If (tExists=2) {
					Set tSC = $$$ERROR($$$GeneralError,"Folder item with given name "_tForceItemName_" already exists and you do not have permission to replace it"_$S(pForceItemName=tItem.fullName:"",1:" with imported item "_tItem.fullName))
					Quit
				}
				ElseIf (tExists=1) {
					If (pReplace) {
						Write:pVerbose "Replacing: "_tForceItemName_$S(tForceItemName=tItem.fullName:"",1:" with imported item "_tItem.fullName)
						Set tSC = ..%DeleteFolderItem(tForceItemName)
						If $$$ISERR(tSC) Quit
					}
					Else {
						Set tSC = $$$ERROR($$$GeneralError,"Folder item with given name "_tForceItemName_" already exists; not replacing"_$S(tForceItemName=tItem.fullName:"",1:" with imported item "_tItem.fullName))
						Quit
					}
				}
				Else {
					Write:pVerbose "Importing to "_tForceItemName_$S(tForceItemName=tItem.fullName:"",1:" from imported item "_tItem.fullName),!
				}
				Set tSC = tItem.%OnAfterImport(tForceItemName)
				If $$$ISERR(tSC) Quit

				Set tItem.fullName=tForceItemName

				Set tSC = tItem.%Save()
				If $$$ISERR(tSC) Quit

				Set pItemsLoaded($I(pItemsLoaded)) = tItem.fullName

				// JMD1211 register the recent item
				Set tType = $P(tItem.fullName,".",2)
				Set tSC = ##class(%DeepSee.UserLibrary.Utils).%RegisterRecentItem(tType,tItem.fullName)
				If $$$ISERR(tSC) Quit
			}
		}
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If ($$$ISERR(tSC)&&pVerbose) {
		Write !
		Do $System.Status.DisplayError(tSC)
	}
	Quit tSC
}

/// Import a folder item definition from the Contents XData block of the given class.<br/>
/// If <var>pReplace</var> is true, replace an existing item with the same name.<br/>
/// If <var>pVerbose</var> is true, write status to the console.<br/>
ClassMethod %ImportContainer(pClass As %String = "", pReplace As %Boolean = 0, pVerbose As %Boolean = 1) As %Status
{
	Set tSC = $$$OK
	Try {
		Kill %objlasterror

		Set tClassDef = ##class(%Dictionary.ClassDefinition).%OpenId(pClass)
		If '$IsObject(tClassDef) {
			Set tSC = $$$ERROR($$$GeneralError,"Class not found: ",pClass)
			Quit
		}
		
		#; find XDATA block named Contents
		Set tIndex = tClassDef.XDatas.FindObjectId(pClass_"||Contents")

		If (tIndex '= "") {
			#; get XDATA as stream
			Set tStream = tClassDef.XDatas.GetAt(tIndex).Data
			Do tStream.Rewind()

			If (tStream.Size > 0) {
				// Create an instance of %XML.Reader
				Set tReader = ##class(%XML.Reader).%New()
	
				// Begin processing of the file
				Set tSC = tReader.OpenStream(tStream)
				If $$$ISERR(tSC) Quit

				// Associate possible class names with their XML element names
				Set tSC = ..%GetFolderItemClasses(.tClasses)
				If $$$ISERR(tSC) Quit

				Set n = $O(tClasses(""))
				While (n'="") {
					Set tClassName = $LG(tClasses(n),1)
					Set tXMLName = $LG(tClasses(n),2)
					Do tReader.Correlate(tXMLName,tClassName)
					Set n = $O(tClasses(n))
				}

				// Read objects from xml file
				While (tReader.Next(.tItem,.tSC)) {
					Set tExists = ..%FolderItemExists(tItem.fullName)
					If (tExists=2) {
						Set tSC = $$$ERROR($$$GeneralError,"Folder item with given name already exists and you do not have permission to replace it: "_tItem.fullName)
						Quit
					}
					ElseIf (tExists=1) {
						If (pReplace) {
							Write:pVerbose "Replacing: ",tItem.fullName,!
							Set tSC = ..%DeleteFolderItem(tItem.fullName)
							If $$$ISERR(tSC) Quit
						}
						Else {
							Set tSC = $$$ERROR($$$GeneralError,"Folder item with given name already exists: "_tItem.fullName)
							Quit
						}
					}
					Else {
						Write:pVerbose "Importing: ",tItem.fullName,!
					}

					// JMD1202: invoke callback
					Set tSC = tItem.%OnAfterImport()
					If $$$ISERR(tSC) Quit

					Set tSC = tItem.%Save()
					If $$$ISERR(tSC) Quit

					// JMD1211 register the recent item
					Set tType = $P(tItem.fullName,".",2)
					Set tSC = ##class(%DeepSee.UserLibrary.Utils).%RegisterRecentItem(tType,tItem.fullName)
					If $$$ISERR(tSC) Quit
				}
			}
		}
		If $$$ISERR(tSC) Quit
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If ($$$ISERR(tSC)&&pVerbose) {
		Write !
		Do $System.Status.DisplayError(tSC)
	}
	Quit tSC
}

/// Diagnostic method. Display the contents of a folder item to the console.
ClassMethod %Dump(pFolderItemName As %String = "") As %Status
{
	Set tSC = $$$OK
	Try {
		Set tItem = ..%OpenFolderItem(pFolderItemName,.tSC)
		If $$$ISERR(tSC) Quit

		If '$IsObject(tItem) {
			Write "Unable to find item: ",pFolderItemName,!
			Quit
		}

		Set tSC = tItem.%Dump()
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		Do $System.Status.DisplayError(tSC)
	}
	Quit tSC
}

/// Does the current user have "WRITE" access to a folder?
ClassMethod %CanWriteToFolder(pFolderName As %String) As %Boolean
{
	Set tWrite = 1

	Set tFolder = ##class(%DeepSee.UserLibrary.Utils).%FindFolder(pFolderName)
	If $IsObject(tFolder) {
		Set tResource = tFolder.%GetResource()
		If ((tResource'="") && '$System.Security.Check(tResource,"WRITE")) {
			Set tWrite = 0
		}
	}
	Quit tWrite
}

}
