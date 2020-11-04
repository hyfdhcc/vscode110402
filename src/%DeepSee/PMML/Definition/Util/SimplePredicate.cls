Class %DeepSee.PMML.Definition.Util.SimplePredicate Extends Predicate [ System = 3 ]
{

Property field As %DeepSee.PMML.Datatype.FieldName(XMLPROJECTION = "ATTRIBUTE");

Property operator As %DeepSee.PMML.Datatype.String(VALUELIST = ",equal,notEqual,lessThan,lessOrEqual,greaterThan,greaterOrEqual,isMissing,isNotMissing", XMLPROJECTION = "ATTRIBUTE");

Property value As %DeepSee.PMML.Datatype.String(MAXLEN = 2000, XMLPROJECTION = "ATTRIBUTE");

Method %GetComputeCode(pObj As %String) As %String
{
	quit:..operator="isMissing" pObj_".%IsMissing("_$$$QUOTE(..field)_")"
	quit:..operator="isNotMissing" "'"_pObj_".%IsMissing("_$$$QUOTE(..field)_")"
	if ($g(%PMML("Fields",$$$PROPERTYNAME(..field),"datatype"))="boolean") { // BDB505
		set tValue = $case($$$LOWER(..value), "false":0, "true":1, :..value)
	} else {
		set tValue = $s((..value=+..value):..value, 1:$$$QUOTE(..value))
	}
	quit "$s("_pObj_".%IsMissing("_$$$QUOTE(..field)_"):""UNKNOWN"", 1:("_pObj_"."_$$$PROPERTYNAME(..field)_$case(..operator, "equal":"=", "notEqual":"'=", "lessThan":"<", "lessOrEqual":"<=", "greaterThan":">", "greaterOrEqual":">=") _ tValue _"))"
}

Method %ValidateNames(ByRef pDictionary) As %Status
{
	set tSC = $$$OK
	try {
		
		if '$d(pDictionary("fields", ..field)) {
			set tSC = $$$ERROR($$$GeneralError, "Unknown field: '"_..field_"'")
			quit
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Adds node-specific validation checks
Method %OnValidateObject(force As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	set tSC = $$$OK
	try {
		
		if (..value="") && (..operator'="isMissing") && (..operator'="isNotMissing") {
			set tSC = $$$ERROR($$$GeneralError, "value is a required attribute for operator '"_..operator_"'")
			quit
		}
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

Method SetOperatorSymbol(pSymbol As %String) As %Status
{
	quit ..operatorSet(..OperatorFromSymbol(pSymbol))
}

ClassMethod OperatorFromSymbol(pSymbol As %String) As %String
{
	quit $case(pSymbol, "=":"equal", "!=":"notEqual", "<":"lessThan", "<=":"lessOrEqual", ">":"greaterThan", ">=":"greaterOrEqual")
}

ClassMethod SymbolFromOperator(pOperator As %String) As %String
{
	quit $case(pOperator, "equal":"=", "notEqual":"!=", "lessThan":"<", "lessOrEqual":"<=", "greaterThan":">", "greaterOrEqual":">=")
}

Method %GetAsTree(Output pTree) As %Status [ Internal ]
{
	set pTree = $lb(..field, ..operator, ..value)
	quit $$$OK
}

}
