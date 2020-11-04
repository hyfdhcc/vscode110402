ROUTINE %occCompiler [Type=INC]
#;
#; macro definition for 'Raw' action
#;
#define defClassRaw(%class)                                                      ^oddDEF(%class)
#define defClassKeyRaw(%class,%ckey)                                             ^oddDEF(%class,%ckey)
#define defClassArrayRaw(%class,%ckey,%member)                                   ^oddDEF(%class,%ckey,%member)
#define defMemberRaw(%class,%ckey,%member)                                       ^oddDEF(%class,%ckey,%member)
#define defMemberKeyRaw(%class,%ckey,%member,%mkey)                              ^oddDEF(%class,%ckey,%member,%mkey)
#define defSubMemberRaw(%class,%ckey,%member,%mkey,%submember)                   ^oddDEF(%class,%ckey,%member,%mkey,%submember)
#define defSubMemberKeyRaw(%class,%ckey,%member,%mkey,%submember,%skey)          ^oddDEF(%class,%ckey,%member,%mkey,%submember,%skey)
#;
#define comClassRaw(%class)                                                      ^oddCOM(%class)
#define comClassKeyRaw(%class,%ckey)                                             ^oddCOM(%class,%ckey)
#define comClassArrayRaw(%class,%ckey,%member)                                   ^oddCOM(%class,%ckey,%member)
#define comMemberRaw(%class,%ckey,%member)                                       ^oddCOM(%class,%ckey,%member)
#define comMemberKeyRaw(%class,%ckey,%member,%mkey)                              ^oddCOM(%class,%ckey,%member,%mkey)
#define comSubMemberRaw(%class,%ckey,%member,%mkey,%submember)                   ^oddCOM(%class,%ckey,%member,%mkey,%submember)
#define comSubMemberKeyRaw(%class,%ckey,%member,%mkey,%submember,%skey)          ^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey)
#;
#define workClassRaw(%class)                                                     ^oddCOM(%class)
#define workClassKeyRaw(%class,%ckey)                                            ^oddCOM(%class,%ckey)
#define workClassArrayRaw(%class,%ckey,%member)                                  ^oddCOM(%class,%ckey,%member)
#define workMemberRaw(%class,%ckey,%member)                                      ^oddCOM(%class,%ckey,%member)
#define workMemberKeyRaw(%class,%ckey,%member,%mkey)                             ^oddCOM(%class,%ckey,%member,%mkey)
#define workSubMemberRaw(%class,%ckey,%member,%mkey,%submember)                  ^oddCOM(%class,%ckey,%member,%mkey,%submember)
#define workSubMemberKeyRaw(%class,%ckey,%member,%mkey,%submember,%skey)         ^oddCOM(%class,%ckey,%member,%mkey,%submember,%skey)
#;
#define editClassRaw(%class)                                                     ^||%occEditClass(%class)
#define editClassKeyRaw(%class,%ckey)                                            ^||%occEditClass(%class,%ckey)
#define editClassArrayRaw(%class,%ckey,%member)                                  ^||%occEditClass(%class,%ckey,%member)
#define editMemberRaw(%class,%ckey,%member)                                      ^||%occEditClass(%class,%ckey,%member)
#define editMemberKeyRaw(%class,%ckey,%member,%mkey)                             ^||%occEditClass(%class,%ckey,%member,%mkey)
#define editSubMemberRaw(%class,%ckey,%member,%mkey,%submember)                  ^||%occEditClass(%class,%ckey,%member,%mkey,%submember)
#define editSubMemberKeyRaw(%class,%ckey,%member,%mkey,%submember,%skey)         ^||%occEditClass(%class,%ckey,%member,%mkey,%submember,%skey)
#;
#define modifyClassRaw(%class)                                                   %classmodify(%class)
#define modifyClassKeyRaw(%class,%ckey)                                          %classmodify(%class,%ckey)
#define modifyClassArrayRaw(%class,%ckey,%member)                                %classmodify(%class,%ckey,%member)
#define modifyMemberRaw(%class,%ckey,%member)                                    %classmodify(%class,%ckey,%member)
#define modifyMemberKeyRaw(%class,%ckey,%member,%mkey)                           %classmodify(%class,%ckey,%member,%mkey)
#define modifySubMemberRaw(%class,%ckey,%member,%mkey,%submember)                %classmodify(%class,%ckey,%member,%mkey,%submember)
#define modifySubMemberKeyRaw(%class,%ckey,%member,%mkey,%submember,%skey)       %classmodify(%class,%ckey,%member,%mkey,%submember,%skey)
	