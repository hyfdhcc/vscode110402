ROUTINE %occUtility [Type=INC]
#define quote(%val) $zutil(144,1,%val)
#define quoteall(%val) """"_$extract($zutil(144,1,"z"_%val),3,*)
quote(string) public { Quit $$$quote(string) }
quoteall(string) public { Quit $$$quoteall(string) }
 