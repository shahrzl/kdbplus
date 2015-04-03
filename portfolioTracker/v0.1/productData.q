//Get Name, exchange and currency data from yahoo finance.
//Things todo:Joint product data table with the position table.

//Define product data table
productDataTbl:([symbol:`symbol$()] name:`symbol$();exchange:`symbol$();currency:`symbol$());


getPrdData:{
        params:"GET /d/quotes.csv?s=",(","sv string x,:()),"&f=n0x0c4 http/1.0\r\nhost:download.finance.yahoo.com\r\n\r\n";
        a:{(1+x?"")_x}` vs `:http://download.finance.yahoo.com params;
        b:("SSS";",")0:a;
        :b
        }

syms:`GOOG`AMZN`MSFT`AAPL`TM`GE`HAL`BAC`F`CSCO`INTC;

init:{
        data:getPrdData syms;
        `productDataTbl upsert syms,'flip data;
        }

init[]

\p 5015

