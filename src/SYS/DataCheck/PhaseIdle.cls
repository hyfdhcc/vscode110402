/// Causes the DataCheck system to enter an idle loop, where it maintains connection
/// but does not create any queries.  The system will advance when the Workflow
/// is modified to specify a new phase (either manually by a user, or programatically).
/// 

Class SYS.DataCheck.PhaseIdle Extends SYS.DataCheck.Phase
{

Parameter SHORTDESCRIPTION As STRING [ Internal ] = "Wait for user to specify next workflow phase";

Property %Repeat As %Integer [ InitialExpression = 1, Internal, SqlFieldName = percent_Repeat ];

Storage Default
{
<Type>%Library.CacheSerialState</Type>
}

}
