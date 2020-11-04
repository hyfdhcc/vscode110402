Include (%syAudit, %sySecurity, %sySystem, %syDatabase, %syJrninc, %occSystemMessages)

/// Class wrapper for SQL security to provide queries, etc.
Class Security.SQL Extends (%SYSTEM.Help, %XML.Adaptor) [ Abstract, Final, System = 4 ]
{

/// Returns data under ^SYS("Security","SQL","priv",...) via macro $$$SecurityGlobalSQLPriv.
/// Global is organized as ^SYS("Security","SQL","priv",NAMESPACE,grant_option,(reltype,name),privcode,grantee,grantor)=grant_option
Query PrivList() As %Query(ROWSPEC = "Namespace:%String,GrantOption:%String,ReltypeName:%String,PrivCode:%String,Grantee:%String,Grantor:%String,Value:%String")
{
}

ClassMethod PrivListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod PrivListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = UserListExecute ]
{
}

ClassMethod PrivListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = UserListFetch ]
{
}

/// Returns data under ^SYS("Security","SQL","syspriv",...) via macro $$$SecurityGlobalSQLSysPriv.
/// Data is at $$$SecurityGlobalSQLSysPriv(Namespace,GrantOption,ReltypeName,PrivCode,Grantee,Grantor)=grant_option
Query SysPrivList() As %Query(ROWSPEC = "Namespace:%String,GrantOption:%String,ReltypeName:%String,PrivCode:%String,Grantee:%String,Grantor:%String,Value:%String")
{
}

ClassMethod SysPrivListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod SysPrivListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = UserListExecute ]
{
}

ClassMethod SysPrivListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = UserListFetch ]
{
}

/// Returns data under ^SYS("Security","SQL","user-role") via macro $$$SecurityGlobalSQLUserRole
/// Data is ^SYS("Security","SQL","user-role",UserName,RoleName)=0 or 1
Query UserRoleList() As %Query(ROWSPEC = "User:%String,Role:%String,Value:%String")
{
}

ClassMethod UserRoleListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod UserRoleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = UserRoleListExecute ]
{
}

ClassMethod UserRoleListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = UserRoleListFetch ]
{
}

Query RoleUserList() As %Query(ROWSPEC = "Role:%String,User:%String,Value:%String")
{
}

ClassMethod RoleUserListExecute(ByRef qHandle As %Binary) As %Status [ Internal ]
{
}

ClassMethod RoleUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ Internal, PlaceAfter = RoleUserListExecute ]
{
}

ClassMethod RoleUserListClose(ByRef qHandle As %Binary) As %Status [ Internal, PlaceAfter = RoleUserListFetch ]
{
}

}
