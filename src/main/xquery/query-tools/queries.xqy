xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";

declare namespace ss = "http://marklogic.com/xdmp/status/server";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $debug as xs:boolean := fn:false();

declare function local:request($request-status as element(ss:request-status)) as element()+
{
    if ((fn:current-dateTime() - $request-status/ss:start-time) gt xs:dayTimeDuration("PT1M"))
    then (
    <tr class="red">
        <td>{xdmp:server-name($request-status/ss:server-id)}</td>
        <td>{xdmp:host-name($request-status/ss:host-id)}</td>
        <td>{fn:current-dateTime() - $request-status/ss:start-time}</td>
        <td>{$request-status/ss:client-address}</td>
    </tr>,
    <tr>
        <td colspan="4" class="info">
            <ul>
                <li><strong>Request ID:</strong> {fn:data($request-status/ss:request-id)}</li>
                <li><strong>Transaction ID:</strong> {fn:data($request-status/ss:transaction-id)}</li>
                <li><strong>Canceled:</strong> {fn:data($request-status/ss:canceled)}</li>
                <li><strong>Modules:</strong> {fn:data($request-status/ss:modules)}</li>
                <li><strong>Database:</strong> {xdmp:database-name(fn:data($request-status/ss:database))}</li>
                <li><strong>Root:</strong> {fn:data($request-status/ss:root)}</li>
                <li><strong>Request Kind:</strong> {fn:data($request-status/ss:request-kind)}</li>
                <li><strong>Request Text:</strong> {fn:data($request-status/ss:request-text)}</li>
                <li><strong>Request Text (Rewritten):</strong> {fn:data($request-status/ss:request-rewritten-text)}</li>
                <li><strong>Start Time: </strong> {fn:data($request-status/ss:start-time)}</li>
                <li><strong>Update:</strong> {fn:data($request-status/ss:update)}</li>
                <li><strong>Time-Limit:</strong> {fn:data($request-status/ss:time-limit)}</li>
                <li><strong>Max Time Limit:</strong> {fn:data($request-status/ss:max-time-limit)}</li>
                <li><strong>User:</strong> 
                {let $uid:=fn:data($request-status/ss:user)
                 return xdmp:eval(
                 'import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";
                  declare variable $uid as xs:unsignedLong external; 
                  sec:get-user-names($uid)/text()', 
    
                  (xs:QName("uid"), $uid), 
                   <options xmlns="xdmp:eval">
                      <isolation>different-transaction</isolation>
                      <database>{xdmp:security-database()}</database>
                   </options>)}</li>
                <li><strong>Trigger Depth:</strong> {fn:data($request-status/ss:trigger-depth)}</li>
                <li><strong>Expanded Tree Cache Hits:</strong> {fn:data($request-status/ss:expanded-tree-cache-hits)}</li>
                <li><strong>Expanded Tree Cache Misses:</strong> {fn:data($request-status/ss:expanded-tree-cache-misses)}</li>
                <li><strong>Request State:</strong> {fn:data($request-status/ss:request-state)}</li>
                <li><strong>Profiling Allowed:</strong> {fn:data($request-status/ss:profiling-allowed)}</li>
                <li><strong>Profiling Enabled:</strong> {fn:data($request-status/ss:profiling-enabled)}</li>
                <li><strong>Debugging Allowed:</strong> {fn:data($request-status/ss:debugging-allowed)}</li>
                <li><strong>Debugging Status:</strong> {fn:data($request-status/ss:debugging-status)}</li>
            </ul>
        </td>
        {if ($debug)
        then (<td colspan="4"><textarea>{$request-status}</textarea></td>)
        else ()}
    </tr> )
    else ((<tr class="grn"><td colspan="4"><em>Transaction {fn:data($request-status/ss:request-id)} currently under 60s (@ {fn:current-dateTime() - $request-status/ss:start-time})</em></td></tr>))
};
    
(: Module main :)

lib-view:create-bootstrap-page("MarkLogic Tools: Running Queries",
    (
    lib-view:page-header("Long running queries", "TODO", ()),
    
    element h3 {"Cluster application server status @ ",fn:current-dateTime()},
    element table {attribute class {"table table-bordered table-striped"},
        element thead {element tr {for $i in ("Server", "Host", "Elapsed Time", "Invoked by") return element th {$i}}},
        element tbody {	
          for $grp in xdmp:groups()
          return
          for $host in xdmp:group-hosts($grp)
          for $server in xdmp:group-servers($grp)
          return 
          try { local:request(xdmp:server-status($host, $server)//ss:request-status)}
          catch ($e) {xdmp:log(concat("[MarkLogic Support Request Script] - Unable to access the application server status for the application server named: ", xdmp:server-name($server), " on the host: ", xdmp:host-name($host)), "error")}
    }}
            
    )
)


        
        
            
            