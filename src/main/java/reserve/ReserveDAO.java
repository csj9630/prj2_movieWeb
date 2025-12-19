package reserve;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;


public class ReserveDAO {
	private static ReserveDAO bDAO;

	private ReserveDAO() {
		// 생성자 잠금
	}// WebMemerDAO


	public static ReserveDAO getInstance() {
		if (bDAO == null) {
			bDAO = new ReserveDAO();

		} // end if

		return bDAO;
	}// getInstance
	
	
	/**
	 * 좌석 예약 가능 여부 확인
	 * @param screenCode 상영 코드
	 * @param seatCode 좌석 코드
	 * @return true: 예약 가능, false: 예약 불가
	 */
	public boolean selectSeatStatus(String screenCode, String seatCode) throws SQLException {
		boolean resultFlag = false;

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		try {
			// 1.JNDI 사용객체 생성
			// 2.DataSource 얻기
			// 3.DataSource에서 Connection 얻기
			con = dbCon.getConn();

			// 4.쿼리문 생성객체 얻기
			StringBuilder selectSeatStatus = new StringBuilder();

			selectSeatStatus
			.append("	select count(*) as cnt	")
			.append("	from seat_book sb		")
			.append("	inner join book b on sb.book_num = b.book_num	")
			.append("	where sb.screen_code = ?	")
			.append("	and sb.seat_code = ? 	")
			.append("	and b.book_state in ('예약중', '예약완료', 'T')	");
	
			
			
			pstmt = con.prepareStatement(selectSeatStatus.toString());
			// 5.바인드 변수 값 설정
	        pstmt.setString(1, screenCode);
            pstmt.setString(2, seatCode);

			// 6.쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			if (rs.next()) {
				// 0이면 예약 가능
				resultFlag = rs.getInt("CNT") == 0;
			} // end if

		} finally {
			// 7.연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return resultFlag;
	}// selectSeatStatus
	
	/**
	 * BOOK_STATE 업데이트
	 * @param bookNum 예매 번호
	 * @param bookState 변경할 상태 ('예약중', '예약완료', '취소' 등)
	 * @return 업데이트된 행 수 (1: 성공, 0: 실패)
	 */
	public int updateBookState(String bookNum, String bookState) throws SQLException {
		int rowCount = 0;

		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = dbCon.getConn();

			StringBuilder updateBookState = new StringBuilder();
			updateBookState
			.append("	update book			")
			.append("	set book_state = ?	")
			.append("	where book_num = ?	");

			pstmt = con.prepareStatement(updateBookState.toString());
			
			// 바인드 변수 값 설정
			pstmt.setString(1, bookState);
			pstmt.setString(2, bookNum);

			// 쿼리 수행
			rowCount = pstmt.executeUpdate();

		} finally {
			dbCon.dbClose(null, pstmt, con);
		} // end finally

