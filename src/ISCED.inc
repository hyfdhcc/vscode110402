ROUTINE ISCED [Type=INC]
;ISCED.INC  -- invoke replace/with editor on text
 
#ifndef ISCED
#define ISCED
 
ED(%L) ; Edit using the familiar old line editor.
 N %IED,%R,%W,%A,%B,%C,%D,%J X ^%("ED") W !?7,"--> "_%L Q %L
 
#endif ISCED