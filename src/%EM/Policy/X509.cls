/// %EM.Policy.X509 is the subclass of %EM.Policy that defines 
/// security using the UsernameToken WS-Security element protected by WS-Security SymmetricBinding.
Class %EM.Policy.X509 Extends %EM.Policy [ System = 4 ]
{

/// XData block which defines WS-Security  AsymmetricBinding based policy.
/// See EMS.Connection.Policy for rules for this XData block.
XData APIConnection [ Internal ]
{
<cfg:configuration name="APIConnection" xmlns:cfg="http://www.intersystems.com/configuration" xmlns:wsp="http://www.w3.org/ns/ws-policy" xmlns:sp="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702">
<cfg:service classname="">
<wsp:Policy xmlns:wsap="http://www.w3.org/2006/05/addressing/wsdl">
  <sp:SymmetricBinding>
    <wsp:Policy>
      <sp:ProtectionToken>
        <wsp:Policy>
          <sp:SecureConversationToken cfg:Lifetime="0.5" sp:IncludeToken="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702/IncludeToken/AlwaysToRecipient">
            <wsp:Policy>
              <sp:RequireDerivedKeys/>
              <sp:MustNotSendAmend/>
              <sp:MustNotSendRenew/>
              <sp:BootstrapPolicy>
                <wsp:Policy>
                  <sp:SignedParts>
                    <sp:Header Namespace="http://www.w3.org/2005/08/addressing"/>
                  </sp:SignedParts>
                  <sp:EncryptedParts>
                    <sp:Body/>
                  </sp:EncryptedParts>
                  <sp:SymmetricBinding>
                    <wsp:Policy>
                      <sp:ProtectionToken>
                        <wsp:Policy>
                          <sp:X509Token sp:IncludeToken="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702/IncludeToken/AlwaysToRecipient">
                            <wsp:Policy>
                              <sp:WssX509V3Token11/>
                            </wsp:Policy>
                          </sp:X509Token>
                        </wsp:Policy>
                      </sp:ProtectionToken>
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
                      <sp:OnlySignEntireHeadersAndBody/>
                    </wsp:Policy>
                  </sp:SymmetricBinding>
                  <sp:SignedEncryptedSupportingTokens>
                    <wsp:Policy>
                      <sp:UsernameToken sp:IncludeToken="http://docs.oasis-open.org/ws-sx/ws-securitypolicy/200702/IncludeToken/AlwaysToRecipient">
                        <wsp:Policy>
                          <sp:WssUsernameToken11/>
                        </wsp:Policy>
                      </sp:UsernameToken>
                    </wsp:Policy>
                  </sp:SignedEncryptedSupportingTokens>
                  <sp:Trust13>
                    <wsp:Policy>
                      <sp:RequireClientEntropy/>
                      <sp:RequireServerEntropy/>
                    </wsp:Policy>
                  </sp:Trust13>
                </wsp:Policy>
              </sp:BootstrapPolicy>
            </wsp:Policy>
          </sp:SecureConversationToken>
        </wsp:Policy>
      </sp:ProtectionToken>
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
      <sp:OnlySignEntireHeadersAndBody/>
    </wsp:Policy>
  </sp:SymmetricBinding>
  <wsap:UsingAddressing/>
  <sp:SignedParts>
    <sp:Header Namespace="http://www.w3.org/2005/08/addressing"/>
    <sp:Body/>
  </sp:SignedParts>
  <sp:EncryptedParts>
    <sp:Body/>
  </sp:EncryptedParts>
</wsp:Policy>
 </cfg:service>
</cfg:configuration>
}

}
