package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import DBConnection.DbConn;


public class UserLoginDAO {
	private static UserLoginDAO uDAO;
	private String jndiName;
	
	private UserLoginDAO() {
		
	}
	
	public static UserLoginDAO getInstance(String jndiName) {
		if( uDAO == null ) {
			uDAO = new UserLoginDAO();
			uDAO.jndiName = jndiName;
		}//end if
		return uDAO;
	}//getInstance
	
	
	
	
	
	
	public userDTO selectLogin( LoginDTO lDTO ) throws SQLException {
		userDTO uDTO = null;
		
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
		//1. JNDI사용객체 생성
		//2. DataSource 얻기
		//3. DataSource에서 Connection 얻기
			con=dbCon.getConn();
		//4. 쿼리문 생성객체 얻기
			String selectMemberData
			= "select users_name from users where users_id=? and users_pass=? and active='활성화'";
			pstmt = con.prepareStatement(selectMemberData);
		//5. 바인드 변수에 값 설정
			pstmt.setString(1, lDTO.getUsers_id());
			pstmt.setString(2, lDTO.getUsers_pass());//일방향 Hash된 비번
		//6. 쿼리문 수행 후 결과 얻기
			rs=pstmt.executeQuery();
			if( rs.next() ) {//조회된 결과 있음.(입력한 아이디와 비번이 맞음.)
				uDTO = new userDTO();
				uDTO.setUsers_id(lDTO.getUsers_id());
				uDTO.setUsers_name(rs.getString("users_name"));
			}//end if
		}finally {
		//7. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		}
		return uDTO;
	}
	
}//class
