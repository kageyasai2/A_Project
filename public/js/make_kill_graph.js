google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(draw_daily_kill_graph);
google.charts.setOnLoadCallback(draw_monthly_kill_graph);
function draw_daily_kill_graph() {

  let data = new google.visualization.DataTable();
  data.addColumn('number', '日付');
  data.addColumn('number', '死者数(人)');
  for (let item = 0; item < gon.daily_kill_retios.length; item++){
    data.addRow(
      gon.daily_kill_retios[item]
    );
  }
  let options = {
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

function draw_monthly_kill_graph() {

  let data = new google.visualization.DataTable();
  data.addColumn('number', '月');
  data.addColumn('number', '死者数');
  for (let item = 0; item < gon.monthly_kill_retios.length; item++){
    data.addRow(
      gon.monthly_kill_retios[item]
    );
  }
  let options = {
    title: 'monthly kill graph',
    hAxis: {
      title: '月'
    },
    vAxis: {
      title: '死者数'
    },
    colors: ['#800000']
  };
  let chart = new google.visualization.LineChart(document.getElementById('monthly_chart_div'));
  chart.draw(data, options);
}