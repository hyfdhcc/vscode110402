ROUTINE %occSAX [Type=INC]
#include %callout
 
#; ------------------------------------------------------------------------
#; Bit flags for %XML.SAX.Parser callbacks to process (Mask Argument)
#; ------------------------------------------------------------------------
#;
#; Specify this bit if you want to process the 'start document' callback
#define SAXSTARTDOCUMENT           1
#;
#; Specify this bit if you want to process the 'end document' callback
#define SAXENDDOCUMENT             2
#;
#; Specify this bit if you want to process the 'start element' callback
#define SAXSTARTELEMENT            4
#;
#; Specify this bit if you want to process the 'end element' callback
#define SAXENDELEMENT              8
#;
#; Specify this bit if you want to process the 'characters' callback
#define SAXCHARACTERS              16
#;
#; Specify this bit if you want to process the 'processing instruction' callback
#define SAXPROCESSINGINSTRUCTION   32
#;
#; Specify this bit if you want to process the 'start prefix mapping' callback
#define SAXSTARTPREFIXMAPPING      64
#;
#; Specify this bit if you want to process the 'end prefix mapping' callback
#define SAXENDPREFIXMAPPING        128
#;
#; Specify this bit if you want to process the 'ignorable whitespace' callback
#define SAXIGNORABLEWHITESPACE     256
#;
#; Specify this bit if you want to process the 'skipped entity' callback
#define SAXSKIPPEDENTITY           512
 
#; Specify this bit if you want to process the 'comment' callback
#define SAXCOMMENT                 1024
 
#; Specify this bit if you want to process the 'startCDATA' callback
#define SAXSTARTCDATA              2048
 
#; Specify this bit if you want to process the 'endCDATA' callback
#define SAXENDCDATA                4096
 
#; Specify this bit if you want to process the 'startDTD' callback
#define SAXSTARTDTD                8192
 
#; Specify this bit if you want to process the 'endDTD' callback
#define SAXENDDTD                  16384
 
#; Specify this bit if you want to process the 'startEntity' callback
#define SAXSTARTENTITY             32768
 
#; Specify this bit if you want to process the 'endEntity' callback
#define SAXENDENTITY               65536
 
#; These callbacks cannot be MASKED
#define SAXERROR                   131072
 
#define SAXFATALERROR              262144
 
#define SAXWARNING                 524288
 
#; Useful combinations of above flags
#define SAXCONTENTEVENTS           1023
#define SAXLEXICALEVENTS           130048
#define SAXALLEVENTS               131071
 
 
 
 
#; ------------------------------------------------------------------------
#; Bit flags for %XML.SAX.Parser feature selection (flags argument)
#; ------------------------------------------------------------------------
 
#; Specify this value if you want to accept the SAX defaults (see below)
#;
#define SAXDEFAULTS                     27
 
#; Specify this value if you want the SAX defaults plus namespaces prefixes/
#define SAXFULLDEFAULT                  95
 
#;
#; Specify this bit if you want the parser to perform validation
 
#; http://xml.org/sax/features/validation   
#; On:    Report all validation errors. (default)   
#; Off:   Do not report validation errors.    
 
#define SAXVALIDATION                   1
 
#;
#; Specify this bit if you want the parser to recognize namespaces
 
#; http://xml.org/sax/features/namespaces   
#; On:   Perform Namespace processing (default)   
#; Off:  Optionally do not perform Namespace processing   
 
#define SAXNAMESPACES                   2
 
#;
#; Specify this bit if you want the parser to process namespace prefixes
 
#; http://xml.org/sax/features/namespace-prefixes   
#; On:   Report the original prefixed names and attributes used for Namespace declarations 
#; Off:  Do not report attributes used for Namespace declarations, and optionally do not report original prefixed names (default)
 
#define SAXNAMESPACEPREFIXES            4
 
#;
#; Specify this bit if you want the parser to perform validation dynamically
 
#; http://apache.org/xml/features/validation/dynamic   
#; On:   The parser will validate the document only if a grammar is specified. (http://xml.org/sax/features/validation must be true)  (default)
#; Off:  Validation is determined by the state of the http://xml.org/sax/features/validation feature
 
#define SAXVALIDATIONDYNAMIC            8
 
#;
#; Specify this bit if you want the parser to recognize schemas
 
#; http://apache.org/xml/features/validation/schema   
#; On:   Enable the parser's schema support. (default)    
#; Off:  Disable the parser's schema support.    
#define SAXVALIDATIONSCHEMA             16
 
#; Specify this bit if you want the parser to perform full schema checking
 
#; http://apache.org/xml/features/validation/schema-full-checking
#; On:   Enable full schema constraint checking, including checking which may be time-consuming or memory intensive. Currently, particle unique attribution constraint checking and particle derivation resriction checking are controlled by this option
#; Off:  Disable full schema constraint checking (default).    
 
#define SAXVALIDATIONSCHEMAFULLCHECKING  32
 
#; http://apache.org/xml/features/validation/cache-grammarFromParse
#; On:   Cache the grammar in the pool for re-use in subsequent parses
#; Off:  Do not cache the grammar in the pool  (default)
#; If set to true, the http://apache.org/xml/features/validation/use-cachedGrammarInParse is also set to true automatically.
#define SAXVALIDATIONREUSEGRAMMAR        64
 
#; Flags to force SAX not to validate but DO recognize namespaces and prefixes
#define SAXNOVALIDATION                  $$$SAXNAMESPACES+$$$SAXNAMESPACEPREFIXES
 
 
 
 
#; ------------------------------------------------------------------------
#; Miscellaneous
#; ------------------------------------------------------------------------
 
#; Internal Use Only
#define HANDLE                           $$$SaxLibrary
  
#; Byte Order Markers
#define UNIVAL 65279
#define UNIBOM $C($$$UNIVAL)
#define UTF8BOM $C(239,187,191)
 
#; CacheIsUnicode?
#define CacheIsUnicode $zbitget($zversion(0),1)
 
#; EntityExpansionLimit
#define EntityExpansionLimit 0

#; These map to the ordinals in the CacheSAX library
#define ParseStream          1
#define ParseFile            2
#define ParseURL             3
#define LocatePosition       4
#define PushHandler          5
#define PopHandler           6
#define GetXDev              7
#define ParseXDev            8
#define ParseString          9
#define Version             10
#define HTTPServer          11
#define Verify              12
#define VerifySaml          13
 
#; These determine the handler type to be used
#define RtnHandler           1
#define ClsHandler           2
#define IntHandler           3
#define LocHandler           4
#define FlatIntHandler       6
 