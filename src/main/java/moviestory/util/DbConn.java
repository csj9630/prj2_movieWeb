package moviestory.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * DB 연결 유틸리티 클래스
 * DBCP(Database Connection Pool)를 사용하여 Connection을 관리
 * 싱글톤 패턴 적용
 */
public class DbConn {
    private static DbConn dbCon;
    private String jndiName;
    
    // 생성자 - private으로 외부 생성 차단
    private DbConn() {
    }
    
    /**
     * 싱글톤 인스턴스 반환
     * @param jndiName JNDI 리소스명 (예: "jdbc/dbcp")
     * @return DbConn 인스턴스
     */
    public static DbConn getInstance(String jndiName) {
        if(dbCon == null) {
            dbCon = new DbConn();
            dbCon.jndiName = jndiName;
        }
        return dbCon;
    }
    
    /**
     * DBCP에서 Connection 얻기
     * @return Connection 객체
     * @throws SQLException DB 연결 오류 시
     */
    public Connection getConn() throws SQLException {
        Connection con = null;
        try {
            // 1. JNDI 사용 객체 생성
            Context ctx = new InitialContext();
            // 2. DBCP에서 DataSource 얻기
            DataSource ds = (DataSource) ctx.lookup("java:comp/env/" + jndiName);
            // 3. DataSource에서 Connection 얻기
            con = ds.getConnection();
        } catch(NamingException ne) {
            ne.printStackTrace();
        }
        return con;
    }
    
    /**
     * DB 자원 해제
     * @param rs ResultSet (nullable)
     * @param stmt Statement (nullable)
     * @param con Connection (nullable)
     * @throws SQLException 자원 해제 오류 시
     */
    public void dbClose(ResultSet rs, Statement stmt, Connection con) throws SQLException {
        try {
            if(rs != null) { rs.close(); }
            if(stmt != null) { stmt.close(); }
        } finally {
            if(con != null) { con.close(); }
        }
    }
}
