xquery version "1.0-ml";

module namespace common = "http://help.marklogic.com/common";
declare namespace qry = "http://marklogic.com/cts/query";
declare namespace sec = "http://marklogic.com/xdmp/security";

declare variable $PATHSEP := if (xdmp:platform() = "winnt") then "\\" else "/";
declare variable $DATABASE := xdmp:get-request-field("db", xdmp:database-name(xdmp:database()));
declare variable $FOREST-COUNTS-REBALANCER := xdmp:forest-counts(xdmp:database-forests(xdmp:database($DATABASE)), (), ("preview-rebalancer"));


declare function common:get-log-directory() {
    fn:concat(xdmp:data-directory(), $PATHSEP, "Logs", $PATHSEP)
};

declare function common:get-base-xsd-path() {
    if (xdmp:platform() eq "linux")
    then
        ("/opt/MarkLogic/Config/")
    else
        ("C:\Program Files\MarkLogic\Config\")
};

declare function common:callout($hdr, $content) as element(div) {
    element div {
        attribute class {"bs-callout bs-callout-info"},
        element h4 {$hdr},
        element p {$content}
    }
};

declare function common:callout-help($hdr, $content) {
    element div {
        attribute class {"bs-callout bs-callout-warning"},
        element h4 {$hdr},
        element p {$content}
    }
};


declare function common:get-term-keys($query) as xs:unsignedLong* {
    fn:distinct-values(xdmp:plan(cts:search(doc(), $query))//qry:key)
};

declare function common:get-estimate-for-term-key($key) {
    xdmp:estimate(cts:search(doc(), cts:term-query($key)))
};

declare function common:get-uris-from-term-key($key) {
    cts:uris((), (), cts:term-query($key cast as xs:unsignedLong))
};

declare function common:lookup-term-from-key($key as xs:unsignedLong) {
    let $options := <options
        xmlns="cts:train"><use-db-config>true</use-db-config><details>true</details></options>
    let $doc := (cts:search(doc(), cts:term-query($key)))[1]
    return
        cts:hash-terms($doc, $options)//cts:term[@id = $key]
};

declare function common:get-security-users() {
    xdmp:eval('xquery version "1.0-ml";

import module namespace sec="http://marklogic.com/xdmp/security" at "/MarkLogic/security.xqy";

declare function local:expand-role-roles($roles){ 
 if(not(empty($roles)))  
 then(  
  element ul {attribute class {"parent-roles", $roles},
    for $role in $roles 
    return element li {attribute class {count(sec:role-get-roles($role)), sec:role-get-roles($role) }, element span {attribute class {"glyphicon glyphicon-tower"}, " "}, " ", $role, local:expand-privileges($role), local:expand-role-roles(sec:role-get-roles($role)) }})
   else()
};

declare function local:expand-roles($uname){
  element ul {attribute class {"parent-user", $uname},
    for $i in sec:user-get-roles($uname)
      return (element li {attribute class {"role-name"}, element span {attribute class {"glyphicon glyphicon-tower"}, " "}, " ", $i}, local:expand-privileges($i), local:expand-role-roles(sec:role-get-roles($i)))
  }
};

declare function local:expand-privileges($role){
element ul {attribute class {"privileges"},
for $i in sec:role-privileges($role)
return element li {text { xs:string($i/sec:privilege-name), "(", xs:string($i/sec:kind), ")" }}}
};

declare function local:get-users(){
for $user in cts:search(doc(), cts:element-query( fn:QName("http://marklogic.com/xdmp/security", "user"), cts:and-query(()) ) ) 
order by $user/sec:user/sec:user-name
return xs:string($user/sec:user/sec:user-name)};

element ul {attribute class {"top"},
for $i in local:get-users()
return (element li {attribute class {"user-name"}, element span {attribute class {"glyphicon glyphicon-user"}, " "}, " ", $i}, local:expand-roles($i))
}
',
    (),
    <options
        xmlns="xdmp:eval">
        <database>{xdmp:security-database()}</database>
    </options>)
};

declare function common:nav-item($path as xs:string, $name as xs:string) {
    element li {
        if (xdmp:get-request-path() eq $path) then
            (attribute class {"active"})
        else
            (),
        element a {
            attribute href {$path},
            $name
        }
    }
};

declare function common:nav() {
    <nav
        class="navbar navbar-default">
        <div
            class="container-fluid">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div
                class="navbar-header">
                <button
                    type="button"
                    class="navbar-toggle collapsed"
                    data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1"
                    aria-expanded="false">
                    <span
                        class="sr-only">Toggle navigation</span>
                    <span
                        class="icon-bar"></span>
                    <span
                        class="icon-bar"></span>
                    <span
                        class="icon-bar"></span>
                </button>
                <a
                    class="navbar-brand"
                    href="#">ML Support Summit 2015</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div
                class="collapse navbar-collapse"
                id="bs-example-navbar-collapse-1">
                <ul
                    class="nav navbar-nav">
                    {
                        common:nav-item("/", "XML Schemas"),
                        common:nav-item("/all.xqy", "All XSD items"),
                        common:nav-item("/min-max.xqy", "Min / Max"),
                        common:nav-item("/functions.xqy", "Builtin Functions"),
                        common:nav-item("/plan.xqy", "XDMP Plan Breakdown"),
                        common:nav-item("/security.xqy", "User / Role Mappings"),
                        common:nav-item("/queries.xqy", "Long running queries")
                    }
                </ul>
            </div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
    </nav>
};