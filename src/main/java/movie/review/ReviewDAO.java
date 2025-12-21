package movie.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;
import moviestory.dto.MovieReviewDTO;

public class ReviewDAO {
	// ------싱글톤 패턴------------------------
	private static ReviewDAO rDAO;

	private ReviewDAO() {
	}// DetailService

	public static ReviewDAO getInstance() {
		if (rDAO == null) {
			rDAO = new ReviewDAO();
		} // end if
		return rDAO;
	}// getInstance
		// --------------------------싱글톤 패턴----

	/**
	 * 영화 코드를 입력 받아서 해당되는 모든 리뷰를 DTOList로 리턴한다.
	 * 
	 * @param code : 영화코드
	 * @return
	 * @throws SQLException
	 */
	public List<ReviewDTO> selectReviewList(String mvCode) throws SQLException {
		List<ReviewDTO> list = new ArrayList<ReviewDTO>();

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
			StringBuilder selectReview = new StringBuilder();

			//@formatter:off
					selectReview
							.append(" SELECT  R.review_num,R.review_content, R.review_score, R.review_date, R.book_num, R.users_id ")
							.append(" FROM REVIEW R ")
							.append(" JOIN BOOK B ON R.book_num = B.book_num ")
							.append(" JOIN SCREEN_INFO SI ON B.screen_code = SI.screen_code ")
							.append(" WHERE SI.movie_code = ? ")
							.append(" order by review_date desc ");
			
			//@formatter:on
			//System.out.println(selectReview);
			pstmt = con.prepareStatement(selectReview.toString());
			// 5.바인드 변수 값 설정
			pstmt.setString(1, mvCode);

			// 6.쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			// review_num,review_content,review_score,review_date,book_num,users_id

			ReviewDTO rdto = null;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

			while (rs.next()) {
				rdto = new ReviewDTO();
				rdto.setRvCode(rs.getString("review_num"));
				rdto.setContent(rs.getString("review_content"));
				rdto.setScore(rs.getInt("review_score"));
				rdto.setDate(rs.getDate("review_date"));
				rdto.setBook_code(rs.getString("book_num"));
				rdto.setUsers_id(rs.getString("users_id"));
				rdto.setDateStr(sdf.format(rs.getDate("review_date")));
				list.add(rdto);
			} // end while

		} finally {
			// 7.연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return list;
	}// selectReviewList

	// ========== [리뷰 등록] ==========
	/**
	 * 새 리뷰 등록
	 * 
	 * @param dto 리뷰 정보 (review_num, review_content, review_score, book_num,
	 *            users_id)
	 * @return 등록 성공 여부
	 */
	public boolean insertReview(ReviewDTO dto) throws SQLException {
		boolean result = false;
		System.out.println("dao : " +dto);
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");

		Connection con = null;
		PreparedStatement pstmt = null;

		try {
			con = dbCon.getConn();

			// review_num은 외부에서 생성해서 전달 (예: rn + 시퀀스)
			StringBuilder sql = new StringBuilder();
			sql.append("INSERT INTO REVIEW (review_num, review_content, review_score, ")
					.append("                    review_date, book_num, users_id) ")
					.append("VALUES ('rn' || LPAD(review_seq.NEXTVAL, 3, '0'), ?, ?, SYSDATE, ?, ?)");

			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, dto.getContent());
			pstmt.setInt(2, dto.getScore());
			pstmt.setString(3, dto.getBook_code());
			pstmt.setString(4, dto.getUsers_id());

			int cnt = pstmt.executeUpdate();
			System.out.println("dao : " + cnt);
			result = (cnt > 0);

		} finally {
			dbCon.dbClose(null, pstmt, con);
		}

		return result;
	}

	   /**
     * 
     * 댓글 작성 전 영화 시청했는지 체크.
     * @param userId
     * @return 영화 본적없으면 empty, 있으면 book_num
     */
	public String selectBookForReview(String movieCode, String userId) throws SQLException {
	    String result = "";
	    DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
	    ResultSet rs = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    

	    try {
	        con = dbCon.getConn();

	        StringBuilder sql = new StringBuilder();
	        // 각 append 마지막에 공백(" ")을 추가하여 단어가 붙지 않게 합니다.
	        sql.append("SELECT B.book_num ")
	           .append("FROM BOOK B ")
	           .append("INNER JOIN SCREEN_INFO S ON B.screen_code = S.screen_code ")
	           .append("WHERE S.movie_code = ? AND B.users_id = ? ");
	        
	        pstmt = con.prepareStatement(sql.toString());
	        pstmt.setString(1, movieCode); 
	        pstmt.setString(2, userId);

	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            result = rs.getString("book_num");
	            // 값이 하나만 필요하므로 찾자마자 break 역할
	        }

	        //System.out.println("조회된 book_num: " + result);

	    } catch (SQLException e) {
	        e.printStackTrace(); // 에러 발생 시 로그 확인용
	        throw e;
	    } finally {
	        // rs를 포함하여 모든 리소스를 안전하게 닫습니다.
	        dbCon.dbClose(rs, pstmt, con);
	    }

	    return result;
	}

}// class
