/* REXX */
"allocate dataset('sys1.iplparm(loadw1)') fi(iplparm) shr reuse"
"execio * diskr iplparm (stem parm. finis)"
    do p=1 to parm.0
    say parm.p
    end
exit 0
