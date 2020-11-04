ROUTINE %syLDAP [Type=INC]
 ; %syLDAP.INC
#if 0   /*=======================Maintenance========================*/
#;STC2452  7/16/14 Steve Clay, Add Additional parameters for LDAP set_option and get_option 
#;STC1155 01/25/07 Steve Clay, Fix LDAP error handling on Unix and VMS platforms 
#;STC983 05/01/06 Steve Clay, LDAP SSL authentication
#endif  /*=======================Maintenance========================*/
 
#define LDAPPORT               389
#define LDAPSSLPORT            636
#define LDAPGCPORT             3268
#define LDAPSSLGCPORT          3269
 
#; The default version of the API is 2. If required, the user MUST set the
#; version to 3 using the LDAP_OPT_VERSION option.
 
#define LDAPVERSION1           1
#define LDAPVERSION2           2
#define LDAPVERSION3           3
#define LDAPVERSION            LDAPVERSION2
 
#;Error messages defined for LDAP
#define ISCFIRSTLDAPMESSAGE          $zhex("5000")
#define LDAPSUCCESS                  $zhex("00")
#define LDAPOPERATIONSERROR          $zhex("01")
#define LDAPPROTOCOLERROR            $zhex("02")
#define LDAPTIMELIMITEXCEEDED        $zhex("03")
#define LDAPSIZELIMITEXCEEDED        $zhex("04")
#define LDAPCOMPAREFALSE             $zhex("05")
#define LDAPCOMPARETRUE              $zhex("06")
#define LDAPAUTHMETHODNOTSUPPORTED   $zhex("07")
#define LDAPSTRONGAUTHREQUIRED       $zhex("08")
#define LDAPREFERRALV2               $zhex("09")
#define LDAPPARTIALRESULTS           $zhex("09")
#define LDAPREFERRAL                 $zhex("0a")
#define LDAPADMINLIMITEXCEEDED       $zhex("0b")
#define LDAPUNAVAILABLECRITEXTENSION $zhex("0c")
#define LDAPCONFIDENTIALITYREQUIRED  $zhex("0d")
#define LDAPSASLBINDINPROGRESS       $zhex("0e")
 
#define LDAPNOSUCHATTRIBUTE          $zhex("10")
#define LDAPUNDEFINEDTYPE            $zhex("11")
#define LDAPINAPPROPRIATEMATCHING    $zhex("12")
#define LDAPCONSTRAINTVIOLATION      $zhex("13")
#define LDAPATTRIBUTEORVALUEEXISTS   $zhex("14")
#define LDAPINVALIDSYNTAX            $zhex("15")
 
#define LDAPNOSUCHOBJECT             $zhex("20")
#define LDAPALIASPROBLEM             $zhex("21")
#define LDAPINVALIDDNSYNTAX          $zhex("22")
#define LDAPISLEAF                   $zhex("23")
#define LDAPALIASDEREFPROBLEM        $zhex("24")
 
#define LDAPINAPPROPRIATEAUTH        $zhex("30")
#define LDAPINVALIDCREDENTIALS       $zhex("31")
#define LDAPINSUFFICIENTRIGHTS       $zhex("32")
#define LDAPBUSY                     $zhex("33")
#define LDAPUNAVAILABLE              $zhex("34")
#define LDAPUNWILLINGTOPERFORM       $zhex("35")
#define LDAPLOOPDETECT               $zhex("36")
#define LDAPSORTCONTROLMISSING       $zhex("3C")
#define LDAPOFFSETRANGEERROR         $zhex("3D")
 
#define LDAPNAMINGVIOLATION          $zhex("40")
#define LDAPOBJECTCLASSVIOLATION     $zhex("41")
#define LDAPNOTALLOWEDONNONLEAF      $zhex("42")
#define LDAPNOTALLOWEDONRDN          $zhex("43")
#define LDAPALREADYEXISTS            $zhex("44")
#define LDAPNOOBJECTCLASSMODS        $zhex("45")
#define LDAPRESULTSTOOLARGE          $zhex("46")
#define LDAPAFFECTSMULTIPLEDSAS      $zhex("47")
    
#define LDAPVIRTUALLISTVIEWERROR     $zhex("4c")
 
#define LDAPOTHER                    $zhex("50")
#define LDAPSERVERDOWN               $zhex("51")
#define LDAPLOCALERROR               $zhex("52")
#define LDAPENCODINGERROR            $zhex("53")
#define LDAPDECODINGERROR            $zhex("54")
#define LDAPTIMEOUT                  $zhex("55")
#define LDAPAUTHUNKNOWN              $zhex("56")
#define LDAPFILTERERROR              $zhex("57")
#define LDAPUSERCANCELLED            $zhex("58")
#define LDAPPARAMERROR               $zhex("59")
#define LDAPNOMEMORY                 $zhex("5a")
#define LDAPCONNECTERROR             $zhex("5b")
#define LDAPNOTSUPPORTED             $zhex("5c")
#define LDAPNORESULTSRETURNED        $zhex("5e")
#define LDAPCONTROLNOTFOUND          $zhex("5d")
#define LDAPMORERESULTSTORETURN      $zhex("5f")
 
