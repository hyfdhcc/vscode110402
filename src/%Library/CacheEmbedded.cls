/// When using an embedded datatype class this provides a &lt;member&gt;Embedded method which returns
/// an instance of the embedded class to the caller. You can mix this superclass in to your datatype class
/// for example specify the superclass %25String,%25CacheEmbedded.
Class %Library.CacheEmbedded [ System = 1 ]
{

/// Return an instance of the embedded class
ClassMethod Embedded() As %RegisteredObject [ CodeMode = generator, ServerOnly = 1 ]
{
	#; don't generate any code if it not for a member
	If %mode="method" QUIT $$$OK
	$$$comMemberKeyGetLvar(embeddedclass,%class,%kind,%pqname,$$$cXXXXembeddedname)
	If embeddedclass="" Quit $$$OK
	$$$GENERATE("	Quit ##class("_embeddedclass_").%New()")
	Quit $$$OK
}

}
