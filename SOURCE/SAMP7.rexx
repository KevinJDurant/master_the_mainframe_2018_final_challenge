/* REXX */
Arg mbr
    if mbr = '' then
    Do
        Say 'Enter CH15.OUTPUT member name'
        parse pull mbr
    End
clrscn
say ' '
say 'Many system parameters are read at IPL time that control the'
say 'global behavior of the system.'
"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio * diskr rpt (stem rpt. finis)"
    do i=1 to rpt.0
        select
        when pos('IEE254I',rpt.i) > '0' then call parm_mbrs
        when pos('IEE251I',rpt.i) > '0' then call parm_ds
        otherwise iterate
        end
    end
"free fi(rpt)"
say ' '
say 'If you want to review the content of IEASYS## members,'
say 'then enter TSO SYSLIB'
say ' '
say 'Enter v in the Act (Action) column to the left of $PARMLIB.'
say ' '
say 'You are now viewing the 4 PARMLIB data sets where the lib'
say 'column indicates which parmlib data set has the member.'
exit
parm_mbrs:
i = i + 3
parse var rpt.i w1 w2 w3 w4 w5 w6
say ' '
say w4 'member name 'w2' is the first set of system parameters read'
say ' '
i = i + 3
parse var rpt.i w7 w8 w9 w10 w11 w12
ieasys_parm1 = substr(w10,2,2)
ieasys_parm2 = substr(w10,5,2)
ieasys_parm3 = substr(w10,8,2)
ieasys_parm4 = substr(w10,11,2)
say ' '
say w2 'includes 1 or more 2 digit values associated with IEASYS parm'
say ' '
say 'The contest system IEASYS parameter is ' w10
say ' '
say 'Therefore, the following partitioned data set members are read'
say 'in order to construct a single list of system parameters'
say '   IEASYS'ieasys_parm1
say '   IEASYS'ieasys_parm2
say '   IEASYS'ieasys_parm3
say '   IEASYS'ieasys_parm4
return
parm_ds:
i = i + 4
parse var rpt.i w1 w2 w3 w4 w5
i = i + 1
parse var rpt.i w6 w7 w8 w9 w10
i = i + 1
parse var rpt.i w11 w12 w13 w14 w15
i = i + 1
parse var rpt.i w16 w17 w18 w19 w20
say ' '
say 'The following partitioned data set names are searched to find each'
say 'IEASYS member to constuct the single list of system parameters'
say '   'w4
say '   'w9
say '   'w14
say '   'w19
return
