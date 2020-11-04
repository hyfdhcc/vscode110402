ROUTINE %IFInclude [Type=INC]
/// Bitstring macro's
#define IFBITOFFPOS(%id,%off,%pos)		Set %off=(%id\64000)+1,%pos=(%id#64000)+1
#define IFIDOFFPOS(%off,%pos)			(((%off-1)*64000)+%pos-1)
#define IFGETIDOFFPOS(%id,%off,%pos)	Set %id=$$$IFIDOFFPOS(%off,%pos)
#define IFSETBIT(%arr,%id,%b)			Set $bit(%arr((%id\64000)+1),(%id#64000)+1)=%b
#define	IFBITOFF(%id)					((%id\64000)+1)
#define	IFBITPOS(%id)					((%id#64000)+1)


#define IFFINDFULL			0
#define IFFINDEXTEND		1


/// And bits of different bitstrings
#define IFANDBITS(%dst,%src)                            ##continue
    set mbChunk=""                                      ##continue
    for {                                               ##continue
        set mbChunk=$o(%dst(mbChunk),1,mbBits)          ##continue
        quit:mbChunk=""                                 ##continue
        set mbBits=$bitlogic(mbBits&%src(mbChunk))      ##continue
        If $bitfind(mbBits,1) {                         ##continue
            Set %dst(mbChunk)=$bitlogic(mbBits)         ##continue
        } Else {                                        ##continue
            Kill %dst(mbChunk)                          ##continue
        }                                               ##continue
    }
#define IFANDNOTBITS(%dst,%src)                         ##continue
    set mbChunk=""                                      ##continue
    for {                                               ##continue
        set mbChunk=$o(%dst(mbChunk),1,mbBits)          ##continue
        quit:mbChunk=""                                 ##continue
        set mbBits=$bitlogic(mbBits & ~%src(mbChunk))   ##continue
        If $bitfind(mbBits,1) {                         ##continue
            Set %dst(mbChunk)=$bitlogic(mbBits)         ##continue
        } Else {                                        ##continue
            Kill %dst(mbChunk)                          ##continue
        }                                               ##continue
    }
    
/// OR bitstrings
#define IFORBITS(%dst,%src) ##continue
	set tChunk="" ##continue
	for { ##continue
		set tChunk=$order(%src(tChunk),1,tBits) ##continue
		quit:tChunk="" ##continue
		set %dst(tChunk) = $bitlogic(%dst(tChunk) | tBits) ##continue
	}
#define IFORNOTBITS(%dst,%src) ##continue
	set tChunk="" ##continue
	for { ##continue
		set tChunk=$order(%src(tChunk),1,tBits) ##continue
		quit:tChunk="" ##continue
		set %dst(tChunk) = $bitlogic(%dst(tChunk) | ~tBits) ##continue
	}
	

/// Characters not to strip
#define STRIPKEEP "`-_"

/// Max word length
#define IFMAXLEN						150

/// search options
#define IFSEARCHNORMAL					0
#define IFSEARCHSTEMMED					1
#define IFSEARCHDECOMPOUNDED			2
///#define IFSEARCHDECOMPEXP				3
#define IFSEARCHPATTERN					4
#define IFSEARCHFUZZY					3

/// Find cases
#define IFSELWORD 0 
#define IFSELENTITY 1
#define IFSELPOSITIONAL 2

/// Positions of words int entities
#define IFWORDPOSSTART			"s"
#define IFWORDPOSMID			"m"
#define IFWORDPOSEND			"e"

///
#define IFGLOBALINDEXLOC				"INDEXLOC"
#define IFGLOBALDICTLOC					"DICTLOC"

/// Subscript in index globals
#define IFGLOBALSUBENTITY				"E"
#define IFGLOBALSUBWORD					"W"
#define IFGLOBALSUBWORDPOS				"P"
#define IFGLOBALSUBCLEAN				"c"
#define IFGLOBALSUBDOMINANCE			"d"
#define IFGLOBALSUBPATH					"p"
#define IFGLOBALSUBPROXIMITY			"x"
#define IFGLOBALSUBPROXIMITYORIGIN		"xio"
#define IFGLOBALATTRIBUTE				"A"
#define IFGLOBALATTRIBUTEPOS			"AP"
#define IFGLOBALLANGUAGE				"L"

