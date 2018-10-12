xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

lib-view:create-bootstrap-page("MarkLogic Tools: Rebalancer preview",
    <div class="container">{
        lib-view:page-header("Database Overview", "All Databases and Forests", " "),
        <ul>{
            for $i in xdmp:databases()
            return (element li {xdmp:database-name($i)},
            element ul {for $j in xdmp:database-forests($i, fn:true()) return element li {element a {attribute href {"?forestid="||$j}, xdmp:forest-name($j)}}}
            )
        }
        </ul>

    }</div>
)
