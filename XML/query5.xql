xquery version "3.1";
declare namespace ms="http://wocoTest.com/mainSchema";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

declare function local:directOwnership($entity as xs:string?,$company as xs:string?)
as xs:decimal?
{
    let $entry := doc("db.xml")/ms:entries
    let $shares := $entry//ms:commonality[ms:id=$entity]/ms:ownsCompany/ms:ownedCompany[ms:cid=$company and ms:shares>0]/ms:shares
    let $totalShares := $entry/ms:company[ms:commonality/ms:id=$company]/ms:shares
    return xs:decimal($shares div $totalShares)
};

declare function local:indirectOwnership($entity as xs:string?, $company as xs:string?, $percentage as xs:decimal?)
as xs:decimal?
{
    let $entry := doc("db.xml")/ms:entries
    let $directOwnership := local:directOwnership($entity,$company)
    return (($percentage * $directOwnership) + sum(
    for $chainedCompany in $entry//ms:commonality[ms:id=$entity]/ms:ownsCompany/ms:ownedCompany[ms:shares>0]/ms:cid
        let $chainedPercentage := ($percentage * local:directOwnership($entity,$chainedCompany))
        let $totalControl := if($percentage<0.00000001) then 0 else local:indirectOwnership($chainedCompany,$company,$chainedPercentage)
    return $totalControl
      ))
};

<html>

<!-- I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else or using code from external sources.
ToDB Project 3
File Name: schema.xml
Author: Rajat R Hande (112674168)
Brief Description: Query 5: Percentage of companies owned by people.-->

<head>
    <title>Query 5</title>
    </head>
    <body>
    <h4>Percentage of companies owned by people:</h4>
    <table style="border: 1px solid black">
        <tr>
            <th style="padding: 10px">Person</th>
            <th style="padding: 10px">Company</th>
            <th style="padding: 10px">Percentage</th>
        </tr>
        {
            let $entry := doc("db.xml")/ms:entries
            for $person in $entry/ms:person
                for $company in $entry/ms:company
                    let $percentage:= round-half-to-even(
                        (xs:decimal(local:indirectOwnership($person/ms:commonality/ms:id,$company/ms:commonality/ms:id,1) * 100)),2)
                    where $percentage>=10
                order by $person/ms:commonality/ms:name,$company/ms:commonality/ms:name
                return <shareholders>
                <tr>
                        <td style="padding: 10px">
                            <person>{$person/ms:commonality/ms:name/text()}</person>
                        </td>
                        <td style="padding: 10px">
                            <company>{$company/ms:commonality/ms:name/text()}</company>
                        </td>
                        <td style="padding: 10px">
                            <percentage>{xs:decimal(sum($percentage))}</percentage>
                        </td>
                </tr>    
                </shareholders>
}
</table>
</body>
</html>


