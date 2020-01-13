package demo;

/****************************************************************************
CSE532 -- Project 2
File name: DemoServlet.java
Author(s): Ravinder Singh (112681203), Rajat Hande (112684167)
Brief description: The servlet serves the query results to the request.
					It is used to create the Data Access Object as well.
****************************************************************************/

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DemoServlet")
public class DemoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	Map<Integer, String> qnMapping;
	WOCODAO wocoDao = new WOCODAO();
       
    public DemoServlet() {
    	super();
		String query1 = "SELECT C.name AS \"COMPANY\" FROM company C, UNNEST(C.board_members) B, person P, UNNEST(P.owns) O WHERE B = P.pid AND O.company_owned = C.cid AND O.shares_owned > 0;";
		String query2 = "SELECT P.name AS \"PERSON\", SUM(O.shares_owned*C.shareprice) AS \"Net Worth\" FROM person P, UNNEST(P.owns) O, company C WHERE O.company_owned = C.cid AND O.shares_owned > 0 GROUP BY P.name;";
		String query3 = "SELECT DISTINCT C.name AS \"COMPANY\", P.name AS \"TOP BOARD MEMBER\" FROM company C, person P, UNNEST(P.owns) O1 WHERE O1.shares_owned = (SELECT MAX(O.shares_owned) FROM UNNEST(P.owns) O, UNNEST(C.board_members) B WHERE O.company_owned = C.cid AND O.shares_owned > 0 AND B=P.pid);";
		String query4 = "SELECT C1.name AS \"COMPANY 1\", C2.name AS \"COMPANY 2\" FROM company C1, company C2 WHERE C1.cid <> C2.cid AND EXISTS (SELECT I1 FROM UNNEST(C1.industry) I1, UNNEST(C2.industry) I2 WHERE I1 = I2) AND NOT EXISTS ( (SELECT PEX.pid, PEX.company_owned FROM ( SELECT pid, o.company_owned, o.shares_owned FROM person, UNNEST(owns) o) PEX WHERE PEX.pid = ANY(C2.board_members) AND PEX.shares_owned > 0) EXCEPT (SELECT P2.pid, P2.company_owned FROM ( SELECT pid, o.company_owned, o.shares_owned FROM person, UNNEST(owns) o) P2 WHERE P2.pid = ANY(C2.board_members) AND P2.shares_owned > 0 AND P2.shares_owned <= ANY(SELECT P1.shares_owned FROM ( SELECT pid, o.company_owned, o.shares_owned FROM person, UNNEST(owns) o ) P1 WHERE P1.pid = ANY(C1.board_members) AND P2.company_owned = P1.company_owned AND P1.shares_owned > 0)));";
		String query5 = "SELECT P.name AS \"PERSON\", C.name AS \"COMPANY\", (A.ratio*100) AS \"PERCENTAGE\" FROM aggregate_ownership A, person P, company C WHERE A.ratio >= 0.1 AND P.pid = A.pid AND C.cid = A.company_owned ORDER BY P.name, C.name;";
		this.qnMapping = new HashMap<>();
		this.qnMapping.put(1, query1);
		this.qnMapping.put(2, query2);
		this.qnMapping.put(3, query3);
		this.qnMapping.put(4, query4);
		this.qnMapping.put(5, query5);
       
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int paramValue = Integer.valueOf(request.getParameter("queryNumber"));
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		out.println("<html><body>");
		out.println(wocoDao.runQuery(this.qnMapping.get(paramValue), paramValue));
		out.println("</body></html>");

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
