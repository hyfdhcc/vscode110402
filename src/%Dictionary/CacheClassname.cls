Class %Dictionary.CacheClassname Extends %DataType [ System = 2 ]
{

ClassMethod IsValid(%val As %CacheString) As %Status
{
 If $length(%val)>220 Quit $$$ERROR($$$DatatypeValidationFailed,##safeexpression(""""_$get(%classname,"???")_":"_$get(%methodname,"???")_""""),%val)
 Set v=1
 For i=1:1:$l(%val,".") Set p=$p(%val,".",i),v=$select(i=1:$zname(p),1:$extract(p)'="%"&$zname(p)) Quit:v=0
 Quit $select(v:$$$OK,1:$$$ERROR($$$DatatypeValidationFailed,##safeexpression(""""_$get(%classname,"???")_":"_$get(%methodname,"???")_""""),%val))
}

}
