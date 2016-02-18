xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace admin = "http://marklogic.com/xdmp/admin";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $QUERY := cts:and-query((cts:word-query("XDMP"), cts:element-value-query(xs:QName("random"), "7447420811867039164")));


(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Term Key Explorer",
    (
    lib-view:page-header("Term Key Lookup", "TODO", ()),
    element div { 
        attribute class {"container"},
        element h3 {"Your cts:query"},
        element textarea {text { $QUERY } },
        element h3 {"CTS XML Serialisation of Query"},
        element pre {element code {xdmp:quote(element q {$QUERY}/node())} },
        element h3 {"MarkLogic Plan"},
        element pre {element code {xdmp:quote(xdmp:plan(cts:search(doc(), $QUERY)))}},
        element h3 {"Unique Term Keys"},
        for $i in common:get-term-keys($QUERY) return element p {element a {attribute href {concat("/query-tools/termkey.xqy?k=",$i)}, $i}, " Matching fragment estimate:", common:get-estimate-for-term-key($i)},
        
        element p {"TODO"
        
        }
    })
)