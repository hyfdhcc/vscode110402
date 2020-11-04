Include (%syMonitor, %syPidtab, %occErrors)

/// Provides system management functions for the Cache Monitor
Class %Monitor.Manager Extends (%RegisteredObject, %XML.Adaptor) [ System = 3 ]
{

/*
---------------------Documentation------------------------------------
RFD463   6/22/09 Rob Davis, Add status of "system-only" ($zu(84,1,3)) counters. 
RFD435   1/29/09 Rob Davis, Fix %Monitor.Manager.StopSystemCounters() class method
-------------------End Documentation----------------------------------
*/
/// Activate a metrics class
ClassMethod Activate(mclass As %String) As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s id=""
 s sc=##class(%Monitor.ItemGroup).MetricsClassItemGroup(mclass,.id)
 i 'sc Q 0
 s class=##class(%Monitor.ItemGroup).%OpenId(id)
 i '$IsObject(class) q 0
 s class.Activated = 1
 s sc = class.%Save()
 k class
 i sc'=$$$OK q 0
 q 1
Error s $zt=""
 Q 0
}

/// Deactivate a metrics class
ClassMethod Deactivate(mclass As %String) As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s id=""
 s sc=##class(%Monitor.ItemGroup).MetricsClassItemGroup(mclass,.id)
 i 'sc Q 0
 s class=##class(%Monitor.ItemGroup).%OpenId(id)
 i '$IsObject(class) q 0
 s class.Activated = 0
 s sc = class.%Save()
 k class
 i sc'=$$$OK q 0
 q 1
Error s $zt=""
 Q 0
}

/// Remove a metrics class
ClassMethod Remove(mclass As %String) As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s id=""
 s sc=##class(%Monitor.ItemGroup).MetricsClassItemGroup(mclass,.id)
 i id="" Q 0
 s sc=##class(%Monitor.ItemGroup).%DeleteId(id)
 i sc'=$$$OK q 0
 q 1
Error s $zt=""
 Q 0
}

/// Set the sample interval for a metrics class
ClassMethod ClassInterval(mclass As %String, ByRef interval As %Integer) As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s id=""
 s sc=##class(%Monitor.ItemGroup).MetricsClassItemGroup(mclass,.id)
 i 'sc Q 0
 s class=##class(%Monitor.ItemGroup).%OpenId(id)
 i '$IsObject(class) q 0
 i interval'="" {
	s class.SampInterval = interval
	s sc = class.%Save()
 } else {
	 s interval=class.SampInterval
 }
 k class
 i sc'=$$$OK q 0
 q 1
Error s $zt=""
 Q 0
}

/// Purge a metrics class
ClassMethod Purge(mclass As %String) As %Integer [ Internal ]
{
 s $ZT="Error"
 
 // Execute the query on the sample to get the data
 Set rspec = ##class(%ResultSet).%New("Monitor.Sample:LatestSample")
 Do rspec.Execute(mclass)
 // Get all the data
 While rspec.Next(.sc) {
	If '$SYSTEM.Status.IsOK(sc) Quit
	// Get ID
	Set id= rspec.GetData(1)
	d ##class(Monitor.Sample).%DeleteId(id)
 }
 Q 1
Error s $zt=""
 Q 0
}

/// Return summary active status: 0 - no active classes, else 1 (some active classes)
ClassMethod IsActive() As %Boolean
{
	s active = 0
	Set Rset = ##class(%ResultSet).%New("%Monitor.ItemGroup:Classes")
	// loop on the groups
	d Rset.Execute()
	While Rset.Next() {
		i Rset.GetData(2) {
			s active = 1
			Q
		}
	}
	Q active
}

/// Start the System Monitor
ClassMethod Start() As %Integer
{
 s $ZT="Error"
 
 s monitor = "MONITOR"
 i $system.Event.Defined(monitor) q -1

 JOB START^MONITOR::5
 Q $TEST
Error s $zt=""
 Q 0
}

/// Refresh the System Monitor
ClassMethod Refresh() As %Integer
{
 s $ZT="Error"
 
 s monitor = "MONITOR"
 s status = $system.Event.Signal(monitor_"REFRESH")
 s status = $system.Event.Signal(monitor)
 q status
Error s $zt=""
 Q 0
}

