package moviestory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import moviestory.dto.MovieReviewDTO;
import moviestory.util.DbConn;

/**
 * 리뷰 DAO
 * REVIEW 테이블에 대한 CRUD 기능 담당
 */
public class MovieReviewDAO {
    
    // 싱글톤 인스턴스
    private static MovieReviewDAO mrDAO;
    
    // 생성자 - private
    private MovieReviewDAO() {
    }
    
    /**
     * 싱글톤 인스턴스 반환
     */
    public static MovieReviewDAO getInstance() {
        if (mrDAO == null) {
            mrDAO = new MovieReviewDAO();
        }
        return mrDAO;
    }

    // ========== [사용자별 리뷰 목록 조회] ==========
    /**
     * 특정 사용자의 모든 리뷰 목록 조회
     * REVIEW + BOOK + SCREEN_INFO + MOVIE 테이블 JOIN
     * @param users_id 사용자 아이디
     * @return 리뷰 목록
     */
    public List<MovieReviewDTO> selectReviewList(String users_id) throws SQLException {
        List<MovieReviewDTO> list = new ArrayList<MovieReviewDTO>();
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            con = dbCon.getConn();
            
            // REVIEW + BOOK + SCREEN_INFO + MOVIE JOIN 쿼리
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT r.review_num, r.review_content, r.review_score, ")
               .append("       r.review_date, r.book_num, r.users_id, ")
               .append("       m.movie_code, m.movie_name, m.main_image ")
               .append("FROM REVIEW r ")
               .append("JOIN BOOK b ON r.book_num = b.book_num ")
               .append("JOIN SCREEN_INFO s ON b.screen_code = s.screen_code ")
               .append("JOIN MOVIE m ON s.movie_code = m.movie_code ")
               .append("WHERE r.users_id = ? ")
               .append("ORDER BY r.review_date DESC");
            
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, users_id);
            
            rs = pstmt.executeQuery();
            
