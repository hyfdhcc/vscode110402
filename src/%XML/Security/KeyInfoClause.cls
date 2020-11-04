/// Abstract base class for KeyInfo clauses.
/// 
/// This class is used internally by Cach&eacute;. You should not make direct
/// use of it within your applications. There is no guarantee made about either
/// the behavior or future operation of this class."
Class %XML.Security.KeyInfoClause Extends (%RegisteredObject, %XML.Adaptor) [ Abstract, Inheritance = right, System = 4 ]
{

Parameter XMLFORMAT = "literal";

Parameter NAMESPACE = "http://www.w3.org/2000/09/xmldsig#";

Parameter ELEMENTQUALIFIED = 1;

/// Force any subclass into choice list.
/// This usage of XMLINCLUDEINGROUP is only needed for classes in %XML and %SOAP packages.
Parameter XMLINCLUDEINGROUP = 2;

/// Validate this input KeyInfo clause.  Default behavior is to ignore the clause.
/// If valid, set credentials and tokenType and return "". 
/// If not valid, return error code.
Method ValidateTokenRef(service As %SOAP.WebBase, ByRef tokenType As %String, Output credentials As %CacheLiteral) As %String [ Internal ]
{
	Set credentials=""
	Quit ""
}

}