/// Halt the System monitor
ClassMethod Halt() As %Integer
{
 s $ZT="Error"
 
 s monitor = "MONITOR"
 s status = $system.Event.Signal(monitor_"HALT")
 s status = $system.Event.Signal(monitor)
 h 1
 d $system.Event.Delete(monitor)
 d $system.Event.Delete(monitor_"HALT")
 d $system.Event.Delete(monitor_"REFRESH")
 q 1
Error s $zt=""
 i $ze'["<UNDEFINED>" q 0
 q 1
}

/// Start the Application Monitor
ClassMethod StartApp() As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s monitor = "^APPMONITOR"
 i $system.Event.Defined(monitor) q 0

 JOB START^%MONAPP::5
 i '$TEST w "Application Monitor failed to start",! q -1
 h 1
 i '$system.Event.Defined(monitor) q -1
 Q 1
Error s $zt=""
 w $ze,!
 q -1
}

/// Refresh the Monitor agent
ClassMethod RefreshApp() As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s monitor = "^APPMONITOR"
 i '$system.Event.Defined(monitor) q 0
 s status = $system.Event.Signal(monitor_"REFRESH")
 s status = $system.Event.Signal(monitor)
 q status
Error s $zt=""
 w $ze,!
 q -1
}

/// Halt the monitor
ClassMethod HaltApp() As %Integer [ Internal ]
{
 s $ZT="Error"
 
 s monitor = "^APPMONITOR"
 i '$system.Event.Defined(monitor) q 0
 s sc = $system.Event.Signal(monitor_"HALT")
 i sc'=1 q -1
 s sc = $system.Event.Signal(monitor)
 i sc'=1 q -1
 h 1
 d $system.Event.Delete(monitor)
 d $system.Event.Delete(monitor_"HALT")
 d $system.Event.Delete(monitor_"REFRESH")
 q 1
Error s $zt=""
 i $ze'["<UNDEFINED>" {
	w $ze,!
 	q -1
 }
 q 1
}

/// Signal the Monitor agent to run
ClassMethod SignalApp() As %Integer [ Internal ]
{
 s $ZT="Error"
 
 i $ZNSPACE="%SYS" {
	 q 1
 }
 s monitor = "^APPMONITOR"
 i '$system.Event.Defined(monitor) q -1
 s status = $system.Event.Signal(monitor)
 q status
Error s $zt=""
 w $ze,!
 q -1
}

/// Clear the current system MONITOR counters
/// <br>
/// System = 1 indicates to specifically clear the system level counters
ClassMethod ClearSystemCounters(System As %Boolean = 0) As %Integer
{
 ; see if %SYS.MONLBL is enabled
 i $zu(84,8)=1,$zu(84,16)'=-1 q $$$ERROR($$$MonitorInUse)
 s sc=1,err="",$ZT="Error",$ZE=""
 ; Do we want to clear systat[] only ?
 i System d $zu(84,2,3) Q $$$OK
 d $zu(84,2)
 Q $$$OK
 If group = "" s $ze="Class does not exist" goto Error
Error
 i $ze]"" s sc=0,err=$ze
 i err]"" s sc=sc_","_err
 Set $ZT=""
 Q sc
}

