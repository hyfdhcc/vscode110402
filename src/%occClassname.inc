ROUTINE %occClassname [Type=INC]
#;
#; classname and package name related macros
#; 
#define normalize(%string)           %string 
#define NormalizeClassname(%class)   $s(%class="":"",%class[".":%class,$e(%class)'="%":"User."_%class,1:"%Library."_$e(%class,2,*))
#define DenormalizeClassname(%class) $s($l(%class,".")=2:$s($e(%class,1,9)="%Library.":"%"_$p(%class,".",2),1:%class),1:%class)
#define ClassPackageName(%class)     $p(%class,".",1,*-1)
#define ClassShortName(%class)       $p(%class,".",*)
#define ClassCompatibleName(%class)  $s($$$ClassPackageName(%class)="%Library":"%",1:"")_$$$ClassShortName(%class)
 