xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace cs = "http://marklogic.com/xdmp/status/cache";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";

(: TODO - parameterise debug :)
declare variable $debug := xdmp:get-request-field("debug", "0");
declare variable $cache-status := xdmp:cache-status();

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Group Level Caches",
element div {
attribute class {"container"},
lib-view:page-header("MarkLogic Cluster", "Group Level Caches", " "),
element div {attribute class {"row"},
element h4 {xs:string($cache-status/cs:host-name) || " ", element small {xs:string($cache-status/cs:host-id)}},
element div {attribute id {"cache-data"}, text{ xdmp:javascript-eval("xdmp.cacheStatus(xdmp.host())")}},
<div id="ctc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="etc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="lc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="tc" style="width: 900px; height: 500px;">{" "}</div>,
<div id="tvc" style="width: 900px; height: 500px;">{" "}</div>,
if($debug eq "1") then(element h3 {"Group Level Cache Status (Debug Mode)"}, element pre {element code {xdmp:quote(xdmp:cache-status())}}) else ()
}
},<script src="/assets/js/caches.js">{" "}</script>)
