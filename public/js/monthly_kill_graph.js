google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawBasic);

function drawBasic() {

  var data = new google.visualization.DataTable();
  data.addColumn('number', '月');
  data.addColumn('number', '死者数');
  for (var item = 0; item < gon.monthly_kill_retios.length; item++){
    data.addRow(
      [gon.monthly_kill_retios[item][0],gon.monthly_kill_retios[item][1]]
    );
  }
  var options = {
    title: 'monthly kill graph',
    hAxis: {
      title: '月'
    },
    vAxis: {
      title: '死者数'
    },
    colors: ['#800000']
  };
  var chart = new google.visualization.LineChart(document.getElementById('monthly_chart_div'));
  chart.draw(data, options);
}
