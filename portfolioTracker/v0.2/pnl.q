
/File: pnl.q

/Tables definition.
lastPriceTbl:([sym:`$()] price:`float$());

positionTbl:([] account:`$();sym:`lastPriceTbl$();trader:`$();pos:`int$();totalBQty:`int$();totalBCost:`float$();totalSQty:`int$();totalSCost:`float$();avgBCost:`float$();avgSCost:`float$();lastPrice:`float$();pnl:`float$();lPriceChg:`float$();lPriceChgPct:`float$();realizedPnl:`float$());

/New definition of positionTbl
/positionTbl:([] account:`$();sym:`$();trader:`$();pos:`int$();totalBQty:`int$();totalBCost:`float$();totalSQty:`int$();totalSCost:`float$();avgBCost:`float$();avgSCost:`float$();lastPrice:`float$();pnl:`float$();lPriceChg:`float$();lPriceChgPct:`float$();realizedPnl:`float$());

/execTbl:([] date:`date$();time:`time$();account:`$();sym:`$();trader:`$();side:`$();qty:`int$();execPrice:`float$());

fxTbl:([currency:`$()] fxRate:`float$());

pnlView::(positionTbl ij productDataTbl) ij fxTbl

/---Ticker plant related procedures---
/ Ticker plant related procedures was moved to a separate file.

/---Position table related procedures---

/function definitions.
flatten:{[acc;s;tr]
        cnt:count x:select from positionTbl where account in acc, sym in s,trader in tr;
        if[cnt=1;
                update pos:0,totalBQty:0,totalBCost:0.0,totalSQty:0,totalSCost:0.0,avgBCost:0.0,avgSCost:0.0 from `positionTbl where account in acc, sym in s,trader in tr;
        ];


        }

qtyFlgB:{
        $[x~`B;:1;:0];
        }

qtyFlgS:{
        $[x~`S;:1;:0];
        }

posSignChg:{
        0N!`callingposSignChg
        /args is pos, new pos
        $[0>x*y;:1;:0];
        }
        
/calculate realized pnl
realzPnl:{[execDat]
        /update realizedPnl column
        /change execDat into a table
        0N!`calculatingRealizedPnl;
        qty:execDat[`qty];
        prc:execDat[`execPrice];
        tbl:flip enlist each execDat;
        update realizedPnl:qty*(prc-avgBCost) from `positionTbl where sym in (exec sym from tbl),account in (exec account from tbl),trader in (exec trader from tbl), pos>=0;
        update realizedPnl:qty*(avgSCost-prc) from `positionTbl where sym in (exec sym from tbl),account in (exec account from tbl),trader in (exec trader from tbl), pos<0;
        }

/process execution data
prExec:{[execDat]
        sideFlg:{$[x~`B;:1;:-1]}execDat[`side];
        cnt:count x:select from positionTbl where account in execDat[`account], sym in execDat[`sym], trader in execDat[`trader];

        0N!`prExec;0N!`count;0N!cnt;

        $[cnt=1;schg:posSignChg[x[0;`pos];x[0;`pos]+sideFlg*execDat[`qty]]; schg:0];

        /add logic for realizedPnl
        if[(cnt=1) and (schg=0) and ((sideFlg*x[0;`pos])<0);realzPnl[execDat] ];

        execDatTmp:execDat;

        if[schg=1; 0N!`calcRlzPnlHere;execDatTmp[`qty]:abs[x[0;`pos]];realzPnl[execDatTmp]   ;flatten[execDat[`account];execDat[`sym];execDat[`trader]];execDat[`qty]-:abs[x[0;`pos]]];

        $[cnt=1;
        update pos:pos+sideFlg*execDat[`qty],totalBQty:totalBQty+execDat[`qty]*qtyFlgB[execDat[`side]],totalBCost:totalBCost+execDat[`qty]*execDat[`execPrice]*qtyFlgB[execDat[`side]], totalSQty:totalSQty+execDat[`qty]*qtyFlgS[execDat[`side]], totalSCost:totalSCost+execDat[`qty]*execDat[`execPrice]*qtyFlgS[execDat[`side]] from  `positionTbl where account in execDat[`account], sym in execDat[`sym],trader in execDat[`trader];

        `positionTbl insert (execDat[`account];execDat[`sym];execDat[`trader];execDat[`qty]*sideFlg;execDat[`qty]*qtyFlgB[execDat[`side]];execDat[`qty]*execDat[`execPrice]*qtyFlgB[execDat[`side]];execDat[`qty]*qtyFlgS[execDat[`side]];execDat[`qty]*execDat[`execPrice]*qtyFlgS[execDat[`side]];  0.0;0.0; 0.0;0.0; 0.0;0.0; 0.0) ];

        /update avg bought and avg sold cost.
        update avgBCost:totalBCost%totalBQty, avgSCost:totalSCost%totalSQty from `positionTbl where account in execDat[`account], sym in execDat[`sym],trader in execDat[`trader];
        update avgBCost:0.0 from `positionTbl where avgBCost=0n;
        update avgSCost:0.0 from `positionTbl where avgSCost=0n;
        }

/testdata
/execDat1:`account`sym`trader`side`qty`execPrice!(`acc1;`GOOG;`trader1;`B;100;50.0)
/execDat2:`account`sym`trader`side`qty`execPrice!(`acc1;`AMZN;`trader1;`S;100;55.0)
/execDat3:`account`sym`trader`side`qty`execPrice!(`acc1;`MSFT;`trader1;`S;100;45.0)

/execDat4:`account`sym`trader`side`qty`execPrice!(`acc1;`GOOG;`trader1;`S;200;50.0)
/execDat5:`account`sym`trader`side`qty`execPrice!(`acc1;`AMZN;`trader1;`B;100;55.0)
/execDat6:`account`sym`trader`side`qty`execPrice!(`acc1;`MSFT;`trader1;`B;300;45.0)

/---websocket functionality---
/ Web socket functionality was moved to a separate file.
