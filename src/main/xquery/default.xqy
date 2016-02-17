xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace f = "http://marklogic.com/xdmp/status/forest";
declare variable $DATABASE as xs:string := xdmp:get-request-field("db", "Documents");


declare function local:database-select() as element(div) {
    element div {
        attribute class {"dropdown"},
        element button {
            attribute class {"btn btn-default dropdown-toggle pull-right"},
            attribute type {"button"},
            attribute id {"database-select"},
            attribute data-toggle {"dropdown"},
            attribute aria-haspopup {"true"},
            attribute aria-expanded {"true"},
            "Choose database ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"database-select"},
            element li {attribute class {"dropdown-header"}, "Available Databases:"},
            for $x in xdmp:database-name(xdmp:databases())
            return
                element li {element a {attribute href {concat("?db=", $x)}, $x}}
        }
    }
};

declare function local:rebalancer-preview() as element(div) {
    element div {
        attribute class {"row"},
        element table {
            attribute class {"table table-striped table-bordered"},
            element thead {
                element tr {
                    for $i in ("Source Forest", "Active Fragments", "Deleted Fragments", "Target Forests", "Total(s) to be moved")
                    return
                        element th {$i}
                }
            },
            element tbody {
                for $f in xdmp:forest-counts(xdmp:database-forests(xdmp:database($DATABASE)), (), ("preview-rebalancer"))
                return
                    element tr {
                        element td {$f/f:forest-name/fn:string(.)},
                        element td {fn:sum($f//f:active-fragment-count)},
                        element td {fn:sum($f//f:deleted-fragment-count)},
                        element td {
                            element dl {
                                attribute class {"dl-horizontal"},
                                for $c in $f//f:rebalance-fragment-count[f:fragment-count != 0]
                                order by number($c/f:fragment-count) descending
                                return
                                    (element dt {$c/f:rebalance-destination}, element dd {$c/f:fragment-count})
                            }
                        },
                        element td {fn:sum($f//f:rebalance-fragment-count[*:fragment-count != 0]/f:fragment-count)}
                    }
            }
        }
    }
};


lib-view:create-bootstrap-page("MarkLogic Tools: Rebalancer preview",
    (
    lib-view:page-header("Forest counts (rebalancer preview)", $DATABASE, local:database-select()),
    local:rebalancer-preview()
    )
)