		return rowCount;
	}// updateBookState
	
	

    /**
     * BOOK 테이블에 INSERT
     * @param bookDTO BOOK 정보
     * @return INSERT된 행 수
     */
    public int insertBook(BookDTO bookDTO) throws SQLException {
        int rowCount = 0;

        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dbCon.getConn();

            StringBuilder insertSql = new StringBuilder();
            insertSql
            .append("   insert into book(              ")
            .append("       book_num,                  ")
            .append("       book_time,                 ")
            .append("       book_state,                ")
            .append("       total_book,                ")
            .append("       screen_code,               ")
            .append("       users_id                   ")
            .append("   ) values (                     ")
            .append("       'bn' || LPAD(book_seq.NEXTVAL, 3, '0'), SYSDATE, ?, ?, ?, ?     ")
            .append("   )                              ");

            pstmt = con.prepareStatement(insertSql.toString());
            
           // pstmt.setString(1, bookDTO.getBookNum());
            pstmt.setString(1, bookDTO.getBookState());
            pstmt.setInt(2, bookDTO.getTotalBookNum());
            pstmt.setString(3, bookDTO.getScreenCode());
            pstmt.setString(4, bookDTO.getUsersId());

            rowCount = pstmt.executeUpdate();

        } finally {
            dbCon.dbClose(null, pstmt, con);
        }

        return rowCount;
    }// insertBook
	
    
    /**
     * SEAT_BOOK 테이블에 INSERT
     * @param seatBookDTO 좌석 예매 정보
     * @return INSERT된 행 수
     */
    public int insertSeatBook(SeatBookDTO seatBookDTO) throws SQLException {
        int rowCount = 0;

        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dbCon.getConn();

            StringBuilder insertSql = new StringBuilder();
            insertSql
            .append("   insert into seat_book(     ")
            .append("       seat_book_code,        ")
            .append("       seat_code,             ")
            .append("       screen_code,           ")
            .append("       book_num,              ")
            .append("       discount_code          ")
            .append("   ) values ( 'sb' || LPAD(seat_book_seq.NEXTVAL, 3, '0'), ?, ?, ?, ?)   ");

            pstmt = con.prepareStatement(insertSql.toString());
            
            //pstmt.setString(1, seatBookDTO.getSeatBookCode());
            pstmt.setString(1, seatBookDTO.getSeatCode());
            pstmt.setString(2, seatBookDTO.getScreenCode());
            pstmt.setString(3, seatBookDTO.getBookNum());
            pstmt.setString(4, seatBookDTO.getDiscountCode());

            rowCount = pstmt.executeUpdate();

        } finally {
            dbCon.dbClose(null, pstmt, con);
        }

        return rowCount;
    }// insertSeatBook
    
    /**
     * PAYMENT 테이블에 INSERT
     * @param paymentDTO 결제 정보
     * @return INSERT된 행 수
     */
    public int insertPayment(PaymentDTO paymentDTO) throws SQLException {
        int rowCount = 0;

        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dbCon.getConn();

            StringBuilder insertSql = new StringBuilder();
            insertSql
            .append("   insert into payment(           ")
            .append("       payment_code,              ")
            .append("       payment_price,             ")
            .append("       payment_method,            ")
            .append("       payment_time,              ")
            .append("       payment_state,             ")
            .append("       book_num                   ")
            .append("   ) values (                     ")
            .append("       'pc' || LPAD(payment_seq.NEXTVAL, 3, '0'), ?, ?, SYSDATE, ?, ?     ")
            .append("   )                              ");

            pstmt = con.prepareStatement(insertSql.toString());
            
            //pstmt.setString(1, paymentDTO.getPaymentCode());
            pstmt.setInt(1, paymentDTO.getPaymentPrice());
            pstmt.setString(2, paymentDTO.getPaymentMethod());
            pstmt.setString(3, paymentDTO.getPaymentState());
            pstmt.setString(4, paymentDTO.getBookNum());

            rowCount = pstmt.executeUpdate();

        } finally {
            dbCon.dbClose(null, pstmt, con);
        }

        return rowCount;
    }// insertPayment
    
    /**
     * 예약 생성 트랜잭션 (BOOK + SEAT_BOOK 여러 건)
     * 
     * [실행 시점] 
     * - 사용자가 좌석 선택 완료 후 "결제하기" 버튼 클릭
     * - 결제 페이지로 넘어가기 직전
     * 
     * [처리 내용]
     * 1. BOOK 테이블에 예매 정보 INSERT (BOOK_STATE = '예약중')
     * 2. SEAT_BOOK 테이블에 선택한 좌석들 INSERT (배치 처리)
     * 3. 트랜잭션으로 묶어서 원자성 보장
     * 
     * @param bookDTO 예매 정보 (예매번호, 사용자ID, 상영코드, 좌석수 등)
     * @param seatBookList 선택한 좌석 리스트 (좌석코드, 할인코드 등)
     * @return 생성된 예매번호 반환.
     * @throws SQLException DB 오류 발생 시
     */
    public String insertBookingTransaction(BookDTO bookDTO, List<SeatBookDTO> seatBookList) 
            throws SQLException {
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement seqPstmt = null;
        PreparedStatement bookPstmt = null;
        PreparedStatement seatBookPstmt = null;
        ResultSet rs = null;
        
        String generatedBookNum = null;

        try {
            con = dbCon.getConn();
            con.setAutoCommit(false); // ← 트랜잭션 시작 (자동 커밋 OFF)

            // 시퀀스 먼저 조회해서 book_num 생성
            String getSeqSql = "SELECT 'bn' || LPAD(book_seq.NEXTVAL, 3, '0') AS book_num FROM DUAL";
            
            seqPstmt = con.prepareStatement(getSeqSql);
            rs = seqPstmt.executeQuery();
            
            if (rs.next()) {
                generatedBookNum = rs.getString("book_num");
                System.out.println("생성된 book_num: " + generatedBookNum);  // 디버깅
            } else {
                throw new SQLException("book_num 생성 실패");
            }
            
            rs.close();
            seqPstmt.close();
            
            // 1. BOOK INSERT (시퀀스로 book_num 자동 생성)
            StringBuilder insertBookSql = new StringBuilder();
            insertBookSql
            .append("   INSERT INTO BOOK (                                          ")
            .append("       book_num,                                               ")
            .append("       book_time,                                              ")
            .append("       book_state,                                             ")
            .append("       total_book,                                             ")
            .append("       screen_code,                                            ")
            .append("       users_id                                                ")
            .append("   ) VALUES (                                                  ")
            .append("       ?,            ")  // ← 자동 생성
            .append("       SYSDATE,                                                ")
            .append("       ?,                                                      ")
            .append("       ?,                                                      ")
            .append("       ?,                                                      ")
            .append("       ?                                                       ")
            .append("   )                                                           ");

            // DTO에서 값 꺼내서 바인딩
            bookPstmt = con.prepareStatement(insertBookSql.toString());
            bookPstmt.setString(1, generatedBookNum);
            bookPstmt.setString(2, bookDTO.getBookState());
            bookPstmt.setInt(3, bookDTO.getTotalBookNum());
            bookPstmt.setString(4, bookDTO.getScreenCode());
            bookPstmt.setString(5, bookDTO.getUsersId());
            int bookResult = bookPstmt.executeUpdate();
            System.out.println("BOOK INSERT 결과: " + bookResult + "건");  // 디버깅

            // 생성된 book_num 조회
            //String selectBookNumSql = "SELECT 'BN' || LPAD(book_seq.CURRVAL, 3, '0') AS book_num FROM DUAL";
            //bookPstmt = con.prepareStatement(selectBookNumSql);
            //rs = bookPstmt.executeQuery();
            //if (rs.next()) {
           //     generatedBookNum = rs.getString("book_num");
           // }

            // ==========================================
            // 2. SEAT_BOOK INSERT (배치)
            StringBuilder insertSeatBookSql = new StringBuilder();
            insertSeatBookSql
            .append("   INSERT INTO SEAT_BOOK (                                     ")
            .append("       seat_book_code,                                         ")
            .append("       seat_code,                                              ")
            .append("       screen_code,                                            ")
            .append("       book_num,                                               ")
            .append("       discount_code                                           ")
            .append("   ) VALUES (                                                  ")
            .append("       'sb' || LPAD(seat_book_seq.NEXTVAL, 3, '0'),      ")  // ← 자동 생성
            .append("       ?,                                                      ")
            .append("       ?,                                                      ")
            .append("       ?,                                                      ")
            .append("       ?                                                       ")
            .append("   )                                                           ");

            seatBookPstmt = con.prepareStatement(insertSeatBookSql.toString());

            for (SeatBookDTO seatBook : seatBookList) {
                seatBookPstmt.setString(1, seatBook.getSeatCode());
                seatBookPstmt.setString(2, seatBook.getScreenCode());
                seatBookPstmt.setString(3, generatedBookNum);  // 생성된 book_num 사용
                seatBookPstmt.setString(4, seatBook.getDiscountCode());
                seatBookPstmt.addBatch();// ← 배치에 추가 (아직 실행 X)
            }

            int[] seatResults = seatBookPstmt.executeBatch();// ← 모아둔 INSERT들을 한 번에 실행
            System.out.println("SEAT_BOOK INSERT 결과: " + seatResults.length + "건");

            con.commit();// ← 여기서 비로소 DB에 실제로 저장됨

        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;

        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            if (seatBookPstmt != null) {
                try {
                    seatBookPstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            dbCon.dbClose(rs, bookPstmt, con);
        }

        return generatedBookNum;  // 생성된 예매번호 반환
    }//insertBookingTransaction
    
 // 3. 결제 완료 처리 (필수 추가)
    // ========================================
    public boolean completePaymentTransaction(PaymentDTO paymentDTO) throws SQLException {
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement paymentPstmt = null;
        PreparedStatement updatePstmt = null;
        boolean success = false;
        
        try {
            con = dbCon.getConn();
            con.setAutoCommit(false);
            
            // 1. PAYMENT INSERT
            StringBuilder insertPaymentSql = new StringBuilder();
            insertPaymentSql
            .append("   INSERT INTO PAYMENT (                                   ")
            .append("       payment_code,                                       ")
            .append("       payment_price,                                      ")
            .append("       payment_method,                                     ")
            .append("       payment_time,                                       ")
            .append("       payment_state,                                      ")
            .append("       book_num                                            ")
            .append("   ) VALUES (                                              ")
            .append("       'PAY' || LPAD(SEQ_PAYMENT_CODE.NEXTVAL, 8, '0'),   ")
            .append("       ?, ?, SYSDATE, '완료', ?                            ")
            .append("   )                                                       ");
            
            paymentPstmt = con.prepareStatement(insertPaymentSql.toString());
            paymentPstmt.setInt(1, paymentDTO.getPaymentPrice());
            paymentPstmt.setString(2, paymentDTO.getPaymentMethod());
            paymentPstmt.setString(3, paymentDTO.getBookNum());
            paymentPstmt.executeUpdate();
            
            // 2. BOOK_STATE 업데이트
            StringBuilder updateBookSql = new StringBuilder();
            updateBookSql
            .append("   UPDATE BOOK                         ")
            .append("   SET book_state = '예약완료'         ")
            .append("   WHERE book_num = ?                  ");
            
            updatePstmt = con.prepareStatement(updateBookSql.toString());
            updatePstmt.setString(1, paymentDTO.getBookNum());
            int rowCount = updatePstmt.executeUpdate();
            
            if (rowCount > 0) {
                con.commit();
                success = true;
            } else {
                con.rollback();
            }
            
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
            
        } finally {
            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            
            if (updatePstmt != null) {
                try {
                    updatePstmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            dbCon.dbClose(null, paymentPstmt, con);
        }
        
        return success;
    }
    
    // 4 예약 취소 (필수 추가)
    public boolean cancelBooking(String bookNum) throws SQLException {
        int rowCount = 0;
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = dbCon.getConn();
            
            StringBuilder updateSql = new StringBuilder();
            updateSql
            .append("   UPDATE BOOK                         ")
            .append("   SET book_state = '취소',            ")
            .append("       book_cancel = SYSDATE           ")
            .append("   WHERE book_num = ?                  ")
            .append("   AND book_state IN ('예약중')        ");  // 예약중인 것만 취소 가능
            
            pstmt = con.prepareStatement(updateSql.toString());
            pstmt.setString(1, bookNum);
            
            rowCount = pstmt.executeUpdate();
            
        } finally {
            dbCon.dbClose(null, pstmt, con);
        }
        
        return rowCount > 0;
    }//cancelBooking
    
    // 5. 예약 상세 조회 (필수 추가)
    // ========================================
    public BookDTO selectBookingDetail(String bookNum) throws SQLException {
        BookDTO bookDTO = null;
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = dbCon.getConn();
            
            StringBuilder selectSql = new StringBuilder();
            selectSql
            .append("   SELECT                                      ")
            .append("       b.book_num,                             ")
            .append("       b.book_time,                            ")
            .append("       b.book_state,                           ")
            .append("       b.total_book,                           ")
            .append("       b.screen_code,                          ")
            .append("       b.users_id,                             ")
            .append("       si.screen_date,                         ")
            .append("       si.screen_price,                        ")
            .append("       m.movie_name,                           ")
            .append("       ci.cinema_name,                         ")
            .append("       ti.theather_name                        ")
            .append("   FROM BOOK b                                 ")
            .append("   INNER JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
            .append("   INNER JOIN MOVIE m ON si.movie_code = m.movie_code ")
            .append("   INNER JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
            .append("   INNER JOIN CINEMA_INFO ci ON ti.cinema_num = ci.cinema_num ")
            .append("   WHERE b.book_num = ?                        ");
            
            pstmt = con.prepareStatement(selectSql.toString());
            pstmt.setString(1, bookNum);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                bookDTO = new BookDTO();
                bookDTO.setBookNum(rs.getString("book_num"));
                bookDTO.setBookTime(rs.getString("book_time"));
                bookDTO.setBookState(rs.getString("book_state"));
                bookDTO.setTotalBookNum(rs.getInt("total_book"));
                bookDTO.setScreenCode(rs.getString("screen_code"));
                bookDTO.setUsersId(rs.getString("users_id"));
                
                // 추가 정보도 DTO에 담기 (BookDTO에 필드 추가 필요)
                // bookDTO.setMovieName(rs.getString("movie_name"));
                // bookDTO.setCinemaName(rs.getString("cinema_name"));
                // ...
            }
            
        } finally {
            dbCon.dbClose(rs, pstmt, con);
        }
        
        return bookDTO;
    }//selectBookingDetail
    
    // ========================================
    // 6. 예약한 좌석 목록 조회 (필수 추가)
    // ========================================
    public List<SeatBookDTO> selectSeatListByBookNum(String bookNum) throws SQLException {
        List<SeatBookDTO> seatList = new ArrayList<>();
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = dbCon.getConn();
            
            StringBuilder selectSql = new StringBuilder();
            selectSql
            .append("   SELECT                                      ")
            .append("       sb.seat_book_code,                      ")
            .append("       sb.seat_code,                           ")
            .append("       s.seat_row,                             ")
            .append("       s.seat_col,                             ")
            .append("       sb.discount_code,                       ")
            .append("       d.discount_rate                         ")
            .append("   FROM SEAT_BOOK sb                           ")
            .append("   INNER JOIN SEAT s ON sb.seat_code = s.seat_code ")
            .append("   LEFT JOIN DISCOUNT d ON sb.discount_code = d.discount_code ")
            .append("   WHERE sb.book_num = ?                       ")
            .append("   ORDER BY s.seat_row, s.seat_col             ");
            
            pstmt = con.prepareStatement(selectSql.toString());
            pstmt.setString(1, bookNum);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                SeatBookDTO seatDTO = new SeatBookDTO();
                seatDTO.setSeatBookCode(rs.getString("seat_book_code"));
                seatDTO.setSeatCode(rs.getString("seat_code"));
                seatDTO.setSeatRow(rs.getString("seat_row"));
                seatDTO.setSeatCol(rs.getString("seat_col"));
                seatDTO.setDiscountCode(rs.getString("discount_code"));
                
                seatList.add(seatDTO);
            }
            
        } finally {
            dbCon.dbClose(rs, pstmt, con);
        }
        
        return seatList;
    }
    
 // ========================================
    // 7. 사용자별 예약 목록 조회 (필수 추가)
    // ========================================
    public List<BookDTO> selectBookingListByUser(String userId) throws SQLException {
        List<BookDTO> bookList = new ArrayList<>();
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = dbCon.getConn();
            
            StringBuilder selectSql = new StringBuilder();
            selectSql
            .append("   SELECT                                      ")
            .append("       b.book_num,                             ")
            .append("       b.book_time,                            ")
            .append("       b.book_state,                           ")
            .append("       b.total_book,                           ")
            .append("       m.movie_name,                           ")
            .append("       si.screen_date,                         ")
            .append("       ci.cinema_name,                         ")
            .append("       ti.theather_name                        ")
            .append("   FROM BOOK b                                 ")
            .append("   INNER JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
            .append("   INNER JOIN MOVIE m ON si.movie_code = m.movie_code ")
            .append("   INNER JOIN THEATHER_INFO ti ON si.theather_num = ti.theather_num ")
            .append("   INNER JOIN CINEMA_INFO ci ON ti.cinema_num = ci.cinema_num ")
            .append("   WHERE b.users_id = ?                        ")
            .append("   ORDER BY b.book_time DESC                   ");
            
            pstmt = con.prepareStatement(selectSql.toString());
            pstmt.setString(1, userId);
            
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                BookDTO bookDTO = new BookDTO();
                bookDTO.setBookNum(rs.getString("book_num"));
                bookDTO.setBookTime(rs.getString("book_time"));
                bookDTO.setBookState(rs.getString("book_state"));
                bookDTO.setTotalBookNum(rs.getInt("total_book"));
                
                bookList.add(bookDTO);
            }
            
        } finally {
            dbCon.dbClose(rs, pstmt, con);
        }
        
        return bookList;
    }
    
    
}// class
