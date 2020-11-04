Class %BI.Users Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Property shortcutLinks As %String(MAXLEN = 10000, TRUNCATE = 1);

Index Code On Code [ Unique ];

Index ExactCode On Code As Exact;

Property Code As %String(MAXLEN = 30, TRUNCATE = 1);

Property FullName As %String(MAXLEN = 100, TRUNCATE = 1);

Property Password As %String(MAXLEN = 30, TRUNCATE = 1);

Property DGSIG As %String(TRUNCATE = 1);

Property MinRowDrillDown As %Integer;

Property MailUsrName As %String(TRUNCATE = 1);

Property MailPassword As %String(TRUNCATE = 1);

Property DisplayFilterCount As %String(TRUNCATE = 1);

Property FolderSuperUser As %Boolean;

Property DefaultFolder As %String(MAXLEN = 30, TRUNCATE = 1);

Property SysLanguage As %String(TRUNCATE = 1);

Property NoTimeOut As %String(TRUNCATE = 1);

Property SecurityLevel As %Integer;

Property DefaultFolderName As %String(TRUNCATE = 1) [ Calculated ];

Property lockOut As %String(TRUNCATE = 1);

Property MyMisStd As %String(TRUNCATE = 1);

Property EightCharPwd As %String(TRUNCATE = 1);

Property ExpiryDate As %String(TRUNCATE = 1);

Property CanExpire As %String(TRUNCATE = 1);

Property AlphaNumPwd As %String(TRUNCATE = 1);

Property NoReUse As %String(TRUNCATE = 1);

Property ExPasswords As array Of %String(TRUNCATE = 1);

Property EnbScript As %String(TRUNCATE = 1);

Property DisplayDate As %String(TRUNCATE = 1);

Property screenWidth As %String(TRUNCATE = 1);

Property screenHeight As %String(TRUNCATE = 1);

Property FullScreen As %String(TRUNCATE = 1);

Property LimitUserPref As %String(TRUNCATE = 1);

Property PerfAlert As %String(TRUNCATE = 1);

Property PerfAlertPopup As %String(TRUNCATE = 1);

Property MyFolder As %String(MAXLEN = 1000);

Method DefaultFolderNameGet() As %String
{
 if ..MyFolder="" q ""
 quit $LG($G(^BI.FolderD(..MyFolder)),2)
 //quit $LG($G(^BI.FolderD(..DefaultFolder)),2)
}

Property Folders As array Of %BI.FolderAccess;

Property CustomFn As array Of %BI.CustomFunction;

Property DesktopItems As array Of %BI.DashBoardItem;

Property ShortCutDB As array Of %BI.DashBoardItem;

Relationship UserDashBoard As %BI.UserDashBoard [ Cardinality = children, Inverse = Users ];

Relationship UserRole As %BI.UserRole [ Cardinality = children, Inverse = Users ];

Property MailUsrMtnAdd As %String(MAXLEN = 300);

Property MailUsrMtnSig As %String(MAXLEN = 300);

Property MailUsrMtnAddbookLimit As %String(MAXLEN = 300);

Property LoginModule As %String(TRUNCATE = 1);

Property ShortcutModule As %BI.WebSCM;

Method Encrypt(inVal) As %String [ Final ]
{
	quit $$ENCR^%bi.SMr.Users1(inVal)
}

ClassMethod IsValidLogin(UserName As %String, UserPasswd As %String) As %Boolean
{
	S ok=$$chkLogin^%bi.SMr.LoginUser(UserName,UserPasswd)
	quit (ok=1)
}

Query AllUsers() As %SQLQuery(CONTAINID = 1)
{
SELECT ID,Code,FullName,FolderSuperUser  
FROM %BI.Users ORDER BY FullName
}

