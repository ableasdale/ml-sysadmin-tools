xquery version "1.0-ml";

declare function local:database-preview() {
    element table{
        attribute class {"table table-striped table-bordered"},
  
  let $dbs := ($dump//db:databases)[1]/db:database
  for $db in $dbs
  let $db-name := $db/(db:database-name)/fn:string(.)
  let $indexes := fn:string-join($db/*[fn:string(.) = "true"]/fn:local-name(.), ",")
  let $fragments := 0
  let $dfragments := 0
  let $documents := 0
  let $size := 0
  let $memory := 0
  order by $db/db:database-name
  return 
  (    

       element tr {
          element th {  attribute colspan {"10"}, $db-name  }
       },
       element tr {
          element td {  attribute colspan {"10"}, $indexes  }
       },
       element tr {
    
    element td { "Forests"},
    element td { "Host"},
    element td { "Stands"},
    element td { "Active Fr"},
    element td { "Deleted Fr"},
    element td { "Documents"},
    element td { "DB Size"},
    element td { "Mem Size"},
    element td { "LC Ratio"},
    element td { "LC Hit/Miss Rate"},
    element td { "CTC Ratio"}

  },
       for $f at $j in $db/db:forests/db:forest-id/fn:string(.)
       let $fs := map:get($FSTAT, $f)
       let $fc := map:get($FCOUNTS, fn:string($fs//f:current-master-forest))
       let $ms := map:get($FSTAT, fn:string($fs//f:current-master-forest))
       let $replicas := $fs//f:replica-forest/fn:string(.)
       let $rs := for $r  in $replicas return map:get($FSTAT, $r)
       let $forest-host := map:get($HOSTS, fn:string($fs/f:host-id))
       let $group := map:get($GROUPS, fn:string($forest-host/h:group))
       let $_ := xdmp:set($fragments, $fragments +fn:sum($fc//f:active-fragment-count) )
       let $_ := xdmp:set($dfragments, $dfragments +fn:sum($fc//f:deleted-fragment-count) )
       let $_ := xdmp:set($size, $size + fn:sum($fs//f:disk-size) )
       let $_ := xdmp:set($memory, $memory + fn:sum($fs//f:memory-size) )
       let $_ := xdmp:set($documents, $documents +fn:sum($fc//f:document-count) )
       order by $group/g:group-name
       return 
        element tr {
          
          element td { attribute style {"padding-left:20px"}, fn:string($fs/f:forest-name)},
          
          element td { fn:string($forest-host/h:host-name), "-" , fn:data(map:get($GROUPS, $forest-host/h:group/fn:string(.))/g:group-name)},
          element td { fn:count($fs//f:stand)},
          element td { local:format(fn:sum($fc//f:active-fragment-count)  div 1000000)},
          element td { local:format(fn:sum($fc//f:deleted-fragment-count) div 1000000)},
          element td { local:format(fn:sum($fc//f:document-count) div 1000000)},
          element td { local:format(fn:sum($fs//f:disk-size) div 1024)},
          element td { local:format(fn:sum($fs//f:memory-size) div  1024)},
          element td { local:ratio($ms//f:list-cache-hits,$ms//f:list-cache-misses)},
          element td { local:format(fn:avg($ms//f:list-cache-hit-rate)), "/",  local:format(fn:avg($ms//f:list-cache-miss-rate))},
         
          element td { local:ratio($ms//f:compressed-tree-cache-hits,$ms//f:compressed-tree-cache-misses)}
          
        },
         element tr {
          
          element td { attribute style {"padding-left:20px"}, "Total"},
          
          element td { " "},
          element td { " "},
          element td { local:format($fragments  div 1000000)},
                    element td { local:format($dfragments  div 1000000)},
          element td { local:format($documents  div 1000000)},
                    element td { local:format($size  div 1024)},
                    element td { local:format($memory  div 1024)}
          
          
        }
 )
}

};
