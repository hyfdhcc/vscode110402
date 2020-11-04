ROUTINE %occActivate [Type=INC]
 #include %occInclude
 #include %callout
 #;
 #; Location of the Activate DLL
 #define DLL                             ^%SYS("bindir")_"Activate.dll"
 #define ORDINAL                         -6
 #define HANDLE                          $$$ActivateLibrary
 #define UNLOAD                          4
 #define NameSpace                       "Activate"
 #;
 #; Useful Macros
 #define ActXError(%p)                   $$$ERROR($$$ComException,$LG(%p,1)_" "_$LG(%p,2)_" "_$LG(%p,3))
 #define ActXRaise(%p)                   Set sc=$$$ActXError(%p) ZT "ACTX"
 #;
 #; Activate DLL entry point ordinals
 #;
 #define ActXCreateObject                1
 #define ActXGetIdsOfNames               2
 #define ActXInvoke                      3
 #define ActXReadTypeLibrary             4
 #define ActXReleaseObject               5
 #define ActXGetObject                   6
 #define ActXQueryInterface              7
 #define ActXCreateObjectFromProgid      8
 #define ActXAdvise                      9
 #define ActXUnAdvise                    10
 #define ActXInvokeGeneric               11
 #define ActXGetRefCount                 12
 #define ActXGetStream                   13
 #define ActXInvokeGenericStream         14
 #define ActXEnumClone					 15
 #define ActXEnumNext                    16
 #define ActXEnumReset				     17
 #define ActXEnumSkip                    18
 #define ActXEnableExceptionHandler      19
 
 #;
 #; TKIND
 #define TKINDENUM                       0
 #define TKINDRECORD                     1
 #define TKINDMODULE                     2
 #define TKINDINTERFACE                  3
 #define TKINDDISPATCH                   4
 #define TKINDCOCLASS                    5
 #define TKINDALIAS                      6
 #define TKINDUNION                      7
 #define TKINDMAX                        8
 #define TKINDREFERENCEDTYPES			 9
 #;
 #; INVOKE_KIND
 #; 
 #define INVOKEFUNC                      1
 #define INVOKEPROPERTYGET               2
 #define INVOKEPROPERTYPUT               4
 #define INVOKEPROPERTYPUTREF            8
 #;
 #; PARAMETER_FLAGS
 #define PARAMFLAGNONE                   0
 #define PARAMFLAGFIN                    1
 #define PARAMFLAGFOUT                   2
 #define PARAMFLAGFLCID                  4
 #define PARAMFLAGFRETVAL                8
 #define PARAMFLAGFOPT                   16
 #define PARAMFLAGFHASDEFAULT            32
 #define PARAMFLAGFHASCUSTDATA           64
 #;
 #; VARIANT_TYPE
 #define VTEMPTY                         0
 #define VTNULL                          1
 #define VTI2                            2
 #define VTI4                            3
 #define VTR4                            4
 #define VTR8                            5
 #define VTCY                            6
 #define VTDATE                          7
 #define VTBSTR                          8
 #define VTDISPATCH                      9
 #define VTERROR                         10
 #define VTBOOL                          11
 #define VTVARIANT                       12
 #define VTUNKNOWN                       13
 #define VTDECIMAL                       14
 #define VTI1                            16
 #define VTUI1                           17
 #define VTUI2                           18
 #define VTUI4                           19
 #define VTI8                            20
 #define VTUI8                           21
 #define VTINT                           22
 #define VTUINT                          23
 #define VTVOID                          24
 #define VTHRESULT                       25
 #define VTPTR                           26
 #define VTSAFEARRAY                     27
 #define VTCARRAY                        28
 #define VTUSERDEFINED                   29
 #define VTLPSTR                         30
 #define VTLPWSTR                        31
 #define VTRECORD                        36
 #define VTFILETIME                      64
 #define VTBLOB                          65
 #define VTSTREAM                        66
 #define VTSTORAGE                       67
 #define VTSTREAMEDOBJECT                68
 #define VTSTOREDOBJECT                  69
 #define VTBLOBOBJECT                    70
 #define VTCF                            71
 #define VTCLSID                         72
 #define VTUNSUPPORTED					 99
 #define VTBSTRBLOB                      4095
 #define VTVECTOR                        4096
 #define VTARRAY                         8192
 #define VTBYREF                         16384
 #define VTRESERVED                      32768
 #define VTILLEGAL                       65535
 #define VTILLEGALMASKED                 4095
 #define VTTYPEMASK                      4095
 #;
 #; DISPID
 #define DISPIDVALUE                     0
 #define DISPIDUNKNOWN                  -1
 #define DISPIDPROPERTYPUT              -3
 #define DISPIDNEWENUM                  -4
 #define DISPIDEVALUATE                 -5
 #define DISPIDCONSTRUCTOR              -6
 #define DISPIDDESTRUCTOR               -7
 #define DISPIDCOLLECT                  -8
 #;
 #define DISPATCHMETHOD                  1
 #define DISPATCHPROPERTYGET             2
 #define DISPATCHPROPERTYPUT             4
 #define DISPATCHPROPERTYPUTREF          8
 #;
 #; TYPEFLAG
 #define TYPEFLAGFAPPOBJECT				 1
 #define TYPEFLAGFCANCREATE				 2
 #define TYPEFLAGFLICENSED				 4
 #define TYPEFLAGFPREDECLID				 8
 #define TYPEFLAGFHIDDEN				 16
 #define TYPEFLAGFCONTROL				 32
 #define TYPEFLAGFDUAL					 64
 #define TYPEFLAGFNONEXTENSIBLE			 128
 #define TYPEFLAGFOLEAUTOMATION			 256
 #define TYPEFLAGFRESTRICTED			 512
 #define TYPEFLAGFAGGREGATABLE			 1024
 #define TYPEFLAGFREPLACEABLE			 2048
 #define TYPEFLAGFDISPATCHABLE			 4096
 #define TYPEFLAGFREVERSEBIND			 8192
 #define TYPEFLAGFPROXY					 16384