Storage Default
{
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="CustomFn">
<Attribute>CustomFn</Attribute>
<Structure>subnode</Structure>
<Subscript>"CF"</Subscript>
</Data>
<Data name="DesktopItems">
<Attribute>DesktopItems</Attribute>
<Structure>subnode</Structure>
<Subscript>"D"</Subscript>
</Data>
<Data name="ExPasswords">
<Attribute>ExPasswords</Attribute>
<Structure>subnode</Structure>
<Subscript>"XP"</Subscript>
</Data>
<Data name="Folders">
<Attribute>Folders</Attribute>
<Structure>subnode</Structure>
<Subscript>"F"</Subscript>
</Data>
<Data name="LoginModule">
<Attribute>LoginModule</Attribute>
<Structure>node</Structure>
<Subscript>"SCOL"</Subscript>
</Data>
<Data name="MailExtra">
<Attribute>MailUsrMtnAdd</Attribute>
<Structure>node</Structure>
<Subscript>"M",1</Subscript>
</Data>
<Data name="MailExtra2">
<Attribute>MailUsrMtnSig</Attribute>
<Structure>node</Structure>
<Subscript>"M",2</Subscript>
</Data>
<Data name="MailExtra3">
<Attribute>MailUsrMtnAddbookLimit</Attribute>
<Structure>node</Structure>
<Subscript>"M",3</Subscript>
</Data>
<Data name="ShortCutDB">
<Attribute>ShortCutDB</Attribute>
<Structure>subnode</Structure>
<Subscript>"SD"</Subscript>
</Data>
<Data name="ShortcutModule">
<Attribute>ShortcutModule</Attribute>
<Structure>node</Structure>
<Subscript>"SCM"</Subscript>
</Data>
<Data name="UsersDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>FullName</Value>
</Value>
<Value name="3">
<Value>Password</Value>
</Value>
<Value name="4">
<Value>FolderSuperUser</Value>
</Value>
<Value name="5">
<Value>DefaultFolder</Value>
</Value>
<Value name="6">
<Value>SysLanguage</Value>
</Value>
<Value name="7">
<Value>SecurityLevel</Value>
</Value>
<Value name="8">
<Value>shortcutLinks</Value>
</Value>
<Value name="9">
<Value>NoTimeOut</Value>
</Value>
<Value name="10">
<Value>lockOut</Value>
</Value>
<Value name="11">
<Value>AlphaNumPwd</Value>
</Value>
<Value name="12">
<Value>CanExpire</Value>
</Value>
<Value name="13">
<Value>EightCharPwd</Value>
</Value>
<Value name="14">
<Value>ExpiryDate</Value>
</Value>
<Value name="15">
<Value>NoReUse</Value>
</Value>
<Value name="16">
<Value>MyMisStd</Value>
</Value>
<Value name="17">
<Value>EnbScript</Value>
</Value>
<Value name="18">
<Value>MailPassword</Value>
</Value>
<Value name="19">
<Value>MailUsrName</Value>
</Value>
<Value name="20">
<Value>DisplayFilterCount</Value>
</Value>
<Value name="21">
<Value>DisplayDate</Value>
</Value>
<Value name="22">
<Value>screenHeight</Value>
</Value>
<Value name="23">
<Value>screenWidth</Value>
</Value>
<Value name="24">
<Value>FullScreen</Value>
</Value>
<Value name="25">
<Value>DGSIG</Value>
</Value>
<Value name="26">
<Value>LimitUserPref</Value>
</Value>
<Value name="27">
<Value>PerfAlert</Value>
</Value>
<Value name="28">
<Value>PerfAlertPopup</Value>
</Value>
<Value name="29">
<Value>MyFolder</Value>
</Value>
<Value name="30">
<Value>MinRowDrillDown</Value>
</Value>
</Data>
<DataLocation>^BI.UsersD</DataLocation>
<DefaultData>UsersDefaultData</DefaultData>
<IdLocation>^BI.UsersD</IdLocation>
<IndexLocation>^BI.UsersI</IndexLocation>
<StreamLocation>^BI.UsersS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
