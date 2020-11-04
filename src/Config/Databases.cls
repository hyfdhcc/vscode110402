Include (%syConfig, %syJrninc, %syMirror)

///  This class allows you to modify and view the [Databases] section of the CPF file through
///  programatic APIs. While properties are usually modified through the System Management
///  portal, there may be some occasion where modifying them through the API's is best
///  for your system. In all the Config methods, if you do not specify the CPFFile parameter,
///  the currently active CPF file is used. If you wish to modify a CPF file which is not
///  the currently active one, then specify the CPFFile you wish to modify in the method call.<br>
///  The Flags parameter does not normally need to be specified; the defaults are usually
///  sufficient for most cases.<br>
///  You can use either the provided API's (Create/Get/Modify/Delete) to modify the properties by passing 
///  in the correct parameters, or use Object sytax to open and directly manipulate the config
///  objects (Open() and Exists()). Most objects created here need only to specify the Name of the object, 
///  and 1 or 2 properties since the the defaults are what are commonly used for most cases.
///  <br>
///  <br>
///  EXAMPLE:<br>
///  <br>
///  <pre>
///  ; Use class methods to create an instance
///  %SYS>s Name="ABC"
///  %SYS>s Properties("Directory")="c:\abc\"
///  %SYS>s Status=##Class(Config.Databases).Create(Name,.Properties)
///  %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
///  ; Use class methods to modify properties
///  %SYS>s Status=##Class(Config.Databases).Get(Name,.Properties)
///  %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
///  %SYS>zw Properties
///  Properties("ClusterMountMode")=0
///  Properties("Directory")="c:\abc\"
///  Properties("MountAtStartup")=0
///  Properties("MountRequired")=0
///  Properties("Server")=""
///  %SYS>s Properties("MountRequired")=1
///  %SYS>s Status=##Class(Config.Databases).Modify(Name,.Properties)
///  %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
///  ; Now use Objects to modify properties
///  %SYS>s Obj=##Class(Config.Databases).Open(Name)
///  ; We could have used i ##Class(Config.Databases).Exists(Name,.Obj) instead of Open()
///  %SYS>w Obj.MountRequired
///  1
///  %SYS>s Obj.MountRequired=0
///  %SYS>s Status=Obj.%Save()
///  %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
///  ; Now delete the object we just created
///  %SYS>s Status=##Class(Config.Databases).Delete(Name)
///  %SYS>i '$$$ISOK(Status) w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
///  </pre>
Class Config.Databases Extends (%Persistent, Config.CommonMultipleMethods, Config.CommonProperties, %SYSTEM.Help) [ Final, Inheritance = right, System = 4 ]
{

Index CPFNameSectionHeaderName On (CPFName, SectionHeader, Name) [ IdKey, Unique ];

///  Database name is always capitalized.<br>
Parameter CAPITALNAME = 1;

Parameter EMSSERVICE [ Internal ] = "Namespace";

///  Specifies whether the database should be mounted privately or clustered.<br>
///  0 - Mount private<br>
///  1 - Mount clustered<br>
Property ClusterMountMode As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

///  Directory where the database resides.<br><br>
///  On ECP Clients of a mirror this contains logical references to the databases on the
///  failover miror memebers as the path may be different on the various nodes. <br>
///  This has two forms:<br>
///  &nbsp&nbsp&nbsp&nbsp&nbsp:mirror:&ltmirror name&gt:&ltmirror database name&gt <br>
///  &nbsp&nbsp&nbsp&nbsp&nbsp:ds:&ltconfig database name&gt <br>
///  <br>
///  The 1st form, :mirror:&ltmirror name&gt:&ltmirror database name&gt, refers to a mirrored database. The mirror
///  database name is the internal mirror name assigned to the database when it was added to
///  the mirror. This is generally the same as the database name in the configuration.
///  <br><br>
///  The 2nd form, :ds:&ltconfig database name&gt, refers to a non-mirrored database on the server.
///  The config database name is the name of the database in the configuration and this database name
///  is expected to exist on all of the failover members. This form is only used in special circumstances
///  as normally non-mirrored databases are hosted on the ECP Client, not the ECP Server. This is used
///  in cases where scratch data (eg. the data will be lost during a mirror failover) needs to be hosted
///  on the server for some reason.
Property Directory As %SysPath [ Required ];

///  On a clustered system, specifies whether the database should be mounted at startup.<br>
///  This property is valid for cluster systems only, and is ignored 
///  for non-cluster systems.<br>
///  0 - Don't mount at startup<br>
///  1 - Mount at startup<br>
Property MountAtStartup As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

///  Specifies that the database MUST be successfully mounted at startup.<br>
///  0 - Successfull mount not required for startup to succeed.<br>
///  1 - Successfull mount required for startup to succeed.<br>
Property MountRequired As Security.Datatype.BooleanYN [ InitialExpression = 0, Required ];

///  Force the name to be uppercase.<br>
Method NameSet(Val) As %Status [ Internal ]
{
}

///  Name of the remote server where the DB resides.<br>
///  If empty, the database is local.<br>
///  Remote server must already be configured to be entered here.<br>
Property Server As %String(MAXLEN = 64, MINLEN = 0);

///  Force the server name to be uppercase.<br>
Method ServerSet(Val) As %Status [ Internal ]
{
}

///  Directory where the streams associated with this database go.<br>
///  By default (value=""), the location is in the subdirectory "stream", underneath the
///  database directory, e.g. for a database located in c:\abc, the default would be
///  c:\abc\stream. InterSystems recommends leaving this parameter as "".<br>
Property StreamLocation As %SysPath;

///  Called by the Create method during import from a CPF file.<br>
ClassMethod CreateCallBack(Obj As %ObjectHandle, Data As %String) As %Status [ Internal ]
{
}

///  Returns a list of databases that share the same given server/directory pair.
ClassMethod DatabasesByDirectory(Server As %String, Directory As %String, ByRef DBList As %String, CPFFile As %String = "") As %Status
{
}

///  Returns a list of databases that reference a given server.<br>
ClassMethod DatabasesByServer(Server As %String, ByRef DatabaseList As %String, CPFFile As %String = "") As %Status
{
}

///  Write a default Databases section in a CPF file.<br>
ClassMethod Default(CPFFile As %String, Platform As %String) As %Status [ Internal ]
{
}

///  Get the databases directory location.<br>
///  If the database does not exist in the configuration, it will return null.
ClassMethod GetDirectory(Name As %String) As %String [ Internal ]
{
}

///  Get the streams location
ClassMethod GetStreamLocation(Name As %String) As %String [ Internal ]
{
}

///  Returns true if the collation matches the exist global.
ClassMethod IsValidCollation(Name As %String, Global As %String, Collation As %Integer = 5, ByRef Status As %Status, Flags As %Integer = 0) As %Boolean [ Internal ]
{
}

///  Load the parameters into memory and activate.<br>
///  Parameters:<br>
///  <b>Obj</b> = Handle to the object which caused the load. If "", 
///  then load everything, only called from STU.<br>
///  If a delete operation, then Obj is the NAME of the item which was deleted
///  since the oject itself has already been deleted.<br>
///  <b>Flags</b> = Type of modification.<br>
///  0 - Modify<br>
///  1 - Create/Insert<br>
///  2 - Delete<br>
ClassMethod Load(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

///  Called from Load().<br>
ClassMethod LoadOne(Dataset As %String, Data As %String, ByRef ClusterMountMode As %Boolean) As %Status [ Internal, Private ]
{
}

///  Called by LoadOne() when processing databases from the config
///  file to check whether the GFDISAIMPL bit in gfattrib in the database
///  label block which blocks implicit mounting of the database agreees with
///  the Cluster v. Private mount mode setting in the configuration (.cpf file).
///  An implicit mount results in privately mounting a datbase and a mounted
///  database cannot be cluster mounted. To prevent accidently mounting a
///  database which should be cluster mounted the GFDISAIMPL bit is generally
///  set. This is maintained by the SMP and ^DATABASE when databases are
///  designated a clustered (or privately) mounted. However if someone
///  edits the .cpf file by hand the setting might get out of sync so we
///  check it here.
ClassMethod FixInternalMountFlag(Dir As %String, ClusterMountMode As %String) As %Boolean [ Internal, Private ]
{
}

///  isMirroredDB(dir) returns true if a database is marked internally
///  as a mirrored db. Does not validate whether the database is part of
///  "this" mirror. Used by LoadOne() where we force mirrored databases to
///  be mounted privately at startup (but we don't force "required" mount). If
///  the db is not part of this mirror, the mirror flags will be cleared when
///  it is mounted.
ClassMethod isMirroredDB(dir) As %Boolean [ Internal, Private ]
{
}

///  Modify Dataset section instance in CPF file. If the Server or Directory path is changed, it will be reflected on all Namespaces referring this DB.<br>
///  <br>
///  Parameters:<br>
///  <b>Name</b> - Name of the Dataset to modify.<br>
///  <b>Properties (byref)</b> - List of the properties to modify in Properties(Name)=Value format. See the subclass for a list of valid properties. 
///  If a specific property is not passed in the properties array, the value is not modified.<br>
///  <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
///  <b>Flags</b> - Bit string of options to perform. See the <METHOD>Create</METHOD> method for values.<br>
///  <br>
///  Return values:<br>
///  <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Modify(Name As %String, ByRef Properties As %String, ByRef CPFFile As %String = "", Flags As %Integer = {$$$CPFSave+$$$CPFWrite+$$$CPFActivate}) As %Status
{
}

///  Move the CPF data into the active config global. This also check if any Database is added/removed/updated in CPF file since last shutdown. And those database will affect namespace mappings.<br>
///  <br>
///  Parameters:<br>
///  <b>Obj</b> - Handle to Object causing the move<br>
ClassMethod MoveToActive(Obj As %ObjectHandle = "", Flags As %Integer = 1) As %Status [ Internal ]
{
}

///  Rename the database name in the CPF file.<br>
///  <br>
///  Parameters:<br>
///  <b>OldName</b> - Name of the database to rename.<br>
///  <b>NewName (byref)</b> - New name of the database.<br>
///  <b>CPFFile (byref)</b> - Name of the CPF file to use, Default=current active CPF file.<br>
///  <br>
///  Return values:<br>
///  <b>CPFFile (byref)</b> - Name of the CPF file the modification was made in.<br>
ClassMethod Rename(OldName As %String, NewName As %String, ByRef CPFFile As %String = "") As %Status
{
}

///  Returns a list of database names whose Server/Directory properties are the same as
///  the ones for a given database for the current configuration.<br>
///  This will return the passed database name as one of the matching ones.
ClassMethod SynonymDBs(Name As DBName, ByRef DBList As %String, CPFFile As %String = "", Flags As %Integer = 0) As %Status [ Internal ]
{
}

///  Called from %Save().<br>
///  Validate the database info here, and possibly change it.<br>
Method %OnAddToSaveSet(depth As %Integer = 3, insert As %Integer = 0, callcount As %Integer = 0) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
}

///  Called from %OnDelete.<br>
///  Returning an error here will keep the database from being deleted.<br>
ClassMethod %OnDeleteCallBack(Obj As %ObjectHandle) As %Status [ Internal ]
{
}

///  Called from %Save().<br>
///  Validate that the database being created has all its parameters set correctly.<br>
///  Any error returned here will abort the creation of the database.<br>
Method %OnValidateObject() As %Status [ Internal ]
{
}

///  Returns a list of Local Databases configured with compact information.<br>
Query CompactLocalDBList(Names As %String = "*", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Directory:%String,SFN:%Integer,ReadOnly:%Integer,Resource:%String,BlockSize:%Integer,Collation:%Integer") [ Internal ]
{
}

ClassMethod CompactLocalDBListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod CompactLocalDBListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = CompactLocalDBListExecute ]
{
}

ClassMethod CompactLocalDBListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = CompactLocalDBListExecute ]
{
}

