
// initialise variable
var ws,syms = document.getElementById("selectSymsList"),
        positionTbl = document.getElementById("tblPosition");

function connect(){
   if ("WebSocket" in window) {
        ws = new WebSocket("ws://localhost:5011");
        ws.binaryType = 'arraybuffer'; // using serialisation
        ws.onopen=function(e){
        // on successful connection,
//      alert("Successful conn");
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

function filterSyms(data){
        ws.send(serialize(['filterSyms',data]));
}

function getSyms(data){
        syms.innerHTML = '';
        for (var i = 0 ; i<data.length ; i++) {
                syms.innerHTML += '<option value="'
                + data[i] + '">' + data[i] + '</option>';
        };
}

function getPosition(data) {
        positionTbl.innerHTML = tableBuilder(data);

        var arr = pnlArrayBuilder(data);
        var chartData = google.visualization.arrayToDataTable(arr);
        var options = {
          title: 'PnL Performance',
          vAxis: {title: 'Symbol',  titleTextStyle: {color: 'red'}}
        };
        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        chart.draw(chartData, options);

        var arr2 = prcArrayBuilder(data);
        var chartData2 = google.visualization.arrayToDataTable(arr2);
        var options2 = {
          title: 'realizedPnl',
          vAxis: {title: 'Symbol',  titleTextStyle: {color: 'red'}}
        };

        var chart2 = new google.visualization.BarChart(document.getElementById('chart2_div'));
        chart2.draw(chartData2, options2);

}

function prcArrayBuilder(data) {
        var arr = [["sym","realizedPnl"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("sym"===x || "realizedPnl"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}

function pnlArrayBuilder(data) {
        //parse array of objects into 2 dim array suitable for google chart.
        var arr = [["sym","pnl"]];

        //next, we push the data.
        for (var i = 0; i < data.length; i++) {
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("sym"===x || "pnl"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}

function tableBuilder(data) {
        // parse array of objects into HTML table
        var t = '<tr class=\"ui-widget-header\">'
        for (var x in data[0]) {
                t += '<th>' + x + '</th>';
        }

        t += '</tr>';
        for (var i = 0; i < data.length; i++) {
                t += '<tr>';
                for (var x in data[0]) {
                        if("pnl"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">' ;
                        } else if ("pnl"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else if ("lPriceChg"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">+' ;
                        } else if ("lPriceChg"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else if ("lPriceChgPct"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">+' ;
                        } else if ("lPriceChgPct"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else if ("pos"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">+' ;
                        } else if ("pos"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else if ("realizedPnl"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">+' ;
                        } else if ("realizedPnl"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else {
                                t += '<td style=\"color:black\">' ;
                        }

                        t +=
                        
                      (("time" === x) ? data[i][x].toLocaleTimeString().slice(0,-3) : ("number" == typeof data[i][x]) ? data[i][x].toFixed(2) : data[i][x]);

                        if ("lPriceChgPct"===x){
                                t += '%' ;
                        } else if ("lPriceChgPct"===x){
                                t += '%' ;
                        } else {
                                t += '' ;
                        }

                        t+= '</td>';
                }
        t += '</tr>';
        }
        return t ;

}
