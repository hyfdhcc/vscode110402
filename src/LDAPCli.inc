ROUTINE LDAPCli [Type=INC]
#if 0   /*=======================Maintenance========================*/
#;GK272   ;12/11/03 Garen Kotikian, Initial version
#endif
 
#; $ZBOOLEAN operators
#define booland				1
#define boolor				7
 
#; The Lib/DLL version
#; Version #1 Initial version.
#; Version #2 Unicode interface DLL
#define kLDAPLibVersion		2
 
#define LDAPSCOPEBASE      0
#define LDAPSCOPEONELEVEL  1
#define LDAPSCOPESUBTREE   2
 
#define LDAPLIBRARY            "isldapc"
#define RaiseLDAPException ZT "LDAP"
 
#; Use Value List object ID
#define LDAPUseVLObjID		4294967295
 
#; Objs > LDAPMaxValLen are store in big obj
#define LDAPMaxValLen		100
 
#; Prop list limit when starts conserving memory
#define LDAPStartConserving	10000
 
#; Big obj transfer len
#define LDAPBigObjTranLen	8000
 
 
#; blub of bytes 0x10
#define LDAPBinValMask		16
 
#; large value mask 0x40
#define LDAPLargeValMask	64
 
#; Multiple value mask 0x80
#; Multi value is used only by the propList.
#; See PropList for usage.
#define LDAPMultiValMask	128
 
#; No value associated with entry
#define LDAPNoVal			1
 
#; Binary and or string value
#define LDAPStrVal			0
#define LDAPBinVal			16
 
#; large binary value 0x50 = LDAPBinVal + LDAPLargeValMask
#define LDAPLargeBinVal		80
 
#; large string value 0x60 = LDAPStrVal + LDAPLargeValMask
#define LDAPLargeStrVal		64
 
 
#; kEdit* functions are used to change/edit an entry attribute
#define kEditAdd			0
#define kEditReplace		1
#define kEditRemove			2
 
#define FNRelEntry			..Parent.FNRelEntry
#define FNNextEntry			..Parent.FNNextEntry
#define FNFirstEntry		..Parent.FNFirstEntry
#define FNGetEntryDN		..Parent.FNGetEntryDN
#define FNGetEntryAttr		..Parent.FNGetEntryAttr
#define FNRelAttrib			..Parent.FNRelAttrib
#define FNAttribName		..Parent.FNAttribName
#define FNAttribValue		..Parent.FNAttribValue
#define FNFirstAttrib		..Parent.FNFirstAttrib
#define FNNextAttrib		..Parent.FNNextAttrib
#define FNRelBigObj			..Parent.FNRelBigObj
#define FNAddRefBigObj		..Parent.FNAddRefBigObj
#define FNNewBigObj			..Parent.FNNewBigObj
#define FNGetSubObj			..Parent.FNGetSubObj
#define FNAppendObj			..Parent.FNAppendObj
#define FNCommitChanges		..Parent.FNCommitChanges
 
#define LDAPLibID			..Parent.SharedLibID
#define LDAPSessionID		..Parent.SessionID
 
#; return last error from the session.
#define LDAPLastError		..Parent.GetLastError()
 
#; Unexpected error, or an unexpected obj, or uninitialized obj
#define LDAPRaiseException			ZT "LDAP"
 
#; Convert platform LDAP lib DN format to native string
#define ConvertPlatDN(%x)			(..Parent.ConvertFromPlatStr(%x))
#; Convert DN to platform LDAP lib format to native string
#define ConvertDNPlat(%x)			(..Parent.ConvertToPlatStr(%x))
 
 #; Convert platform attribute name to native string
#define ConvertPlatAttrib(%x)		(..Parent.ConvertFromPlatStr(%x))
 #; Convert native attribute name to platform
#define ConvertAttribPlat(%x)		(..Parent.ConvertToPlatStr(%x))
 
 #; Convert platform string to native string. Note platform string has a nil terminator.
#define ConvertPlatValStr(%x)		(..Parent.ConvertFromPlatStr(%x))
 #; Convert native string to platform string. Note platform string has a nil terminator.
#define ConvertValStrPlatNoTerm(%x)	(..Parent.ConvertToPlatStr(%x,0))
#define ConvertValStrPlat(%x)		(..Parent.ConvertToPlatStr(%x))
 
 #; Convert to platform username or passwd.
#define ConvertUserNamePlat(%x)		(..Parent.ConvertToPlatStr(%x))
 
 #; Convert filter to platform.
#define ConvertFilterPlat(%x)		(..Parent.ConvertToPlatStr(%x))