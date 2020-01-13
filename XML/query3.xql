xquery version "3.1";
declare namespace ms="http://wocoTest.com/mainSchema";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

<html>

<!-- I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else or using code from external sources.
ToDB Project 3
File Name: schema.xml
Author: Rajat R Hande (112674168)
Brief Description: Query 3: Top Board Member of each company.-->

<head>
    <title>Query 3</title>
    </head>
    <body>
    <h4>Top Board Member of each company:</h4>
    <table style="border: 1px solid black">
        <tr><th style="padding: 10px">Person</th><th style="padding: 10px">Top Board Member</th></tr>
    {
        let $entires := doc("db.xml")/ms:entries
        for $company in $entires/ms:company
            for $person in $entires/ms:person
            let $bm := $company/ms:board/ms:member/ms:pid
            let $cid := $company/ms:commonality/ms:id
            let $cname := $company/ms:commonality/ms:name
            let $maxShares := max($person/ms:commonality[ms:id=$bm]/ms:ownsCompany/ms:ownedCompany[ms:cid=$cid]/ms:shares)
                where $person/ms:commonality[ms:id=$bm]/ms:ownsCompany/ms:ownedCompany[ms:cid=$cid and ms:shares>0 and ms:shares=$maxShares]
            order by $cname
            return <tr>
                        <td style="padding: 10px">
                            <company><name>{$cname/text()}</name></company>
                        </td>
                        <td style="padding: 10px">
                            <top_member>{$person/ms:commonality/ms:name/text()}</top_member>
                        </td>
                    </tr>
    }
</table>
</body>
</html>