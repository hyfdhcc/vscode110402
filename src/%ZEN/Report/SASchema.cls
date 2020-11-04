/// This class implements SASchema for the ZEN report classes.
Class %ZEN.Report.SASchema Extends %Studio.SASchemaClass [ System = 3 ]
{

/// This is the namespace value used to identify this SA schema.
/// This corresponds to the XMLNamespace keyword of a Studio XData block.
Parameter XMLNAMESPACE As STRING = "http://www.intersystems.com/zen/report/definition";

/// This is comma-separated list of the classes whose xml elements
/// can be used as the root level element of a document.
Parameter ROOTCLASSES As STRING = "%ZEN.Report.report:report";

}
