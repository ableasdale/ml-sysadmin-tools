$(document).ready(function() {

    /* ErrorLog tail */
    var url = "/get-error-log.xqy?filename=";
    var poll = 3000; /* 2s */


    if($("pre#data").length > 0){

       // console.log($("pre#data").value);
        //var file = SelectText($('pre')[0]); // $("pre[id='data']").val();
        // console.log(file);
        // console.dir($("pre#data")[0].innerText);
        var file = $("pre#data")[0].innerText  //$("#data").textContent;
        console.log("file: "+url+file);
        console.log("should init once...");
        get_log(url + file);

        window.setInterval(function(){
            get_log(url+file)
        }, poll);
    }

    /* CodeMirror */
    if($("textarea#editor").length > 0) {
        CodeMirror.fromTextArea(document.getElementById("editor"), {
            lineNumbers: true,
            lineWrapping: true
        });
    }
});

