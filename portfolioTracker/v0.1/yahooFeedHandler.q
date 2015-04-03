
/Yahoo Feed Handler.
/To use this, make sure Tickerplant is started first.

getTnQBySyms:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=l1k3 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:{b:count x ss ",";if[b=2;a: x _ last x ss ","];if[b>2;a: x _/ reverse  (1-b)# x ss ","];if[b<2;a:x];("FF";",")0:a} each a;
        :b
        }

/open connection with TP
h:hopen 5010

/timer frequency
t:2000
publish:{neg[h](`.u.upd;x;y)}

syms:`GOOG`AMZN`MSFT`AAPL`TM`GE`HAL`BAC`F`CSCO`INTC;

.z.ts:{a:getTnQBySyms x:syms;publish[`trade;]each x,'a}

system"t ",string t

/stop sending data if connection to tickerplant is lost
.z.pc:{if[x=h;-1"Lost connection with TP"; system"t 0"];}
