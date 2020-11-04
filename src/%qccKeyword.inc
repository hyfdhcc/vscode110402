ROUTINE %qccKeyword [Type=INC]
#include %occLocation
 
#define ToNew 1
#define ToOld 0
	
#define KEYnametoid(%table,%key)     $$$tableIntIntToSubGet(%table,%key)
#define KEYidtoname(%table,%key)     $$$tableSubSubToIntGet(%table,%key)
#define TABnametoid(%table)          $$$tableIntIntToSubGet("category",%table)
#define TABidtoname(%table)          $$$tableSubSubToIntGet("C",%table)
#define KEYconvert(%dir,%table,%key) $s(%dir=$$$ToNew:$$$KEYnametoid(%table,%key),1:$$$KEYidtoname(%table,%key))
#define TABconvert(%dir,%table)      $s(%dir=$$$ToNew:$$$TABnametoid(%table),1:$$$TABidtoname(%table))
	