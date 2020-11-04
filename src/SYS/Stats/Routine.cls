/// This class represents system metrics captured for routines. Each property is a different metric. 
/// A class may be instantiated by calling the class method 'Sample', and then the current
/// value of each property can be accessed.
/// <br><br>
/// For example:
/// <example>
/// s ref=##class(SYS.Stats.Routine).Sample()
/// w ref.RtnCommands ; display number of routine commands executed
/// </example>
///  
/// System stats for Routine activity
Class SYS.Stats.Routine Extends SYS.WSMon.wsResource [ System = 4 ]
{

/// The count of all routine lines executed on the system.
/// NOTE: This property is deprecated, line counts are no longer available and this actually returns the RtnCommands.
/// It is left here for backwards compatibility, but should no longer be used.
Property RtnLines As %Integer;

/// The count of all routine commands executed on the system.
Property RtnCommands As %Integer;

/// The count of all routine calls where the routine is stored locally.
Property RtnCallsLocal As %Integer;

/// The count of all routine calls where the routine is stored remotely.
Property RtnCallsRemote As %Integer;

/// The number of times that local routines were fetched from disk into buffers (or saved to disk) 
Property RtnFetchLocal As %Integer;

/// The number of times that remote routines were fetched from disk into buffers (or saved to disk) 
Property RtnFetchRemote As %Integer;

/// Instantiate the class and fill in current values for all properties.
ClassMethod Sample() As SYS.Stats.Global
{
}

}
