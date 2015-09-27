
An implementation of timer service to replay historical tick data to the tickerplant.
This can be used for backtesting purpose.

Pre-requisite: Have q installed. To install q, go to www.kx.com.


To run the timer service:

1.Run ticker plant.

        >q tick.q sym . -p 5010
        
tick.q source code can be downloaded from http://code.kx.com/wsvn/code/kx/ .

2.Run the timer service. 

        >q timersvc.q [csv file] [sym]

This timer service use historical tick data downloaded from http://www.netfonds.no .

A java downloader is also included in this directory.

To compile the java downloader, simply run

        >javac TickDL.java
        
You can try tickDL.sh shell script to run the downloader. Make sure tickDL.sh is executable.
To make it executable, run

        >chmod u+x tickDL.sh
        

 
