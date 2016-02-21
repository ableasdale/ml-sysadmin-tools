xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";


(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Overview",
element div {
attribute class {"container"},
lib-view:page-header("MarkLogic Cluster", "Overview", " "),
element div {attribute class {"row"},
    element h3 {"Your cluster at a glance"},
    element div {
        attribute id {"overview"}
    },
<div id="tooltip" class="hidden">
    <h4><span id="name">A</span></h4>
    <p><span id="value">B</span></p>
</div>
}
})
