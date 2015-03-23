
Pricing Binary and Barrier Options.

Notes:

1. Here we tried to price two types of options. The Higher and the No Touch which are available
on binary.com website.
2. Volatility are considered to be constant. Here I used Implied Volatility calibrated based on price 
available from binary.com website.
3. 1-month LIBOR is used as risk free rate.
4. FX rates data is sourced from Yahoo Finance.
5. Communication between back end and front end is done using Web Socket. Here I am using port 5027.
You can change to other port nunmber by editing binarySvc.q.

Pre-requisites: 

1. Have q installed. To install q, go to www.kx.com.
2. Also required stat.q file. Can be downloaded from http://kx.com/q/stat.q
3. Ticker plant. You can download tick.q file from http://code.kx.com/wsvn/code/kx/.

References:

1. Derman, Emanuel, and lraj Kani. "The Ins and Outs of
Barrier Optiom: Part 2." Derivatives Quarterly, Winrcr 96
URL: http://www.emanuelderman.com/media/insoutbarriers2.pdf

To run this:
1.Run ticker plant. q tick.q sym . -p 5010

        >q tick.q sym . -p 5010
      

2.Run Yahoo Finance feed handler. 

        >q yahooFeedHandlerCCY.q
        

3.Run binarySvc.q

        >q binarySvc.q
        
4.Open binary.html in your browser.
