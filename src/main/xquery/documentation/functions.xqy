xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace xdmp = "http://marklogic.com/xdmp";

declare variable $restriction-base as xs:string := xdmp:get-request-field("q", "cts");

declare function local:get-fn-names() as xs:string+ {
  
    for $i in xdmp:functions()
    order by xdmp:function-name($i) cast as xs:string
    return (
        xdmp:function-name($i) cast as xs:string, 
        xdmp:describe(xdmp:function-name($i)) (:,
        fn:function-lookup(fn:QName("http://www.w3.org/2005/xpath-functions","concat"),4):)
    )
  
};

declare function local:restriction-base-dropdown-items() as element(div){
    element div {
        attribute class {"dropdown"},
        element button {
            attribute class {"btn btn-default dropdown-toggle pull-right"},
            attribute type {"button"},
            attribute id {"package-select"},
            attribute data-toggle {"dropdown"},
            attribute aria-haspopup {"true"},
            attribute aria-expanded {"true"},
            "Choose Namespace ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"package-select"},
            element li {attribute class {"dropdown-header"}, "Available Namespaces:"},
            for $x in ("dbg", "fn", "geo", "json", "map", "math", "prof", "rdf", "sc", "sem", "sql", "temporal", "xs")
            return
                element li {element a {attribute href {concat("?q=", $x)}, $x}}
        }
    }
};

declare function local:build-table(){
element table {attribute class {"table table-bordered table-striped"},
    element thead {element tr {for $i in ("Name", "Arity", "Signature", "Parts", "Return Type") return element th {$i}}},
    element tbody {
        for $i in xdmp:functions()
            where fn:starts-with(xdmp:function-name($i) cast as xs:string, $restriction-base)
            order by xdmp:function-name($i) cast as xs:string
            return  
            (element tr {
                element td {element a { attribute href {concat("/documentation/functions.xqy?q=",fn:function-name($i) cast as xs:string)},  fn:function-name($i) cast as xs:string}
            },
(: )element td {xdmp:describe($i) cast as xs:string}, :)
            element td {fn:function-arity($i)},
            element td {xdmp:function-signature(fn:function-lookup(fn:function-name($i), fn:function-arity($i)))},
            element td {   
            for $j in (1 to fn:function-arity($i))
            return(
            element p {
                xdmp:function-parameter-name($i,$j),
                xdmp:function-parameter-type($i,$j)
            }
            )
            },
            element td {xdmp:function-return-type($i) }
            (: )element td {
                (: xdmp:function-module(fn:function-lookup(fn:function-name($i), fn:function-arity($i))) :)
                if(not(empty(xdmp:function-module(fn:function-lookup(fn:function-name($i), fn:function-arity($i))))))
                then(xdmp:function-module(fn:function-lookup(fn:function-name($i), fn:function-arity($i))))
                else("N/A")       
             } :)
            })
        }    
    }
};


lib-view:create-bootstrap-page("Built-in functions",
    element div {
        attribute class {"container"},
            lib-view:page-header("Built-in functions", $restriction-base,local:restriction-base-dropdown-items()),
            element div {
                attribute class {"row"},
                element h3 {element a {attribute href {"http://docs.marklogic.com/"||$restriction-base}, attribute target {"_blank"}, $restriction-base}},
                local:build-table()
        }
    }
)