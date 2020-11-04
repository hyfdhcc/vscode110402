Class %SYNC.PropertyParameters [ System = 2 ]
{

/// SYNCIGNORE is used to suppress a property from being synchronized. If true the property's
/// value will not be added to a sync set even if the value has changed. The property will be
/// ignored during sync set import as well. The default for this value is false (0).
/// 
/// It is important to note that if the property is constrained by a REQUIRED (NOTNULL) constraint
/// then it will be impossible to create new objects on another system using synchronization unless
/// extraordinary measures are employed.
Parameter SYNCIGNORE = 0;

}
