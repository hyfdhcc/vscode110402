Include %systemInclude

IncludeGenerator %systemInclude

/// Constraint root class
Class %Library.ConstraintAbstract [ Abstract, Not ProcedureBlock, System = 2 ]
{

/***********************************************************************\
	| Supplied by subclass implementation.                                  |
	\***********************************************************************/
ClassMethod Check() As %Status [ ServerOnly = 1 ]
{
 QUIT $$$ERROR($$$MethodNotImplemented,"%ConstraintAbstract::%Check")
}

}