#define LDAPCLIENTLOOP               $zhex("60")
#define LDAPREFERRALLIMITEXCEEDED    $zhex("61")
#; End LDAP error codes
#; API Error Codes
#;
#; Based on draft-ietf-ldap-c-api-xx
#; but with new negative code values
#;
#define XLDAPSERVERDOWN				(-1)
#define XLDAPLOCALERROR				(-2)
#define XLDAPENCODINGERROR				(-3)
#define XLDAPDECODINGERROR				(-4)
#define XLDAPTIMEOUT					(-5)
#define XLDAPAUTHUNKNOWN				(-6)
#define XLDAPFILTERERROR				(-7)
#define XLDAPUSERCANCELLED				(-8)
#define XLDAPPARAMERROR				(-9)
#define XLDAPNOMEMORY					(-10)
#define XLDAPCONNECTERROR				(-11)
#define XLDAPNOTSUPPORTED				(-12)
#define XLDAPCONTROLNOTFOUND			(-13)
#define XLDAPNORESULTSRETURNED		(-14)
#define XLDAPMORERESULTSTORETURN		(-15)
#define XLDAPCLIENTLOOP				(-16)
#define XLDAPREFERRALLIMITEXCEEDED	(-17)
 
#;First ISC LDAP error code (from ldap/isldap.h)
#define ISCFIRSTLDAPMESSAGE          $zhex("5000")
#define LDAPUNSUPPORTEDOPTION        $zhex("5000")
#define LDAPUNSUPPORTEDFUNCTIONONPLATFORM $zhex("5001")
#define LDAPINSUFFICIENTMEMORYNEWFAILED $zhex("5002")
#define LDAPINSUFFICIENTMEMORYNEWFAILED1 $zhex("5003")
#define LDAPINSUFFICIENTMEMORYMALLOCFAILED $zhex("5004")
#define LDAPATTRIBUTESTOOBIG $zhex("5005")
#define LDAPINTERNALERROR $zhex("5006")
#define LDAPINTERNALERROR1 $zhex("5007")
#define LDAPNOSUCHSESSION $zhex("5008")
#define LDAPNOSUCHENTRY $zhex("5009")
 
#;Options for ldap_set/get_option
#define LDAPOPTAPIINFO            $zhex("00")
#define LDAPOPTDESC               $zhex("01")
#define LDAPOPTDEREF              $zhex("02")
#define LDAPOPTSIZELIMIT          $zhex("03")
#define LDAPOPTTIMELIMIT          $zhex("04")
#define LDAPOPTTHREADFNPTRS       $zhex("05")
#define LDAPOPTREBINDFN           $zhex("06")
#define LDAPOPTREBINDARG          $zhex("07")
#define LDAPOPTREFERRALS          $zhex("08")
#define LDAPOPTRESTART            $zhex("09")
 
#define LDAPOPTSSL                $zhex("0a")
#define LDAPOPTIOFNPTRS           $zhex("0b")
#define LDAPOPTCACHEFNPTRS        $zhex("0d")
#define LDAPOPTCACHESTRATEGY      $zhex("0e")
#define LDAPOPTCACHEENABLE        $zhex("0f")
#define LDAPOPTREFERRALHOPLIMIT   $zhex("10")
 
#define LDAPOPTPROTOCOLVERSION    $zhex("11")        
#define LDAPOPTVERSION            $zhex("11")
#define LDAPOPTAPIFEATUREINFO     $zhex("15")
 
#;Not in current RFC draft.
 
#define LDAPOPTHOSTNAME           $zhex("30")
#define LDAPOPTERRORNUMBER        $zhex("31")
#define LDAPOPTERRORSTRING        $zhex("32")
#define LDAPOPTSERVERERROR        $zhex("33")
#define LDAPOPTSERVEREXTERROR     $zhex("34")
#define LDAPOPTHOSTREACHABLE      $zhex("3E")

#define LDAPOPTTIMEOUT            $zhex("5002")
#define LDAPOPTNETWORKTIMEOUT     $zhex("5005")

#define LDAPOPTXTLSCACERTFILE     $zhex("6002")
#define LDAPOPTXTLSCERTFILE       $zhex("6004")
#define LDAPOPTXTLSKEYFILE        $zhex("6005")
 
#;  These options control the keep-alive logic.  Keep alives are sent as
#;  ICMP ping messages (which currently don't go through firewalls).
#;
#;  There are three values that control how this works :
#;  PING_KEEP_ALIVE : min number of seconds since we last received a response
#;                    from the server before we send a keep-alive ping
#;  PING_WAIT_TIME  : number of milliseconds we wait for the response to
#;                    come back when we send a ping
#;  PING_LIMIT      : number of unanswered pings we send before we close the
#;                    connection.
 
#;  To disable the keep-alive logic, set any of the values (PING_KEEP_ALIVE,
#;  PING_LIMIT, or PING_WAIT_TIME) to zero.
#;
#;  The current default/min/max for these values are as follows :
 
