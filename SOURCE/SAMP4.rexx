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
    say rpt.i
return
hardware:
    say rpt.i
return
operinfo:
    say rpt.i
return
