/* Rexx */
/* Throw away first 43 columns for each tmp record */
/* Starting at column 1 in rpt1 write tmp columns from 44 to end */
Arg mbr
"allocate dataset(ch15.output(tmp)) fi(tmp) shr reuse"
"execio * diskr tmp (stem tmp. finis)"
/*      */
"allocate dataset(ch15.output("mbr")) fi(rpt) shr reuse"
"execio 0 diskw rpt (stem rpt. open)"
/*      */
    do i=1 to tmp.0
        rpt.i = substr(tmp.i,44,77)
    end
/*      */
"execio * diskw rpt (stem rpt. finis)"
/*      */
"free fi(tmp)"
"free fi(rpt)"
exit
