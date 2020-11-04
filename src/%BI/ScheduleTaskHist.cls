Class %BI.ScheduleTaskHist Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index IdKey On (ScheduleID, ScheduleStartDate, ScheduleStartTime, TaskID) [ IdKey, Unique ];

Property EndDate As %Date;

Property EndTime As %Time;

Property Error As %String;

Property ScheduleID As %String;

Property ScheduleStartDate As %Date;

Property ScheduleStartTime As %Time;

Property StartDate As %Date;

Property StartTime As %Time;

Property Status As %String;

Property TaskID As %String;

Property UserID As %Integer;

ClassMethod DeleteHist(Para As %String)
{
	s ScheID=$p(Para,"||",1),Date=$p(Para,"||",2),Time=$p(Para,"||",3),Year=$p(Para,"||",4)
	d DeleteHist^%bi.SWr.WebScheduler6(ScheID,Date,Time,Year)
}

//latest schedule status

Query TaskHistory(SchID As %String, TaskID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,EndDate,EndTime,Error,ScheduleID,StartDate,StartTime,Status,TaskID FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :SchID AND TaskID = :TaskID)
 ORDER BY ScheduleStartDate desc, ScheduleStartTime desc
}

//task level, specific date & time

Query ScheIdTaskDateTime(SchID As %String, Task As %String, Date As %Date, Time As %Time) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,EndDate,EndTime,Error,ScheduleID,ScheduleStartDate,ScheduleStartTime,StartDate,StartTime,Status,TaskID,UserID FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :SchID AND TaskID = :Task AND ScheduleStartDate = :Date AND ScheduleStartTime = :Time)
}

//latest schedule status

Query ByScheIDTaskID(ScheID As %String, TID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT EndDate,EndTime,Error,ScheduleID,ScheduleStartDate,ScheduleStartTime,Status,TaskID FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :ScheID AND TaskID = :TID)
 ORDER BY ScheduleStartDate desc, ScheduleStartTime desc
}

//list of history

Query BySchDesc(ScheID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT EndDate,EndTime,Error,ScheduleID,ScheduleStartDate,ScheduleStartTime,Status FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :ScheID)
 ORDER BY ScheduleStartDate DESC, ScheduleStartTime DESC
}

//task level view by schedule, all

Query BySchID(ScheID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT EndDate,EndTime,Error,ScheduleID,ScheduleStartDate,ScheduleStartTime,Status,TaskID FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :ScheID)
 ORDER BY ScheduleStartDate DESC, ScheduleStartTime DESC, TaskID asc
}

//Use in deleting schedule hist by ID

Query DeleteById(ScheID As %String) As %SQLQuery
{
SELECT %ID, ScheduleID FROM %BI.ScheduleTaskHist
WHERE (ScheduleID = :ScheID)
}

//Use in deleting specific hist by date and time

Query ScheIdDateTime(SchID As %String, Date As %Date, Time As %Time) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ScheduleID,ScheduleStartDate,ScheduleStartTime FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :SchID AND ScheduleStartDate = :Date AND ScheduleStartTime = :Time)
}

//Use in deleting hist by range of day

Query DeleteRange(SchID As %String, Date As %Date) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ScheduleID,ScheduleStartDate FROM %BI.ScheduleTaskHist
 WHERE (ScheduleID = :SchID AND ScheduleStartDate <= :Date)
}

//Use on deleting hist by range regardless of Scheduler ID

Query DeleteRangeAll(Date As %Date) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,ScheduleStartDate FROM %BI.ScheduleTaskHist
 WHERE (ScheduleStartDate <= :Date)
}

Storage Default
{
<Data name="ScheduleTaskHistDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EndDate</Value>
</Value>
<Value name="3">
<Value>EndTime</Value>
</Value>
<Value name="4">
<Value>Error</Value>
</Value>
<Value name="5">
<Value>StartDate</Value>
</Value>
<Value name="6">
<Value>StartTime</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
<Value name="8">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^BI.ScheduleTaskHistD</DataLocation>
<DefaultData>ScheduleTaskHistDefaultData</DefaultData>
<IdLocation>^BI.ScheduleTaskHistD</IdLocation>
<IndexLocation>^BI.ScheduleTaskHistI</IndexLocation>
<StreamLocation>^BI.ScheduleTaskHistS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
