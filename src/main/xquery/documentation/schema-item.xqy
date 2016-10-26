xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare variable $filename := xdmp:get-request-field("file");

declare function local:process($x) {
    (element h2 {fn:data($x/@name)},
    element p {$x//xs:documentation/text()},
    element pre { element code  { xdmp:quote($x) } }
)};

declare function local:schema-file($file as xs:string) {
    element div {attribute class {"row"},
        element div { 
            attribute class {"well"}, "Viewing contents of: ", element strong {$file} 
        },
        for $x in xdmp:document-get(concat(common:get-base-xsd-path(), $file))/node()/node()
        return if (fn:exists($x/@name))
        then (local:process($x))
        else ()
    },
    element div {attribute class {"row"},
        element a {attribute href {"/documentation/schema-item.xqy"}, "Back to listing >"}   
    }
};

declare function local:get-directory() {
    element div {attribute class {"row"},
        element h3 {"Directory listing ", element small{common:get-base-xsd-path()}},
        element table { attribute class {"table table-striped table-bordered"}, 
            element thead { element tr {
                for $x in ("Filename", "Pathname", "Type", "Content Length", "Last Modified")
                return element th {$x}
                }
            },
            element tbody {
                for $d in xdmp:filesystem-directory(common:get-base-xsd-path())/dir:entry
                return element tr {
                element td {element a  { attribute href {concat("?file=", $d/dir:filename)}, $d/dir:filename}},
                element td {$d/dir:pathname/text()},
                element td { attribute class {"text-center"},
                if ($d/dir:type/text() eq "file")
                then (element span { attribute class {"glyphicon glyphicon-file"},  " "})
                else (element span { attribute class {"glyphicon glyphicon-folder-open"},  " "})
                },
                element td {element span { attribute class {"badge"}, $d/dir:content-length/text()}},
                element td {$d/dir:last-modified/text()}
                }
            }
        }
    }
};

(: main :)
if (not(empty($filename)))
then (
    lib-view:create-bootstrap-page("File Listing: "|| $filename,
        element div {attribute class {"container"},
            lib-view:page-header("Schema Explorer", $filename, " "), 
            local:schema-file($filename)
        })
) else (
    lib-view:create-bootstrap-page("Directory Listing", 
        element div {attribute class {"container"},
            lib-view:page-header("Schema Explorer", "Directory listing", " "), 
            local:get-directory()
        })
)
