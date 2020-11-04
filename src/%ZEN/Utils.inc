ROUTINE %ZEN.Utils [Type=INC]
#; %ZEN.Utils.INC
#; Include file for %ZEN Library
 
#; Takes a ZEN property value and, if it contains an expression
#; evaluates it, otherwise return the orginal value.
#define ZENVAL(%val)		$S(%val'["#(":%val,1:..%Eval(%val))
#define ZENVALJS(%val)		$S(%val'["#(":%val,1:..%Eval(%val,"JS"))
#define ZENVALHTML(%val)	$S(%val'["#(":%val,1:..%Eval(%val,"HTML"))
#define ZENCVAL(%val)		$S(%val'["#(":%val,1:..%EvalC(%val))
#define ZENCVALJS(%val)		$S(%val'["#(":%val,1:..%EvalC(%val,"JS"))
#define ZENCVALHTML(%val)	$S(%val'["#(":%val,1:..%EvalC(%val,"HTML"))
 
#; inject a JS alert that will display a value on the client
#define ZENALERT(%val)		&js<alert('#($ZCVT(%val,"O","JS"))#');>
 
#; Returns true if we are talking to an IE browser.
#define ZENISIE 	((%request.UserAgent [ "MSIE")||(%request.UserAgent [ "Trident"))
 
#; Special value used by MVC to indicate a missing property.
#define ZENMISSING			$C(1,1,1)
 
#; Macros to get current class and method at compile time. 
#define ZenCurrentClass            $zobjclass($this)
#define ZenCurrentMethod           ##safeexpression(""""_$get(%methodname)_"""")
 
#; Log an informational message to Zen log (if enabled)
#define ZENLOG(%type,%msg)	Do:$D(^%ISC.ZENLOG) ##class(%ZEN.Utils).%Log(%type,$$$ZenCurrentClass,$$$ZenCurrentMethod,%msg,$G(%this))
 
#; Log specific types of event
#define ZENLOGINFO(%msg)	$$$ZENLOG("INFO",%msg)
#define ZENLOGERROR(%msg)	$$$ZENLOG("ERROR",%msg)
#define ZENLOGSTATUS(%sc)	$$$ZENLOG("ERROR",$System.Status.GetErrorText(%sc))
 
#; type encodings used by MVC classes
#define ZENMVCNONE			0
#define	ZENMVCOBJECT		1
#define	ZENMVCPERSISTENT	2
#define	ZENMVCSERIAL		3
#define	ZENMVCSTREAM		4
#define	ZENMVCBSTREAM		5
#define ZENMVCLIST			6
#define ZENMVCARRAY			7
#define ZENMVCRELATIONSHIP	8
 
#define ZENMVCDATE			10
#define ZENMVCTIME			11
#define ZENMVCINTEGER		12
#define ZENMVCFLOAT			13
#define ZENMVCBOOLEAN		14
 
#; JSON utilities
#define ZENJSESCAPE(%str)	$Replace($ZCVT(%str,"O","JS"),"\'","'")
#define ZENJSSTR(%str)		(""""_$$$ZENJSESCAPE(%str)_"""")
#define ZENJSNUM(%num)		$fnumber(%num,"LON")
#define ZENJSISNUM(%val)	($IsValidNum(%val)&&(%val=+(%val)))
#define ZENJSPROP(%prop)	$$$ZENJSSTR(%prop)
#define ZENJSVALUE(%val)	$S($$$ZENJSISNUM(%val):$$$ZENJSNUM(%val),$C(0)=(%val)||$ListValid(%val):"""""",1:$$$ZENJSSTR(%val))
#define ZENJSPAIR(%pr,%val)	$$$ZENJSPROP(%pr)_":"_$$$ZENJSVALUE(%val)
 
#define ZENJSUESCAPE(%str)	$Replace($ZCVT(%str,"O","JSML"),"\'","'")
#define ZENJSUSTR(%str)		(""""_$$$ZENJSUESCAPE(%str)_"""")
#define ZENJSUPROP(%prop)	$$$ZENJSUSTR(%prop)
#define ZENJSUVALUE(%val)	$S($$$ZENJSISNUM(%val):$$$ZENJSNUM(%val),$C(0)=(%val)||$ListValid(%val):"""""",1:$$$ZENJSUSTR(%val))
#define ZENJSUPAIR(%pr,%val) $$$ZENJSUPROP(%pr)_":"_$$$ZENJSUVALUE(%val)

#; JSON utility macros that use the JSON translation table instead of the JS translation table
#define ZENJSTABLE(%format)				("JS"_$S(%format["u":"ML",1:""))
#define ZENJSONTABLE(%format)			("JSON"_$S((%format["u"):"ML",1:""))
#define ZENJSONESCAPE(%str,%format)		$S(%format["s":$ZCVT(%str,"O",$$$ZENJSONTABLE(%format)),1:$Replace($ZCVT(%str,"O",$$$ZENJSTABLE(%format)),"\'","'"))
#define ZENJSONSTR(%str,%format)		(""""_$$$ZENJSONESCAPE(%str,%format)_"""")
#define ZENJSONPROP(%prop,%format)		$$$ZENJSONSTR(%prop,%format)
#define ZENJSONVALUE(%val,%format)		$S($$$ZENJSISNUM(%val):$$$ZENJSNUM(%val),$C(0)=(%val)||$ListValid(%val):"""""",1:$$$ZENJSONSTR(%val,%format))
#define ZENJSONPAIR(%pr,%val,%format)	$$$ZENJSONPROP(%pr,%format)_":"_$$$ZENJSONVALUE(%val,%format)
 
#; utility for quoting values
#define quote(%val) $zutil(144,1,%val)
