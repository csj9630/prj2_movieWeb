package movie.user_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class UserDAO {
	
	private static UserDAO uDAO;
	
	private UserDAO() {
	}
	
	public static UserDAO getInstance() {
		if(uDAO == null) {
			uDAO = new UserDAO();
		}
		return uDAO;
	}
	
	/**
	 * 총 회원 수 구하기
	 */
	public int selectTotalCount(String field, String keyword) throws SQLException {
		int totalCount = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder selectCnt = new StringBuilder();
			selectCnt.append("SELECT count(*) cnt FROM users ");
			
			boolean isSearch = keyword != null && !"".equals(keyword);
			if(isSearch) {
				String colName = "users_id";
				if("1".equals(field)) colName = "users_name";
				if("2".equals(field)) colName = "phone_num";
				selectCnt.append("WHERE ").append(colName).append(" LIKE '%'||?||'%'");
			}
			
			pstmt = con.prepareStatement(selectCnt.toString());
			if(isSearch) {
				pstmt.setString(1, keyword);
			}
			
			rs = pstmt.executeQuery();
			if(rs.next()) {
				totalCount = rs.getInt("cnt");
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return totalCount;
	}
	
	/**
	 * 회원 리스트 조회 (ACTIVE 컬럼 적용)
	 */
	public List<UserDTO> selectUserList(int startNum, int endNum, String field, String keyword) throws SQLException {
		List<UserDTO> list = new ArrayList<UserDTO>();
		
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			
			boolean isSearch = keyword != null && !"".equals(keyword);
			StringBuilder selectUser = new StringBuilder();
			
			// [수정] user_status 대신 ACTIVE 컬럼 조회
			selectUser.append("	SELECT users_id, users_name, email, phone_num, join_date, recent_login,	")
					  .append("		   TO_CHAR(birth, 'YYYY-MM-DD') birth, gender, active, rnum	")
					  .append("	FROM (SELECT users_id, users_name, email, phone_num, join_date, recent_login, birth, gender, active,	")
					  .append("		ROW_NUMBER() OVER(ORDER BY join_date DESC) rnum	")
					  .append("		FROM users ");
			
			if(isSearch) {
				String colName = "users_id";
				if("1".equals(field)) colName = "users_name";
				if("2".equals(field)) colName = "phone_num";
				selectUser.append(" WHERE ").append(colName).append(" LIKE '%'||?||'%' ");
			}
			
			selectUser.append(" ) WHERE rnum BETWEEN ? AND ? ");
			
			pstmt = con.prepareStatement(selectUser.toString());
			
			int bindIndex = 1;
			if(isSearch) {
				pstmt.setString(bindIndex++, keyword);
			}
			pstmt.setInt(bindIndex++, startNum);
			pstmt.setInt(bindIndex++, endNum);
			
			rs = pstmt.executeQuery();
			
			UserDTO uDTO = null;
			while(rs.next()) {
				uDTO = new UserDTO();
				uDTO.setUserId(rs.getString("users_id"));
				uDTO.setUserName(rs.getString("users_name"));
				uDTO.setEmail(rs.getString("email"));
				uDTO.setPhoneNum(rs.getString("phone_num"));
				uDTO.setJoinDate(rs.getDate("join_date"));
				uDTO.setRecentLogin(rs.getDate("recent_login"));
				uDTO.setBirth(rs.getString("birth"));
				uDTO.setGender(rs.getString("gender"));
				
				// [수정] DB 값이 '활성'/'비활성' 이므로 그대로 설정
				uDTO.setActive(rs.getString("active"));
				
				list.add(uDTO);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}

	/**
	 * 회원 상태 변경
	 * @param userId 아이디
	 * @param status 변경할 상태 ('활성' or '비활성')
	 */
	public int updateUserStatus(String userId, String status) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			// [수정] 컬럼명 ACTIVE로 변경
			String updateStatus = "UPDATE users SET active = ? WHERE users_id = ?";
			pstmt = con.prepareStatement(updateStatus);
			pstmt.setString(1, status);
			pstmt.setString(2, userId);
			
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
}