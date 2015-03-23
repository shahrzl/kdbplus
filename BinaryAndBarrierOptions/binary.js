
// initialise variable
var ws,ntTbl = document.getElementById("ntTbl"),
        hTbl = document.getElementById("hTbl");

function connect(){
   if ("WebSocket" in window) {
        ws = new WebSocket("ws://localhost:5027");
        ws.binaryType = 'arraybuffer'; // using serialisation
        ws.onopen=function(e){
        // on successful connection,
        console.log("Successful conn");
        //we want to create an initial subscription to load all the data into the page
                ws.send(serialize(['loadPage',[]]));
        };
        ws.onclose=function(e){console.log("disconnected");};
        ws.onmessage=function(e){
                // deserialise incoming messages
                var d =  deserialize(e.data);
                // messages should have format [‘function’,params]
                // call the function name with the parameters
                window[d.shift()](d[0]);
        };
        ws.onerror=function(e){console.log(e.data);};
        }
        else alert("WebSockets not supported on your browser.");

}

function getHigher(data) {
        console.log(data);
        hTbl.innerHTML = tableBuilder(data);
}

function getNoTouch(data) {
        console.log(data);
        ntTbl.innerHTML = tableBuilder(data);
}

function tableBuilder(data) {
        console.log("Building Table");
        // parse array of objects into HTML table
        var t = '<tr>'
        for (var x in data[0]) {
                t += '<th>' + x + '</th>';
        }
        t += '</tr>';
        for (var i = 0; i < data.length; i++) {
                t += '<tr>';
                for (var x in data[0]) {
                t += '<td>' + (("time" === x) ? data[i][x].toLocaleTimeString().slice(0,-3) : ("number" == typeof data[i][x]) ? data[i][x] : data[i][x]) + '</td>';
                }
                t += '</tr>';
        }
        return t ;
}

