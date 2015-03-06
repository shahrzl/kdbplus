
Pre-requisite: Have q installed. To install q, go to www.kx.com.


To run this:
1.Run ticker plant. q tick.q sym . -p 5010

        >q tick.q sym . -p 5010
        
tick.q source code can be downloaded from http://code.kx.com/wsvn/code/kx/ .

2.Run yahooFeedHandler. q yahooFeedHandler.q :5010 or
 alternatively run our random walk feed simulator feedsimR.q.

        >q feedsimR.q
        
feedsimR.q can be found under kdbplus/feedhandler/randomWalkSim/
        

3.Run pnl.q.

        >q pnl.q

4.Run execsvc.q

        >q execsvc.q
        
5.Open portfolioTracker.html in your browser.
