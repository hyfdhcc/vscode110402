Class %DeepSee.PMML.Definition.Util.Predicate Extends %DeepSee.PMML.Definition.extendableNode [ Abstract, System = 3 ]
{

Method %WriteComputeCode(pVar As %String, pObj As %String, pIndent As %String, pStream As %Stream.TmpCharacter) As %Status
{
	quit pStream.WriteLine(pIndent_"set "_pVar_" = "_..%GetComputeCode(pObj))
}

Method %GetComputeCode(pObj As %String) As %String [ Abstract ]
{
	quit ""
}

Method %GetAsTree(Output pTree) As %Status [ Abstract, Internal ]
{
}

Method %ValidateNames(ByRef pDictionary) As %Status
{
	quit $$$OK
}

}
