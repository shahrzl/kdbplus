
/File: pnlsvc.q

/What's new?
/1. Support multiple currencies. Non USD pnl will be automatically converted into USD.
/2. Add exchange,name data into the table.
/3. Aggregate view. PnL by Account.
/4. Add quote table.
/5. Save data at shutdown. Load position data at start up.

\p 5011

\l pnl.q

\l yahooProductData.q

.u.init:{
        0N!`$"Initialization function.";

        0N!`$"Loading position table.";
        loadTable[];
        }

/Save and Load table functions
saveTable:{
        /save `:positionTbl;
        @[save;`:positionTbl;`$"Failed to save Position table"];
        }

loadTable:{
        /load `:positionTbl
        @[load;`:positionTbl;`$"Failed to load Position table"];
        }


/---Ticker plant related procedures---

if[not "w"=first string .z.o;system "sleep 1"];

upd:{[tbl;data]
        /upsert into lastPrice table
        insert[tbl;data];
/       0N!data;
        upsert[`lastPriceTbl;select last price by sym from trade];

/upsert fxTbl
        /upsert[`fxTbl; 1!select currency:sym, fxRate:price from data where sym in (exec distinct currency from productDataTbl)];
        upsert[`fxTbl; select fxRate:last price by currency:sym from trade where sym in (exec distinct currency from productDataTbl)];


/       update lPriceChg:sym.price-lastPrice,lPriceChgPct:((sym.price-lastPrice)%lastPrice)*100.0, lastPrice:sym.price,pnl:pos*(sym.price-avgBCost) from `positionTbl where sym in (exec sym from data),pos>=0;
/       update lPriceChg:sym.price-lastPrice,lPriceChgPct:((sym.price-lastPrice)%lastPrice)*100.0, lastPrice:sym.price,pnl:pos*(sym.price-avgSCost) from `positionTbl where sym in (exec sym from data),pos<0;

/New version. We do not calculate lPriceChg and lPriceChgPct here.
/Here we only updates  lastPrice and pnl.
/we moved this into getPosition function.
        update lastPrice:sym.price,pnl:pos*(sym.price-avgBCost) from `positionTbl where sym in (exec sym from data),pos>=0;
        update lastPrice:sym.price,pnl:pos*(sym.price-avgSCost) from `positionTbl where sym in (exec sym from data),pos<0;
        }

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

.u.rep:{0N!x;0N!y;(.[;();:;].)each x}

/---tp related procedures end here---

/---Position table related procedures---
/ Moved to a separate file.

/---websocket functionality---

.z.ws:{0N!`Connecting; value -9!x}

// subs table to keep track of current subscriptions
subs:2!flip `handle`func`params`curData!"is**"$\:()

// pubsub functions
sub:{`subs upsert (.z.w;x;y;res:eval(x;enlist y));(x;res)}
pub:{neg[x] -8!y}
pubsub:{pub[.z.w] eval(sub[x];enlist y)}
.z.pc: {delete from `subs where handle=x}

///functions to be called through websocket.

loadPage:{0N!`$"Loading page"; pubsub[;`$x] each `getSymsAutoComplete`getSyms`getPosition`getPnlByAccount`getQuote`getChartData}
filterSyms:{pubsub[;`$x]each enlist `getPosition}

getChart:{pubsub[;`$x]each enlist `getChartData}

getChartData:{
        w:$[all all null x;exec first sym from lastPriceTbl;x];
/       0N!`$"getChartData";
/       0N!w;
        res:select from trade where sym=w;
        /pubsub[;w]each enlist `getChart;
        :res
        }

//get data method
getData:{
        w:$[all all null y;();enlist(in;`sym;enlist y)];
        //0!?[x;w;enlist[`sym]!enlist`sym;()]
        res:0!?[x;w;0b;()];
        :res
        }

/getPosition:{getData[`positionTbl] x}
getPosition:{
        tmp: getData[`pnlView] x;
        tmp2: 1!select sym,priceChg:lastPrice-prevClose,pctPriceChg:((lastPrice-prevClose)%prevClose)*100.0 from tmp;
        /res:ej[`sym;tmp;tmp2];
        res:tmp ij tmp2;
        res: select account,sym,trader,pos,avgBCost,avgSCost,lastPrice,pnl:pnl*fxRate,realizedPnl,name,exchange,currency,prevDayClose:prevClose,fxRate,priceChg,pctPriceChg from res;
        :res
        }

/Aggregated PnL
getPnlByAccount:{
        tmp: select from pnlView;
        res: select account,sym,trader,pnl:pnl*fxRate,realizedPnl from tmp;
        res: 0!select sum[pnl],sum[realizedPnl] by account from res;
        :res
        }

getQuote:{
        tmp:0!select from lastPriceTbl;
        res:tmp ij productDataTbl;
        res:select sym, price, change:price-prevClose from res where not exchange in (`CCY);
/add quote data
        res: res ij select last bid,last ask,last bsize,last asize by sym from quote;

        :0!res
        }

getSyms:{distinct positionTbl`sym}

getSymsAutoComplete:{distinct trade`sym}

// refresh function - publishes data if changes exist, and updates subs
refresh:{
        update curData:{[h;f;p;c] if[not c~d:eval(f;enlist p);pub[h] (f;d)]; d }'[handle;func;params;curData] from `subs
        }

// trigger refresh every 100ms
.z.ts:{refresh[]}
\t 1000

/Subscribe to tickerplant
(hopen `$":",.u.x 0)".u.sub[`trade;`];.u.sub[`quote;`]";

/Initialization of data. Use this for testing purpose.
.u.init[];

\
