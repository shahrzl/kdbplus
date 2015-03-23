

/Calculate binary currency/index options

\l stat.q /include stat.q for cumulative normal distribution function.

/Standard normal distribution
normsdist:{
        if[x<0;:1-nx[neg x]];
        :nx[x];
        }

/Function to calculate d1 for currency
/rd and rf are domestic and foreign risk free interest rate.
cd1:{[S;K;T;rd;rf;vol]
        tmp1: log S%K;
        tmp2:((rd-rf+(vol xexp 2)%2))*T;
        tmp3:vol * sqrt[T];
        d1:(tmp1+tmp2);
        d1:d1%tmp3;
        :d1
        }

/Function to calculate d2 for currency
cd2:{[S;K;T;rd;rf;vol]
        d2:cd1[S;K;T;rd;rf;vol] - vol*sqrt[T];
        :d2
        }

/Function to calculate binary call
/Call on foreign ccy/put on domestic ccy
binaryCallCcy:{[S;K;T;rd;rf;vol]
        tmp: exp[neg rd*T];
        tmp:tmp*normsdist[cd2[S;K;T;rd;rf;vol]];
        :tmp
        }
        
/Function to calculate binary put
/Put on foreign ccy/call on domestic ccy
binaryPutCcy:{[S;K;T;rd;rf;vol]
        tmp: exp[neg rd*T];
        tmp:tmp*normsdist[neg cd2[S;K;T;rd;rf;vol]];
        }

/binaryNoTouchCall
/Call on foreign ccy/put on domestic ccy
/b is the barrier
binaryNoTouchCallCcy:{[S;K;b;T;rd;rf;vol]
        bCall:binaryCallCcy[S;K;T;rd;rf;vol];
        rateDiff:rd-rf;
        vol2: vol xexp 2.0;
        multp: neg 1.0 + 2*rateDiff%vol2;
        tmp1: b%S;
        tmp1:tmp1 xexp multp;
        barrierCall:tmp1*binaryCallCcy[(b xexp 2.0)%S;K;T;rd;rf;vol];
        res:bCall - barrierCall;
        :res
        }


/Plain Vanilla Equity Options

/Function to calculate d1 as in N(d1) in the Black Scholes equation.
d1:{[S;K;T;rF;vol]
        tmp1: log S%K;
        tmp2:((rF+(vol xexp 2)%2))*T;
        tmp3:vol * sqrt[T];
        d1:(tmp1+tmp2);
        d1:d1%tmp3;
        :d1
        }

/Function d2 as in N(d2) in the Black Scholes equation.
/d2 is calculated using equation d1-Sigma*sqrt[T]
d2:{[S;K;T;rF;vol]
        d2:d1[S;K;T;rF;vol] - vol*sqrt[T];
        :d2
        }

/Calculate call option using Black Scholes equation.
bsCallPriceEu:{[S;K;T;rF;vol]
        prc:S*nx[d1[S;K;T;rF;vol]];
        tmp1:K * exp[neg rF*T];
        tmp1:tmp1*nx[d2[S;K;T;rF;vol]];
        :prc-tmp1
        }

/Calculate put option price. Here we use put call parity to do that.
/P=C-S+Ke^-rT
bsPutPriceEuPCP:{[S;K;T;rF;vol]
        callPrice:bsCallPriceEu[S;K;T;rF;vol];
        putPrice:callPrice-S;
        putPrice:putPrice+K*exp[neg rF*T];
        :putPrice
        }

/Let`s check using Black Scholes equation for put option price
bsPutPriceEu:{[S;K;T;rF;vol]
        prc:S*(1-nx[d1[S;K;T;rF;vol]]);
        tmp1:K*exp[neg rF*T];
        tmp1:tmp1*(1-nx[d2[S;K;T;rF;vol]]);
        :tmp1-prc
        }

