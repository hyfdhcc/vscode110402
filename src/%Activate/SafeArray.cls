/// Class to represent SafeArray types for Activate. Array types cannot be supported
/// by Activate.If the signature of an Activate generated contains an %Activate.SafeArray
/// then activate will attempt to coerce that type to a string. This may or may not be successful 
/// depending upon the implementation of the ActiveX object that defines it
Class %Activate.SafeArray Extends %String [ System = 4 ]
{

}
