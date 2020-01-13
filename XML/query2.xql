xquery version "3.1";
declare namespace ms="http://wocoTest.com/mainSchema";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

<html>

<!-- I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else or using code from external sources.
ToDB Project 3
File Name: schema.xml
Author: Rajat R Hande (112674168)
Brief Description: Query 2: Networth of every person -->

<head>
    <title>Query 2</title>
    </head>
    <body>
    <h4>Networth of every person:</h4>
    <table style="border: 1px solid black">
        <tr><th style="padding: 10px">Person</th><th style="padding: 10px">Net Worth</th></tr>
        {
            let $entries := doc("db.xml")/ms:entries
            for $person in /ms:entries/ms:person
                for $company1 in $entries/ms:company
                let $company2 := $person/ms:commonality/ms:ownsCompany/ms:ownedCompany/ms:cid
                    where $company1/ms:commonality[ms:id=$company2]
                    let $company1Id := $company1/ms:commonality/ms:id
                    let $shares := $person/ms:commonality/ms:ownsCompany/ms:ownedCompany[ms:cid=$company1Id and ms:shares>0]/ms:shares
                    let $netWorth := ($shares * ($company1/ms:shareprice))
                group by $person
                order by $person/ms:commonality/ms:name
                return
                    <tr>
                        <td style="padding: 10px">
                            <person><name>{$person/ms:commonality/ms:name/text()}</name></person>
                        </td>
                        <td style="padding: 10px">
                            <networth>{xs:decimal(sum($netWorth))}</networth>
                        </td>
                    </tr>
        }
    </table>
    </body>
</html> 