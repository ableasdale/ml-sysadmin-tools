xquery version "1.0-ml";

module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view";

declare namespace xdmp = "http://marklogic.com/xdmp";

declare function lib-view:create-bootstrap-page($title as xs:string, $content as element(div)){
    lib-view:create-bootstrap-page($title, $content, ())
};

declare function lib-view:create-bootstrap-page($title as xs:string, $content as element(div), $additional-resource as item()?) {
    xdmp:log(("Creating page: "|| $title), "debug"),
    xdmp:set-response-content-type("text/html; charset=utf-8"),
    '<!DOCTYPE html>',
    element html {attribute lang {"en"},
    element head {
        element meta {attribute charset {"utf-8"}},
        element meta {attribute http-equiv {"X-UA-Compatible"}, attribute content {"IE=edge"}},
        element meta {attribute name {"viewport"}, attribute content {"width=device-width, initial-scale=1"}},
        element title {$title},
        element link {
            attribute rel {"stylesheet"},
            attribute href {"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"},
            attribute crossorigin {"anonymous"}
        },
        element link {
            attribute rel {"stylesheet"},
            attribute href {"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css"},
            attribute crossorigin {"anonymous"}
        },
        element link {
            attribute rel {"stylesheet"},
            attribute href {"https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/codemirror.min.css"}
        },
        element link {
            attribute rel {"stylesheet"},
            attribute href {"/assets/css/styles.css"}
        }
    },
    element body { $content }
    },
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.7.0/styles/default.min.css" />,
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js">{" "}</script>,
    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.7.0/highlight.min.js">{" "}</script>,
    <script src="https://code.jquery.com/jquery-2.2.1.min.js">{" "}</script>,
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" crossorigin="anonymous">{" "}</script>,
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/codemirror.min.js">{" "}</script>,
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.19.0/mode/xquery/xquery.min.js">{" "}</script>,
    <script src="https://cdnjs.cloudflare.com/ajax/libs/d3/3.5.16/d3.js">{" "}</script>,
    <script src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js">{" "}</script>,
    <script><![CDATA[hljs.initHighlightingOnLoad();]]></script>,

    $additional-resource
};


declare function lib-view:navigation() as element(div) {
    <div class="navbar navbar-default" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse"
                data-target=".navbar-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                </button>
                <img style="max-width:150px; padding-top:8px;" id="nav-logo" src="/assets/images/marklogic.png"/>
            </div>

            <div class="navbar-collapse collapse">
                <ul class="nav navbar-nav">
                    <!-- TODO - add class="active" to active page -->
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dashboard <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="/">Overview</a></li>
                            <!-- li><a href="/bi-level.xqy">Bi-Level Database View</a></li -->
                            <li><a href="/data.xqy">Data</a></li>
                            <li><a href="/cache-status.xqy">Group Level Cache Status</a></li>
                            <li><a href="/hosts.xqy">Hosts</a></li>
                            <li><a href="/servers.xqy">Servers</a></li>
                            <li><a href="/databases.xqy">Databases</a></li>
                            <li><a href="/forests.xqy">Forests</a></li>
                            <li><a href="/range-indexes.xqy">Range Index Use</a></li>
                        </ul>
                    </li>

                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Configuration <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="/configuration/security.xqy">Security</a></li>
                            <li><a href="/configuration/visual.xqy">Visual Diff on Config Files</a></li>
                            <li><a href="/configuration/backup.xqy">Backup Config Files</a></li>
                            <!--li><a href="/configuration/TODO.xqy"><strong>TODO</strong> Restore from Config Backup</a></li-->
                        </ul>
                    </li>

                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Documentation <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="/documentation/messages.xqy">Exceptions</a></li>
                            <li><a href="/documentation/functions.xqy">Functions</a></li>
                            <li><a href="/documentation/all-schemas.xqy">All XSD Schemas</a></li>
                            <li><a href="/documentation/min-max.xqy">Schemas: Max/Min</a></li>
                        </ul>
                    </li>

                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Query Tools <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="/query-tools/queries.xqy">Running Queries</a></li>
                            <li><a href="/query-tools/locks.xqy">Transaction Locks</a></li>
                            <li><a href="/query-tools/plan.xqy">Plan Manager</a></li>
                            <li><a href="/query-tools/termkey.xqy">Term Key Lookup</a></li>
                        </ul>
                    </li>
                    <li><a href="/log.xqy">Logs</a></li>
                </ul>
            </div>
        </div>
    </div>
};

declare function lib-view:item-select($seq as xs:string*, $arg1 as xs:string, $arg2 as xs:string, $left as xs:boolean, $alt as xs:string) as element(div) {
    element div {attribute class {"dropdown"},
        element button {
            attribute class {"btn btn-default dropdown-toggle"},
            attribute type {"button"},
            attribute id {"select"},
            attribute data-toggle {"dropdown"},
            attribute aria-haspopup {"true"},
            attribute aria-expanded {"true"},
            "Choose ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"select"},
            element li {attribute class {"dropdown-header"}, "Available Files:"},
            for $x in $seq
            return
                if($left)
                then (element li {element a {attribute href {"?"||$arg1||"="||$x||"&amp;"||$arg2||"="||$alt}, $x}})
                else (element li {element a {attribute href {"?"||$arg1||"="||$alt||"&amp;"||$arg2||"="||$x}, $x}})
        }
    }
};

declare function lib-view:database-select() as element(div) {
    element div {attribute class {"dropdown"},
        element button {
            attribute class {"btn btn-default dropdown-toggle pull-right"},
            attribute type {"button"},
            attribute id {"database-select"},
            attribute data-toggle {"dropdown"},
            attribute aria-haspopup {"true"},
            attribute aria-expanded {"true"},
            "Choose database ", element span {attribute class {"caret"}}
        },
        element ul {
            attribute class {"dropdown-menu"}, attribute aria-labelledby {"database-select"},
            element li {attribute class {"dropdown-header"}, "Available Databases:"},
            for $x in xdmp:database-name(xdmp:databases())
            return
                element li {element a {attribute href {concat("?db=", $x)}, $x}}
        }
    }
};

declare function lib-view:page-header($title as xs:string, $subtitle as xs:string, $dropdown as item()?) as element(div)+ {
        element div {attribute class {"row"},
            element div {attribute class {"col-md-9"}, element h3 {$title, " ", element small {$subtitle}}},
            element div {attribute class {"col-md-3"}, attribute style {"padding-top:1em;"}, $dropdown}
        },
        element div {attribute class {"row"}, lib-view:navigation()}
};

declare function lib-view:form-submit-button($name as xs:string) as element(button) {
    element button {
        attribute type {"submit"},
        attribute class {"btn btn-default"},
        $name
    }
};

(:
            // Check for the various File API support.
            // https://www.adobe.com/devnet/archive/html5/articles/real-world-example-html5-filesystem-api.html
            // http://www.html5rocks.com/en/tutorials/file/dndfiles/
if (window.File || window.FileReader || window.FileList || window.Blob) {
  console.log("full log support" + window.File);
} else {
  console.err('The File APIs are not fully supported in this browser.');
}
:)