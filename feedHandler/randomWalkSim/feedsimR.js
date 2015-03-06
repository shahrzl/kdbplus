
// Variables
var ws;

function connect(){
   if ("WebSocket" in window) {
        ws = new WebSocket("ws://localhost:5023");
        ws.binaryType = 'arraybuffer'; // using serialisation
        ws.onopen=function(e){
        // on successful connection,
        //we want to create an initial subscription to load all the data into the page
                console.log("Connected.");
                ws.send(serialize(['loadPage', [] ]));
        };
        ws.onclose=function(e){console.log("Disconnected");};
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

function getTrades(data) {
        var arr = arrayBuilder(data);

        var chartData = google.visualization.arrayToDataTable(arr);

        var options = {
                title: 'Share price',
                legend: { position: 'bottom' }
        };

        var chart = new google.visualization.LineChart(document.getElementById('price_chart_div'));

        chart.draw(chartData, options);
}

function arrayBuilder(data) {
        var arr=[["Time","Price"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("time"===x || "price"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}
