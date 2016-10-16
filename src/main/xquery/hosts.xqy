xquery version '1.0-ml';

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace hs="http://marklogic.com/xdmp/status/host";
declare namespace h="http://marklogic.com/xdmp/hosts";
declare namespace f="http://marklogic.com/xdmp/status/forest";
declare namespace sec = "http://marklogic.com/xdmp/security";
declare namespace g="http://marklogic.com/xdmp/group";

(:
declare variable $HOSTS := xdmp:hosts();
declare variable $HOST-STATUS
:)

declare function local:statistics() {
	(: TODO - we call this twice - which is a bit stupid :)
	for $hostid at $i in xdmp:hosts()
	(: let $host := map:get($common:HOSTS, xs:string($hostid)) :)
	let $status := xdmp:host-status($hostid)
	let $forests := xdmp:forest-status(xdmp:host-forests($hostid))
	let $fcounts := xdmp:forest-counts(xdmp:host-forests($hostid))
	return (
		element pre {element code {xdmp:quote($status/hs:background-period)}},
		element pre {element code {xdmp:quote($status/hs:background-process)}}
	)
};

declare function local:hosts() {
    (:	let $map := map:map()
	let $_ := for $s in xdmp:host-status(xdmp:hosts()) return  map:put ($common:HOSTS, xs:string($s/hs:host-id), $s)
	let $forests:= map:map()
	let $_ := for $f in xdmp:forest-status(xdmp:forests()) return  map:put ($forests, $f/f:host-id/fn:string(.), (map:get($forests, $f/f:host-id/fn:string(.)), $f))
	return :)
	element table {
		attribute class {"table table-striped table-bordered"},
		element thead {
		element tr {
		    element th { "Host #"},
		    element th { "Name"},
		    element th { "Group"},
		    element th { "Forests"},
		    element th { "Forest Size (Gb)"},
		    element th { "Mem Size (Gb)"},
		    element th { "Version"},
		    element th { "Arch"},
		    element th { "CPUs"},
		    element th { "Cores"},
		    element th { "Memory (Gb)"},
		    element th { "Disk (Gb)"},
		    (: element th { "Disk free"},:)
		    element th { "Process Size" || element br {" "} || "(Linux only?)"},
		    element th { "Fragments (M)"}
    		}
    	},
		for $hostid at $i in xdmp:hosts()
        (: let $host := map:get($common:HOSTS, xs:string($hostid)) :)
		let $status := xdmp:host-status($hostid)
		let $forests := xdmp:forest-status(xdmp:host-forests($hostid))
		let $fcounts := xdmp:forest-counts(xdmp:host-forests($hostid))
		return
		(: ( debug element textarea {$status}, element textarea {$forests}, :)
		element tr {
			element td {"H" || $i},
			element td {$status/hs:host-name},
			element td {xdmp:group-name($status/hs:group-id)},
			element td {count($forests)},
			element td {common:format(fn:sum($forests//f:disk-size) div 1024) },
			element td {common:format(fn:sum($forests//f:memory-size) div 1024) },

			element td {fn:data($status/hs:version)},
			element td {fn:data($status/hs:architecture)},
			element td {fn:data($status/hs:cpus)},
			element td {fn:data($status/hs:cores)},
			element td {fn:data($status/hs:memory-size) div 1000},
			element td {common:format(($status//hs:data-dir-space ) div 1000) },
			element td {common:format(fn:data($status/hs:memory-process-size) div 1024)},
            element td { fn:sum($fcounts//f:active-fragment-count) div 1000000 } 
		}
	}
};


lib-view:create-bootstrap-page("MarkLogic Tools: Security Database Layout",
element div {
attribute class {"container"},
	lib-view:page-header("Host information", "Cluster status", " "),
	element div {attribute class {"row"},
	    element div {attribute id {"host-info"}}
	},
	element div {attribute class {"row"},
		element h4 {"Current Timestamp time: ", element small{xdmp:timestamp-to-wallclock(xdmp:request-timestamp())}},
	    local:hosts(),
		local:statistics()
	}
}, <script src="/assets/js/hosts.js">{" "}</script>)



