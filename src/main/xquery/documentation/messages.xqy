xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace msg = "http://marklogic.com/xdmp/messages";
declare namespace xdmp = "http://marklogic.com/xdmp";

declare variable $COLLECTION as xs:string := xdmp:get-request-field("col", "XDMP-en.xml");

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
            "Choose collection ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"database-select"},
            element li {attribute class {"dropdown-header"}, "All Collections:"},
            for $x in cts:collections()
            return
                element li {element a {attribute href {concat("?col=", $x)}, $x}}
        }
    }
};

declare function local:rebalancer-preview() {
    element div {
        attribute class {"row"},
        element table {
            attribute class {"table table-striped table-bordered"},
            element thead {
                element tr {
                    for $i in ("Code", "Text", "Cause", "Response")
                    return
                        element th {$i}
                }
            },
            element tbody {
                
                for $f in collection($COLLECTION)/msg:message
                order by $f/msg:code ascending
                return
                    element tr {
                        element td {element strong {xs:string($f/msg:code)}},
                        element td {xs:string($f/msg:text)},
                        element td {xs:string($f/msg:cause)},
                        element td {xs:string($f/msg:response)}
                    }
            
            }
        }
    }
};

lib-view:create-bootstrap-page("MarkLogic Exceptions",
element div {
attribute class {"container"},
lib-view:page-header("Exception Messages", $COLLECTION,local:database-select()),
local:rebalancer-preview()
})

