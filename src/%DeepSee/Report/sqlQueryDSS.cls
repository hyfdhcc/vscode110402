/// Base class for data set schema interface modules created by from imported sqlQuery sources.
/// 
Class %DeepSee.Report.sqlQueryDSS Extends %DeepSee.Report.abstractDSS [ System = 4 ]
{

/// Report Model information supplied from Report Builder.
XData QueryInterfaceModel
{
<qiModel>
	</qiModel>
}

Method GetQueryInterfaceModel() As %String
{
	Quit ..%GetXDataTextSection($CLASSNAME()_"||QueryInterfaceModel")
}

}
