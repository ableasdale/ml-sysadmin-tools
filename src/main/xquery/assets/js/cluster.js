/**
 * Created by ableasdale on 02/03/2016.
 */

/* current code for default.xqy */
//http://joshbranchaud.com/blog/2014/06/06/Getting-Started-With-D3js-In-121-Seconds.html
// http://projects.delimited.io/experiments/csv-json/
// https://bl.ocks.org/mbostock/3151318
// http://bl.ocks.org/mbostock/3151228
// http://bl.ocks.org/dbuezas/9306799
// http://jsfiddle.net/5PENv/
// http://bl.ocks.org/Guerino1/2295263

$(document).ready(function () {

    var width = 700, height = 650, radius = 130;
    var jsonData;
    d3.json("/ws/cluster-overview.xqy", function (error, data) {
        //if (error) return console.warn(error);
        jsonData = data;
        doUpdate(data);
    });


    // .range(['#74E600', '#26527C', '#61D7A4', '#6CAC2B', '#408AD2', '#218359', '#36D792', '#679ED2', '#B0F26D', '#4B9500', '#98F23D', '#04396C', '#007241']);
    // debug console.dir(d3.select("div#overview").append('p').text('DO we ever see this text?'));

    //var length = 100;
    //var color = d3.scale.linear().domain([1,length]).interpolate(d3.interpolateHcl).range([d3.rgb("#007AFF"), d3.rgb('#FFF500')]);
    var color = d3.scale.category20c();

    var svg = d3.select("div#overview").append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height * .52 + ")");


    var partition = d3.layout.partition()
        .sort(null)
        .size([2 * Math.PI, radius * radius])
        .value(function (d) {
            return d.documents;
        });

    var arc = d3.svg.arc()
        .startAngle(function (d) {
            return d.x;
        })
        .endAngle(function (d) {
            return d.x + d.dx;
        })
        .innerRadius(function (d) {
            return Math.sqrt(d.y);
        })
        .outerRadius(function (d) {
            // make the outer part a larger area
            return Math.sqrt(d.y + d.dy * 20);
        });




    function doUpdate(myData) {
        svg.datum(myData).selectAll("path")
            .data(partition.nodes)
            .enter().append("path")
            .attr("display", function (d) {
                return d.depth ? null : "none";
            }) // hide inner ring
            .attr("d", arc)

            .attr("class", function (d) {
                return (d.children ? d : d.parent).name;
            })
            .on("mouseover", function (d) {
                //console.dir(d);
                d3.select("#tooltip")
                    .style("left", d3.event.pageX + "px")
                    .style("top", d3.event.pageY + "px")
                    .classed("hidden", false)
                    .append("h4").text(d.name)
                    .append("p").text(d.value.toLocaleString('en') + " Documents");
                if (d.disksize) { d3.select("#tooltip").append("p").text("Size on disk: " + d.disksize + "MB") }
            })
            .on("mouseout", function () {
                // Hide the tooltip
                d3.select("#tooltip")
                    .html("")
                    .classed("hidden", true);
            })
            .style("stroke", "#ddd")
            .style("fill", function (d) {
                return color((d.children ? d : d.parent).name);
            })
            .style("fill-rule", "inherit");
    }

    /* This is a bit funky right now - I have to load the JSON and call this twice (first is below and the second is when we get the data
     if we don't have both, nothing is displayed).
     in order for it to work - TODO - figure out how to do this properly and fix it! */
    var path = doUpdate(jsonData);

    var svg2 = d3.select("div#overview").append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
    //Create an SVG text element and append a textPath element
    svg2.parentNode.appendChild("text")
        .append("textPath") //append a textPath to the text element
        .attr("xlink:href", "#wavy") //place the ID of the path here
        .style("text-anchor", "middle") //place the text halfway on the arc
        .attr("startOffset", "50%")
        .text("3 hosts in current cluster");
});
/* end current code for default.xqy */