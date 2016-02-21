xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";
import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace f = "http://marklogic.com/xdmp/status/forest";

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Rebalancer preview",
    element div {
        attribute class {"container"},
        lib-view:page-header("Database Overview", "All Databases", " "),
        (:local:database-forest-preview(), :)
        common:database-forest-composition()
    }
)
