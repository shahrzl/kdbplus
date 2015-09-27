
/A timer service to replay historical tick data to the tickerplant.
/For strategy backtesting purpose.

trade: flip (`time;`price;`quantity;`source;`buyer;`seller;`initiator;`sym)!("ZFFSSSSS";" ")0:();

/load data into trade table
loaddataT:{
        filenm: "./taq/",first .z.x;
        0N!`$filenm;
        insym: last .z.x;
        insym: `$insym;
        update sym:insym from data:("ZFFSSSS";enlist ",")0:`$filenm
        }

trade,: loaddataT[];

/open connection with TP
h:hopen 5010

/timer frequency
t:1000

publish:{neg[h](`.u.upd;x;y)}

/counter
cnt:1

numofrows: count trade

/A timer function.
.z.ts:{
        rslt: exec last sym,last price, last quantity from select[cnt] from trade;
        publish[`trade;value rslt];
        insym: last .z.x;
        insym: `$insym;
        0N!value rslt;
        /dummy data for quote
        qdat: 2#value rslt;
        qdat,: last qdat;
        qdat,: 100 100;
        0N!qdat;
        publish[`quote; qdat];
        $[cnt<numofrows; cnt:: cnt + 1; cnt::count];
        }

system"t ",string t

/stop sending data if connection to tickerplant is lost
.z.pc:{if[x=h;-1"Lost connection with TP"; system"t 0"];}

\p 5031

\

How to run this:

q timersvc.q [csv file] [sym]

example:
q timersvc.q tradeGE.N0821.csv GE
