xquery version "1.0-ml";

declare namespace admin = "http://marklogic.com/xdmp/admin";
declare namespace meters = "http://marklogic.com/manage/meters";
declare namespace manage = "http://marklogic.com/manage";
declare namespace xdmp = "http://marklogic.com/xdmp";

import module namespace lib-view = "http://www.marklogic.com/sysadmin/lib-view" at "/lib/lib-view.xqy";
import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $strings := ( "size", "ratio", "threshold", "max", "min", "limit", "rate", "throttle" ); 

(:

<div class="panel panel-default">
  <div class="panel-heading">Panel heading without title</div>
  <div class="panel-body">
    Panel content
  </div>
</div>
:)

declare function local:display($name, $it as item()*) {
if( exists($it/node())) 
then (

element div { attribute class {"panel", if( fn:local-name($it) eq "complexType"  ) then("panel-primary") else("panel-default") },
    element div {attribute class {"panel-heading"}, 
        element h4 {fn:data($it/@name)}
    },


    element div {attribute class {"panel-body"},
        element dl { attribute class {"dl-horizontal"},
            element dt {"Filename:"},
            element dd {$name},
            element dt {"Schema Node Type:"},
            element dd {fn:local-name($it)},
            if(fn:local-name($it) eq "element") then (element dt {"Element datatype:"}, element dd {fn:data($it/@type)}) else ()
            
        },
    
        if( exists($it//xs:documentation/text()) ) then ( common:callout("Documentation", normalize-space(string-join(xs:string($it//xs:documentation), ''))) ) else(),     
        if( exists($it//xs:appinfo/admin:help/text()) ) then ( common:callout-help("Help text",  $it//xs:appinfo/admin:help ) ) else (),
    
        (: Manage - units - todo - dt dd :)
        if( exists($it//manage:units)) then(text {"Units: ", fn:data($it//manage:units)}) else (),
        
        if( exists($it//xs:appinfo/admin:default) ) then (element h4 {"Default: ", element span {attribute class {"label label-default"}, $it//xs:appinfo/admin:default}}) else (),    
        if( exists($it/xs:restriction/@base) ) then ( element h4 {"Restriction base: ", element span {attribute class {"label label-default"}, fn:data($it/xs:restriction/@base)}})  else (),
        if( exists($it/xs:restriction/xs:minInclusive/@value)) then (element h4 {"Min Inclusive: ", element span {attribute class {"label label-default"}, fn:data($it/xs:restriction/xs:minInclusive/@value)}}) else (),
        if( exists($it/xs:restriction/xs:maxInclusive/@value)) then (element h4 {"Max Inclusive: ", element span {attribute class {"label label-default"}, fn:data($it/xs:restriction/xs:maxInclusive/@value)}}) else ()
       
       (: toso - xs:restriction base 1 to 5 :)
       
       (:  <xs:attribute name="count" type="xs:integer" use="required"/> this is a complex type - start drawing boxes 
       
       if( exists($it//xs:attribute) ) then (element h4 {fn:data($it//attribute/), element span {attribute class {"label label-default"}, fn:data($it/xs:restriction/xs:maxInclusive/@value)}}) else (),
    
    :)
        
        
        
    
       
       (: proper xs:restriction base :)
       (: <xs:complexType   and xs:sequence :)
    }
},
element pre {element code {xdmp:quote($it)}}


) 
else ()
};


declare function local:process($filename as xs:string, $name as xs:string) {
(

    for $x in xdmp:document-get($filename)/node()/node()
    where fn:exists($x/@name)
    return 
        if (
            some $str in $strings
            satisfies contains($x/@name, $str )
            ) 
        then (local:display($name, $x))
        else ()
    
    
 )
};

(: Module main :)
lib-view:create-bootstrap-page("Minimum / Maximum",
    element div { attribute class {"container"},
        lib-view:page-header("Schema Explorer", "Minimum and Maximum Values", " "),
        element div {attribute class {"row"},
            for $d in xdmp:filesystem-directory(common:get-base-xsd-path())/dir:entry
            where contains($d/dir:filename/text(), "xsd")
            return local:process($d/dir:pathname, $d/dir:filename)
        }
    }
)