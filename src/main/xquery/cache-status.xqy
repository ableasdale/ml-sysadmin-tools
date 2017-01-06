xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Group Level Caches",
element div {
attribute class {"container"},
lib-view:page-header("MarkLogic Cluster", "Group Level Caches", " "),
element div {attribute class {"row"},
<div id="ctc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="etc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="lc" style="width: 900px; height: 500px;">{" "}</div>,
element h3 {"Group Level Cache Status"},
element pre {element code {xdmp:quote(xdmp:cache-status())}}
}
},<script src="/assets/js/caches.js">{" "}</script>)
