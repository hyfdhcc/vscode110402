ROUTINE %apiCBIND [Type=INC]
#define IsUnicode $zbitget($zversion(0),1)
#define ClientEncoding $$GetCharset^%SYS.NLS()
 
 /* D_type constants */
 
#define cbindVoid                                                 -1
#define cbindObjId                                                0
#define cbindIntId                                                1
#define cbindDoubleId                                             2
#define cbindBinaryId                                             3
#define cbindStringId                                             4
#define cbindStatusId                                             5
#define cbindTimeId                                               6
#define cbindDateId                                               7
#define cbindTimestampId                                          8
#define cbindBoolId                                               9
#define cbindCurrencyId                                           10
#define cbindListId                                               11
#define cbindDecimalId                                            15
#define cbindMVDateId                                             16
 
 /* interface for errors */
 
#define cbindSetZFMode                                             1
#define cbindGetLastErrCode                                        2
#define cbindGetLastErrMsg                                         3
 
 /* interface for d_connection */
 
#define cbindAllocConn                                             4
#define cbindFreeConn                                              5
 
 /* interface for Database */
 
#define cbindAllocDb                                               6
#define cbindFreeDb                                                7
#define cbindResetArgs                                             8
#define cbindSetNextArg                                            9
#define cbindGetArg                                                10
 
#define cbindRunClassMethod                                        11
#define cbindRunObjMethod                                          12
#define cbindGetProperty                                           13
#define cbindSetProperty                                           14
 
#define cbindCreateNew                                             15
#define cbindOpen                                                  16
#define cbindOpenId                                                17
#define cbindCloseObj                                              18
 
 /* interface for d_query */
 
#define cbindAllocQuery                                            19
#define cbindFreeQuery                                             20
#define cbindPrepareGenQuery                                       21
#define cbindPrepareClassQuery                                     22
#define cbindQueryExecute                                          23
#define cbindQueryFetch                                            24
#define cbindQueryGetDataStr                                       25
 
#define cbindQueryGetNumCols                                       26
#define cbindQueryGetColSQLType                                    27
#define cbindQueryGetColName                                       28
#define cbindQueryGetColPrecision                                  39
#define cbindQueryGetColScale                                      40
#define cbindQueryGetDisplaySize                                   41
#define cbindQueryGetColIsMoney                                    42
#define cbindQueryGetColIsNullable                                 43
 
#define cbindQueryGetNumPars                                       29
#define cbindQueryGetParSQLType                                    30
#define cbindQueryGetParColSize                                    31
#define cbindQueryGetParNumDecDigits                               32
#define cbindQueryIsParNullable                                    33
#define cbindQueryIsParUnbound                                     34
#define cbindQuerySetPar                                           35
#define cbindQuerySetUniPar                                        44
 
 /* miscellaneous */
 
#define cbindGenCppProxy                                           36
#define cbindSetUniClient                                          37
#define cbindSetClientEncoding                                     38