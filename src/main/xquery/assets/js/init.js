// TODO - Only load JS files where needed - at the moment every page loads all JS; as these are cached, it's not a massive problem - but better not to...

$(document).ready(function() {

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
    var poll = 3000; /* 2s */


    if($("pre#data").length > 0){

       // console.log($("pre#data").value);
        //var file = SelectText($('pre')[0]); // $("pre[id='data']").val();
        // console.log(file);
        // console.dir($("pre#data")[0].innerText);
        var file = $("pre#data")[0].innerText;  //$("#data").textContent;
        console.log("file: "+url+file);
        console.log("should init once...");
        get_log(url + file);

        window.setInterval(function(){
            get_log(url+file)
        }, poll);
    }
    /* End ErrorLog Tail */

    /* CodeMirror */
    if($("textarea#editor").length > 0) {
        CodeMirror.fromTextArea(document.getElementById("editor"), {
            lineNumbers: true,
            lineWrapping: true
        });
    }
});

