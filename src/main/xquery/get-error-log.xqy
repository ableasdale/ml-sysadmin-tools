xquery version "1.0-ml";

declare variable $filename := xdmp:get-request-field("filename", "ErrorLog.txt");
declare variable $PATHSEP := if (xdmp:platform()="winnt") then "\\" else "/";
declare variable $FILEPATH :=  concat(xdmp:data-directory(), $PATHSEP,"Logs", $PATHSEP,$filename);

let $data := xdmp:external-binary($FILEPATH)

(: 
 let $range := (fn:replace(fn:normalize-space($range), "bytes=", ""),"0-")[1]
        let $splits := tokenize($range, "-")
:)

let $range := xdmp:get-request-header("Range")
(: let $_ := xdmp:log(concat("Requested range: ",xdmp:get-request-header("Range"))) :)
(: let $_ := xdmp:add-response-header("Content-Range", concat("bytes 0-",xdmp:binary-size($data)-1)) :)
return 
  if ($range)
  then  
    let $range := replace(normalize-space($range), "bytes=", "")
    let $splits := tokenize($range, "-")
    (: let $_ := xdmp:log(concat("R1: ", $splits[1], " R2: ", $splits[2])) :)
    let $start := if ($splits[1] eq "") then (xdmp:log("going from the top"), 0) else (xs:integer($splits[1])) 
    (:  This isn't so great right now - our tail currently starts right from the top of the file...  Can we get it to start nearer to the end?
    xdmp:binary-size($data) - $splits[2]
    :)
    let $end := if ($splits[2] eq "")
                then xdmp:binary-size($data)-1
                else xs:integer($splits[2])
    let $ranges  := 
        concat("bytes ", $start, "-", $end, "/",
               xdmp:binary-size($data))
    (: let $_ := xdmp:log("ranges: " || $ranges) :)
    return (xdmp:add-response-header("Content-Range", $ranges),
            (: xdmp:set-response-content-type("text/plain"), :)
            xdmp:set-response-code(206, "Partial Content"),
            xdmp:subbinary($data, $start, $end))
            (: xdmp:subbinary($data, $start+1, $end - $start + 1)) :)
    else $data 