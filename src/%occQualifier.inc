ROUTINE %occQualifier [Type=INC]
#define QUALIFIERROOT                                 ^%qCacheObjectQualifier
#define QUALIFIER(%group,%name)                       ^%qCacheObjectQualifier(%name)
#define QUALIFIERtype(%group,%name)                   ^%qCacheObjectQualifier(%name,"type")
#define QUALIFIERdescription(%group,%name)            ^%qCacheObjectQualifier(%name,"description")
#define QUALIFIERaliaslist(%group,%name)              ^%qCacheObjectQualifier(%name,"aliaslist")
#define QUALIFIERenumlist(%group,%name)               ^%qCacheObjectQualifier(%name,"enumlist")
#define QUALIFIERdefaultvalue(%group,%name)           ^%qCacheObjectQualifier(%name,"default")
#define QUALIFIERnegatedvalue(%group,%name)           ^%qCacheObjectQualifier(%name,"negated")
#define QUALIFIERpresentvalue(%group,%name)           ^%qCacheObjectQualifier(%name,"present")
#define QUALIFIERallvalue(%group,%name)               ^%qCacheObjectQualifier(%name,"all")
#define QUALIFIERnonevalue(%group,%name)              ^%qCacheObjectQualifier(%name,"none")
#define QUALIFIERalias(%group,%name,%value)           ^%qCacheObjectQualifier(%name,"alias",%value)
#define QUALIFIERflagequivalence(%group,%name,%value) ^%qCacheObjectQualifier(%name,"flag",%value)
#;
#define xQUALIFIERROOT                          ^%qCacheObjectQualifier
#def1arg xQUALIFIER(%args)                      ^%qCacheObjectQualifier(%args)
#define xQUALIFIERtype(%name)                   ^%qCacheObjectQualifier(%name,"type")
#define xQUALIFIERdescription(%name)            ^%qCacheObjectQualifier(%name,"description")
#define xQUALIFIERaliaslist(%name)              ^%qCacheObjectQualifier(%name,"aliaslist")
#define xQUALIFIERenumlist(%name)               ^%qCacheObjectQualifier(%name,"enumlist")
#define xQUALIFIERdefaultvalue(%name)           ^%qCacheObjectQualifier(%name,"default")
#define xQUALIFIERnegatedvalue(%name)           ^%qCacheObjectQualifier(%name,"negated")
#define xQUALIFIERpresentvalue(%name)           ^%qCacheObjectQualifier(%name,"present")
#define xQUALIFIERallvalue(%name)               ^%qCacheObjectQualifier(%name,"all")
#define xQUALIFIERnonevalue(%name)              ^%qCacheObjectQualifier(%name,"none")
#define xQUALIFIERalias(%name,%value)           ^%qCacheObjectQualifier(%name,"alias",%value)
#define xQUALIFIERflagequivalence(%name,%value) ^%qCacheObjectQualifier(%name,"flag",%value)
#define xQUALIFIERenumexternalvalue(%name)      ^%qCacheObjectQualifier(%name,"externalvalue")
#;
#define qualifierParse(%group,%qspec,%qstruct)                         $$ParseQualifier^%occQualifier(%group,%qspec,%qstruct)
#define qualifierParseFull(%sc,%qspec,%qstruct)                        If $d(%qspec)\10 { Merge %qstruct=%qspec Set %sc=1 } Else { Set %sc=$$ParseQualifier^%occQualifier("",.%qspec,.%qstruct) }
#define qualifierParseAlterDefault(%group,%altdefault,%qspec,%qstruct) $$ParseQualifierAlterDefault^%occQualifier(%group,%altdefault,%qspec,%qstruct)
#define qualifierAmend(%group,%qstructin,%qspec,%qstructout)           $$AmendQualifier^%occQualifier(%group,%qstructin,%qspec,%qstructout)
#;
#define qualifierGetValue(%qualifiers,%name)      %qualifiers(%name)
