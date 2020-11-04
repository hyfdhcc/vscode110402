/// %EM.Policy.SSL is the subclass of %EM.Policy that defines 
/// security using the UsernameToken WS-Security element protected by SSL.
Class %EM.Policy.SSL Extends %EM.Policy [ System = 4 ]
{

/// XData block which defines SSL policy.
/// See %EM.Policy for rules for this XData block.
XData APIConnection [ Internal ]
{
<cfg:configuration name="APIConnection" xmlns:cfg="http://www.intersystems.com/configuration" xmlns:wsp="http://www.w3.org/ns/ws-policy" xmlns:sp="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702">
<cfg:service classname="">
<wsp:Policy xmlns:wsap="http://www.w3.org/2006/05/addressing/wsdl">
<sp:TransportBinding>
<wsp:Policy>
<sp:TransportToken>
<wsp:Policy>
<sp:HttpsToken>
<wsp:Policy/>
</sp:HttpsToken>
</wsp:Policy>
</sp:TransportToken>
<sp:AlgorithmSuite>
<wsp:Policy>
<sp:Basic256Sha256/>
</wsp:Policy>
</sp:AlgorithmSuite>
<sp:Layout>
<wsp:Policy>
<sp:Strict/>
</wsp:Policy>
</sp:Layout>
<sp:IncludeTimestamp/>
</wsp:Policy>
</sp:TransportBinding>
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
