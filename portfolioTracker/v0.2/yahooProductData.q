
/get Name, Exchange, Currency and Prev Close data from yahoo finance.
/We will use previous close to calculate chg and %chg.
/Currency will be used to convert pnl to USD.

/p0 previous close

//Define product data table
productDataTbl:([symbol:`symbol$()] name:`symbol$();exchange:`symbol$();currency:`symbol$();prevClose:`float$());


getPrdData:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=n0x0c4p0 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:("SSSF";",")0:a;
        :b
        }

syms:`GOOG`AMZN`MSFT`AAPL`TM`GE`HAL`BAC`F`CSCO`INTC;
syms,:`$"1961%2EKL";
syms,:`$"5099%2EKL";

init:{
        data:getPrdData syms;
        `productDataTbl upsert syms,'flip data;
        }

init[];
