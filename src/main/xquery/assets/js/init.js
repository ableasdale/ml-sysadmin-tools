$(document).ready(function() {
    var running = false;
    var url = "/get-error-log.xqy?";

    if(running === false && $("pre#data").length > 0){
        console.log("found my div");
       // console.log($("pre#data").value);

        //var file = SelectText($('pre')[0]); // $("pre[id='data']").val();
        // console.log(file);
        // console.dir($("pre#data")[0].innerText);
        var file = $("pre#data")[0].innerText  //$("#data").textContent;
        console.log("file: "+url+file);
        get_log(url + file);
        running = true;
    }

});