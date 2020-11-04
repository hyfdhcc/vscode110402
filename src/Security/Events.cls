Include (%syAudit, %sySecurity, %sySystem, %occErrors, %syEMS, %ems)

/// This class defines the Audit Events for the system.<br><br>
/// An Event name consists of 3 separate fields:<br><br>
/// 1) Source - Source of the event<br>
/// 2) Type - Type of the event<br>
/// 3) Event - Name of the event<br><br>
/// And Event name is the combination of the 3 fields separated
/// by "/". For example:<br><br>
/// %System/%Login/Login<br><br>
/// Event names have the following properties:<br>
/// 1) Source, Type, and Event fields are case insensitive.<br>
/// 2) Source, Type, and Event fields cannot contain a "/".<br>
/// 3) Only system defined events can have a Source = "%System" or Source start with a "%".<br>
/// 4) Only system defined events can have a Type start with a "%".<br>
/// <br><br>
/// The table for this class should be manipulated only through object access, the published API's
/// or through the System Management Portal. It should not be updated through direct SQL access.<br>
Class Security.Events Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

Index SourceTypeNameLowerCaseIndex On (SourceLowerCase, TypeLowerCase, NameLowerCase) [ IdKey, Unique ];

Parameter EMSSERVICE [ Internal ] = "Security";

/// Description of the event.
Property Description As %String(MAXLEN = 256);

/// Event enabled.
Property Enabled As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

/// Flags.<br>
/// Internal use only, user defined events should set this to 0.<br>
/// Bit 0 - System defined event<br>
/// Bit 1 - Reserved, previously was Mandatory Events. When saving the object, we now AND out this bit. Do
/// not re-use this bit as customers may have exported event records with this bit set.
Property Flags As %Integer(MAXVAL = 3, MINVAL = 0) [ InitialExpression = 0, Internal ];

/// Name of the event.
Property Name As %String(MAXLEN = 64, MINLEN = 1);

/// Name of the event.
Property NameLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly ];

/// Source (system events all have "%System" here).
Property Source As %String(MAXLEN = 64, MINLEN = 1);

/// Source (system events all have "%System" here).
Property SourceLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly ];

/// Type.
Property Type As %String(MAXLEN = 64, MINLEN = 1);

/// Type.
Property TypeLowerCase As %String(MAXLEN = 64, MINLEN = 1, XMLPROJECTION = "NONE") [ Internal, ReadOnly ];

/// Clear the in memory event counters for the specified events.<br>
/// EventSources - Comma separated list of Event Sources, "*" = All<br>
/// EventTypes - Comma separated list of Types Sources, "*" = All<br>
/// Events - Comma separated list of Events, "*" = All<br>
ClassMethod Clear(EventSources As %String = "*", EventTypes As %String = "*", EventNames As %String = "*") As %Status
{
}

/// Create an Event.<br>
/// Create an Event in the Security database.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specification in the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// Description - Description of the Event<br>
/// Enabled - Enabled for auditing - 0/1<br>
/// Flags - Internal use only. Pass 0 for this value.<br>
ClassMethod Create(Source As %String, Type As %String, Name As %String, Description As %String = "", Enabled As Security.Datatype.BooleanYN = 1, Flags As %Integer = 0) As %Status
{
}

/// Handle %OpenId for EMS update. Check for non-existant System Events and ignore them.
/// This happens primarily if we have mixed Cache and Ensemble Instances in a Group.
ClassMethod EMSOpen(id As %String, concurrency As %Integer = -1, ByRef sc As %Status) As %RegisteredObject [ Internal ]
{
}

/// Delete an Event.<br>
/// This method will delete an Event from the security database.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specification in the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// This method also clears the in memory counters.<br>
ClassMethod Delete(Source As %String, Type As %String, Name As %String) As %Status
{
}

/// Event exists.<br>
/// This method checks for the existence of an Event in the security database.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specificationin the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// Return values:<br>
/// If Value of the method = 0 (Event does not exist, or some error occured)<br>
/// Event = Null<br>
/// Status = Event "x" does not exist, or other error message<br><br>
/// If Value of the method = 1 (Event exists)<br>
/// Event = Object handle to Event<br>
/// Status = $$$OK<br>
ClassMethod Exists(Source As %String = "", Type As %String = "", Name As %String = "", ByRef Event As %ObjectHandle, ByRef Status As %Status) As %Boolean
{
}

/// This method exports Event records to a file in xml format.<br>
/// Parameters:<br>
/// Filename -  Output file name<br>
/// NumExported (byref) -  Returns number of records exported.<br>
/// Sources - Comma separated list of Sources to export, "*" = All<br>
/// Types - Comma separated list of Types to export, "*" = All<br>
/// Names - Comma separated list of event Names to export, "*" = All<br>
ClassMethod Export(FileName As %String = "EventsExport.xml", ByRef NumExported As %Integer, Sources As %String = "*", Types As %String = "*", Names As %String = "*") As %Status
{
}

