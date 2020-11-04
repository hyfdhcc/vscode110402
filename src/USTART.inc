ROUTINE USTART [Type=INC]
#show
 ;%USTART.INC RJW962 10/22/04 Include file for %USTART and %UHALT processing
#noshow
 
#if 0  /*===========Mainenance=====================================*/
RJW962 ;10/22/04 Ron Watt, Remove SESSION %ZSTART and %ZSTOP entry point invocations created by RJW957
RJW957 ;10/21/04, Ron Watt, Enhance Users.ZSTART to check the enabled bit.
LFT477 ;08/04/97, Laura Tillem, test which options to use
#endif /*===========End Maintenance================================*/
 
#define NOLOGINSTART 1
#define NOJOBSTART 2
#define NOCALLINSTART 4
#define NOLOGINHALT 8
#define NOJOBHALT 16
#define NOCALLINHALT 32
#define NOSYSTEMSTART 64
#define NOSYSTEMHALT 128
#;RJW957+ ; RJW962+
#define GETUSTART $v($ZU(40,2,115),-2,1)
#define	SETUSTART(%val) v $ZU(40,2,115):-2:1:%val
#define	USTARTENABLED(%x) ($v($ZU(40,2,115),-2,1)\(%x)#2=0)
#;RJW957- ; RJW962+
 