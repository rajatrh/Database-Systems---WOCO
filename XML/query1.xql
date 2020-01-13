xquery version "3.1";
declare namespace ms="http://wocoTest.com/mainSchema";
declare option exist:serialize "method=xhtml media-type=text/html indent=yes";

<html>

<!-- I pledge my honor that all parts of this project were done by me alone and without collaboration with anybody else or using code from external sources.
ToDB Project 3
File Name: schema.xml
Author: Rajat R Hande (112674168)
Brief Description: Query 1: The companies that are partially owned by one of their board members. -->

    <head>
        <title>Query 1</title>
    </head>
    <body>
        <h4>Companies that are partially owned by one of their board members:</h4>
        <ol style="width: 10%">
        
            {
                let $entries := doc("db.xml")/ms:entries
                for $company in $entries/ms:company
                let $pId := $company/ms:board/ms:member/ms:pid
                    for $personId in $entries/ms:person[ms:commonality/ms:id = $pId]
                    let $cId := $company/ms:commonality/ms:id
                        where $personId/ms:commonality/ms:ownsCompany/ms:ownedCompany[ms:cid = $cId]/ms:shares > 0
                group by $company
                order by $company/ms:commonality/ms:name
                return
                <li style="padding-bottom:5px; border-bottom: 1px solid gray"><company>{$company/ms:commonality/ms:name/text()}</company></li>
            }
        </ol>
    </body>
</html>