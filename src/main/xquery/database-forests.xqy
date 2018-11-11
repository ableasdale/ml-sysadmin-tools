xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace f = "http://marklogic.com/xdmp/status/forest";
declare namespace l = "http://marklogic.com/xdmp/forest/label";

declare variable $FID as xs:unsignedLong := xs:unsignedLong(xdmp:get-request-field("forestid", xs:string(xdmp:forest("Documents"))));
declare variable $COUNTS := xdmp:forest-counts($FID);
declare variable $PATH := xs:string(xdmp:forest-counts($FID)//f:path)[1];
declare variable $LABEL := fn:substring($PATH, 1, common:index-of-string($PATH, $common:PATHSEP)[last()]) || "Label";

declare variable $LABELXML := xdmp:document-get($LABEL,
    <options xmlns="xdmp:document-get">
        <format>xml</format>
    </options>);

lib-view:create-bootstrap-page("MarkLogic Tools: Forest Label Information",
    <div class="container">{
        lib-view:page-header("Label information ", xdmp:forest-name($FID), " "),
        <ul>{
            for $i in xdmp:databases()
            return (element li {xdmp:database-name($i)},
            element ul {for $j in xdmp:database-forests($i, fn:true()) return element li {element a {attribute href {"?forestid="||$j}, xdmp:forest-name($j)}}}
            )
        }
        </ul>,
        <h3>Forest Label Status</h3>,
        <h4>{xdmp:forest-name($FID)|| " ("||$FID||")"}</h4>,
        common:forest-label-table($LABELXML/node()),
        element pre {element code {xdmp:quote($LABELXML)}},       
        <h3>Forest Counts</h3>,
        element pre {element code {xdmp:quote($COUNTS)}}
    }</div>
)
