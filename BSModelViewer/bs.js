
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

function calcGreeks(strike, mat, rate, vol) {

        console.log([strike,mat,rate,vol]);
        ws.send( serialize(['calcGreeks',[strike,mat,rate,vol]]));

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
        
        var arr_gamma = gammaArrayBuilder(data);
        var gammaChartData = google.visualization.arrayToDataTable(arr_gamma);

        var options_gamma = {
          title: 'Gamma',
          curveType: 'function',
          legend: { position: 'bottom' }
        };
        var chart_gamma = new google.visualization.LineChart(document.getElementById('gamma_chart_div'));
        chart_gamma.draw(gammaChartData, options_vega);


        var arr_vega = vegaArrayBuilder(data);
        var vegaChartData = google.visualization.arrayToDataTable(arr_vega);

        var options_vega = {
          title: 'Vega',
          curveType: 'function',
          legend: { position: 'bottom' }
        };
        var chart_vega = new google.visualization.LineChart(document.getElementById('vega_chart_div'));
        chart_vega.draw(vegaChartData, options_vega);

        var arr_theta = thetaArrayBuilder(data);
        var thetaChartData = google.visualization.arrayToDataTable(arr_theta);

        var options_theta = {
          title: 'Theta',
          curveType: 'function',
          legend: { position: 'bottom' }
        };
        var chart_theta = new google.visualization.LineChart(document.getElementById('theta_chart_div'));
        chart_theta.draw(thetaChartData, options_theta);
        
        var arr_rho = rhoArrayBuilder(data);
        var rhoChartData = google.visualization.arrayToDataTable(arr_rho);

        var options_rho = {
          title: 'Rho',
          curveType: 'function',
          legend: { position: 'bottom' }
        };
        var chart_rho = new google.visualization.LineChart(document.getElementById('rho_chart_div'));
        chart_rho.draw(rhoChartData, options_rho);

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

function gammaArrayBuilder(data) {
        var arr=[["Price","Gamma"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("S"===x || "Gamma"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;

}

function vegaArrayBuilder(data) {
        var arr=[["Price","Vega"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("S"===x || "Vega"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;

}

function thetaArrayBuilder(data) {
        var arr=[["Price","Theta"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("S"===x || "Theta"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}

function rhoArrayBuilder(data) {
        var arr=[["Price","Rho"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("S"===x || "Rho"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}
