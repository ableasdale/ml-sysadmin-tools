/**
 * Created by ableasdale on 02/03/2016.
 */

/**
 * Animation code and d3 visualisations for the hosts.xqy page
 *
 */

/* arc tween for host page ::  hosts.xqy  */
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
    .style("text-anchor", "middle") //place the text halfway on the arc
    .attr("startOffset", "50%")
    .text("3 hosts in current cluster");


// TODO - move arc tween to a reusable library at some stage

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

/* end arc tween for host page ::  hosts.xqy  */