ROUTINE %syLDAPFunc [Type=INC]
 ;%syLDAPFunc
#if 0   /*=======================Maintenance========================*/
#;STC2739  3/02/18 Steve Clay, LDAP authentication updates
#;STC2501  3/02/16 Steve Clay, Correctly copy LDAP timeout to return buffers
#;STC2190 03/08/13 Steve Clay, Support LDAP paged results on Windows platforms for any LDAP server
#;STC1951 05/09/11 Steve Clay, Add trailing $c(0) to LDAP certificate name
#;STC1892 01/18/11 Steve Clay, Return correctly formatted LDAP error string
#;STC1525 01/12/09 Steve Clay, Update LDAP examples and documentation 
#;STC1522 01/07/09 Steve Clay, Support big strings and fix memory leak in ldap DLL 
#;STC1244 07/13/07 Steve Clay, Return "" when LDAP attribute does not exist
#;STC1233 06/15/07 Steve Clay, Add GetValues() call
#;STC1155 01/25/07 Steve Clay, Add GetOption call
#;STC983 05/01/06 Steve Clay, LDAP SSL authentication
#endif  /*=======================Maintenance========================*/
#include %syLDAP
#include %systemInclude

#define USELDAPCLI $D(^%SYS("USELDAPCLI"))

#define LDAPConvertFormat $s($zv["Windows":"UnicodeLittle",1:"UTF8")
#define ConvertToPlatformString(%string) $s(%string'="":$zconvert(%string_$c(0),"o",$$$LDAPConvertFormat),1:"")
 
 goto %LDAPStartFunc999
