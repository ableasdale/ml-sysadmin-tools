xquery version '1.0-ml';

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace sv = "http://marklogic.com/xdmp/status/server";

declare variable $stats as element (sv:server-status)+ := xdmp:server-status(xdmp:host(),xdmp:servers());

declare function local:servers() {

    (:  let $map := map:map()
    let $_ :=
        let $servers := $dump//sv:server-status

        for $server in $servers
        let $e := map:get($map, $server/sv:server-name)
        return
            map:put($map, $server/sv:server-name,
                if ($e)
                then
                    element info {
                        $e/(name | kind),
                        element rate {$server/sv:request-rate/fn:number(.) + $e/rate}
                    }
                else
                    element info {
                        element name {$server/sv:server-name/fn:string(.)},
                        element kind {$server/sv:server-kind/fn:string(.)},
                        element rate {$server/sv:request-rate/fn:number(.)}

                    }

            )
    return :)
    (: element textarea {$stats}, :)
    element table {
        attribute class {"table table-striped table-bordered"},
        element thead { attribute class {"thead-inverse"},
            element tr {
                element th {"Name"},
                element th {"Type"},
                element th {"Enabled"},
                element th {"Modules root"},
                element th {"Request timeout"},
                element th {"Port"},
                element th {"Threads"},
                element th {"MVCC"},
                element th {"Rate"}
            }
        },
        element tbody {
            for $server in $stats
            order by number($server/sv:port)
            return
                element tr {
                    element td {fn:data($server/sv:server-name)},
                    element td {fn:data($server/sv:server-kind)},
                    element td {if(fn:data($server/sv:enabled eq fn:true())) then(attribute class {"success"}) else(attribute class {"danger"}),  fn:data($server/sv:enabled)},
                    element td {fn:data($server/sv:root)},
                    element td {fn:data($server/sv:request-timeout)},
                    element td {fn:data($server/sv:port)},
                    element td {fn:data($server/sv:threads)," / ", fn:data($server/sv:max-threads)},
                    element td {fn:data($server/sv:multi-version-concurrency-control)},
                    element td {fn:data($server/sv:request-rate)}
                }
            }
    }
};


lib-view:create-bootstrap-page("MarkLogic Tools: Security Database Layout",
    element div {
        attribute class {"container"},
        lib-view:page-header("Host information", "Cluster status", " "),
        element div {attribute class {"row"},
            element h4 {"Current Timestamp time: ", element small{xdmp:timestamp-to-wallclock(xdmp:request-timestamp())}},
            local:servers()
        }
    })
