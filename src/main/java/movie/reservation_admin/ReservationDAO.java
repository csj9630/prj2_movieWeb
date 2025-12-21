package movie.reservation_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class ReservationDAO {
	private static ReservationDAO rDAO;
	
	private ReservationDAO() {}
	
	public static ReservationDAO getInstance() {
		if(rDAO == null) rDAO = new ReservationDAO();
		return rDAO;
	}
	
	/**
	 * 총 예매 내역 수 조회 (검색 포함)
	 */
	public int selectTotalCount(String field, String keyword) throws SQLException {
		int count = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			sql.append(" SELECT count(*) FROM BOOK b ")
			   .append(" JOIN USERS u ON b.users_id = u.users_id ")
			   .append(" JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
			   .append(" JOIN MOVIE m ON si.movie_code = m.movie_code ");
			
			if(keyword != null && !keyword.isEmpty()) {
				if("0".equals(field)) { // 예매번호
					sql.append(" WHERE b.book_num LIKE '%'||?||'%' ");
				} else if("1".equals(field)) { // 아이디
					sql.append(" WHERE u.users_id LIKE '%'||?||'%' ");
				} else if("2".equals(field)) { // 영화제목
					sql.append(" WHERE m.movie_name LIKE '%'||?||'%' ");
				}
			}
			
			pstmt = con.prepareStatement(sql.toString());
			if(keyword != null && !keyword.isEmpty()) {
				pstmt.setString(1, keyword);
			}
			
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return count;
	}
	
	/**
	 * 예매 리스트 조회 (다중 조인)
	 */
	public List<ReservationDTO> selectReservationList(int startNum, int endNum, String field, String keyword) throws SQLException {
		List<ReservationDTO> list = new ArrayList<>();
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			sql.append(" SELECT book_num, users_id, users_name, movie_name, theather_name, ")
			   .append("        screen_date, screen_open, total_book, payment_price, book_state, book_time, rnum ")
			   .append(" FROM ( ")
			   .append("    SELECT b.book_num, u.users_id, u.users_name, m.movie_name, ti.theather_name, ")
			   .append("           TO_CHAR(si.screen_date, 'YYYY-MM-DD') screen_date, ")
			   .append("           TO_CHAR(si.screen_open, 'HH24:MI') screen_open, ")
			   .append("           b.total_book, p.payment_price, b.book_state, ")
			   .append("           b.book_time, ") 
			   .append("           ROW_NUMBER() OVER(ORDER BY b.book_time DESC) rnum ")
			   .append("    FROM BOOK b ")
			   .append("    JOIN USERS u ON b.users_id = u.users_id ")
			   .append("    JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
			   .append("    JOIN MOVIE m ON si.movie_code = m.movie_code ")
			   .append("    JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
			   .append("    LEFT JOIN PAYMENT p ON b.book_num = p.book_num ");
			
			if(keyword != null && !keyword.isEmpty()) {
				if("0".equals(field)) { 
					sql.append(" WHERE b.book_num LIKE '%'||?||'%' ");
				} else if("1".equals(field)) { 
					sql.append(" WHERE u.users_id LIKE '%'||?||'%' ");
				} else if("2".equals(field)) { 
					sql.append(" WHERE m.movie_name LIKE '%'||?||'%' ");
				}
			}
			
			sql.append(" ) WHERE rnum BETWEEN ? AND ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			int idx = 1;
			if(keyword != null && !keyword.isEmpty()) {
				pstmt.setString(idx++, keyword);
			}
			pstmt.setInt(idx++, startNum);
			pstmt.setInt(idx++, endNum);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ReservationDTO dto = new ReservationDTO();
				dto.setBookNum(rs.getString("book_num"));
				dto.setUserId(rs.getString("users_id"));
				dto.setUserName(rs.getString("users_name"));
				dto.setMovieName(rs.getString("movie_name"));
				dto.setTheaterName(rs.getString("theather_name"));
				dto.setScreenDate(rs.getString("screen_date"));
				dto.setScreenTime(rs.getString("screen_open"));
				dto.setSeatCount(rs.getInt("total_book"));
				dto.setPrice(rs.getInt("payment_price"));
				dto.setBookState(rs.getString("book_state")); 
				
				String rawDate = rs.getString("book_time");
				if(rawDate != null && rawDate.length() >= 10) {
					rawDate = rawDate.substring(0, 10);
				}
				dto.setBookDate(rawDate);
				
				list.add(dto);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}
	
	/**
	 * 예매 상세 조회 (좌석 정보 포함) - AJAX 모달용
	 */
	public ReservationDTO selectReservationDetail(String bookNum) throws SQLException {
		ReservationDTO dto = null;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			// 1. 기본 정보 조회
			StringBuilder sql = new StringBuilder();
			sql.append(" SELECT b.book_num, u.users_id, u.users_name, m.movie_name, ti.theather_name, ")
			   .append("        TO_CHAR(si.screen_date, 'YYYY-MM-DD') screen_date, ")
			   .append("        TO_CHAR(si.screen_open, 'HH24:MI') screen_open, ")
			   .append("        b.total_book, p.payment_price, p.payment_state, b.book_state, ")
			   .append("        b.book_time ") 
			   .append(" FROM BOOK b ")
			   .append(" JOIN USERS u ON b.users_id = u.users_id ")
			   .append(" JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
			   .append(" JOIN MOVIE m ON si.movie_code = m.movie_code ")
			   .append(" JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
			   .append(" LEFT JOIN PAYMENT p ON b.book_num = p.book_num ")
			   .append(" WHERE b.book_num = ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, bookNum);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new ReservationDTO();
				dto.setBookNum(rs.getString("book_num"));
				dto.setUserId(rs.getString("users_id"));
				dto.setUserName(rs.getString("users_name"));
				dto.setMovieName(rs.getString("movie_name"));
				dto.setTheaterName(rs.getString("theather_name"));
				dto.setScreenDate(rs.getString("screen_date"));
				dto.setScreenTime(rs.getString("screen_open"));
				dto.setSeatCount(rs.getInt("total_book"));
				dto.setPrice(rs.getInt("payment_price"));
				dto.setBookState(rs.getString("book_state"));
				dto.setPaymentState(rs.getString("payment_state"));
				
				dto.setBookDate(rs.getString("book_time"));
				
				// 2. 좌석 정보 조회
				pstmt.close();
				String seatSql = "SELECT seat_code FROM SEAT_BOOK WHERE book_num = ?";
				pstmt = con.prepareStatement(seatSql);
				pstmt.setString(1, bookNum);
				ResultSet rsSeat = pstmt.executeQuery();
				
				StringBuilder seats = new StringBuilder();
				while(rsSeat.next()) {
					if(seats.length() > 0) seats.append(", ");
					seats.append(rsSeat.getString("seat_code"));
				}
				dto.setSeats(seats.toString());
				rsSeat.close();
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return dto;
	}
	
	/**
	 * 예매 취소 (트랜잭션: BOOK 상태 변경 + PAYMENT 상태 변경)
	 */
	public int cancelReservation(String bookNum) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			con.setAutoCommit(false); // 트랜잭션 시작
			
			// ---------------------------------------------------------
			// 1. BOOK 테이블 상태 변경 ('예매취소', 취소일 = 현재)
			// ---------------------------------------------------------
			String updateBook = "UPDATE BOOK SET book_state = '결제취소', book_cancel = SYSDATE WHERE book_num = ?";
			pstmt = con.prepareStatement(updateBook);
			pstmt.setString(1, bookNum);
			cnt = pstmt.executeUpdate();
			
			// ★ 중요: 두 번째 쿼리를 위해 사용한 pstmt를 반드시 닫아줍니다.
			pstmt.close(); 
			
			// ---------------------------------------------------------
			// 2. PAYMENT 테이블 상태 변경 ('결제취소')
			// ---------------------------------------------------------
			String updatePay = "UPDATE PAYMENT SET payment_state = '결제취소' WHERE book_num = ?";
			pstmt = con.prepareStatement(updatePay);
			pstmt.setString(1, bookNum);
			int payCnt = pstmt.executeUpdate(); // 실행 결과 확인용 변수 (로깅용)
			
			// ---------------------------------------------------------
			// 3. 커밋 (둘 다 문제 없을 때만)
			// ---------------------------------------------------------
			con.commit();
			
		} catch(SQLException e) {
			// 에러 발생 시 변경사항 모두 취소 (롤백)
			if(con != null) { try { con.rollback(); } catch(SQLException ex) {} }
			throw e;
		} finally {
			// 오토커밋 복구 및 자원 해제
			if(con != null) { try { con.setAutoCommit(true); } catch(SQLException ex) {} }
			db.dbClose(null, pstmt, con);
		}
		
		return cnt;
	}
}