/// Get an Events properties.<br>
/// Gets an Events properties from the security database.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specification in the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// Return values:<br>
/// Properties - Array of properties<br>
/// "Description" - Description of the event<br>
/// "Enabled" - Event is enabled for auditing<br>
/// "Flags" - Internal use only<br>
ClassMethod Get(Source As %String, Type As %String, Name As %String, ByRef Properties As %String) As %Status
{
}

/// Get an Events properties.<br>
/// Gets an Events properties from the security database.<br>
/// Parameters:<br>
/// Event - Object handle to an Event record<br>
/// Return values:<br>
/// Properties - See the Get method for more information on properties returned
ClassMethod GetProperties(Event As %ObjectHandle, ByRef Properties As %String) As %Status [ Internal ]
{
}

/// Import Event records from an xml file.<br>
/// Parameters:<br>
/// FileName - Filename to import Event records from<br>
/// NumImported (byref) - Returns number of records imported<br>
/// Flags - Control import<br>
/// Bit 0 - Do not import records, just return count<br>
/// Note: On failure, no records will be imported<br>
ClassMethod Import(FileName As %String = "EventsExport.xml", ByRef NumImported As %Integer, Flags As %Integer = 0) As %Status
{
}

/// Initializes the Event database for the first time when the system is installed.<br>
/// This is callable anytime to make sure all the system events are created/defined.
/// If any are missing, it will add them.<br>
ClassMethod Initialize(SecuritySetting As %String = "None", Flag As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

/// Modify an Event's properties.<br>
/// Modifies an Event's properties from the security database.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specification in the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// See the Get() method for a description of the Properties parameter.<br>
/// If a specific property is not passed in the properties array, 
/// the value is not modified.<br>
ClassMethod Modify(Source As %String = "", Type As %String = "", Name As %String = "", ByRef Properties As %String) As %Status
{
}

/// Given an event name, return its description
ClassMethod NameToDescription(Name As %String, Description As %String) As %String [ Internal ]
{
}

/// Set or clear the in-memory audit flags.<br>
/// This method will set or clear the in memory audit flag for the specified event.
/// Upon restart of the system, the permanent value will be restored.<br>
/// Parameters:<br>
/// Source - Source of the Event. This may also contain an entire Event 
/// specification in the format Source/Type/Name. If this is the case the Type
/// and Name parameters are ignored.<br>
/// Type - Type of the Event<br>
/// Name - Name of the Event<br>
/// Enabled - Enabled for auditing - 0/1<br>
/// Flag - Internal use only<br>
ClassMethod Set(Source As %String = "", Type As %String = "", Name As %String = "", Enabled As Security.Datatype.BooleanYN = 0, Flag As %Integer = 0) As %Status [ Internal ]
{
}

/// Turn on the in memory audit events for all enabled events.<br>
/// Flags - Bitmask of the following:<br>
/// Bit 0 - Do not clear in memory counters<br>
ClassMethod Start(Flags As %Integer = 0) As %Status [ Internal ]
{
}

/// Initialize an EMS client when an event changes
ClassMethod StartEMS() As %Status [ Internal ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called after 
/// the object's data has been successfully written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnAfterSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Save</METHOD> method to 
/// provide notification that the object is being saved. It is called before 
/// any data is written to disk.
/// 
/// <P><VAR>insert</VAR> will be set to 1 if this object is being saved for the first time.
/// 
/// <P>If this method returns an error then the call to <METHOD>%Save</METHOD> will fail.
Method %OnBeforeSave(insert As %Boolean) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%Delete</METHOD> method to 
/// provide notification that the object specified by <VAR>oid</VAR> is being deleted.
/// 
/// <P>If this method returns an error then the object will not be deleted.
ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Internal, Private ]
{
}

/// This callback method is invoked by the <METHOD>%ValidateObject</METHOD> method to 
/// provide notification that the current object is being validated.
/// 
/// <P>If this method returns an error then <METHOD>%ValidateObject</METHOD> will fail.
Method %OnValidateObject() As %Status [ Internal, Private, ProcedureBlock = 1 ]
{
}

/// Return list of events.<br>
/// EventSources - Comma separated list of Event Sources, "*" = All<br>
/// EventTypes - Comma separated list of Types Sources, "*" = All<br>
/// Events - Comma separated list of Events, "*" = All<br>
/// Note: This query may change in future versions<br>
Query List(EventSources As %String, EventTypes As %String, Events As %String) As %Query(ROWSPEC = "Source:%String,Type:%String,Name:%String,Description:%String,Enabled:%String,Total:%Integer,Written:%Integer,Lost:%Integer") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

/// Return list of events with counters, including in memory only events.<br>
/// EventSources - Comma separated list of Event Sources, "*" = All<br>
/// EventTypes - Comma separated list of Types Sources, "*" = All<br>
/// Events - Comma separated list of Events, "*" = All<br>
/// OwnerFlag - 1 - Return only system defined events.<br>
/// Flags - 0 - Use "Startswith" as the selection on the name.<br>
/// Flags - 1 - Use "Contains" as the selection on the name.<br>
/// Note: This query may change in future versions<br>
Query ListAll(EventSources As %String, EventTypes As %String, Events As %String, OwnerFlag As %Integer, Flags As %Integer) As %Query(ROWSPEC = "EventName:%String,Enabled:%String,Total:%Integer,Written:%Integer,Lost:%Integer,EnabledBoolean:%Boolean,")
{
}

ClassMethod ListAllExecute(ByRef qHandle As %Binary, EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", OwnerFlag As %Integer = 2, Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListAllExecute ]
{
}

ClassMethod ListAllClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListAllExecute ]
{
}

/// Return list of System events.<br>
/// EventSources - Comma separated list of Event Sources, "*" = All<br>
/// EventTypes - Comma separated list of Types Sources, "*" = All<br>
/// Events - Comma separated list of Events, "*" = All<br>
/// Note: This query may change in future versions<br>
Query ListAllSystem(EventSources As %String, EventTypes As %String, Events As %String) As %Query(ROWSPEC = "EventName:%String,Enabled:%String,Total:%Integer,Written:%Integer,Lost:%Integer,EnabledBoolean:%Boolean,MandatoryBoolean:%Boolean")
{
}

ClassMethod ListAllSystemExecute(ByRef qHandle As %Binary, EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListAllSystemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListAllSystemExecute ]
{
}

ClassMethod ListAllSystemClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListAllSystemExecute ]
{
}

