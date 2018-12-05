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
        select
        when pos('IEE254I',rpt.i) > '0' then call iplinfo
        when pos('IEE174I',rpt.i) > '0' then call hardware
        when pos('IEE112I',rpt.i) > '0' then call operinfo
        otherwise iterate
        end
    end
"free fi(rpt)"
exit
iplinfo:
i = i + 1
parse var rpt.i w1 w2 w3 w4 w5 w6 w7
i = i + 1
parse var rpt.i w8 w9 w10 w11 w12 w13 w14
i = i + 1
parse var rpt.i w14 w15 w16 w17 w18 w19 w20
clrscn
say ' '
say 'The first system parameter data set name read during IPL is 'w17
say ' '
say w15 'is the 'w17' member name read during IPL'
say ' '
say w15 'includes information such as the system Master Catalog'
loadw1 = w17'('w15')'
"allocate dataset('"loadw1"') fi(iplparm) shr reuse"
"execio * diskr iplparm (stem parm. finis)"
    do p=i to parm.0
    parse var parm.p w21 w22 w23
    if w21 = 'SYSCAT' then
        do
        say ' '
        say 'Master Catalog name is ' substr(w22,11,15)
        say 'Master Catalog volume is ' substr(w22,1,6)
        say 'Master Catalog device address is ' substr(w22,7,4)
        say ' '
        end
    end
return
hardware:
    say 'Hardware information area'
    say ' '
return
operinfo:
    say 'Operation information area'
    say ' '
return
