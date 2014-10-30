/Implied Risk Neutral Distribution
/Author: Shahrizal Shaari
/Email: shah.and.shah@gmail.com

/This code was developed using below reference
/Shimko, David C(1993): "Bounds of Probability", Risk, 6, 33-7

/Prerequisite:
/1.Implied Volality Curve. I use R to calculate implied volatility and curve
/fitting.
/2.Options data. I use historical Nikkei 225 option data downloaded from Osaka Stock Exchange website.

/Reimplementation of implied Risk Neutral Distribution(RND) using q kdb+
/Use stat.q for cumulative standard normal distribution function
/Can be downloaded from http://kx.com/q/stat.q
\l stat.q

/Function parameters
/S current index value (atom)
/K Strike price ( can be an atom or list )
/T Maturity (atom)
/rF risk free rate (atom)
/Sigma Volatility ( can be atom or list )

/Things TODO:
/1.Parameter checking for the functions
/2.Error handling

/IV fitted function. Fitted to the aK^2 + bK + c curve.
/This one created for testing.
ivFitted:{[K]
        a1:2.0*(10.0 xexp -8.0);
        a2:-0.0004;
        a3:2.3088;
        a1:a1*(K xexp 2.0);
        a1:a1+a2*K;
        a1:a1+a3
        }

/This is the real one.       
ivFitted2:{[K;a;b;c]
        iv:a*(K xexp 2.0);
        iv:iv+b*K;
        iv:iv+c;
        :iv
        }

/Function to calculate d1 as in N(d1) in the Black Scholes equation.
d1:{[S;K;T;rF;Sigma]
        tmp1: log S%K;
        tmp2:((rF+(Sigma xexp 2)%2))*T;
        tmp3:Sigma * sqrt[T];
        d1:(tmp1+tmp2);
        d1:d1%tmp3;
        :d1
        }

/Function d2 as in N(d2) in the Black Scholes equation.
/d2 is calculated using equation d1-Sigma*sqrt[T]
d2:{[S;K;T;rF;Sigma]
        d2:d1[S;K;T;rF;Sigma] - Sigma*sqrt[T];
        :d2
        }

/Function to calculate Call Option price using Black Scholes equation.
callPrc:{[S;K;T;rF;Sigma]
        prc:S*nx[d1[S;K;T;rF;Sigma]];
        tmp1:K * exp[neg rF*T];
        tmp1:tmp1*nx[d2[S;K;T;rF;Sigma]];
        :prc-tmp1
        }

/Function to calculate implied pdf
impliedPDF:{[c0;cp;cm;rF;T;dS]
        ipdf: (cp+cm)-2*c0;
        ipdf: ipdf%(dS xexp 2);
        ipdf: ipdf * exp[rF*T];
        :ipdf
        }

/A Demo on how to use above function to calculate implied risk neutral probability
demoFunc:{[dS]
        K:til 1000;
        K:K*dS;
        K:K+6500;
        Kminus:K-dS;
        Kplus:K+dS;
        S0:10801.57;
        rF:0.0017;
        T:0.108;
        iv:ivFitted K;
        ivplus: ivFitted Kplus;
        ivminus: ivFitted Kminus;
        c0:callPrc[S0;K;T;rF;iv];
        cplus:callPrc[S0;Kplus;T;rF;ivplus];
        cminus:callPrc[S0;Kminus;T;rF;ivminus];
        impliedRND:impliedPDF[c0;cplus;cminus;rF;T;dS];
        :impliedRND
        }

