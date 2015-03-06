

getTBySyms:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=l1k3 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:{b:count x ss ",";if[b=2;a: x _ last x ss ","];if[b>2;a: x _/ reverse  (1-b)# x ss ","];if[b<2;a:x];("FF";",")0:a} each a;
        :b
        }

syms:`GOOG`AMZN`MSFT`AAPL`TM`GE`HAL`BAC`F`CSCO`INTC;
prctmp: getTBySyms syms;
price: prctmp[;0];

PI:acos -1f;

//Cauchy random walk simulator
rcauchy:{[n;loc;scale]
        :loc + scale * tan PI * (n?1.0) - 0.5;
        }

/ connect to ticker plant
h:hopen 5010

/number of extra columns to add for test 3.2
ex:0

/ number of rows to send for each update
r:10

/number of updates to send per millisecond
u:1

/ time frequency , here we set to 2 seconds
t:2000

publish:{neg[h](`.u.upd;x;y)}

/ timer functions, sends data to the tickerplant
.z.ts:{
        price::price+rcauchy[count syms;0.0;0.01];
        tdat:(syms; price ; (count syms)#100);
        if[ex>0; tdat,:ex#enlist r#1f];
        if[r=1;tdat:first each tdat];
        do[u;publish[`trade;]each flip tdat;];
        }

system"t ",string t


/ stop sending data if connection to tickerplant is lost
.z.pc:{if[x=h]; system"t 0";}
