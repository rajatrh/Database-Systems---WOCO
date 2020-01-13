/****************************************************************************
CSE532 -- Project 2
File name: SQL-FILE
Author(s): Ravinder Singh (112681203), Rajat Hande (112684167)
Brief description: The SQL Statements used to create the tables and insert values.
                   Query Statements to retrieve the results as mentioned in the document.
****************************************************************************/

CREATE TYPE ownership AS (
    company_owned   text,
    shares_owned    int
);

CREATE TABLE company (
    cid             text NOT NULL,
    name            text NOT NULL,
    shares          int NOT NULL,
    shareprice      int NOT NULL,
    industry        text [],
    board_members   text [],
    owns            ownership [],
    PRIMARY KEY (cid)
);

CREATE TABLE person (
    pid     text NOT NULL,
    name    text NOT NULL,
    owns    ownership[],
    PRIMARY KEY (pid)
);

CREATE INDEX company_index ON company (cid);

CREATE INDEX person_index ON person (pid);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c1', 'QUE', 150000, 30, Array[ 'Software', 'Accounting' ], Array[ 'p3', 'p1', 'p4' ], Array[ROW('c2', 10000)::ownership, ROW('c4', 20000)::ownership, ROW('c8', 30000)::ownership]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c2', 'RHC', 250000, 20, Array[ 'Accounting' ], Array[ 'p1', 'p2', 'p5' ], Array[]::ownership[]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c3', 'Alf', 10000000, 700, Array[ 'Software', 'Automotive' ], Array[ 'p6', 'p7', 'p1' ], Array[ROW('c9', -100000)::ownership, ROW('c4', 400000)::ownership, ROW('c8', 100000)::ownership]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c4', 'Elgog', 1000000, 400, Array[ 'Software', 'Search' ], Array[ 'p6', 'p7', 'p5' ], Array[ROW('c6', 5000)::ownership]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c5', 'Tfos', 10000000, 300, Array[ 'Software', 'Hardware' ], Array[ 'p2', 'p5', 'p4' ], Array[ROW('c6', 30000)::ownership, ROW('c7', 50000)::ownership, ROW('c1', 200000)::ownership]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c6', 'Ohay', 180000, 50, Array[ 'Search' ], Array[ 'p2', 'p4', 'p8' ], Array[]::ownership[]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c7', 'Gnow', 150000, 300, Array[ 'Search' ], Array[ 'p2', 'p3', 'p4' ], Array[]::ownership[]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c8', 'Elpa', 9000000, 300, Array[ 'Software', 'Hardware' ], Array[ 'p2', 'p3', 'p8' ], Array[ROW('c5', 20000)::ownership, ROW('c4', 30000)::ownership]);

INSERT INTO company(cid, name, shares, shareprice, industry, board_members, owns) VALUES 
('c9', 'Ydex', 5000000, 300, Array[ 'Software', 'Search' ], Array[ 'p6', 'p3', 'p8' ], Array[]::ownership[]);

