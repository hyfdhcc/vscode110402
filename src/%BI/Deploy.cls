Include (%occInclude, %occReference2)

/// Hyperindex Deployment class
Class %BI.Deploy [ Abstract, ClassType = "", LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/// Parameters:
/// log = full path of log file, "" for none, 0 for users device
/// mode = 1 : DB side, Immediate <default
/// 2 : DB side, Delayed
/// 3 : DB side, Delayed + Rebuild
/// 4 : Shadow side, Delayed
/// 5 : Shadow side, Delayed + Rebuild
/// uinterval is the hang when all updates processed (default 10)
/// rnrecords is number to rebuild in a batch, modes 3,5 only,
/// default 1000, if "" then 'all', if 0 then no rebuild
/// rinterval is the hang between a batch of records, or class default 60
/// rebinterval is the hang when a complete rebuild finishes (before the next one starts),
/// default 3600
/// debug is level of detail in log file
/// (0=minimal, 1=log class, 2=log batch, 3=log 100 records, 4=log record) default=0
ClassMethod Start(log, mode, uinterval, rnrecords, rinterval, rebinterval, debug)
{
	;        
	;  ^BIidx.Hi=$lb(mode,log,uinterval,rnrecords,rinterval,rebinterval,laststartdt,lastenddt,currentstartdt,status,debug)
	;                                             laststartdt is $h of last completed full rebuild start (if any)
	;                                             lastenddt is $h of last completed full rebuild (if any)
	;                                             currentstartdt is $h of current full rebuild (if running)
	;                                             status =1 if running, =0 if paused, =-1 if stopping/stopped
	;  ^BIidx.Hi(class)=$lb(startdt,enddt,lastid)    startdt = date/time of rebuild start, "" if none
	;                                             enddt = date/time rebuild finished, "" if not finished
	;                                             lastid is the last Id processed in rebuild (for restart)
	;  ^BIidx.Hi(class,cond,chunk)=$bit              bitmap for condition 'cond', chunk size is controlled by
	;                                             entry in Hyperindex.Inc
	;  ^BIidx.Col(class,Col)=Id                      Id is record Id in class
	;  ^BIidx.Id(class,Id)=Col                       Col is column in bit table
	;  ^BIidx.Cols(class,col,catid,cond)=""          condition cond is true for column col
	;  ^BIidx.Hi(class,"Tempnnn",chunk)=$bit         temp rows built during search engine
	;  ^BIidx.Hi(class,"Upd",Id)=flag                list of records that need indexing.
	;                                             flag=1 for insert, =0 for update, =-1 for 'delete
	
	new backgroundlog,Hi,laststartdt,lastenddt,currentstartdt,status
	if '$d(log) do  ; interactive startup
	. read !,"Log file <Hyper.log>          :",log
	. if log="" set log="Hyper.log" write log
	. read !,"Mode (1-5)                    :",mode
	. if mode="" set mode=1 write mode
	. if mode=1 quit
	. read !,"Check interval <10>           :",uinterval
	. if uinterval="" set uinterval=10 write uinterval
	. read !,"Rebuild batch size <1000>     :",rnrecords
	. if rnrecords="" set rnrecords=1000 write rnrecords
	. read !,"Interval betw. batches <60>   :",rinterval
	. if rinterval="" set rinterval=60 write rinterval
	. read !,"Interval betw. rebuilds <3600>:",rebinterval
	. if rebinterval="" set rebinterval=3600 write rebinterval
	. read !,"Logging level <0>             :",debug
	. if debug="" set debug=0 write debug
	
	set log=$get(log),mode=$get(mode,1),uinterval=$get(uinterval,10),debug=$get(debug,0)
	set rnrecords=$get(rnrecords,1000),rinterval=$get(rinterval,60),rebinterval=$get(rebinterval,3600)
	
	; set immediately in case user starts before background
	set backgroundlog=log,log=""
	if (mode<1)||(mode>5) do Log("Invalid mode :"_mode) quit
	lock +^BIidx.Hi:5 else  do Log("Hyperindex is locked.  Quitting") quit
	set Hi=$g(^BIidx.Hi),laststartdt=$lg(Hi,7),lastenddt=$lg(Hi,8),
		currentstartdt=$lg(Hi,9),status=0
	set ^BIidx.Hi=$lb(mode,backgroundlog,uinterval,rnrecords,rinterval,rebinterval,
	        laststartdt,lastenddt,currentstartdt,status,debug)
	lock -^BIidx.Hi
	
	if mode=1 quit  ; just set the mode in ^BIidx.Hi and quit
	
	; start the background.  This code needed because you cannot job a method
	job Background(backgroundlog,mode,uinterval,rnrecords,rinterval,rebinterval,debug)
	quit

Background(log,mode,uinterval,rnrecords,rinterval,rebinterval,debug)
	do Log("Hyperindex started with params="_mode_","_uinterval_","_rnrecords_","_rinterval_","_rebinterval_","_debug)
	lock +^BIidx.Hi:5 else  do Log("Hyperindex is locked.  Quitting") quit
	if (mode<1)||(mode>5) do Log("Invalid mode :"_mode) quit
	set Hi=$g(^BIidx.Hi),laststartdt=$lg(Hi,7),lastenddt=$lg(Hi,8),currentstartdt=$lg(Hi,9),status=1
	set ^BIidx.Hi=$lb(mode,log,uinterval,rnrecords,rinterval,rebinterval,laststartdt,lastenddt,currentstartdt,status,debug)
	
	do SET^%PRIO("BATCH") ; make this a 'batch job' (could also use "BATCH,LOW" ?)
	
	set $zt="Crash"
	
Main	;
	do Check
	
	; check for shutdown
	if status=-1 quit  ; shutdown
	
	;if mode is not 3 or 5, or user has disabled the rebuild, or paused
	;  then hang for interval and check again
	if (35'[mode)||(rnrecords=0)||(status=0) do  goto Main
	. if debug>2 do Log("Waiting "_uinterval_" seconds")
	. if uinterval hang uinterval
	
Rebuild	;
	; (re-)start the Rebuild
	
	if currentstartdt="" do
	. set currentstartdt=$h,$list(^BIidx.Hi,9)=currentstartdt  
	
	. ; loop through all Hyperindex target classes
	. set classes=##class(%ResultSet).%New("%CompiledClass:ClassInfo")
	. set ok=classes.Execute("&")
	. for  quit:'classes.Next()  set Class=classes.Get("Name") do
	. . if '$$$METHrunnable($$$MGINFO,Class,"HiRebuild") quit
	. . set ^BIidx.Hi(Class)="" ; reset
	. do classes.%Close()
	
	. if debug do Log("Rebuild all classes started at "_$zdt(currentstartdt,3))
	else  do
	. if debug do Log("Rebuild all classes restarted at "_$zdt($h,3))
	
	set class=""
	
NextClass	;
	; check for shutdown/pause
	if status=-1 quit  ; shutdown
	if status=0 goto Main ; paused
	if rnrecords=0 goto Main ; rebuild disabled
	
	; find first class with no enddt
	set found=0
	for  set class=$o(^BIidx.Hi(class)) quit:class=""  do  quit:found
	. set data=$get(^BIidx.Hi(class)),startdt=$lg(data,1),enddt=$lg(data,2),lastid=$lg(data,3)
	. if enddt="" set found=1 if startdt="" set startdt=$h,$li(^BIidx.Hi(class),1)=startdt
	
	; if no more, we have finished a pass of the full rebuild
	if class="" do  goto Main
	. set laststartdt=currentstartdt,lastenddt=$h,currentstartdt=""
	. set $list(^BIidx.Hi,7,9)=$lb(laststartdt,lastenddt,currentstartdt) ; update last-run dates
	. if debug do Log("Rebuild all classes ended at "_$zdt(lastenddt,3))
	. if rebinterval do Wait(rebinterval)
	
	; if class is locked, someone is running a foreground rebuild
	lock +^BIidx.Hi(class):10 else  do:debug Log("Class "_class_" is locked, cannot rebuild now") goto NextClass
	
	; [continue] rebuilding this class
	;   if rs is not there, create the rs and run forward
	;        to lastid (if any)
	;   else just continue using the rs
	if $get(rs)="" do
	. set rs=##class(%ResultSet).%New(class_":Extent")
	. do rs.Execute()
	. if lastid'="" do
	. . set found=0 for  quit:'rs.Next()  if rs.Get("ID")=lastid set found=1 quit
	. . if 'found do rs.%Close(),rs.Execute() set lastid="" ; not found, restart
	
	if lastid="" do
	. if debug do Log("Rebuild class "_class_" started at "_$zdt($h,3))
	else  do
	. if debug do Log("Rebuild class "_class_", starting after "_lastid)
	
	set count=0 ; start batch
	set quit=0
	
Next	; next record
	; check for end of class
	if 'rs.Next() do  goto NextClass
	. do rs.%Close() set rs=""
	. do ##class(%BI.MinerUtils).UpdateCompoundConditions(class)
	. set enddt=$h,^BIidx.Hi(class)=$lb(startdt,enddt,"")
	. lock -^BIidx.Hi(class)
	. if debug do Log("Rebuild class "_class_" ended at "_$zdt(enddt,3))
	. if rinterval do Wait(rinterval)
	
	set Id=rs.Get("ID")
	set obj=$zobjclassmethod(class,"%OpenId",Id)
	if obj="" do Log(class_".%OpenId("_Id_") failed")
	else  do
	. set sc=obj.HiBuild(Id) do obj.%Close()
	. if debug>3 do Log("Rebuilt "_class_" "_Id)
	. if 'sc do Log(class_".HiBuild("_Id_") failed")
	set count=count+1
	
	; every 100 records, update checkpoint, check for updates or shutdown, but no wait
	if '(count#100) do  if quit goto Main
	. set $li(^BIidx.Hi(class),3)=Id
	. if debug>2 do Log("Processed "_count_" records in class "_class_", lastid="_Id)
	. do Check ; check for updates
	. ; check for shutdown/pause
	. if (status<1)||(rnrecords=0) lock -^BIidx.Hi(class) set quit=1
	
	; if rnrecords'="" then every rnrecords check for updates or shutdown and wait rinterval
	if rnrecords,count'<rnrecords do  if quit goto Main ; end of batch
	. if debug>1 do Log("End of batch of "_rnrecords_" records in class "_class_", lastid="_Id)
	. if rinterval do Wait(rinterval)
	. set count=0
	. if (status<1)||(rnrecords=0) lock -^BIidx.Hi(class) set quit=1
	
	goto Next

Check	; Check for and process any records listed in ^BIidx.Hi(class,"Upd",Id)=flag
	; watching for a change in status (shutdown or pause)
	; rest for uinterval every 100 records
	
	new class,Id,flag,sc,obj,count,wait,int
	; not newed : uinterval,rnrecords,rinterval,rebinterval,status,debug
	
	; refresh params and check for shutdown/pause
	do GetParams
	if status<1 quit  ; shutdown or paused
	
	if debug>3 do Log("Checking for updates")
	set count=0
	set class="" for  set class=$o(^BIidx.Hi(class)) quit:class=""  quit:status<1  do
	. set Id="" for  set Id=$o(^BIidx.Hi(class,"Upd",Id)) quit:Id=""  quit:status<1  do
	. . set flag=$get(^BIidx.Hi(class,"Upd",Id))
	. . if flag=-1 do
	. . . set sc=##class(%BI.MinerUtils).Delete(class,Id)
	. . . if $$$ISERR(sc) do Log("HyperindexUtils.Delete("_class_","_Id_") failed:"_sc)
	. . . else  if debug>3 do Log("Deleted "_class_" "_Id)
	. . else  do
	. . . set obj=$zobjclassmethod(class,"%OpenId",Id)
	. . . if obj="" do Log(class_".%OpenId("_Id_") failed")
	. . . else  do
	. . . . set sc=obj.HiBuild(Id)
	. . . . if $$$ISERR(sc) do Log(class_".HiBuild("_Id_") failed:"_sc)
	. . . . set sc=##class(%BI.MinerUtils).SetCompoundConditionsOneRecord(class,Id)
	. . . . if $$$ISERR(sc) do Log(class_".SetCompoundConditionsOneRecord("_Id_") failed:"_sc)
	. . . . do obj.%Close()
	. . . . if debug>3 do Log("Processed "_class_" "_Id)
	. . kill ^BIidx.Hi(class,"Upd",Id) ; delete it, (even if it failed !)
	. . set count=count+1
	. . if '(count#100) do
	. . . do GetParams if status<1 quit
	. . . if debug>2 do Log("Processed 100 records, to "_class_":"_Id_", resting for "_uinterval_" seconds")
	. . . if uinterval=0 quit
	. . . set wait=0
	. . . for  do  if (status<1)||(wait'<uinterval) quit
	. . . . set int=uinterval-wait if int>10 set int=10
	. . . . if debug>3 do Log("Waiting "_int_" seconds")
	. . . . hang int set wait=wait+int
	. . . . do GetParams
	. . else  do GetParams
	
	if debug>2 do Log(count_" updates processed")
	else  if debug=2,count do Log(count_" updates processed")
	quit

GetParams	;
	set Hi=$get(^BIidx.Hi),oldstatus=$get(status),oldrnr=$get(rnrecords)
	set uinterval=$lg(Hi,3),rnrecords=$lg(Hi,4),rinterval=$lg(Hi,5),rebinterval=$lg(Hi,6)
	set laststartdt=$lg(Hi,7),lastenddt=$lg(Hi,8),currentstartdt=$lg(Hi,9)
	set status=$lg(Hi,10),debug=$lg(Hi,11)
	if status'=oldstatus {
	do Log("Hyperindex "_
	$s(status=0:"paused",status=1:"resumed",status=-1:"stopped",1:"invalid status"))
	}
	if rnrecords'=oldrnr {
	if rnrecords=0 do Log("Hyperindex rebuild paused") quit
	if oldrnr=0 do Log("Hyperindex rebuild resumed")
	}
	quit

Wait(interval)
	; Wait for (up to) interval seconds, checking for updates and user commands every 10 seconds
	new wait,int
	do GetParams
	if (status<1)||(rnrecords=0) quit
	if interval=0 quit
	set wait=0
	for  do  if (status<1)||(wait'<interval)||(rnrecords=0) quit
	. set int=interval-wait if int>10 set int=10
	. if debug>3 do Log("Waiting "_int_" seconds")
	. hang int set wait=wait+int
	. do Check 
	quit

Crash	;
	do Log("Hyperindex crashed with $ZE="_$ze)
	quit

Log(Message)	; Log a message to device log
	if log="" quit
	if log'=0 open log:"wsa":1 else  open log:"wns":1 else  quit
	use log write !,$h," ",Message
	if log'=0 close log
	quit
}

/// Set background into a wait loop using uinterval
ClassMethod Pause()
{
	set $list(^BIidx.Hi,10)=0
	quit
}

/// Resume background from Paused state
ClassMethod Resume()
{
	set $list(^BIidx.Hi,10)=1
	lock +^BIidx.Hi:1 else  quit  ; OK, background is running
	lock -^BIidx.Hi
	; restart background
	new Hi,log,mode,uinterval,rnrecords,rinterval,rebinterval,status,debug
	set Hi=$get(^BIidx.Hi),mode=$lg(Hi,1),log=$lg(Hi,2)
	set uinterval=$lg(Hi,3),rnrecords=$lg(Hi,4),rinterval=$lg(Hi,5),
		rebinterval=$lg(Hi,6)
	set status=1,debug=$lg(Hi,11)
	do ..Start(log,mode,uinterval,rnrecords,rinterval,rebinterval,debug)
	quit
}

/// Shutdown background
ClassMethod Stop()
{
	set $list(^BIidx.Hi,10)=-1
	quit
}

/// Disable background rebuild, but process updates
ClassMethod PauseRebuild() As %String
{
	new batchsize
	set batchsize=$lg($get(^BIidx.Hi),4)
	set $list(^BIidx.Hi,4)=0
	quit batchsize
}

/// Resume background rebuild, using batchsize, if provided, else 1000
ClassMethod ResumeRebuild(batchsize As %String)
{
	if '$d(batchsize) set batchsize=1000 ; note batchsize="" is valid
	set $list(^BIidx.Hi,4)=batchsize
	quit
}

/// Method called on the DB server when it is started up.
/// Must ONLY be called for mode 4 or 5.
/// Deletes all the 'Upd' entries, all the ^Hi indices.
/// It does this with journalling disabled, so that these
/// changes are not reflected on the shadow server.
/// Sets the mode to signal 'delayed' mode
ClassMethod Cleanup(mode)
{
	new jrn
	set mode=$get(mode) if (mode="")||(45'[mode) quit
	set jrn=$$CURRENT^%NOJRN if jrn do DISABLE^%NOJRN ; stop jrn
	kill ^BIidx.Hi,^BIidx.Id,^BIidx.Col,^BIidx.Cols,^BIidx.HiTemp,^BIidx.Hilog
	kill ^BI.CategoryD,^BI.CategoryI,^BIidx.ConditionD,^BIidx.ConditionI
	set $li(^BIidx.Hi,1)=mode ; set mode on DB server to 'delayed'
	if jrn do ENABLE^%NOJRN ; restart jrn
	quit
}

}
