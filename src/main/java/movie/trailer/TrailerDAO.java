package movie.trailer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import DBConnection.DbConn;

public class TrailerDAO {
	// ------싱글톤 패턴------------------------
		private static TrailerDAO trDAO;

		private TrailerDAO() {
		}// DetailService

		public static TrailerDAO getInstance() {
			if (trDAO == null) {
				trDAO = new TrailerDAO();
			} // end if
			return trDAO;
		}// getInstance
	// --------------------------싱글톤 패턴----
		/**
		 * 영화 코드를 입력 받아서 해당되는 모든 트레일러를 DTOList로 리턴한다.
		 * 
		 * @param code : 영화코드
		 * @return
		 * @throws SQLException
		 */
		public List<TrailerDTO> selectTrailer(String code) throws SQLException {
			List<TrailerDTO> list = new ArrayList<TrailerDTO>();
			
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
				StringBuilder selectTrailer = new StringBuilder();

				selectTrailer
						.append("	select	")
						.append("	trailer_code, url_path, movie_code		")
						.append("	from TRAILER	")
						.append("	where movie_code=?	");
				

				pstmt = con.prepareStatement(selectTrailer.toString());
				// 5.바인드 변수 값 설정
				pstmt.setString(1, code);

				// 6.쿼리문 수행 후 결과 얻기
				rs = pstmt.executeQuery();
				
				TrailerDTO trDTO = null;
				while (rs.next()) {
					trDTO = new TrailerDTO();
					trDTO.setTrailer_code(rs.getString("trailer_code"));
					trDTO.setUrl_path(rs.getString("url_path"));
					trDTO.setMovie_code(rs.getString("movie_code"));
					list.add(trDTO);
				} // end while

			} finally {
				// 7.연결 끊기
				dbCon.dbClose(rs, pstmt, con);
			} // end finally

			return list;
		}// selectImage
	
	
}//class