ConvertFromPlatformString(String) Private {q $s($zv'["Windows":$s(($l(String)>1):$zconvert($e(String,1,$l(String)-1),"i","UTF8"),1:""),1:$s(($l(String)>2):$zconvert($e(String,1,$l(String)-2),"i","UnicodeLittle"),1:""))}
ConvertToPlatformList(List) Private { s NewList="" f i=1:1:$ll(List) {s $li(NewList,i)=$$$ConvertToPlatformString($li(List,i))} q NewList}
ConvertToPlatformListCred(List) Private { s NewList="" f i=1:1:$ll(List) {s $li(NewList,i)=$$$ConvertToPlatformString($li(List,i))} /* STC2739+ */ i $e($li(NewList,i))=$c(0) { i $$PasswordError() } /* STC2739- */ q NewList}
ConvertFromPlatformList(List) Private { f i=1:1:$ll(List) {s $li(NewList,i)=$$ConvertFromPlatformString($li(List,i))} q $g(NewList)}
#;Convert a list passed in for ldap_modify or ldap_add in the following format:
#;$lb($lb(mod_op,mod_type,$lb(value1,value1)))
ConvertToPlatformMultiList(List) Private { s NewList="" f i=1:1:$ll(List) { s String=$li(List,i) /* s $li(String,1)=$$$ConvertToPlatformString($li(String,1)) */ s $li(String,2)=$$$ConvertToPlatformString($li(String,2)) s $li(String,3)=$$ConvertToPlatformList($li(String,3)) s $li(NewList,i)=String} q NewList}
%LDAPStartFunc999 
 
#define LDAPLibraryName $g(^%SYS("bindir"))_"ldap"_$s($zv["Windows":".dll",$zv["UNIX":".so",$zv["VMS":".exe",1:".dll") 
#define LDAPLibraryID $zf(-4,1,$$$LDAPLibraryName)
 
#define LDAPAddExtsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_add_ext_s")
#define LDAPBindsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_bind_s")
#define LDAPCheckFilterFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_check_filter")
#define LDAPCompareExtsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_compare_ext_s")
#define LDAPConnectFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_connect")
#define LDAPCountEntriesFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_count_entries")
#define LDAPDeleteExtsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_delete_ext_s")
#define LDAPErr2StringFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_err2string")
#define LDAPFirstAttributeFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_first_attribute")
#define LDAPFirstEntryFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_first_entry")
#define LDAPInitFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_init")
#define LDAPInitializeFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_initialize")
#define LDAPGetDNFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_dn")
#define LDAPGetErrorFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_error")
#define LDAPGetLastErrorFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_last_error")
#define LDAPGetOptionFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_option")
#define LDAPGetValuesFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_values")
#define LDAPGetNextPagesFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_next_page_s")
#define LDAPGetValuesLenFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_get_values_len")
#define LDAPModifyExtsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_modify_ext_s")
#define LDAPMsgFreeFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_msgfree")
#define LDAPNextEntryFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_next_entry")
#define LDAPNextAttributeFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_next_attribute")
#define LDAPRenameExtsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_rename_ext_s")
#define LDAPSASLBindsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_sasl_bind_s")
#define LDAPSearchAbandonPageFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_search_abandon_page")
#define LDAPSearchExtsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_search_ext_s")
#define LDAPSearchInitPageFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_search_init_page")
#define LDAPSetOptionFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_set_option")
#define LDAPSimpleBindsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_simple_bind_s")
#define LDAPStartTLSsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_start_tls_s")
#define LDAPStopTLSsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_stop_tls_s")
#define LDAPUnbindsFunction $ZF(-4,3,$$$LDAPLibraryID,"ldap_unbind_s")
 
#define ldapaddexts(%ld,%dn,%attrs,%ServerControls,%ClientControls)  $$LDAPAddExtS(%ld,%dn,%attrs)
#define ldapbinds(%ld,%dn,%cred,%method)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPBindsFunction, %ld, $$$ConvertToPlatformString(%dn),$$ConvertToPlatformListCred(%cred), +%method)
#define ldapcheckfilter(%ld,%SearchFilter)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPCheckFilterFunction, %ld, $$$ConvertToPlatformString(%SearchFilter))
#define ldapconnect(%ld,%timeout)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPConnectFunction, %ld, +%timeout)
#define ldapcountentries(%ld,%res)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPCountEntriesFunction, %ld, %res)
#define ldapcountvalues(%vals)  $ll(%vals)
#define ldapcountvalueslen(%vals)  $ll(%vals)
#define ldapcompareexts(%ld,%dn,%Attr,%Data,%ServerControls,%ClientControls)  $$LDAPCompareExtS(%ld,%dn,%Attr,%Data)
#define ldapdeleteexts(%ld,%dn,%ServerControls,%ClientControls)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPDeleteExtsFunction, %ld, $$$ConvertToPlatformString(%dn), /*%ServerControls*/"", /*%ClientControls*/"")
#define ldaperr2string(%err)  $s(%err<$$$ISCFIRSTLDAPMESSAGE:$$ConvertFromPlatformString($ZF(-5, $$$LDAPLibraryID, $$$LDAPErr2StringFunction,%err)),1:$$$GetMsg($$$LDAPMsg,""_%err))
#define ldapfirstattribute(%ld,%entry,%ptr)  $$ConvertFromPlatformString($$LDAPFirstAttribute(%ld, %entry, %ptr))
#define ldapfirstentry(%ld,%res)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPFirstEntryFunction, %ld, %res)
#define ldapgetdn(%ld,%entry)  $$ConvertFromPlatformString($ZF(-5, $$$LDAPLibraryID, $$$LDAPGetDNFunction, %ld, %entry))
#define ldapgeterror(%ld)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPGetErrorFunction, %ld)
#define ldapgetlasterror()  $ZF(-5, $$$LDAPLibraryID, $$$LDAPGetLastErrorFunction)
#define ldapgetnextpages(%ld,%search,%timeout,%pagesize,%totalcount,%res)  $$LDAPGetNextPageS(%ld, %search, %timeout, %pagesize, %totalcount, %res)
#define ldapgetoption(%ld,%option,%outvalue)  $$LDAPGetOption(%ld, +%option, %outvalue)
#define ldapgetvalues(%ld,%entry,%attr)  $$ConvertFromPlatformList($ZF(-5, $$$LDAPLibraryID, $$$LDAPGetValuesFunction, %ld, %entry, $$$ConvertToPlatformString(%attr)))
#define ldapgetvalueslen(%ld,%entry,%attr)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPGetValuesLenFunction, %ld, %entry, $$$ConvertToPlatformString(%attr))
#define ldapinit(%HostName,%PortNumber)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPInitFunction, $$$ConvertToPlatformString(%HostName), +%PortNumber)
#define ldapinitialize(%ld,%url)  $$LDAPInitialize(%ld, $$$ConvertToPlatformString(%url))
#define ldapmodifyexts(%ld,%dn,%attrs,%ServerControls,%ClientControls)  $$LDAPModifyExtS(%ld,%dn,%attrs)
#define ldapmsgfree(%res)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPMsgFreeFunction, %res)
#define ldapnextentry(%ld,%res)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPNextEntryFunction, %ld, %res)
#define ldapnextattribute(%ld,%entry,%ptr)  $$ConvertFromPlatformString($$LDAPNextAttribute(%ld,%entry,%ptr))
#define ldaprenameexts(%ld,%dn,%NewRDN,%NewParent,%DeleteOldRdn,%ServerControls,%ClientControls)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPRenameExtsFunction, %ld, $$$ConvertToPlatformString(%dn), $$$ConvertToPlatformString(%NewRDN), $$$ConvertToPlatformString(%NewParent), %DeleteOldRdn, /*%ServerControls*/"",/*%ClientControls*/"")
#define ldapsaslbinds(%ld,%dn,%Mechanism,%ClientCredentials,%ServerControls,%ClientControls,%ServerCredentials)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPSASLBindsFunction, %ld, $$$ConvertToPlatformString(%dn),$$$ConvertToPlatformString(%Mechanism),$$ConvertToPlatformList(%ClientCredentials), /*%ServerControls*/"",/*%ClientControls*/"",$$ConvertToPlatformList(%ServerCredentials))
#define ldapsetoption(%ld,%option,%invalue)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPSetOptionFunction, %ld, +%option, $$$ConvertToPlatformString(%invalue))
#define ldapsearchabandonpage(%ld,%page)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPSearchAbandonPageFunction, %ld,%page)
#define ldapsearchexts(%ld,%base,%scope,%filter,%attrs,%attrsonly,%ServerControls,%ClientControls,%timeout,%SizeLimit,%res)  $$LDAPSearchExtS(%ld, $$$ConvertToPlatformString(%base), %scope, $$$ConvertToPlatformString(%filter), $$ConvertToPlatformList(%attrs), %attrsonly, /*%ServerControls*/"",/*%ClientControls*/"", %timeout, %SizeLimit, %res)
#define ldapsearchinitpage(%ld,%base,%scope,%filter,%attrs,%attrsonly,%ServerControls,%ClientControls,%timeout,%SizeLimit,%SortKey)  $$LDAPSearchInitPage(%ld, $$$ConvertToPlatformString(%base), %scope, $$$ConvertToPlatformString(%filter), $$ConvertToPlatformList(%attrs), %attrsonly, /*%ServerControls*/"",/*%ClientControls*/"", %timeout, %SizeLimit, /*%SortKey */"")
#define ldapsimplebinds(%ld,%dn,%passwd)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPSimpleBindsFunction, %ld, $$$ConvertToPlatformString(%dn), /* STC2739+ */ $s($e(%passwd)'=$c(0):$$$ConvertToPlatformString(%passwd),1:$$PasswordError()) /* STC2739- */ )
#def1arg ldapstarttlss(%Args)  $$LDAPStartTLSS(%Args)
#define ldapstoptlss(%ld)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPStopTLSsFunction, %ld)
#define ldapunbinds(%ld)  $ZF(-5, $$$LDAPLibraryID, $$$LDAPUnbindsFunction, %ld)
 goto %LDAPENDFUNC9999 
PasswordError() ztrap "PASSWORD"
LDAPFirstAttribute(ld,entry,ptr) Private { s res=$ZF(-5, $$$LDAPLibraryID, $$$LDAPFirstAttributeFunction, ld,entry, 0) s ptr=$zla(res) q $e(res,5,$l(res))}
LDAPGetOption(ld,option,outvalue) Private { s outvalue=$ZF(-5, $$$LDAPLibraryID, $$$LDAPGetOptionFunction,ld,option,$g(outvalue)) q $$$ldapgeterror(ld)}
LDAPGetNextPageS(ld,search,timeout,pagesize,totalcount,results) Private { s totalcount=$ZF(-5, $$$LDAPLibraryID, $$$LDAPGetNextPagesFunction,ld,search,timeout,pagesize,+$g(totalcount),+$g(results)) s results=search q $$$ldapgeterror(ld)}
LDAPInitialize(ld,url) Private { s res=$ZF(-5, $$$LDAPLibraryID, $$$LDAPInitializeFunction,$g(ld),url) s ld=res q $$$ldapgeterror(ld)}
LDAPNextAttribute(ld,entry,ptr) Private { s res=$ZF(-5, $$$LDAPLibraryID, $$$LDAPNextAttributeFunction, ld,entry, $g(ptr)) s ptr=$zla(res) q $e(res,5,$l(res))}
LDAPSearchExtS(ld,base,scope,filter,attrs,attrsonly,ServerControls,ClientControls,timeout,SizeLimit,res) Private { s res=$ZF(-5, $$$LDAPLibraryID, $$$LDAPSearchExtsFunction,ld,base,scope,filter,attrs,attrsonly,/*ServerControls*/"",/*ClientControls*/"",timeout,SizeLimit,$g(res)) q $$$ldapgeterror(ld)}
LDAPSearchInitPage(ld,base,scope,filter,attrs,attrsonly,ServerControls,ClientControls,timeout,SizeLimit,SortKey) Private { q $ZF(-5, $$$LDAPLibraryID, $$$LDAPSearchInitPageFunction,ld,base,scope,filter,attrs,attrsonly,/*ServerControls*/"",/*ClientControls*/"",timeout,SizeLimit,/*SortKey*/"")}
LDAPStartTLSS(Args...) Private { q:Args=5 $ZF(-5, $$$LDAPLibraryID, $$$LDAPStartTLSsFunction,+Args(1),/* ServerReturnValue */"",/* Result */"",/*ServerControls*/"",/*ClientControls*/"")  q $ZF(-5, $$$LDAPLibraryID, $$$LDAPStartTLSsFunction,+Args(1),/*ServerControls*/"",/*ClientControls*/"")}
#define LDAPAddExtSCompat(%ld, %dn, %name, %value, %type) $ZF(-5, $$$LDAPLibraryID, $$$LDAPAddExtsFunction, %ld, $$$ConvertToPlatformString(%dn), %name, %value, %type)
LDAPAddExtS(ld,dn,attr) Private { s x=$$DecodeAttr(attr,.name,.value,.type) q $$$LDAPAddExtSCompat(ld, dn, name, value, type)}
#define LDAPCompareExtSCompat(%ld, %dn, %attr, %data, %binary) $ZF(-5, $$$LDAPLibraryID, $$$LDAPCompareExtsFunction, %ld, $$$ConvertToPlatformString(%dn), $$$ConvertToPlatformString(%attr), $s(%binary=0:$$$ConvertToPlatformString(%data),1:$li(%data)), %binary)
LDAPCompareExtS(ld,dn,attr,data) Private { s binary=$listvalid(data) q $$$LDAPCompareExtSCompat(ld, dn, attr, data, binary) }
#define LDAPModifyExtSCompat(%ld, %dn, %name, %value, %type, %func) $ZF(-5, $$$LDAPLibraryID, $$$LDAPModifyExtsFunction, %ld, $$$ConvertToPlatformString(%dn), %name, %value, %type, %func)
LDAPModifyExtS(ld,dn,attr) Private { s x=$$DecodeAttr(attr,.name,.value,.type,.func) q $$$LDAPModifyExtSCompat(ld, dn, name, value, type, func) }
DecodeAttr(Attributes,NameList,ValueList,TypeList,FuncList) Public {
	s $zt="Error"
	k NameList
	k ValueList
	k TypeList
	k FuncList
	s Status=$$$OK
	Try {
		s NumAttributes=$ll(Attributes)
	} catch {
		s Status=$$$ERROR($$$GeneralError,"Attribute must be a list")
	}
	i '$$$ISOK(Status) q Status
	s NameList=""
	s ValueList=""
	s TypeList=""
	s FuncList=""
	f i=1:1:NumAttributes {
		s Attribute=$li(Attributes,i)
		Try {
			s Name=$li(Attribute,2)
			i $ll(Attribute)=3 {
				s Type=$li(Attribute,1)
				s Values=$li(Attribute,3)
			} else {
				s Status=$$$ERROR($$$GeneralError,"Attribute "_Name_" must be a 3 piece list")
			}
		} Catch {
			s Status=$$$ERROR($$$GeneralError,"Attribute "_$g(Name,i)_" must be a list")
		}
		i '$$$ISOK(Status) q
		Try {
			s NumValues=$ll(Values)
		} Catch {
			s Status=$$$ERROR($$$GeneralError,"Value of "_Name_" must be a list")
		}
		i '$$$ISOK(Status) q
		s NameList=NameList_$lb($$$ConvertToPlatformString(Name))
#;LDAP_MOD_BVALUES
		i $zb(Type,128,1) {
			s IsBinary=1
			s Type=Type-128
		} else {
			s IsBinary=0
		}
#; The DLL has the types mixed up. We don't want to mess up compatibility, so
#; we switch the types for replace and delete here.
		i Type=1 {
			s Type=2
		} else {
			i Type=2 s Type=1
		}
		i (Type>2)||(Type<0) {
			s Status=$$$ERROR($$$GeneralError,"Function value for "_Name_" must be 0, 1, or 2") 
			q
		}
		s FuncList=FuncList_$c(Type)
#;128 is multivalue
#;16 is Binary
		i NumValues>1 {
#;128 is multi value
			i IsBinary {
				s TypeEntry=128+16
			} else {
				s TypeEntry=128
			}
			s TypeList=TypeList_$c(TypeEntry)
			s Types=""
			f j=1:1:NumValues {
#;For Binary, we do not convert the string we are passing in.
#;16 is for Binary
				i IsBinary {
					s Types=Types_$c(16)
				} else {
					s Types=Types_$c(0)
				}
			}
			i 'IsBinary	s Values=$$ConvertToPlatformList(Values)
#;4 byte length, 2 byte type, and extra 2 bytes (formerly a 4 byte big obj ptr)
			s ValueList=ValueList_$lb($zlc($l(Values))_$zwc($l(Types))_$zwc("")_Values_Types)
		} else {
			s TypeEntry=0
			s Values=$li(Values)
			i (Type'=0),(Values="") {
#;We are calling a delete operation, with a null string to remove the entry
				s TypeEntry=1
				s ValueList=ValueList_$lb(Values)
			} else {
#;For Binary, we do not convert the string we are passing in.
#;16 is for Binary
				i IsBinary {
					s TypeEntry=TypeEntry+16
					s ValueList=ValueList_$lb(Values)
				} else {
					s ValueList=ValueList_$lb($$$ConvertToPlatformString(Values))
				}
			}
			s TypeList=TypeList_$c(TypeEntry)
		}
	}
	q Status
Error s $zt=""
 q $$$ERROR($$$CacheError,$ze)
 }
%LDAPENDFUNC9999 
 