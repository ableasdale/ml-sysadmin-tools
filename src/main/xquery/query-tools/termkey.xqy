xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace qry = "http://marklogic.com/cts/query";

declare variable $KEY as xs:string := xdmp:get-request-field("k", xs:string((xdmp:plan(/doc())//qry:key)[1]));

(: Module main :)

lib-view:create-bootstrap-page("MarkLogic Tools: Term Key Explorer",
element div {
    attribute class {"container"},
    lib-view:page-header("Term Key Lookup", $common:DATABASE,  lib-view:database-select()),
    element div {
        attribute class {"row"},
        element h3 {"Term Key: ", element small {$KEY}},
        
        element h3 {"Reverse Lookup of Search Term (and indexes) from Term Key:"},
        element pre {element code {xdmp:quote(common:lookup-term-from-key($KEY cast as xs:unsignedLong))}},
        
        element hr {" "},
        element p {"Download matching docs in ZIP"},
        element h3 {common:get-estimate-for-term-key($KEY cast as xs:unsignedLong), "URIs Matched for key ", $KEY},
        
        element ul {
            for $i in common:get-uris-from-term-key($KEY)
            return
                element li {$i}
        }
        
    }
})




