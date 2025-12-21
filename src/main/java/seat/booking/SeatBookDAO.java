package seat.booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;


import movie_mypage_book.BookDAO;

public class SeatBookDAO {
	private static SeatBookDAO sbDAO;

	private SeatBookDAO() {

	}
	
	public static SeatBookDAO getInstance() {
		if (sbDAO == null) {
			sbDAO = new SeatBookDAO();
		} // end if
		return sbDAO;
	}//getInstance
	
	//빠른 예매 페이지에서 페이지 로딩시 좌석 그리기
	public List<SeatBookDTO> selectAllSeatBook(String screen_code) throws SQLException {
		// [자동 정리] 좌석 조회 전 만료된 예약 정리 (전체 사용자 대상)
		BookDAO.getInstance().cancelAllExpiredBookings();
		
		List<SeatBookDTO> list = new ArrayList<SeatBookDTO>();

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// 1. JNDI사용객체 생성
			// 2. DataSource 얻기
			// 3. Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문생성객체 얻기
			StringBuilder selectSeatBook = new StringBuilder();
			selectSeatBook
			.append("	SELECT b.seat_row || b.seat_col AS seat_name	")
			.append("	FROM SEAT_BOOK a	")
			.append("	JOIN SEAT b ON a.seat_code = b.seat_code 	")
			.append("	WHERE a.screen_code = ? 	");
			pstmt = con.prepareStatement(selectSeatBook.toString());
			// 5. 바인드변수 값 설정
			pstmt.setString(1, screen_code);

			// 6. 조회결과 얻기
			SeatBookDTO sDTO = null;
			rs = pstmt.executeQuery();

			while (rs.next()) {
				sDTO = new SeatBookDTO();
				sDTO.setSeat_name((rs.getString("seat_name")));
				list.add(sDTO);
			} // end while
		} finally {
			// 7. 연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally
		return list;
	}// selectAllRestaurant
	
	
	
	//seat_code값 가져오기 ( A1, 상영관 코드를 가지고 몇 번 seat_code을 가지는지 찾기)
	public List<String> selectSeatCodes(List<String> seatNames, String theaterNum) throws SQLException {
	    List<String> seatCodesList = new ArrayList<>();
	    DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    // IN 절에 들어갈 물음표(?) 개수를 다이나믹 쿼리로 생성
	    StringBuilder sql = new StringBuilder("SELECT seat_code FROM SEAT WHERE theather_num = ? AND (seat_row || seat_col) IN (");
	    for (int i = 0; i < seatNames.size(); i++) {
	        sql.append("?");
	        if (i < seatNames.size() - 1) sql.append(",");
	    }
	    sql.append(")");

	    try {
	    	con = dbCon.getConn();
	        pstmt = con.prepareStatement(sql.toString());
	        
	        //상영관 번호 설정
	        pstmt.setString(1, theaterNum);
	        
	        //IN 절에 들어갈 좌석 이름들 설정
	        for (int i = 0; i < seatNames.size(); i++) {
	            pstmt.setString(i + 2, seatNames.get(i));
	        }
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	seatCodesList.add(rs.getString("seat_code"));
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, con);
	    }
	    return seatCodesList;
	}//selectSeatCodes

	
	//영화 예매 메인 메소드
	public String insertBookingTransaction(SeatBookDTO dto) throws SQLException {
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
	    String bookNum = null;
	    
	    // 1. 시퀀스로 번호 먼저 생성
	    String sqlSeq = "SELECT 'bn'||LPAD(book_seq.NEXTVAL, 3, '0') FROM DUAL";

	    //Book 
	    String sqlBook = "INSERT INTO BOOK (book_num, book_time, book_state, total_book, screen_code, users_id) " +
                "VALUES (?, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '결제대기', ?, ?, ?)";
	    // 이미 생성된 bookNum 사용
	    String sqlSeat = "INSERT INTO SEAT_BOOK (seat_book_code, seat_code, screen_code, book_num, discount_code) " +
                "VALUES ('sb'||LPAD(seat_book_seq.NEXTVAL, 3, '0'), ?, ?, ?, ?)";
	    
	    String sqlPay = "INSERT INTO PAYMENT (payment_code, payment_price, payment_method, payment_time, payment_state, book_num) " +
                "VALUES ('pc'||LPAD(payment_seq.NEXTVAL, 3, '0'), ?, ?, SYSDATE, '결제중', ?)";

	    try {
	    	con = dbCon.getConn();
	        con.setAutoCommit(false); // 트랜잭션 시작

	        // 1. 에매 번호 생성
	        pstmt = con.prepareStatement(sqlSeq);
	        ResultSet rs = pstmt.executeQuery();
	        if(rs.next()) {
	        	bookNum = rs.getString(1);
	        }
	        pstmt.close();
	        
	        if(bookNum == null) {
	        	throw new SQLException("예매 번호 생성 실패");
	        }
	        
	        //BOOK 테이블
	        pstmt = con.prepareStatement(sqlBook);
	        pstmt.setString(1, bookNum);
	        pstmt.setInt(2, dto.getSeatCodes().size());
	        pstmt.setString(3, dto.getScreenCode());
	        pstmt.setString(4, dto.getUserId());
	        pstmt.executeUpdate();
	        pstmt.close();

	        //SEAT_BOOK 테이블 (좌석 수만큼 반복)
	        pstmt = con.prepareStatement(sqlSeat);
	        for (int i = 0; i < dto.getSeatCodes().size(); i++) {
	            pstmt.setString(1, dto.getSeatCodes().get(i));
	            pstmt.setString(2, dto.getScreenCode());
	            pstmt.setString(3, bookNum);
	            pstmt.setString(4, dto.getDiscountCodes().get(i));
	            pstmt.executeUpdate();
	        }
	        pstmt.close();

	        //PAYMENT 테이블
	        pstmt = con.prepareStatement(sqlPay);
	        pstmt.setInt(1, dto.getTotalPrice());
	        pstmt.setString(2, "CARD");
	        pstmt.setString(3, bookNum);
	        pstmt.executeUpdate();

	        con.commit(); // 모두 성공 시 확정

	    } catch (Exception e) {
	        if (con != null) con.rollback(); // 하나라도 실패 시 전체 취소
	        bookNum = null; // 실패 시 null 반환
	        throw e;
	    } finally {
	        if (con != null) {
	            con.setAutoCommit(true);
	            con.close();
	        }
	    }
	    return bookNum;
	}
	
	//예약 확인
	public boolean isSeatAlreadyReserved(List<String> seatCodes, String screenCode) throws SQLException {
	    boolean isReserved = false;
	    DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    // 선택한 좌석들 중 해당 상영 코드에 이미 등록된 좌석이 있는지 검사
	    StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM SEAT_BOOK WHERE screen_code = ? AND seat_code IN (");
	    for (int i = 0; i < seatCodes.size(); i++) {
	        sql.append("?");
	        if (i < seatCodes.size() - 1) sql.append(",");
	    }
	    sql.append(")");

	    try {
	        con = dbCon.getConn();
	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setString(1, screenCode);
	        for (int i = 0; i < seatCodes.size(); i++) {
	            pstmt.setString(i + 2, seatCodes.get(i));
	        }

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            // 카운트가 0보다 크면 누군가 이미 예약한 것
	            if (rs.getInt(1) > 0) isReserved = true;
	        }
	    } finally {
	        dbCon.dbClose(rs, pstmt, con);
	    }
	    return isReserved;
	}
	
}//class
