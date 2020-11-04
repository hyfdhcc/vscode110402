Class %Dictionary.SQLIdentifier Extends %DataType [ System = 2 ]
{

ClassMethod IsValid(%val As %CacheString) As %Status [ CodeMode = expression ]
{
$select($system.SQL.IsValidRegularIdentifier(%val):$$$OK,1:$$$ERROR($$$DatatypeValidationFailed,##safeexpression(""""_$get(%classname,"???")_":"_$get(%methodname,"???")_""""),%val))
}

}
