IncludeGenerator %occUtility

/// This classes defines a task that can be executed by the Task Manager.
/// To create a new task, create a subclass and override the OnTask method.<br>
/// All public properties whose name does not start with a "%" are treated
/// as user-configurable "settings" for this task.
Class %SYS.Task.Definition Extends %RegisteredObject [ System = 4 ]
{

/*
---------------------Documentation------------------------------------
JB308	09/28/06 James Bourette	 Task Definition does not allow collections
JB306	09/22/06 James Bourette  Localize Property Descriptions
----------------------------------------------------------------------
*/
Parameter PROPERTYVALIDATION = 2;

/// Default Localization Domain
Parameter DOMAIN = "%Utility";

/// This defines the user-visible name of this task;
/// This is defined in subclasses.
Parameter TaskName As STRING;

Property %RunDate As %Date;

Property %RunTime As %Time;

/// This method is responsible for executing the task.<br>
/// At the scheduled time, the Task Manager creates an instance of this object,
/// sets any property values using the stored "settings" for the task, and then
/// invokes this method to execute the task.<br>
/// In order to execute a real task, override this method in a subclass.
Method OnTask() As %Status
{
	Quit $$$ERROR($$$NotImplemented)
}

/// Return the serialized set of settings for this Task as a $List.
/// This serialized value is used by the Task Manager to store settings 
/// for this task.<br>
/// The serialized state is of the form:<br>
/// $LB(name,val,name,val)
Method GetSettings() As %List [ CodeMode = objectgenerator, Final ]
{
	Do %code.WriteLine(" Set tState = """"")

	// find list of "settings"
	For n = 1:1:%compiledclass.Properties.Count() {
		Set pdef = %compiledclass.Properties.GetAt(n)
		If (pdef.Private || ($E(pdef.Name,1,1) = "%")) continue
		// JMD: removed call to IsValid as it made no sense here!
		If pdef.Collection]"" {
			Do %code.WriteLine(" Set tColState=""""")
			Do %code.WriteLine(" Set key="""" For  Set value=.."_pdef.Name_".GetNext(.key) quit:key=""""  Set tColState = tColState _ $LB(key,value)")
			Do %code.WriteLine(" Set tState = tState _ $LB("""_pdef.Name_""",tColState)")
		} Else {
			Do %code.WriteLine(" Set tState = tState _ $LB("""_pdef.Name_""",.."_pdef.Name_")")
		}
 	}

	Do %code.WriteLine(" Quit tState")
	
	Quit $$$OK
}

Method SetSettings(pState As %List) As %Status [ Final ]
{
	Set $ZT="Trap"
	Set tSC = $$$OK
	Do ..GetCollectionType("",.tCollection)
	// apply serial state to this object
	For n=1:2:$LL(pState) {
		Set tName = $LG(pState,n)
		Set tVal = $LG(pState,n+1)
		Set tMethod=$g(tCollection(tName))
		Set tMethod=$S(tMethod="array":"SetAt",tMethod="list":"Insert",1:"")
		If tMethod = "" Set $property($this,tName) = tVal continue
		Set tCollectionVar = $property($this,tName)
		Do tCollectionVar.Clear()
		For idx=1:2:$ll(tVal) {
			Set tNode=$li(tVal,idx)
			Set tColVal=$li(tVal,idx+1)
			Do $method(tCollectionVar,tMethod,tColVal,tNode)
		}
	}

Done
	Quit tSC

Trap
	Set $ZT=""
	Goto Done
}

/// This callback is called when this form is submitted.
/// <var>pID</var> is the ID value associated with the form.
/// The default implementation will perform a Save if the AutoForm is a persistent object.<br>
/// <var>pSubmit</var> is the name of the submit button (i.e., $AUTOFORM_SAVE).
Method OnSubmit(ByRef pID As %String, pSubmit As %String) As %Status [ CodeMode = objectgenerator, Final ]
{
	// see if submitted values are valid
	Do %code.WriteLine(" Set tSC = $$$OK")
	Do %code.WriteLine(" Set tError = """"")
	
	Do %code.WriteLine(" Do {")

	// find list of "settings"
	For n = 1:1:%compiledclass.Properties.Count() {
		Set pdef = %compiledclass.Properties.GetAt(n)
		If ('pdef.Private && ($E(pdef.Name,1,1) '= "%")) {
			Do %code.WriteLine(" Set tValid = 1")
			If (pdef.Required) {
				Do %code.WriteLine(" Set:(.."_pdef.Name_"="""") tSC = $$$ERROR($$$GeneralError,""Property '"_pdef.Name_"' is required."")")
			}
			Do %code.WriteLine(" Set:(.."_pdef.Name_"'="""") tValid =.."_pdef.Name_"IsValid(.."_pdef.Name_")")
			Do %code.WriteLine(" If ('tValid) {")
				Do %code.WriteLine(" Set tSC = $$$ERROR($$$GeneralError,""Property '"_pdef.Name_"' is invalid."")")
				Do %code.WriteLine(" Quit")
			Do %code.WriteLine(" }")
		}
	}
	Do %code.WriteLine(" } While(0)")

	Do %code.WriteLine(" Quit tSC")
	
	Quit $$$OK
}

/// Returns the localized name of this task.
ClassMethod GetTaskName() As %String [ CodeMode = objectgenerator, Final ]
{
	// Make sure task name gets a $$$Text macro wrapped around it
	// so that it is localized.
	// User-defined task classes must make sure to set DOMAIN if they
	// want to use localization.

	Set TASKNAME = $G(%parameter("TaskName"))
	If (TASKNAME = "") {
		// no task name defined: use class name and do not localize!
		Do %code.WriteLine(" Quit """_%class.Name_"""")
		Quit $$$OK
	}

	// Test if we need to localize:
	Set tLocalize = 0
	Set DOMAIN = $G(%parameter("DOMAIN"))
	If (%class.Name [ "%SYS.Task") {
		// a built-in task
		Set tLocalize = (DOMAIN '= "")
	}
	Else {
		// user-defined
		Set tLocalize = (DOMAIN '= "") && (DOMAIN '= "%Utility")
	}

	// now generate code to get name
	If (tLocalize) {
		Do %code.WriteLine(" Quit $$$Text("_$$$quote($G(%parameter("TaskName")))_")")
	}
	Else {
		Do %code.WriteLine(" Quit ..#TaskName")
	}
	Quit $$$OK
}

ClassMethod GetPropertyName(propertyName As %String) As %String [ CodeMode = objectgenerator, Final ]
{
	// Test if we need to localize:
	Set tLocalize = 0
	Set DOMAIN = $G(%parameter("DOMAIN"))
	If (%class.Name [ "%SYS.Task") {
		// a built-in task
		Set tLocalize = (DOMAIN '= "")
	}
	Else {
		// user-defined
		Set tLocalize = (DOMAIN '= "") && (DOMAIN '= "%Utility")
	}
	If 'tLocalize {
		Do %code.WriteLine(" Quit propertyName")
		Quit $$$OK
	}
	Do %code.WriteLine(" Quit:propertyName="""" """"")
	// find list of "settings"
	For n = 1:1:%compiledclass.Properties.Count() {
		Set pdef = %compiledclass.Properties.GetAt(n)
		If (pdef.Private || ($E(pdef.Name,1,1) = "%")) continue
		Do %code.WriteLine(" Set array("""_pdef.Name_""")=$$$Text("""_pdef.Name_""")")
 	}

	Do %code.WriteLine(" Quit $G(array(propertyName))")
	Quit $$$OK
}

/// Return a collection type for a property, by passing reference tCollection we can get all properties which are collections
ClassMethod GetCollectionType(propertyName As %String, ByRef tCollection As %String) As %String [ CodeMode = objectgenerator, Final ]
{
	// find list of "settings"
	For n = 1:1:%compiledclass.Properties.Count() {
		Set pdef = %compiledclass.Properties.GetAt(n)
		If pdef.Collection]"" Do %code.WriteLine(" Set tCollection("""_pdef.Name_""")="""_pdef.Collection_"""")
 	}
	Do %code.WriteLine(" Quit:propertyName="""" """"")
	Do %code.WriteLine(" Quit $G(tCollection(propertyName))")
	Quit $$$OK
}

}
