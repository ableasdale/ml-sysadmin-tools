xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace server = "http://marklogic.com/xdmp/status/server";
declare variable $host := xdmp:hosts()[1];

declare function local:txn-locks() {
let $oldest-request :=
(for $request in xdmp:server-status($host,xdmp:server("TaskServer"))//server:request-status
order by $request/server:start-time ascending
return
$request)[1]
let $transaction-id := $oldest-request/server:transaction-id
let $start-time := $oldest-request/server:start-time/text()
return
(
"Transaction "||$transaction-id,
"Started at "||$start-time,
xdmp:transaction-locks($host, $transaction-id)
)
};


lib-view:create-bootstrap-page("MarkLogic Tools: Term Key Explorer",
element div {
    attribute class {"container"},
    lib-view:page-header("Transaction Locks", $common:DATABASE,  lib-view:database-select()),
    element div { attribute class {"row"}, local:txn-locks() }
})