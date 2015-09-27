
ccydat: select currency:sym, fxRate:prevClose from productDataTbl where exchange in (`CCY);

insert[`fxTbl; ccydat];
