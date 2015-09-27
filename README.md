kdb**plus**
==========

A repository for q/kdb+ programs. For more details on q/kdb+ visit www.kx.com.

_Keywords: Binomial Model, Black-Scholes Equation, Implied Volatility, Smile, Options Pricing, Delta Hedging, Risk Neutral Distribution, Physical Distribution, Statistics, Portfolio Tracking, Tickerplant, Web Socket, JQuery UI._

Blog: https://arjunadelta.wordpress.com

###What's New?

Portfolio Tracker version 0.4 is now available under /portfolioTracker directory.

New features in version 0.4:
* Enhancements to support strategy backtesting by replaying historical tick data.
* Historical tick data is sourced from http://www.netfonds.no. Of course you can use other sources, but may require editing of timersvc.q under /histTickData directory.

Screenshot:
![ptr0 2-2](https://cloud.githubusercontent.com/assets/9425771/7025990/95c51e58-dd79-11e4-8e61-296a486a758f.png)


Delta Hedging Simulator is now available under /deltaHedging directory.

Screenshot:

![deltahedge3](https://cloud.githubusercontent.com/assets/9425771/7717062/885b438a-fecd-11e4-8422-c7c2f0d2f20b.png)

###Projects:

1. Binary and Barrier Options Pricing.
  * Here we tried to price two types of options. The Higher and the No Touch which are available
    on binary.com website. 
  * Volatility are considered to be constant. Here I used Implied Volatility calibrated based on price 
   available from binary.com website.
  * 1-month LIBOR is used as risk free rate.
  * FX rates data is sourced from Yahoo Finance.
  * Communication between back end and front end is done using Web Socket. 

  References:

  - Derman, Emanuel, and lraj Kani. "The Ins and Outs of
    Barrier Option: Part 2." Derivatives Quarterly, Winrcr 96
    URL: http://www.emanuelderman.com/media/insoutbarriers2.pdf

2. Implied Risk Neutral Distribution.
  * Computation of Implied Risk Neutral Distribution by recovering from index option prices.
  * Here I use Nikkei 225 Options data available from Osaka Stock Exchange (OSE) website.
  * Data source: http://www.jpx.co.jp/markets/statistics-derivatives/daily/index.html
  
  References:

  - Shimko, David C(1993): "Bounds of Probability", Risk, 6, 33-7
  
  Screenshot:

  ![irnd](https://cloud.githubusercontent.com/assets/9425771/6879928/705e4738-d550-11e4-94e0-c41d9e95eeec.png)
  
3. Portfolio Tracker.
  * Demonstrate the use of feed handler, tickerplant as well as tick subscriber.
  * Market data is sourced from Yahoo Finance. Please note that it is a delayed tick data.
  * A feed handler based on Random Walk Simulation is also available so that application can be tested
    during market close. This simulator can be found under feedHandler/randomWalkSim directory.
    The file is feedsimR.q.
  * PnL is calculated based on the difference between average bought/sold price and last price.
  * Charts are rendered using Google Chart Api.
  * Web Socket is used to push data to GUI.
  
  Screenshot:
 ![ptr0 2-2](https://cloud.githubusercontent.com/assets/9425771/7025990/95c51e58-dd79-11e4-8e61-296a486a758f.png)

 ![ptr0 2agg](https://cloud.githubusercontent.com/assets/9425771/7026025/db9a0380-dd79-11e4-802d-fedac9b219bb.png)

4. Physical Distribution Estimation.
  * An estimation of physical distribution based on historical data using Gaussian Kernel.
  * Here I am using Nikkei 225 daily historical data for year 2014. This data was downloaded
    from Yahoo Finance.

  Screenshot:
  ![gaussian](https://cloud.githubusercontent.com/assets/9425771/6885618/07ca59a8-d65b-11e4-86db-5858c1bee709.png)

5. BS Model Viewer.
  * A graphical viewer for Black-Scholes model for European Call Option.
  * The GUI allows user to change parameters and see how the Greek letters change.
  
  Screenshot:
  ![bs](https://cloud.githubusercontent.com/assets/9425771/6935038/ceeeed8e-d870-11e4-8adf-d0f5421c24f1.png)
