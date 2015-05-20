

/Here we used Mini size Nikkei 225 Futures for hedging purpose.
/Delta = 0.1
/Contract size for the Nikkei 225 Option is x1000.

\l impliedVolNR.q

optPosTbl:([] timestamp:`datetime$();account:`$();sym:`$();trader:`$();pos:`int$();totalBQty:`int$();totalBCost:`float$();totalSQty:`int$();totalSCost:`float$();avgBCost:`float$();avgSCost:`float$();lastPrice:`float$();pnl:`float$();lPriceChg:`float$();lPriceChgPct:`float$();realizedPnl:`float$());

optRiskParamTbl:([ sym:`$()] Delta:`float$(); Gamma:`float$(); Vega:`float$(); Theta:`float$(); IV:`float$());

optParamTbl:([sym:`$()] rf:`float$(); maturity:`datetime$();strike:`float$();underlying:`$());

ivTbl:([] timestamp:`datetime$(); sym:`$(); IV:`float$());

ivrnd:0.17;

initFlg:0;

/Option sym is in the format PXXXXX where P is for Put and XXXXX is the strike.

rcauchy:{[n;loc;scale]
        :loc + scale * tan pi * (n?1.0) - 0.5;
        }

initHedge:{
        /Init other param tbl
        a:15%24;
        `optParamTbl insert (`N225P19375; 0.0007; 15+a+`datetime$.z.D; 19375.0;`$"%5EN225");

        /Calculate price and risk parameters first.
        a:select sym,rf,ttm:(`float$maturity-`float$.z.Z)%252.0,strike,price,IV:0.17 from optParamTbl ij 1!select underlying:sym,price from lastPriceTbl where sym in(`$"%5EN225");
        b:select sym,Delta:putDelta[price;strike;ttm;rf;IV],Gamma:putGamma[price;strike;ttm;rf;IV],Vega:putVega[price;strike;ttm;rf;IV],Theta:putTheta[price;strike;ttm;rf;IV],OptPrice:bsPutPriceEu[price;strike;ttm;rf;IV],IV from a;

        /init risk parameters table.
        `optRiskParamTbl insert select sym,Delta,Gamma,Vega,Theta,IV from b;

        /create option position.
        `optPosTbl insert (.z.Z;`acc1;`N225P19375;`trader1;10; 10;0.0*10.0; 0;0.0; 0.0;0.0; 0.0;0.0; 0.0; 0.0;0.0);
        /update option price in position tbl.
        prc: first exec OptPrice from b;
        update totalBCost:prc*pos, avgBCost:prc from `optPosTbl;
        }

calcOption:{
        dat: optParamTbl ij 1!select underlying:sym,price from lastPriceTbl where sym in (`$"%5EN225");
        dat: select sym,price,strike,ttm:(`float$maturity-`float$.z.Z)%252.0,rf from dat;
        dat: dat ij optRiskParamTbl;

        res:select sym,OptPrice:bsPutPriceEu[price;strike;ttm;rf;ivrnd], Delta:putDelta[price;strike;ttm;rf;ivrnd],Gamma:putGamma[price;strike;ttm;rf;ivrnd],Vega:putVega[price;strike;ttm;rf;ivrnd],Theta:putTheta[price;strike;ttm;rf;ivrnd],IV:ivrnd from dat;
        res: 1!select sym,optPos:10,totalDelta:Delta*10, Delta,Gamma,Vega,Theta,IV,OptPrice from res;
        deltaHedge[first exec Delta from res];

        res: select sym,optPos,avgBCost,pnl:1000*optPos*OptPrice-avgBCost,totalDelta,Delta,Gamma,Vega,Theta,IV,lastPrice:OptPrice from optPosTbl ij res;
        :res
        }

deltaHedge:{[delta]
        uPos: first exec pos from positionTbl;
        oPos: first exec pos from optPosTbl;
        newUPos: `int$neg delta*oPos%0.1;
        qty: newUPos-uPos;
        if[qty=0Ni; qty:newUPos];
        /0N!qty;

        side:enlist "B";
        trd:`account`sym`trader`side`qty`execPrice!("acc1";"%5EN225";"trader1";side;0;first exec price from lastPriceTbl where sym in (`$"%5EN225"));

        /Call enter trade function in execsvc.
        if[qty<-2;trd[`side]:enlist "S"; qty:neg qty;trd[`qty]:qty;neg[h](`enterTrade;value trd) ];
        if[qty>2;trd[`qty]:qty; neg[h](`enterTrade;value trd) ];
        }

/Will be called through Web Socket.
getOptionData:{
/       0N!`getOptionData;
        :calcOption[]
        }

