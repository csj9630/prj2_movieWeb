package movie_mypage_book;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class BookDAO {
	private static BookDAO bDAO;
	
	private BookDAO() {
	}
	
	public static BookDAO getInstance() {
		if(bDAO == null) {
			bDAO = new BookDAO();
		}
		return bDAO;
	}
	
	/**
	 * 예매 내역 조회
	 * @param userId 사용자 ID
	 * @param type 조회 유형 ("ACTIVE": 예매내역, "PAST": 지난내역/취소)
	 * @return 예매 목록
	 * @throws SQLException
	 */
	public List<BookDTO> selectBookList(String userId, String type, String year, String month) throws SQLException {
		List<BookDTO> list = new ArrayList<BookDTO>();
		
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			
			if(con == null) {
				System.err.println("[ERROR] DB Connection failed in BookDAO.");
				return list;
			}
			
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT b.book_num, b.users_id, b.screen_code, b.book_state, ")
			   .append("       b.total_book, b.book_time, ")
			   .append("       m.movie_name, m.main_image, ")
			   .append("       t.theather_name, s.screen_date, s.screen_price ")
			   .append("FROM BOOK b ")
			   .append("JOIN SCREEN_INFO s ON b.screen_code = s.screen_code ")
			   .append("JOIN MOVIE m ON s.movie_code = m.movie_code ")
			   .append("JOIN THEATHER_INFO t ON s.theather_num = t.theather_num ")
			   .append("WHERE b.users_id = ? ");
			
			// Type에 따른 조건 추가
			if("ACTIVE".equals(type)) { // 예매내역 (당월)
				if(year != null && !year.isEmpty() && month != null && !month.isEmpty()) {
					sql.append("AND b.book_time LIKE ? ");
				}
			} else if("PAST".equals(type)) { // 지난내역
				if(year != null && !year.isEmpty() && month != null && !month.isEmpty()) {
					sql.append("AND b.book_time LIKE ? ");
				}
			}
			
			sql.append("ORDER BY b.book_time DESC");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, userId);
			
			int paramIdx = 2;
			if(year != null && !year.isEmpty() && month != null && !month.isEmpty()) {
				// ACTIVE나 PAST 모두 날짜 필터링이 있다면 적용
				if("ACTIVE".equals(type) || "PAST".equals(type)) {
					String monthStr = month.length() == 1 ? "0" + month : month;
					
					// DB 포맷이 'YY/MM/DD' (ex: 25/12/15) 형태라고 판단됨 ('rs.getString' 결과 및 검색 실패 원인 분석)
					// 따라서 '2025' -> '25'로 변환하고 구분자를 '/'로 변경하여 검색
					String shortYear = year;
					if(year.length() == 4) {
						shortYear = year.substring(2);
					}
					
					pstmt.setString(paramIdx++, shortYear + "/" + monthStr + "%"); 
				}
			}
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				BookDTO dto = new BookDTO();
				dto.setBook_num(rs.getString("book_num"));
				dto.setUsers_id(rs.getString("users_id"));
				dto.setScreen_code(rs.getString("screen_code"));
				dto.setBook_state(rs.getString("book_state"));
				dto.setTotal_book(rs.getInt("total_book"));
				dto.setBookTimeStr(rs.getString("book_time"));
				
				dto.setMovie_name(rs.getString("movie_name"));
				dto.setMain_image(rs.getString("main_image"));
				dto.setTheater_name(rs.getString("theather_name"));
				dto.setScreen_date(rs.getString("screen_date"));
				dto.setScreen_price(rs.getInt("screen_price"));
				
				list.add(dto);
			}
			
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		
		return list;
	}

}
