package movie.detail;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import DBConnection.DbConn;

public class DetailDAO {
	// ------싱글톤 패턴------------------------
	private static DetailDAO dtDAO;

	private DetailDAO() {
	}// DetailService

	public static DetailDAO getInstance() {
		if (dtDAO == null) {
			dtDAO = new DetailDAO();
		} // end if
		return dtDAO;
	}// getInstance
		// --------------------------싱글톤 패턴----

	/**
	 * 영화 코드를 입력 받아서 영화 Detail DTO를 리턴한다.
	 * 
	 * @param code
	 * @return
	 * @throws SQLException
	 */
	public DetailDTO selectDetail(String code) throws SQLException {
		DetailDTO dtDTO = null;

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
			StringBuilder selectDetail = new StringBuilder();

			selectDetail
					.append("	select	")
					.append("	movie_code, movie_name, movie_genre, running_time, movie_grade,		")
					.append("	release_date, intro, main_image, bg_image, daily_audience,	")
					.append("	total_audience, movie_delete, showing	")
					.append("	from movie	")
					.append("	where movie_code=?	");
			

			pstmt = con.prepareStatement(selectDetail.toString());
			// 5.바인드 변수 값 설정
			pstmt.setString(1, code);

			// 6.쿼리문 수행 후 결과 얻기
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dtDTO = new DetailDTO();
				dtDTO.setCode(rs.getString("movie_code"));
				dtDTO.setName(rs.getString("movie_name"));
				dtDTO.setGenre(rs.getString("movie_genre"));
				dtDTO.setRunningTime(rs.getInt("running_time"));
				dtDTO.setGrade(rs.getString("movie_grade"));
//				dtDTO.setReleaseDate(rs.getDate("release_date"));
				dtDTO.setReleaseDate(rs.getString("release_date"));
				dtDTO.setIntro(rs.getString("intro"));
				dtDTO.setMainImg(rs.getString("main_image"));
				dtDTO.setBgImg(rs.getString("bg_image"));
				dtDTO.setDailyAudience(rs.getInt("daily_audience"));
				dtDTO.setTotalAudience(rs.getInt("total_audience"));
				dtDTO.setDeleteFlag(rs.getString("movie_delete"));
				dtDTO.setShowingFlag(rs.getString("showing"));
			} // end if

		} finally {
			// 7.연결 끊기
			dbCon.dbClose(rs, pstmt, con);
		} // end finally

		return dtDTO;
	}// selectId
	
	
	/**
	 * 조회수를 업데이트
	 * 
	 * @param pDTO
	 * @throws SQLException
	 */
	public int upDateAudience(int da,int ta,String code) throws SQLException {
		int cnt = 0;
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		Connection con = null;
		PreparedStatement pstmt = null;

		try {

			// 1.JNDI 사용객체 생성
			// 2.DataSource 얻기
			// 3.DataSource에서 Connection 얻기
			con = db.getConn();

			// 4.쿼리문 생성객체 얻기
			StringBuilder upDateMember = new StringBuilder();
			
			upDateMember
				.append(" update movie ")
				.append(" set daily_audience=?, total_audience=? ")
				.append(" where movie_code=? ");
			pstmt = con.prepareStatement(upDateMember.toString());

			// 5.바인드 변수 값 설정
			pstmt.setInt(1, da);
			pstmt.setInt(2, ta);
			pstmt.setString(3, code);

			// 6.쿼리문 수행 후 결과 얻기
			cnt = pstmt.executeUpdate();
		} finally {
			// 7.연결 끊기
			db.dbClose(null, pstmt, con);
		} // end finally
		return cnt;
	}// insertMember

}// class