/// Enable the system MONITOR counters<br>
/// <br>
/// System = 1 to separately enable only system level counters (other parameters ignored)<br>
/// <br>
/// Note that if System level counters are enabled separately, then they must also be specifically
/// stopped or cleared separately (use System = 1 for the Stop() and Clear() methods)<br>
/// <br>
/// Processes = the number of individual processes to collect counts for<br>
/// Routines = the number of individual routines to collect counts for<br>
/// Globals = the number of individual globals to collect counts for<br>
/// Network = the number of individual network nodes to collect counts for<br>
/// ProcessList = a $List of specific process IDs to collect counts for<br>
/// <br>
/// Note that the MONITOR will allocate 'slots' for the number of processes, globals,
/// routines and nodes you indicate. The first 'n' processes, routines, globals and
/// nodes to increment the counters will take those slots, and all counts from other
/// processes, globals, routines, and nodes will be added to the 'Other' slot.
/// <br>
/// These counters are the same metrics as reported by the PERFMON utility. If you plan
/// to view the data collected via ^PERFMON, you should ensure that the start time for
/// calculating per/second data is properly set for ^PERFMON by running the $$Clear^PERFMON()
/// function. This will reset the counters and start time.
ClassMethod StartSystemCounters(System As %Boolean = 0, Processes As %Integer = 10, Routines As %Integer = 60, Globals As %Integer = 25, Network As %Integer = 5, ProcessList As %List) As %Integer
{
 ; see if %SYS.MONLBL is enabled
 i $zu(84,8)=1,$zu(84,16)'=-1 q $$$ERROR($$$MonitorInUse)
 ;n status,err,proc,glo,rou,net
 s sc=1,err="",$ZT="Error",$ZE=""
 ; Do we want to collect systat[] only ?
 i System s i=$zu(84,1,3) Q $$$OK
 i $zu(84,8)=1 Q $$$OK
 i $zu(84,0,1,Processes,Globals,Routines,Network,1)'=1 s $ze=$$$ERROR($$$MonitorMemoryAlloc) g Error
 ; Select all PIDs or a specific list
 s all=1 i $d(ProcessList),$ll(ProcessList)>0 s all=2 
 i $zu(84,1,all)'=all s err=$$$ERROR($$$MonitorStatsColl) g Error
 ; Register specific list of PIDs
 i $d(ProcessList) f i=1:1:$ll(ProcessList) s j=$zu(84,6,$list(ProcessList,i))
Error
 i $ze]"" s sc=0,err=$ze
 i err]"" s sc=sc_","_err
 Set $ZT=""
 Q sc
}

/// Stop the system MONITOR counters<br>
/// <br>
/// System = 1 indicates to specifically stop the system level counters (if those were started separately)
ClassMethod StopSystemCounters(System As %Boolean = 0) As %Integer
{
 ; see if %SYS.MONLBL is enabled
 i $zu(84,8)=1,$zu(84,16)'=-1 q $$$ERROR($$$MonitorInUse)
 s sc=1,err="",$ZT="Error",$ZE=""
 i System d $zu(84,0,3) q $$$OK  ; stop system
 i $zu(84,8)=0 q $$$ERROR($$$MonitorNotRunning)
 d $zu(84,1,0) ; disable stats...
 d $zu(84,0,0) ; end collection
 Q $$$OK
Error
 i $ze]"" s sc=0,err=$ze
 i err]"" s sc=sc_","_err
 Set $ZT=""
 Q sc
}

/// Check if the system MONITOR counters are currently active<br>
/// <br>
/// Returns '0' if not active, or a positive integer if active.
/// <br>
/// A '1' indicates that PERFMON (or the SystemCounters in this class) are active.
/// <br>
/// A '2' indicates that %SYS.MONLBL (or the %Monitor.System.LineByLine class) is active.
/// <br>
/// If the 'System' parameter is included as '1', then this will also return a second
/// comma-delimited piece indicating the status of the 'system-only' level counters documented
/// above in the StartSystemCounters() method. So, a '1,1' means both PERFMON and the
/// system-only counters are active, but have been started separately. A '1,0' means that 
/// just a PERFMON collection was started (which includes system-level counters, but they will 
/// be stopped when PERFMON is stopped).
ClassMethod SystemCountersActive(System As %Boolean = 0) As %String
{
 i '$zu(84,8) {
	 i System q $s($zu(84,1,3,0):"0,1",1:"0,0")
	 q 0
 }
 ; see if PERFMON is enabled
 i $zu(84,16)=-1 {
	 i System q $s($zu(84,1,3,0):"1,1",1:"1,0")
 	 q 1
 }
 ; else %SYS.MONLBL is enabled
 i System q $s($zu(84,1,3,0):"2,1",1:"2,0")
 q 2
}

/// Set sampling interval
ClassMethod Interval(interval As %Integer) As %String
{
 i $d(interval) s ^ISCMonitor("Monitor","Interval") = interval q ^ISCMonitor("Monitor","Interval")
 i '$d(^ISCMonitor("Monitor","Interval")) s ^ISCMonitor("Monitor","Interval") = 10
 q ^ISCMonitor("Monitor","Interval")
}

