xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

lib-view:create-bootstrap-page("MarkLogic Tools: Rebalancer preview",
    <div class="container">{
        lib-view:page-header("Database Overview", "All Databases", " "),
        common:database-forest-composition()
    }</div>
)
