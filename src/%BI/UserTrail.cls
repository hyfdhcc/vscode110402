Class %BI.UserTrail Extends (%Persistent, %BI.Adaptor) [ ClassType = persistent, Inheritance = right, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property UserName As %String(TRUNCATE = 1);

Property UserID As %String(TRUNCATE = 1);

Property LoginTime As %String(TRUNCATE = 1);

Property LogoutTime As %String(TRUNCATE = 1);

Property LogEvent As %String(TRUNCATE = 1);

Property LogOutEvent As %String(TRUNCATE = 1);

Property IPadd As %String(TRUNCATE = 1);

Index log On (UserName As Exact, LoginTime As Exact, LogEvent As Exact);

ClassMethod translateLogEvent(value) As %String
{
	s logE = $P(value,$C(2),1), logE2 = $P(value,$C(2),2)
	s val = $S(logE=1:"Login successfully",logE=2:"Unsuccessful login because "_$S(logE2=1:"already logout",logE2=2:"of session timeout",logE2=3:"of invalid login or password",logE2=4:"user account has been suspended",1:"user accound expired"),1:"")
	q val
}

ClassMethod translateLogoutEvent(value) As %String
{
	s val = $S(value=1:"Logout manually",value=2:"Logout via session timeout",1:"")
	q val
}

Storage Default
{
<Data name="CLASSNAME">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="UserTrailDefaultData">
<Value name="1">
<Value>LoginTime</Value>
</Value>
<Value name="2">
<Value>LogoutTime</Value>
</Value>
<Value name="3">
<Value>UserID</Value>
</Value>
<Value name="4">
<Value>LogEvent</Value>
</Value>
<Value name="5">
<Value>UserName</Value>
</Value>
<Value name="6">
<Value>LogOutEvent</Value>
</Value>
<Value name="7">
<Value>IPadd</Value>
</Value>
</Data>
<DataLocation>^BIlog.UserTrailD</DataLocation>
<DefaultData>UserTrailDefaultData</DefaultData>
<IdLocation>^BIlog.UserTrailD</IdLocation>
<IndexLocation>^BIlog.UserTrailI</IndexLocation>
<StreamLocation>^BIlog.UserTrailS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