/// Set application sampling interval
ClassMethod AppInterval(interval As %Integer) As %String [ Internal ]
{
 i $d(interval) s ^ISCMonitor("Monitor","AppInterval") = interval q ^ISCMonitor("Monitor","AppInterval")
 i ('$d(^ISCMonitor("Monitor","AppInterval"))) || (^ISCMonitor("Monitor","AppInterval")=300) {
	s ^ISCMonitor("Monitor","AppInterval") = 30
 }
 q ^ISCMonitor("Monitor","AppInterval")
}

/// Set application default notification scheme
ClassMethod AppNotify(method As %Integer) As %Integer [ Internal ]
{
 i $d(method) {
	 s ^ISCMonitor("Monitor","AppNotify") = method
	 q method
 }
 s method = $g(^ISCMonitor("Monitor","AppNotify"),0)
 i 'method && ($g(^ISCMonitor("Monitor","AppNotify","Method"),"")'="") {
	 s ^ISCMonitor("Monitor","AppNotify") = 2
	 q 2
 }
 q method
}

/// Set application default notification method
ClassMethod AppNotifyMethod(ByRef method As %String, ByRef class As %String) As %Integer [ Internal ]
{
	i $d(method) {
		s ^ISCMonitor("Monitor","AppNotify","Method") = method
		s ^ISCMonitor("Monitor","AppNotify","Class") = class
		s ^ISCMonitor("Monitor","AppNotify") = 2
	}
	i '$d(^ISCMonitor("Monitor","AppNotify","Method")) {
		s method = ""
		s class = ""
	} else {
		s method = ^ISCMonitor("Monitor","AppNotify","Method")
		s class = ^ISCMonitor("Monitor","AppNotify","Class")
	}
	q $$$OK
}

/// Set email SMTP Server name
ClassMethod SmtpServer(server As %String) As %String
{
 i $d(server) s ^ISCMonitor("Monitor","SmtpServer") = server q ^ISCMonitor("Monitor","SmtpServer")
 i '$d(^ISCMonitor("Monitor","SmtpServer")) s ^ISCMonitor("Monitor","SmtpServer") = ""
 q ^ISCMonitor("Monitor","SmtpServer")
}

/// Set email SMTP Server port
ClassMethod SmtpServerPort(port As %String) As %String
{
 i $d(port) s ^ISCMonitor("Monitor","SmtpServerPort") = port q ^ISCMonitor("Monitor","SmtpServerPort")
 i '$d(^ISCMonitor("Monitor","SmtpServerPort")) s ^ISCMonitor("Monitor","SmtpServerPort") = 25
 q ^ISCMonitor("Monitor","SmtpServerPort")
}

/// Email enabled
ClassMethod EnableEmail(enable As %Boolean) As %Boolean
{
 i $d(enable) {
	 s ^ISCMonitor("Monitor","EmailEnabled")=enable
 }
 else {
	i '$d(^ISCMonitor("Monitor","EmailEnabled")) q 0
 }
 q ^ISCMonitor("Monitor","EmailEnabled")
}

/// Set email sender
ClassMethod EmailSender(sender As %String) As %String
{
 i $d(sender) s ^ISCMonitor("Monitor","EmailSender") = sender q ^ISCMonitor("Monitor","EmailSender")
 i '$d(^ISCMonitor("Monitor","EmailSender")) s ^ISCMonitor("Monitor","EmailSender") = ""
 q ^ISCMonitor("Monitor","EmailSender")
}

/// Set email SMTP user name
ClassMethod SmtpUserName(name As %String) As %String
{
 i $d(name) s ^ISCMonitor("Monitor","SmtpUserName") = name q ^ISCMonitor("Monitor","SmtpUserName")
 i '$d(^ISCMonitor("Monitor","SmtpUserName")) s ^ISCMonitor("Monitor","SmtpUserName") = ""
 q ^ISCMonitor("Monitor","SmtpUserName")
}

/// Set email SMTP password
ClassMethod SmtpPassword(passwd As %String) As %String
{
 i $d(passwd) {
	 s ^ISCMonitor("Monitor","SmtpPasswordE") = $system.Encryption.Base64Encode(passwd)
	 q ^ISCMonitor("Monitor","SmtpPasswordE")
 }
 q $g(^ISCMonitor("Monitor","SmtpPasswordE"),"")
}

