google.charts.load("current", {
    packages: ["corechart", "bar"]
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

function genData(objs, mode) {
    var cacheItems = [];

    if (mode === 6){
        cacheItems.push(['Partition Size (MB)', 'Partition Table', 'Partition Busy','Partition Used', 'Partition Free', 'Partition Overhead']);
    } else {
        cacheItems.push(['Partition Size (MB)', 'Partition Table', 'Partition Used', 'Partition Free', 'Partition Overhead']);
    }

    for (var index in objs) {
        var tagsArray = objs[index];
        cacheItems.push(tagsArray);
    }
    return cacheItems;
};

function drawChart() {
    var tc = document.getElementById('data').textContent;
    var objsCTC = JSON.parse(tc).compressedTreeCachePartitions.map(o => Object.values(o));
    var objsETC = JSON.parse(tc).expandedTreeCachePartitions.map(o => Object.values(o));
    var objsLC = JSON.parse(tc).expandedTreeCachePartitions.map(o => Object.values(o));

    var dataCTC = google.visualization.arrayToDataTable(genData(objsCTC, 0));
    var dataETC = google.visualization.arrayToDataTable(genData(objsETC, 6));
    var dataLC = google.visualization.arrayToDataTable(genData(objsLC, 6));

    var compressedTreeChart = new google.charts.Bar(document.getElementById('ctc'));
    var expandedTreeChart = new google.charts.Bar(document.getElementById('etc'));
    var listCacheChart = new google.charts.Bar(document.getElementById('lc'));

    compressedTreeChart.draw(dataCTC, generateOptions("Compressed Tree Cache"));
    expandedTreeChart.draw(dataETC, generateOptions("Expanded Tree Cache"));
    listCacheChart.draw(dataLC, generateOptions("List Cache"));
};