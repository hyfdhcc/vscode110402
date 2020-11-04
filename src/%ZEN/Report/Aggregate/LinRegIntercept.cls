/// 
Class %ZEN.Report.Aggregate.LinRegIntercept Extends %ZEN.Report.Aggregate.LinearRegression [ System = 4 ]
{

// Returns b in y = ax + b

// if result can't be calculated returns "" (null)

Method GetResult() As %String
{
		Set abpair=..GetResultList()
		If abpair="" quit ""
		Set result=$LI(abpair,2)
		Set result = ..%PostProcessValue(result,$s(..postprocessResult'="":..postprocessResult,1:1),..runtimeMode,..ignoreNLS)
		Quit result
}

}
