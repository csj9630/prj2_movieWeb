package movie.admin; // 패키지명 확인

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import DBConnection.DbConn;

public class AdminDAO {
	private static AdminDAO aDAO;
	
	private AdminDAO() {
	}

	public static AdminDAO getInstance() {
		if(aDAO == null) {
			aDAO = new AdminDAO();
		}
		return aDAO;
	}
	
	/**
	 * 관리자 로그인
	 * @param id 아이디
	 * @param pass 비밀번호
	 * @return 로그인 성공 시 AdminDTO(정보 포함), 실패 시 null
	 * @throws SQLException
	 */
	// 1. 반환 타입을 String -> AdminDTO로 변경
	public AdminDTO selectLoginAdmin(String id, String pass) throws SQLException {
		AdminDTO aDTO = null;
		
		// 2. DbConn.getInstance()는 파라미터가 없도록 만들었습니다. (jsp_prj와 동일하다면)
		DbConn db = DbConn.getInstance("jdbc/dbcp"); 
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			
			// 3. 쿼리문: ID와 PASS가 일치하는 행을 찾음
			String selectAdmin = "SELECT admin_id, create_date FROM admin WHERE admin_id=? AND admin_pass=?";
			
			// 4. [중요 수정] 변수 selectAdmin을 넣어야 함 (메소드 재귀호출 X)
			pstmt = con.prepareStatement(selectAdmin);
			
			pstmt.setString(1, id);
			pstmt.setString(2, pass);
			
			rs = pstmt.executeQuery();
			
			// 5. 로그인은 결과가 1개이므로 while보다는 if가 의미상 명확함
			if(rs.next()) {
				aDTO = new AdminDTO();
				aDTO.setAdminId(rs.getString("admin_id"));
				// 6. create_date는 로그인 검증엔 안 쓰이지만, 결과 정보로 담아둠
				aDTO.setCreateDate(rs.getDate("create_date")); 
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		
		return aDTO; // 성공 시 객체, 실패 시 null 반환
	}
}