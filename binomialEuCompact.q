/In this demo, we will show how to calculate binomial model
/for european option using q.
/Note: I haven't fully tested this yet.

/calculate factorial
fact:{[n]
        if[n<0;'`$"n must be a positive integer"];
        if[n=0;:1];
        rslt:1*/1+til n;
        :rslt
        }

/given node j,i , calculate total number
/of paths leading to the node.
combination:{[j;i]
        if[j<0;'`$"j must be a positive integer"];
        if[i<0;'`$"i must be a positive integer"];
        comb:fact[j]%fact[i]*fact[j-i];
        :comb
        }
        
/calculate european call option using binomial model
/n is number of steps. Other parameters are same as in our
/black scholes equation.
/The beauty of using vectorized language like q is we don't need to use loop
/for our calculation of binomial model for eur option.
eurCall:{[S0;K;T;rF;vol;n]
        /first calculate all necessary parameters for the binomial model.
        dt:T%n;
        u:exp[ vol*sqrt[dt]]; /u is up factor
        d:1%u;
        p:exp[rF*dt] - d;
        p:p%(u-d);
        df: exp[(neg rF)*dt];

        /next step is to calculate probabilities at each node at maturity
        prob: (p xexp reverse til n)*((1-p) xexp til n);

        /after that we calculate underlying price for each node at maturity
        S:S0*(u xexp reverse til n)* d xexp til n;

        /then we multiply S with prob
        S:S*prob;

        /calculate the pay off which is max(S-K,0)
        /here we demonstrate the use of | function
        S:S|0#n;

        /finally we sum up our numbers and do discounting
        /here instead of using SUM, we demontrate the use of adverb /
        S:0+/S;
        S:S*exp[neg[rF]*T];
        :S
        }
