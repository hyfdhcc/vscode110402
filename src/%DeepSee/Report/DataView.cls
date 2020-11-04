/// This class represents an instance of a DeepSee DataView.<br/>
/// A DataView provides a set of data fields that can then be used by a DeepSee report.
/// N.B. the storage for this class *must* be set to a non-% global.
/// 
/// !!! deprecated
/// 
Class %DeepSee.Report.DataView Extends (%Persistent, %XML.Adaptor) [ Inheritance = right, System = 3 ]
{

/// Main key for this class.
Index NameKey On name [ IdKey ];

Index Category On category;

/// Optional. Name of the resource
/// for which a user must have USE privilege in order to use this data view.
Property resource As %String(MAXLEN = 100, XMLPROJECTION = "attribute");

/// Category name for this data view.
/// A category name is used to provide a grouping for data views. 
Property category As %String(MAXLEN = 250, XMLPROJECTION = "attribute");

/// Logical name of this data view.<br/>
/// This is used to identify the dataview and must be unique.<br/>
/// By convention names take the form:<br/>
/// "MyApp/MyReport"
Property name As %String(MAXLEN = 500, XMLPROJECTION = "attribute") [ Required ];

/// Display name used for this data view.
Property caption As %String(MAXLEN = 250, XMLPROJECTION = "attribute");

/// Optional. Description of this data view.
Property description As %String(MAXLEN = 500, XMLPROJECTION = "attribute");

/// Name of the persistent class that supplies data for this data view.
Property sourceClass As %String(MAXLEN = 255, XMLPROJECTION = "attribute");

/// If true, then this data view is in "pass through" mode;
/// the set of public properties in the <property>sourceClass</property> are
/// automatically treated as members of the data view.
Property passThrough As %Boolean(XMLPROJECTION = "attribute") [ InitialExpression = 0 ];

/// Set of fields within this data view.
Relationship fields As DataViewField(XMLELEMENTREF = 1, XMLPROJECTION = "ELEMENT", XMLTYPECONSTRAINT = "CHOICE") [ Cardinality = children, Inverse = dataView ];

/// Return an array of fields defined by this data view.<br/>
/// This array takes the form:<br/>
/// pFields(n) = $LB(name,caption,string|integer|number|date|reference,refClass)
Method %GetFields(Output pFields As %List) As %Status
{
	Set tSC = $$$OK
	If ..passThrough {
		// get set of fields in source class
		Set tSC = ##class(%DeepSee.Report.Utils).%GetFieldsForClass(..sourceClass,.pFields)
	}
	Else {
		For n = 1:1:..fields.Count() {
			Set tField = ..fields.GetAt(n)
			Set pFields(n) = $LB(tField.name,tField.caption,"string")
		}
	}
	Quit tSC
}

/// Return the SQL table that supplies data for this dataView.
Method %GetSQLTableName(Output pTable As %String) As %Status
{
	Set tSC = $$$OK
	If ..passThrough {
		Set pTable=$$TableName^%occLGUtil(..sourceClass)
	} else {
		Set pTable =  "Test.SalesData" 	// !!!
	}
	Quit tSC
}

/// Given a field name, return the SQL expression needed to fetch it.
Method %GetSQLForField(pField As %String, Output pExpr As %String) As %Status
{
	Set tSC = $$$OK
	Set pExpr =  pField 	// !!!
	Quit tSC
}

///     Storage

Storage Default
{
<Data name="DataViewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>resource</Value>
</Value>
<Value name="3">
<Value>category</Value>
</Value>
<Value name="4">
<Value>name</Value>
</Value>
<Value name="5">
<Value>caption</Value>
</Value>
<Value name="6">
<Value>description</Value>
</Value>
<Value name="7">
<Value>sourceClass</Value>
</Value>
<Value name="8">
<Value>passThrough</Value>
</Value>
</Data>
<DataLocation>^DeepSee.Report.DataViewD</DataLocation>
<DefaultData>DataViewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DeepSee.Report.DataViewD</IdLocation>
<IndexLocation>^DeepSee.Report.DataViewI</IndexLocation>
<StreamLocation>^DeepSee.Report.DataViewS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
