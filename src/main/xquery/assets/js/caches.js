// google.charts.load("current", { packages: ["corechart"] });
google.charts.load("current", { packages: ["bar"] });
google.charts.setOnLoadCallback(drawChart);
function drawChart() {
    var data = google.visualization.arrayToDataTable([
        ['Partition Size (MB)', 'Partition Table', 'Partition Busy', 'Partition Used', 'Partition Free', 'Partition Overhead'],
        ['512', 1.6, 0, 93.7, 6.3, 0],
        ['512', 1.6, 0, 93.7, 6.3, 0]
    ]);

    var options = {
        chart: {
            title: 'Group Level Cache Status',
            subtitle: 'Compressed Tree Cache'
        },
        axes: {
            y: {
                0: { label: 'percentage (%)' }
            }
        }
        //is3D: true,
    };

    //var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
    var chart = new google.charts.Bar(document.getElementById('ctc'));
    chart.draw(data, options);
}