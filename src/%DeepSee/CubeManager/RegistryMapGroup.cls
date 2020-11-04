Include (%DeepSee, %occErrors)

/// A node representing the named cube groupings within the registry
Class %DeepSee.CubeManager.RegistryMapGroup Extends (%RegisteredObject, %XML.Adaptor)
{

/// Reference to the parent map
Relationship Map As %DeepSee.CubeManager.RegistryMap [ Cardinality = one, Inverse = Groups ];

/// The collection of cubes that are a part of this group
Relationship Cubes As %DeepSee.CubeManager.RegistryMapCube [ Cardinality = many, Inverse = Group ];

/// Display Name for the group.
Property GroupName As %ZEN.Datatype.string;

Property IsRegistered As %ZEN.Datatype.boolean [ InitialExpression = 0 ];

/// This group is checked for validity and the result is stored in this property.
Property IsValid As %ZEN.Datatype.boolean;

/// GROUP DEFAULT - Plan for how the cube is to be managed by the build/synch tasks.
Property UpdatePlan As %String(DISPLAYLIST = ",Manual,Build Only,Build and Synch,Synch Only", VALUELIST = ",Manual,Build,BuildSynch,Synch") [ InitialExpression = "BuildSynch" ];

/// GROUP DEFAULT - <var>Disabled</var> = 1 will block all automatic updates while leaving the 
/// cube visible in the registry.
Property Disabled As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// GROUP DEFAULT - Indicates how often the cube is to be built, in units of
/// <var>BuidTimeUnit</var> 
Property BuildFrequency As %Integer [ InitialExpression = 1 ];

/// GROUP DEFAULT - Base unit of time for cube builds. 
Property BuildTimeUnit As %String(DISPLAYLIST = ",Day,Week,Month", VALUELIST = ",Day,Week,Month") [ InitialExpression = "Week" ];

/// If week is selected for the BuildTimeUnit, this will allow the user to pick which day
/// of the week the build should take place.
Property BuildDayOfWeek As %String(DISPLAYLIST = ",Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday", VALUELIST = ",1,2,3,4,5,6,7") [ InitialExpression = "1" ];

/// If Month is selected as the BuildTimeUnit, this will allow the user to pick which day
/// of the month this build should take place.
Property BuildDayOfMonth As %Integer(MAXVAL = 31, MINVAL = 1) [ InitialExpression = 1 ];

/// GROUP DEFAULT - Indicates how often the cube is to be synched, in units of
/// <var>SynchTimeUnit</var>
Property SynchFrequency As %Integer [ InitialExpression = 1 ];

/// GROUP DEFAULT - Base unit of time for cube synchs.
Property SynchTimeUnit As %String(DISPLAYLIST = ",Minute,Hour,Day", VALUELIST = ",Minute,Hour,Day") [ InitialExpression = "Day" ];

/// GROUP DEFAULT - Flag which allows the user to select whether the build executes
/// synchronously or asynchronously. Asynchronous build is the default.
Property BuildAsynch As %ZEN.Datatype.boolean [ InitialExpression = 1 ];

/// This callback automatically performs some of the property
/// settings as it is created for the RegistryMap
Method %OnNew(pRegGroupName = "") As %Status
{
	set tSC = $$$OK
	try {
		set ..GroupName = pRegGroupName
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// This method walks through all cubes contained in the group and 
/// checks to see if it should be updated.
/// Prior to running the synchronize, this method will run the cube's 
/// Pre-Synch Code if present.<br>
/// The cube will be built if any of these conditions are met:<br>
/// - The cube has not been built within the scheduled time period<br>
/// - It is the day of the week/month scheduled for the cube build<br>
/// - A cube is dependent on another cube that has been built in this cycle<br><br>
/// - The <var>pUpdateAll</var> flag is set to 1
ClassMethod BuildGroup(pGroupIndex = "", pAsync As %Boolean = 1, pVerbose As %Boolean = 1, pIndexOnly As %Boolean = 0, pMaxFacts As %Integer = 0, pTracking As %Boolean = 0, pUpdateAll = 0) As %Status
{
	Set tSC = $$$OK
	If (pGroupIndex = "") Quit $system.Status.Error($$$GeneralError,"No Group passed to BuildGroup()")
	Try {
		Set tMap = ##class(%DeepSee.CubeManager.Utils).BuildRegistryMap(.tSC,,1)
		If $$$ISERR(tSC) Quit
		Set tGroup = tMap.Groups.GetAt(pGroupIndex)
		
		If '##class(%DeepSee.CubeManager.Utils).IsValidGroup(tGroup,.tSC) {
			Quit
		}
		
		Set tCubeIndex=""
		For ii=1:1:tGroup.Cubes.Count() {
			Set tCube = tGroup.Cubes.GetNext(.tCubeIndex)
		
			If ( (tCube.UpdatePlan["Build") || pUpdateAll ) {
				// Find out if a build is due for this cube
				Set tLastUpdate = ##class(%DeepSee.CubeManager.Utils).GetLastUpdate(tCube.CubeKey,"build")
				
				If $$$UPPER(tCube.BuildTimeUnit) = "WEEK" {
					Set tDOWTest = ( $system.SQL.DAYOFWEEK(+$h) = tCube.BuildDayOfWeek )
					Set:'tLastUpdate tLastUpdate=1		// Prevent error in DATEDIFF("week",0,$H())
				}
				
				If $$$UPPER(tCube.BuildTimeUnit) = "MONTH" {
					Set tDOMTest = ( $system.SQL.DAYOFMONTH(+$h) = tCube.BuildDayOfMonth ) 
					If ( +$h = $system.SQL.LASTDAY(+$h) ) && ( $system.SQL.DAYOFMONTH(+$h) <  tCube.BuildDayOfMonth ) {
						// Special case: BuildDayOfMonth = 31 and the month only has 30 or 28 days 
						Set tDOMTest = 1
					}
				} 
				
				Set tScheduleTest = ( $system.SQL.DATEDIFF(tCube.BuildTimeUnit,tLastUpdate,$H) >= tCube.BuildFrequency )
			
				// If ANY of the above conditions are met, update the cube. Err on
				// the side of building too often.
				Set tUpdateCube = ( $G(tScheduleTest,0) ||
				                    $G(tDOWTest,0) || 
				                    $G(tDOMTest,0) || 
				                    $D(tMustUpdate(tCube.CubeKey)) )
				 						
				If (tUpdateCube||pUpdateAll) {
					Set tAsynch = tCube.BuildAsynch
					Set tSC = ##class(%DeepSee.CubeManager.Utils).BuildCube(tCube.CubeKey,tAsynch,pVerbose,pIndexOnly,pMaxFacts,pTracking)
					If $$$ISERR(tSC) Quit
					// If we updated one cube in the group, all cubes dependent
					// on this one should be updated
					For n=1:1:$L(tCube.DependentCubes,",") {
						Set tDependentCube = $P(tCube.DependentCubes,",",n)
						Set:tDependentCube'="" tMustUpdate(tDependentCube)=$G(tMustUpdate(tDependentCube))_
													$S($G(tMustUpdate(tDependentCube))="":"",1:",")_tCube.CubeKey
					}
					
					Set tPostBuildCode = tCube.PostBuildCode
					If tPostBuildCode'="" {
						set tSC = ##class(%DeepSee.CubeManager.Utils).ExecuteCustomCode(tPostBuildCode,tCube.CubeKey,"postbuild")
					}
					If $$$ISERR(tSC) Quit
				}
			}
			Else {
				// Check to see if cube dependencies indicated we should update.
				// If this cube was not registered for this action, log an error.
				Do:$D(tMustUpdate(tCube.CubeKey)) ##class(%DeepSee.Utils).%WriteToLog("BuildGroup","Cube dependency error - "_tCube.CubeKey_" is not build enabled but was triggered by "_tMustUpdate(tCube.CubeKey)_":"_$NAMESPACE)
			}
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		// This is usually run in the background, so record errors to the DeepSee Log
		Do ##class(%DeepSee.Utils).%WriteToLog("BuildGroup",$system.Status.GetErrorText(tSC)_":"_$NAMESPACE)
	}
	
	Quit tSC
}

/// This method walks through all cubes contained in the group and 
/// checks to see if it should be updated.<br>
/// The cube will be synchronized if either of these conditions are met:<br>
/// - the cube has not been synchronized within the scheduled time period<br>
/// - a cube is dependent on another cube that has been synchronized in this cycle<br>
/// - The <var>pUpdateAll</var> flag is set to 1<br>
/// and the Pre-Synchronization Code has not set the $$$AbortSynch token to 1 
ClassMethod SynchronizeGroup(pGroupIndex = "", pVerbose As %Boolean = 1, Output pFactsUpdated As %Integer, pUpdateAll = 0) As %Status
{
	Set tSC = $$$OK
	If pGroupIndex = "" Quit $system.Status.Error($$$GeneralError,"No Group passed to SynchronizeGroup()")
	Try {
		Set tMap = ##class(%DeepSee.CubeManager.Utils).BuildRegistryMap(.tSC,,1)
		If $$$ISERR(tSC) Quit
		Set tGroup = tMap.Groups.GetAt(pGroupIndex)
		
		If '##class(%DeepSee.CubeManager.Utils).IsValidGroup(tGroup,.tSC) {
			Quit
		}
		
		Set tMapBuildDateTimeStamp = $zd($H,3) _ " " _ tMap.CreateMapTimeStamp()
		
		// Check to see if a build is in progress for any of the cubes in this group.
		Set tSC = ..CheckGroupLocks(.tGroup,.tLocked)
		If $$$ISERR(tSC) Quit
		
		Set tCubeIndex=""
		Set pFactsUpdated = 0
		For ii=1:1:tGroup.Cubes.Count() {
			Set tCube = tGroup.Cubes.GetNext(.tCubeIndex)
			If tCube.UpdatePlan [ "Synch" {
				// Check if a synchronize is due for this cube
				Set tLastUpdate = ##class(%DeepSee.CubeManager.Utils).GetLastUpdate(tCube.CubeKey,"synch")
				
				Set tScheduleTest = ( $system.SQL.DATEDIFF(tCube.SynchTimeUnit,tLastUpdate,$H) >= tCube.SynchFrequency )		
				
				Set tDailySynchTest = ( tCube.SynchTimeUnit="Day" ) && 												// The cube is set to daily synch
										( $P($H,",",2) > $ZTH(tMap.BuildStartHour_":"_tMap.BuildStartMinute) ) &&   // Current time is in the build window
										( $system.SQL.DATEDIFF("ss",tLastUpdate,tMapBuildDateTimeStamp) > 0 )			// The cube has not synched in this build window
										
				
				// If ANY of these conditions are met, update the cube. Err on
				// the side of building too often.
				Set tUpdateCube = ( $G(tScheduleTest,0) || 
									$G(tDailySynchTest,0) ||
									$D(tMustUpdate(tCube.CubeKey)) ) 
				
				If ( tUpdateCube || pUpdateAll ) {
					// If any cube in this group is locked for building, exit
					If (tLocked) {
						Do ##class(%DeepSee.Utils).%WriteToLog("SynchGroup","Skipping Synch of " _ tGroup.GroupName _ " since its cubes are locked for building"_":"_$NAMESPACE)
						Quit	
					}
					
					// Run the presynch code for this cube if it exists
					Set tAbortSynch=0			// Re-enable synchronize for each cube
					Set tPreSynchCode = tCube.PreSynchCode
					If tPreSynchCode'="" {
						set tSC = ##class(%DeepSee.CubeManager.Utils).ExecuteCustomCode(tPreSynchCode,tCube.CubeKey,"presynch",.tAbortSynch)
					}
					If $$$ISERR(tSC) Quit
					
					If '$G(tAbortSynch) {
						Set tSC = ##class(%DeepSee.CubeManager.Utils).SynchronizeCube(tCube.CubeKey,pVerbose,.tFactsUpdated)
						If $$$ISERR(tSC) Quit
					
						set pFactsUpdated = pFactsUpdated + tFactsUpdated
						set pFactsUpdated(tCube.CubeKey) = tFactsUpdated
						
						// If we updated one cube in the group, all dependent cubes will be updated
						If +tFactsUpdated {
							For n=1:1:$L(tCube.DependentCubes,",") {
								Set tDependentCube = $P(tCube.DependentCubes,",",n)
								Set:tDependentCube'="" tMustUpdate(tDependentCube)=$G(tMustUpdate(tDependentCube))_
															$S($G(tMustUpdate(tDependentCube))="":"",1:",")_tCube.CubeKey
							}
						}
						
						// DTB030 - Run the postsynch code for this cube if it exists
						Set tPostSynchCode = tCube.PostSynchCode
						If tPostSynchCode'="" {
							set tSC = ##class(%DeepSee.CubeManager.Utils).ExecuteCustomCode(tPostSynchCode,tCube.CubeKey,"postsynch")
						}
						If $$$ISERR(tSC) Quit
					} 
					Else {
						Set pFactsUpdated(tCube.CubeKey) = "abort"
					}
				}
			}
			Else {
				// Check to see if cube dependencies indicated we should update.
				// If this cube was not registered for this action, log an error.
				Do:$D(tMustUpdate(tCube.CubeKey)) ##class(%DeepSee.Utils).%WriteToLog("SynchGroup","Cube dependency error - "_tCube.CubeKey_" is not synch enabled but was triggered by "_tMustUpdate(tCube.CubeKey)_":"_$NAMESPACE)
			}
		}
	}
	Catch ex {
		Set tSC = ex.AsStatus()
	}
	If $$$ISERR(tSC) {
		// This is usually run in the background, so record errors to the DeepSee Log
		Do ##class(%DeepSee.Utils).%WriteToLog("SynchGroup",$system.Status.GetErrorText(tSC)_":"_$NAMESPACE)
	}
	Quit tSC
}

