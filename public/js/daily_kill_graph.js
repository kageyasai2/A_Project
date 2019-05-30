google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawBasic);

function drawBasic() {

  var data = new google.visualization.DataTable();
  data.addColumn('number', '日付');
  data.addColumn('number', '死者数(人)');
  for (var item = 0; item < gon.daily_kill_retios.length; item++){
    data.addRow(
      [gon.daily_kill_retios[item][0],gon.daily_kill_retios[item][1]]
    );
  }
  var options = {
    title: 'daily kill graph',
    hAxis: {
      title: '日'
    },
    vAxis: {
      title: '死者数'
    },
    colors: ['#800000']
  };
  var chart = new google.visualization.LineChart(document.getElementById('daily_chart_div'));
  chart.draw(data, options);
}
