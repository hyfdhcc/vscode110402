Class %DeepSee.extensions.modelling.conf.Operator Extends %XML.Adaptor [ Abstract, System = 4 ]
{

Parameter IMPLEMENTINGCLASS;

Parameter APPLYMETHOD = "apply";

Parameter SETCONFIGMETHOD = "setConfig";

Property SourceClass As %String;

Method GetImplementingClass() As %String
{
	if (..#IMPLEMENTINGCLASS'="") {
		quit ..#IMPLEMENTINGCLASS
	} else {
		quit $piece($classname(),".",1,*-2)_"."_$piece($classname(),".",*)
	}
}

Method GetApplyMethod() As %String
{
	Quit ..#APPLYMETHOD
}

Method GetSetConfigMethod() As %String
{
	Quit ..#SETCONFIGMETHOD
}

}
