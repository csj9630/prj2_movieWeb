package movie.review;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

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
							.append(" WHERE SI.movie_code = ? ");
			
			//@formatter:on

			pstmt = con.prepareStatement(selectReview.toString());
			// 5.바인드 변수 값 설정
			pstmt.setString(1, mvCode);

			// 6.쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			//review_num,review_content,review_score,review_date,book_num,users_id

			ReviewDTO rdto = null;
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
			
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

}// class
