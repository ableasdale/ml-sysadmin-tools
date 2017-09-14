xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";

declare function local:get-estimate-for-database-by-id($id as xs:unsignedLong) as xs:unsignedLong {
  xdmp:invoke-function(function() { xdmp:estimate(doc()) },
      <options xmlns="xdmp:eval">
        <database>{$id}</database>
      </options>)
      (: xdmp:database("Documents") :)
};

element table {
  element thead {
    element tr {element th {"Database ID"}, element th {"Database Name"}, element th {"Document Count"}}
  },
  element tbody {
    for $i in xdmp:databases()
    return element tr { element td{$i}, element td{xdmp:database-name($i)}, element td{local:get-estimate-for-database-by-id($i)} }
  }
}
