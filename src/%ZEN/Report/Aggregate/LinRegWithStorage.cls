/// 
Class %ZEN.Report.Aggregate.LinRegWithStorage Extends %ZEN.Report.Aggregate.LinearRegression [ System = 4 ]
{

/// Array of processed values
Property x As array Of %Integer;

Property y As array Of %Integer;

/// Processes each new value (x,y) pair in %List
Method ProcessValue(pValue As %List) As %Status
{
	if pValue="" quit $$$OK
	Set x = $LI(pValue,1)
	Set y = $LI(pValue,2)
	Set x = ..%PreProcessValue(x, $s(..preprocessValue'="":..preprocessValue,1:1), ..runtimeMode, ..ignoreNLS)
	Set y = ..%PreProcessValue(y, $s(..preprocessValue'="":..preprocessValue,1:1), ..runtimeMode, ..ignoreNLS)
	
	Set ..Count=..Count + 1
	Do ..x.SetAt(x,..Count)
	Do ..y.SetAt(y,..Count)

	Set ..SumOfX=..SumOfX + x
	Set ..SumOfY=..SumOfY + y
	Set ..SumOfXSquared = ..SumOfXSquared + (x*x)
	Set ..SumOfXY = ..SumOfXY + (x*y)
		
	Quit $$$OK
}

}
