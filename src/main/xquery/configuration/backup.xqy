xquery version "1.0-ml";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace dir = "http://marklogic.com/xdmp/directory";

declare variable $FILENAME as xs:string := common:generate-filename();

(:

for $i in xdmp:filesystem-directory(xdmp:data-directory())//dir:filename
where fn:ends-with($i/text(), ".xml")
return element part {$i/text()}

:)


declare function local:build-zip(){
    let $zip := xdmp:zip-create(
            <parts xmlns="xdmp:zip">
                {
                    for $i in xdmp:filesystem-directory(xdmp:data-directory())//dir:filename
                    where fn:ends-with($i/text(), ".xml")
                    return element part {$i/text()}
                }
            </parts>,
            (
                for $i in xdmp:filesystem-directory(xdmp:data-directory())//dir:filename
                where fn:ends-with($i/text(), ".xml")
                return xdmp:read-cluster-config-file($i)
            ))
    return

    (xdmp:set-response-content-type("application/zip"),
    xdmp:add-response-header("Content-Disposition", fn:concat("attachment; filename=", $FILENAME)),
    $zip)

    (:)
        xdmp:save(concat("/tmp/", $FILENAME), $zip,
                <options xmlns="xdmp:save">
                    <encoding>utf8</encoding>
                </options>) :)

};

(: main :)

(
    local:build-zip(),
    lib-view:create-bootstrap-page("Backup / Restore Database XML",
                    <div class="container">

                            {lib-view:page-header("Backup / Restore Database XML", "Backup", " ")}
                        <div class="row">
                            <div class="panel panel-default">
                                <div class="panel-heading"><strong>Backup</strong>&nbsp;<small>TODO</small></div>
                                <div class="panel-body">
                                    TODO - backup of database.xml is currently being zipped and saved to <strong>{concat("/tmp/",$FILENAME)}</strong> - todo - make this downloadable
                                </div>
                            </div>
                        </div>
                    </div>)
)
