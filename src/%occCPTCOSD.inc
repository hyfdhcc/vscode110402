ROUTINE %occCPTCOSD [Type=INC]

#; a defining-occurrence of a variable is one of :-
#; - in a #dim list
#; - on the left-hand-side of a SET command argument whose right-hand-side
#;   is of the form ##class(class).%New/%Open/%OpenId/<index>Open(...)
#;
#; a use-occurrence is any other use of a variable
#;
#; if only use-occurrences are present for a variable the first one is recorded
#; and a type of "" is assigned
#;
#; if there are any defining-occurrences for a variable the last one is recorded
#; and the given type is assigned (may be "" if defined in a #dim)

/// root of dictionary global
#define CPTDG ^||%isc.cpt.d

/// root of dictionary variables
#define CPTDV(%tree) ^||%isc.cpt.d(%tree,"v")

/// dictionary variable definition
#define CPTDVDEFV(%tree,%var) ^||%isc.cpt.d(%tree,"v",%var)
#; 1   - kind
#; 2   - type ("" for unknown)
#; 3-5 - definition location: $LB(studiodocument,line,column)
 
/// dictionary variable - kind
#define CPTDVDEFVKIND(%tree,%data) $List(%data)

/// dictionary variable - cache type
#define CPTDVDEFVTYPE(%tree,%data) $List(%data,2)

/// dictionary variable - declaration locus as $LB(file,line,col)
#define CPTDVDEFVDECLOCUS(%tree,%data) $List(%data,3,5)

/// root of dictionary variable index by kind
#define CPTDVIK(%tree) ^||%isc.cpt.d(%tree,"vik")

/// root of dictionary variable index by kind, for a specific kind
#define CPTDVIKK(%tree,%kind) ^||%isc.cpt.d(%tree,"vik",%kind)

/// kind dictionary variable index entry (no data)
#define CPTDVIKKV(%tree,%kind,%var) ^||%isc.cpt.d(%tree,"vik",%kind,%var)