/// Set email recipients
ClassMethod Recipients(recipients As %List) As %List
{
 i $d(recipients) {
	s ^ISCMonitor("Monitor","Recipients") = recipients
 }
 else {
	i '$d(^ISCMonitor("Monitor","Recipients")) s ^ISCMonitor("Monitor","Recipients") = ""
 }
 s $zt="liste"
 s rec=^ISCMonitor("Monitor","Recipients")
 q:rec="" rec
 ; test old style comma-separated string
 s l=$ll(rec)
 q rec
liste
 ; convert old comma-separated string to a list
 s $zt=""
 i $ze'["<LIST>" w !,"ERROR: "_$ZE
 s newrec = ""
 f i=1:1:$length(rec,",") s newrec = newrec_$lb($p(rec,",",i))
 s ^ISCMonitor("Monitor","Recipients") = newrec
 q newrec
}

/// Set email SMTP Server name
ClassMethod AppSmtpServer(server As %String) As %String [ Internal ]
{
 i $d(server) s ^ISCMonitor("Monitor","AppSmtpServer") = server q ^ISCMonitor("Monitor","AppSmtpServer")
 i '$d(^ISCMonitor("Monitor","AppSmtpServer")) s ^ISCMonitor("Monitor","AppSmtpServer") = ""
 q ^ISCMonitor("Monitor","AppSmtpServer")
}

/// Email enabled
ClassMethod AppEnableEmail(enable As %Boolean) As %Boolean [ Internal ]
{
 i $d(enable) {
	 s ^ISCMonitor("Monitor","AppEmailEnabled")=enable
 }
 else {
	i '$d(^ISCMonitor("Monitor","AppEmailEnabled")) q 0
 }
 q ^ISCMonitor("Monitor","AppEmailEnabled")
}

/// Set email sender
ClassMethod AppEmailSender(sender As %String) As %String [ Internal ]
{
 i $d(sender) s ^ISCMonitor("Monitor","AppEmailSender") = sender q ^ISCMonitor("Monitor","AppEmailSender")
 i '$d(^ISCMonitor("Monitor","AppEmailSender")) s ^ISCMonitor("Monitor","AppEmailSender") = ""
 q ^ISCMonitor("Monitor","AppEmailSender")
}

/// Set email SMTP user name
ClassMethod AppSmtpUserName(name As %String) As %String [ Internal ]
{
 i $d(name) s ^ISCMonitor("Monitor","AppSmtpUserName") = name q ^ISCMonitor("Monitor","AppSmtpUserName")
 i '$d(^ISCMonitor("Monitor","AppSmtpUserName")) s ^ISCMonitor("Monitor","AppSmtpUserName") = ""
 q ^ISCMonitor("Monitor","AppSmtpUserName")
}

/// Set email SMTP password
ClassMethod AppSmtpPassword(passwd As %String) As %String [ Internal ]
{
 i $d(passwd) {
	 s ^ISCMonitor("Monitor","AppSmtpPasswordE") = $system.Encryption.Base64Encode(passwd)
	 q ^ISCMonitor("Monitor","AppSmtpPasswordE")
 }
 q $g(^ISCMonitor("Monitor","AppSmtpPasswordE"),"")
}

/// Set email recipients
ClassMethod AppRecipients(recipients As %List) As %List [ Internal ]
{
 i $d(recipients) {
	s ^ISCMonitor("Monitor","AppRecipients") = recipients
 }
 else {
	i '$d(^ISCMonitor("Monitor","AppRecipients")) s ^ISCMonitor("Monitor","AppRecipients") = ""
 }
 s $zt="liste"
 s rec=^ISCMonitor("Monitor","AppRecipients")
 q:rec="" rec
 ; test old style comma-separated string
 s l=$ll(rec)
 q rec
liste
 ; convert old comma-separated string to a list
 s $zt=""
 i $ze'["<LIST>" w !,"ERROR: "_$ZE
 s newrec = ""
 f i=1:1:$length(rec,",") s newrec = newrec_$lb($p(rec,",",i))
 s ^ISCMonitor("Monitor","AppRecipients") = newrec
 q newrec
}

