$(document).ready(function () {
    /* CodeMirror */
    if ($("textarea#editor").length > 0) {
        CodeMirror.fromTextArea(document.getElementById("editor"), {
            lineNumbers: true,
            lineWrapping: true
        });
    }
});
