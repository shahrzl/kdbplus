//Initialize variable
var wsExec;

function connectExecSvc(){
        if ("WebSocket" in window) {
        wsExec = new WebSocket("ws://localhost:5013");
        wsExec.binaryType = 'arraybuffer'; // using serialisation
        wsExec.onopen=function(e){
        // on successful connection,
                //ws.send(serialize(['loadPage',[]]));
                console.log("Successful connection");
        };
        wsExec.onclose=function(e){console.log("disconnected");};
        wsExec.onmessage=function(e){
                // deserialise incoming messages
                var d =  deserialize(e.data);
                // messages should have format [‘function’,params]
                // call the function name with the parameters
                //window[d.shift()](d[0]);
        };
        wsExec.onerror=function(e){console.log(e.data);};
        }
        else alert("WebSockets not supported on your browser.");

}


function enterTrade(){
        var symVal=document.getElementById("symbol").value;
        var accVal=document.getElementById("account").value;
        var trdVal=document.getElementById("trader").value;
        var side="S";
        if(document.getElementById("buy").checked) { side="B";}
        var qty = document.getElementById("quantity").value;
        var dVal= document.getElementById("dollar").value;

        //validate user entered values.
        if(symVal == null || symVal == ""){alert("Symbol is a required field.");return false;}
        else if(accVal == null || accVal == ""){alert("Account is a required field.");return false;}
        else if(trdVal == null || trdVal =="" ){alert("Trader is a required field.");return false;}
        else if(side == null || side == ""){alert("Side is a required field.");return false;}
        else if(qty == null || qty == ""){alert("Quantity is a required field.");return false;}
        else if(dVal == null || dVal == ""){alert("Price is a required field.");return false;}
        else{ }

        //validate numeric values
        if(isNaN(parseFloat(qty))){alert("Quantity must be numeric.");return false;}
        else if(isNaN(parseFloat(dVal))){alert("Price must be numeric.");return false;}
        else{}

        var arr=[];
        arr.push(accVal);
        arr.push(symVal);
        arr.push(trdVal);
        arr.push(side);
        arr.push(parseInt(qty));
        arr.push(parseFloat(dVal));

        console.log(arr);
        wsExec.send( serialize(['enterTrade',arr]));
        return true;
}

