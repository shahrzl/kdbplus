
/Calculate implied volatility

\l stat.q /include stat.q for cumulative normal distribution function.

/Calculate implied volatility using Newton Raphson method.
/Call Option
/This is done based on Taylor expansion of the first order.
impliedVolCall:{[volGuess;S;K;T;rF;price]
        sigma:NRfuncCall[volGuess;S;K;T;rF;price];
        prevSigma:sigma;
        do[10;
                prevSigma:sigma;
                sigma:NRfuncCall[sigma;S;K;T;rF;price];
        ];

        :sigma
        }

impliedVolPut:{[volGuess;S;K;T;rF;price]
        sigma:NRfuncPut[volGuess;S;K;T;rF;price];
        prevSigma:sigma;
        do[10;
                prevSigma:sigma;
                sigma:NRfuncPut[sigma;S;K;T;rF;price];
        ];

        :sigma
        }

/Newton Raphson
NRfuncCall:{[volGuess;S;K;T;rF;price]
        tmp:price - bsCallPriceEu[S;K;T;rF;volGuess] - callVega[S;K;T;rF;volGuess]*volGuess;
        tmp:tmp%callVega[S;K;T;rF;volGuess];
        :tmp
        }

NRfuncPut:{[volGuess;S;K;T;rF;price]
        tmp:price - bsPutPriceEu[S;K;T;rF;volGuess] - putVega[S;K;T;rF;volGuess]*volGuess;
        tmp:tmp%putVega[S;K;T;rF;volGuess];
        :tmp
        }

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
/we pass 2 for the third parameterT
lsfit:{(enlist y) lsq x xexp/: til 1+z}

/Calculate greek letters.

/Call Delta
/N(d1)
callDelta:{[S;K;T;rF;vol]
        :nx[d1[S;K;T;rF;vol]]
        }

putDelta:{[S;K;T;rF;vol]
        :nx[d1[S;K;T;rF;vol]]-1
        }

gaussianKernel:{[x]
        :(exp neg (x xexp 2.0)%2)%sqrt[2*pi]
        }

callGamma:{[S;K;T;rF;vol]
        :gaussianKernel[d1[S;K;T;rF;vol]]%S*vol*sqrt[T]
        }

putGamma:{[S;K;T;rF;vol]
        :callGamma[S;K;T;rF;vol]
        }

callVega:{[S;K;T;rF;vol]
        :S*sqrt[T]*gaussianKernel[d1[S;K;T;rF;vol]]
        }

putVega:{[S;K;T;rF;vol]
        :callVega[S;K;T;rF;vol]
        }

callTheta:{[S;K;T;rF;vol]
        a:nx[d2[S;K;T;rF;vol]]*K*exp[neg rF*T]*rF;
        b:S*gaussianKernel[d1[S;K;T;rF;vol]]*vol;
        b:b%2*sqrt[T];
        b:neg b;
        :b-a
        }

callRho:{[S;K;T;rF;vol]
        :nx[d2[S;K;T;rF;vol]]*K*exp[neg rF*T]*T
        }