            MovieReviewDTO dto = null;
            while (rs.next()) {
                dto = new MovieReviewDTO();
                dto.setReview_num(rs.getString("review_num"));
                dto.setReview_content(rs.getString("review_content"));
                dto.setReview_score(rs.getInt("review_score"));
                dto.setReview_date(rs.getDate("review_date"));
                dto.setBook_num(rs.getString("book_num"));
                dto.setUsers_id(rs.getString("users_id"));
                dto.setMovie_code(rs.getString("movie_code"));
                dto.setMovie_name(rs.getString("movie_name"));
                dto.setMain_image(rs.getString("main_image"));
                list.add(dto);
            }
            
        } finally {
            dbCon.dbClose(rs, pstmt, con);
        }
        
        return list;
    }

    // ========== [리뷰 단건 조회] ==========
    /**
     * 리뷰 번호로 단건 조회
     * @param review_num 리뷰 번호
     * @return 리뷰 정보 (없으면 null)
     */
    public MovieReviewDTO selectReview(String review_num) throws SQLException {
        MovieReviewDTO dto = null;
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dbCon.getConn();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT r.review_num, r.review_content, r.review_score, ")
               .append("       r.review_date, r.book_num, r.users_id, ")
               .append("       m.movie_code, m.movie_name, m.main_image ")
               .append("FROM REVIEW r ")
               .append("JOIN BOOK b ON r.book_num = b.book_num ")
               .append("JOIN SCREEN_INFO s ON b.screen_code = s.screen_code ")
               .append("JOIN MOVIE m ON s.movie_code = m.movie_code ")
               .append("WHERE r.review_num = ?");

            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, review_num);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new MovieReviewDTO();
                dto.setReview_num(rs.getString("review_num"));
                dto.setReview_content(rs.getString("review_content"));
                dto.setReview_score(rs.getInt("review_score"));
                dto.setReview_date(rs.getDate("review_date"));
                dto.setBook_num(rs.getString("book_num"));
                dto.setUsers_id(rs.getString("users_id"));
                dto.setMovie_code(rs.getString("movie_code"));
                dto.setMovie_name(rs.getString("movie_name"));
                dto.setMain_image(rs.getString("main_image"));
            }

        } finally {
            dbCon.dbClose(rs, pstmt, con);
        }

        return dto;
    }

    // ========== [리뷰 등록] ==========
    /**
     * 새 리뷰 등록
     * @param dto 리뷰 정보 (review_num, review_content, review_score, book_num, users_id)
     * @return 등록 성공 여부
     */
    public boolean insertReview(MovieReviewDTO dto) throws SQLException {
        boolean result = false;
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = dbCon.getConn();
            
            // review_num은 외부에서 생성해서 전달 (예: rn + 시퀀스)
            StringBuilder sql = new StringBuilder();
            sql.append("INSERT INTO REVIEW (review_num, review_content, review_score, ")
               .append("                    review_date, book_num, users_id) ")
               .append("VALUES (?, ?, ?, SYSDATE, ?, ?)");
            
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, dto.getReview_num());
            pstmt.setString(2, dto.getReview_content());
            pstmt.setInt(3, dto.getReview_score());
            pstmt.setString(4, dto.getBook_num());
            pstmt.setString(5, dto.getUsers_id());
            
            int cnt = pstmt.executeUpdate();
            result = (cnt > 0);
            
        } finally {
            dbCon.dbClose(null, pstmt, con);
        }
        
        return result;
    }

    // ========== [리뷰 수정] ==========
    /**
     * 리뷰 내용 및 점수 수정
     * 본인 확인을 위해 users_id도 조건에 포함
     * @param dto 리뷰 정보 (review_num, review_content, review_score, users_id)
     * @return 수정 성공 여부
     */
    public boolean updateReview(MovieReviewDTO dto) throws SQLException {
        boolean result = false;
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = dbCon.getConn();
            
            StringBuilder sql = new StringBuilder();
            sql.append("UPDATE REVIEW ")
               .append("SET review_content = ?, review_score = ? ")
               .append("WHERE review_num = ? AND users_id = ?");
            
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, dto.getReview_content());
            pstmt.setInt(2, dto.getReview_score());
            pstmt.setString(3, dto.getReview_num());
            pstmt.setString(4, dto.getUsers_id());
            
            System.out.println("[DEBUG] DAO updateReview Executing...");
            System.out.println("[DEBUG] content len: " + dto.getReview_content().length() + ", score: " + dto.getReview_score());
            System.out.println("[DEBUG] reviewNum: " + dto.getReview_num() + ", userId: " + dto.getUsers_id());
            
            int cnt = pstmt.executeUpdate();
            System.out.println("[DEBUG] DAO updateReview Count: " + cnt);
            result = (cnt > 0);
            
        } finally {
            dbCon.dbClose(null, pstmt, con);
        }
        
        return result;
    }

    // ========== [리뷰 삭제] ==========
    /**
     * 리뷰 삭제
     * 본인 확인을 위해 users_id도 조건에 포함
     * @param review_num 리뷰 번호
     * @param users_id 사용자 아이디
     * @return 삭제 성공 여부
     */
    public boolean deleteReview(String review_num, String users_id) throws SQLException {
        boolean result = false;
        
        DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
        
        Connection con = null;
        PreparedStatement pstmt = null;
        
        try {
            con = dbCon.getConn();
            
            StringBuilder sql = new StringBuilder();
            sql.append("DELETE FROM REVIEW ")
               .append("WHERE review_num = ? AND users_id = ?");
            
            pstmt = con.prepareStatement(sql.toString());
            pstmt.setString(1, review_num);
            pstmt.setString(2, users_id);
            
            System.out.println("[DEBUG] DAO deleteReview Executing...");
            System.out.println("[DEBUG] reviewNum: " + review_num + ", userId: " + users_id);
            
            int cnt = pstmt.executeUpdate();
            System.out.println("[DEBUG] DAO deleteReview Count: " + cnt);
            result = (cnt > 0);
            
        } finally {
            dbCon.dbClose(null, pstmt, con);
        }
        
        return result;
    }
}
