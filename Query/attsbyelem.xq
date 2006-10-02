declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace rng="http://relaxng.org/ns/structure/1.0";
declare namespace request="http://exist-db.org/xquery/request";

declare function tei:atts($a as element(),$lang as xs:string) as element() {
 <att>
    <name>
    {$a/@usage}
    {data($a/@ident)}</name>
    <default>{data($a/tei:defaultVal)}</default>
    <datatype>
    {
      string($a/tei:datatype/*)
     }
     </datatype>
     {
     for $vl in $a/tei:valList return
     <valList>
       {$vl/@type}	
       {
	for $v in $vl/tei:valList/tei:valItem return
	<valItem>
	   {$v/@ident}
	</valItem>
       }
     </valList>	
     }
    <desc>{
    if ($a/tei:desc[@xml:lang=$lang]) then
        data($a/tei:desc[@xml:lang=$lang])
    else
        data($a/tei:desc[not(@xml:lang)])
	}</desc>
  </att>
};

let $e := request:get-parameter("name", "")
let $lang := request:get-parameter("lang", "")
for $c in collection("/db/TEI")//tei:elementSpec[@ident=$e]
return
<Element>
{
for $a in $c//tei:attDef
return tei:atts($a,$lang) 
}
{
for $class in $c/tei:classes/tei:memberOf
return
for $ac in collection("/db/TEI")//tei:classSpec[@ident=$class/@key]//tei:attDef
return tei:atts($ac,$lang)
}
{
for $ac in collection("/db/TEI")//tei:classSpec[@ident='att.global']//tei:attDef
return tei:atts($ac,$lang)
}
</Element>
