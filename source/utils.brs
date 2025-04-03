function getURLEncode(str as String) as String
    if str = invalid then return ""
    
    encStr = ""
    for i = 0 to Len(str) - 1
        c = Mid(str, i, 1)
        o = Asc(c)
        if (o >= 48 and o <= 57) or (o >= 65 and o <= 90) or (o >= 97 and o <= 122) then
            encStr = encStr + c
        else
            encStr = encStr + "%" + StrI(o, 16)
        end if
    end for
    
    return encStr
end function