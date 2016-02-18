xquery version "1.0-ml";

declare variable $CHUNKSIZE := (30 * 1024 + 1); (: Calls for data at the  JS layer are in 30K chunks - adding one so there's always more to request on HTTP 206 :)
declare variable $FILENAME := xdmp:get-request-field("filename", "ErrorLog.txt");
declare variable $PATHSEP := if (xdmp:platform() = "winnt") then "\\" else "/";
declare variable $FILEPATH := concat(xdmp:data-directory(), $PATHSEP, "Logs", $PATHSEP, $FILENAME);
declare variable $DATA := xdmp:external-binary($FILEPATH);
declare variable $RANGE := xdmp:get-request-header("Range");
(: 
 let $range := (fn:replace(fn:normalize-space($range), "bytes=", ""),"0-")[1]
        let $splits := tokenize($range, "-")
:)
if ($RANGE)
then
    let $range := replace(normalize-space($RANGE), "bytes=", "")
    let $splits := tokenize($range, "-")
    (: let $_ := xdmp:log(concat("Range request 1: ", $splits[1], " Range request 2: ", $splits[2])) :)
    let $start := if ($splits[1] eq "") then ( xdmp:binary-size($DATA) - $CHUNKSIZE) else (xs:integer($splits[1]))
    let $end := if ($splits[2] eq "")
    then xdmp:binary-size($DATA) - 1
    else xs:integer($splits[2])
    let $ranges :=
        concat("bytes ", $start, "-", $end, "/", xdmp:binary-size($DATA))
    (: let $_ := xdmp:log("Response will return the 'Content-Range': " || $ranges) :)
    return (xdmp:add-response-header("Content-Range", $ranges),
    xdmp:set-response-content-type("text/plain"),
    xdmp:set-response-code(206, "Partial Content"),
    xdmp:subbinary($DATA, $start + 1, $end))
else $DATA