google.charts.load('current', {packages: ['corechart', 'line']});
if(document.getElementById('daily_contirbutes_graph') != null) {
    google.charts.setOnLoadCallback(() => drawContributesGraph({ isDaily: true }));
}
if(document.getElementById('monthly_contirbutes_graph') != null) {
    google.charts.setOnLoadCallback(() => drawContributesGraph({ isDaily: false }));
}

// gonを使いSinatraから値を持ってきて、日毎、月毎のグラフを表示する
function drawContributesGraph({ isDaily }) {
    var data = new google.visualization.DataTable();

    data.addColumn('number', '日付');
    data.addColumn('number', '貢献度');

    let chart, hTitle;
    if(isDaily) {
        hTitle = '日';
        data.addRows(gon.daily_contributes)
        chart = new google.visualization.LineChart(document.getElementById('daily_contirbutes_graph'));
    } else {
        hTitle = '月';
        data.addRows(gon.monthly_contributes)
        chart = new google.visualization.LineChart(document.getElementById('monthly_contirbutes_graph'));
    }

    var options = {
      hAxis: {
        title: hTitle
      },
      vAxis: {
        title: '貢献度'
      },
      backgroundColor: '#f1f8e9'
    };

    chart.draw(data, options);
}