#;  PING_KEEP_ALIVE :  120/5/maxInt  seconds (may also be zero)
#;  PING_WAIT_TIME  :  2000/10/60000 milliseconds (may also be zero)
#;  PING_LIMIT      :  4/0/maxInt
#;
 
#define LDAPOPTPINGKEEPALIVE      $zhex("36")
#define LDAPOPTPINGWAITTIME       $zhex("37")
#define LDAPOPTPINGLIMIT          $zhex("38")
 
#; Start of Windows only options
 
#; return DNS name of domain
#define LDAPOPTDNSDOMAINNAME      $zhex("3B")
#; flags for DsGetDcName
#define LDAPOPTGETDSNAMEFLAGS     $zhex("3D")  
 
#; prompt for creds? currently only for DPA & NTLM if no creds are loaded
#define LDAPOPTPROMPTCREDENTIALS  $zhex("3F")
#; Enable/disable autoreconnect
#define LDAPOPTAUTORECONNECT      $zhex("91")
#; flags to pass to InitSecurityContext
#define LDAPOPTSSPIFLAGS          $zhex("92")  
 
#;To retrieve information on an secure connection, a pointer to a
#;SecPkgContext_connectionInfo structure (defined in schannel.h) must be
#;passed in. On success, it is filled with relevent security information.
#define LDAPOPTSSLINFO            $zhex("93")
 
#;backward compatible #define for older constant name.
 
#define LDAPOPTTLS                LDAPOPTSSL
#define LDAPOPTTLSINFO            LDAPOPTSSLINFO
 
#; Turing on either the sign or the encrypt option prior to binding using
#; LDAP_AUTH_NEGOTIATE will result in the ensuing LDAP session to be signed
#; or encrypted using Kerberos. Note that these options can't be used with SSL.
#define LDAPOPTSIGN               $zhex("95")
#define LDAPOPTENCRYPT            $zhex("96")
 
#; The user can set a preferred SASL method prior to binding using LDAP_AUTH_NEGOTIATE
#; We will try to use this mechanism while binding. One example is "GSSAPI".
#define LDAPOPTSASLMETHOD         $zhex("97")
 
#; Setting this option to LDAP_OPT_ON will instruct the library to only perform an
#; A-Record DNS lookup on the supplied host string. This option is OFF by default.
#define LDAPOPTARECEXCLUSIVE      $zhex("98")
 
#; Retrieve the security context associated with the connection.
#define LDAPOPTSECURITYCONTEXT    $zhex("99")
 
#; Enable/Disable the built-in RootDSE cache. This option is ON by default.
#define LDAPOPTROOTDSECACHE       $zhex("9a")
 
#; Turns on TCP keep-alives.  This is separate from the ICMP ping keep-alive
#; mechanism (discussed above), and enables the keep-alive mechanism built into
#; the TCP protocol.  This has no effect when using connectionless (UDP) LDAP.
#; This option is OFF by default.
#define LDAPOPTTCPKEEPALIVE       $zhex("40")
 
#; Turns on support for fast concurrent binds (extended operation
#; 1.2.840.113556.1.4.1781).  This option can be set only on a fresh
#; (never bound/authenticated) connection.  Setting this option will
#; (1) switch the client into a mode where it supports simultaneous
#; simple binds on the connection, and (2) sends the extended operation
#; to the server to switch it into fast bind mode.  Only simple binds
#; are supported in this mode.
 
#define LDAPOPTFASTCONCURRENTBIND $zhex("41")
 
#define LDAPOPTSENDTIMEOUT        $zhex("42")
 
#;End of Microsoft only options
 
#; Flags to pass to ldap_set_option
#define LDAPOPTON                 1
#define LDAPOPTOFF                0
 
#;Valid Windows ldap_bind_s authentication methods. See winldap.h for more info
#define LDAPAUTHSIMPLE    $zhex("80")
#define LDAPAUTHOTHERKIND $zhex("86")
#define LDAPAUTHSICILY    ($$$LDAPAUTHOTHERKIND+$zhex("200"))
#define LDAPAUTHMSN       ($$$LDAPAUTHOTHERKIND+$zhex("800"))
#define LDAPAUTHNTLM      ($$$LDAPAUTHOTHERKIND+$zhex("1000"))
#define LDAPAUTHDPA       ($$$LDAPAUTHOTHERKIND+$zhex("2000"))
#define LDAPAUTHNEGOTIATE ($$$LDAPAUTHOTHERKIND+$zhex("400"))
#define LDAPAUTHDIGEST    ($$$LDAPAUTHOTHERKIND+$zhex("4000"))
#define LDAPAUTHEXTERNAL  ($$$LDAPAUTHOTHERKIND+$zhex("20"))
 
#;Scope levels for ldap_search
#define LDAPSCOPEBASE         $zhex("00")
#define LDAPSCOPEONELEVEL     $zhex("01")
#define LDAPSCOPESUBTREE      $zhex("02")
#;
 
 