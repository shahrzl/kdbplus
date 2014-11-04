/In this demo, we will show how to calculate binomial model
/for european option using q.
/Note: I haven't fully tested this yet.


/calculate factorial
fact:{[n]
        if[n<0;'`$"n must be a positive integer"];
        if[n=0;:1];
        rslt:1+til n;
        rslt:1*/rslt;
        :rslt
        }

/given node j,i , calculate total number
/of paths leading to the node.
combination:{[j;i]
        if[j<0;'`$"j must be a positive integer"];
        if[i<0;'`$"i must be a positive integer"];
        comb:fact[i]*fact[j-i];
        comb:fact[j]%comb;
        :comb
        }

/calculate european call option using binomial model
/n is number of steps. Other parameters are same as in our
/black scholes equation.
eurCall:{[S0;K;T;rF;vol;n]
        dt:T%n;
        u:exp[ vol*sqrt[dt]]; /u is up factor
        d:1%u;
        p:exp[rF*dt] - d;
        p:p%(u-d);
        df: exp[(neg rF)*dt];

        tmp: til n;
        /first we calculate the probabilities
        ptmp: p xexp reverse tmp;
        qtmp:(1-p) xexp tmp;
        pq: ptmp*qtmp;

        /next we calculate underlying price for each node
        ups: u xexp reverse tmp;
        downs: d xexp tmp;
        S:S0*ups*downs;
        S:S-K;

        /next we multiplied S with the probabilities
        tmp: S*pq;
        flag: tmp>0;
        tmp:tmp*flag;

        /finally we take the sum and multiply with exp neg rF*T
        /we can use function sum
        /but here we will show how to use adverb
        tmp:0+/tmp;
        tmp:tmp*exp[neg[rF]*T];

        :tmp
        }
