ROUTINE %occCPTJSNT [Type=INC]

#; JavaScript name table

#; Each name has a list of entries, keyed by nodeindex
#;
#; An entry is a $List :-
#;  1: type - var | prop | qprop | label (enum number)
#;  2: info - type-specific, a $List
#;  3: role - type-specific (enum number)
#; (var includes functions)
#;
#; var role: set | get | declare | setprop | setqprop | getprop | getqprop | call
#; var info: isfun, scopenodeindex (0 for global)
#;
#; prop role: set | get | call
#; prop info: basenodeindex
#; (same for qprop)


#; storage
#define JSNTG ^||%isc.cpt.jsnt
#define JSNTNODECOUNT(%name) $$$JSNTG(%name)
#define JSNTNODEANNCOUNT(%name,%nodeindex) $$$JSNTG(%name,%nodeindex)
#define JSNTENTRY(%name,%nodeindex,%annindex) $$$JSNTG(%name,%nodeindex,%annindex)


#; roles
#define JSNTROLEDECL 1
#define JSNTROLEGETV 2
#define JSNTROLESETV 3
#define JSNTROLECALL 4
#define JSNTROLESETP 5
#define JSNTROLESETQ 6
#define JSNTROLEGETP 7
#define JSNTROLEGETQ 8


#; var info
#define JSNTINFOVsni 1
#define JSNTINFOVisfun 2

#; prop (and qprop) info
#define JSNTINFOPbni 1

