package movie_mypage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;
import movie_mypage_book.BookDTO;

/**
 * 마이페이지 메인 화면용 DAO
 * - 본 영화수 조회
 * - 관람평수 조회
 * - 최근 예매내역 조회 (일주일/한달 기준)
 */
public class MypageDAO {
    private static MypageDAO mDAO;
    
    private MypageDAO() {
    }
    
    public static MypageDAO getInstance() {
        if(mDAO == null) {
            mDAO = new MypageDAO();
        }
        return mDAO;
    }
    
    /**
     * 본 영화수 조회
     * - 해당 사용자의 완료된 예매(book_state='T') 중 상영일이 오늘 이전인 것을 카운트
     * @param userId 사용자 ID
     * @return 본 영화 수
     */
    public int getWatchedMovieCount(String userId) throws SQLException {
        int count = 0;
        
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = db.getConn();
            
            if(con == null) {
                System.err.println("[ERROR] DB Connection failed in MypageDAO.getWatchedMovieCount");
                return 0;
            }
            
            // 예매 완료(book_state='T')이고, 상영일이 오늘 이전인 예매 건수
            // SCREEN_INFO.screen_date가 DATE 타입이라고 가정
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(*) AS cnt ")
               .append("FROM BOOK b ")
               .append("JOIN SCREEN_INFO s ON b.screen_code = s.screen_code ")
               .append("WHERE b.users_id = ? ")
               .append("AND b.book_state = 'T' ")
               .append("AND s.screen_date < SYSDATE");
            
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, userId);
            
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                count = rs.getInt("cnt");
            }
            
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        
        return count;
    }
    
    /**
     * 관람평 수 조회
     * - 해당 사용자가 작성한 리뷰 수
     * @param userId 사용자 ID
     * @return 관람평 수
     */
    public int getReviewCount(String userId) throws SQLException {
        int count = 0;
        
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = db.getConn();
            
            if(con == null) {
                System.err.println("[ERROR] DB Connection failed in MypageDAO.getReviewCount");
                return 0;
            }
            
            // REVIEW 테이블에서 해당 사용자의 리뷰 수 조회
            String sql = "SELECT COUNT(*) AS cnt FROM REVIEW WHERE users_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                count = rs.getInt("cnt");
            }
            
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        
        return count;
    }
    
    /**
     * 최근 예매내역 조회 (일주일 기준)
     * - 예매일(book_time) 기준 최근 7일 이내 or 한달(30일) 이내
     * - 상영일이 아직 지나지 않은 예매만 표시 (예정된 예매)
     * @param userId 사용자 ID
     * @param days 조회 기간 (7: 일주일, 30: 한달)
     * @return 최근 예매 목록 (최대 5건)
     */
    public List<BookDTO> getRecentBookings(String userId, int days) throws SQLException {
        List<BookDTO> list = new ArrayList<BookDTO>();
        
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = db.getConn();
            
            if(con == null) {
                System.err.println("[ERROR] DB Connection failed in MypageDAO.getRecentBookings");
                return list;
            }
            
            // 예매 완료(book_state='T')이고, 상영일이 아직 오지 않은 최근 예매
            // book_time은 문자열(YY/MM/DD) 형태로 저장되어 있으므로 TO_DATE 사용
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT b.book_num, b.users_id, b.screen_code, b.book_state, ")
               .append("       b.total_book, b.book_time, ")
               .append("       m.movie_name, m.main_image, m.movie_code, ")
               .append("       t.theather_name, s.screen_date, s.screen_price ")
               .append("FROM BOOK b ")
               .append("JOIN SCREEN_INFO s ON b.screen_code = s.screen_code ")
               .append("JOIN MOVIE m ON s.movie_code = m.movie_code ")
               .append("JOIN THEATHER_INFO t ON s.theather_num = t.theather_num ")
               .append("WHERE b.users_id = ? ")
               .append("AND b.book_state = 'T' ")
               // 상영일이 오늘 이후인 예매 (앞으로 볼 영화)
               .append("AND s.screen_date >= TRUNC(SYSDATE) ")
               // 예매일이 최근 N일 이내
               .append("AND TO_DATE(b.book_time, 'YY/MM/DD') >= SYSDATE - ? ")
               .append("ORDER BY s.screen_date ASC ")
               // 최대 3건만 표시
               .append("FETCH FIRST 3 ROWS ONLY");
            
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, userId);
            pstmt.setInt(2, days);
            
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
                dto.setMovie_code(rs.getString("movie_code"));  // 영화 코드 추가
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
    
    /**
     * 사용자 이름 조회
     * @param userId 사용자 ID
     * @return 사용자 이름 (마스킹 처리용)
     */
    public String getUserName(String userId) throws SQLException {
        String userName = "";
        
        DbConn db = DbConn.getInstance("jdbc/dbcp");
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = db.getConn();
            
            if(con == null) {
                System.err.println("[ERROR] DB Connection failed in MypageDAO.getUserName");
                return "";
            }
            
            String sql = "SELECT users_name FROM USERS WHERE users_id = ?";
            
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
                userName = rs.getString("users_name");
            }
            
        } finally {
            db.dbClose(rs, pstmt, con);
        }
        
        return userName;
    }
}
