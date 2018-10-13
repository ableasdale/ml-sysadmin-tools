xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare function local:index-of-string
  ( $arg as xs:string? ,
    $substring as xs:string )  as xs:integer* {

  if (contains($arg, $substring))
  then (string-length(substring-before($arg, $substring))+1,
        for $other in
           local:index-of-string(substring-after($arg, $substring),
                               $substring)
        return
          $other +
          string-length(substring-before($arg, $substring)) +
          string-length($substring))
  else ()
 } ;

declare variable $COUNTS := xdmp:forest-counts(xs:unsignedLong(xdmp:get-request-field("forestid")));
declare variable $LABEL := fn:substring($COUNTS//*:path[1], 1, local:index-of-string($COUNTS//*:path[1], "\")[last()]) || "Label";

lib-view:create-bootstrap-page("MarkLogic Tools: Rebalancer preview",
    <div class="container">{
        lib-view:page-header("Database Overview", "All Databases and Forests", " "),
        <ul>{
            for $i in xdmp:databases()
            return (element li {xdmp:database-name($i)},
            element ul {for $j in xdmp:database-forests($i, fn:true()) return element li {element a {attribute href {"?forestid="||$j}, xdmp:forest-name($j)}}}
            )
        }
        </ul>,
        <p>{$COUNTS//*:path[1]}</p>,
        <p>TODO - windows \ and linux /</p>,
        <h3>Label</h3>,
        <p>{fn:substring($COUNTS//*:path[1], 1, local:index-of-string($COUNTS//*:path[1], "\")[last()])}</p>,
        <h3>Counts</h3>,
        element pre {element code {xdmp:tidy(xdmp:filesystem-file($LABEL))  }},

element pre {element code {
        xdmp:document-get($LABEL,
   <options xmlns="xdmp:document-get">
     <format>xml</format>
    </options>)
}},
        element pre {element code {xdmp:quote($COUNTS)}}

    }</div>
)
