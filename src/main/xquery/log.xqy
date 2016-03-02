xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $LOG as xs:string := xdmp:get-request-field("log", "ErrorLog.txt");

declare function local:file-select(){
     element div {
        attribute class {"dropdown"},
        element button {
            attribute class {"btn btn-default dropdown-toggle pull-right"},
            attribute type {"button"},
            attribute id {"file-select"},
            attribute data-toggle {"dropdown"},
            attribute aria-haspopup {"true"},
            attribute aria-expanded {"true"},
            "Choose Logfile ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"file-select"},
            element li {attribute class {"dropdown-header"}, "Available Files:"},
            for $x in xdmp:filesystem-directory(common:get-log-directory())/dir:entry
            where (xs:integer($x/dir:content-length) gt 0)
            return
                element li {element a {attribute href {concat("?log=", xs:string($x/dir:filename))}, xs:string($x/dir:filename)}}
        }
    }
};

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Log Viewer",
    element div {
        attribute class {"container"},
        lib-view:page-header("Log Viewer", $LOG, local:file-select()),
        element div {attribute class {"row"},
            element pre {attribute id {"data"}, attribute style {"height:30em;"},$LOG}
    }},
<script src="/assets/js/logs.js">{" "}</script>
)

(:
,lib-view:get-log-js()
 <div id="header">
            <pre id="data" style="height:30em;">Loading...</pre>
            <input type="hidden" name="country" value="Norway"/>
            <div id="rev"> Chrono</div>
            <div id="pause"> Pause</div>
            <input id="input" />
            <div id="search"> Filter</div>
        </div>,
:)