/// Datatype to display Yes/No rather than 1/0<br>
/// Internal Use only
Class Security.Datatype.BooleanYN Extends %Library.Boolean [ System = 2 ]
{

/*
---------------------Documentation------------------------------------
STC2076 03/27/12 Steve Clay, Fix blank error messages when locale is not translated
JYL254	12/14/11 Jana Lepon, Move class to Datatype package
STC1134 12/18/06 Steve Clay, Display translated security text in correct language 
STC610  08/18/04 Steve Clay, Update security classes to meet spec
STC467	08/13/03 Steve Clay, Initial version
-------------------End Documentation----------------------------------
*/
ClassMethod LogicalToDisplay(%val As %Library.Boolean) As %String [ Internal ]
{
 s Language=$select($get(%response)="":"",1:%response.Language)
 q $case(%val,1:$$$GetMessage(Language,"%SYSTEM.Library","Yes","Yes"),0:$$$GetMessage(Language,"%SYSTEM.Library","No","No"),:%val)
}

ClassMethod DisplayToLogical(%val As %String) As %Library.Boolean [ Internal ]
{
 q $case($zcvt(%val,"U"),$$$GetMsg("%SYSTEM.Library","YES"):1,$$$GetMsg("%SYSTEM.Library","NO"):0,:0)
}

ClassMethod LogicalToODBC(%val As %Library.Boolean) As %String
{
 s Language=$select($get(%response)="":"",1:%response.Language)
 q $case(%val,1:$$$GetMessage(Language,"%SYSTEM.Library","Yes","Yes"),0:$$$GetMessage(Language,"%SYSTEM.Library","No","No"),:%val)
}

}
