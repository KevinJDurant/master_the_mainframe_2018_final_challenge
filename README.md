# IBM Master the Mainframe 2018 - Part 3 Challenge #15
Hi and welcome to my notes repository. In this repository I try to prepare myself for the last challenge of IBM's Master the Mainframe 2018 contest. Feel free to use :) 

## JCL
### S00JCL.jcl
```jcl
//S00JCL   JOB 1,NOTIFY=&SYSUID
//COMMANDS EXEC PGM=IKJEFT01
//SYSPRINT DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTERM  DD DUMMY
//ISFOUT   DD DUMMY
//SYSTSIN  DD *
SDSF ULOG
//ISFIN    DD *
/D IPLINFO
/D M=CPU
/D M=STOR
/D R,L
/$D SPL
PRINT ODSN CH15.OUTPUT(TMP)
PRINT 1 9999
PRINT CLOSE
//***********************************************
//TRIMCOL  EXEC PGM=IKJEFT01,PARM='%TRIMCOL S00'
//SYSEXEC  DD DSN=&SYSUID..CH15.SOURCE,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DUMMY
```
This JCL executes several system display commands. **D** short for **DISPLAY**. A summary of all commands can be found at the [IBM Knowledge Center DISPLAY command page](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ieag100/display.htm). The JCL prints it to **CH15.OUTPUT(TMP)** and then executes a Program (PGM) TRIMCOL with parameter **S00**. 

### S01JCL.jcl
```jcl
//S01JCL   JOB 1,NOTIFY=&SYSUID
//SO1JCL   EXEC PGM=SDSF
//ISFOUT   DD DSN=&SYSUID..CH15.OUTPUT(TMP),DISP=SHR
//ISFIN    DD *
SYS
PARM
PROC
//***********************************************
//DELMENU  EXEC PGM=IKJEFT01,PARM='%TRIMLINE S01'
//SYSEXEC  DD DSN=&SYSUID..CH15.SOURCE,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD DUMMY
```
This code executes **SDSF** commands and writes the output to **CH15.OUTPUT(S01)**. A summary of all SDSF commands can be found at the [IBM Knowledge Center SDSF commands](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.3.0/com.ibm.zos.v2r3.isfa600/xcmdref.htm) reference page.


## SOURCE
When you're inside the DSLIST overview of Z#####.CH15.SOURCE enter **ex** next to a member to execute it. Always enter **S00** as data set when the code prompts for data set name.

### SAMP1.rexx
```rexx
Arg mbr
    if mbr = '' then
    Do
        Say 'Enter CH15.OUTPUT member name'
        parse pull mbr
    End
"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio * diskr rpt (stem rpt. finis)"
    do i=1 to rpt.0
        say rpt.i
    end
"free fi(rpt)"
exit
```
We notice that a variable **mbr** is declared. If **mbr** equals to an empty string then we **Do** and ask the user to enter a member name that can be found in **CH15.OUTPUT**. 

**PARSE PULL** reads ands parses the next string from the external data queue. If the external data queue is empty, it reads a line from the default input stream which is the user's terminal.

After the input is valid then we attempt to allocate the needed data set to an array called **rpt**. [More info on the **stem** keyword.](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ikja300/stems.htm)

Then we iterate via a standard **Do** loop where **rpt.0** is the array length and **rpt.i** equals a line. Inside the loop we just **say** the read line. **free** releases/deallocates previously allocated data sets or UNIX files that we don't need.

### SAMP2.rexx
```rexx
    do i=1 to rpt.0
        parse var rpt.i w1 w2 w3 w4 w5 w6 w7 w8 w9 w10
        say w1 w2 w3
    end
```
Same code and logic as SAMP1.rexx except for the **Do** loop logic. **PARSE VAR** parses the source string as a variable. So what happens here is we **PARSE VAR SOURCE variable1 variable2 variable3**. The source string gets split by spaces and each words will become a variable.

### SAMP3.rexx
```rexx
    do i=1 to rpt.0
        if pos('IEE254I',rpt.i) > '0' then say rpt.i
    end
```
Same code and logic as SAMP1.rexx except for the **Do** loop logic. The code loops over every string and check if this line contains the string **IEE254I**. If so, say that string.

## SAMP4.rexx
```rexx
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
```
Again same base logic regarding the allocation of the data set. However now we get to know how to call a function with rexx. Whenever the code finds either **IEE254I**, **IEE174I** or **IEE112I** it will call the respective function by using the **call functionname** statement. More info on the [SELECT/WHEN/OTHERWISE/END instruction](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ikjc300/ikj2g2_SELECT_WHEN_OTHERWISE_END_Instruction.htm).

