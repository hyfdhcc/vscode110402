ROUTINE %sqlx [Type=INC]
#Define sqlxFuncBase 1073741824
#Define sqlxFuncHandle(%funcId) ##Expression($$$sqlxFuncBase + %funcId)
#Define sqlxFunc0(%funcId) $ZU($$$sqlxFuncHandle(%funcId))
#Define sqlxFunc1(%funcId, %arg0) $ZU($$$sqlxFuncHandle(%funcId), %arg0)
#Define sqlxFunc2(%funcId, %arg0, %arg1) $ZU($$$sqlxFuncHandle(%funcId), %arg0, %arg1)

#Include %sqlxFuncIds

/// Is a value potentially an encoded POSIX logical timestamp?
#Define sqlxPosixTimeIsValid(%posixTime) ($zboolean(1152921504606846976, %posixTime, 1)>0)
/// Encode a time value (in seconds since the Unix Epoch) as a POSIX logical timestamp
#Define sqlxPosixTimeEncode(%time) $$$sqlxFunc1($$$sqlxFuncPosixTimeEncode, %time)
/// Decode a POSIX logical timestamp into a time value (in seconds since the Unix Epoch)
#Define sqlxPosixTimeDecode(%posixTime) $$$sqlxFunc1($$$sqlxFuncPosixTimeDecode, %posixTime)

/// Create a hash set with n initial buckets
#Define sqlxHashSetCreate(%initialBuckets) $$$sqlxFunc1($$$sqlxFuncHashSetCreate, %initialBuckets)
/// Destroy the given hash set
#Define sqlxHashSetDestroy(%set) $$$sqlxFunc1($$$sqlxFuncHashSetDestroy, %set)
/// Insert a value into the hash set if absent, returning 1 if it was already present.
#Define sqlxHashSetInsert(%set, %val) $$$sqlxFunc2($$$sqlxFuncHashSetInsert, %set, %val)

/// Return an integer with bits set indicating available sqlx features in this kernel
#Define sqlxFeaturesAvailable $$$sqlxFunc0($$$sqlxFuncFeaturesAvailable)
