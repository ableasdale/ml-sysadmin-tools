xquery version "1.0-ml";

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
		"children": [{
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

xdmp:set-response-content-type("application/json"), xdmp:unquote($test-json)