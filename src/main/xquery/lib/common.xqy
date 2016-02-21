xquery version "1.0-ml";

module namespace common = "http://help.marklogic.com/common";

import module namespace ses = "http://www.w3.org/2003/05/xpath-functions" at "/MarkLogic/Admin/lib/session.xqy";

declare namespace qry = "http://marklogic.com/cts/query";
declare namespace sec = "http://marklogic.com/xdmp/security";

declare namespace db = "http://marklogic.com/xdmp/database";
declare namespace h = "http://marklogic.com/xdmp/hosts";
declare namespace g = "http://marklogic.com/xdmp/group";
declare namespace f = "http://marklogic.com/xdmp/status/forest";


declare variable $IDS := map:map();
declare variable $FSTAT := map:map();
declare variable $FCOUNTS := map:map();
declare variable $HOSTS := map:map();
declare variable $GROUPS := map:map();
declare variable $HOSTIDS := xdmp:hosts();

declare variable $PATHSEP := if (xdmp:platform() = "winnt") then "\\" else "/";
declare variable $DATABASE := xdmp:get-request-field("db", xdmp:database-name(xdmp:database()));
declare variable $FOREST-COUNTS-REBALANCER := xdmp:forest-counts(xdmp:database-forests(xdmp:database($DATABASE)), (), ("preview-rebalancer"));


declare function common:format($number) {
    fn:format-number($number,"#,##0.00")
};

declare function common:ratio($hits, $misses) {
    if (fn:sum($hits) gt 0)
    then common:format(100 * fn:sum($hits) div
            (fn:sum($hits) + fn:sum($misses)))
    else 0
};

declare function common:get-log-directory() {
    fn:concat(xdmp:data-directory(), $PATHSEP, "Logs", $PATHSEP)
};

(:~ 

:)
declare function common:database-forest-composition() {
    element div {
        attribute class {"row"},
        for $db in $ses:databases.xml/node()
        let $db-name := $db/db:database-name/fn:string(.)
        let $indexes := fn:string-join($db/*[fn:string(.) = "true"]/fn:local-name(.), ",")
        let $fragments := 0
        let $dfragments := 0
        let $documents := 0
        let $size := 0
        let $memory := 0
        order by $db/db:database-name 
        return (
            element table {
                attribute class {"table table-striped table-bordered"},
                
                
                element tr {element th {attribute colspan {"10"}, $db-name}},
                element tr {element td {attribute colspan {"10"}, $indexes}},
                element tr {
                    element td {"Forests"},
                    element td {"Host"},
                    element td {"Stands"},
                    element td {"Active Fr"},
                    element td {"Deleted Fr"},
                    element td {"Documents"},
                    element td {"DB Size"},
                    element td {"Mem Size"},
                    element td {"LC Ratio"},
                    element td {"LC Hit/Miss Rate"},
                    element td {"CTC Ratio"}
                },
                for $f at $j in fn:data($db/db:forests/db:forest-id)
                let $fs := xdmp:forest-status($f)
                let $fc := xdmp:forest-counts(fn:data($fs//f:current-master-forest))
                let $ms := xdmp:forest-status(data($fs//f:current-master-forest))
                let $replicas := $fs//f:replica-forest/fn:string(.)
                let $rs := for $r in $replicas
                return
                    xdmp:forest-status($r)
                let $forest-host := xdmp:host-status(fn:data($fs/f:host-id))
                let $group := $ses:groups.xml/g:group[g:group-id eq fn:data($forest-host/h:group)]
                (: let $group := map:get($GROUPS, fn:string($forest-host/h:group)) :)
                let $_ := xdmp:set($fragments, $fragments + fn:sum($fc//f:active-fragment-count))
                let $_ := xdmp:set($dfragments, $dfragments + fn:sum($fc//f:deleted-fragment-count))
                let $_ := xdmp:set($size, $size + fn:sum($fs//f:disk-size))
                let $_ := xdmp:set($memory, $memory + fn:sum($fs//f:memory-size))
                let $_ := xdmp:set($documents, $documents + fn:sum($fc//f:document-count))
                order by $group/g:group-name
                return
                    element tr {
                        
                        element td {attribute style {"padding-left:20px"}, fn:string($fs/f:forest-name)},
                        
                        element td {fn:string($forest-host/h:host-name), "-", xdmp:group-name(xdmp:host-group($forest-host/h:host-id))},
                        (:    fn:data(map:get($GROUPS, $forest-host/h:group/fn:string(.))/g:group-name :)
                        element td {fn:count($fs//f:stand)},
                        element td {common:format(fn:sum($fc//f:active-fragment-count) div 1000000)},
                        element td {common:format(fn:sum($fc//f:deleted-fragment-count) div 1000000)},
                        element td {common:format(fn:sum($fc//f:document-count) div 1000000)},
                        element td {common:format(fn:sum($fs//f:disk-size) div 1024)},
                        element td {common:format(fn:sum($fs//f:memory-size) div 1024)},
                        element td {common:ratio($ms//f:list-cache-hits, $ms//f:list-cache-misses)},
                        element td {common:format(fn:avg($ms//f:list-cache-hit-rate)), "/", common:format(fn:avg($ms//f:list-cache-miss-rate))},
                        
                        element td {common:ratio($ms//f:compressed-tree-cache-hits, $ms//f:compressed-tree-cache-misses)}
                    },
                element tr {
                    element td {attribute style {"padding-left:20px"}, "Total"},
                    element td {" "},
                    element td {" "},
                    element td {common:format($fragments div 1000000)},
                    element td {common:format($dfragments div 1000000)},
                    element td {common:format($documents div 1000000)},
                    element td {common:format($size div 1024)},
                    element td {common:format($memory div 1024)}
                    
                }
            }
        ),
        element hr {" "}
    }
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