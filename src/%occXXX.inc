ROUTINE %occXXX [Type=INC]
#;
#; generic macros
#;
#define cXXXXmethod		"m"
#define cXXXXparamvalue	"P"
#;
#define XXXX(%ref,%class,%kind,%element) %ref(%class,(),(,%kind),(,%element),"")
#define XXXXxxx(%ref,%class,%kind,%element,%keyword) %ref(%class,(),(,%kind,%element),(,%keyword),$$$tableDefaultGet(%kind,%keyword))
#;
#define modlevelNONE             0
#define modlevelDESCRIPTIONONLY  1
#define modlevelMETHODCODEONLY   2
#define modlevelCOMPLETE         9
#;
#; enumeration values
#;
#define isoneof(%one,%all)             $$isoneof^%occModify(%one,%all)
#;
#; all enum values are now generated in %occKeyword.INC
#define cCLASSCLASSTYPEQUERYTYPE         "querytype"
#define cPROPCOLLECTIONREGULAR          $lb("array","list")
#define cPROPCOLLECTIONSTREAM           $lb("binarystream","characterstream")
#;
#; copied from old %occReference
#;
#define STORE(%ref,%class,%storage) %ref(%class,(),(,"s"),(,%storage),"")
#define STORExxx1(%ref,%class,%storage,%key1) %ref(%class,(),(,"s",%storage),(,%key1),"")
#define STORExxx2(%ref,%class,%storage,%key1,%key2) %ref(%class,(),(,"s",%storage),(,%key1,%key2),"")
#define STORExxx3(%ref,%class,%storage,%key1,%key2,%key3) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3),"")
#define STORExxx4(%ref,%class,%storage,%key1,%key2,%key3,%key4) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3,%key4),"")
#define STORExxx5(%ref,%class,%storage,%key1,%key2,%key3,%key4,%key5) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3,%key4,%key5),"")
#define STORExxx6(%ref,%class,%storage,%key1,%key2,%key3,%key4,%key5,%key6) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3,%key4,%key5,%key6),"")
#define STORExxx7(%ref,%class,%storage,%key1,%key2,%key3,%key4,%key5,%key6,%key7) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3,%key4,%key5,%key6,%key7),"")
#define STORExxx8(%ref,%class,%storage,%key1,%key2,%key3,%key4,%key5,%key6,%key7,%key8) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3,%key4,%key5,%key6,%key7,%key8),"")
#define STORExxx9(%ref,%class,%storage,%key1,%key2,%key3,%key4,%key5,%key6,%key7,%key8,%key9) %ref(%class,(),(,"s",%storage),(,%key1,%key2,%key3,%key4,%key5,%key6,%key7,%key8,%key9),"")
#;
#define PACKAGE(%package)             ^oddPKG($zcvt(%package,"u"))
#define PACKAGEclientname(%package)   ^oddPKG($zcvt(%package,"u"),"clientname")
#define PACKAGEdescription(%package)  ^oddPKG($zcvt(%package,"u"),"description")
#define PACKAGEglobalprefix(%package) ^oddPKG($zcvt(%package,"u"),"globalprefix")
#define PACKAGEname(%package)         ^oddPKG($zcvt(%package,"u"),"name")
#define PACKAGEownername(%package)    ^oddPKG($zcvt(%package,"u"),"ownername")
#define PACKAGErtnprefix(%package)    ^oddPKG($zcvt(%package,"u"),"rtnprefix")
#define PACKAGEsqlname(%package)      ^oddPKG($zcvt(%package,"u"),"sqlname")
#define PACKAGEnext(%package)         $order(^oddPKG(%package))
#;
