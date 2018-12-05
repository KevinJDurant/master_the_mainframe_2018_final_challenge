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
        parse var rpt.i w1 w2 w3 w4 w5 w6 w7 w8 w9 w10
        say w1 w2 w3
    end
"free fi(rpt)"
exit
