Include (%syMonitor, %syPidtab, %sySystem, %occErrors)

Class SYS.Monitor.SystemNotify Extends %SYS.Monitor.AbstractNotification [ System = 3 ]
{

/// Alert flag
Property Alertson As %Integer [ InitialExpression = 1, Internal ];

/// Latest alert time
Property AlertTime As %Integer [ InitialExpression = 0, Internal ];

/// Alert latest time per sensor
Property Alerts [ Internal, MultiDimensional ];

/// Alert count
Property Alertcount As %Integer [ InitialExpression = 0, Internal ];

/// Warning latest time
Property Warnings [ Internal, MultiDimensional ];

/// Warned sensors
Property WarnSensor [ Internal, MultiDimensional ];

/// Monitor alerts count
Property MonitorAlerts As %Integer [ InitialExpression = 0, Internal ];

/// Day number
Property Today As %Integer [ Internal ];

/// System notification class All user apps taking part in SYS.Monitor call this interface for notification.
Method Post() As %Status [ Internal ]
{
}

/// Save alert to persistent class
Method SaveAlert(Sensor As %String, Msg As %String, PrevState As %Integer, CurState As %Integer) As %Status [ Internal ]
{
}

Method PurgeAlerts() As %Status [ Internal ]
{
}

/// init the alert persistent class
Method %OnNew(initval As %Integer) As %Status [ Private ]
{
}

}
