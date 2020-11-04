Include %syDataCheck

/// Workflow to be performed by running system.  See <CLASS>System</CLASS> for overview.
/// An instance of this class is referenced by each <CLASS>Destination</CLASS> object.
/// <p>
/// The workflow is a numbered list of phases.  Each phase is an object of one of the following classes:
/// <br><CLASS>PhaseCheck</CLASS>, <CLASS>PhaseRecheckDiscrepancies</CLASS>, <CLASS>PhaseStop</CLASS>, or 
/// <CLASS>PhaseIdle</CLASS>.
/// <p>
/// Each phase object represents a set of actions that the system will take and includes
/// properties to act as the functional parameters of the phase (as well as internal properties to 
/// manage internal state).  When the Workflow object is created as part of the creation of a
/// new DataCheck <CLASS>Destination</CLASS> object, it is set up with a default set of phases:
/// 1 - Check, 2 - ReCheckDiscrepancies (with 10 iterations), and 3 - Stop.
/// <p>
/// The system proceeds through the phases in numerical order and on completion of the last
/// phase, begins the fist phase anew.  The Workflow object can be modified at any time while
/// the system is running, and can be used to force the system to move to a new phase, or
/// redefine the list of phases.
/// <p>
/// If DataCheck stops in the middle of processing (e.g. in the Check or RecheckDiscrepancy phase)
/// there are options upon starting again to restart from phase #1 of the workflow anew rather than
/// resume processing the current phase.  The first phase, therefore, should be set up to be the
/// logical beginning of the workflow.  The options to restart from phase #1 take three forms: 
/// the <PROPERTY>Timeout</PROPERTY> property in this object, an argument to the Start method
/// of the <CLASS>Destination</CLASS> object, and interactive dialog for starting in ^DATACHECK.
/// <p>
/// As an example, the following code snippet changes the workflow back to the default 
/// set of phases and sets the system to immediately go back to the first phase:<br>
/// <CODE>
/// <br>	set workflow=##class(SYS.DataCheck.Workflow).%OpenId(name)
/// <br>	set sc=workflow.Phases.Clear() quit:$$$ISERR(sc) sc
/// <br>	set p=##class(SYS.DataCheck.PhaseCheck).%New()
/// <br>	set sc=workflow.Phases.Insert(p) quit:$$$ISERR(sc) sc
/// <br>	set p=##class(SYS.DataCheck.PhaseRecheckDiscrepancies).%New()
/// <br>	set p.Iterations=10
/// <br>	set sc=workflow.Phases.Insert(p) quit:$$$ISERR(sc) sc
/// <br>	set p=##class(SYS.DataCheck.PhaseStop).%New()
/// <br>	set sc=workflow.Phases.Insert(p) quit:$$$ISERR(sc) sc
/// <br>	set workflow.NewPhaseNumber=1 ; start at phase 1
/// <br>	set workflow.AbortCurrentPhase=1 ; stop working on the current phase
/// <br>	set sc=workflow.%Save()
/// <br>	quit sc
/// </CODE>
/// 
Class SYS.DataCheck.Workflow Extends %Persistent
{

/// Name of the DataCheck Destination system that uses this object.
/// Set upon creating the destination object and should not be changed.
/// 
Property SystemName As SystemName [ Required ];

Index IdIndex On SystemName [ IdKey ];

/// Numbered list of phases
Property Phases As list Of Phase(CLASSNAME = 1);

/// User-specified new phase number.  If not set (or set to zero)
/// the system will move to the phase that follows its current
/// phase when the current phase is complete.  If set to a phase
/// number the system will move to the specified phase when the
/// current phase is complete.
Property NewPhaseNumber As %Integer(MINVAL = 0);

/// If true, the system will abort the phase of the workflow
/// that it is currently processing and move to the next phase
/// immediately rather than allow this phase to complete any
/// queries it is currently processing.
Property AbortCurrentPhase As %Boolean [ InitialExpression = 0 ];

/// Version used for optimistic concurrency
Property Version As %Integer [ Internal ];

/// If the DataCheck system becomes stopped, disconnected, or paused 
/// (waiting for mirroring) in the middle of the check, then upon 
/// returning to the running state, the system would normally resume
/// the workflow from where it left off.  If the system does not 
/// return to the running state within some reasonable period, it may
/// not be desireable to automatically resume the workflow.  For 
/// example, if the systems were disconnected for several weeks in 
/// the middle of a check and then the check is resumed, the results
/// are of questionable value, having been collected in part from two
/// weeks prior and in part from the present time.
/// 
/// <p>This property is the time, in seconds, within which DataCheck
/// may resume a partially completed workflow phase.  If this timeout
/// is exceeded, it will restart from phase number one.  A value of 
/// zero will always resume, never restart.
/// 
/// <p>Default is five days (432000), on the assumption that a large
/// amount of data is checked by this DataCheck configuration and the 
/// check may take a day or more to complete.  A smaller value may be
/// desired for configurations that complete a check in a shorter amount
/// of time.
Property Timeout As %Integer [ InitialExpression = 432000 ];

/// VERSIONPROPERTY = &lt;property&gt; means that the &lt;property&gt; in memory will be compared to
/// the &lt;property&gt; on disk during an update. If different a concurrency conflict
/// error will be reported and the save will fail.
Parameter VERSIONPROPERTY As STRING [ Internal ] = "Version";

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
}

Storage Default
{
<Data name="WorkflowDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Phases</Value>
</Value>
<Value name="3">
<Value>NewPhaseNumber</Value>
</Value>
<Value name="4">
<Value>AbortCurrentPhase</Value>
</Value>
<Value name="5">
<Value>Version</Value>
</Value>
<Value name="6">
<Value>Timeout</Value>
</Value>
</Data>
<DataLocation>^SYS.DataCheck.WorkflowD</DataLocation>
<DefaultData>WorkflowDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^SYS.DataCheck.WorkflowD</IdLocation>
<IndexLocation>^SYS.DataCheck.WorkflowI</IndexLocation>
<StreamLocation>^SYS.DataCheck.WorkflowS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
