/// This class implements SASchema for the iKnow model classes for metric definitions.
/// See also <class>%iKnow.Metrics.MetricDefinition</class>
Class %iKnow.Model.SASchemaMetrics Extends %Studio.SASchemaClass [ System = 3 ]
{

/// This is the namespace value used to identify this SA schema.
/// This corresponds to the XMLNamespace keyword of a Studio XData block.
Parameter XMLNAMESPACE = "http://www.intersystems.com/iknow/metrics";

/// This is comma-separated list of the classes whose xml elements
/// can be used as the root level element of a document.
Parameter ROOTCLASSES As STRING = "%iKnow.Model.metrics:metrics";

}
