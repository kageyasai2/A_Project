google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(drawBasic);

function drawBasic() {

  var data = new google.visualization.DataTable();
  data.addColumn('number', '日付');
  data.addColumn('number', '死者数(人)');
  var number_list = [[1,10],[2,44],[3,9]];
  for (var item = 0; item < number_list.length; item++){
    data.addRow(
      [number_list[item][0],number_list[item][1]]
    );
  }
  var options = {
    title: 'Death Graph',
    hAxis: {
      title: '日'
    },
    vAxis: {
      title: '死者数'
    },
    colors: ['#800000']
  };
  var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
  chart.draw(data, options);
}
