/// Hidden control.<br>
/// This is a simple wrapper around the HTML input=hidden control.
Class %ZEN.Component.hidden Extends control [ System = 3 ]
{

/// This control is not displayed and does not take place in layout.
Parameter DEFAULTHIDDEN = 1;

Method %DrawHTML()
{
	&html<<input type="hidden" id="#(..%MakeId("control"))#" #(..%Name())# #(..%Attr("value",..value))#/>>
}

}
