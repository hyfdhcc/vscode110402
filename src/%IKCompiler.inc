ROUTINE %IKCompiler [Type=INC]
#define AddTransitionInline(%state,%char,%nextState) 												##continue
	Set %nextState = $G(..StatesGlobal("GoTo", %state, %char)) 										##continue
	If '%nextState {																				##continue
		Set %nextState = ..NextState																##continue
		Set ..NextState = %nextState + 1															##continue
		Set ..StatesGlobal("GoTo", %state, %char) = %nextState										##continue
		Set IKCdepth = $G(..StatesGlobal("Depth", %state)) + 1										##continue
		Set ..StatesGlobal("Depth", %nextState) = IKCdepth											##continue
		Set ..StatesGlobal("DepthMap", IKCdepth - 1, %state, %char, %nextState) = ""				##continue
	}
#define AddOutputAtInline(%outputObj,%state,%curToken)												##continue
	Set IKCValue = %outputObj.GetValue(%curToken) 													##continue
	Set IKCKey = $ORDER(%outputObj.OutputFunc.StatesGlobal("Output",%state,""), 1, IKCEValue)		##continue
	While IKCKey '= "" {																					##continue
		If IKCValue = IKCEValue Quit																##continue
		Set IKCKey = $ORDER(%outputObj.OutputFunc.StatesGlobal("Output",%state,IKCKey), 1, IKCEValue)	##continue
	}																								##continue
	If IKCValue '= $G(IKCEValue) {																	##continue
		Set IKCKey = $G(%outputObj.OutputFunc.StatesGlobal("Output",%state), 0)						##continue
		Set %outputObj.OutputFunc.StatesGlobal("Output", %state, IKCKey) = IKCValue					##continue
		If %outputObj.OutputFunc.MaxState < %state Set %outputObj.OutputFunc.MaxState = %state		##continue
		Set %outputObj.OutputFunc.StatesGlobal("Output", %state) = IKCKey + 1						##continue
	}
