xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";
import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace ses = "http://www.w3.org/2003/05/xpath-functions" at "/MarkLogic/Admin/lib/session.xqy";

declare namespace db = "http://marklogic.com/xdmp/database";
declare namespace h = "http://marklogic.com/xdmp/hosts";
declare namespace g = "http://marklogic.com/xdmp/group";
declare namespace f = "http://marklogic.com/xdmp/status/forest";

(:~ 

:)
declare function local:database-forest-preview() as element(div) {
    element div {
        attribute class {"row"},
        element h3 {"Database Forest Overview"},
        element div {attribute id {"forest"},"Forest layout diagram for database ", element strong {$common:DATABASE}},
        element hr {" "}
    }
};

(:~ 

:)
declare function local:database-forest-composition() {
    element div {
        attribute class {"row"},
        for $db in $ses:databases.xml/node()
        let $db-name := $db/db:database-name/fn:string(.)
        let $indexes := fn:string-join($db/*[fn:string(.) = "true"]/fn:local-name(.), ",")
        let $fragments := 0
        let $dfragments := 0
        let $documents := 0
        let $size := 0
        let $memory := 0
        order by $db/db:database-name 
        return (
            element table {
                attribute class {"table table-striped table-bordered"},
                
                
                element tr {element th {attribute colspan {"10"}, $db-name}},
                element tr {element td {attribute colspan {"10"}, $indexes}},
                element tr {
                    element td {"Forests"},
                    element td {"Host"},
                    element td {"Stands"},
                    element td {"Active Fr"},
                    element td {"Deleted Fr"},
                    element td {"Documents"},
                    element td {"DB Size"},
                    element td {"Mem Size"},
                    element td {"LC Ratio"},
                    element td {"LC Hit/Miss Rate"},
                    element td {"CTC Ratio"}
                },
                for $f at $j in fn:data($db/db:forests/db:forest-id)
                let $fs := xdmp:forest-status($f)
                let $fc := xdmp:forest-counts(fn:data($fs//f:current-master-forest))
                let $ms := xdmp:forest-status(data($fs//f:current-master-forest))
                let $replicas := $fs//f:replica-forest/fn:string(.)
                let $rs := for $r in $replicas
                return
                    xdmp:forest-status($r)
                let $forest-host := xdmp:host-status(fn:data($fs/f:host-id))
                let $group := $ses:groups.xml/g:group[g:group-id eq fn:data($forest-host/h:group)]
                (: let $group := map:get($GROUPS, fn:string($forest-host/h:group)) :)
                let $_ := xdmp:set($fragments, $fragments + fn:sum($fc//f:active-fragment-count))
                let $_ := xdmp:set($dfragments, $dfragments + fn:sum($fc//f:deleted-fragment-count))
                let $_ := xdmp:set($size, $size + fn:sum($fs//f:disk-size))
                let $_ := xdmp:set($memory, $memory + fn:sum($fs//f:memory-size))
                let $_ := xdmp:set($documents, $documents + fn:sum($fc//f:document-count))
                order by $group/g:group-name
                return
                    element tr {
                        
                        element td {attribute style {"padding-left:20px"}, fn:string($fs/f:forest-name)},
                        
                        element td {fn:string($forest-host/h:host-name), "-", xdmp:group-name(xdmp:host-group($forest-host/h:host-id))},
                        (:    fn:data(map:get($GROUPS, $forest-host/h:group/fn:string(.))/g:group-name :)
                        element td {fn:count($fs//f:stand)},
                        element td {common:format(fn:sum($fc//f:active-fragment-count) div 1000000)},
                        element td {common:format(fn:sum($fc//f:deleted-fragment-count) div 1000000)},
                        element td {common:format(fn:sum($fc//f:document-count) div 1000000)},
                        element td {common:format(fn:sum($fs//f:disk-size) div 1024)},
                        element td {common:format(fn:sum($fs//f:memory-size) div 1024)},
                        element td {common:ratio($ms//f:list-cache-hits, $ms//f:list-cache-misses)},
                        element td {common:format(fn:avg($ms//f:list-cache-hit-rate)), "/", common:format(fn:avg($ms//f:list-cache-miss-rate))},
                        
                        element td {common:ratio($ms//f:compressed-tree-cache-hits, $ms//f:compressed-tree-cache-misses)}
                    },
                element tr {
                    element td {attribute style {"padding-left:20px"}, "Total"},
                    element td {" "},
                    element td {" "},
                    element td {common:format($fragments div 1000000)},
                    element td {common:format($dfragments div 1000000)},
                    element td {common:format($documents div 1000000)},
                    element td {common:format($size div 1024)},
                    element td {common:format($memory div 1024)}
                    
                }
            }
        ),
        element hr {" "}
    }
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
lib-view:create-bootstrap-page("MarkLogic Tools: Rebalancer preview",
    element div {
        attribute class {"container"},
        lib-view:page-header("Forest counts (rebalancer preview)", $common:DATABASE, lib-view:database-select()),
        local:database-forest-preview(),
        local:database-forest-composition(),
        local:rebalancer-preview()
    }
)