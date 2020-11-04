Class %SQL.Util.TuneTableStatsMaps Extends (%XML.Adaptor, %Library.RegisteredObject) [ System = 4 ]
{

Relationship table As %SQL.Util.TuneTableStats [ Cardinality = parent, Inverse = maps ];

/// Map name
Property name As %String(MAXLEN = 127);

/// BLOCKCOUNT for this map
Property blockcount As %String;

}
