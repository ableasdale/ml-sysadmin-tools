xquery version "1.0-ml";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";
declare namespace f = "http://marklogic.com/xdmp/status/forest";

declare variable $small-test-json as xs:string := '{
	"children": [{
		"name": "1945",
		"children": [{
			"name": "Buddhism",
			"children": [{
				"year": "1945",
				"cat": "Buddhism",
				"type": "Other",
				"pop": 116237936
			}]
		}, {
			"name": "Christianity",
			"children": [{
				"year": "1945",
				"cat": "Christianity",
				"type": "Anglican",
				"pop": 36955033
			}, {
				"year": "1945",
				"cat": "Christianity",
				"type": "Mahayana",
				"pop": 160887585
			}]
		}, {
			"name": "Islam",
			"children": [{
				"year": "1945",
				"cat": "Islam",
				"type": "Ibadhi",
				"pop": 62273219
			}, {
				"year": "1945",
				"cat": "Islam",
				"type": "Sunni",
				"pop": 49050320
			}]
		}, {
			"name": "Judaism",
			"children": [{
				"year": "1945",
				"cat": "Judaism",
				"type": "Conservative",
				"pop": 49050320
			}, {
				"year": "1945",
				"cat": "Judaism",
				"type": "Reform",
				"pop": 49050320
			}]
		}]
    }]
}';



declare variable $test-json as xs:string := '{
	"children": [{
		"name": "1945",
		"children": [{
			"name": "Buddhism",
			"children": [{
				"year": "1945",
				"cat": "Buddhism",
				"type": "Other",
				"pop": 116237936
			}]
		}, {
			"name": "Christianity",
			"children": [{
				"year": "1945",
				"cat": "Christianity",
				"type": "Anglican",
				"pop": 36955033
			}, {
				"year": "1945",
				"cat": "Christianity",
				"type": "Mahayana",
				"pop": 160887585
			}]
		}, {
			"name": "Islam",
			"children": [{
				"year": "1945",
				"cat": "Islam",
				"type": "Ibadhi",
				"pop": 62273219
			}, {
				"year": "1945",
				"cat": "Islam",
				"type": "Sunni",
				"pop": 49050320
			}]
		}, {
			"name": "Judaism",
			"children": [{
				"year": "1945",
				"cat": "Judaism",
				"type": "Conservative",
				"pop": 49050320
			}, {
				"year": "1945",
				"cat": "Judaism",
				"type": "Reform",
				"pop": 49050320
			}]
		}]
	}, {
		"name": "1950",
		"label": "I want to see this",
		"children": [{
			"label" : "DoesThisDisplay?",
			"name": "Buddhism",
			"children": [{
				"year": "1950",
				"cat": "Buddhism",
				"type": "Other",
				"pop": 144980765
			}, {
				"year": "1950",
				"cat": "Buddhism",
				"type": "Theravada",
				"pop": 14031137
			}]
		}, {
			"name": "Christianity",
			"children": [{
				"year": "1950",
				"cat": "Christianity",
				"type": "Anglican",
				"pop": 38307544
			}, {
				"year": "1950",
				"cat": "Christianity",
				"type": "Mahayana",
				"pop": 133301043
			}]
		}, {
			"name": "Islam",
			"children": [{
				"year": "1950",
				"cat": "Islam",
				"type": "Alawite",
				"pop": 387994
			}, {
				"year": "1950",
				"cat": "Islam",
				"type": "Sunni",
				"pop": 56921304
			}]
		}]
	}]
}';


declare function local:host-get-forest-details($hostname as xs:string) {
for $i in xdmp:host-forests(xdmp:host())
let $fc := xdmp:forest-counts($i)
return object-node {
    "name" : text {xdmp:forest-name($i)},

    "children" : array-node { object-node {
        "pop"  : text { fn:data($fc/f:document-count) },
        "active"  : text { fn:data(sum($fc//f:active-fragment-count)) },
        "nascent" : text { fn:data(sum($fc//f:nascent-fragment-count)) },
        "deleted" : text { fn:data(sum($fc//f:deleted-fragment-count)) }
    }}
(: "parent" : text {$common:DATABASE} :)
}
};

(: json:object-node {"hello": "world"}
object-node {
"name" : text {$common:DATABASE},
"parent" : text {"null"},
"children" : array-node {local:database-get-forest-details(xdmp:database($common:DATABASE))}
} :)

object-node {
    "children" : array-node {
        for $i in xdmp:host-name(xdmp:hosts())
        return object-node {
        "name" : text {$i},
        "children" : array-node {local:host-get-forest-details($i)}
        }
    }
}


(: To return test data ^ just do the following
xdmp:set-response-content-type("application/json"), xdmp:unquote($small-test-json) :)

(:
/*


{"children":[{
    "name":"localhost.localdomain",
    "children":[{
        "name":"Triggers",
        "children":{"pop":"0", "foo":"bar"}}, {"name":"App-Services", "children":{"pop":"3", "foo":"bar"}}, {"name":"Last-Login", "children":{"pop":"0", "foo":"bar"}}, {"name":"Modules", "children":{"pop":"0", "foo":"bar"}}, {"name":"Fab", "children":{"pop":"0", "foo":"bar"}}, {"name":"Extensions", "children":{"pop":"0", "foo":"bar"}}, {"name":"Schemas", "children":{"pop":"0", "foo":"bar"}}, {"name":"Meters", "children":{"pop":"488", "foo":"bar"}}, {"name":"Documents", "children":{"pop":"0", "foo":"bar"}}, {"name":"Security", "children":{"pop":"1221", "foo":"bar"}}]}]}


{"children":[{
    "name":"localhost.localdomain",
    "children":[{
        "name":"Triggers", "pop":"0"}, {"name":"App-Services", "pop":"3"}, {"name":"Last-Login", "pop":"0"}, {"name":"Modules", "pop":"0"}, {"name":"Fab", "pop":"0"}, {"name":"Extensions", "pop":"0"}, {"name":"Schemas", "pop":"0"}, {"name":"Meters", "pop":"307"}, {"name":"Documents", "pop":"0"}, {"name":"Security", "pop":"1221"}]}]}
*/
:)