/// Return list of User owned events for selection display.
/// EventSources - Comma separated list of Event Sources, "*" = All<br>
/// EventTypes - Comma separated list of Types Sources, "*" = All<br>
/// Events - Comma separated list of Events, "*" = All<br>
/// Note: This query may change in future versions<br>
Query ListAllUser(EventSources As %String, EventTypes As %String, Events As %String) As %Query(ROWSPEC = "EventName:%String,Enabled:%String,Total:%Integer,Written:%Integer,Lost:%Integer,EnabledBoolean:%Boolean")
{
}

ClassMethod ListAllUserExecute(ByRef qHandle As %Binary, EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListAllUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListAllSystemExecute ]
{
}

ClassMethod ListAllUserClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListAllSystemExecute ]
{
}

/// Return list of all events which get activated during startup.<br>
/// Note that Enabled is returned in the internal format (0/1)<br>
/// Note: This query may change in future versions<br>
Query ListActivate() As %Query(ROWSPEC = "Source:%String,Type:%String,Name:%String,Description:%String,Enabled:%String") [ SqlProc ]
{
}

ClassMethod ListActivateExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod ListActivateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListActivateExecute ]
{
}

ClassMethod ListActivateClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListActivateExecute ]
{
}

/// Return list of event sources.
/// Note: This query may change in future versions<br>
Query ListSource(ROWSPEC = "Source:%String") As %SQLQuery
{
SELECT DISTINCT %EXACT(Source) FROM Events
 ORDER BY Source
}

/// Return list of event types.
/// Note: This query may change in future versions<br>
Query ListType(ROWSPEC = "Type:%String") As %SQLQuery
{
SELECT DISTINCT %EXACT(Type) FROM Events
 ORDER BY Type
}

/// Return list of events.
/// Note: This query may change in future versions<br>
Query ListName(ROWSPEC = "Name:%String") As %SQLQuery
{
SELECT DISTINCT %EXACT(Name) FROM Events
 ORDER BY Name
}

/// List all Event records, combining the Event Source, Event Type, and Name into
/// one column.<br>
/// EventSources - Comma separated list of Event Sources, "*" = All<br>
/// EventTypes - Comma separated list of Types Sources, "*" = All<br>
/// Events - Comma separated list of Events, "*" = All<br>
/// Note: This query may change in future versions<br>
Query ListSourceTypeName(EventSources As %String, EventTypes As %String, Events As %String, EventOwner As %Integer, Flags As %Integer) As %Query(ROWSPEC = "EventName:%String,Enabled:%String,Total:%Integer,Written:%Integer,Lost:%Integer,EnabledBoolean:%Boolean") [ SqlProc ]
{
}

ClassMethod ListSourceTypeNameExecute(ByRef qHandle As %Binary, EventSources As %String = "*", EventTypes As %String = "*", Events As %String = "*", EventOwner As %Integer = 2, Flags As %Integer = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod ListSourceTypeNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListSourceTypeNameExecute ]
{
}

ClassMethod ListSourceTypeNameClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListSourceTypeNameExecute ]
{
}

Storage Default
{
<Data name="EventsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Enabled</Value>
</Value>
<Value name="4">
<Value>Flags</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","EventsD")</DataLocation>
<DefaultData>EventsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","EventsD")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","EventsI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("Security","EventsS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
