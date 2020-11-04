/// Created from: c:/ensembledata/ehealthv2/pcehrwsdls/schema/common/pcehr_commontypes.xsd
Class %Standards.AU.eHealth.PCEHR.accessingOrganisation Extends (%RegisteredObject, %XML.Adaptor) [ ProcedureBlock, System = 4 ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://ns.electronichealth.net.au/pcehr/xsd/common/CommonCoreElements/1.0";

Parameter XMLNAME = "accessingOrganisation";

Parameter XMLSEQUENCE = 1;

Property organisationID As %String(MAXLEN = "", XMLNAME = "organisationID") [ Required ];

Property organisationName As %String(MAXLEN = "", XMLNAME = "organisationName") [ Required ];

Property alternateOrganisationName As %String(MAXLEN = "", XMLNAME = "alternateOrganisationName");

Storage Default
{
<Data name="accessingOrganisationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>organisationID</Value>
</Value>
<Value name="3">
<Value>organisationName</Value>
</Value>
<Value name="4">
<Value>alternateOrganisationName</Value>
</Value>
</Data>
<DataLocation>^StandardsA3CE.accessingOr1790D</DataLocation>
<DefaultData>accessingOrganisationDefaultData</DefaultData>
<IdLocation>^StandardsA3CE.accessingOr1790D</IdLocation>
<IndexLocation>^StandardsA3CE.accessingOr1790I</IndexLocation>
<StreamLocation>^StandardsA3CE.accessingOr1790S</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
