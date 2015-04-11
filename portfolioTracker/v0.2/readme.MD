Pre-requisite: Have q installed. To install q, go to www.kx.com.


To run this:
1.Run ticker plant. q tick.q sym . -p 5010

        >q tick.q sym . -p 5010
        
tick.q source code can be downloaded from http://code.kx.com/wsvn/code/kx/ .

2.Run Yahoo Finance FeedHandler. 

        >q yhfh.q 
 

3.Run pnlsvc.q.

        >q pnlsvc.q

4.Run execsvc.q

        >q execsvc.q
        
5.Open portfolioTracker.html in your browser.

6.Optional. Run this if you want to save position table.

        >q savePos.q
        
  The saved table will be automatically loaded next time you run pnlsvc.q
