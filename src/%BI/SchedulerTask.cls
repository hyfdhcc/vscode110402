Class %BI.SchedulerTask Extends %SerialObject [ ClassType = serial, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property Name As %String(TRUNCATE = 1);

Property ComplexCode As %String(TRUNCATE = 1);

Property Functions As %String(TRUNCATE = 1);

Property Class As %String(TRUNCATE = 1);

Property TaskType As %String(TRUNCATE = 1);

Property ReportId As %String(TRUNCATE = 1);

Property ReportName As %String(TRUNCATE = 1);

Property Filter As %String(TRUNCATE = 1);

Property QueryVar As %String(TRUNCATE = 1);

Property Action As %String(TRUNCATE = 1);

Property Subject As %String(TRUNCATE = 1);

Property Message As %String(TRUNCATE = 1);

Property PivotId As %String(TRUNCATE = 1);

//Property PivotQry As %String;

Property PivotActionMail As %String(TRUNCATE = 1);

Property PivotActionMsg As %String(TRUNCATE = 1);

Property PivotSubject As %String(TRUNCATE = 1);

Property PivotMsgBody As %String(TRUNCATE = 1);

Property PivotDateLine As %String(TRUNCATE = 1);

Property PivotPriority As %String(TRUNCATE = 1);

Property PivotActType As %String(TRUNCATE = 1);

Property BPMId As %String(TRUNCATE = 1);

Property RetRpt As %String(TRUNCATE = 1);

Property Desc As %String(TRUNCATE = 1);

Property SuspendTsk As %String(TRUNCATE = 1);

Property GrpRebuild As %String;

Property TaskCondi As %String(TRUNCATE = 1);

Property PivotRoleID As %String(TRUNCATE = 1);

Storage Default
{
<Data name="SchedulerTaskState">
<Subscript>"%BI.SchedulerTask"</Subscript>
<Value name="1">
<Value>TaskType</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Class</Value>
</Value>
<Value name="4">
<Value>ComplexCode</Value>
</Value>
<Value name="5">
<Value>Functions</Value>
</Value>
<Value name="6">
<Value>ReportId</Value>
</Value>
<Value name="7">
<Value>ReportName</Value>
</Value>
<Value name="8">
<Value>Filter</Value>
</Value>
<Value name="9">
<Value>QueryVar</Value>
</Value>
<Value name="10">
<Value>Subject</Value>
</Value>
<Value name="11">
<Value>Message</Value>
</Value>
<Value name="12">
<Value>Action</Value>
</Value>
<Value name="13">
<Value>PivotAction</Value>
</Value>
<Value name="14">
<Value>PivotId</Value>
</Value>
<Value name="15">
<Value>PivotActionMail</Value>
</Value>
<Value name="16">
<Value>PivotActionMsg</Value>
</Value>
<Value name="17">
<Value>PivotDateLine</Value>
</Value>
<Value name="18">
<Value>PivotMsgBody</Value>
</Value>
<Value name="19">
<Value>PivotPriority</Value>
</Value>
<Value name="20">
<Value>PivotSubject</Value>
</Value>
<Value name="21">
<Value>PivotActType</Value>
</Value>
<Value name="22">
<Value>BPMId</Value>
</Value>
<Value name="23">
<Value>RetRpt</Value>
</Value>
<Value name="24">
<Value>Desc</Value>
</Value>
<Value name="25">
<Value>SuspendTsk</Value>
</Value>
<Value name="26">
<Value>DailyEndTime</Value>
</Value>
<Value name="27">
<Value>DailyFrequency</Value>
</Value>
<Value name="28">
<Value>DailyFrequencyTime</Value>
</Value>
<Value name="29">
<Value>DailyIncrement</Value>
</Value>
<Value name="30">
<Value>DailyStartTime</Value>
</Value>
<Value name="31">
<Value>DayNextScheduled</Value>
</Value>
<Value name="32">
<Value>Description</Value>
</Value>
<Value name="33">
<Value>ER</Value>
</Value>
<Value name="34">
<Value>EmailOnCompletion</Value>
</Value>
<Value name="35">
<Value>EmailOnError</Value>
</Value>
<Value name="36">
<Value>EmailOnExpiration</Value>
</Value>
<Value name="37">
<Value>EmailOutput</Value>
</Value>
<Value name="38">
<Value>EndDate</Value>
</Value>
<Value name="39">
<Value>Error</Value>
</Value>
<Value name="40">
<Value>Expires</Value>
</Value>
<Value name="41">
<Value>ExpiresDays</Value>
</Value>
<Value name="42">
<Value>ExpiresHours</Value>
</Value>
<Value name="43">
<Value>ExpiresMinutes</Value>
</Value>
<Value name="44">
<Value>IsBatch</Value>
</Value>
<Value name="45">
<Value>JobGUID</Value>
</Value>
<Value name="46">
<Value>LastFinished</Value>
</Value>
<Value name="47">
<Value>LastSchedule</Value>
</Value>
<Value name="48">
<Value>LastStarted</Value>
</Value>
<Value name="49">
<Value>NameSpace</Value>
</Value>
<Value name="50">
<Value>OpenOutputFile</Value>
</Value>
<Value name="51">
<Value>OutputDirectory</Value>
</Value>
<Value name="52">
<Value>OutputFileIsBinary</Value>
</Value>
<Value name="53">
<Value>OutputFilename</Value>
</Value>
<Value name="54">
<Value>Priority</Value>
</Value>
<Value name="55">
<Value>RescheduleOnStart</Value>
</Value>
<Value name="56">
<Value>RunAfterGUID</Value>
</Value>
<Value name="57">
<Value>RunAsUser</Value>
</Value>
<Value name="58">
<Value>RunningJobNumber</Value>
</Value>
<Value name="59">
<Value>Settings</Value>
</Value>
<Value name="60">
<Value>StartDate</Value>
</Value>
<Value name="61">
<Value>Status</Value>
</Value>
<Value name="62">
<Value>Suspended</Value>
</Value>
<Value name="63">
<Value>TaskClass</Value>
</Value>
<Value name="64">
<Value>TimeNextScheduled</Value>
</Value>
<Value name="65">
<Value>TimePeriod</Value>
</Value>
<Value name="66">
<Value>TimePeriodDay</Value>
</Value>
<Value name="67">
<Value>TimePeriodEvery</Value>
</Value>
<Value name="68">
<Value>Type</Value>
</Value>
<Value name="69">
<Value>GrpRebuild</Value>
</Value>
<Value name="70">
<Value>taskCondi</Value>
</Value>
<Value name="71">
<Value>TaskCondi</Value>
</Value>
<Value name="72">
<Value>PivotRoleID</Value>
</Value>
</Data>
<State>SchedulerTaskState</State>
<StreamLocation>^BI.SchedulerTaskS</StreamLocation>
<Type>%Library.CacheSerialState</Type>
}

}
