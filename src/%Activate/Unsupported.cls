Include %occActivate

/// This class serves as a base for those types sometimes found in typelibraries
/// that are not currently supported by Activate. The VariantType holds the Actual Variant
/// type of the value being returned. This can be used to discriminate between the various
/// unsupported types
Class %Activate.Unsupported Extends %RegisteredObject [ System = 4 ]
{

// This holds the variant type. See VARIANT_TYPE in %occActivate.inc

Property VariantType As %Integer;

Method %OnNew(initvalue As %CacheString) As %Status [ Private, ProcedureBlock = 1, ServerOnly = 1 ]
{
	Set ..VariantType=+$Get(initvalue,$$$VTUNSUPPORTED)
	Quit $$$OK
}

}
