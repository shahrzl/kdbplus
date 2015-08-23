// initialise variable
var ws,syms = document.getElementById("selectSymsList"),
        positionTbl = document.getElementById("tblPosition"),
        quoteTbl = document.getElementById("tblQuote"),
        pnlByAccountTbl = document.getElementById("tblPnLByAccount");

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

function getChart(data){
        ws.send(serialize(['getChart',data]));
}

function getChartData(data) {
        var arr = chartArrayBuilder(data);
        //console.log(arr);
        var chartData = google.visualization.arrayToDataTable(arr);

        var options = {
                title: 'Live Data',
                legend: { position: 'bottom' }
        };

        var chart = new google.visualization.LineChart(document.getElementById('price_chart_div'));

        chart.draw(chartData, options);
}

function chartArrayBuilder(data) {
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

function getSyms(data){
        syms.innerHTML = '';
        for (var i = 0 ; i<data.length ; i++) {
                syms.innerHTML += '<option value="'
                + data[i] + '">' + data[i] + '</option>';
        };
}

//For auto complete function
function getSymsAutoComplete(data){
        console.log(data);
        window.status = "Syms loaded.";

        $( "#symbol" ).autocomplete({
              source: data
        });
}

function getPosition(data) {
        positionTbl.innerHTML = tableBuilder(data);

        var arr = pnlArrayBuilder(data);
        var chartData = google.visualization.arrayToDataTable(arr);
        var options = {
          title: 'PnL',
          vAxis: {title: 'Symbol',  titleTextStyle: {color: 'red'}}
        };
        var chart = new google.visualization.BarChart(document.getElementById('chart_div'));
        chart.draw(chartData, options);

        var arr2 = prcArrayBuilder(data);
        var chartData2 = google.visualization.arrayToDataTable(arr2);
        var options2 = {
          title: 'Realized PnL',
          vAxis: {title: 'Symbol',  titleTextStyle: {color: 'red'}}
        };

        var chart2 = new google.visualization.BarChart(document.getElementById('chart2_div'));
        chart2.draw(chartData2, options2);

}

function getPnlByAccount(data) {
        //console.log(data);
        pnlByAccountTbl.innerHTML = pnlTableBuilder(data);

        //Create chart
        var arr = pnlBAArrayBuilder(data);
        var chartData = google.visualization.arrayToDataTable(arr);
        var options = {
          title: 'PnL',
          vAxis: {title: 'Account',  titleTextStyle: {color: 'red'}}
        };
        var chart = new google.visualization.BarChart(document.getElementById('chart21_div'));
        chart.draw(chartData, options);

        var arr2 = realizedPnlBAArrayBuilder(data);
        var chartData2 = google.visualization.arrayToDataTable(arr2);
        var options2 = {
          title: 'Realized PnL',
          vAxis: {title: 'Account',  titleTextStyle: {color: 'red'}}
        };

        var chart2 = new google.visualization.BarChart(document.getElementById('chart22_div'));
        chart2.draw(chartData2, options2);
}

//Build array for pnl by account chart
function pnlBAArrayBuilder(data) {
        var arr = [["Account","Pnl"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("account"===x || "pnl"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
}

//Build array for realizedPnl by account chart
function realizedPnlBAArrayBuilder(data) {
        var arr = [["Account","realizedPnl"]];

        for (var i = 0; i < data.length; i++) {
                //console.log(data.length);
                var dat = [];
                for (var x in data[0]) {
                        //push data
                        if("account"===x || "realizedPnl"===x ){
                                dat.push(data[i][x]);
                        }
                }
                arr.push(dat);
        }

        return arr;
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

//getQUote
function getQuote(data) {
        //console.log(data);
        quoteTbl.innerHTML = quoteTableBuilder(data);
}

function quoteTableBuilder(data) {
        // parse array of objects into HTML table
        var t = '<tr class=\"ui-widget-header\">'
        for (var x in data[0]) {
                t += '<th>' + x + '</th>';
        }

        t += '</tr>';
        for (var i = 0; i < data.length; i++) {
                t += '<tr>';
                for (var x in data[0]) {
                        if("change"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">' ;
                        } else if ("change"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else if("changePct"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">' ;
                        } else if ("changePct"===x && data[i][x]<0){
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
                        } else if ("changePct"===x){
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

function pnlTableBuilder(data) {
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
                        } else if("realizedPnl"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">' ;
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
                        } else if ("pctPriceChg"===x){
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
                        } else if ("priceChg"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">+' ;
                        } else if ("priceChg"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else if ("pctPriceChg"===x && data[i][x]>=0){
                                t += '<td style=\"color:green\">+' ;
                        } else if ("pctPriceChg"===x && data[i][x]<0){
                                t += '<td style=\"color:red\">' ;
                        } else {
                                t += '<td style=\"color:black\">' ;
                        }

                        t +=

                        //(("time" === x) ? data[i][x].toLocaleTimeString().slice(0,-3) : ("number" == typeof data[i][x]) ? data[i][x].toFixed(2) : data[i][x]);
                        (("time" === x) ? data[i][x].toLocaleTimeString().slice(0,-3) : ("number" == typeof data[i][x]) ? (("fxRate"==x)?data[i][x].toFixed(4) : data[i][x].toFixed(2)) : data[i][x]);
                        if ("lPriceChgPct"===x){
                                t += '%' ;
                        } else if ("lPriceChgPct"===x){
                                t += '%' ;
                        } else if ("pctPriceChg"===x){
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