///  List Databases in a CPF file.<br>
///  <br>
///  Parameters:<br>
///  <b>Names</b> - Comma separated list of Database names<br>
///  <var>"*"</var> - All records match<br>
///  <var>"String,String1"</var> - Any records matching one of these elements<br>
///  <var>"String*"</var> - Any record starting with "String"<br>
///  <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
///  <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
///  <b>Flags</b> - Type of databases to return
///  <var> 0 </var> - All databases
///  <var> 1 </var> - Local databases
///  <var> 2 </var> - Remote databases
///  <b>Format</b> <br>
///  <var>0</var> - Standard report list format<br>
///  <var>1</var> - ^CONFIG global format<br>
///  <var>2</var> - CPF file format format<br>
///  Note: This query may change in future versions<br>
Query List(Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Directory:%String,Server:%String,ClusterMountMode:%Integer,MountRequired:%Integer,MountAtStartup:%Integer,StreamLocation:%String,Comments:%List") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
}

Query ListFilter(Filter As %String = "", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Query(ROWSPEC = "Name:%String,Directory:%String,Server:%String,ClusterMountMode:%Integer,MountRequired:%Integer,MountAtStartup:%Integer,StreamLocation:%String,Comments:%List") [ Internal ]
{
}

ClassMethod ListFilterExecute(ByRef qHandle As %Binary, Filter As %String = "", CPFFile As %String = "", Flags As %Integer = 0, Format As %Integer = 0) As %Status [ Internal ]
{
}

ClassMethod ListFilterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

ClassMethod ListFilterClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

///  List Databases in a CPF file. Used internally by the List Query.<br>
///  <br>
///  Parameters:<br>
///  <b>Names</b> - Comma separated list of Database names<br>
///  <var>"*"</var> - All records match<br>
///  <var>"String,String1"</var> - Any records matching one of these elements<br>
///  <var>"String*"</var> - Any record starting with "String"<br>
///  <var>"String,String1*,String2"</var> - Any record mathing one of these elements, or starting with "String1"<br>
///  <b>CPFFile</b> - Name of the CPF file to use. A null string means use the active CPF file.<br>
///  <b>Flags</b> - Type of databases to return
///  <var> 0 </var> - All databases
///  <var> 1 </var> - Local databases
///  <var> 2 </var> - Remote databases
///  Note: This query may change in future versions<br>
Query List1(Names As %String = "*", CPFFile As %String = "", Flags As %Boolean = 0) As %Query(ROWSPEC = "Name:%String,Directory:%String,Server:%String,ClusterMountMode:%Integer,MountRequired:%Integer,MountAtStartup:%Integer,StreamLocation:%String,Comments:%List") [ Internal, SqlProc ]
{
}

ClassMethod List1Execute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "", Flags As %Boolean = 0) As %Status [ Internal, ProcedureBlock = 0 ]
{
}

