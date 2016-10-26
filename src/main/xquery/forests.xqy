xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";
import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace f = "http://marklogic.com/xdmp/status/forest";
declare namespace xdmp = "http://marklogic.com/xdmp";

(:~ 

:)
declare function local:database-forest-preview() as element(div) {
    element div {
        attribute class {"row"},
        element h3 {"Database Forest Overview"},
        element div {attribute id {"forest"},"Forest layout diagram for database ", 
        element strong {$common:DATABASE}},
        element hr {" "}
    }
};


declare function local:reindexer-preview() {
    <div class="row">
        <h3>Forest Counts with Reindexer Preview</h3>
        <table class="table table-striped table-bordered">
            <thead>
                <tr>{for $i in ("Source Forest", "Current Time", "Reindex Refragment Fragment Count", "Reindex Fragment Count") return element th {$i}}</tr>
            </thead>
            <tbody>{
for $f in $common:FOREST-COUNTS-REINDEXER
return element tr {
    element td {fn:data($f/f:forest-name)},
    element td {fn:data($f/f:current-time)},
    element td {fn:data($f/f:reindex-refragment-fragment-count)},
    element td {fn:data($f/f:reindex-fragment-count)}
}
            }</tbody>
        </table>

<pre><code>
{
for $f in $common:FOREST-COUNTS-REINDEXER
return xdmp:quote($f)
}
</code></pre>
    </div>
};

(:~ 

:)
declare function local:rebalancer-preview() as element(div) {
    element div {
        attribute class {"row"},
        element h3 {"Forest Counts with Rebalancer Preview"},
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
                for $f in $common:FOREST-COUNTS-REBALANCER
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

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Forest Counts for "||$common:DATABASE,
    element div {
        attribute class {"container"},
        lib-view:page-header("Forest Counts (Rebalancer Preview)", $common:DATABASE, lib-view:database-select()),
        local:database-forest-preview(),
        common:database-forest-composition($common:DATABASE),
        local:rebalancer-preview(),
        local:reindexer-preview()
    },
<script src="/assets/js/forests.js">{" "}</script>
)