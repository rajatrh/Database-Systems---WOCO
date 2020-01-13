package demo;

/****************************************************************************
CSE532 -- Project 2
File name: PostGresConnector.java
Author(s): Ravinder Singh (112681203), Rajat Hande (112684167)
Brief description: This file handles to connection to the Postgres Database.
****************************************************************************/

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class PostGresConnector {
	Connection pgCon = null;
	public Connection getConnection() {
		pgCon = null;
	      try {
	         Class.forName("org.postgresql.Driver");
	         pgCon = DriverManager
	            .getConnection("jdbc:postgresql://localhost:5432/testdb",
	            "rajatrhande", "");
	         return pgCon;
	      } catch ( Exception e ) {
	    	  System.out.println("Could not connect to the DB");
	    	  System.err.println( e.getClass().getName()+": "+ e.getMessage() );
	      }
	      return null;
	}
	
	public void closeConnection() throws SQLException {
		pgCon.close();
	}
}
