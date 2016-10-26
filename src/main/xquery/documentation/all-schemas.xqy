xquery version "1.0-ml";

declare namespace admin = "http://marklogic.com/xdmp/admin";
declare namespace meters = "http://marklogic.com/manage/meters";
declare namespace manage = "http://marklogic.com/manage";
declare namespace xdmp = "http://marklogic.com/xdmp";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";


declare function local:display($name, $it as item()*) {
    
    (element tr {
        element td {element a {attribute href {"/documentation/schema-item.xqy?file="||$name},  $name}   },
        element td {attribute class {fn:local-name($it)}, fn:local-name($it)},
        element td {element strong { fn:data($it/@name) }},
        element td {$it//xs:documentation/text()}
    })
(:
    if( exists($it/@name)) then (element h3 {fn:data($it/@name)}, element h4 {element small {$name}} ) else (element h4 {element small {$name}}),
    fn:local-name($it),
    element pre {xdmp:quote($it)},
    element hr {} :)
};


declare function local:process($filename as xs:string, $name as xs:string) {
(
    for $x in xdmp:document-get($filename)/node()/node()    
    return local:display($name, $x)
 )
};

(: Module main :)
lib-view:create-bootstrap-page("All XSD Items",
    element div {attribute class {"container"},
        lib-view:page-header("Schema Explorer", "All XML Schema Items", " "),
        element div {attribute class {"row"},
            element table { attribute class {"table table-striped table-bordered"}, 
                element thead { 
                    element tr {
                        for $x in ("Filename", "XSD Localname", "Name", "Documentation")
                        return element th {$x}
                    }
                },
                element tbody {
                    for $d in xdmp:filesystem-directory(common:get-base-xsd-path())/dir:entry
                    where contains($d/dir:filename/text(), "xsd")
                    return local:process($d/dir:pathname/text(),  $d/dir:filename)
                }
            }
        }
    }
)