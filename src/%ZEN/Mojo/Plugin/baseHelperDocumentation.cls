/// Superclass for all classes that provide documentation for
/// subclasses of baseHelperPlugin.
/// The classname needs to be the same as the classname of the 
/// helper plugin with "Documentation" as postfix.
/// If the helper plugin classname is "chuiHelper", the documentation
/// classname needs to be "chuiHelperDocumentation".
Class %ZEN.Mojo.Plugin.baseHelperDocumentation Extends %ZEN.Component.object [ Abstract, System = 3 ]
{

Parameter NAMESPACE = "http://www.intersystems.com/zen/mojo";

/// returns an object containing information about the requested identifier (e.g. $loop).
/// The object contains an array holding an object for each supported attribute and a documentation
/// EXAMPLE:
/// 
/// {
/// 	description: 'Description of the identifier e.g. $loop',
/// 	attributes: [
/// 			{name:'value',type:'string',description:'Holds the value of the html element'}
/// 		]
/// }
/// 
/// Valid types are: string,number,boolean,date,object,array and function
ClientMethod getDocumentation(identifier) [ Language = javascript ]
{
	return {attributes:[]};
}

}
