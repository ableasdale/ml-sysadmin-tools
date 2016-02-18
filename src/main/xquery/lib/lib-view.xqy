xquery version "1.0-ml";

module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view";

declare function lib-view:create-bootstrap-page($title as xs:string, $content as element()) {
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
            attribute href {"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"},
            attribute integrity {"sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7"},
            attribute crossorigin {"anonymous"}
        },
        element link {
            attribute rel {"stylesheet"},
            attribute href {"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"},
            attribute integrity {"sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r"},
            attribute crossorigin {"anonymous"}
        }
    },
    element body { element div { attribute class {"container"}, $content }}
    },
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">{" "}</script>,
    <script src="/assets/js/logtail.js">{" "}</script>,
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous">{" "}</script>
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
                    <li><a href="/">Dashboard</a></li>
                    <li><a href="/security.xqy">Security</a></li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Documentation <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="/documentation/messages.xqy">Exceptions</a></li>
                            <li><a href="/wp-admin/editor.xqy">Schemas</a></li>
                        </ul>
                    </li>
                    
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">Query Tools <span class="caret"></span></a>
                        <ul class="dropdown-menu" role="menu">
                            <li><a href="/query-tools/queries.xqy">Running Queries</a></li>
                            <li><a href="/query-tools/plan.xqy">Plan Manager</a></li>
                            <li><a href="/query-tools/termkey.xqy">Term Key Lookup</a></li>
                        </ul>
                    </li>
                    <li><a href="/log.xqy">Log</a></li>
                    
                </ul>
            </div>
        </div>
    </div>
};

declare function lib-view:page-header($title as xs:string, $subtitle as xs:string, $dropdown as item()?) as element(div)+ {
        element div {attribute class {"row"},
            element div {attribute class {"col-md-9"}, element h3 {$title, " ", element small {$subtitle}}},
            element div {attribute class {"col-md-3"}, attribute style {"padding-top:1em;"}, $dropdown}
        },
        element div {attribute class {"row"}, lib-view:navigation()}
};

declare function lib-view:get-log-js() {
    (
    <script language="javascript" type="text/javascript">
    <![CDATA[

$(document).ready(function() {
   // window.onerror = error;
    get_log();
});

    
            // Check for the various File API support.
            // https://www.adobe.com/devnet/archive/html5/articles/real-world-example-html5-filesystem-api.html
            // http://www.html5rocks.com/en/tutorials/file/dndfiles/
if (window.File || window.FileReader || window.FileList || window.Blob) {
  console.log("full log support" + window.File);
} else {
  console.err('The File APIs are not fully supported in this browser.');
}
    ]]>
    </script>)
};