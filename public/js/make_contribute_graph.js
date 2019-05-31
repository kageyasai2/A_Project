google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawBackgroundColor);

function drawBackgroundColor() {
    var data = new google.visualization.DataTable();

    data.addColumn('number', '日');
    data.addColumn('number', '貢献度');

    data.addRows(gon.daily_contributes) // Sinatraから値を持ってきている

    var options = {
      hAxis: {
        title:'日'
      },
      vAxis: {
        title: '貢献度'
      },
      backgroundColor: '#f1f8e9'
    };

    var chart = new google.visualization.LineChart(document.getElementById('monthly_contirbutes_graph'));
    chart.draw(data, options);
}

