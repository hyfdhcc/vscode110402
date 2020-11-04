/// %EM.Policy.Username is the subclass of %EM.Policy that defines 
/// security using the UsernameToken WS-Security element with no other security.
Class %EM.Policy.Username Extends %EM.Policy [ System = 4 ]
{

/// XData block which defines UsernameToken only policy with no encryption.
/// See %EM.Policy for rules for this XData block.
XData APIConnection [ Internal ]
{
<cfg:configuration name="APIConnection" xmlns:cfg="http://www.intersystems.com/configuration" xmlns:wsp="http://www.w3.org/ns/ws-policy" xmlns:sp="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702">
<cfg:service classname="">
<wsp:Policy xmlns:wsap="http://www.w3.org/2006/05/addressing/wsdl">
<sp:SupportingTokens wsp:Optional="true">
<wsp:Policy>
<sp:UsernameToken sp:IncludeToken="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702/IncludeToken/Once">
<wsp:Policy>
<sp:WssUsernameToken11/>
</wsp:Policy>
</sp:UsernameToken>
</wsp:Policy>
</sp:SupportingTokens>
<wsap:UsingAddressing/>
</wsp:Policy>
 </cfg:service>
</cfg:configuration>
}

}
