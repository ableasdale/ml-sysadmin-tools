xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";
import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare namespace d="http://marklogic.com/xdmp/database";
declare namespace f = "http://marklogic.com/xdmp/status/forest";

declare function local:qname-key($uri,$nam)
{
    xdmp:add64(xdmp:mul64(xdmp:add64(xdmp:mul64(xdmp:hash64($uri),5), xdmp:hash64($nam)), 5), xdmp:hash64("qname()"))
};

declare function local:attr-key($euri,$enam,$auri,$anam)
{
    xdmp:add64(xdmp:mul64(xdmp:add64(xdmp:mul64(local:qname-key($euri,$enam),5), xdmp:hash64("/@")), 5), local:qname-key($auri,$anam))
};

declare function local:element-range-index($uri, $nam)
{
    xdmp:integer-to-hex(local:qname-key($uri,$nam))
};

declare function local:element-attribute-range-index($euri,$enam,$auri,$anam)
{
    xdmp:integer-to-hex(local:attr-key($euri,$enam,$auri,$anam))
};

declare function local:get-element-range-index-keys($map as map:map,$db-name as xs:string)
{
    let $ranges := admin:database-get-range-element-indexes(admin:get-configuration(), xdmp:database($db-name))
    for $range in $ranges
    let $uri := fn:string($range/d:namespace-uri)
    let $coll := fn:string($range/d:collation)
    let $ckey :=
        if (
            $coll eq "http://marklogic.com/collation/codepoint"
                    or $range/d:scalar-type ne "string"
        )
        then "-"
        else fn:concat("-", xdmp:integer-to-hex(xdmp:hash64($coll)), "+")
    for $name in fn:tokenize(fn:string($range/d:localname), " ")
    let $nam := fn:string($name)
    let $key := local:element-range-index($uri, $nam)
    for $pos in (
        "",
        if (data($range/d:range-value-positions)) then "=" else ()
    )
    let $fkey := fn:concat($key, $ckey, $range/d:scalar-type, $pos)
    let $uri := if($uri) then $uri else "empty"
    return map:put($map,$fkey,fn:concat($uri,":",$nam))
};

declare function local:get-element-attribute-range-index-keys($map as map:map,$db-name as xs:string)
{
    let $ranges := admin:database-get-range-element-attribute-indexes(admin:get-configuration(),xdmp:database($db-name))
    for $range in $ranges
    let $euri := fn:string($range/d:parent-namespace-uri)
    let $auri := fn:string($range/d:namespace-uri)
    let $coll := fn:string($range/d:collation)
    let $ckey :=
        if (
            $coll eq "http://marklogic.com/collation/codepoint"
                    or $range/d:scalar-type ne "string"
        )
        then "-"
        else fn:concat("-", xdmp:integer-to-hex(xdmp:hash64($coll)), "+")
    for $ename in fn:tokenize(fn:string($range/d:parent-localname), " ")
    let $enam := fn:string($ename)
    for $aname in fn:tokenize(fn:string($range/d:localname), " ")
    let $anam := fn:string($aname)
    for $pos in (
        "",
        if (data($range/d:range-value-positions)) then "=" else ()
    )
    let $key := local:element-attribute-range-index($euri, $enam, $auri, $anam)
    let $fkey := fn:concat($key, $ckey, $range/d:scalar-type, $pos)
    return map:put($map,$fkey,fn:concat($euri,":",$enam,"@",$auri,":",$anam))
};

declare function local:get-slash(){
    if(xdmp:platform() eq "winnt") then "\" else "/"
};

declare function local:get-forest-data-directory($forest-id) as xs:string{
    let $dir := admin:forest-get-data-directory(admin:get-configuration(),$forest-id)
    let $dir := if($dir) then $dir else xdmp:data-directory()
    let $dir := if(fn:ends-with($dir,local:get-slash())) then $dir else fn:concat($dir,local:get-slash())
    return
        fn:concat($dir,"Forests",local:get-slash(),xdmp:forest-name($forest-id))
};

declare function local:get-stand-directories($dir as xs:string){
    for $entry in xdmp:filesystem-directory($dir)//dir:entry
    return
        if(($entry/dir:type = "directory") and fn:not($entry/dir:filename/text() = ("Journals","Large"))) then
            $entry//dir:pathname/text()
        else()
};

declare function local:add-to-memory-map($map as map:map,$entry as element(dir:entry)){
    let $filename := fn:replace($entry/dir:filename/text(),"-$","")
    let $null := if(map:get($map,$filename)) then () else map:put($map,$filename,0)
    return
        map:put($map,$filename,map:get($map,$filename) + xs:long($entry/dir:content-length/text()))
};

declare function local:format-number($number){
    if($number > 1024 * 1024 * 1024) then
        fn:concat(xs:string(xs:int($number div (1024 * 1024)) div 1000),"G")
    else if($number > 1024 * 1024) then
        fn:concat(xs:string(xs:int($number div 1024) div 1000),"M")
    else if($number > 1024) then
            fn:concat(xs:string($number div 1000),"K")
        else
            xs:string($number)
};

declare function local:compute-indexes($db-name){

    let $map := map:map()
    let $name-map := map:map()
    let $null := (local:get-element-range-index-keys($name-map,$db-name),local:get-element-attribute-range-index-keys($name-map,$db-name))
    let $null :=
        for $forest in admin:database-get-attached-forests(admin:get-configuration(),xdmp:database($db-name))
        return
            for $dir in local:get-stand-directories(local:get-forest-data-directory($forest))
            return
                (: TODO - these need to be invoked! :)
                for $entry in xdmp:filesystem-directory($dir)//dir:entry
                return
                    local:add-to-memory-map($map,$entry)
    return
        (
            element h3 {"Range Indexes and Lexicons"},
            element table {
                attribute class {"table table-striped table-bordered"},
                element thead {
                    element tr {
                        for $i in ("Key", "Range Index / Lexicon", "Total Size")
                        return
                        element th {$i}
                    }
                },
                element tbody {

                    for $key in map:keys($map)
                    let $range-index := map:get($name-map, $key)
                    let $range-index := if (fn:lower-case($key) = "4c8c228348a3b60d-string") then "URI Lexicon" else $range-index
                    let $range-index := if (fn:lower-case($key) = "702c7a5fff541f5e-string") then "Collection Lexicon" else $range-index
                    let $range-index := if ($range-index) then $range-index else "Mapping not known"
                    where fn:not(fn:matches($key, "^[^\d]*$"))
                    order by map:get($map, $key) descending
                    return
                    element tr { (:fn:concat($key, ",", $range-index, ",", local:format-number(map:get($map, $key))):)
                        element td {$key},
                        element td {$range-index},
                        element td {local:format-number(map:get($map, $key))}
                    }
                }
            },
            element h3 {"Other Memory Mapped Files ", element small {"(not range indexes)"}},
            element dl {
                attribute class {"dl-horizontal"},
                for $key in map:keys($map)
                where (fn:matches($key,"^[^\d]*$") and fn:not($key = ("ListData","TreeData")))
                order by map:get($map,$key) descending
                return (
                    element dt {$key},
                    element dd {local:format-number(map:get($map,$key))}
                )
            }
        )
};

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Range Index Utilisation",
element div {
    attribute class {"container"},
        lib-view:page-header("Range Index Use", $common:DATABASE, lib-view:database-select()),
        local:compute-indexes($common:DATABASE)

    }
)
