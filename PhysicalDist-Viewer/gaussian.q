

/Estimation of Physical Distribution based on historial date using Gaussian Kernel.

pi:acos -1

gaussianKernel:{[x]
        :(exp neg (x xexp 2.0)%2)%sqrt[2*pi]
        }


/n is number of samples
band:{[n;sigma]
        :0.9*sigma%(n xexp 0.2)
        }

sd:{[data]
        :sqrt[var[data]]
        }

/We will use above functions for our physical distribution estimation based on historical data

loadDist:{
        r:("DEEEEIE"; enlist ",")0:`n2252014.csv;
        r:update sym:`N225 from r;
        sdtbl:select sd:sd[Close] by sym from r;
        if[(count sdtbl)=1;sdval:raze sdtbl[`N225];sdval:sdval 0];
        bandval:band[count r;sdval];
        numOfPnts:10000%250;
        numOfPnts:`int$numOfPnts;
        r2:(numOfPnts * count r)#r;
        a:til numOfPnts;
        a:a*250;
        a:a+10000;
        b:raze (count r)#/:a;
        tmptbl:([] xval:b);
        r3:r2,'tmptbl;
        r4:select Date,sym,Close,xval,gk:gaussianKernel[(Close-xval)%bandval] from r3;
        r5:select gksum:sum[gk] by xval from r4;
        r6:select xval,density:gksum%(numOfPnts*bandval) from r5;

        pub[.z.w] (`drawChart;r6);
        }

/WebSocket related procedures

.z.ws:{
        0N!`Connecting;
        value -9!x;
        }

//publish function

pub:{neg[x] -8!y}
.z.pc:{ }

\p 5025
