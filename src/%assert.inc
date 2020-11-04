ROUTINE %assert [Type=INC]
#ifdef  DEBUG
#define ASSERT(%condition)          ZT:'(%condition) "ASST"
#else
#define ASSERT(%condition)
#endif