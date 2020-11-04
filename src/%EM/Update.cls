/// The %EM.Update class describes the current status of a background Update or Activation.
/// As some Activations can be done by JOBs on the Instances, it may be necessary to
/// periodically check the status to see if its finished and successful.
Class %EM.Update Extends (%RegisteredObject, %XML.Adaptor) [ System = 4 ]
{

/// Activation has finished
Property Finished As %Boolean;

/// The first error reported from an Instance during a synchronized Activation.
/// If this is null, and the Activation is Finished, then it has been successful.
/// For services which do synchronized Activation, failure on one Instance will cause all Instances to fail.
/// So, the first error reported may be significant.
Property SyncError As %String(MAXLEN = "");

/// An array of error strings for all Instances involved in the Activation. 
Property Errors As array Of %String(MAXLEN = "");

}