ClassMethod List1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = List1Execute ]
{
}

ClassMethod List1Close(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = List1Execute ]
{
}

ClassMethod GetDBMirrorSetName(SFN As %String) As %String [ Internal ]
{
}

///  Returns a list of Local Databases configured.
Query LocalDatabaseList(Names As %String = "*", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Mirror:%String,Directory:%String,Maximum Size in GB:%String,Size in MB:%Integer,Status:%String,Resource:%String,Encrypted:%String,Journal:%String,StatusInt:%String") [ Internal ]
{
}

ClassMethod LocalDatabaseListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod LocalDatabaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

ClassMethod LocalDatabaseListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

Query LocalDatabaseListFilter(Filter As %String = "", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Mirror:%String,Directory:%String,Maximum Size in GB:%String,Size in MB:%Integer,Status:%String,Resource:%String,Encrypted:%String,Journal:%String,StatusInt:%String") [ Internal ]
{
}

ClassMethod LocalDatabaseListFilterExecute(ByRef qHandle As %Binary, Filter As %String = "", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod LocalDatabaseListFilterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

ClassMethod LocalDatabaseListFilterClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = LocalDatabaseListExecute ]
{
}

///  Returns a list of Local Databases configured that can be added to the mirror.<br>
///  The results are the subset of databases in LocalDatabaseList that are mounted R/W,
///  are journals, are not already mirrored, and are not a system database.
Query LocalDatabaseCanMirrorList(Names As %String = "*", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Directory:%String") [ Internal ]
{
}

ClassMethod LocalDatabaseCanMirrorListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod LocalDatabaseCanMirrorListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = LocalDatabaseCanMirrorListExecute ]
{
}

ClassMethod LocalDatabaseCanMirrorListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = LocalDatabaseCanMirrorListExecute ]
{
}

///  Returns a list of the Local databases listed in the configuration file which
///  are mirrored along with their current mirror status.
///  <br><Br>
///  MirrorStatus is the current "mirror state" of the database, it could be one of the following values.<br>
///  'Normal' - (Primary Only) The mirrored database is writable (if not a read-only database) and global updates are being journaled.<br>
///  'Dejournaling' - (Backup and Async) The database has been activated and caught up and mirroring is applying journal data to the database.<br>
///  'Needs Catchup' - The database has been activated but not caught up yet; the Catchup operation is needed.<br>
///  'Needs Activation' - The database has not been activated yet; the Activate and Catchup operations are needed.<br>
///  'Obsolete' - The mirrored database is obsolete and should be removed from the mirror.<br>
///  'Dejournaling Stopped' - Dejournaling has been stopped by an operator or an error.<br>
///  'Database Dismounted' - The database is dismounted.<br>
///  'Catchup Running' - The Catchup operation is running on the database.<br>
Query MirrorDatabaseList(Names As %String = "*", CPFFile As %String = "") As %Query(ROWSPEC = "Name:%String,Mirror:%String,Directory:%String,Maximum Size in GB:%String,Size in MB:%Integer,Status:%String,Resource:%String,Encrypted:%String,Journal:%String,StatusInt:%String,MirrorStatus:%String,MirrorDBName:%String,MirrorFailoverDB:%Boolean,MirrorStatusInt:%Integer") [ SqlProc ]
{
}

ClassMethod MirrorDatabaseListExecute(ByRef qHandle As %Binary, Names As %String = "*", CPFFile As %String = "") As %Status [ Internal ]
{
}

ClassMethod MirrorDatabaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = MirrorDatabaseListExecute ]
{
}

ClassMethod MirrorDatabaseListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = MirrorDatabaseListExecute ]
{
}

///  This callback method is invoked by the <METHOD>%Open</METHOD> method to 
///  provide notification that the object specified by <VAR>oid</VAR> is being opened.
/// 
///  <P>If this method returns an error then the object will not be opened.
Method %OnOpen() As %Status [ Private, ServerOnly = 1 ]
{
}

Storage Default
{
<Data name="DatabasesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClusterMountMode</Value>
</Value>
<Value name="3">
<Value>Directory</Value>
</Value>
<Value name="4">
<Value>MountAtStartup</Value>
</Value>
<Value name="5">
<Value>MountRequired</Value>
</Value>
<Value name="6">
<Value>Server</Value>
</Value>
<Value name="7">
<Value>StreamLocation</Value>
</Value>
<Value name="8">
<Value>Comments</Value>
</Value>
</Data>
<DataLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</DataLocation>
<DefaultData>configDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIG")</IdLocation>
<IndexLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGI")</IndexLocation>
<StreamLocation>@("^|""^^"_$zu(203,1)_"""|"_$zu(203,3))@("CONFIGS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
