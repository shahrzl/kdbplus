
/Yahoo Feed Handler.
/To use this, make sure Tickerplant is started first. See tick.q on how to start Tickerplant.

getTnQBySyms:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=b2b3a5b6l1k3 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:{b:count x ss ",";if[b=6;a: x _ last x ss ","];if[b<6;a:x];("FFFFFF";",")0:a} each a;
        :b
        }

/open connection with TP
h:hopen 5010

/timer frequency.Change here to change frequency.
t:1000*5
publish:{neg[h](`.u.upd;x;y)}

/Change x to change to your own list of symbols.
.z.ts:{a:getTnQBySyms x:`GOOG`AMZN`AAPL;publish[`quote;]each flip 5#flip x,'a;publish[`trade;]each x,'flip(-2#flip a)}

system"t ",string t

/stop sending data if connection to tickerplant is lost
.z.pc:{if[x=h;-1"Lost connection with TP"; system"t 0"];}
