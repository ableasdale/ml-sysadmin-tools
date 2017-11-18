xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace cs = "http://marklogic.com/xdmp/status/cache";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare function local:stands() {
    element h3 {"Debug: reference:"},
    element pre { 
        element code {    
            xdmp:quote(xdmp:forest-counts(xdmp:database-forests(xdmp:database($common:DATABASE))))
        }
    }
    (:"stands" || $common:DATABASE :)
};

lib-view:create-bootstrap-page("MarkLogic Tools: Stands",
    element div {
        attribute class {"container"},
        lib-view:page-header("Database: Stands", $common:DATABASE, lib-view:database-select()),
        element svg { attribute width {"960"}, attribute height {"500"}},
        local:stands()
    }, <script src="/assets/js/stands.js">{" "}</script>
)