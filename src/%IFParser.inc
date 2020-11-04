ROUTINE %IFParser [Type=INC]
#define OP		$c(0)
#define ESC		$c(1)
#define SPC		$c(2)
#define GRPEL	$c(3)
#define GRPER	$c(4)
#define GRPWL	$c(5)
#define GRPWR	$c(6)

#define TRANS "\*<>{}() "
#define ANNOT $c(1,0,0,0,3,4,5,6,2)
#define OPLST $c(0,3,4,5,6)

#define VALIDLEFTOP		$lb("","*","<","<*","(","{","<{")
#define VALIDRIGHTOP	$lb("","*",">","*>",")","}","}>")
