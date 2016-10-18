xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare variable $primary as xs:string := xdmp:get-request-field("db1", "databases.xml");
declare variable $secondary as xs:string := xdmp:get-request-field("db2", "databases_1.xml");

declare function local:get-config-files() {
    for $i in xs:string(xdmp:filesystem-directory(xdmp:data-directory())//dir:filename)
    where fn:ends-with($i, ".xml")
    order by $i
    return $i
};

lib-view:create-bootstrap-page("MarkLogic Tools: Visual Diff of Config Files",
    element div {attribute class {"container"},
    lib-view:page-header("Visual Diff", "Config Files", " "),
    <div class="row">
<!-- h4>Visual Diff <small>{xdmp:get-request-field("cfg")}</small></h4 -->
        <div class="row" style="padding-bottom:1em;">
            <div class="col-md-1">
                {lib-view:item-select(local:get-config-files(),"db1", "db2", fn:true(), $secondary)}
            </div>
            <div class="col-md-5">
                <h4>Primary file: <strong>{$primary}</strong></h4>
            </div> 
            <div class="col-md-1">
                {lib-view:item-select(local:get-config-files(),"db1", "db2", fn:false(), $primary)}
            </div>
            <div class="col-md-5">
                <h4>Secondary file: <strong>{$secondary}</strong></h4>
            </div>
        </div>
        <div id="panel1" style="display:none;">{xdmp:read-cluster-config-file($primary)}</div>
        <div id="panel2" style="display:none;">{xdmp:read-cluster-config-file($secondary)}</div>
        <div id="placeholder"></div>
    </div>
},
<div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/fold/xml-fold.min.js">{" "}</script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/hint/xml-hint.min.js">{" "}</script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/mode/xml/xml.min.js">{" "}</script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/fold/foldgutter.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/fold/foldcode.js">{" "}</script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/fold/foldgutter.js">{" "}</script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/merge/merge.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/diff_match_patch/20121119/diff_match_patch.js">{" "}</script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/addon/merge/merge.js">{" "}</script>
    <style><![CDATA[
            .CodeMirror-merge, .CodeMirror-merge .CodeMirror {
                height: 600px;
            }
    ]]></style>
    <script><![CDATA[
                CodeMirror.MergeView(document.getElementById("placeholder"), {
                    value: document.getElementById("panel1").innerHTML,
                    orig: document.getElementById("panel2").innerHTML,
                    lineNumbers: true,
                    mode: "xml",
                    highlightDifferences: true
                });
    ]]></script>
</div>
)

(:
common:build-page( concat("Visual Diff: ",xdmp:get-request-field("cfg"))  ,
    <div class="row">        
        <!-- h4>Visual Diff <small>{xdmp:get-request-field("cfg")}</small></h4 -->
        <div class="row">
            <div class="col-md-6">
                <p>Primary diff path: <strong>{$consts:PRIMARY-DIFF-PATH}</strong></p>
            </div>
            <div class="col-md-6">
                <p>Secondary diff path: <strong>{$consts:SECONDARY-DIFF-PATH}</strong></p>
            </div>
        </div>        
        <div id="panel1" style="display:none;">{xdmp:document-get(concat($consts:PRIMARY-DIFF-PATH,"/",xdmp:get-request-field("cfg"),".xml"))}</div>
        <div id="panel2" style="display:none;">{xdmp:document-get(concat($consts:SECONDARY-DIFF-PATH,"/",xdmp:get-request-field("cfg"),".xml"))}</div>
        <!-- <div id="panel1" style="display:none;">{xdmp:read-cluster-config-file("databases.xml")}</div>
        <div id="panel2" style="display:none;">{xdmp:read-cluster-config-file("databases_1.xml")}</div> -->
        <div id="placeholder"></div>

        <script><![CDATA[
            CodeMirror.MergeView(document.getElementById("placeholder"), {
                value: document.getElementById("panel1").innerHTML,
                orig: document.getElementById("panel2").innerHTML,
                lineNumbers: true,
                mode: "xml",
                highlightDifferences: true
            });
        ]]></script>
    </div>)
:)