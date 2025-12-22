package screenInfo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScreenInfoDAO {
	
	private static ScreenInfoDAO siDAO;
	
	private ScreenInfoDAO() {
		
	} // ScreenInfoDAO
	
	public static ScreenInfoDAO getInstance() {
		if(siDAO == null) {
			siDAO = new ScreenInfoDAO();
		} // end if
		return siDAO;
	} // getInstance
	
	// 날짜를 받아 상영 스케줄 리스트를 반환
	public List<Map<String, String>> selectScreenList(String date) throws SQLException {
	    List<Map<String, String>> list = new ArrayList<>();
	    
		DbConn dbCon = DbConn.getInstance("jdbc/dbcp");
		
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			// 1. JDNI사용 객체 생성
			// 2. DataSource 얻기
			// 3. Connection 얻기
			con = dbCon.getConn();
			// 4. 쿼리문 생성 객체 얻기
			String sql =
					"select	s.screen_code, m.movie_grade, m.movie_code, m.movie_name, m.running_time, " +
					"t.theather_name, s.screen_open, t.total_seat," +
					"(select count(*) from seat_book b where b.screen_code = s.screen_code) as seat_count " +
					"from	screen_info s " +
					"join	movie m on s.movie_code = m.movie_code " +
					"join	theather_info t on s.theather_num = t.theather_num " +
					"where	s.screen_date = to_date(?, 'yyyy-mm-dd') and s.screen_showing = 'Y'" +
					"order by	m.movie_name asc, t.theather_name asc, s.screen_open asc";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, date); // Service에서 이미 변환된 날짜(yyyy-MM-dd)를 받음
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				Map<String, String> row = new HashMap<>();
				row.put("SCREEN_CODE", rs.getString("SCREEN_CODE"));
				row.put("MOVIE_GRADE", rs.getString("MOVIE_GRADE"));
				row.put("MOVIE_CODE", rs.getString("MOVIE_CODE"));
				row.put("MOVIE_NAME", rs.getString("MOVIE_NAME"));
				row.put("RUNNING_TIME", rs.getString("RUNNING_TIME"));
				row.put("THEATHER_NAME", rs.getString("THEATHER_NAME"));
				row.put("SCREEN_OPEN", rs.getString("SCREEN_OPEN"));
				row.put("TOTAL_SEAT", rs.getString("TOTAL_SEAT"));
				row.put("REMAIN_SEAT", String.valueOf(rs.getInt("TOTAL_SEAT") - rs.getInt("SEAT_COUNT")) + "석");
				
				list.add(row);
			} // end while
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end try ~ catch ~ finally
		return list;
	} // selectScreenList
	
} // class
