xquery version "1.0-ml";

declare variable $FILES as xs:string+ := ("databases.xml", "hosts.xml", "groups.xml", "assignments.xml", "clusters.xml", "server.xml");
declare variable $FILENAMES as xs:string+ := for $i in $FILES return xdmp:hosts() ! ("file://"||xdmp:host-name(.)||xdmp:data-directory()||"/"||$i);
declare variable $ZIPFILENAME as xs:string := "/tmp/ml-configfiles-"||fn:format-dateTime(fn:current-dateTime(),"[Y01]_[M01]_[D01]_[H01]_[m01]_[s01]")||".zip";

declare function local:write-zipfile() {
    let $zip := xdmp:zip-create(
            <parts xmlns="xdmp:zip">{for $i in $FILENAMES return element part {$i}}</parts>,
            (for $i in $FILENAMES return xdmp:document-get($i))
    )
    return xdmp:save($ZIPFILENAME, $zip,
                <options xmlns="xdmp:save">
                    <encoding>utf8</encoding>
                </options>)
};

local:write-zipfile(),
xdmp:set-response-content-type("application/zip"),
xdmp:add-response-header("Content-Disposition", fn:concat("attachment; filename=", $ZIPFILENAME)),
xdmp:external-binary($ZIPFILENAME)