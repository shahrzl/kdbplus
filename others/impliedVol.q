
/Calculate implied volatility

\l stat.q /include stat.q for cumulative normal distribution function.



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

/Do polynomial fitting.
/In case of Implied Risk Neutral Distribution, we use quadratic,therefore
/we pass 2 for the third parameter.
lsfit:{(enlist y) lsq x xexp/: til 1+z}
