// TODO - Only load JS files where needed - at the moment every page loads all JS; as these are cached, it's not a massive problem - but better not to...

$(document).ready(function () {

    /* current code for default.xqy */
    //http://joshbranchaud.com/blog/2014/06/06/Getting-Started-With-D3js-In-121-Seconds.html
    // http://projects.delimited.io/experiments/csv-json/

    //*************************************************
    // SETUP DATA VIZ
    //*************************************************
    var width = 960, height = 700, radius = 300;

    var json = {"children":[{"name":"1945","children":[{"name":"Buddhism","children":[{"year":"1945","cat":"Buddhism","type":"Other","pop":116237936}]},{"name":"Christianity","children":[{"year":"1945","cat":"Christianity","type":"Anglican","pop":36955033},{"year":"1945","cat":"Christianity","type":"Catholic","pop":391332035},{"year":"1945","cat":"Christianity","type":"Orthodox","pop":98501171},{"year":"1945","cat":"Christianity","type":"Other","pop":13674466},{"year":"1945","cat":"Christianity","type":"Mahayana","pop":160887585}]},{"name":"Islam","children":[{"year":"1945","cat":"Islam","type":"Ibadhi","pop":62273219},{"year":"1945","cat":"Islam","type":"Shia","pop":19436742},{"year":"1945","cat":"Islam","type":"Sunni","pop":49050320}]},{"name":"Judaism","children":[{"year":"1945","cat":"Judaism","type":"Conservative","pop":1426350},{"year":"1945","cat":"Judaism","type":"Orthodox","pop":856827},{"year":"1945","cat":"Judaism","type":"Other","pop":7796835},{"year":"1945","cat":"Judaism","type":"Reform","pop":1929388}]}]},{"name":"1950","children":[{"name":"Buddhism","children":[{"year":"1950","cat":"Buddhism","type":"Other","pop":144980765},{"year":"1950","cat":"Buddhism","type":"Theravada","pop":14031137}]},{"name":"Christianity","children":[{"year":"1950","cat":"Christianity","type":"Anglican","pop":38307544},{"year":"1950","cat":"Christianity","type":"Catholic","pop":401935856},{"year":"1950","cat":"Christianity","type":"Orthodox","pop":106610911},{"year":"1950","cat":"Christianity","type":"Other","pop":16324768},{"year":"1950","cat":"Christianity","type":"Mahayana","pop":133301043}]},{"name":"Islam","children":[{"year":"1950","cat":"Islam","type":"Alawite","pop":387994},{"year":"1950","cat":"Islam","type":"Ibadhi","pop":215867687},{"year":"1950","cat":"Islam","type":"Shia","pop":20944082},{"year":"1950","cat":"Islam","type":"Sunni","pop":56921304}]},{"name":"Judaism","children":[{"year":"1950","cat":"Judaism","type":"Conservative","pop":1860297},{"year":"1950","cat":"Judaism","type":"Orthodox","pop":2204231},{"year":"1950","cat":"Judaism","type":"Other","pop":7105125},{"year":"1950","cat":"Judaism","type":"Reform","pop":2528641}]}]},{"name":"1955","children":[{"name":"Buddhism","children":[{"year":"1955","cat":"Buddhism","type":"Other","pop":145861839},{"year":"1955","cat":"Buddhism","type":"Theravada","pop":33522360}]},{"name":"Christianity","children":[{"year":"1955","cat":"Christianity","type":"Anglican","pop":38177572},{"year":"1955","cat":"Christianity","type":"Catholic","pop":474378130},{"year":"1955","cat":"Christianity","type":"Orthodox","pop":111661338},{"year":"1955","cat":"Christianity","type":"Other","pop":22437724},{"year":"1955","cat":"Christianity","type":"Mahayana","pop":189347338}]},{"name":"Islam","children":[{"year":"1955","cat":"Islam","type":"Alawite","pop":445582},{"year":"1955","cat":"Islam","type":"Ibadhi","pop":240487382},{"year":"1955","cat":"Islam","type":"Shia","pop":24256503},{"year":"1955","cat":"Islam","type":"Sunni","pop":78882540}]},{"name":"Judaism","children":[{"year":"1955","cat":"Judaism","type":"Conservative","pop":1653007},{"year":"1955","cat":"Judaism","type":"Orthodox","pop":2496432},{"year":"1955","cat":"Judaism","type":"Other","pop":6611524},{"year":"1955","cat":"Judaism","type":"Reform","pop":2225241}]}]},{"name":"1960","children":[{"name":"Buddhism","children":[{"year":"1960","cat":"Buddhism","type":"Other","pop":183672909},{"year":"1960","cat":"Buddhism","type":"Theravada","pop":16766250}]},{"name":"Christianity","children":[{"year":"1960","cat":"Christianity","type":"Anglican","pop":41846700},{"year":"1960","cat":"Christianity","type":"Catholic","pop":541957872},{"year":"1960","cat":"Christianity","type":"Orthodox","pop":118268109},{"year":"1960","cat":"Christianity","type":"Other","pop":44601144},{"year":"1960","cat":"Christianity","type":"Mahayana","pop":220293770}]},{"name":"Islam","children":[{"year":"1960","cat":"Islam","type":"Alawite","pop":521848},{"year":"1960","cat":"Islam","type":"Ibadhi","pop":303101053},{"year":"1960","cat":"Islam","type":"Shia","pop":27174803},{"year":"1960","cat":"Islam","type":"Sunni","pop":104325384}]},{"name":"Judaism","children":[{"year":"1960","cat":"Judaism","type":"Conservative","pop":1716903},{"year":"1960","cat":"Judaism","type":"Orthodox","pop":2818847},{"year":"1960","cat":"Judaism","type":"Other","pop":6892701},{"year":"1960","cat":"Judaism","type":"Reform","pop":2300405}]}]},{"name":"1965","children":[{"name":"Buddhism","children":[{"year":"1965","cat":"Buddhism","type":"Other","pop":194287704},{"year":"1965","cat":"Buddhism","type":"Theravada","pop":18305680}]},{"name":"Christianity","children":[{"year":"1965","cat":"Christianity","type":"Anglican","pop":45086639},{"year":"1965","cat":"Christianity","type":"Catholic","pop":614115021},{"year":"1965","cat":"Christianity","type":"Orthodox","pop":125954494},{"year":"1965","cat":"Christianity","type":"Other","pop":55119929},{"year":"1965","cat":"Christianity","type":"Mahayana","pop":234437703}]},{"name":"Islam","children":[{"year":"1965","cat":"Islam","type":"Alawite","pop":598115},{"year":"1965","cat":"Islam","type":"Mahayana","pop":40000},{"year":"1965","cat":"Islam","type":"Ibadhi","pop":367705416},{"year":"1965","cat":"Islam","type":"Shia","pop":17097714},{"year":"1965","cat":"Islam","type":"Sunni","pop":129192812}]},{"name":"Judaism","children":[{"year":"1965","cat":"Judaism","type":"Conservative","pop":1760345},{"year":"1965","cat":"Judaism","type":"Orthodox","pop":3295632},{"year":"1965","cat":"Judaism","type":"Other","pop":6849626},{"year":"1965","cat":"Judaism","type":"Reform","pop":2348076}]}]},{"name":"1970","children":[{"name":"Buddhism","children":[{"year":"1970","cat":"Buddhism","type":"Other","pop":207939998},{"year":"1970","cat":"Buddhism","type":"Theravada","pop":20862636}]},{"name":"Christianity","children":[{"year":"1970","cat":"Christianity","type":"Anglican","pop":46079842},{"year":"1970","cat":"Christianity","type":"Catholic","pop":671006540},{"year":"1970","cat":"Christianity","type":"Orthodox","pop":134595635},{"year":"1970","cat":"Christianity","type":"Other","pop":76991429},{"year":"1970","cat":"Christianity","type":"Mahayana","pop":247932230}]},{"name":"Islam","children":[{"year":"1970","cat":"Islam","type":"Alawite","pop":700450},{"year":"1970","cat":"Islam","type":"Mahayana","pop":374000},{"year":"1970","cat":"Islam","type":"Ibadhi","pop":403431693},{"year":"1970","cat":"Islam","type":"Shia","pop":36572141},{"year":"1970","cat":"Islam","type":"Sunni","pop":151264004}]},{"name":"Judaism","children":[{"year":"1970","cat":"Judaism","type":"Conservative","pop":1923986},{"year":"1970","cat":"Judaism","type":"Orthodox","pop":3663721},{"year":"1970","cat":"Judaism","type":"Other","pop":6670904},{"year":"1970","cat":"Judaism","type":"Reform","pop":2574798}]}]},{"name":"1975","children":[{"name":"Buddhism","children":[{"year":"1975","cat":"Buddhism","type":"Other","pop":237395084},{"year":"1975","cat":"Buddhism","type":"Theravada","pop":22929200}]},{"name":"Christianity","children":[{"year":"1975","cat":"Christianity","type":"Anglican","pop":48153338},{"year":"1975","cat":"Christianity","type":"Catholic","pop":748325898},{"year":"1975","cat":"Christianity","type":"Orthodox","pop":137192284},{"year":"1975","cat":"Christianity","type":"Other","pop":101587361},{"year":"1975","cat":"Christianity","type":"Mahayana","pop":264857729}]},{"name":"Islam","children":[{"year":"1975","cat":"Islam","type":"Ahmadiyya","pop":2700},{"year":"1975","cat":"Islam","type":"Alawite","pop":924465},{"year":"1975","cat":"Islam","type":"Mahayana","pop":420500},{"year":"1975","cat":"Islam","type":"Ibadhi","pop":379000166},{"year":"1975","cat":"Islam","type":"Shia","pop":44373213},{"year":"1975","cat":"Islam","type":"Sunni","pop":238953304}]},{"name":"Judaism","children":[{"year":"1975","cat":"Judaism","type":"Conservative","pop":2253657},{"year":"1975","cat":"Judaism","type":"Orthodox","pop":3910099},{"year":"1975","cat":"Judaism","type":"Other","pop":6839862},{"year":"1975","cat":"Judaism","type":"Reform","pop":2910930}]}]},{"name":"1980","children":[{"name":"Buddhism","children":[{"year":"1980","cat":"Buddhism","type":"Other","pop":268001266},{"year":"1980","cat":"Buddhism","type":"Theravada","pop":30400850}]},{"name":"Christianity","children":[{"year":"1980","cat":"Christianity","type":"Anglican","pop":51093360},{"year":"1980","cat":"Christianity","type":"Catholic","pop":798834729},{"year":"1980","cat":"Christianity","type":"Orthodox","pop":137902427},{"year":"1980","cat":"Christianity","type":"Other","pop":125285902},{"year":"1980","cat":"Christianity","type":"Mahayana","pop":278962191}]},{"name":"Islam","children":[{"year":"1980","cat":"Islam","type":"Ahmadiyya","pop":1584485},{"year":"1980","cat":"Islam","type":"Alawite","pop":1148480},{"year":"1980","cat":"Islam","type":"Mahayana","pop":668250},{"year":"1980","cat":"Islam","type":"Ibadhi","pop":315105986},{"year":"1980","cat":"Islam","type":"Shia","pop":50827912},{"year":"1980","cat":"Islam","type":"Sunni","pop":277804364}]},{"name":"Judaism","children":[{"year":"1980","cat":"Judaism","type":"Conservative","pop":2439116},{"year":"1980","cat":"Judaism","type":"Orthodox","pop":4300992},{"year":"1980","cat":"Judaism","type":"Other","pop":6713100},{"year":"1980","cat":"Judaism","type":"Reform","pop":3153787}]}]},{"name":"1985","children":[{"name":"Buddhism","children":[{"year":"1985","cat":"Buddhism","type":"Other","pop":301438364},{"year":"1985","cat":"Buddhism","type":"Theravada","pop":36232325}]},{"name":"Christianity","children":[{"year":"1985","cat":"Christianity","type":"Anglican","pop":56651880},{"year":"1985","cat":"Christianity","type":"Catholic","pop":865316946},{"year":"1985","cat":"Christianity","type":"Orthodox","pop":141435053},{"year":"1985","cat":"Christianity","type":"Other","pop":138453851},{"year":"1985","cat":"Christianity","type":"Mahayana","pop":305061321}]},{"name":"Islam","children":[{"year":"1985","cat":"Islam","type":"Alawite","pop":1202490},{"year":"1985","cat":"Islam","type":"Mahayana","pop":899500},{"year":"1985","cat":"Islam","type":"Ibadhi","pop":364584661},{"year":"1985","cat":"Islam","type":"Shia","pop":62653376},{"year":"1985","cat":"Islam","type":"Sunni","pop":317788564}]},{"name":"Judaism","children":[{"year":"1985","cat":"Judaism","type":"Conservative","pop":2466942},{"year":"1985","cat":"Judaism","type":"Orthodox","pop":4580474},{"year":"1985","cat":"Judaism","type":"Other","pop":6415455},{"year":"1985","cat":"Judaism","type":"Reform","pop":3320124}]}]},{"name":"1990","children":[{"name":"Buddhism","children":[{"year":"1990","cat":"Buddhism","type":"Other","pop":335944605},{"year":"1990","cat":"Buddhism","type":"Theravada","pop":39303150}]},{"name":"Christianity","children":[{"year":"1990","cat":"Christianity","type":"Anglican","pop":63954053},{"year":"1990","cat":"Christianity","type":"Catholic","pop":928527756},{"year":"1990","cat":"Christianity","type":"Orthodox","pop":147970918},{"year":"1990","cat":"Christianity","type":"Other","pop":162855904},{"year":"1990","cat":"Christianity","type":"Mahayana","pop":391772588}]},{"name":"Islam","children":[{"year":"1990","cat":"Islam","type":"Alawite","pop":9123315},{"year":"1990","cat":"Islam","type":"Mahayana","pop":1095087},{"year":"1990","cat":"Islam","type":"Ibadhi","pop":394656683},{"year":"1990","cat":"Islam","type":"Shia","pop":78407673},{"year":"1990","cat":"Islam","type":"Sunni","pop":516397560}]},{"name":"Judaism","children":[{"year":"1990","cat":"Judaism","type":"Conservative","pop":1926083},{"year":"1990","cat":"Judaism","type":"Orthodox","pop":4395315},{"year":"1990","cat":"Judaism","type":"Other","pop":6089896},{"year":"1990","cat":"Judaism","type":"Reform","pop":2458253}]}]},{"name":"1995","children":[{"name":"Buddhism","children":[{"year":"1995","cat":"Buddhism","type":"Other","pop":370731530},{"year":"1995","cat":"Buddhism","type":"Theravada","pop":41223800}]},{"name":"Christianity","children":[{"year":"1995","cat":"Christianity","type":"Anglican","pop":69080890},{"year":"1995","cat":"Christianity","type":"Catholic","pop":962614859},{"year":"1995","cat":"Christianity","type":"Orthodox","pop":182860714},{"year":"1995","cat":"Christianity","type":"Other","pop":185349210},{"year":"1995","cat":"Christianity","type":"Mahayana","pop":385509297}]},{"name":"Islam","children":[{"year":"1995","cat":"Islam","type":"Ahmadiyya","pop":200000},{"year":"1995","cat":"Islam","type":"Alawite","pop":11824580},{"year":"1995","cat":"Islam","type":"Mahayana","pop":1229556},{"year":"1995","cat":"Islam","type":"Ibadhi","pop":311342152},{"year":"1995","cat":"Islam","type":"Shia","pop":116574174},{"year":"1995","cat":"Islam","type":"Sunni","pop":713820144}]},{"name":"Judaism","children":[{"year":"1995","cat":"Judaism","type":"Conservative","pop":1900415},{"year":"1995","cat":"Judaism","type":"Orthodox","pop":5143346},{"year":"1995","cat":"Judaism","type":"Other","pop":4635903},{"year":"1995","cat":"Judaism","type":"Reform","pop":2392642}]}]},{"name":"2000","children":[{"name":"Buddhism","children":[{"year":"2000","cat":"Buddhism","type":"Mahayana","pop":4938780},{"year":"2000","cat":"Buddhism","type":"Other","pop":270076925},{"year":"2000","cat":"Buddhism","type":"Theravada","pop":113240351}]},{"name":"Christianity","children":[{"year":"2000","cat":"Christianity","type":"Anglican","pop":68291261},{"year":"2000","cat":"Christianity","type":"Catholic","pop":978633933},{"year":"2000","cat":"Christianity","type":"Orthodox","pop":264356291},{"year":"2000","cat":"Christianity","type":"Other","pop":136031105},{"year":"2000","cat":"Christianity","type":"Mahayana","pop":443610594}]},{"name":"Islam","children":[{"year":"2000","cat":"Islam","type":"Ahmadiyya","pop":536000},{"year":"2000","cat":"Islam","type":"Alawite","pop":12568650},{"year":"2000","cat":"Islam","type":"Mahayana","pop":1360367},{"year":"2000","cat":"Islam","type":"Ibadhi","pop":30722832},{"year":"2000","cat":"Islam","type":"Shia","pop":153872692},{"year":"2000","cat":"Islam","type":"Sunni","pop":1114987699}]},{"name":"Judaism","children":[{"year":"2000","cat":"Judaism","type":"Conservative","pop":1849587},{"year":"2000","cat":"Judaism","type":"Orthodox","pop":5433428},{"year":"2000","cat":"Judaism","type":"Other","pop":3856395},{"year":"2000","cat":"Judaism","type":"Reform","pop":2306902}]}]},{"name":"2005","children":[{"name":"Buddhism","children":[{"year":"2005","cat":"Buddhism","type":"Mahayana","pop":14098904},{"year":"2005","cat":"Buddhism","type":"Other","pop":303189054},{"year":"2005","cat":"Buddhism","type":"Theravada","pop":156829163}]},{"name":"Christianity","children":[{"year":"2005","cat":"Christianity","type":"Anglican","pop":69037503},{"year":"2005","cat":"Christianity","type":"Catholic","pop":1013883916},{"year":"2005","cat":"Christianity","type":"Orthodox","pop":255124896},{"year":"2005","cat":"Christianity","type":"Other","pop":161742315},{"year":"2005","cat":"Christianity","type":"Mahayana","pop":490942837}]},{"name":"Islam","children":[{"year":"2005","cat":"Islam","type":"Ahmadiyya","pop":543367},{"year":"2005","cat":"Islam","type":"Alawite","pop":15993460},{"year":"2005","cat":"Islam","type":"Mahayana","pop":1415383},{"year":"2005","cat":"Islam","type":"Ibadhi","pop":41954417},{"year":"2005","cat":"Islam","type":"Shia","pop":164919787},{"year":"2005","cat":"Islam","type":"Sunni","pop":1201627932}]},{"name":"Judaism","children":[{"year":"2005","cat":"Judaism","type":"Conservative","pop":1778851},{"year":"2005","cat":"Judaism","type":"Orthodox","pop":6271171},{"year":"2005","cat":"Judaism","type":"Other","pop":3878005},{"year":"2005","cat":"Judaism","type":"Reform","pop":2342301}]}]},{"name":"2010","children":[{"name":"Buddhism","children":[{"year":"2010","cat":"Buddhism","type":"Mahayana","pop":14951768},{"year":"2010","cat":"Buddhism","type":"Other","pop":304682353},{"year":"2010","cat":"Buddhism","type":"Theravada","pop":165612816}]},{"name":"Christianity","children":[{"year":"2010","cat":"Christianity","type":"Anglican","pop":71770419},{"year":"2010","cat":"Christianity","type":"Catholic","pop":1049709823},{"year":"2010","cat":"Christianity","type":"Orthodox","pop":268783851},{"year":"2010","cat":"Christianity","type":"Other","pop":163818774},{"year":"2010","cat":"Christianity","type":"Mahayana","pop":557830085}]},{"name":"Islam","children":[{"year":"2010","cat":"Islam","type":"Ahmadiyya","pop":500000},{"year":"2010","cat":"Islam","type":"Alawite","pop":4108974},{"year":"2010","cat":"Islam","type":"Mahayana","pop":1606195},{"year":"2010","cat":"Islam","type":"Ibadhi","pop":44843888},{"year":"2010","cat":"Islam","type":"Shia","pop":183218930},{"year":"2010","cat":"Islam","type":"Sunni","pop":1321204779}]},{"name":"Judaism","children":[{"year":"2010","cat":"Judaism","type":"Conservative","pop":1899567},{"year":"2010","cat":"Judaism","type":"Orthodox","pop":6637406},{"year":"2010","cat":"Judaism","type":"Other","pop":2976676},{"year":"2010","cat":"Judaism","type":"Reform","pop":2509660}]}]}]};

    var color = d3.scale.ordinal().range(['#74E600','#26527C','#61D7A4','#6CAC2B','#408AD2','#218359','#36D792','#679ED2','#B0F26D','#4B9500','#98F23D','#04396C','#007241']);

    // debug console.dir(d3.select("div#overview").append('p').text('DO we ever see this text?'));

    var svg = d3.select("div#overview").append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height * .52 + ")");

    var partition = d3.layout.partition()
        .sort(null)
        .size([2 * Math.PI, radius * radius])
        .value(function(d) { return d.pop; });

    var arc = d3.svg.arc()
        .startAngle(function(d) { return d.x; })
        .endAngle(function(d) { return d.x + d.dx; })
        .innerRadius(function(d) { return Math.sqrt(d.y); })
        .outerRadius(function(d) { return Math.sqrt(d.y + d.dy); });

    //*************************************************
    // GET THE CSV DATA
    //*************************************************
   /* d3.csv("/data/religions.csv", function(error, data) {
        _.each(data, function(element, index, list){
            element.pop = +element.pop;
        });*/

        //*************************************************
        // THE FUNCTION
        //*************************************************
        /*function genJSON(csvData, groups) {

            console.log("doing something to the json")

            var genGroups = function(data) {
                return _.map(data, function(element, index) {
                    return { name : index, children : element };
                });
            };

            var nest = function(node, curIndex) {
                if (curIndex === 0) {
                    node.children = genGroups(_.groupBy(csvData, groups[0]));
                    _.each(node.children, function (child) {
                        nest(child, curIndex + 1);
                    });
                }
                else {
                    if (curIndex < groups.length) {
                        node.children = genGroups(
                            _.groupBy(node.children, groups[curIndex])
                        );
                        _.each(node.children, function (child) {
                            nest(child, curIndex + 1);
                        });
                    }
                }
                return node;
            };
            return nest({}, 0);
        } */
        //*************************************************
        // CALL THE FUNCTION
        //*************************************************
        //var preppedData = genJSON(data, ['year', 'cat']);
        console.log(json);

        //*************************************************
        // LOAD THE PREPPED DATA IN D3
        //*************************************************
        var path = svg.datum(json).selectAll("path")
            .data(partition.nodes)
            .enter().append("path")
            .attr("display", function(d) { return d.depth ? null : "none"; }) // hide inner ring
            .attr("d", arc)
            .attr("class", function(d) { return (d.children ? d : d.parent).name; })
            .style("stroke", "#fff")
            .style("fill", function(d) { return color((d.children ? d : d.parent).name); })
            .style("fill-rule", "evenodd");


    /* end current code for default.xqy */






    /* Host information

     console.log("here");
     var data = [1, 1, 2, 3, 5, 8, 13];

     var canvas = document.querySelector("canvas"),
     context = canvas.getContext("2d");

     var width = canvas.width,
     height = canvas.height,
     radius = Math.min(width, height) / 2;

     var colors = [
     "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
     "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
     ];

     var arc = d3.arc()
     .outerRadius(radius - 10)
     .innerRadius(radius - 70)
     .padAngle(0.03)
     .context(context);

     var pie = d3.pie();

     var arcs = pie(data);

     context.translate(width / 2, height / 2);

     context.globalAlpha = 0.5;
     arcs.forEach(function(d, i) {
     context.beginPath();
     arc(d);
     context.fillStyle = colors[i];
     context.fill();
     });

     context.globalAlpha = 1;
     context.beginPath();
     arcs.forEach(arc);
     context.lineWidth = 1.5;
     context.stroke();

     End host info */

    /* arc tween for host page */
    var width = 200, height = 240, τ = 2 * Math.PI; // http://tauday.com/tau-manifesto
    // An arc function with all values bound except the endAngle. So, to compute an SVG path string for a given angle, we pass an object with an endAngle property to the `arc` function, and it will return the corresponding string.
    var arc = d3.svg.arc().innerRadius(100).outerRadius(70).startAngle(0);
    // Create the SVG container, and apply a transform such that the origin is the center of the canvas. This way, we don't need to position arcs individually.
    var svg = d3.select("#host-info").append("svg").attr("width", width).attr("height", height).append("g").attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
    // Add the background arc, from 0 to 100% (τ).
    var background = svg.append("path").datum({endAngle: τ}).style("fill", "#eee").attr("d", arc);
    // Add the foreground arc in orange, currently showing 12.7%.  // .127 * τ
    var node1 = svg.append("path").datum({endAngle: 0}).style("fill", "orange").attr("d", arc);
    var node2 = svg.append("path").datum({endAngle: 0}).style("fill", "red").attr("d", arc);
    var node3 = svg.append("path").datum({endAngle: 0}).style("fill", "blue").attr("d", arc);

    // animate
    setTimeout(function () {
        node1.transition().duration(750).call(arcTween, 1 * τ);
        node2.transition().duration(750).call(arcTween, .666 * τ);    // .333 * τ //Math.random() * τ
        node3.transition().duration(750).call(arcTween, .333 * τ);
    }, 1000);


// text
/*
 http://www.visualcinnamon.com/2015/09/placing-text-on-arcs.html
 http://bl.ocks.org/mbostock/2565344
 http://bl.ocks.org/mbostock/5100636 - like the above example
 http://www.brightpointinc.com/download/radial-progress-source-code/
 http://bl.ocks.org/mbostock/1846692
 https://bost.ocks.org/mike/selection/
 https://bl.ocks.org/mbostock/99f0a6533f7c949cf8b8

 */
//Creating an Arc path
    // M start-x, start-y A radius-x, radius-y, x-axis-rotation, large-arc-flag, sweep-flag, end-x, end-y
    //Create an SVG path
    //   M 10,10 Q 100,15 200,70 Q 340,140 180,30
    svg.append("path")
        .attr("id", "wavy") //very important to give the path element a unique ID to reference later
        // .attr("d", " M -100,0 A 100,100 0 0,1 100,0") // perfect arc
        .attr("d", "M -105,-5 A 100,100 0 0,1 105,0") //Notation for an SVG path, from bl.ocks.org/mbostock/2565344
        .style("fill", "none");
        // if you want to see the line
        //.style("stroke", "#AAAAAA");

//Create an SVG text element and append a textPath element
    svg.append("text")
        .append("textPath") //append a textPath to the text element
        .attr("xlink:href", "#wavy") //place the ID of the path here
        .style("text-anchor","middle") //place the text halfway on the arc
        .attr("startOffset", "50%")
        .text("3 hosts in current cluster");





// Creates a tween on the specified transition's "d" attribute, transitioning
// any selected arcs from their current angle to the specified new angle.
    function arcTween(transition, newAngle) {

        // The function passed to attrTween is invoked for each selected element when
        // the transition starts, and for each element returns the interpolator to use
        // over the course of transition. This function is thus responsible for
        // determining the starting angle of the transition (which is pulled from the
        // element's bound datum, d.endAngle), and the ending angle (simply the
        // newAngle argument to the enclosing function).
        transition.attrTween("d", function (d) {

            // To interpolate between the two angles, we use the default d3.interpolate.
            // (Internally, this maps to d3.interpolateNumber, since both of the
            // arguments to d3.interpolate are numbers.) The returned function takes a
            // single argument t and returns a number between the starting angle and the
            // ending angle. When t = 0, it returns d.endAngle; when t = 1, it returns
            // newAngle; and for 0 < t < 1 it returns an angle in-between.
            var interpolate = d3.interpolate(d.endAngle, newAngle);

            // The return value of the attrTween is also a function: the function that
            // we want to run for each tick of the transition. Because we used
            // attrTween("d"), the return value of this last function will be set to the
            // "d" attribute at every tick. (It's also possible to use transition.tween
            // to run arbitrary code for every tick, say if you want to set multiple
            // attributes from a single function.) The argument t ranges from 0, at the
            // start of the transition, to 1, at the end.
            return function (t) {

                // Calculate the current arc angle based on the transition time, t. Since
                // the t for the transition and the t for the interpolate both range from
                // 0 to 1, we can pass t directly to the interpolator.
                //
                // Note that the interpolated angle is written into the element's bound
                // data object! This is important: it means that if the transition were
                // interrupted, the data bound to the element would still be consistent
                // with its appearance. Whenever we start a new arc transition, the
                // correct starting angle can be inferred from the data.
                d.endAngle = interpolate(t);

                // Lastly, compute the arc path given the updated data! In effect, this
                // transition uses data-space interpolation: the data is interpolated
                // (that is, the end angle) rather than the path string itself.
                // Interpolating the angles in polar coordinates, rather than the raw path
                // string, produces valid intermediate arcs during the transition.
                return arc(d);
            };
        });
    }


    // Example taken from: http://bl.ocks.org/d3noob/8375092
    // ************** Generate the D3 tree diagram	 *****************
    if ($("div#forest").length > 0) {
        // Get the database name
        var db = $("div#forest > strong")[0].innerText;
        // console.log(db);

        // load the external data
        d3.json("/ws/forest-layout.xqy?db=" + db, function (error, treeData) {
            root = treeData;
            update(root);
            root.x0 = height / 2;
            root.y0 = 0;

            update(root);

            d3.select(self.frameElement).style("height", "500px");
        });
    }
    // ************** End Generate the D3 tree diagram	 *****************


    /* ErrorLog tail */
    var url = "/get-error-log.xqy?filename=";
    var poll = 3000;
    /* 2s */


    if ($("pre#data").length > 0) {

        // console.log($("pre#data").value);
        //var file = SelectText($('pre')[0]); // $("pre[id='data']").val();
        // console.log(file);
        // console.dir($("pre#data")[0].innerText);
        var file = $("pre#data")[0].innerText;  //$("#data").textContent;
//        console.log("file: " + url + file);
        get_log(url + file);

        window.setInterval(function () {
            get_log(url + file)
        }, poll);
    }
    /* End ErrorLog Tail */

    /* CodeMirror */
    if ($("textarea#editor").length > 0) {
        CodeMirror.fromTextArea(document.getElementById("editor"), {
            lineNumbers: true,
            lineWrapping: true
        });
    }
});
