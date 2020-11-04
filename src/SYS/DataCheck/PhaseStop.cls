/// Stops DataCheck.  On starting, DataCheck moves to the next phase.
/// 

Class SYS.DataCheck.PhaseStop Extends SYS.DataCheck.Phase
{

Parameter SHORTDESCRIPTION As STRING [ Internal ] = "Stop the DataCheck system";

Method OnAction() As %Status [ Internal ]
{
}

Storage Default
{
<Type>%Library.CacheSerialState</Type>
}

}
