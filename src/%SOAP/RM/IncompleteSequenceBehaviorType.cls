/// Enumeration used in CreateSequence in request body in WS-ReliableMessaging 1.2.
Class %SOAP.RM.IncompleteSequenceBehaviorType Extends %xsd.string [ System = 4 ]
{

Parameter NAMESPACE = "http://docs.oasis-open.org/ws-rx/wsrm/200702";

Parameter VALUELIST = ",DiscardEntireSequence,DiscardFollowingFirstGap,NoDiscard";

}
