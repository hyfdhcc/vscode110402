Include (%sySystem, %sySecurity)

/// This class will allow a user to specify and save favorite pages in the
/// system management portal.
Class %SYS.Portal.Users Extends (%Persistent, %XML.Adaptor, %SYSTEM.Help) [ Inheritance = right, System = 4 ]
{

/*
---------------------Documentation------------------------------------
STC1866 11/26/10 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
Index UserNamePageIndex On (Username, Page) [ IdKey ];

/// Arbitray $list data.<br>
Property Data As %List [ Internal, Required ];

/// Identifier for the page.<br>
Property Page As %String(MAXLEN = 256) [ Internal, Required ];

/// $username of the user saving the page.<br>
Property Username As %String(MAXLEN = 128) [ Internal, Required ];

/// Add a page favorite for the current $username.<br>
/// If the page favorite already exists, return success.<br>
/// Parameters:<br><br>
/// Page - Identifier of the page.<br>
/// Data - Data associated with the page.<br>
ClassMethod %AddFavorite(Page As %String, Data As %List) As %Status [ Internal ]
{
 s $zt="Error"
 s Obj=..%New()
 i Obj="" q %objlasterror
 s Obj.Username=$username
 s Obj.Page=Page
 s Obj.Data=Data
 s Status=Obj.%Save()
 i $$$ISERR(Status) && ($SYSTEM.Status.GetErrorCodes(Status)=$$$ERRORCODE($$$IDKeyNotUnique)) {
	Set Status = ..%RemoveFavorite(Page)
	if $$$ISOK(Status){
		Set Status = Obj.%Save()
	}
	s Status=$$$OK
 }
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Return the list of page favorites for the current $Username.<br>
/// Parameters:<br><br>
/// Favorites (byref) - Array of page favorites for the current $username.<br>
/// Favorites(Page)=Data<br>
ClassMethod %GetFavoritesForUser(ByRef Favorites As %String) As %Status [ Internal ]
{
 s $zt="Error"
 k Favorites
 Set Rset = ##class(%ResultSet).%New("%SYS.Portal.Users:List")
 i '$$$ISOK(Rset) q %objlasterror
 s Status=Rset.Execute($Username)
 i '$$$ISOK(Status) q Status
 While Rset.Next() {
	s Favorites(Rset.Data("Page"))=Rset.Data("Data")
 }
 q $$$OK 
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Return the list of page favorites for the specified usernames.<br>
/// Parameters:<br><br>
/// Usernames - List of usernames in the same format passed to the List() query.<br>
/// Favorites (byref) - Array of page favorites for the specified users.<br>
/// Favorites(Username,Page)=Data<br>
ClassMethod %GetFavoritesForUsers(Usernames As %String = "*", ByRef Favorites As %String) As %Status [ Internal ]
{
 s $zt="Error"
 k Favorites
 Set Rset = ##class(%ResultSet).%New("%SYS.Portal.Users:List")
 i '$$$ISOK(Rset) q %objlasterror
 s Status=Rset.Execute(Usernames)
 i '$$$ISOK(Status) q Status
 While Rset.Next() {
	s Favorites(Rset.Data("Username"),Rset.Data("Page"))=Rset.Data("Data")
 }
 q $$$OK 
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Remove a page favorite for the current $username.<br>
/// Returns success if the page favorite does not exist.<br>
/// Parameters:<br><br>
/// Page - Identifier of the page favorite to remove for $username.<br>
ClassMethod %RemoveFavorite(Page As %String) As %Status [ Internal ]
{
 s $zt="Error"
 s Obj=..%OpenId($username_"||"_Page)
 i Obj="" q $$$OK
 s Status=Obj.%Delete(Obj.%Oid())
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Remove all page favorites for the current $username.<br>
ClassMethod %RemoveFavoritesForUser() As %Status [ Internal ]
{
 s $zt="Error"
 Set Rset = ##class(%ResultSet).%New("%SYS.Portal.Users:List")
 i '$$$ISOK(Rset) q %objlasterror
 s Status=Rset.Execute($Username)
 i '$$$ISOK(Status) q Status
 While Rset.Next() {
	s Status=..%RemoveFavorite(Rset.Data("Page"))
 	q:'$$$ISOK(Status)
 }
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// Remove all favorites for the specified usernames.<br>
/// Parameters:<br><br>
/// Usernames - List of usernames in the same format passed to the List() query.<br>
ClassMethod %RemoveFavoritesForUsers(Usernames As %String = {$username}) As %Status [ Internal ]
{
 s $zt="Error"
 n $roles
 Set Rset = ##class(%ResultSet).%New("%SYS.Portal.Users:List")
 i '$$$ISOK(Rset) q %objlasterror
 s Status=Rset.Execute(Usernames)
 i '$$$ISOK(Status) q Status
 While Rset.Next() {
	d $SYSTEM.Security.Users.PrincipalNameSet(Rset.Data("Username"))
	s Status=..%RemoveFavorite(Rset.Data("Page"))
 	q:'$$$ISOK(Status)
 }
 q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
}

/// List of users and their page favorites.<br>
/// Names - Comma separated list of users<br>
/// "*" - All records match<br>
/// "String,String1" - Any records matching one of these elements<br>
/// "String*" - Any record starting with "String"<br>
/// "String,String1*,String2" - Any record mathing one of these elements, or starting with "String1"<br>
/// Note: This query may change in future versions<br>
Query List(Usernames As %String = "*") As %Query(ROWSPEC = "Username:%String,Page:%String,Data:%List") [ SqlProc ]
{
}

ClassMethod ListExecute(ByRef qHandle As %Binary, Usernames As %String = "*") As %Status [ Internal, ProcedureBlock = 0 ]
{
 s $zt="Error"
 &SQL(DECLARE UsersListCursor CURSOR for 
	SELECT Username,Page,Data
	FROM Users
	WHERE ($$CheckName(:Usernames,Username)=1)
	ORDER BY Username,Page)
 &SQL(OPEN UsersListCursor)
 Quit $$$OK
$$$CheckName()
Error s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod ListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = ListExecute ]
{
 &SQL(FETCH UsersListCursor
	INTO :Username,:Page,:Data)
 If SQLCODE=100 {
	Set Row="",AtEnd=1
 } Else {
	Set Row=$LB(Username,Page,Data)
	Set AtEnd=0
 }
 Quit $$$OK
Error s $zt=""
 Quit $$$ERROR($$$CacheError,$ze)
}

ClassMethod ListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = ListExecute ]
{
	&SQL(CLOSE UsersListCursor)
	Quit $$$OK
}

Storage Default
{
<Data name="UsersDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Data</Value>
</Value>
</Data>
<DataLocation>^|"^^"_$zu(12)|SYS("Portal","UsersD")</DataLocation>
<DefaultData>UsersDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^|"^^"_$zu(12)|SYS("Portal","UsersD")</IdLocation>
<IndexLocation>^|"^^"_$zu(12)|SYS("Portal","UsersI")</IndexLocation>
<StreamLocation>^|"^^"_$zu(12)|SYS("Portal","UsersS")</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
