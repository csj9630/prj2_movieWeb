package movie.review_admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class ReviewDAO {
	private static ReviewDAO rDAO;
	
	private ReviewDAO() {}
	
	public static ReviewDAO getInstance() {
		if(rDAO == null) rDAO = new ReviewDAO();
		return rDAO;
	}
	
	/**
	 * 리뷰 목록 조회 (REVIEW -> BOOK -> SCREEN_INFO -> MOVIE 4단 조인)
	 */
	public List<ReviewDTO> selectReviewList(int startNum, int endNum, String field, String query) throws SQLException {
		List<ReviewDTO> list = new ArrayList<>();
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			
			// 4개 테이블 조인: 리뷰 -> 예매 -> 상영정보 -> 영화
			sql.append(" SELECT review_num, users_id, movie_name, review_content, review_score, review_date, rnum ")
			   .append(" FROM ( ")
			   .append("    SELECT r.review_num, r.users_id, m.movie_name, r.review_content, r.review_score, r.review_date, ")
			   .append("           ROW_NUMBER() OVER(ORDER BY r.review_date DESC) rnum ")
			   .append("    FROM REVIEW r ")
			   .append("    JOIN BOOK b ON r.book_num = b.book_num ")
			   .append("    JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
			   .append("    JOIN MOVIE m ON si.movie_code = m.movie_code ");
			
			// 검색 조건 처리
			if(query != null && !query.isEmpty()) {
				if("movie".equals(field)) {
					sql.append(" WHERE m.movie_name LIKE '%'||?||'%' ");
				} else if("user".equals(field)) {
					sql.append(" WHERE r.users_id LIKE '%'||?||'%' ");
				} else if("content".equals(field)) {
					sql.append(" WHERE r.review_content LIKE '%'||?||'%' ");
				}
			}
			
			sql.append(" ) WHERE rnum BETWEEN ? AND ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			
			int idx = 1;
			if(query != null && !query.isEmpty()) {
				pstmt.setString(idx++, query);
			}
			pstmt.setInt(idx++, startNum);
			pstmt.setInt(idx++, endNum);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				ReviewDTO dto = new ReviewDTO();
				dto.setReviewNum(rs.getString("review_num"));
				dto.setUserId(rs.getString("users_id"));
				dto.setMovieName(rs.getString("movie_name"));
				dto.setReviewContent(rs.getString("review_content"));
				dto.setReviewScore(rs.getInt("review_score"));
				dto.setReviewDate(rs.getDate("review_date"));
				list.add(dto);
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return list;
	}
	
	/**
	 * 총 리뷰 수 조회 (검색 포함)
	 */
	public int selectTotalCount(String field, String query) throws SQLException {
		int count = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			
			sql.append(" SELECT count(*) FROM REVIEW r ")
			   .append(" JOIN BOOK b ON r.book_num = b.book_num ")
			   .append(" JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
			   .append(" JOIN MOVIE m ON si.movie_code = m.movie_code ");
			
			if(query != null && !query.isEmpty()) {
				if("movie".equals(field)) {
					sql.append(" WHERE m.movie_name LIKE '%'||?||'%' ");
				} else if("user".equals(field)) {
					sql.append(" WHERE r.users_id LIKE '%'||?||'%' ");
				} else if("content".equals(field)) {
					sql.append(" WHERE r.review_content LIKE '%'||?||'%' ");
				}
			}
			
			pstmt = con.prepareStatement(sql.toString());
			if(query != null && !query.isEmpty()) {
				pstmt.setString(1, query);
			}
			
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return count;
	}
	
	/**
	 * 리뷰 삭제
	 */
	public int deleteReview(String reviewNum) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		
		try {
			con = db.getConn();
			String sql = "DELETE FROM REVIEW WHERE review_num = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, reviewNum);
			cnt = pstmt.executeUpdate();
		} finally {
			db.dbClose(null, pstmt, con);
		}
		return cnt;
	}
	
	/**
	 * [추가됨] 리뷰 상세 조회 (1건)
	 */
	public ReviewDTO selectReviewDetail(String reviewNum) throws SQLException {
		ReviewDTO dto = null;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			StringBuilder sql = new StringBuilder();
			// 목록 조회와 동일하게 4중 조인하여 영화 제목까지 가져옵니다.
			sql.append(" SELECT r.review_num, r.users_id, m.movie_name, r.review_content, r.review_score, r.review_date ")
			   .append(" FROM REVIEW r ")
			   .append(" JOIN BOOK b ON r.book_num = b.book_num ")
			   .append(" JOIN SCREEN_INFO si ON b.screen_code = si.screen_code ")
			   .append(" JOIN MOVIE m ON si.movie_code = m.movie_code ")
			   .append(" WHERE r.review_num = ? ");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, reviewNum);
			
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new ReviewDTO();
				dto.setReviewNum(rs.getString("review_num"));
				dto.setUserId(rs.getString("users_id"));
				dto.setMovieName(rs.getString("movie_name"));
				dto.setReviewContent(rs.getString("review_content"));
				dto.setReviewScore(rs.getInt("review_score"));
				dto.setReviewDate(rs.getDate("review_date"));
			}
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		return dto;
	}
	
}