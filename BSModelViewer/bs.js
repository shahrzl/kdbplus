
/ Variables
var ws;

function connect(){
   if ("WebSocket" in window) {
        ws = new WebSocket("ws://localhost:5021");
        ws.binaryType = 'arraybuffer'; // using serialisation
        ws.onopen=function(e){
        // on successful connection,
        //we want to create an initial subscription to load all the data into the page
                ws.send(serialize(['calcGreeks', [60.0,0.9,0.0011,0.2] ]));
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

function drawChart(data) {
        var arr = deltaArrayBuilder(data);

        var deltaChartData = google.visualization.arrayToDataTable(arr);

        var options = {
          title: 'Delta',
          curveType: 'function',
          legend: { position: 'bottom' }
        };
        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
        chart.draw(deltaChartData, options);

}

function deltaArrayBuilder(data) {
        var arr=[["Price","Delta"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("S"===x || "Delta"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}
