
/2008.09.09 .k -> .q
/2006.05.08 add

\d .u
init:{w::t!(count t::tables`.)#()}

del:{w[x]_:w[x;;0]?y}

.z.pc:{del[;x]each t}

sel:{$[`~y;x;select from x where sym in y]}

pub:{[t;x]
        {[t;x;w]
                if[count x:sel[x]w 1;(neg first w)(`upd;t;x)]
                }[t;x]each w t
        }

pubExec:{[t;x]
        {[t;x;w]
                (neg first w)(`updExec;t;x)
                }[t;x]each w t
        }

add:{
        $[(count w x)>i:w[x;;0]?.z.w;
        .[`.u.w;(x;i;1);union;y];
        w[x],:enlist(.z.w;y)];
        /.u.w is populated with the handle data.ex: `s#`quote`trade!(,(6i;`);,(6i;`))
        /type 99 is dictionary.table is 98.
        0N!value x;
        0N!type value x;
        (x;$[99=type v:value x;sel[v]y;0#v])
        }

sub:{
        if[x~`;:sub[;y]each t];
        if[not x in t;'x];
        del[x].z.w;
        /handle of r.q process
        /x is `trade or `quote.y is ` means subscribe to all symbols.
        add[x;y]
        }

end:{(neg union/[w[;;0]])@\:(`.u.end;x)}
