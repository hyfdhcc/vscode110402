Include %sySite

/// The <class>%SYSTEM.Monitor</class> class provides an interface for managing
/// Cach&eacute; System Monitor functions.<br>
/// 
/// <p>You can use it via the special <b>$SYSTEM</b> object.
/// <p>
/// <p>You can call help to get a list of all entrypoints:<br>
/// <p>
/// Do $SYSTEM.Monitor.Help()
Class %SYSTEM.Monitor Extends Help [ Abstract, System = 4 ]
{

/*
"State",
"SetState",
"Alerts",
"ClearAlerts",
"Clear",
*/
/// Returns the system state as an integer.
/// <p>
/// -1: System is hung<br>
///  0: System state is OK<br>
///  1: System state is Warning<br>
///  2: System state is Alert
ClassMethod State() As %Integer
{
}

/// Set the system state. See State() for allowed integer values.
ClassMethod SetState(State As %Integer) As %Integer [ Internal ]
{
}

/// Returns the number of alerts posted to cconsole.log.
ClassMethod Alerts() As %Integer [ Internal ]
{
}

/// Clears the alerts counter.
ClassMethod ClearAlerts() As %Integer [ Internal ]
{
}

/// Clears the alerts counter and sets the system state = 0 (OK).
ClassMethod Clear() As %Integer [ Internal ]
{
}

}
