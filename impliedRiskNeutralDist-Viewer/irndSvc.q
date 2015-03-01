
//Implied Risk Neutral Distribution
/Author: Shahrizal Shaari
/Email: shah.and.shah@gmail.com

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
ivFitted:{[K;a;b;c]
        res:c;
        res:res+b*K;
        res:res+a*(K xexp 2.0);
        :res
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

/Do polynomial fitting.
/In case of Implied Risk Neutral Distribution, we use quadratic, therefore
/we pass 2 for the third argument.
lsfit:{(enlist y) lsq x xexp/: til 1+z}

/-----------------------Web Socket functionality --------------------

.z.ws:{
        0N!`Connecting;
        value -9!x;
        }

//publish function

pub:{neg[x] -8!y}
.z.pc:{ }

loadIV:{[]
        ivData: ("FF"; enlist ",")0:`iv23.csv;
        :ivData
        }

kTbl:([] K:`float$();Kplus:`float$();Kminus:`float$());

initKTbl:{[]
        K:til 1000;
        dS:10;

        K:K*dS;
        K:K+10000;
        Kminus:K-dS;
        Kplus:K+dS;
        `kTbl insert (`float$K;`float$Kplus;`float$Kminus);
        }
        
  //function to be call through we socket.
calcDist:{[dat]
        0N!dat;

        dS:10.0;

        S0:17512.0;
        rF:0.0007214;
        T:0.079365;

        /Call curve fitting function
        ivDat: loadIV[];
        strike: exec Strike from ivDat;
        ivol: exec Vol from ivDat;
        /3rd. parameter is 2 for quadratic curve.
        crv: lsfit[ strike;ivol;2];

        ivTbl:select K,Kplus,Kminus,iv:ivFitted[K;crv[0;2];crv[0;1];crv[0;0]],ivplus:ivFitted[Kplus;crv[0;2];crv[0;1];crv[0;0]],ivminus:ivFitted[Kminus;crv[0;2];crv[0;1];crv[0;0]] from kTbl;
        prcTbl: select K,prc:callPrc[S0;K;T;rF;iv],prcPlus:callPrc[S0;Kplus;T;rF;ivplus],prcMinus:callPrc[S0;Kminus;T;rF;ivminus] from ivTbl;
        irndTbl:select K,pdf:impliedPDF[prc;prcPlus;prcMinus;rF;T;dS] from prcTbl;

        :irndTbl
        }

getImpliedDist:{[dat]
        0N!dat;

        res:calcDist[dat];
        pub[.z.w] (`drawChart;res);
        }

initKTbl[];



/Set our port number.
\p 5023
