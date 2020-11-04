Class %SYS.Task.PurgeZENReports Extends %SYS.Task.Definition [ System = 4 ]
{

Parameter TaskName = "Purge ZEN Reports";

Method OnTask() As %Status
{
	; When ZEN Reports generates a temporary PDF file for printing it creates an entry in ^SYS("ZENReports","filestopurge",index)
	; based on incrementing through index=$i(^SYS("ZENReports","filestopurge"))
	; It sets the value at index to $LB(filename,$zdt($zts,3))
	
	#;We must run in %SYS
		d $zu(5,"%SYS")
		Do DeleteFilesFromQueue^%occZENReports()
		Quit $$$OK
}

}
