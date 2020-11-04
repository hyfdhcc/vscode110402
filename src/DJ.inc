ROUTINE DJ [Type=INC]
DJ      ; Help text     ;
        W !,"Examples of valid dates:"
        W !,"JAN 16 1953",!,"1/16",!,"1/16/53",!,"1/16/1953"
        W !,"16 JAN 53",!,"T   (for today)"
        W !,"T+1   (for tomorrow)   ,T+2,T+3, etc."
        W !,"T-1   (for yesterday)   ,T-2, etc."
        W !,"If the year is omitted, the computer uses the current year.",! 
        Q