ClassMethod CheckGroupLocks(pGroup As %DeepSee.CubeManager.RegistryMapGroup, pLocked As %String = "") As %Status [ Internal ]
{
	Set tSC = $$$OK
	try {
		For j=1:1:2 {
			// This hang is an attempt to ensure that we don't miss a lock by checking
			// during the window when the cube build is switching between cubes
			If (j=2) hang .1	
			Set tCubeIndex=""
			For i=1:1:pGroup.Cubes.Count() {
				Set tCube = pGroup.Cubes.GetNext(.tCubeIndex)
				Set tLockName = "^DeepSee.Build("""_tCube.CubeKey_""")"
				Set pLocked = ^$LOCK(tLockName,"OWNER")
				If (pLocked'="") {
					Set pLocked=1
					Quit
				}
			}
		}
	}
	catch Ex {
		Set tSC=Ex.AsStatus()	
	}
	Quit tSC
}

/// Convert this group object to array form. This will match the index arrays returned using the call<br>
/// <method>%DeepSee.CubeManager.Utils.GetCubeGroups</method>(.pGroups,.pCubes,.pBuildOrders)<br>
/// trimmed to the subset of only the cubes in this group
Method ToArray(ByRef pGroup, ByRef pCubes, ByRef pBuildOrders) As %Status
{
	kill pGroup,pCubes,pBuildOrders
	set tSC = $$$OK
	try {
		set tCubeIndex = ""
		for ii=1:1:..Cubes.Count() {
			set tCube = ..Cubes.GetNext(.tCubeIndex)
			Set tCubeKey = tCube.CubeKey
			If tCube.CustomBuildOrder'="" {
				Set tBuildOrder = tCube.CustomBuildOrder
			} Else {
				Set tBuildOrder = tCube.NaturalBuildOrder
			}
			
			set pGroup(..GroupName,tCubeKey) = tBuildOrder
			set pCubes(tCubeKey) = ..GroupName
			If $L(tCube.DependentCubes)>0 {
				Set pCubes(tCubeKey,"dependents") = $L(tCube.DependentCubes,",")
				For jj=1:1:pCubes(tCubeKey,"dependents") {
					Set pCubes(tCubeKey,"dependents",$P(tCube.DependentCubes,",",jj))=""
				}
			}
			Set pBuildOrders(..GroupName,tBuildOrder) = tCubeKey
		}
	}
	catch ex {
		set tSC = ex.AsStatus()
	}

	quit tSC
}

}
