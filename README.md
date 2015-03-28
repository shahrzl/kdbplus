kdbplus
=======

A repository for q/kdb+ programs. For more details on q/kdb+ visit www.kx.com.

Keywords: Binomial Model, Black-Scholes Equation, Options Pricing, Risk Neutral Distribution, Physical Distribution, Statistics, Portfolio Tracking, Tickerplant, Web Socket.

Here are list of some of the projects under kdbplus repository:

1. Binary and Barrier Options Pricing.
  * Here we tried to price two types of options. The Higher and the No Touch which are available
    on binary.com website. 
  * Volatility are considered to be constant. Here I used Implied Volatility calibrated based on price 
   available from binary.com website.
  * 1-month LIBOR is used as risk free rate.
  * FX rates data is sourced from Yahoo Finance.
  * Communication between back end and front end is done using Web Socket. Here I am using port 5027.
   You can change to other port nunmber by editing binarySvc.q.

  References:

  - Derman, Emanuel, and lraj Kani. "The Ins and Outs of
    Barrier Optiom: Part 2." Derivatives Quarterly, Winrcr 96
    URL: http://www.emanuelderman.com/media/insoutbarriers2.pdf

2. Implied Risk Neutral Distribution.
  * Computation of Implied Risk Neutral Distribution by recovering from index option prices.
  * Here I use Nikkei 225 Options data available from Osaka Stock Exchange (OSE) website.
  
  References:

  - Shimko, David C(1993): "Bounds of Probability", Risk, 6, 33-7
  
  Screenshot:

  
  
