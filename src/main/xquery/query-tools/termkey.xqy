xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace admin = "http://marklogic.com/xdmp/admin";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $KEY as xs:string := xdmp:get-request-field("k", "0");


(: Module main :)

lib-view:create-bootstrap-page("MarkLogic Tools: Term Key Explorer",
    (
    lib-view:page-header("Term Key Lookup", "TODO", ()),
    element div { 
        attribute class {"row"},
        element h3 {"Term Key:"},
        element p {$KEY},
        
        element h3 {"Reverse Lookup of Search Term (and indexes) from Term Key:"},
        element pre {element code{xdmp:quote(common:lookup-term-from-key($KEY cast as xs:unsignedLong))}},

        element hr {" "},
        element p {"Download matching docs in ZIP"},
        element h3 {common:get-estimate-for-term-key($KEY cast as xs:unsignedLong), "URIs Matched for key ", $KEY},
        
        element ul {
            for $i in common:get-uris-from-term-key($KEY) 
            return element li {$i}
        }
        
    }
    )
)


    
