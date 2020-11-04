Class %ZEN.Report.Semaphore Extends %RegisteredObject [ System = 4 ]
{

ClassMethod SetSemaphoreInitialValue(Name As %String, InitialValue As %Integer, TimeOut As %Integer = 30)
{
	Set ^CacheTemp.ZENReport.Semaphore(Name,1)=InitialValue
	Set ^CacheTemp.ZENReport.Semaphore(Name,2)=TimeOut
}

ClassMethod Wait(Name As %String) As %Status
{
	If '$D(^CacheTemp.ZENReport.Semaphore(Name)) Quit $$$OK
	Lock +^CacheTemp.ZENReport.Semaphore(Name,"wait"):^CacheTemp.ZENReport.Semaphore(Name,2)
	Quit:'$Test $$$ERROR($$$GeneralError,"Timeout waiting")	
	while ^CacheTemp.ZENReport.Semaphore(Name,1) <= 0 {
		Hang 1
	}
	Lock +^CacheTemp.ZENReport.Semaphore(Name,"atomic"):5
	if '$Test {
		Lock -^CacheTemp.ZENReport.Semaphore(Name,"wait")
		q $$$ERROR($$$GeneralError,"Timeout waiting for atomic operation")	
	}
	; Decrement Semaphore
	Set ^CacheTemp.ZENReport.Semaphore(Name,1)=^CacheTemp.ZENReport.Semaphore(Name,1)-1
	Lock -^CacheTemp.ZENReport.Semaphore(Name,"atomic")
	Lock -^CacheTemp.ZENReport.Semaphore(Name,"wait")
	Quit $$$OK
}

ClassMethod Signal(Name As %String) As %Status
{
	If '$D(^CacheTemp.ZENReport.Semaphore(Name)) Quit $$$OK
	; increment Semaphore
	Lock +^CacheTemp.ZENReport.Semaphore(Name,"atomic"):5
	Quit:'$Test $$$ERROR($$$GeneralError,"Timeout signaling semaphore for atomic operation")	
	If $I(^CacheTemp.ZENReport.Semaphore(Name,1)) ; increment
	Lock -^CacheTemp.ZENReport.Semaphore(Name,"atomic")
	Quit $$$OK
}

}
