/Implied Risk Neutral Distribution
/Author: Shahrizal Shaari
/Email: shah.and.shah@gmail.com

/This is the compact version of irnd.q

/Use stat.q for cumulative standard normal distribution function

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
ivFitted2:{[K;a;b;c] :a*(K xexp 2.0)+b*K+c}

/Function to calculate d1 as in N(d1) in the Black Scholes equation.
d1:{[S;K;T;rF;Sigma] d1:(log S%K + ((rF+(Sigma xexp 2.0)%2.0)) )%(Sigma*sqrt[T]);:d1}

/Function d2 as in N(d2) in the Black Scholes equation.
/d2 is calculated using equation d1-Sigma*sqrt[T]
d2:{[S;K;T;rF;Sigma] d2:d1[S;K;T;rF;Sigma] - Sigma*sqrt[T];:d2}

/Function to calculate Call Option price using Black Scholes equation.
callPrc:{[S;K;T;rF;Sigma]
        prc:S*nx[d1[S;K;T;rF;Sigma]] - (K*exp[neg rF*T])*nx[d2[S;K;T;rF;Sigma]];
        :prc
        }

/Function to calculate implied pdf
impliedPDF:{[c0;cp;cm;rF;T;dS]
        ipdf: (cp+cm)-2*c0;
        ipdf: ipdf%(dS xexp 2);
        ipdf: ipdf * exp[rF*T];
        :ipdf
        }

impliedPDF:{[c0;cp;cm;rF;T;dS]
        ipdf: (cp+cm-2*c0)* exp[rF*T]%(dS xexp 2.0);
        :ipdf
        }
