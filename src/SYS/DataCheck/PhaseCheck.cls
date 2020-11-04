/// Begins a new check on all globals that the system is configured to check.
/// Starts a new <CLASS>RangeList</CLASS> listset to hold the results of the new check.  The previous
/// set of results is saved and any earlier set is purged.
/// 

Class SYS.DataCheck.PhaseCheck Extends SYS.DataCheck.Phase
{

/// Override this property with a string describing the purpose of this action type.
Parameter SHORTDESCRIPTION As STRING [ Internal ] = "Check consistency of all globals selected";

/// Called on each iteration of the action to perform the action (typically to create queries).
/// The system starts a transaction before calling this method to guarantee that all queries
/// created are created atomically and that the nextphase
Method OnAction() As %Status [ Internal ]
{
}

Parameter FINDGLOBALS As INTEGER [ Constraint = "0,1,2", Flags = ENUM, Internal ] = 1;

Storage Default
{
<Type>%Library.CacheSerialState</Type>
}

}
