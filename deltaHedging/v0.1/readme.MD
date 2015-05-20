Pre-requisites: 

-Have q installed. To install q, go to www.kx.com.
-Tickerplant. tick.q source code can be downloaded from http://code.kx.com/wsvn/code/kx/.
-stat.q
-impliedVolNR.q. Available under iVolatility directory.


To run this:

1.Run ticker plant.

        >q tick.q sym . -p 5010
        
2.Run Yahoo Finance FeedHandler. 

        >q yhfh.q 
 

3.Run execsvc.q.

        >q execsvc.q

4.Run pnlsvc.q

        >q pnlsvc.q
        
5.Open portfolioTracker.html in your browser.

