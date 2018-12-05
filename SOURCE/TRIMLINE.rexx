/* Rexx */
/* Throw away the first 60 lines from tmp member */
/* Copy lines after 60 to rpt1 member */
/* Exclude any line with all blanks       */
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
