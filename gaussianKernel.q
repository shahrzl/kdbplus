/Estimation of Physical Distribution based on historial date using Gaussian Kernel.

pi:acos -1

gaussianKernel:{[x]
        :(exp neg (x xexp 2.0)%2)%sqrt[2*pi]
        }


/n is number of samples
band:{[n;sigma]
        :0.9*sigma%(n xexp 0.2)
        }

variance:{[data]
        average:avg data;
        datavgdiff:data-average;
        r:datavgdiff xexp 2.0;
        r:sum r;
        r:r%(count data);
        :r
        }

sd:{[data]
        :sqrt[var[data]]
        }
        
\l yahooFinance.q

/Next we use above functions to do our estimastion.

/we use a year worth of historical data.
r:yahooHistData[`$"%5EN225";365]
r:update sym:`N225 from r
sdtbl:select sd:sd[close] by sym from r
if[(count sdtbl)=1;sdval:raze sdtbl[`N225];sdval:sdval 0]
bandval:band[count r;sdval]
numOfPnts:10000%250
numOfPnts:`int$numOfPnts
r2:(numOfPnts * count r)#r
a:til numOfPnts
a:a*250
a:a+10000
b:raze (count r)#/:a
tmptbl:([] xval:b)
r3:r2,'tmptbl
r4:select date,sym,close,xval,gk:gaussianKernel[(close-xval)%bandval] from r3
r5:select gksum:sum[gk] by xval from r4
r6:select xval,density:gksum%(numOfPnts*bandval) from r5

