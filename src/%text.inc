ROUTINE %text [Type=INC]
#define metachar "#"
#define noiseword 0
#define normalword 1
#define numdocuments 2
#define sumdoclen 3
#define category 4
#define thesaurus 5
#define synonyms 6
#define phonetic 7
#define	tfColl 1
#define tfUncoll 2
#define wqt 3
 
#define GetSimilarityIndexData(%globalRef) 			$lg($g(%globalRef),2)
 
 