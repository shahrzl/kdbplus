
/get Name, Exchange, Currency and Prev Close data from yahoo finance.
/We will use previous close to calculate chg and %chg.
/Currency will be used to convert pnl to USD.

/p0 previous close. Use l1 if p0 not available

//Define product data table
productDataTbl:([sym:`symbol$()] name:`symbol$();exchange:`symbol$();currency:`symbol$();prevClose:`float$());

/n0 name
/x0 exchange
getPrdData:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=c4l1 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:("SF";",")0:a;
        :b
        }

getPDatFromFile:{
        Data:("SSS";enlist ",")0:`product.csv;
        :Data
        }

/syms:`GOOG`AMZN`MSFT`AAPL`TM`GE`HAL`BAC`F`CSCO`INTC;
/syms,:`$"1961%2EKL";
/syms,:`$"5099%2EKL";

init:{
        tmpDat:getPDatFromFile[];
        syms:exec sym from tmpDat;
        name:exec name from tmpDat;
        exchange:exec exchange from tmpDat;

        data:getPrdData syms;
        `productDataTbl upsert syms,'name,'exchange,'flip data;
        tmp: select sym, name, exchange, currency:upper[`$((string currency),'(count productDataTbl)#enlist"USD%3DX")] ,prevClose from productDataTbl;
        `productDataTbl upsert 1!tmp;
        }

init[];

\