/// Set alert level
ClassMethod AlertLevel(level As %Integer) As %Integer [ Internal ]
{
 i $d(level) {
	s ^ISCMonitor("Monitor","AlertLevel") = level
 }
 else {
	i '$d(^ISCMonitor("Monitor","AlertLevel")) s ^ISCMonitor("Monitor","AlertLevel") = 2
 }
 q ^ISCMonitor("Monitor","AlertLevel")
}

/// Register system classes in current namespace
ClassMethod Register(classname As %String) As %Status [ Internal ]
{
 s $zt="Error",$ze="",rc=$$$OK
 
 Set cdef = ##class(%Dictionary.CompiledClass).%OpenId(classname)
 If cdef = "" s $ze="Class does not exist" goto Error
 
 Set pkgname = $p(classname,".",1,$l(classname,".")-1)_".Sample."
 Set samplename = pkgname_$p(classname,".",$l(classname,"."))

 // Find the application parameters
 Do ##class(%Projection.Monitor).GetParms(cdef, .appname, .groupname, .idx)

 // Delete old metadata
 s id = appname_"||"_classname
 If ##class(%Monitor.ItemGroup).%ExistsId(id) {
	Set rc=##class(%Monitor.ItemGroup).%DeleteId(id)
	i $$$ISERR(rc) goto Error
 }
 // Generate application object (check if it exists first to avoid calling $$$ERROR macro inside ^build process)
 Lock +^Monitor.ApplicationD(appname):$$$LockTimeout Else  Set rc=$$$ERROR($$$GeneralError,"Unable to lock %Monitor.Application") Goto Error
 If ##class(%Monitor.Application).%ExistsId(appname) {
 	Set app = ##class(%Monitor.Application).%OpenId(appname)
 } Else {
	 Set app = ##class(%Monitor.Application).%New()
	 Set app.Name = appname
 }
 
 // Create itemgroup
 Set mclass = ##class(%Monitor.ItemGroup).%New()
 Set mclass.MetricsClassName = classname
 Set mclass.SampleClassName = samplename
 Set mclass.GroupName = groupname
 Set mclass.Description = cdef.Description
 Set mclass.Namespace = $zu(5)
 Set mclass.ApplicationName = appname

 Set mclass.Application = app
 s rc = app.%Save()
 Lock -^Monitor.ApplicationD(appname)#"I"
 i $$$ISERR(rc) goto Error
 Set mclassId = mclass.%Id()

 // process properties
 Set count = cdef.Properties.Count()
 For i = 1:1:count {
	// Property parameters
	Set prop = cdef.Properties.GetAt(i)
	If $Piece(prop.Type,".",1) '= "%Monitor" Continue
	Set parms = prop.Parameters

	Set item = ##class(%Monitor.Item).%New()
	Set item.Name = prop.Name
	Set item.Description = prop.Description
	Set item.Type = $Piece(prop.Type,".",2)

	Set item.MaxVal = parms.GetAt("MAXVAL")
	Set item.MaxLen = parms.GetAt("MAXLEN")
	Set item.MinVal = parms.GetAt("MINVAL")
	Set item.MinLen = parms.GetAt("MINLEN")
	
	Set item.ItemGroup = mclass
	Set rc = mclass.%Save()
	i $$$ISERR(rc) goto Error

	
	k item,prop
 }
 // process the index
 if idx '= "" {
	 Set count = $length(idx,",")
	 For i=1:1:count {
		 Set prop = $p(idx,",",i)
	 }
 }
 Set mclass.Index = idx
 Set rc = mclass.%Save()
 i $$$ISERR(rc) goto Error
 
 Set rc = app.%Save()
 i $$$ISERR(rc) goto Error
 QUIT $$$OK
Error
 Set $ZT=""
 i $$$ISERR(rc) Q rc
 Quit $$$ERROR($$$CacheError,$ze)
}

/// Queues an alert
ClassMethod Alert(name As %String, app As %String = "", text As %String = "") As %Integer [ Internal ]
{
 s dt=$zdt($h,3)
 s sc = ##class(%Monitor.Alert).GetId(name,app,.id)
 if id="" q 0
 s alert=##class(%Monitor.Alert).%OpenId(id)
 i '$IsObject(alert) q 0
 s ^ISCMonitor("Monitor","Alert Queue",0,dt,id)=text
 q $$$OK
}

}
