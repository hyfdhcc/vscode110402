ROUTINE ISCstrip [Type=INC]
;;ISCstrip.INC    function for stripping leading/trailing spaces
 
#if 0   /*=======================Maintenance========================*/
#;SML1494 04/26/12 Simon Li, Rename Z*.INC and z*.INC to ISC*.INC.
BEB410   ;04/29/92, Ben Bishop. Uses Zstripdef.inc to separate out macros
#endif  /*=====================End Maintenance======================*/
 
#ifndef ISCstrip
#define ISCstrip
 
#include ISCstripdef
 
Strip(x) Q $$StrHead($$StrTail(.x)) ;strip both leading and trailing spaces
 
StrHead(x) ;return 'x' without any leading spaces
 Q $$$StrHead(x)
 
StrTail(x) ;return 'x' without any trailing spaces
 Q $$$StrTail(x)
 
#define StrQuote(%a) $$StrQuote(%a)
StrQuote(x) ; return 'x' without 1 layer of quotes
 I ($E(x)'="""")!($E(x,$L(x))'="""") Q x
 S x="S x="_x X x Q x
 
#endif ISCstrip