Class %ZEN.Report.ResultSet Extends %Library.ResultSet [ System = 4 ]
{

Method %Get(name As %String) As %String [ ProcedureBlock = 1 ]
{
	if (name '= "") && ($Data(i%Data(name))) { set rReturnValue = $get(i%Data(name)) }
	else  {
		s rReturnValue=""
	}
	quit rReturnValue
}

}
