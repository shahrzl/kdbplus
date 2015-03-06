

/Use to test our random walk simulator.

\p 5023

/----Ticker plant related procedures------

if[not "w"=first string .z.o;system "sleep 1"];

upd:{[tbl;data]
        insert[tbl;data];
        }

/ get the ticker plant and history ports, defaults are 5010,5012
.u.x:.z.x,(count .z.x)_(":5010";":5012");

.u.rep:{0N!x;0N!y;(.[;();:;].)each x}

/---tp related procedures end here---

/Subscribe to tickerplant
(hopen `$":",.u.x 0)".u.sub[`trade;`]";

/-----------Web Socket functionality-------------

.z.ws:{
        0N!`Connecting;
        value -9!x;
        }

// subs table to keep track of current subscriptions
subs:2!flip `handle`func`params`curData!"is**"$\:()

//publish function

// pubsub functions
sub:{`subs upsert (.z.w;x;y;res:eval(x;enlist y));(x;res)}
pub:{neg[x] -8!y}
pubsub:{pub[.z.w] eval(sub[x];enlist y)}
.z.pc: {delete from `subs where handle=x}

//functions to be called through web socket.

loadPage:{0N!`$"Loading page"; pubsub[;`$x]each enlist `getTrades}

getTrades:{
        res: select from trade where sym=`GOOG;
        :res
        }

// refresh function - publishes data if changes exist, and updates subs
refresh:{
        update curData:{[h;f;p;c] if[not c~d:eval(f;enlist p);pub[h] (f;d)]; d }'[handle;func;params;curData] from `subs
        }

// trigger refresh every 100ms
.z.ts:{refresh[]}

\t 1000
