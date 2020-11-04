Class Studio.ExampleDocument Extends %Studio.AbstractDocument [ ProcedureBlock ]
{

/// The extension name, this can be a comma separated list of extensions if this class supports more than one
Projection RegisterExtension As %Projection.StudioDocument(DocumentDescription = "Example User Document", DocumentExtension = "tst", DocumentType = "null");

/// Load the routine in Name into the stream Code
Method Load() As %Status
{
	Write !,"Load: ",..Name
	If ..Name="TestRoutine.TST" Do ..Clear(),..Write("This is a test document"_$char(13,10)_"This is the second line")
	Quit $$$OK
}

/// Compile the routine
Method Compile(flags As %String) As %Status
{
	Write !,"Compile: ",..Name
	Quit $$$OK
}

/// Delete the routine 'name' which includes the routine extension
ClassMethod Delete(name As %String) As %Status
{
	Write !,"Delete: ",name
	Quit $$$OK
}

/// Lock the current routine, default method just unlocks the ^ROUTINE global with the name of the routine.
/// If it fails then return a status code of the error, otherise return $$$OK
Method Lock(flags As %String) As %Status
{
	Write !,"Lock: ",..Name
	Lock +^ROUTINE(..Name):0 Else  Quit $$$ERROR($$$CanNotLockRoutine,..Name)
	Quit $$$OK
}

/// Unlock the current routine, default method just unlocks the ^ROUTINE global with the name of the routine
Method Unlock(flags As %String) As %Status
{
	Write !,"Unlock: ",..Name
	Lock -^ROUTINE(..Name)
	Quit $$$OK
}

/// Return the timestamp of routine 'name' in %TimeStamp format. This is used to determine if the routine has
/// been updated on the server and so needs reloading from Studio. So the format should be $zdatetime($horolog,3),
/// or "" if the routine does not exist.
ClassMethod TimeStamp(name As %String) As %TimeStamp
{
	Write !,"TimeStamp: ",name
	If name="TestRoutine.TST" Quit "2003-04-08 13:11:43"
	Quit ""
}

/// Return 1 if the routine 'name' exists and 0 if it does not.
ClassMethod Exists(name As %String) As %Boolean
{
	Write !,"TimeStamp: ",name
	If name="TestRoutine.TST" Quit 1
	Quit 0
}

/// Save the routine stored in Code
Method Save() As %Status
{
	Write !,"Save: ",..Name
	Quit $$$OK
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Directory As %String, Flat As %Boolean, System As %Boolean) As %Status
{
	Set qHandle=$listbuild(Directory,Flat,System,"")
	Quit $$$OK
}

/// This should return a Row in the form:<br>
/// $listbuild(name,date/time modified,size,directory delimitor)<ul>
/// <li>name - The name to display in the open dialog</li>
/// <li>date/time modified - In %TimeStamp format the date/time this item was last modified</li>
/// <li>size - The size of this item</li>
/// <li>directory delimitor - If this is not an directory then return "" here, if it is a directory then
/// return the type of delimitor to use when they double click on this directory</li>
ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ListExecute ]
{
	Set Row="",AtEnd=0
	If qHandle="" Set AtEnd=1 Quit $$$OK
	If $list(qHandle)'=""||($list(qHandle,4)=1) Set AtEnd=1 Quit $$$OK
	Set Row=$listbuild("TestRoutine.TST",$zdt($h,3),10101,""),$list(qHandle,4)=1,AtEnd=1
	Quit $$$OK
}

}
