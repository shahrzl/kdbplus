// Variables
var ws;

function connect(){
   if ("WebSocket" in window) {
        ws = new WebSocket("ws://localhost:5025");
        ws.binaryType = 'arraybuffer'; // using serialisation
        ws.onopen=function(e){
        // on successful connection,
        //we want to create an initial subscription to load all the data into the page
                console.log("Connected.");
                ws.send(serialize(['getData', [] ]));
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
        var arr = nrArrayBuilder(data);

        var nrChartData = google.visualization.arrayToDataTable(arr);

        var options = {
          title: 'Implied Volatility vs Strike Price',
          hAxis: {title: 'Strike Price'},
          vAxis: {title: 'IV'},
          legend: { position: 'bottom' }
        };

        var chart = new google.visualization.ScatterChart(document.getElementById('nr_chart_div'));
        chart.draw(nrChartData, options);

//Next, create chart for Excel Data

        var xl_arr = xlArrayBuilder(data);

        var xlChartData = google.visualization.arrayToDataTable(xl_arr);

        var xl_chart = new google.visualization.ScatterChart(document.getElementById('excel_chart_div'));
        xl_chart.draw(xlChartData, options);

}

function nrArrayBuilder(data) {
        var arr=[["Strike","IV"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("Strike"===x || "IV"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}

function xlArrayBuilder(data) {
        var arr=[["Strike","IV"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("Strike"===x || "ImpliedVol"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}
