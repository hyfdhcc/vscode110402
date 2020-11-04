Class %Net.Remote.Java.JavaGateway Extends %Net.Remote.Gateway [ System = 3 ]
{

Parameter JMSGETMESSAGE [ Final ] = "YG";

Method %GetMessage() As %ObjectHandle [ Final ]
{
	Set ..CurrentDevice=$IO
	Use ..GatewayDevice
	Set x=$zobjexport(9),fun=$zobjexport(15)
	If fun'="YN" {
		Use ..CurrentDevice Set x=$$$ERROR($$$RemoteGatewayError,"Invalid Message: "_fun)
		ZT "JGTW"
	}
	Set className=$zobjexport(12)
	Set message=$classmethod(className,"%New")
	Set message.Gateway=$this
	Set x=$zobjexport(className,18)
	Set x=$zobjexport(message,18)
	Set x=$zobjexport(..#JMSGETMESSAGE,8)
	Set x=$zobjexport(9)
	Use ..CurrentDevice
	Quit message
}

}
