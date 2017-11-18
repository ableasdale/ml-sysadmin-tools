xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace xdmp = "http://marklogic.com/xdmp";

(: Module main :)
lib-view:create-bootstrap-page("MarkLogic Tools: Overview",
    element div {attribute class {"container"},
        lib-view:page-header("MarkLogic Cluster", "Overview", " "),
        element div {attribute class {"row"},    
            <div class="col-md-8">
                {
                    element h4 {"Your system at a glance"},
                    element div {
                        attribute id {"overview"}, " "
                    }
                },  
            </div>,
            <div class="col-md-4">
                <h5>System Stats</h5>
                <dl class="dl-horizontal">
                    <dt>OS / Architecture</dt>
                    <dd>{xdmp:platform() || " (" || xdmp:architecture() || ")"}</dd>
                    <dt>Request Timestamp</dt>
                    <dd>{xdmp:request-timestamp()}</dd>
                    <dt>Hosts in cluster</dt>
                    <dd>{count(xdmp:hosts())}</dd>
                    <dt>Total databases</dt>
                    <dd>{count(xdmp:databases())}</dd>
                    <dt>Total forests</dt>
                    <dd>{count(xdmp:forests())}</dd>
                </dl>
            </div>,
            <div id="tooltip" class="hidden"></div>
        }   
    },
    <script src="/assets/js/cluster.js">{" "}</script>)
