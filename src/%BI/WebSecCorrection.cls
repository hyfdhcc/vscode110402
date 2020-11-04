Class %BI.WebSecCorrection [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod saveNewPass(P0)
{
	d ##class(%BI.webPreference).SavNewPass(P0)
	s %session.Data("currLocation") = "userPref.csp"
	w "alert('Password changed.');"
	w "parent.window.location.reload();"
}

}
