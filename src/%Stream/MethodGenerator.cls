/// Provided by the object based method generator so you have a stream to write
/// the code to and to set the type of code.
Class %Stream.MethodGenerator Extends %Stream.GlobalCharacter [ System = 2 ]
{

/// Specified the type of code this stream represents. This is one of<ul>
/// <li><b>code</b> : A block of code, this is the default value</li>
/// <li><b>expression</b> : An expression</li>
/// <li><b>call</b> : A call to another routine</li></ul>
Property CodeMode As %String(VALUELIST = ",call,code,expression,") [ InitialExpression = "code" ];

Property Language As %String(VALUELIST = ",cache,basic,java,tsql,javascript,mvbasic,") [ InitialExpression = "cache" ];

Storage Custom
{
<Type>%Library.CompleteCustomStorage</Type>
}

}
