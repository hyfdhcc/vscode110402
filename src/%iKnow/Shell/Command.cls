Class %iKnow.Shell.Command Extends %RegisteredObject
{

Parameter COMMAND = "Command";

Parameter QUERYENTITY = "QueryEntity";

Parameter QUERYCRC = "QueryCrc";

Parameter QUERYCC = "QueryCc";

Parameter QUERYPATH = "QueryPath";

Parameter QUERYSENTENCE = "QuerySentence";

Parameter QUERYSOURCE = "QuerySource";

Property ChildResult [ MultiDimensional ];

Method GetCommandName() As %String
{
	quit ""
}

Method Type(option As %String) As %String
{
	quit ..#COMMAND
}

Method Describe(shell As %iKnow.Shell, ByRef description)
{
}

Method Run(shell As %iKnow.Shell, ByRef args, parentCommand As %iKnow.Shell.Command = "")
{
}

Method SetResult(ByRef result) [ Final ]
{
	k i%ChildResult
	merge i%ChildResult=result
}

Method RTToHeader(rtDesc As %String) As %List [ Final ]
{
	set parts=$listfromstring(rtDesc,",")
	set headerLst=""
	for i=1:1:$listlength(parts) {
		set headerLst=headerLst_$lb($piece($list(parts,i),":",1))
	}
	quit headerLst
}

}
