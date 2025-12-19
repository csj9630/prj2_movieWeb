package moviestory.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import moviestory.dto.MovieTimelineDTO;
import moviestory.util.DbConn;

public class MovieTimelineDAO {
	
	private static MovieTimelineDAO mtDAO;
	
	private MovieTimelineDAO() {
	}
	
	public static MovieTimelineDAO getInstance() {
		if(mtDAO == null) {
			mtDAO = new MovieTimelineDAO();
		}
		return mtDAO;
	}
	
	/**
	 * 사용자의 예매 내역을 기반으로 타임라인 목록 조회
	 * BOOK(예매), SCREEN_INFO(상영정보), MOVIE(영화), THEATHER_INFO(상영관) 조인 필요
	 * (Note: SCREEN_INFO에 theater info가 있는지, 별도 테이블인지 확인 필요하나 
	 *  MovieTimelineDTO에 theather_name이 있으므로 우선 SCREEN_INFO나 THEATER_INFO 조인 가정)
	 *  
	 *  Query logic based on presumed schema:
	 *  SELECT m.movie_name, m.main_image, m.release_date, 
	 *         s.screen_date, t.theather_name, b.users_id
	 *  FROM BOOK b
	 *  JOIN SCREEN_INFO s ON b.screen_code = s.screen_code
	 *  JOIN MOVIE m ON s.movie_code = m.movie_code
	 *  JOIN THEATHER_INFO t ON s.theather_code = t.theather_code
	 *  WHERE b.users_id = ?
	 *  ORDER BY s.screen_date DESC
	 */
	public List<MovieTimelineDTO> selectTimelineList(String userId) throws SQLException {
		List<MovieTimelineDTO> list = new ArrayList<MovieTimelineDTO>();
		
		DbConn db = DbConn.getInstance("jdbc/dbcp");
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			con = db.getConn();
			
			// Theater join might need adjustment based on exact schema. 
			// Assuming standard join path: Book -> Screen -> (Movie, Theater)
			StringBuilder sql = new StringBuilder();
			sql.append("SELECT m.movie_name, m.main_image, m.release_date, ")
			   .append("       s.screen_date, t.theather_name, b.users_id, m.movie_code ")
			   .append("FROM BOOK b ")
			   .append("JOIN SCREEN_INFO s ON b.screen_code = s.screen_code ")
			   .append("JOIN THEATHER_INFO t ON s.theather_num = t.theather_num ")
			   .append("JOIN MOVIE m ON s.movie_code = m.movie_code ")
			   .append("WHERE b.users_id = ? ")
			   .append("ORDER BY s.screen_date DESC");
			
			pstmt = con.prepareStatement(sql.toString());
			pstmt.setString(1, userId);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				MovieTimelineDTO dto = new MovieTimelineDTO();
				dto.setMovie_name(rs.getString("movie_name"));
				dto.setMain_image(rs.getString("main_image"));
				dto.setRelease_date(rs.getString("release_date"));
				dto.setScreen_date(rs.getDate("screen_date"));
				dto.setTheather_name(rs.getString("theather_name"));
				dto.setUsers_id(rs.getString("users_id"));
				dto.setMovie_code(rs.getString("movie_code"));
				
				list.add(dto);
			}
			
		} finally {
			db.dbClose(rs, pstmt, con);
		}
		
		return list;
	}

}