INSERT INTO person(pid, name, owns) VALUES
('p1', 'Bill Doe', Array[ROW('c5', 30000)::ownership, ROW('c8', 100000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p2', 'Bill Seth', Array[ROW('c7', 40000)::ownership, ROW('c4', 20000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p3', 'John Smyth', Array[ROW('c1', 20000)::ownership, ROW('c2', 20000)::ownership, ROW('c5', 800000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p4', 'Anne Smyle', Array[ROW('c2', 30000)::ownership, ROW('c5', 40000)::ownership, ROW('c3', 500000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p5', 'Steve Lamp', Array[ROW('c8', 90000)::ownership, ROW('c1', 50000)::ownership, ROW('c6', 50000)::ownership, ROW('c2', 70000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p6', 'May Serge', Array[ROW('c8', -10000)::ownership, ROW('c9', -40000)::ownership, ROW('c3', 500000)::ownership, ROW('c2', 40000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p7', 'Bill Public', Array[ROW('c7', 80000)::ownership, ROW('c4', 30000)::ownership, ROW('c1', 30000)::ownership, ROW('c5', 300000)::ownership, ROW('c2', -9000)::ownership]);

INSERT INTO person(pid, name, owns) VALUES
('p8', 'Muck Lain', Array[ROW('c2', 60000)::ownership, ROW('c6', -40000)::ownership, ROW('c9', -80000)::ownership, ROW('c8', 30000)::ownership]);

/***Query 1 : Find all companies that are (parially) owned by one of their board members***/

SELECT C.name AS "COMPANY"
FROM company C, UNNEST(C.board_members) B, person P, UNNEST(P.owns) O
WHERE B = P.pid AND O.company_owned = C.cid AND O.shares_owned > 0
ORDER BY C.name;

/***Query 2: Net worth of every person in the database***/

SELECT P.name AS "PERSON", SUM(O.shares_owned*C.shareprice) AS "Net Worth"
FROM person P, UNNEST(P.owns) O, company C
WHERE O.company_owned = C.cid AND O.shares_owned > 0
GROUP BY P.name;

/***Query 3: Board Member of a company that owns the most shares***/

SELECT DISTINCT C.name AS "COMPANY", P.name AS "TOP BOARD MEMBER"
FROM company C, person P, UNNEST(P.owns) O1
WHERE O1.shares_owned = (SELECT MAX(O.shares_owned)
                    FROM UNNEST(P.owns) O, UNNEST(C.board_members) B
                    WHERE O.company_owned = C.cid AND O.shares_owned > 0 AND B=P.pid)
ORDER BY C.name;

/***Query 4: Company 1 board dominates Company 2, sharing similar industries***/

SELECT C1.name AS "COMPANY 1", C2.name AS "COMPANY 2"
FROM company C1, company C2
WHERE C1.cid <> C2.cid AND
      EXISTS (SELECT I1
              FROM UNNEST(C1.industry) I1, UNNEST(C2.industry) I2
              WHERE I1 = I2) AND
      NOT EXISTS ( (SELECT PEX.pid, PEX.company_owned
                    FROM ( SELECT pid, o.company_owned, o.shares_owned
                            FROM person, UNNEST(owns) o) PEX
                    WHERE PEX.pid = ANY(C2.board_members) AND PEX.shares_owned > 0)
                    EXCEPT
                    (SELECT P2.pid, P2.company_owned
                     FROM ( SELECT pid, o.company_owned, o.shares_owned
                            FROM person, UNNEST(owns) o) P2
                     WHERE P2.pid = ANY(C2.board_members) AND P2.shares_owned > 0 AND
                           P2.shares_owned <= ANY(SELECT P1.shares_owned
                                                      FROM ( SELECT pid, o.company_owned, o.shares_owned
                                                             FROM person, UNNEST(owns) o ) P1
                                                      WHERE P1.pid = ANY(C1.board_members) AND 
                                                      P2.company_owned = P1.company_owned AND P1.shares_owned > 0)));

/***Query 5: For each person, find the companies he controls and the percentage of control, if that percentage is greater than 10%.***/

CREATE VIEW direct_company_ownership AS
SELECT C.cid, C.company_owned, ROUND(C.shares_owned * 1.0/CREF.shares, 25) AS "ratio"
FROM company CREF, ( SELECT cid, o.company_owned, o.shares_owned
                     FROM company, UNNEST(owns) o) C
WHERE C.shares_owned > 0 AND C.cid = CREF.cid;

CREATE RECURSIVE VIEW indirect_company_ownership(cid, company_owned, ratio) AS
    SELECT *
    FROM direct_company_ownership
UNION
    SELECT I.cid, D.company_owned, ROUND(I.ratio*D.ratio, 25) AS "ratio"
    FROM direct_company_ownership D INNER JOIN indirect_company_ownership I ON (D.cid = I.company_owned)
    WHERE I.cid <> D.company_owned;

CREATE VIEW aggregate_company_ownership AS
    SELECT C.cid, C.company_owned, SUM(C.ratio) AS "ratio"
    FROM indirect_company_ownership C
    GROUP BY C.cid, C.company_owned;

CREATE VIEW direct_person_ownership AS
SELECT P.pid, P.company_owned, ROUND(P.shares_owned * 1.0/C.shares, 25) AS "ratio"
FROM company C, (
    SELECT pid, company_owned, shares_owned
    FROM person, UNNEST(owns)
    ) P
WHERE C.cid = P.company_owned AND P.shares_owned > 0;

CREATE RECURSIVE VIEW indirect_person_ownership(pid, company_owned, ratio) AS
    SELECT *
    FROM direct_person_ownership
UNION
    SELECT I.pid, A.company_owned, ROUND(I.ratio*A.ratio, 25) AS "ratio"
    FROM indirect_person_ownership I INNER JOIN aggregate_company_ownership A ON (I.company_owned = A.cid);

CREATE VIEW aggregate_ownership AS
    SELECT P.pid, P.company_owned, SUM(P.ratio) AS "ratio"
    FROM indirect_person_ownership P
    GROUP BY P.pid, P.company_owned
    ORDER BY P.pid, P.company_owned;

SELECT P.name AS "PERSON", C.name AS "COMPANY", (A.ratio*100) AS "PERCENTAGE"
FROM aggregate_ownership A, person P, company C
WHERE A.ratio >= 0.1 AND P.pid = A.pid AND C.cid = A.company_owned
ORDER BY P.name, C.name;
