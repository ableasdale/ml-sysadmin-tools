xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $DATABASE := xdmp:get-request-field("db", xdmp:database-name(xdmp:database()));
declare variable $QUERY := cts:and-query((cts:word-query("XDMP"), cts:element-value-query(xs:QName("random"), "7447420811867039164")));

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Plan Explorer",
    element div {
        attribute class {"container"},
        lib-view:page-header("XDMP Plan Lookup", $DATABASE, lib-view:database-select()),
        element div {
            attribute class {"row"},
            element h3 {"Your cts:query"},
            element textarea {attribute id {"editor"}, text { $QUERY } },
            element h3 {"CTS XML Serialisation of Query"},
            element pre {element code {xdmp:quote(element q {$QUERY}/node())} },
            element h3 {"MarkLogic Plan"},
            element pre {element code {xdmp:quote(xdmp:plan(cts:search(doc(), $QUERY)))}},
            element h3 {"Unique Term Keys"},
            for $i in common:get-term-keys($QUERY) return element p {element a {attribute href {concat("/query-tools/termkey.xqy?k=",$i)}, $i}, " Matching fragment estimate:", common:get-estimate-for-term-key($i)},
            element p {"TODO"}
        }
    })