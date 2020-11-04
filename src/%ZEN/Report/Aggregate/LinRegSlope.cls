/// 
Class %ZEN.Report.Aggregate.LinRegSlope Extends %ZEN.Report.Aggregate.LinearRegression [ System = 4 ]
{

// Returns a in y = ax + b

// if result can't be calculated returns "" (null)

Method GetResult() As %String
{
		Set abpair=..GetResultList()
		if abpair="" quit ""
		Set result = $LI(abpair,1)
		Set result = ..%PostProcessValue(result,$s(..postprocessResult'="":..postprocessResult,1:1),..runtimeMode,..ignoreNLS)
		Quit result
}

}
