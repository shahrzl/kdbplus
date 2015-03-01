
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
                ws.send(serialize(['getImpliedDist', [60.0,0.9,0.0011,0.2] ]));
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

function drawChart(data) {
        var arr = pdfArrayBuilder(data);

        var pdfChartData = google.visualization.arrayToDataTable(arr);

        var options = {
          title: 'Implied Risk Neutral Dist',
          curveType: 'function',
          legend: { position: 'bottom' }
        };
        var chart = new google.visualization.LineChart(document.getElementById('pdf_chart_div'));
        chart.draw(pdfChartData, options);

}

function pdfArrayBuilder(data) {
        var arr=[["Strike","PDF"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("K"===x || "pdf"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}
