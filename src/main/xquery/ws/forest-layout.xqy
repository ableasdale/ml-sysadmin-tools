xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

(:
Service needs to be able to create something that looks like this (initially):
var treeData = [
        {
            "name": "DB",
            "parent": "null",
            "children": [
                {
                    "name": "F1",
                    "parent": "DB",
                },
                {
                    "name": "F2",
                    "parent": "DB"
                }
            ]
        }
    ];

:)

(:
for $i in xdmp:database-forests(xdmp:database($common:DATABASE))

return (xdmp:forest-name($i) || " (" || $i || ")")
:)

declare function local:database-get-forest-details($dbid as xs:unsignedLong){
    for $i in xdmp:database-forests($dbid)
    return object-node {
        "name" : text {xdmp:forest-name($i) || " (" || $i || ")"} ,
        "parent" : text {$common:DATABASE}
    }
};

(: json:object-node {"hello": "world"} :)
object-node {
    "name" : text {$common:DATABASE},
    "parent" : text {"null"},
    "children" : array-node {local:database-get-forest-details(xdmp:database($common:DATABASE))}
}

(:
"children" : array-node {
object-node {"name" : text {"F1"}, "parent" : text {$common:DATABASE}},
object-node {"name" : text {"F2"}}
}:)