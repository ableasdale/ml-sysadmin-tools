xquery version "1.0-ml";
declare namespace d="http://marklogic.com/xdmp/database";
declare namespace html = "http://www.w3.org/1999/xhtml";
declare namespace local = "urn:local";
declare namespace dir = "http://marklogic.com/xdmp/directory";

import module namespace admin = "http://marklogic.com/xdmp/admin" at "/MarkLogic/admin.xqy";

declare variable $config := admin:get-configuration();
declare variable $default-forest-directory := 
  if(xdmp:platform() = "winnt")
  then "Data/Forests/"
  else "/opt/MarkLogic/Data";
declare variable $forest-files-enumerated := ();

declare function local:get-forest-directories(
  $dbname as xs:string
) {
  for $forest in admin:database-get-attached-forests($config,xdmp:database($dbname))
  let $data-directory := admin:forest-get-data-directory($config,$forest)
  return  
     if(fn:exists($data-directory) and fn:normalize-space($data-directory) ne "")
     then fn:concat($data-directory,"/",xdmp:forest-name($forest))
     else fn:concat($default-forest-directory,xdmp:forest-name($forest))
};
declare function local:initialize-forest-files($dbname) {
 let $forest-files := 
  for $fd in local:get-forest-directories("measures") 
  return 
      local:recurse-filesystem($fd)
  return
     xdmp:set($forest-files-enumerated,$forest-files)
};
declare function local:recurse-filesystem($dir) {
  for $e in xdmp:filesystem-directory($dir)/dir:entry
  return
    if($e/dir:type = "directory") 
    then (local:recurse-filesystem($e/dir:pathname))
    else $e
};
declare function local:qname-key($uri, $nam)
{
  xdmp:add64(
    xdmp:mul64(
      xdmp:add64(
        xdmp:mul64(xdmp:hash64($uri), 5), xdmp:hash64($nam)),
      5),
    xdmp:hash64("qname()"))
};

declare function local:attr-key($euri, $enam, $auri, $anam)
{
  xdmp:add64(
    xdmp:mul64(
      xdmp:add64(
        xdmp:mul64(local:qname-key($euri, $enam), 5),
        xdmp:hash64("/@")),
      5),
    local:qname-key($auri, $anam))
};

declare function local:element-range-index($uri, $nam)
{
  xdmp:integer-to-hex(local:qname-key($uri, $nam))
};

declare function local:element-attribute-range-index($euri, $enam, $auri, $anam)
{
  xdmp:integer-to-hex(
    local:attr-key($euri, $enam, $auri, $anam))
};


declare function local:element-range-index-keys($ranges)
{
  for $range in $ranges
  let $uri := fn:string($range/d:namespace-uri)
  let $coll := fn:string($range/d:collation)
  let $ckey :=
    if ($coll eq "http://marklogic.com/collation/codepoint" or
        $range/d:scalar-type ne "string")
    then "-"
    else
      fn:concat("-", xdmp:integer-to-hex(xdmp:hash64($coll)), "+")
  for $name in fn:tokenize(fn:string($range/d:localname), " ")
  let $nam := fn:string($name)
  let $key := local:element-range-index($uri, $nam)

  let $fkey := fn:concat($key, $ckey, $range/d:scalar-type)
  let $files :=$forest-files-enumerated/self::dir:entry[dir:filename = $fkey or dir:filename = fn:concat($fkey,"-") or  dir:filename = fn:concat($fkey,"=")]
  return <element-range-index>
           <key>{$fkey}</key>
           <namespace-uri>{$uri}</namespace-uri> 
           <localname>{$name}</localname>
           <collation>{$coll}</collation>
           <size>{fn:sum($files/dir:content-length)}</size>
           <file-count>{fn:count($files)}</file-count>
         </element-range-index>
};

declare function local:element-attribute-range-index-keys($ranges)
{
  for $range in $ranges
  let $euri := fn:string($range/d:parent-namespace-uri)
  let $auri := fn:string($range/d:namespace-uri)
  let $coll := fn:string($range/d:collation)
  let $ckey :=
    if ($coll eq "http://marklogic.com/collation/codepoint" or
        $range/d:scalar-type ne "string")
    then "-"
    else
      fn:concat(
        "-", xdmp:integer-to-hex(xdmp:hash64($coll)), "+")
  for $ename in fn:tokenize(fn:string($range/d:parent-localname), " ")
  let $enam := fn:string($ename)
  for $aname in fn:tokenize(fn:string($range/d:localname), " ")
  let $anam := fn:string($aname)
  let $key :=local:element-attribute-range-index($euri, $enam, $auri, $anam)
  let $fkey := fn:concat($key, $ckey, $range/d:scalar-type)
  let $files := $forest-files-enumerated/self::dir:entry[dir:filename = $fkey or dir:filename = fn:concat($fkey,"-") or dir:filename = fn:concat($fkey,"=")]
  return
    <element-attribute-range-index>
      <key>{$fkey}</key>
      <element-namespace>{$euri}</element-namespace>
      <element-localname>{$enam}</element-localname>
      <attribute-namespace>{$auri}</attribute-namespace>
      <attribute-localname>{$anam}</attribute-localname>
      <collation>{$coll}</collation>
      <size>{fn:sum($files/dir:content-length)}</size>
      <file-count>{fn:count($files)}</file-count>
    </element-attribute-range-index>
};
declare function local:field-range-index-keys($ranges)
{
  for $range in $ranges
  let $uri := "http://marklogic.com/fields"
  let $coll := fn:string($range/d:collation)
  let $ckey :=
    if ($coll eq "http://marklogic.com/collation/codepoint" or
        $range/d:scalar-type ne "string")
    then "-"
    else
      fn:concat("-", xdmp:integer-to-hex(xdmp:hash64($coll)), "+")
  for $name in fn:tokenize(fn:string($range/d:field-name), " ")
  let $nam := fn:string($name)
  let $key := local:element-range-index($uri, $nam)
  let $fkey := fn:concat($key, $ckey, $range/d:scalar-type)
  let $files :=$forest-files-enumerated/self::dir:entry[dir:filename = $fkey or dir:filename = fn:concat($fkey,"-") or dir:filename = fn:concat($fkey,"=")]
  return <field-range-index>
           <key>{$fkey}</key>
           <namespace-uri>{$uri}</namespace-uri> 
           <field-name>{$nam}</field-name>
           <collation>{$coll}</collation>
           <size>{fn:sum($files/dir:content-length)}</size>
           <file-count>{fn:count($files)}</file-count>
         </field-range-index>
};
let $config := admin:get-configuration() 
let $db := xdmp:database("measures") 
let $init := try {local:initialize-forest-files("measures")}catch($ex) {()}
let $eranges := admin:database-get-range-element-indexes($config, $db) 
let $earanges := admin:database-get-range-element-attribute-indexes($config,$db) 
let $franges  := admin:database-get-range-field-indexes($config,$db)
return ( 
   local:element-range-index-keys($eranges), 
   local:element-attribute-range-index-keys($earanges),
   local:field-range-index-keys($franges)
)


