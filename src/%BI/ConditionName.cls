Class %BI.ConditionName Extends %String [ ClassType = datatype, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

/// Convert 'Car = {1,User.HCar}Make,Model' to 'Car = Toyota,Corola'
ClassMethod LogicalToDisplay(%val As %String) As %String
{
 quit $$LogicD^%bi.SMr.Condition3(%val)
}

}
