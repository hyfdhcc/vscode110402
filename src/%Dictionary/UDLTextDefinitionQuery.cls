Class %Dictionary.UDLTextDefinitionQuery [ Abstract, Not ProcedureBlock, System = 2 ]
{

Query Summary(classname As %String) As %Query(ROWSPEC = "Name")
{
}

ClassMethod SummaryExecute(ByRef QHandle As %Binary, classname As %String) As %Status [ CodeMode = expression ]
{
##class(%Dictionary.ClassDefinitionQuery).MemberSummaryExecute(.QHandle,classname,$$$cCLASSudltext)
}

ClassMethod SummaryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ CodeMode = expression ]
{
##class(%Dictionary.ClassDefinitionQuery).MemberSummaryFetch(.QHandle,.Row,.AtEnd)
}

ClassMethod SummaryClose(QHandle As %Binary) As %Status [ CodeMode = expression ]
{
##class(%Dictionary.ClassDefinitionQuery).MemberSummaryFetch(.QHandle)
}

}
