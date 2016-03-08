xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Overview",
element div {
attribute class {"container"},
lib-view:page-header("MarkLogic Cluster", "Overview", " "),
element div {attribute class {"row"},
element h3 {"Database > Forest > Fragment Chart"},
element div {
attribute id {"overview"}
},
<div id="tooltip" class="hidden"></div>
}
},<script src="/assets/js/bi-level.js">{" "}</script>)