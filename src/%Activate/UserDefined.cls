/// Class to represent UserDefined types for Activate. User defined types that are 
/// IDispatch or Enumeration compatible are treated as IDispatch and VT_I4 respectively.
/// Genuine UserDefined types cannot be supported by Activate. If the signature of an 
/// Activate generated contains an %Activate.UserDefined then activate will attempt to 
/// coerce that type to a string. This may or may not be successful depending upon the
/// implementation of the ActiveX object that defines it
Class %Activate.UserDefined Extends %String [ System = 4 ]
{

}
