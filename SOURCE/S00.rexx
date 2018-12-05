/* rexx */
Arg mbr
    if mbr = '' then
    Do
        Say 'Enter CH15.OUTPUT member name'
        parse pull mbr
    End
call report_header
call zos_level
call read_rpt
call net_info
call vm_info
exit 0
/*************************/
report_header:
zname    = mvsvar('sysname')
zlevel   = mvsvar('sysopsys')
zsms     = mvsvar('syssms')
rpt_time = time()
rpt_date = date()
clrscn
say ' '
say 'Report for System Name' zname
say '----------------------'
say  rpt_date rpt_time
say ' '
return
/*************************/
zos_level:
say 'z/OS Level'
say '------------'
say zlevel
return
/*************************/
read_rpt:
"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio * diskr rpt (stem rpt. finis)"
    do i=1 to rpt.0
        parse var rpt.i w1 w2 w3 w4 w5 w6 w7
        select
        when w1 = 'SYSTEM' & w2 = 'IPLED' then call zos_ipl
        when w1 = 'CPC' & w2 = 'ND' & w3 = '=' then call z_system
        otherwise iterate
        end
    end
"free fi(rpt)"
return
/*************************/
zos_ipl:
say ' '
say 'IPL Time - IPL Date'
say '--------   ----------'
say w4 ' ' w6
return
z_system:
say ' '
say 'Machine   Model   Serial'
say 'Type      Number  Number'
say '-------   ------  ------'
IBMZ = substr(w4,3,4)
IBMZ_model = substr(w4,8,3)
IBMZ_serial = substr(w4,26,5)
say IBMZ '     ' IBMZ_model '  ' IBMZ_serial
return
/*************************/
net_info:
n = outtrap("net",4)
netstat home
parse var net3 net3_word1 net3_word2 net3_word3
parse var net4 net4_word1 net4_word2 net4_word3
say ' '
say 'Network Information'
say '-------------------'
say 'Link Home IP Address'
say '---- ---------------'
say net3_word2 net4_word2
say ' '
return
/*************************/
vm_info:
v = outtrap("vm",1)
q cplevel
say 'Host VM Information'
say '-------------------'
v = outtrap("vm",1)
q cplevel
say vm1
say ' '
say ' z/VM     z/OS Virtual'
say ' Name     Machine Name'
say '-------   ------------'
v = outtrap("vm",1)
q userid
parse var vm1 vm_word1 vm_word2 vm_word3 vm_word4
say vm_word3 ' ' vm_word1
return
