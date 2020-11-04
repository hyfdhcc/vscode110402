/// A version of the JSON provider that can use an MDX query or the full name of a stored pivot table to supply data that is served
/// to the client in JSON format. This can be used in the same manner as the 
/// <class>jsonProvider</class> component.<br/>
/// For example, placing this within your page definition:
/// <example language="xml!fragment">
/// <jsonMDXProvider id="mdxProvider" mdxQuery="SELECT FROM HOLEFOODS"/>
/// </example>
/// would cause the given MDX statement to execute when the page is requested and the results of the
/// query to be written to the page in JSON format:
/// <example language="javascript">
/// o.content = {
/// 		"AxesInfo": {
/// 		},
/// 		"Info": {
/// 			"ColCount":0,
/// 			"Cube":"HOLEFOODS",
/// 			"CubeKey":"HOLEFOODS",
/// 			"Error": {
/// 				"ErrorCode":"",
/// 				"ErrorMessage":""
/// 			},
/// 			"ListingSource":"",
/// 			"MDXText":"SELECT FROM HOLEFOODS",
/// 			"QueryKey":"en558256763",
/// 			"QueryType":"SELECT",
/// 			"ResultsComplete":1,
/// 			"RowCount":0,
/// 			"TimeStamp":"2015-05-12 13:23:58"
/// 		},
/// 		"Result": {
/// 			"Axes":[
/// 			],
/// 			"CellData":[ {
/// 					"%ID":"Cell_1",
/// 					"Format":"",
/// 					"ValueFormatted":"1,000",
/// 					"ValueLogical":1000
/// 				}
/// 			]
/// 		}
/// 	};
/// </example>
/// The JSON content object will contain three major branches AxesInfo, Info, and Result, each of which contain an array of objects that
/// correspond to query structure, metadata, and actual results as returned by the MDX statement.<br/>
/// If you need more control over the MDX query, you can use the <property>OnGetMDX</property> 
/// callback method.<br/>
/// 
/// This component ignores all of the data source callback methods inherited from the <class>jsonProvider</class> class.
Class %ZEN.Auxiliary.jsonMDXProvider Extends (%ZEN.Auxiliary.altJSONProvider, %DeepSee.Component.pivotTable)
{

/// This specifies a callback method that returns an MDX query (string) that will drive this
/// provider. This is identical in behavior to (and replaces) the <property>mdx</property> property.
/// The method can make it easier to create queries based on parameter values or search criteria
/// passed via the <property>criteria</property> property.
Property OnGetMDX As %ZEN.Datatype.delegator(FORMALSPEC = "&pParameters:%String,&pMDX:%String,pCriteria:%ZEN.proxyObject,&pPagingInfo:%String", RETURNTYPE = "%Status");

/// (optional) Name of Server-side callback method to call to create 
/// a <class>%DeepSee.ResultSet</class> object.<br>
/// This must be the name of a server-only method in the page
/// class that contains this component.
Property OnCreateResultSet As %ZEN.Datatype.delegator(FORMALSPEC = "*tSC:%Status,&pParms:%String", RETURNTYPE = "%DeepSee.ResultSet");

/// (optional) Name of Server-side callback method to call to execute the
/// <class>%DeepSee.ResultSet</class> object.<br>
/// This must be the name of a server-only method in the page
/// class that contains this table pane.
Property OnExecuteResultSet As %ZEN.Datatype.delegator(FORMALSPEC = "pRS:%DeepSee.ResultSet,*tSC:%Status,&pParms:%String", RETURNTYPE = "%Boolean");

/// If the provider is using server-side data paging, this is the total number of records.
Property recordCount As %ZEN.Datatype.integer;

/// If defined, the provider can generate JSON results from a stored pivot definition
Property pivotTable As %ZEN.Datatype.string;

/// If defined, the provider can generate JSON results from MDX query text
Property mdxQuery As %ZEN.Datatype.string;

/// If defined along with <property>cubeKey</property>, the provider can prepare a 
/// resultset of a query already in progress.
Property queryKey As %ZEN.Datatype.string;

/// If defined along with <property>queryKey</property>, the provider can prepare a 
/// resultset of a query already in progress.
Property cubeKey As %ZEN.Datatype.string;

/// Draw JSON output.
Method %DrawJSON() As %Status [ Internal ]
{
	Set tDrawJSONStatus = $$$OK		// Internal status to indicate if there was a code failure
	Set tSC = $$$OK					// Status which will report query problems back to the client
	
	// Initialize dynamic object for converting to JSON
	Set tResultOBJ = ..%ConstructNewDynamicObject()
	// Main branches
	Set tInfoBranch = ..%ConstructNewDynamicObject()
	Set tResultBranch = ..%ConstructNewDynamicObject()
	Set tAxesInfoBranch = ..%ConstructNewDynamicArray()		// DTB240 - Switch to array
	
	Try {
		// DTB - Call new method to perform the actual execution, whichever form it takes
		Set tSC = ..%Execute()
		If $$$ISERR(tSC)
		
		Set tRS = ..%ResultSet
		
		// Once we have a %DeepSee.ResultSet, construct a dynamic object to use for Drawing the JSON
		
		
		// === Construct the Info branch
		Set tQueryKey = tRS.%GetQueryKey()
		Set tInfoBranch.Error = ""		// DTB276 - Make sure the Error object is listed first
		Set tInfoBranch.TimeStamp = ""	// DTB276 - Make the timestamp appear early in the result - this will get set later
		Set tInfoBranch.ResultsComplete = (tRS.%GetStatus()=100)
		Set tInfoBranch.MDXText = tRS.%GetQueryText()
		Set tInfoBranch.QueryKey = tQueryKey
		Set tInfoBranch.CubeKey = tRS.%CubeKey
		Set tInfoBranch.QueryID = tRS.%CubeKey _ "||" _ tQueryKey
		Set tInfoBranch.Cube = tRS.%GetCubeName()		// DTB210 - Need the original cube name for filters
		Set tInfoBranch.Pivot = ..pivotTable			// DTB239 - Return the pivot if it is defined
		
		// If there is an error at this point, do not process further
		If $$$ISERR(tSC) Quit
		
		
		// Determine type
		Set tQueryOBJ = tRS.%GetQuery()
		Set tInfoBranch.QueryType = tQueryOBJ.queryType
		Set tInfoBranch.ListingSource = tQueryOBJ.%listingSource 
		
		// Find axis sizes. The slicer size may be zero but the axis sizes must be >= 1
		Set tAxisSize(0) = tRS.%GetAxisSize(0)
		Set tAxisSize(1) = tRS.%GetColumnCount()		// DTB299
		Set tAxisSize(2) = tRS.%GetRowCount()			// DTB299
		
		// Report axis sizes in the Info branch
		Set tInfoBranch.ColCount = tAxisSize(1)
		Set tInfoBranch.RowCount = tAxisSize(2)
		
		
		
		// === Construct the AxesInfo branch
		
		// +DTB240
		For a = 0:1:2 {
			Set tAxisInfo = ..%ConstructNewDynamicObject()
			If a>0 {
				Set tAxisInfo.%ID = "AxisInfo_"_a
				Set tAxis = tQueryOBJ.axes.GetAt(a)
				Set tAxisInfo.Text = $S($IsObject(tAxis):tAxis.%ToString(),1:"[%SEARCH]")
			}
			Else {
				Set tAxisInfo.%ID = "SlicerInfo"
				Set tAxisInfo.Text = $S($IsObject(tQueryOBJ.slicer):tQueryOBJ.slicer.%ToString(),1:"")
			}
			Do tAxesInfoBranch.%Push(tAxisInfo)
		}
		// -DTB240
		
		
		
		// === Construct the Result branch
		
		If tQueryOBJ.queryType="SELECT" {
			
			// + WAL159
			Set tSC = tRS.%GetAxisMembers(1)
			If $$$ISERR(tSC) Quit
			Set tSC = tRS.%GetAxisMembers(2)
			If $$$ISERR(tSC) Quit
			Set tAxisInfoKey = $O(^||DeepSee.AxisMembers(""))
			// - WAL159
			
			// Send the results back as an MDX result
			// Build the axis labels
			Set tAxesArray = ..%ConstructNewDynamicArray()
			Set tAxisCount = tRS.%GetAxisCount()
			For a = 1:1:tAxisCount {
				// Process each axis
				Kill tAxis 
				Set tAxis = ..%ConstructNewDynamicObject()
				Set tAxis.%ID = "Axis_"_(a)
				
				// + WAL159
				Merge tAxisMemberInfo = ^||DeepSee.AxisMembers(tAxisInfoKey,a) // + WAL159
				Kill ^||DeepSee.AxisMembers(tAxisInfoKey,a)
				// - WAL159
				
				Set tTupleArray = ..%ConstructNewDynamicArray()
				Set tTupleInfoArray = ..%ConstructNewDynamicArray() // + WAL166
				For t = 1:1:tAxisSize(a) {
					// Process each axis coordinate
					Kill tTuple
					Set tTuple = ..%ConstructNewDynamicObject()
					Set tTuple.%ID = "Tuple_"_t
					
					Set tTupleInfo = ..%ConstructNewDynamicObject()
					Set tTupleInfo.%ID = "TupleInfo_"_t
					
					Set tMemberArray = ..%ConstructNewDynamicArray()
					Do tRS.%GetOrdinalLabel(.tLabels,a,t,.tLabelFormat)
					
					Set tMemberInfoArray = ..%ConstructNewDynamicArray() // + WAL159
					
					Set tFormats(a,t) = tLabelFormat		// Preserve format from this axis
					
					Set tLabelIdx = $O(tLabels(""),1,tLabel)
					
					// + WAL159
					Merge tTupleMemberInfo = tAxisMemberInfo(t)
					Set tMemberInfoIdx = $O(tTupleMemberInfo(""),-1,tMemberInfoList)
					// - WAL159
					
					// + WAL166 -- add child info
					Set tChildSpec = ""
					Set tSC = ##class(%DeepSee.Utils).%GetChildSpec(.tTupleMemberInfo,tInfoBranch.Cube,a,.tChildSpec)
					Set tTupleInfo.childSpec = tChildSpec
					// - WAL166
					
					While tLabelIdx'="" {
						// Add each member to the axis coordinate tuple
						Set tMember = ..%ConstructNewDynamicObject()
						Set tMember.%ID = "Member_"_tLabelIdx
						
						Set tMember.Name = tLabels(tLabelIdx)
						
						Do tMemberArray.%Push(tMember)
						
						// + WAL159 -- Include info about each member so we can assemble drilldown/drillthrough queries
						// $LB(nodeno,text,dimName,hierName,levelName,memberKey,dimNo,hierNo,levelNo,[aggregate],[orspec])
						If ($G(tMemberInfoList)'="") {
							Set tMemberInfo = ..%ConstructNewDynamicObject()
							Set tMemberInfo.%ID = "MemberInfo_"_tLabelIdx
							Set tMemberInfo.nodeNo = $LG(tMemberInfoList,1)
							Set tMemberInfo.text = $LG(tMemberInfoList,2)
							Set tMemberInfo.dimName = $LG(tMemberInfoList,3)
							Set tMemberInfo.hierName = $LG(tMemberInfoList,4)
							Set tMemberInfo.levelName = $LG(tMemberInfoList,5)
							Set tMemberInfo.memberKey = $LG(tMemberInfoList,6)
							Set tMemberInfo.dimNo = $LG(tMemberInfoList,7)
							Set tMemberInfo.hierNo = $LG(tMemberInfoList,8)
							Set tMemberInfo.levelNo = $LG(tMemberInfoList,9)
							Set tMemberInfo.aggregate = $LG(tMemberInfoList,10)
							Set tMemberInfo.orSpec = $LG(tMemberInfoList,11)
							Do tMemberInfoArray.%Push(tMemberInfo)
						}
						Set tMemberInfoIdx = $O(tTupleMemberInfo(tMemberInfoIdx),-1,tMemberInfoList)
						// - WAL159
						
						Set tLabelIdx = $O(tLabels(tLabelIdx),1,tLabel)
					}	
					Set tTuple.Members = tMemberArray
					Set tTuple.MemberInfo = tMemberInfoArray // + WAL159
					
					Do tTupleArray.%Push(tTuple)
					Do tTupleInfoArray.%Push(tTupleInfo) // + WAL166
				}
				Set tAxis.Tuples = tTupleArray
				Set tAxis.TupleInfo = tTupleInfoArray // + WAL166
				
				Do tAxesArray.%Push(tAxis)
			}
			Set tResultBranch.Axes = tAxesArray
		
			// Build the CellData
			Set tCellDataArray = ..%ConstructNewDynamicArray()
			Set tCellCount = tAxisSize(1)*tAxisSize(2)
			
			Set tColSize = $S(+tAxisSize(1):tAxisSize(1),1:1)
			Set tRowSize = $S(+tAxisSize(2):tAxisSize(2),1:1)
			
			For r=1:1:tRowSize {
				For c=1:1:tColSize {
					Set tCell = ..%ConstructNewDynamicObject()
					Set tCell.%ID = "Cell_"_((r-1)*tColSize + c)
					
					Set tCellValue = tRS.%GetOrdinalValue(c,r)
					
					Set tCell.ValueLogical = tCellValue
					
					// Try Row format first. If Column format also exists, it overrides
					Set tCellFormat = $G(tFormats(2,r))
					If $D(tFormats(1,c)) && ($G(tFormats(1,c))'="") {
						Set tCellFormat = $G(tFormats(1,c))
					}
					
					Set tCell.Format = tCellFormat
					Set tCell.ValueFormatted = tRS.%FormatNumber(tCellValue,tCellFormat)
					
					Do tCellDataArray.%Push(tCell)
				}
			}
			Set tResultBranch.CellData = tCellDataArray	
		}		
		ElseIf tQueryOBJ.queryType="DRILLTHROUGH" {
			// DTB209 - Dispatch to a jsonSQLProvider to create the result branch
			Set tSC = tRS.%GetListingResultSet(.tListingRS,.tFieldList)
			Set tInfoBranch.RowCount = tListingRS.%ROWCOUNT
			Set tInfoBranch.ColCount = tListingRS.%ResultColumnCount
			
			Set tSQLProvider = ##class(%ZEN.Auxiliary.jsonSQLProvider).%New()
			Set tSQLProvider.sql = tRS.%GetListingSQL()
			Set tSC = tSQLProvider.%WriteJSONStreamFromSQL(.tJSONstream,tSQLProvider.sql,,,1,tSQLProvider)
			If $$$ISERR(tSC) Quit
			
			Set tSC = ..%ConvertJSONToObject(.tJSONstream,"%DynamicAbstractObject",.tSQLListingObj)		// DTB212 - Allow default rather than hard-coding proxyObject
			If $$$ISERR(tSC) Quit
			
			// This new object is the entire result
			Set tResultBranch = tSQLListingObj
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError,"Unknown query type: "_tQueryOBJ.queryType)	
			Quit
		}
	}
	Catch ex {
		Set tCatchSC = ex.AsStatus()
	}
	If $D(tCatchSC) Quit tCatchSC
	
	// Construct information about the return status for communication back to the client
	Set tInfoBranch.Error = ..%StatusToDynamicObject(tSC)
	
	// Preserve the time (ODBC format) the server has completed generating this object
	Set tInfoBranch.TimeStamp = $ZDT($H,3)

	// Send anything that was successful back to the client
	// DTB276 - Order of properties in JSON output is the same as the order they are defined,
	// provide information before the data
	Set tResultOBJ.Info = tInfoBranch
	Set tResultOBJ.AxesInfo = tAxesInfoBranch
	Set tResultOBJ.Result = tResultBranch
	
	// Convert the resultset representation object to JSON
	Set tDrawJSONStatus = ..%ObjectToJSON(tResultOBJ)		// DTB212 - Use generic API for compatibility with both %ZEN.proxyObject and DAO objects
	
	Quit tDrawJSONStatus
}

