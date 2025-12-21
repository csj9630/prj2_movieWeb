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
			// [자동 정리] 조회 시 오래된 결제대기 건 취소 처리
			cancelPendingBookings(userId);
			
			con = db.getConn();
			
			if(con == null) {
				System.err.println("[ERROR] DB Connection failed in BookDAO.");
				return list;
			}
			
			StringBuilder sql = new StringBuilder();
			// 공백 문제 방지를 위해 TRIM 적용
			sql.append("SELECT b.book_num, b.users_id, b.screen_code, TRIM(b.book_state) as book_state, ")
			   .append("       b.total_book, b.book_time, ")
			   .append("       m.movie_name, m.main_image, ")
			   .append("       t.theather_name, ")
			   .append("       TO_CHAR(s.screen_date, 'YYYY-MM-DD') AS screen_date, ")
			   .append("       TO_CHAR(s.screen_open, 'HH24:MI:SS') AS screen_open, ") // 시간 추가
			   .append("       s.screen_price ")
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
					
					// DB 포맷이 'YYYY-MM-DD HH24:MI:SS' 형태임
					pstmt.setString(paramIdx++, year + "-" + monthStr + "%"); 
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
				dto.setScreen_open(rs.getString("screen_open")); // 시간 설정
				dto.setScreen_price(rs.getInt("screen_price"));
				
				list.add(dto);
			}
			
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		
		return list;
	}
	
	/**
	 * 예매 상태 변경 (결제대기 -> 결제완료 or 취소)
	 * @param bookNum 예매 번호
	 * @param state 변경할 상태
	 * @return 성공 여부 (1:성공, 0:실패)
	 * @throws SQLException
	 */
	public int updateBookState(String bookNum, String state) throws SQLException {
		int result = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			String sql = "UPDATE BOOK SET book_state = ? WHERE book_num = ?";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, state);
			pstmt.setString(2, bookNum);
			
			result = pstmt.executeUpdate();
			
		} finally {
			db.dbClose(null, pstmt, con);
		}
		
		return result;
	}


	
	/**
	 * 일정 시간이 지난 '결제대기' 상태의 예매를 '결제취소'로 변경 (스케줄러 대용)
	 * @param userId 사용자 ID
	 * @return 업데이트된 건수
	 */
	public int cancelPendingBookings(String userId) {
		int result = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			con.setAutoCommit(false); // 트랜잭션 처리
			
			// 1. 대상 조회 조건 (1분 이상 지난 결제대기)
			// 재결제 기능이 없으므로 비교적 짧게 설정하여 좌석 점유 해제
			String whereClause = "WHERE users_id = ? " +
			                     "AND book_state = '결제대기' " +
			                     "AND (SYSDATE - TO_DATE(book_time, 'YYYY-MM-DD HH24:MI:SS')) * 24 * 60 > 1";

			// 2. SEAT_BOOK 테이블 데이터 삭제 (좌석 점유 해제)
			// BOOK 테이블이 업데이트되기 전에 수행 (book_state가 아직 '결제대기'일 때)
			String seatWhere = "WHERE book_num IN (SELECT book_num FROM BOOK " + whereClause + ")";
			String sqlSeat = "DELETE FROM SEAT_BOOK " + seatWhere;
			pstmt = con.prepareStatement(sqlSeat);
			pstmt.setString(1, userId);
			int deletedSeats = pstmt.executeUpdate();
			pstmt.close();
			
			// 3. PAYMENT 테이블 업데이트 (결제중 -> 결제취소)
            // PAYMENT에는 users_id 컬럼이 없으므로 book_num 서브쿼리로 연결해야 함
            String paymentWhere = "WHERE book_num IN (SELECT book_num FROM BOOK " + whereClause + ")";
			String sqlPayment = "UPDATE PAYMENT SET payment_state = '결제취소' " + paymentWhere;
			
			pstmt = con.prepareStatement(sqlPayment);
            // 서브쿼리 내의 users_id 파라미터 바인딩
			pstmt.setString(1, userId);
			pstmt.executeUpdate();
			pstmt.close();
			
			// 3. BOOK 테이블 업데이트 (결제대기 -> 결제취소)
			String sqlBook = "UPDATE BOOK SET book_state = '결제취소' " + whereClause;
			
			pstmt = con.prepareStatement(sqlBook);
			pstmt.setString(1, userId);
			result = pstmt.executeUpdate();
			
			con.commit();
			
			if(result > 0) {
				System.out.println("[INFO] Auto-cancelled " + result + " pending bookings (and payments) for user: " + userId);
			}
			
		} catch (SQLException e) {
			try { con.rollback(); } catch(SQLException se) {}
			e.printStackTrace();
		} finally {
			try { db.dbClose(null, pstmt, con); } catch(Exception e) {}
		}
		
		return result;
	}
	
	/**
	 * [전체 사용자] 일정 시간이 지난 '결제대기' 건 일괄 정리 (좌석 조회 전 호출용)
	 * @return 업데이트된 건수
	 */
	public int cancelAllExpiredBookings() {
		int result = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			con.setAutoCommit(false);
			
			// 1. 대상 조회 조건 (1분 이상 지난 결제대기, 전체 사용자 대상)
			String whereClause = "WHERE book_state = '결제대기' " +
			                     "AND (SYSDATE - TO_DATE(book_time, 'YYYY-MM-DD HH24:MI:SS')) * 24 * 60 > 1";

			// 2. SEAT_BOOK 테이블 데이터 삭제
			String seatWhere = "WHERE book_num IN (SELECT book_num FROM BOOK " + whereClause + ")";
			String sqlSeat = "DELETE FROM SEAT_BOOK " + seatWhere;
			pstmt = con.prepareStatement(sqlSeat);
			int deletedSeats = pstmt.executeUpdate();
			pstmt.close();
			
			// 3. PAYMENT 테이블 업데이트 (결제중 -> 결제취소)
            String paymentWhere = "WHERE book_num IN (SELECT book_num FROM BOOK " + whereClause + ")";
			String sqlPayment = "UPDATE PAYMENT SET payment_state = '결제취소' " + paymentWhere;
			pstmt = con.prepareStatement(sqlPayment);
			pstmt.executeUpdate();
			pstmt.close();
			
			// 4. BOOK 테이블 업데이트 (결제대기 -> 결제취소)
			String sqlBook = "UPDATE BOOK SET book_state = '결제취소' " + whereClause;
			pstmt = con.prepareStatement(sqlBook);
			result = pstmt.executeUpdate();
			
			con.commit();
			
			if(result > 0) {
				System.out.println("[INFO] Auto-cancelled " + result + " expired bookings (Global check).");
			}
			
		} catch (SQLException e) {
			try { con.rollback(); } catch(SQLException se) {}
			e.printStackTrace();
		} finally {
			try { db.dbClose(null, pstmt, con); } catch(Exception e) {}
		}
		
		return result;
	}

}
