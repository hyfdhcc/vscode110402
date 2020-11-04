/// Rechecks any global ranges in the current set of results that has a value other
/// than Matched.  Set property <PROPERTY>Iterations</PROPERTY> to the desired
/// number of times to recheck each discrepant range.  The phase ends when after that
/// number of iterations, or when there are no more discrepant ranges.
/// 
Class SYS.DataCheck.PhaseRecheckDiscrepancies Extends SYS.DataCheck.Phase
{

Property Iterations As %Integer [ InitialExpression = 1 ];

Property CurrentIteration As %Integer [ InitialExpression = 0, Internal ];

Parameter SETUPPROPERTIES As STRING [ Flags = LIST, Internal ] = "Iterations";

Parameter STATEPROPERTIES As STRING [ Flags = LIST, Internal ] = "CurrentIteration";

/// Override this property with a string describing the purpose of this action type.
Parameter SHORTDESCRIPTION As STRING [ Internal ] = "Recheck any discrepant global ranges";

Method OnAction() As %Status [ Internal ]
{
}

Storage Default
{
<Data name="PhaseState">
<Value name="1">
<Value>%Repeat</Value>
</Value>
<Value name="2">
<Value>%SystemName</Value>
</Value>
<Value name="3">
<Value>%CreatedQueries</Value>
</Value>
<Value name="4">
<Value>Iterations</Value>
</Value>
<Value name="5">
<Value>CurrentIteration</Value>
</Value>
</Data>
<Type>%Library.CacheSerialState</Type>
}

}
