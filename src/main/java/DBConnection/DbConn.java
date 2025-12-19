package DBConnection;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DbConn {
	private static DbConn dbcon;
	private String jndiName;
	private DbConn() {
		
	}
	
	
	public static DbConn getInstance( String jndiName) {
		if (dbcon == null) {// 객체가 생성되어 있지 않을 때만
			dbcon = new DbConn();// 새로 객체를 생성하라.
			dbcon.jndiName= jndiName;
		} // end if
		return dbcon;
	}// getInstance
	
	public Connection getConn() throws SQLException{
		Connection con = null;
		
		try {
			//1.JNDI 사용객체 생성
			Context ctx = new InitialContext();
			
			//2.DBCP에 DataSource 얻기
			DataSource ds = (DataSource)ctx.lookup("java:comp/env/"+jndiName);
			
			//3.DataSource에서 connection 얻기
			con = ds.getConnection();
		
		}catch(NamingException ne) {
			ne.printStackTrace();
		}
		
		return con;
	}//
	
	public void dbClose(ResultSet rs,Statement stmt, Connection con ) throws SQLException {
		try {
			if(rs != null) {rs.close();}
			if(stmt != null) {stmt.close();}	
		}finally { //다른 게 다 예외 나와도 커넥션 만큼은 반드시 끊는다.
			if(con != null) {con.close();}
		}//end finally
	}//dbclose
	
	
}//class
