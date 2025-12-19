package movie.booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import DBConnection.DbConn;

public class ScheduleDAO {
	
	private static ScheduleDAO sbDAO;
	
	private ScheduleDAO() {
		
	} // ScreenInfoDAO
	
	public static ScheduleDAO getInstance() {
		if(sbDAO == null) {
			sbDAO = new ScheduleDAO();
		} // end if
		return sbDAO;
	} // getInstance
	
	
	/**
	 * 승준 : 날짜와 영화코드를 받아 상영 스케줄 리스트를 반환
	 * 위에 코드 그대로 복사해서 매개변수만 바꿔서 오버로
	 * @param movieCode 영화 코드
	 * @param date 날짜
	 * @return
	 * @throws SQLException
	 */
	public List<ScheduleDTO> selectScreenBookList(String date,String movieCode) throws SQLException {
		List<ScheduleDTO> list = new ArrayList<>();
	    
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
					" select	s.screen_code, m.movie_grade, m.movie_code, m.movie_name, m.running_time, " +
					" t.theather_name, s.screen_open,s.screen_end, s.screen_date,  t.total_seat," +
					" (select count(*) from seat_book b where b.screen_code = s.screen_code) as seat_count " +
					" from	screen_info s " +
					" join	movie m on s.movie_code = m.movie_code " +
					" join	theather_info t on s.theather_num = t.theather_num " +
					" where	s.screen_date = to_date(?, 'yyyy-mm-dd') " +
					"  and m.movie_code = ?  " +
					" order by s.screen_open asc";
			
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, date); // Service에서 이미 변환된 날짜(yyyy-MM-dd)를 받음
			pstmt.setString(2, movieCode); // 영화코드
			rs = pstmt.executeQuery();
			
			ScheduleDTO sbDTO = null;
			while (rs.next()) {
			sbDTO = new ScheduleDTO();
			// 1. screen_info 테이블 데이터
            sbDTO.setScreenCode(rs.getString("screen_code"));
            sbDTO.setScreenOpen(rs.getTimestamp("screen_open")); // 시간까지 포함
            sbDTO.setScreenEnd(rs.getTimestamp("screen_end"));   // 시간까지 포함
            sbDTO.setScreenDate(rs.getString("screen_date"));
            
            // 2. movie 테이블 데이터
            sbDTO.setMovieCode(rs.getString("movie_code"));
            sbDTO.setMovieGrade(rs.getString("movie_grade"));
            sbDTO.setMovieName(rs.getString("movie_name"));
            sbDTO.setRunningTime(rs.getInt("running_time"));
            
            // 3. theather_info 테이블 데이터
            sbDTO.setTheatherName(rs.getString("theather_name"));
            sbDTO.setTotalSeat(rs.getInt("total_seat"));
            
            // 4. 서브쿼리 결과 (예약된 좌석 수)
            sbDTO.setSeatCount(rs.getInt("seat_count"));
            
            // 리스트에 추가
            list.add(sbDTO);
				
			} // end while
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbCon.dbClose(rs, pstmt, con);
		} // end try ~ catch ~ finally
		return list;
	} // selectScreenList
		
} // class
