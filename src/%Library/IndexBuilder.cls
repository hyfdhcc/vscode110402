Include %occInclude

IncludeGenerator %occInclude

/// The purpose of this class is to allow one or more indices to be added to a class on a system that can afford little downtime, and the normal %BuildIndices process would take a very long time because the large amount of data in the class/table.  
/// <class>%Library.IndexBuilder</class> implements an interface to build indices for a class using multiple processes.  <br> <br>
/// IMPORTANT:<br>
/// -- The preferred index building utilty is now the %BuildIndices method of each persistent class, not %Library.IndexBuilder/%ConstructIndicesParallel().<br>
/// -- %Library.IndexBuilder/%ConstructIndicesParallel() may only be used with classes that have positive INTEGER ID values. <br>
/// -- The only feature %Library.IndexBuilder/%ConstructIndicesParallel() has that %BuildIndices does not is the SortBegin flag. <br><br>
/// <!doctype html public "-//w3c//dtd html 4.0 transitional//en">
/// <html>
/// <head>
///    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
///    <meta name="GENERATOR" content="Mozilla/4.77 [en] (Windows NT 5.0; U) [Netscape]">
///    <title>Index Builder</title>
/// </head>
/// 	<body>
/// 	<h1>Construct Index Parallel</h1>
/// 	<h2>Overview</h2>
/// 	
/// 	<p>The %Library.IndexBuilder class contains methods that can be inherited into persistent classes that will allow indices defined in the class to be built using multiple processes.
/// 	The class allows one or more indices to be added to a class on a system that can afford little down-time, and the normal %BuildIndices process would take a very long time because the amount of data in the class/table.
/// 	</p>
/// 	<p>
/// To add the IndexBuilder methods to your class, your class definition must list %Library.IndexBuilder as a superclass.  
/// There is also a class parameter recognized by the methods of %Library.IndexBuilder called 
/// INDEXBUILDERFILTER.  INDEXBUILDERFILTER parameter is a string value of index names delimited by a 
/// comma if there is more than one name.  INDEXBUILDERFILTER is looked at to determine which indices 
/// should be built by the %ConstructIndicesParallel method.  For example, suppose you add the NameIDX 
/// index to class Sample.Person and would like to build only that Index.  Define the INDEXBUILDERFILTER 
/// parameter as follows:
/// 	</p>
/// 	<pre>
/// 	Parameter INDEXBUILDERFILTER = "NameIDX";
/// 	</pre>
/// <p>Then when %ConstructIndicesParallel() method is called, only the NameIDX index will be built.</p>
/// 
/// <p>If INDEXBUILDERFILTER is not defined or set to "", all indices in the class will be built.</p>
/// 
/// <p>When you are ready to build the index, call the %ConstructIndicesParallel() method of the class you want 
/// to build the index for.  Above we added the NameIDX index to Sample.Person, so you would make the 
/// following call:
/// </p>
/// <pre>
/// set sc=##class(Sample.Person).%ConstructIndicesParallel()
/// </pre>
/// <p>
/// The arguments to %ConstructIndicesParallel are as follows:
/// <pre>
/// 1)  TaskId - For internal use only.  For direct, interactive callers, leave this undefined.
/// 
/// 2)  StartId - ID of the table to start building the ID for.  Default is 1
/// 
/// 3)  EndId - ID of the table you want to end the Index build on.  
///             Default is -1 which means end at the last ID of the table
/// 
/// 4)  Sortbegin - 1/0 Flag which determines if the index build will use the SortBegin feature.
/// 
/// 5)  DroneCount - Number of background jobs to use to build the indices.  
/// 	Default is 0, in which case the code will determine the number of Drones to use based on the number of CPUs and the range of rows being indexed.
/// 
/// 6)  LockFlag - Flag that determines locking behavior for the index build.
///  			0 = No locking performed for the index build
///  			1 = Extent locking - Acquires an exclusive lock on the entire extent for the duration of the index build
///  			2 = Row level locking - Acquires a shared lock for each row as it is processed and the index defined for the entry.
///                         When index build for this row is complete, an immediate unlock of this row is performed.
/// 
/// 7)  JournalFlag - 0/1 flag.  1 means the index building will be journalled.  
///                              0 means turn off journalling for this index build
/// </pre></p>
/// <p>The following example will build the NameIDX of the Sample.Person table for all rows:
/// <pre>
///        set sc=##class(Sample.Person).%ConstructIndicesParallel(,,,1,,1,1)
/// </pre></p>
/// <p>This builds the index entry for the NameIDX for all rows with ID 1 through the last ID of the class/table.  
/// It uses SortBegin, performs Extent level locking, and the index build is journalled.
/// <pre>
///        set sc=##class(Sample.Person).%ConstructIndicesParallel(,1,50000000,1,,2,0)
/// </pre></p>
/// <p>This builds the index entry for the NameIDX for all rows with ID 1 through 50,000,000 of the 
/// class/table.  
/// It uses SortBegin, performs row level level locking, and the index build is not journalled.
/// </p>
Class %Library.IndexBuilder [ Abstract, System = 3 ]
{

/// <parameter>BITMAPCHUNKINMEMORY</parameter> is used during code generation to decide whether or not bitmap chunks can be
/// constructed in memory. It is faster to construct bitmap chunks in memory but if there are a lot of bitmaps,
/// the indexed property or properties have very low selectivity or the index values are large then STORE errors
/// can be encountered. If <parameter>BITMAPCHUNKINMEMORY</parameter> is 1 then bitmap chunks are constructed in memory by
/// %ConstructIndices. Otherwise, bitmap chunks are constructed using process-private globals. The default is 0,
/// meaning that bitmap chunks are built using process-private globals.
Parameter BITMAPCHUNKINMEMORY = 0;

/// NextId(pId,pDirection) returns the ID value following pId if pDirection is 1 or the ID value preceding pId if pDirection is -1.
ClassMethod %NextId(pId As %Integer, pDirection As %Integer = 1) As %Integer [ CodeMode = objectgenerator, Internal ]
{
	if (%compiledclass.ClassType=$$$cCLASSCLASSTYPEPERSISTENT) && ('%compiledclass.NoExtent) {
		set tClassId = %compiledclass.%Id()
		set tDataAddress = $$$EXTdataaddress($$$pEXT,tClassId)
		set tGLVN = $$$EXTADDRglobal($$$pEXT,tClassId,tDataAddress)
		set tKeysubs = $$$EXTADDRkeysubscripts($$$pEXT,tClassId,tDataAddress)
		set tGLVN = tGLVN _ $select($extract(tGLVN)'="@":"(",1:"@(")
		set tSubscript = $order($$$EXTADDRSUB($$$pEXT,tClassId,tDataAddress,""))
		if $listlength(tKeysubs) = 1 {
			while (tSubscript '= "") && ('$get($$$EXTADDRSUBkeysub($$$pEXT,tClassId,tDataAddress,tSubscript))) {
				set tGLVN = tGLVN _ $$$EXTADDRSUBexpression($$$pEXT,tClassId,tDataAddress,tSubscript) _ ","
				set tSubscript = $order($$$EXTADDRSUB($$$pEXT,tClassId,tDataAddress,tSubscript))
			}
			do %code.WriteLine($Char(9)_"quit $Case(pDirection,1:$Order("_tGLVN_"pId)),:$Order("_tGLVN_"pId),-1))")
		}
		else { do %code.WriteLine($Char(9)_"quit """"") }
	}
	quit $$$OK
}

/// <p><method>%ConstructIndicesParallel</method> will build the indices of this class (optionally filtered by the INDEXBUILDERFILTER class parameter)
/// </p><pre>Arguments:
/// 	pTaskId		- TaskID of the background job - leave blank/undefined for the interactive caller
/// 	pStartId	- ID of the table to start building the ID for.  Default is 1
/// 	pEndId		- ID of the table you want to end the Index build on.  Default is -1 which means end at the last ID of the table
/// 	pSortbegin	- 1/0 Flag which determines if the index build will use the SortBegin feature.
/// 	pDroneCount	- Number of background jobs to use to build the indices.  
/// 			  Default is 0, in which case the code will determine the number of Drones to use based on the 
/// 			  number of CPUs and the range of rows being indexed.
/// 	pLockFlag	- Flag that determines locking behavior for the index build.
/// 			   0 = No locking performed for the index build
/// 			   1 = Extent locking - Acuires an exclusive lock on the entire extent for the duration of the index build
/// 			   2 = Row level locking - Acquires a shared lock for each row as it is processed and the index defined for the entry.
/// 				When index build for this row is complete, and immediate unlock of this row is performed.
/// 	pJournalFlag	- 0/1 flag.  1 means the index building will be journalled.  0 means turn off journalling for this index build
/// 	</pre>
ClassMethod %ConstructIndicesParallel(pTaskId = "", pStartId As %Integer = 0, pEndId As %Integer = -1, pSortBegin As %Integer = 1, pDroneCount As %Integer = 0, pLockFlag As %Integer = 1, pJournalFlag As %Boolean = 1) As %Status
{
#define BitMapSize							64000
#define BitMapChunk(%id)					(%id\$$$BitMapSize+1)
#define BitMapOffset(%id)					(%id#$$$BitMapSize+1)
#define BitMapChunkStartingId(%chunk)		((%chunk-1)*$$$BitMapSize)
#define BitMapChunkEndingId(%chunk)			(%chunk*$$$BitMapSize-1)
#define BitMapChunkAtStart(%chunk,%start)	($select(%start=$$$BitMapChunkStartingId(%chunk):1,%start'>..%NextId($$$BitMapChunkStartingId(%chunk)-1):1,1:0))
#define BitMapChunkAtEnd(%chunk,%end)		($select(%end=$$$BitMapChunkEndingId(%chunk):1,%end'<..%NextId($$$BitMapChunkEndingId(%chunk)+1,-1):1,1:0))
#define BitMapChunkComplete(%chunk,%start,%end)	$$$BitMapChunkAtStart(%chunk,%start)&&$$$BitMapChunkAtEnd(%chunk,%end)
#define ChunksPerJob		2

	set tStatus = $$$OK,pJournalFlag=''pJournalFlag
	if pTaskId = "" {
		set tStartTime = $zh
			#; MASTER PROCESS - this section could start background tasks, up to the number of cores + 2.
		if pLockFlag=1 {
			set tStatus = ..%LockExtent(0)
			if $$$ISERR(tStatus) { quit tStatus }
		}
		if pJournalFlag=0,$$CURRENT^%SYS.NOJRN() { do DISABLE^%SYS.NOJRN() set tWeStoppedJournaling=1 }
		

		#; Chunk it up
			#; Determine chunk boundaries and how many chunks
		if 'pStartId { set pStartId = 0, tChunkStart = 1, tOffsetStart = 1 }
		else { set tChunkStart = $$$BitMapChunk(pStartId), tOffsetStart = $$$BitMapOffset(pStartId) }
		if pEndId < 1 { set pEndId = ..%NextId("",-1) }
		set tChunkEnd = $$$BitMapChunk(pEndId), tOffsetEnd = $$$BitMapOffset(pEndId)
			#; Determine if the ID range for the chunk is complete
		set tChunkCount = tChunkEnd - tChunkStart + 1
			#; Single chunk - just do it.
		if tChunkCount = 1 {
			write !,"Building single chunk that is ",$s($$$BitMapChunkComplete(tChunkStart,pStartId,pEndId):"",1:"not "),"complete."
			set tStatus = ..%ConstructIndices(pStartId,pEndId,pLockFlag,pJournalFlag)
		}
			#; Two chunks - just do it.
		elseif tChunkCount = 2 {
			write !,"Building two chunks. First is ",$s($$$BitMapChunkAtStart(tChunkStart,pStartId):"",1:"not "),"complete and second is ",$s($$$BitMapChunkAtEnd(tChunkEnd,pEndId):"",1:"not "),"complete."
			set tStatus = ..%ConstructIndices(pStartId,$$$BitMapChunkEndingId(tChunkStart),pLockFlag,pJournalFlag)
			set tStatus = ..%ConstructIndices($$$BitMapChunkStartingId(tChunkEnd),pEndId,pLockFlag,pJournalFlag)
		}
			#; Build the task list
		else {
			set tTaskPtr = $Increment(^CacheTemp)
			$$$AddTempNode(^CacheTemp(tTaskPtr))
			set ^CacheTemp(tTaskPtr) = 1, ^CacheTemp(tTaskPtr,1) = $listbuild(pStartId,$$$BitMapChunkEndingId(tChunkStart),$$$BitMapChunkAtStart(tChunkStart,pStartId))
			for tChunk = tChunkStart+1:1:tChunkEnd-1 { set ^CacheTemp(tTaskPtr,$increment(^CacheTemp(tTaskPtr))) = $listbuild($$$BitMapChunkStartingId(tChunk),$$$BitMapChunkEndingId(tChunk),1) }
			set tendend = $$$BitMapChunkAtEnd(tChunkEnd,pEndId)
			set ^CacheTemp(tTaskPtr,$Increment(^CacheTemp(tTaskPtr))) = $listbuild($$$BitMapChunkStartingId(tChunkEnd),pEndId,$$$BitMapChunkAtEnd(tChunkEnd,pEndId))
			if 'pDroneCount {
				set tMaxDrones = $system.Util.NumberOfCPUs()
				set:tMaxDrones<1 tMaxDrones = 1
				set:tMaxDrones>128 tMaxDrones = 128
			}
			else { set tMaxDrones = pDroneCount }
			set tDroneCount = $Select(tChunkCount\$$$ChunksPerJob>tMaxDrones:tMaxDrones,1:tChunkCount\$$$ChunksPerJob)
			write !,"Building ",tChunkCount," chunks and will use parallel build algorithm with ",tDroneCount," drone processes."
			if pSortBegin { write !,"SortBegin is requested." }
			set ^CacheTemp(tTaskPtr,"shutdown") = 0
			for tPtr = 1:1:tDroneCount {
				set tChild =  ..%ConstructIndicesStartTask(tTaskPtr,pSortBegin,pLockFlag,pJournalFlag)
					if tChild = "" {
						set tSC = $$$ERROR($$$GeneralError,"JOB Command Failure. Unable to start background process to build indices. Make sure license key is valid!")
						quit
					}
					set ^CacheTemp(tTaskPtr,"log",$Increment(^CacheTemp(tTaskPtr,"log"))) = "Started drone process: "_$zchild
					write !,"Started drone process: ",$zchild
			}
				#; tChunkTime is the estimate of time to complete building a single chunk (64,000 rows)
				#; This will vary based on the hardware configuration, number and complexity of indices, etc.
			set tChunkTime = 1.1
			set tExpectedTime = (tChunkCount / tDroneCount * tChunkTime) \ 1
			if tExpectedTime > 5 {
				write !,"Expected time to complete is ",tExpectedTime," secs to build ",tChunkCount," chunks of 64,000 objects using ",tDroneCount," processes."
				write !,"Waiting for processes to complete."
				h tExpectedTime/3
			}
			do {
					h .1
					if $increment(tWaitCount) > 10000 { 
						Write !,"This is taking longer than expected..."
						Write !,"Examine ^CacheTemp("_tTaskPtr_",""log"") for errors...",! zw ^CacheTemp(tTaskPtr,"log") w ! zw ^CacheTemp(tTaskPtr,"shutdown")
						set tWaitCount = 0
					}
			} while ^CacheTemp(tTaskPtr,"shutdown") < tDroneCount
			set tEndTime = $zh
			write "...done.",!,"Elapsed time using ",tDroneCount," processes was ",tEndTime-tStartTime,"."
			for i=1:1:$g(^CacheTemp(tTaskPtr,"log")) {
				if $g(^CacheTemp(tTaskPtr,"log",i))'="",$p(^CacheTemp(tTaskPtr,"log",i)," with status = ",2)'=1,$p(^CacheTemp(tTaskPtr,"log",i)," with status = ",2)'="" {
					write !,"Error logged for background task:",!,$p(^CacheTemp(tTaskPtr,"log",i)," with status = ",1)," with status = ",$$DisplayError^%apiOBJ($p(^CacheTemp(tTaskPtr,"log",i)," with status = ",2))
				}
			}
			kill ^CacheTemp(tTaskPtr)
			$$$RemoveTempNode(^CacheTemp(tTaskPtr))
		}
		if pLockFlag = 1 do ..%UnlockExtent(0)
		if pJournalFlag=0,$g(tWeStoppedJournaling) { do ENABLE^%SYS.NOJRN() }
	}
	else {
		try {
			set ^CacheTemp(pTaskId,"log",$Increment(^CacheTemp(pTaskId,"log"))) = "DRONE: ready for work: "_$j
			set tTask = $Increment(^CacheTemp(pTaskId,"processing"))
			set ^CacheTemp(pTaskId,"log",$Increment(^CacheTemp(pTaskId,"log"))) = "DRONE["_$j_"] Entering task loop with task id #"_tTask_$Select(pSortBegin:" with SortBegin/End.",1:"")
			if pSortBegin { do ..%SortBegin() }
			while tTask '> ^CacheTemp(pTaskId) {
					set tTime = $zh
					set ^CacheTemp(pTaskId,"log",$Increment(^CacheTemp(pTaskId,"log"))) = "DRONE["_$j_"] Grabbing task id #"_tTask
					set tTaskData = ^CacheTemp(pTaskId,tTask)
					//if $List(tTaskData,3) { set tStatus = ..%ConstructIndices($List(tTaskData,1),$List(tTaskData,2),pLockFlag,pJournalFlag) }
					//else  { set tStatus = ..%SaveIndices($List(tTaskData,1),$List(tTaskData,2)) }
					set tStatus = ..%ConstructIndices($List(tTaskData,1),$List(tTaskData,2),pLockFlag,pJournalFlag)
					set ^CacheTemp(pTaskId,tTask,"processed") = "Processed by "_$j_" in "_($zh-tTime)_". Task finished with "_$Select(tStatus:"SUCCESS",1:"Failure")
					set tTask = $Increment(^CacheTemp(pTaskId,"processing"))
			}
		}
		#dim tException as %Exception.AbstractException
		catch tException {
			set tStatus = tException.AsStatus()
		}
			#; Signal the TaskMaster that this worker is going home
		if $Increment(^CacheTemp(pTaskId,"shutdown"))
		if pSortBegin { do ..%SortEnd() }
		set ^CacheTemp(pTaskId,"log",$Increment(^CacheTemp(pTaskId,"log"))) = "Shutting down drone process: "_$j_" with status = "_tStatus
	}
	quit tStatus
}

ClassMethod %ConstructIndicesStartTask(pTaskId, pSortBegin, pLockFlag As %Integer = 1, pJournalFlag As %Boolean = 1) As %String [ CodeMode = objectgenerator, Internal ]
{
	if (%compiledclass.ClassType '= $$$cCLASSCLASSTYPEPERSISTENT) || (%compiledclass.NoExtent) { do %code.WriteLine($char(9)_"QUIT """"") quit $$$OK }
	do %code.WriteLine($Char(9)_"job ##class("_%compiledclass.Name_").%ConstructIndicesParallel(pTaskId,0,-1,pSortBegin,0,pLockFlag,pJournalFlag)::10")
	do %code.WriteLine($Char(9)_"if $Test { set tChild = $zchild } else { set tChild = """" }")
	do %code.WriteLine($Char(9)_"quit tChild")
	quit $$$OK
}

ClassMethod %ConstructIndices(pStartId As %Integer, pEndId As %Integer, pLockFlag As %Integer = 1, pJournalFlag As %Boolean = 1) As %Status [ CodeMode = objectgenerator, Internal ]
{
 Quit $$GenerateConstructIndices^%ocsCache()
}

/// Files the indices for all objects whose ID is in the range defined by <var>pStartId</var> and <var>pEndId</var>.
/// If <var>pEndId</var> is null then it defaults to <var>pStartId</var>. If <var>pStartId</var> is null then the
/// range is empty and no filing will occur.
/// 
/// If <var>lockExtent</var> is true then an extent lock will be acquired before the indices
/// are built. If the lock cannot be acquired then an error is returned. The lock is released
/// after the index filing is completed.
/// 
/// 
/// 
/// <p>Returns a <CLASS>%Status</CLASS> value indicating success or failure.
ClassMethod %SaveIndices(pStartId As %String(MAXLEN="") = "", pEndId As %String(MAXLEN="") = "", lockExtent As %Boolean = 0) As %Status [ CodeMode = generator, Internal, ProcedureBlock = 1, ServerOnly = 0 ]
{
 Quit $$GenerateIBSaveIndices^%ocsCache()
}

}
