
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

sym:`GOOG`AMZN`MSFT

publish:{neg[h](`.u.upd;x;y)}

/ timer functions, sends data to the tickerplant
.z.ts:{
        t:(10#sym;10?500.0;10#100);
        if[ex>0; t,:ex#enlist r#1f];
        if[r=1;t:first each t];
        do[u;publish[`trade;]each flip t;];
        }

system"t ",string t

/t:(10?sym;10?550.0;10#100);

/ stop sending data if connection to tickerplant is lost
.z.pc:{if[x=h]; system"t 0";}
