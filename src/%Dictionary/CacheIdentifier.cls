Class %Dictionary.CacheIdentifier Extends %DataType [ System = 2 ]
{

ClassMethod IsValid(%val As %CacheString) As %Status [ CodeMode = expression ]
{
$select($length(%val)'>$$$MAXNAMELENGTH&&(%val'="")||(%val["||")||(%val["."):$$$OK,1:$$$ERROR($$$DatatypeValidationFailed,$classname()_":IsValid",%val))
}

}
