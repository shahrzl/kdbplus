/Yahoo Feed Handler.
/To use this, make sure Tickerplant is started first.

/b2b3 ask and bid realtime
/a5b6 ask size and bid size
/l1 last trade price
/k3 last trade size
/a0 b0 ask bid

getTnQBySyms:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=aba5b6l1k3 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:{b:count x ss ",";if[b=6;a: x _ last x ss ","];if[b<6;a:x];("FFFFFF";",")0:a} each a;
        :b
        }

/open connection with TP
h:hopen 5010

/timer frequency.
t:1000*2publish:{neg[h](`.u.upd;x;y)}

getSyms:{
        Data:("SSS";enlist ",")0:`product.csv;
        res:exec sym from Data;
        :res
        }

/.z.ts:{syms:getSyms[];a:getTnQBySyms x:syms;publish[`quote;]each flip 5#flip x,'a;publish[`
trade;]each x,'flip(-2#flip a)}

.z.ts:{syms:getSyms[];a:getTnQBySyms x:syms;publish[`trade;]each x,'flip(-2#flip a);publish[`quote;]each flip 5#flip x,'a}


system"t ",string t

/stop sending data if connection to tickerplant is lost
.z.pc:{if[x=h;-1"Lost connection with TP"; system"t 0"];}
