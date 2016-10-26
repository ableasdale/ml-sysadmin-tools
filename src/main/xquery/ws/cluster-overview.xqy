xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace f = "http://marklogic.com/xdmp/status/forest";

declare variable $FOREST-STATUS := xdmp:forest-status(xdmp:host-forests(xdmp:hosts()));

declare function local:host-get-forest-details($hostname as xs:string) { (: as object-node :)
    for $i in xdmp:host-forests(xdmp:host($hostname))
    let $fc := xdmp:forest-counts($i)
    return object-node {
        "name" : text {xdmp:forest-name($i)},
        "documents" : text {fn:data(sum($fc//f:document-count))},
        "children" : array-node {
            for $i in $fc//f:stand-counts
            return object-node {
                "name" : text {fn:data($i/f:stand-id)},
                "documents" : text {fn:data($i/f:active-fragment-count)},
                "disksize" : text {fn:sum($FOREST-STATUS//*:stand[*:stand-id eq fn:data($i/f:stand-id)]/*:disk-size)}
            }
        }
(: "parent" : text {$common:DATABASE} :)
    }
};

xdmp:set-response-content-type("application/json; charset=utf-8"),
object-node {
    "children" : array-node {
        for $i in xdmp:host-name(xdmp:hosts())
        return object-node {
        "name" : text {$i},
        "children" : array-node {local:host-get-forest-details($i)}
        }
    }
}
