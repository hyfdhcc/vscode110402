ROUTINE COPYRIGH [Type=INC]
#;/*=======================Maintenance========================*/
#;RJW2254 11/14/14, Ron Watt Update copyright year to 2015 in COPYRIGH.INC
#;SML1354 05/17/11, Simon Li: Changed year to 2011
#;RJW1647 01/14/08, Ron Watt: Change copyright end date displayed in various places to 2009.
#;STC1144 01/04/07, Steve Clay: Update copyrights for 2007
#;STC1126 12/06/06, Steve Clay: Fix to not include excessive BOL tokens 
#;LRS1014 01/04/06, Lee Smith: Changed year to 2006
#;LRS910  02/10/05, Lee Smith: Changed year to 2005
#;LRS748  01/05/04, Lee Smith: Changed year to 2004
#;LRS656  01/06/03, Lee Smith: Changed year to 2003
#;LRS     01/07/02, Lee Smith: Changed year to 2002
#;LRS     01/02/01, Lee Smith: Changed year to 2001
#;LRS     01/04/00, Lee Smith: Changed year to 2000
#;LRS     01/05/99, Lee Smith: Changed year to 1999
#;LRS     01/06/98, Lee Smith: Changed year to 1998
#;LRS     01/27/97, Lee Smith: Changed year to 1997 for real
#;STC     01/16/97, Steve Clay: Changed year to 1997
#;LRS     02/23/96, Lee Smith: Changed year to 1996
#;JAO     01/24/95, Jeffrey Orlin, changed year to 1995
#;CLEAN   12/01/94, Peter Cudhea-Pierce, removed old code
#;DKA212  02/24/94, Keith Avery: Changed year to 1994
#;DPB122  06/02/93, Dan Smith Remove a repeated "of"
#;DPB102  3/31/93, Dan Smith 1) Change year to 1993; 2) remove 
#;        useless "(c)"; 3) identify us as InterSystems CORPORATION;
#;        4) identify our location as Cambridge.  Changes reviewed and
#;        approved by Paul Grabscheid.  Rationale for 2) is that 
#;        a parenthesized "c" gives no legal protection (is not an
#;        acceptable substitute for the circle-C character), and the
#;        word "Copyright" is adequate by itself.
#;
#;        Note: COPYRIGH.INC and %copyright.inc need to be maintained
#;        in parallel.  Usage of former: simply #include COPYRIGH
#;        Latter: must  #include %copyright  AND invoke   $$$copyright
#;/*=====================End Maintenance======================*/
  
#ifndef copyright
  #define copyright
  #show
 /*
 +--------------------------------------------------------+
 | Copyright 1986-2015 by InterSystems Corporation,       |
 | Cambridge, Massachusetts, U.S.A.                       |
 | All rights reserved.                                   |
 |                                                        |
 | Confidential, unpublished property of InterSystems.    |
 |                                                        |
 | This media contains an authorized copy or copies       |
 | of material copyrighted by InterSystems and is the     |
 | confidential, unpublished property of InterSystems.    |
 | This copyright notice and any other copyright notices  |
 | included in machine readable copies must be reproduced |
 | on all authorized copies.                              |
 +--------------------------------------------------------+
 */
  #noshow
#endif (ifndef copyright)
 