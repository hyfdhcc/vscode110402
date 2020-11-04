Include (%occInclude, %occSAX)

IncludeGenerator (%occInclude, %soap)

/// Super class for generated classes that represent SOAP Client WebMethods.
/// <br>
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class."
Class %SOAP.ProxyDescriptor Extends %SOAP.Descriptor [ Abstract, Not ProcedureBlock, System = 3 ]
{

/// The name of the SOAP operation being implemented.
Property %RequestName As %String(XMLPROJECTION = "NONE");

/// <var>operation</var> is the SOAP operation.
Method %OnNew(operation As %String) As %Status
{
	Set ..%RequestName=$get(operation)
	Quit $$$OK
}

}
