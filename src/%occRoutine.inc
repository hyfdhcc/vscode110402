ROUTINE %occRoutine [Type=INC]
#; Define which routine types we support, what language mode they are etc.
#; If you wish to add a new language you need to modify this file and %RoutineMgr in the
#; routine query to add any new types to Studio. Hopefully there should be very few other
#; changes required in object code.
#define rtnIsINT(%type)		$case($zconvert(%type,"U"),"INT":1,"BAS":1,"MVI":1,:0)
#define rtnIsMAC(%type)		$case($zconvert(%type,"U"),"MAC":1,:0)
#define rtnIsINC(%type)		$case($zconvert(%type,"U"),"INC":1,:0)
 
#define rtnTypeLang(%type)	$case($zconvert(%type,"U"),"BAS":9,"MVI":11,:0)
#define rtnLangINT(%lang)	$select(+%lang<9:"INT",1:$case(+%lang,9:"BAS",10:"INT",11:"MVI",12:"PROC"))
#define rtnLangMAC(%lang)	$select(+%lang<9:"MAC",1:$case(+%lang,10:"MAC"))
 
#define rtnGlobal(%type)	$select($$$rtnIsINT(%type):"^ROUTINE",$$$rtnIsMAC(%type):"^rMAC",$$$rtnIsINC(%type):"^rINC",$zconvert(%type,"U")="OBJ":"^rOBJ",1:"")
 
#define rtnIsKnown(%type)	(",INT,BAS,MVI,MAC,INC,"[(","_$zconvert(%type,"U")_","))
#define rtnMACTypes			"MAC"
#define rtnINTTypes			"INT","BAS","MVI"
#define rtnINCTypes			"INC"
 
#define rtnRemoveINTIdx(%name)	Kill ^rINDEX(%name,"INT"),^("BAS"),^("MVI")
#define rtnRemoveMACIdx(%name)	Kill ^rINDEX(%name,"MAC")
#define rtnRemoveINCIdx(%name)	Kill ^rINDEX(%name,"INC")
#define rtnRemoveOBJIdx(%name)	Kill ^rINDEX(%name,"OBJ")
 
#; The "document journal" global that tracks all document modifications
#; (not only for routines, but also classes, etc)
#; It is always referenced with a database directory specification
#define DocJrnGbl(%dir)		^|%dir|ISC.Src.Jrn
#; Except for the rare occasion when I need only the name
#define DocJrnGblName		^ISC.Src.Jrn
