/// %EM.Policy is the base class for policy description classes for remote API connections.
/// Each possible policy is defined in a subclass.
/// Each subclass must contain an XData block which defines the policy.<br><br>
Class %EM.Policy Extends %SOAP.Configuration [ Abstract, System = 4 ]
{

/// Validate security information for API service
/// XData block which defines policy.  This needs to be overridden in each subclass with
/// an XData block called APIConnection which contains a configuration named APIConnection.
/// Use of classname="" means that this policy will be attached to specific class later using AssociateConfiguration
XData APIConnection [ Internal ]
{
<cfg:configuration name="APIConnection" xmlns:cfg="http://www.intersystems.com/configuration" xmlns:wsp="http://www.w3.org/ns/ws-policy" xmlns:sp="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702">
<cfg:service classname="">
<wsp:Policy xmlns:wsap="http://www.w3.org/2006/05/addressing/wsdl">
<wsap:UsingAddressing/>
</wsp:Policy>
 </cfg:service>
</cfg:configuration>
}

}
