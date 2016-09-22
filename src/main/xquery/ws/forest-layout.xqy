xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare function local:database-get-forest-details($dbid as xs:unsignedLong){
    for $i in xdmp:database-forests($dbid)
    return object-node {
        "name" : text {xdmp:forest-name($i) || " (" || $i || ")"} ,
        "parent" : text {$common:DATABASE}
    }
};

object-node {
    "name" : text {$common:DATABASE},
    "parent" : text {"null"},
    "children" : array-node {local:database-get-forest-details(xdmp:database($common:DATABASE))}
}
