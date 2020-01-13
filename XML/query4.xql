xquery version "3.1";
declare namespace ms="http://wocoTest.com/mainSchema";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

<html>

<!-- I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else or using code from external sources.
ToDB Project 3
File Name: schema.xml
Author: Rajat R Hande (112674168)
Brief Description: Query 4: Company1 Dominates Company2-->

<head>
    <title>Query 4</title>
    </head>
    <body>
    <h4>Company1 Dominates Company2:</h4>
    <table style="border: 1px solid black">
        <tr><th style="padding: 10px">Company 1</th><th style="padding: 10px">Company 2</th></tr>
        {
            let $entries := doc("db.xml")/ms:entries
            for $company1 in $entries/ms:company
                for $company2 in $entries/ms:company[ms:commonality/ms:id != $company1/ms:commonality/ms:id and ms:industries/ms:industry=$company1/ms:industries/ms:industry]
                    where every $person in $entries/ms:person[ms:commonality/ms:id=$company2/ms:board/ms:member/ms:pid]/ms:commonality/ms:ownsCompany/ms:ownedCompany
                    satisfies (
                        $entries/ms:person[ms:commonality/ms:id=$company1/ms:board/ms:member/ms:pid]/ms:commonality/ms:ownsCompany/ms:ownedCompany[ms:cid=$person/ms:cid]/ms:shares >= xs:integer($person/ms:shares))
                        return  <tr>
                        <td style="padding: 10px">
                            <cname1>{$company1/ms:commonality/ms:name/text()}</cname1>
                        </td>
                        <td style="padding: 10px">
                            <cname2>{$company2/ms:commonality/ms:name/text()}</cname2>
                        </td>
                    </tr>            
            }
</table>
</body>
</html>