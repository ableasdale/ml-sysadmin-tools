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
}

function genData(objs, mode) {
    var cacheItems = [];

    if (mode === 7) {
        cacheItems.push(['Partition Size (MB)', 'Partition Busy', 'Partition Used', 'Partition Free','Value Count', 'Value Bytes Total', 'Value Bytes Average']);
    } else if (mode === 6) {
        cacheItems.push(['Partition Size (MB)', 'Partition Table', 'Partition Busy','Partition Used', 'Partition Free', 'Partition Overhead']);
    } else if (mode === 5) {
        cacheItems.push(['Partition Size (MB)', 'Partition Table', 'Partition Used', 'Partition Free', 'Partition Overhead']);
    } else {
        cacheItems.push(['Partition Size (MB)', 'Partition Busy', 'Partition Used', 'Partition Free']);
    }

    for (var index in objs) {
        var tagsArray = objs[index];
        cacheItems.push(tagsArray);
    }
    return cacheItems;
}

function drawChart() {
    var tc = document.getElementById('cache-data').textContent;
    var objsCTC = JSON.parse(tc).compressedTreeCachePartitions.map(o => Object.values(o));
    var objsETC = JSON.parse(tc).expandedTreeCachePartitions.map(o => Object.values(o));
    var objsLC = JSON.parse(tc).expandedTreeCachePartitions.map(o => Object.values(o));
    var objsTC = JSON.parse(tc).tripleCache.tripleCachePartitions.map(o => Object.values(o));
    var objsTVC = JSON.parse(tc).tripleValueCache.tripleValueCachePartitions.map(o => Object.values(o));

    var dataCTC = google.visualization.arrayToDataTable(genData(objsCTC, 5));
    var dataETC = google.visualization.arrayToDataTable(genData(objsETC, 6));
    var dataLC = google.visualization.arrayToDataTable(genData(objsLC, 6));
    var dataTC = google.visualization.arrayToDataTable(genData(objsTC, 0));
    var dataTVC = google.visualization.arrayToDataTable(genData(objsTVC, 7));

    var compressedTreeChart = new google.charts.Bar(document.getElementById('ctc'));
    var expandedTreeChart = new google.charts.Bar(document.getElementById('etc'));
    var listCacheChart = new google.charts.Bar(document.getElementById('lc'));
    var tripleCacheChart = new google.charts.Bar(document.getElementById('tc'));
    var tripleValueCacheChart = new google.charts.Bar(document.getElementById('tvc'));

    compressedTreeChart.draw(dataCTC, generateOptions("Compressed Tree Cache ["+objsCTC.length+" partition(s)]"));
    expandedTreeChart.draw(dataETC, generateOptions("Expanded Tree Cache ["+objsETC.length+" partition(s)]"));
    listCacheChart.draw(dataLC, generateOptions("List Cache ["+objsLC.length+" partition(s)]"));
    tripleCacheChart.draw(dataTC, generateOptions("Triple Cache ["+objsTC.length+" partition(s)]"));
    tripleValueCacheChart.draw(dataTVC, generateOptions("Triple Value Cache ["+objsTVC.length+" partition(s)]"));
}