package demo;

/****************************************************************************
CSE532 -- Project 2
File name: WOCODAO.java
Author(s): Ravinder Singh (112681203), Rajat Hande (112684167)
Brief description: It facilitates querying the database and forming the response.
****************************************************************************/

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class WOCODAO {
	
	WOCODAO() {
	}
	
	public String runQuery(String query, int queryNumber) {
		System.out.print(query);
		String res = "Couldn't connect FTW";
		PostGresConnector connector = new PostGresConnector();
        Connection connection = connector.getConnection();
        if (connection != null) {
        	System.out.println("We are good now!");
        	Statement statement;
    		try {
    			statement = connection.createStatement();
    			ResultSet rs = statement.executeQuery(query);
    			System.out.println(rs.getFetchSize());
    			res = "<table class=\"table table-striped \" border>";
    			switch(queryNumber) {
				case 1: {
					res += "<tr><th>COMPANY</th></tr>";
				} break;
				case 2: {
					res += "<tr><th>PERSON</th><th>NET WORTH</th>";
				} break;
				case 3: {
					res += "<tr><th>COMPANY</th><th>TOP BOARD MEMBER</th>";
				} break;
				case 4: {
					res += "<tr><th>COMPANY 1</th><th>COMPANY 2</th>";
				} break;
				case 5: {
					res += "<tr><th>PERSON</th><th>COMPANY</th><th>PERCENTAGE</th>";
				} break;
				}
    			while (rs.next()) {
    				switch(queryNumber) {
    				case 1: {
    					res += "<tr><td>" + rs.getString("COMPANY") + "</td></tr>";
    				} break;
    				case 2: {
    					res += "<tr>";
    					res += "<td>" + rs.getString("PERSON") + "</td>";
    					res += "<td>" + rs.getInt("Net Worth") + "</td>";
    					res += "</tr>";
    				} break;
    				case 3: {
    					res += "<tr>";
    					res += "<td>" + rs.getString("COMPANY") + "</td>";
    					res += "<td>" + rs.getString("TOP BOARD MEMBER") + "</td>";
    					res += "</tr>";
    				} break;
    				case 4: {
    					res += "<tr>";
    					res += "<td>" + rs.getString("COMPANY 1") + "</td>";
    					res += "<td>" + rs.getString("COMPANY 2") + "</td>";
    					res += "</tr>";
    				} break;
    				case 5: {
    					res += "<tr>";
    					res += "<td>" + rs.getString("PERSON") + "</td>";
    					res += "<td>" + rs.getString("COMPANY") + "</td>";
    					res += "<td>" + rs.getString("PERCENTAGE") + "</td>";
    					res += "</tr>";
    				} break;
    				}
    			}
    			res += "</table>";
    		} catch (SQLException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
        }
		return res;
	}
}