/// Execute the MDX query or pre-defined pivot table
Method %Execute() As %Status
{
	
	// Method added by DTB226
	Set tSC = $$$OK
	Try {
		// convert parameters to local array
		Set key = ..parameters.Next("")
		While (key'="") {
			Set value = ..parameters.GetAt(key).value
			Set tParms(key) = $$$ZENVAL(value)
			Set key = ..parameters.Next(key)
		}
		
		// Source the ResultSet from either custom MDX or a stored pivot definition.
		If (..mdxQuery'="") {
			Set tMDX = ..mdxQuery		// This is equivalent to a "Manual" pivot
			
			If (..OnGetMDX '= "") {
				Set tSC = ..%OnGetMDX(.tParms,.tMDX)
				If $$$ISERR(tSC) {
					Write "null"
					Quit
				}
				Set ..mdxQuery = tMDX
			}
			
			Set tRS = ##class(%DeepSee.ResultSet).%New()
			
			If '$IsObject(tRS) {
				Write "null"
				Quit
			}

			Set tSC = tRS.%PrepareMDX(tMDX)
		}
		ElseIf (..pivotTable'="") {			
			// Add ".pivot" to the pivot name
			Set tDataSource = ..pivotTable
			If ($$$LOWER($E(tDataSource,*-5,*))'=".pivot") {
				Set tDataSource = tDataSource_".pivot"
			}

			// Open the saved pivot
			Set tPivotDef = ##class(%DeepSee.UserLibrary.Utils).%OpenFolderItem(tDataSource,.tStatus)
			If '$IsObject(tPivotDef) Quit
			
			// Copy saved pivot information to this provider
			set tSC = tPivotDef.%CopyToComponent($this)
			If $$$ISERR(tSC) Quit
			 
			// Get filter info
			Set tSC = ..%GetFilterInfo(.tFilterInfo,.tAdvancedFilters)
			If $$$ISERR(tSC) Quit
			
			// Call %CreateResultSet, which creates the MDX query
			Set tMDX = ""
			Set tRS = ..%CreateResultSet(.tSC, .tParms , .tFilterInfo , .tAdvancedFilters , .tMDX )
		}
		ElseIf ((..queryKey'="")&&(..cubeKey'="")) {
			Set tMDX =""
			Set tRS = ##class(%DeepSee.ResultSet).%New()
			
			Set tSC = tRS.%PrepareKey(..cubeKey,..queryKey)
			
			Set:$$$ISOK(tSC) tMDX = tRS.%GetQueryText()
		}
		Else {
			Set tSC = $$$ERROR($$$GeneralError,"No source defined for jsonMDXProvider")
			Quit
		}


		If '$IsObject(tRS) {
			// ERROR - no resultset!
			Set tSC = $$$ERROR($$$GeneralError,"No %DeepSee.ResultSet was created.")
			Quit
		}

		// Execute the ResultSet
		Set:$$$ISOK(tSC) tSC = tRS.%ExecuteAsynch(.tQueryKey,.tParms)
		Set ..%ResultSet = tRS
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Utility method to allow direct use of JSON from a non-ZEN context (such as a CSP page).<br/>
/// The JSON notation is written out to the current device.
/// <var>pVar</var> is the optional name of the client-side javascript variable that refers to the JSON notation.<br/>
/// <var>pMDX</var> is the MDX statement that is executed and provides the JSON content. Supported query types are SELECT, DRILLTHOUGH, DRILLFACTS.<br/>
/// From a CSP page, you could invoke the method as follows:<br/>
/// <example language="CSP">
/// #(##class(%ZEN.Auxiliary.jsonMDXProvider).%WriteJSONFromMDX("json","SELECT NON EMPTY [Channel].[H1].[Channel Name].Members ON 0 FROM [HOLEFOODS]"))#
/// </example>
/// <var>pReturnStatus</var> controls whether the method will return the execution status. By default this is set to 0 to quit an empty string for
/// compatibility with the #()# syntax.<br>
/// <var>tProvider</var> allows parameters to be passed in by creating an instance of the jsonMDXProvider and passing it into the method. The value of
/// <var>pMDX</var> will be ignored in this case.<br/>
ClassMethod %WriteJSONFromMDX(pVar As %String = "", pMDX As %String, pReturnStatus As %Boolean = 0, tProvider As %ZEN.Auxiliary.jsonMDXProvider = "") As %String
{
	// Method added by DTB209
	Set tSC = $$$OK
	Try {
		if tProvider="" {
			Set tProvider = ##class(%ZEN.Auxiliary.jsonMDXProvider).%New()
			Set tProvider.mdxQuery = pMDX
		}
		If (pVar'="") {
			// variable to hold the json object
			Write "var "_pVar_"="
		}

		// emit content of the object
		Set tSC = tProvider.%DrawJSON()

		If (pVar'="") {
			Write ";",!
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit:pReturnStatus tSC
	
	If $$$ISERR(tSC) {
		&js<alert('#($ZCVT($System.Status.GetErrorText(tSC),"O","JS"))#');>
	}

	// return an empty string to be #()# compatible
	Quit ""
}

/// Utility method to allow JSON output generated by the MDX query defined in <var>pMDX</var>
/// to be written to the stream supplied in <var>pStream</var> from a general non-ZEN context.
/// Note that <var>pStream</var> will be created if not supplied, hence the ByRef designation.<br/>
/// <var>pRewindStream</var> controls whether the stream should be rewound after the data is written to it.<br/>
/// <var>tProvider</var> allows parameters to be passed in by creating an instance of the jsonMDXProvider and passing it into the method. The value of
/// <var>pMDX</var> will be ignored in this case.<br/>
ClassMethod %WriteJSONStreamFromMDX(ByRef pStream As %Stream.Object, pMDX As %String, pRewindStream As %Boolean = 0, tProvider As %ZEN.Auxiliary.jsonMDXProvider = "") As %Status [ ProcedureBlock = 0 ]
{
	// Method added by DTB213
	New %ISCJSONStream, tSC, ex, tInitIO, tRedirected, tWasRedirected, tOldMnemonic
	Set tSC = $$$OK
	Set tRedirected = 0
	Try {
		Set tWasRedirected = 0
		Set tOldMnemonic = ""

		Set:'$IsObject($G(pStream)) pStream=##class(%Stream.TmpBinary).%New()

		Set tInitIO = $IO
		Set tWasRedirected = ##class(%Library.Device).ReDirectIO()
		Set tOldMnemonic = ##class(%Library.Device).GetMnemonicRoutine()
		Set %ISCJSONStream = pStream
		Use tInitIO::("^"_$ZNAME)
		Set tRedirected = 1
		Do ##class(%Library.Device).ReDirectIO(1)
		
		Set tSC = ..%WriteJSONFromMDX(,pMDX,1,tProvider)

	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	If tRedirected && ##class(%Library.Device).ReDirectIO(0) {
		Use tInitIO
	}
	If ($get(tOldMnemonic) '= "") {
		Set tOldMnemonic = "^"_tOldMnemonic
		Use tInitIO::(tOldMnemonic)
	}
	If $get(tWasRedirected) {
		Do ##class(%Library.Device).ReDirectIO(1)
	}
	If pRewindStream && $$$ISOK(tSC) {
		Do pStream.Rewind()
	}
	Quit tSC
}

/// Utility method to allow direct use of JSON from a non-ZEN context (such as a CSP page).<br/>
/// The JSON notation is written out to the current device.
/// <var>pVar</var> is the optional name of the client-side javascript variable that refers to the JSON notation.<br/>
/// <var>pPivot</var> is the full name of a stored pivot that is executed and provides the JSON content.<br/>
/// From a CSP page, you could invoke the method as follows:<br/>
/// <example language="CSP">
/// #(##class(%ZEN.Auxiliary.jsonMDXProvider).%WriteJSONFromPivot(,"Use In Dashboards/ProductInfo"))#
/// </example>
/// <var>pReturnStatus</var> controls whether the method will return the execution status. By default this is set to 0 to quit an empty string for
/// compatibility with the #()# syntax.<br>
/// <var>tProvider</var> allows parameters to be passed in by creating an instance of the jsonMDXProvider and passing it into the method. The value of
/// <var>pPivot</var> will be ignored in this case.<br/>
ClassMethod %WriteJSONFromPivot(pVar As %String = "", pPivot As %String, pReturnStatus As %Boolean = 0, tProvider As %ZEN.Auxiliary.jsonMDXProvider = "") As %String
{
	// Method added by DTB209
	Set tSC = $$$OK
	Try {
		if tProvider="" {
			Set tProvider = ##class(%ZEN.Auxiliary.jsonMDXProvider).%New()
			Set tProvider.pivotTable = pPivot
		}
		If (pVar'="") {
			// variable to hold the json object
			Write "var "_pVar_"="
		}

		// emit content of the object
		Set tSC = tProvider.%DrawJSON()

		If (pVar'="") {
			Write ";",!
		}
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit:pReturnStatus tSC
	
	If $$$ISERR(tSC) {
		&js<alert('#($ZCVT($System.Status.GetErrorText(tSC),"O","JS"))#');>
	}

	// return an empty string to be #()# compatible
	Quit ""
}

/// Utility method to allow JSON output generated by the stored pivot table defined in <var>pPivot</var>
/// to be written to the stream supplied in <var>pStream</var> from a general non-ZEN context.
/// Note that <var>pStream</var> will be created if not supplied, hence the ByRef designation.<br/>
/// <var>pRewindStream</var> controls whether the stream should be rewound after the data is written to it.<br/>
/// <var>tProvider</var> allows parameters to be passed in by creating an instance of the jsonMDXProvider and passing it into the method. The value of
/// <var>pPivot</var> will be ignored in this case.<br/>
ClassMethod %WriteJSONStreamFromPivot(ByRef pStream As %Stream.Object, pPivot As %String, pRewindStream As %Boolean = 0, tProvider As %ZEN.Auxiliary.jsonMDXProvider = "") As %Status [ ProcedureBlock = 0 ]
{
	// Method added by DTB213
	New %ISCJSONStream, tSC, ex, tInitIO, tRedirected, tWasRedirected, tOldMnemonic
	Set tSC = $$$OK
	Set tRedirected = 0
	Try {
		Set tWasRedirected = 0
		Set tOldMnemonic = ""

		Set:'$IsObject($G(pStream)) pStream=##class(%Stream.TmpBinary).%New()

		Set tInitIO = $IO
		Set tWasRedirected = ##class(%Library.Device).ReDirectIO()
		Set tOldMnemonic = ##class(%Library.Device).GetMnemonicRoutine()
		Set %ISCJSONStream = pStream
		Use tInitIO::("^"_$ZNAME)
		Set tRedirected = 1
		Do ##class(%Library.Device).ReDirectIO(1)
		
		Set tSC = ..%WriteJSONFromPivot(,pPivot,1,tProvider)

	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	If tRedirected && ##class(%Library.Device).ReDirectIO(0) {
		Use tInitIO
	}
	If ($get(tOldMnemonic) '= "") {
		Set tOldMnemonic = "^"_tOldMnemonic
		Use tInitIO::(tOldMnemonic)
	}
	If $get(tWasRedirected) {
		Do ##class(%Library.Device).ReDirectIO(1)
	}
	If pRewindStream && $$$ISOK(tSC) {
		Do pStream.Rewind()
	}
	Quit tSC
}

/// Invoke the <property>OnGetMDX</property> callback.
Method %OnGetMDX(ByRef pParms, ByRef pMDX) As %Status [ Internal ]
{
	Set tSC = $$$OK
	Try {
		Set pObject = ""
		// pass property values to callback
		Set tPagingInfo("pageSize") = ..pageSize
		Set tPagingInfo("currPage") = ..currPage
		Set tPagingInfo("recordCount") = ..recordCount

		If (..%containerClass'="") {
			Set tSC = $classmethod(..%containerClass,..OnGetMDX,.pParms,.pMDX,..criteria,.tPagingInfo)
		}
		Else {
			Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
			If ($IsObject(tHost) && (..OnGetMDX '= "")) {
				Set tSC = $method(tHost,..OnGetMDX,.pParms,.pMDX,..criteria,.tPagingInfo)
			}
		}

		// update properties
		Set ..pageSize = $G(tPagingInfo("pageSize"))
		Set ..currPage = $G(tPagingInfo("currPage"))
		Set ..recordCount = $G(tPagingInfo("recordCount"))

		// always set to "array" in this case
		Set ..contentType = "array"
	}
	Catch(ex) {
		Set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// This callback is invoked when a provider is about to
/// create a result set.<br/>
/// If the callback creates a <class>%DeepSee.ResultSet</class> object and returns it
/// via <var>pRS</var>, then the pivot table will use this result set to display results.
Method %OnCreateResultSet(Output pRS As %DeepSee.ResultSet, ByRef pParms) As %Status
{
	Set tSC = $$$OK
	Try {
		Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
		If ($IsObject(tHost) && (..OnCreateResultSet '= "")) {		
			Set pRS = $zobjmethod(tHost,..OnCreateResultSet,.tSC,.pParms)
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
		Set pRS = ""
	}

	Quit tSC
}

/// Internal method.<br>
/// Subclasses can override this to execute the <class>%ResultSet</class> object used to
/// by this component.<br>
/// Return true (1) if the result set has been executed.<br>
/// The default implementation is to call the page method specified
/// by the <property>onExecuteResultSet</property> property, if defined.
Method %OnExecuteResultSet(pRS As %DeepSee.ResultSet, Output tSC As %Status, ByRef pParms) As %Boolean
{
	Set $ZT="Trap"
	Set tSC = $$$OK
	Set tRet = 0

	Set tHost = $S($IsObject(..composite):..composite,1:$G(%page))
	If ($IsObject(tHost) && (..OnExecuteResultSet '= "")) {
		Set tRet = $zobjmethod(tHost,..OnExecuteResultSet,pRS,.tSC,.pParms)
	}
Done
	Quit tRet
Trap
	Set $ZT=""
	Set tRet = 0
	Goto Done
}

/// Constructor for a dynamic array.
Method %ConstructNewDynamicArray() As %DynamicArray
{
	//Quit ##class(%ListOfObjects).%New()
	Quit ##class(%DynamicArray).%New()
}

/// Constructor for a dynamic object.
Method %ConstructNewDynamicObject() As %DynamicObject
{
	//Quit ##class(%ZEN.proxyObject).%New()
	Quit ##class(%DynamicObject).%New()
}

/// Convert a %Status object into an object that can be emitted as JSON
ClassMethod %StatusToDynamicObject(pStatus As %Status) As %RegisteredObject
{
	// Method added by DTB226
	Set tErrorOBJ = $$$NULLOREF
	Try {
		If $$$ISOK(pStatus) Quit
		
		Set tProvider = ##class(%ZEN.Auxiliary.jsonMDXProvider).%New()
		Set tErrorOBJ = tProvider.%ConstructNewDynamicObject()
		Set tErrorOBJ.ErrorCode = $system.Status.GetErrorCodes(pStatus)
		Set tErrorOBJ.ErrorMessage = $system.Status.GetErrorText(pStatus)
	}
	Catch ex {
		Set tErrorOBJ = $$$NULLOREF
	}
	Quit tErrorOBJ
}

Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1 ]
{
	// DTB - Need these for transferring saved pivot definition info.
	Set ..rowAxisOptions = ##class(%DeepSee.Component.pivotLevel).%New()
	Set ..rowAxisOptions.filterEnabled = 0
	Do:$IsObject($G(%page)) %page.%AddComponent(..rowAxisOptions)

	Set ..columnAxisOptions = ##class(%DeepSee.Component.pivotLevel).%New()
	Set ..columnAxisOptions.filterEnabled = 0
	Do:$IsObject($G(%page)) %page.%AddComponent(..columnAxisOptions)

	Quit ##super($G(initvalue))
}

ClassMethod redirects() [ Internal, Private, ProcedureBlock = 0 ]
{
	Quit
#; Public entry points for redirection - any changes made here should
#; also be reflected in redirects() in the jsonProvider and jsonSQLProvider classes
	;; Extra QUIT added to jsonMDXProvider to ensure tags are generated in this routine
	Quit

wstr(s) Do %ISCJSONStream.Write(s) Quit
wchr(a) Do %ISCJSONStream.Write($char(a)) Quit
wnl Do %ISCJSONStream.Write($char(13,10)) Quit
wff Do %ISCJSONStream.Write($char(13,10,13,10)) Quit
wtab(n) New chars Set $piece(chars," ",n+1)="" Do %ISCJSONStream.Write(chars) Quit
rstr(len,time) Quit ""
rchr(time) Quit ""
}

}
