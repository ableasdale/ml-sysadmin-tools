xquery version '1.0-ml';

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare namespace sec = "http://marklogic.com/xdmp/security";

lib-view:create-bootstrap-page("MarkLogic Tools: Security Database Layout",
element div {
    attribute class {"container"},
    lib-view:page-header("Security Mappings", "Security Database", " "),
    common:get-security-users()
})

