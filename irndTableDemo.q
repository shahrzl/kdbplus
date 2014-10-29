/A demo using our implied risk neutral distribution function in q-sql query

\l irnd.q

/set http port. We can check our calc result via web browser.
\p 5053

kTbl:([] K:`int$();Kplus:`int$();Kminus:`int$())
`kTbl insert (K;Kplus;Kminus)
ivTbl: select K,Kplus,Kminus,iv: ivFitted[K],ivplus:ivFitted[Kplus],ivminus:ivFitted[Kminus] from kTbl
prcTbl: select K,prc:callPrc[S0;K;T;rF;iv],prcPlus:callPrc[S0;Kplus;T;rF;ivplus],prcMinus:callPrc[S0;Kminus;T;rF;ivminus] from ivTbl
irndTbl:select K,pdf:impliedPDF[prc;prcPlus;prcMinus;rF;T;dS] from prcTbl

/Save our result into csv, so that we plot using excel later.
save `:irndTbl.csv
