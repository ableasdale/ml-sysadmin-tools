xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace cs = "http://marklogic.com/xdmp/status/cache";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";

declare variable $cache-status := xdmp:cache-status();

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Group Level Caches",
element div {
attribute class {"container"},
lib-view:page-header("MarkLogic Cluster", "Group Level Caches", " "),
element div {attribute class {"row"},
element h4 {xs:string($cache-status/cs:host-name) || " ", element small {xs:string($cache-status/cs:host-id)}},
<div id="ctc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="etc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="lc" style="width: 900px; height: 500px;">{" "}</div>,
element p {$cache-status/cs:compressed-tree-cache-partitions},
element h3 {"Group Level Cache Status"},
element pre {element code {xdmp:quote($cache-status)}}
}
},<script src="/assets/js/caches.js">{" "}</script>)
