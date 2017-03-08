// google.charts.load("current", { packages: ["corechart"] });

google.charts.load("current", {
    packages: ["bar"]
});

google.charts.setOnLoadCallback(drawChart);

function generateOptions(subtitle) {
    return {
        chart: {
            title: 'Group Level Cache Status:',
            subtitle: subtitle
        },
        axes: {
            y: {
                0: {
                    label: 'percentage (%)'
                }
            }
        }
    }
};

function drawChart() {
    var data = google.visualization.arrayToDataTable([
        ['Partition Size (MB)', 'Partition Table', 'Partition Busy', 'Partition Used', 'Partition Free', 'Partition Overhead'],
        ['512', 1.6, 0, 93.7, 6.3, 0],
        ['256', 1.6, 0, 43.7, 6.3, 0]
    ]);

    //is3D: true,


    //var chart = new google.visualization.PieChart(document.getElementById('piechart_3d'));
    var compressedTreeChart = new google.charts.Bar(document.getElementById('ctc'));
    var expandedTreeChart = new google.charts.Bar(document.getElementById('etc'));
    var listCacheChart = new google.charts.Bar(document.getElementById('lc'));

    compressedTreeChart.draw(data, generateOptions("Compressed Tree Cache"));
    expandedTreeChart.draw(data, generateOptions("Expanded Tree Cache"));
    listCacheChart.draw(data, generateOptions("List Cache"));
};