Function declaration:
```rexx
operinfo:
    say rpt.i
return
```

Function call:
```rexx
call operinfo
```

### SAMP5.rexx
```rexx
"allocate dataset('sys1.iplparm(loadw1)') fi(iplparm) shr reuse"
"execio * diskr iplparm (stem parm. finis)"
    do p=1 to parm.0
    say parm.p
    end
exit 0
```
Again this piece of code allocates a data set to the array **parm** and **say**s the line it currently has the value of.

### SAMP6.rexx
```rexx
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
```
Again this code prompt for a data set member name. Whenever it encounters **IEE254I**, **IEE174I** or **IEE112I** inside its loop it will call the respective function **iplinfo**, **hardware** or **operinfo** and **free**/deallocate the data set after code execution. **IPL** stands for initial program launch.

In this case loadw1 contains the value SYS1.IPLPARM(LOADW1). This is a basic string concatenation.
```rexx
loadw1 = w17'('w15')'
```

This piece of code can be seen as reading a website domain. All [substr](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ikja300/substr.htm) does is take parts of a string at pos **p** for length **n**.
```rexx
    say 'Master Catalog name is ' substr(w22,11,15) /* OUTPUT: MASTERV.CATALOG */
    say 'Master Catalog volume is ' substr(w22,1,6) /* OUTPUT: VPMVSB */
    say 'Master Catalog device address is ' substr(w22,7,4) /* OUTPUT: 113C */
```
The original string is **VPMVSB113CMASTERV.CATALOG**.

### SAMP7.rexx
```rexx
Arg mbr
    if mbr = '' then
    Do
        Say 'Enter CH15.OUTPUT member name'
        parse pull mbr
    End
clrscn
```
The **clrscn** statement clears the screen after we've entered the data set member name. 

```rexx
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
```
A longer piece of code but just more of the same. Again when we encounter **IEE254I** or **IEE251I** inside the iterated string value we call the respective function **parm_mbrs** or **parm_ds**.

This code tells us how to review the content of **IEASYS##** members. I assume those members are important for this challenge. To get to the content we enter the primary command **TSO SYSLIB**, enter **v** in the **Action** column to the left of **$PARMLIB**. We can now view the **00**, **LV**, **SV** and **VN** data sets.

The **parm_ds** never gets called as the string **IEE251I** is nowhere to be found inside the **S00**, **S01** or **TMP** members.

### TRIMCOL.rexx
```rexx
Arg mbr
"allocate dataset(ch15.output(tmp)) fi(tmp) shr reuse"
"execio * diskr tmp (stem tmp. finis)"

"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio 0 diskw rpt (stem rpt. open)"
    do i=1 to tmp.0
        rpt.i = substr(tmp.i,44,77)
    end
"execio * diskw rpt (stem rpt. finis)"

"free fi(tmp)"
"free fi(rpt)"
exit
```
This reads from **CH15.OUTPUT(TMP)** and writes to the argument data set name. It deletes the first 43 columns from the source data set. Each key inside **rpt** its value gets reassigned with its own value but only from the 44th index for a length of 77 characters.

### TRIMLINE.rexx
```rexx
arg mbr
"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio 0 diskw rpt (stem rpt. open)"
/*      */
"allocate dataset(ch15.output(tmp)) fi(tmp) shr reuse"
"execio * diskr tmp (stem tmp. finis)"
/*      */
    j = 1
/*      */
    do i=60 to tmp.0
    if words(tmp.i) > '1'
        then do
                rpt.j = tmp.i
                j = j + 1
            end
    end
/*      */
"execio * diskw rpt (stem rpt. finis)"
/*      */
"free fi(tmp)"
"free fi(rpt)"
exit
```
This writes to the argument given member name inside **CH15.OUTPUT** and reads from **CH15.OUTPUT(TMP)**. Obvserve that **i** is declared and initialised as **60** in this case, not as **1**. This means the first **60** lines are skipped. The **if** statement required the read line to be **longer** than **1** character.

### S00#15.rexx
```rexx
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
```
Again this code prompts the user for a data set member name. Then it instantly calls several functions.

The following piece of code is a good example of **stemming**. We have **o**. We can allocate values to any key of **o**. **o.1** becomes a blank line etc. [**mvsvar**](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ikja300/mvsvarr.htm) is a global function to get system information.
```rexx
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
```
[**outtrap**](https://www.ibm.com/support/knowledgecenter/en/SSLTBW_2.1.0/com.ibm.zos.v2r1.ikja300/outtrap.htm) returns the name of the variable in which trapped output is stored. The rest of the code is trivial to what we've seen so far. 