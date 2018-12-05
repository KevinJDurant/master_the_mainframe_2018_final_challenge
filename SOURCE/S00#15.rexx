/* rexx */
Arg mbr
    if mbr = '' then
    Do
        Say 'Enter CH15.OUTPUT member name'
        parse pull mbr
    End
call open_output
call report_header
call zos_level
call read_rpt
call net_info
call vm_info
call write_output
exit 0
/*************************/
open_output:
"allocate dataset(p3.output(#15)) fi(#15) shr reuse"
"execio 0 diskw #15 (stem o. open)"
return
/*************************/
report_header:
zname    = mvsvar('sysname')
zlevel   = mvsvar('sysopsys')
zsms     = mvsvar('syssms')
rpt_time = time()
rpt_date = date()
clrscn
o.1 = ' '
o.2 = 'Report for System Name' zname
o.3 = '----------------------'
o.4 = rpt_date rpt_time
o.5 = ' '
return
/*************************/
zos_level:
o.6 = 'z/OS Level'
o.7 = '------------'
o.8 = zlevel
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
o.9 = ' '
o.10 = 'IPL Time - IPL Date'
o.11 = '--------   ----------'
o.12 = w4 ' ' w6
return
/*************************/
z_system:
o.13 = ' '
o.14 = 'Machine   Model   Serial'
o.15 = 'Type      Number  Number'
o.16 = '-------   ------  ------'
IBMZ = substr(w4,3,4)
IBMZ_model = substr(w4,8,3)
IBMZ_serial = substr(w4,26,5)
o.17 = IBMZ '     ' IBMZ_model '  ' IBMZ_serial
return
/*************************/
net_info:
n = outtrap("net",4)
netstat home
parse var net3 net3_word1 net3_word2 net3_word3
parse var net4 net4_word1 net4_word2 net4_word3
o.18 = ' '
o.19 = 'Network Information'
o.20 = '-------------------'
o.21 = 'Link Home IP Address'
o.22 = '---- ---------------'
o.23 = net3_word2 net4_word2
o.24 = ' '
return
/*************************/
vm_info:
v = outtrap("vm",1)
q cplevel
o.25 = 'Host VM Information'
o.26 = '-------------------'
v = outtrap("vm",1)
q cplevel
o.27 = vm1
o.28 = ' '
o.29 = ' z/VM     z/OS Virtual'
o.30 = ' Name     Machine Name'
o.31 = '-------   ------------'
v = outtrap("vm",1)
q userid
parse var vm1 vm_word1 vm_word2 vm_word3 vm_word4
o.32 = vm_word3 ' ' vm_word1
return
/*************************/
write_output:
"execio * diskw #15 (stem o. finis)"
"free fi(#15)"
return