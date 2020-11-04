/// Monitor Service. No class data exchanged here.
Class EMS.Service.Monitor Extends EMS.Service.Base
{

/// Get the localized name of the service
/// This method must be overridden for each service
ClassMethod GetLocalizedName() As %String
{
	Quit $$$Text("Monitor")
}

/// Return MonitorStatus
ClassMethod MonitorStatus(Output message As EMS.DataMessage) As EMS.Error [ Internal ]
{
	Set message=##class(EMS.DataMessage).%New()
	Do message.Data.SetAt($system.Monitor.State(),"Status")
	Quit ""
}

Storage Default
{
<Type>%Library.CacheStorage</Type>
}

}
