xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace admin = "http://marklogic.com/xdmp/admin";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $LOG as xs:string := xdmp:get-request-field("log", "0");

(: Module main :)

lib-view:create-bootstrap-page("MarkLogic Tools: Log Viewer",
    (lib-view:page-header("Log Viewer", "TODO", ()),
    element div {attribute class {"row"},
        <div id="header">
            <div id="rev"> Chrono</div>
            <div id="pause"> Pause</div>
            <input id="input" />
            <div id="search"> Filter</div>
        </div>,
        <pre id="data" style="height:30em;">Loading...</pre>    
    },
    lib-view:get-log-js()
    )
)


    
