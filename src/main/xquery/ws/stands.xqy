xquery version "1.0-ml";

declare namespace xdmp = "http://marklogic.com/xdmp";
declare namespace fs = "http://marklogic.com/xdmp/status/forest";

import module namespace common = "http://help.marklogic.com/common" at "/lib/common.xqy";

declare variable $fcs := xdmp:forest-counts(xdmp:database-forests(xdmp:database($common:DATABASE)));

text {'StandId,Active Fragment Count,Nascent Fragment Count,Deleted Fragment Count'},
for $i in $fcs/fs:stands-counts/fs:stand-counts
return text { $i/fs:stand-id||","||$i/fs:active-fragment-count||","||$i/fs:nascent-fragment-count||","||$i/fs:deleted-fragment-count}