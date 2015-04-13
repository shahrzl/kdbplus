
\l impliedVolNR.q

Data:("FFSF";enlist ",")0:`n225Opt.csv;

/-----------------------Web Socket functionality----------------------

.z.ws:{
        0N!`Connecting;
        value -9!x;
        }

//publish function

pub:{neg[x] -8!y}
.z.pc:{ }

getData:{
        S:17512;
        rF:0.0007214;
        T:20.0%252.0;

        0N!`$"Reading csv file";

        0N!`InitData;
        update SO:S,Mat:T,Rate:rF from `Data;

        0N!`SelectData;
        callDat: select from Data where Type=`Call;
        putDat: select from Data where Type=`Put;

        res1: select Strike,Price,ImpliedVol,IV:impliedVolCall[0.1;SO;Strike;Mat;Rate;Price] from callDat;
        res2: select Strike,Price,ImpliedVol,IV:impliedVolPut[0.3;SO;Strike;Mat;Rate;Price] from putDat;

        res:res1,res2;
        pub[.z.w] (`drawChart;res);
        }

\p 5025