/// Throw macro's
#define THROWGENERAL(%description)      THROW ##class(%Exception.SQL).CreateFromSQLCODE(-400,%description)
#define THROWFILELOCKING(%lock)         THROW ##class(%Exception.SQL).CreateFromSQLCODE(-110,"Failed to lock "_%lock)
#define THROWSTATUS(%status)            THROW:$$$ISERR(%status) ##class(%Exception.StatusException).CreateFromStatus(%status)

/// Dummy domain to do iknow indexing
#define	IFINDDOMAIN						-2

#define IFGetLangId(%lang) ##class(%iFind.Filer.Basic).GetLanguageId(%lang)

/// BDB664: the default ranker algorithm to use
#define IFDEFAULTRANKER "%iFind.Rank.TFIDF"

/// The multiplier by which dominance values are multiplied (and then rounded) before they are stored
#define IFDOMINANCEMULTIPLIER 1000

/// BDB666: default highlighting tags
#define IFDEFAULTHLTAGS "<b>,<font color=""red"">"

/// BDB670
#define GloNameMLS(%g) $s($e(%g,*)=")":$e(%g,1,*-1)_",", 1:%g_"(")

/// BDB675: configurable shared data location
#define DataLocationSub(%l) $case(%l,"WordI":"$WI","WordD":"$WD","WordCP":"$WCP","WordRI":"$WRI","TransfoD":"$TD","TransfoI":"$TI","TransfoW":"$TW","TransfoB":"$TB","EntityW":"$EW","EntityI":"$EI","EntityD":"$ED","EntityWP":"$EWP")
#define DataLocation(%l,%p) $s(%p="":"^ISC.IF."_%l_"(", 1:$$$GloNameMLS(%p)_$$$QUOTE($$$DataLocationSub(%l))_",")
#define DataLocationN(%l,%p) $s(%p="":"^ISC.IF."_%l, 1:$$$GloNameMLS(%p)_$$$QUOTE($$$DataLocationSub(%l))_")")
#define GetSharedLocation(%param,%idxloc,%sloc) if (%param="INDEX") { set %sloc = %idxloc } ##continue
			else { $$$THROWGENERAL("Unknown shared data location type: '"_%param_"'") }
#define GetSharedLocationS(%param,%idxloc,%sloc) if (%param="INDEX") { do ##class(%iFind.Index.ClassGenerator.Abstract).ParseIndexLocation(%idxloc,.%sloc) } ##continue
			else { $$$THROWGENERAL("Unknown shared data location type: '"_%param_"'") }
#define GetIndexLocations(%cls,%idx,%priv,%shared,%override) if $g(%override)'="" { set %priv = %override, %shared = $s($e(%override)="@":"", 1:%override) } ##continue
		else { if $g(%cls)="" { set %priv = "" } elseif '$d($$$EXTIDXGLOBAL($$$pEXT,%cls,%idx,$$$IFGLOBALINDEXLOC),%priv) { do ##class(%Compiler.iFind.Index).GenerateGlobalNames(%cls,%idx) set %priv = $$$EXTIDXGLOBAL($$$pEXT,%cls,%idx,$$$IFGLOBALINDEXLOC) } ##continue
		set tLocalSharedStorage = $s($g(%cls)="":"", 1:$$$comMemberArrayGet(%cls,$$$cCLASSindex,%idx,$$$cINDEXparameter,"IFINDSHAREDDATALOCATION")) ##continue
		set:tLocalSharedStorage="" tLocalSharedStorage = "NAMESPACE" ##continue
		if (tLocalSharedStorage'="NAMESPACE") { $$$GetSharedLocation(tLocalSharedStorage,%priv,%shared) } else { set %shared = "" } }
		