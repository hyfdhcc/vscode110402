Class %BI.WebSQLComGen [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod cgGetClasses(P0, P1, P2)
{
	d cgGetClasses^%bi.SWr.WebSQLComGen(P0,P1,P2)
}

ClassMethod loadTblProp(P0)
{
	s %session.Data("cgTotChkBx")=0
	d cgGetTableProperty^%bi.SWr.WebSQLComGen(P0)
}

ClassMethod getOptCls(P0, P1)
{
	d cgGenClsSel^%bi.SWr.WebSQLComGen(P0,P1)
}

ClassMethod getNxtLvl(P0, P1)
{
	d getNxtLvl^%bi.SWr.WebSQLComGen(P0,P1)
}

// ______________________________________________________________________________

// Author: Steven

ClassMethod getSQLQuerySession()
{
	q $$getSQLQuerySession^%bi.SWr.WebSQLComGen()
}

// Author: Steven

ClassMethod analyzeSQLQuery()
{
	do analyzeSQLQuery^%bi.SWr.WebSQLComGen()
}

// ______________________________________________________________________________

}
