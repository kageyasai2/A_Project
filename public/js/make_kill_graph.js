google.charts.load('current', {packages: ['corechart', 'line']});
google.charts.setOnLoadCallback(draw_daily_kill_graph);
google.charts.setOnLoadCallback(draw_monthly_kill_graph);

function draw_daily_kill_graph() {
    let data = new google.visualization.DataTable();

    data.addColumn('number', '日付');
    data.addColumn('number', '殺害数(人)');
    data.addRows(gon.daily_kill_retios); // Sinatraから値を持ってきている

    let options = {
        title: '殺害グラフ(日毎)',
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

    data.addColumn('number', '日付');
    data.addColumn('number', '殺害数(人)');
    data.addRows(gon.monthly_kill_retios); // Sinatraから値を持ってきている

    let options = {
        title: '殺害グラフ(月毎)',
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
