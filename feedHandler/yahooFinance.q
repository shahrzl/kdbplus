
/Reference: http://code.kx.com/wsvn/code/contrib/simon/googlefinance/
/This code was written with reference to googlefinance.q code by Simon Garland

/Notes on coding style: This code was written in a step by step manner for easy understanding by the reader.

/How to use: example; yahooHistData[`GOOG;50]
/Example of return value:
//date       sym  open   high   low    close  volume
//---------------------------------------------------
//2014.09.22 GOOG 593.82 593.95 583.46 587.37 1684900
//2014.09.23 GOOG 586.85 586.85 581    581.13 1467400
//............

/Warranties:
/There are no warranties.

httpget:{[host;location] (`$":http://",host)"GET ",location," HTTP/1.0\r\nhost:",host,"\r\n\r\n"}

buildParams:{[start;offset]
        end:start+offset;
        sd:string `dd$start;
        sm:string -1+`mm$start;
        sy:string `year$start;
        ed:string `dd$end;
        em:string -1+`mm$end;
        ey:string `year$end;

        params:"&a=",sm,"&b=",sd,"&c=",sy,"&d=",em,"&e=",ed,"&f=",ey,"&g=d&ignore=.csv ";
        :params
        }

getMcsv:{[host;stock;start;offset;tbl]
        params:buildParams[start;offset];
        $["200"~3#9_r:httpget[host;"/table.csv?s=",(string stock),params];
        update Sym:stock from select from("DEEEEIE ";enlist",")0:{(x ss"Date,Open")_ x}r;tbl]
        }
        
yahooMGet:{[host;stock;dates;offset]
        tbl:flip(`Date;`Open;`High;`Low;`Close;`Volume;`$"Adj Close";`Sym)!("DEEEEIES";" ")0:();
        tbl,:raze getMcsv[host;stock;;offset;tbl] each distinct dates,();
        tbl:(lower cols tbl)xcol`Date`Sym xasc select from tbl where not null Volume;
        select date,sym,open,high,low,close,volume from tbl
        }

yahoo:yahooMGet"ichart.yahoo.com"

yahooHistData:{[stock;numofdays]
        tdy:`date$.z.z;
        start:tdy-numofdays;
        offset:15;
        d:offset*til ceiling[numofdays%offset];
        dates:start+d;
        rslt:yahoo[stock;dates;offset-1];
        rslt:`date`sym xasc rslt;
        :rslt
        }
