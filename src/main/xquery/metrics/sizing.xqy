xquery version "1.0-ml";
declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace fs="http://marklogic.com/xdmp/status/forest";
 
let $sizing := <sizing xmlns="http://marklogic.com/xdmp/status/forest">{
  attribute version { xdmp:version() },
  attribute now { current-dateTime() },
  for $f in xdmp:database-forests(xdmp:database())
  let $name := xdmp:forest-name($f)
  let $status := xdmp:forest-status($f)
  let $counts := xdmp:forest-counts($f)
  let $stands as xs:unsignedLong* :=
    $status/stands/stand[disk-size ge memory-size]/stand-id
  return element forest {
    $counts/stands-counts/stand-counts[ stand-id = $stands ]
      /(active-fragment-count|nascent-fragment-count
        |deleted-fragment-count),
    $status/stands/stand[ stand-id = $stands ]
      /(disk-size|memory-size),
      $status/large-data-size,
    <large-binary-fragments>{xdmp:estimate(/binary()[xdmp:binary-is-large(.)])}</large-binary-fragments>

  }
}
</sizing>
let $fragments := sum((
  0,
  $sizing/fs:forest/(
    fs:active-fragment-count|fs:nascent-fragment-count
    |fs:deleted-fragment-count)
))
let $docs := xdmp:estimate(doc())
let $in-memory-mb := sum((0, $sizing/fs:forest/fs:memory-size))
let $in-memory-b := $in-memory-mb * 1024 * 1024
let $on-disk-mb := sum((0, $sizing/fs:forest/fs:disk-size))
let $on-disk-b := $on-disk-mb * 1000 * 1000
let $large-binary-fragments := sum((0, $sizing/fs:forest/fs:large-binary-fragments))
let $large-binary-size := sum((0,$sizing/fs:forest/fs:large-data-size))

return <sizing xmlns="http://marklogic.com/xdmp/status/forest">{
  $sizing/@*,
  element fragments { $fragments },
  element documents { $docs },
  element in-memory-MB { $in-memory-mb },
  element large-binary-fragment-count { $large-binary-fragments }, 
  element large-binary-size-MB { $large-binary-size } ,
  if (not($fragments)) then ()
  else element in-memory-B-per-fragment { $in-memory-b div $fragments },
  element in-memory-B-per-document { $in-memory-b div $docs },
  element on-disk-MB { $on-disk-mb },
  if (not($fragments)) then ()
  else element on-disk-B-per-fragment { $on-disk-b div $fragments },
  element on-disk-B-per-document { $on-disk-b div $docs }
}
</sizing>
