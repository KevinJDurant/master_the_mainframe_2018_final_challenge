/* REXX */
Arg mbr
    if mbr = '' then
    Do
        Say 'Enter CH15.OUTPUT member name'
        parse pull mbr
    End
"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio * diskr rpt (stem rpt. finis)"
    do i=1 to rpt.0
        if pos('IEE254I',rpt.i) > '0' then say rpt.i
    end
"free fi(rpt)"
exit
