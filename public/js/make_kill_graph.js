google.charts.load('current', {packages: ['corechart', 'line']});
if(document.getElementById('daily_kill_retios_graph') != null) {
    google.charts.setOnLoadCallback(() => drawKillRetiosGraph({ isDaily: true }));
}
if(document.getElementById('monthly_kill_retios_graph') != null) {
    google.charts.setOnLoadCallback(() => drawKillRetiosGraph({ isDaily: false }));
}

function drawKillRetiosGraph({ isDaily }) {
    let data = new google.visualization.DataTable();

    data.addColumn('number', '日付');
    data.addColumn('number', '殺害数(人)');

    let chart, hTitle;
    if(isDaily) {
        hTitle = '日';
        data.addRows(gon.daily_kill_retios);
        chart = new google.visualization.LineChart(document.getElementById('daily_kill_retios_graph'));
    } else {
        hTitle = '月';
        data.addRows(gon.monthly_kill_retios);
        chart = new google.visualization.LineChart(document.getElementById('monthly_kill_retios_graph'));
    }

    let options = {
        title: '殺害グラフ(日毎)',
        hAxis: {
          title: hTitle
        },
        vAxis: {
          title: '死者数'
        },
        colors: ['#800000']
    };

    chart.draw(data, options);
}
