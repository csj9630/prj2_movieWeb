package movie.booking;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ScheduleService {
	
	private static ScheduleService sis;
	
	private ScheduleService() {
		
	} // ScreenInfoService
	
	public static ScheduleService getInstance() {
		if(sis == null) {
			sis = new ScheduleService();
		} // end if
		return sis;
	} // getInstance
	

	/**
	 *  JSP에서 호출할 메서드
	 * 승준 : 날짜와 영화코드를 받아 상영 스케줄 리스트를 반환
	 * 위에 코드 그대로 복사해서 매개변수만 바꿔서 오버로
	 * @param selectedDate 날짜
	 * @param selectedMovieCode 영화 코드
	 * @return
	 */
	public List<ScheduleDTO> getMovieSchedule(String selectedDate, String selectedMovieCode) {
		
		List<ScheduleDTO> list = null;
		
		
		ScheduleDAO siDAO = ScheduleDAO.getInstance();
		String sqlDate = selectedDate.replace('.', '-');
		
		// 2. DAO를 통해 원본 데이터 가져오기
		try {
			list = siDAO.selectScreenBookList(sqlDate, selectedMovieCode);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end try ~ catch
		

		return list;
	} // getMovieSchedule
	
}
