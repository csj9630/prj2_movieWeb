package screenInfo;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ScreenInfoService {
	
	private static ScreenInfoService sis;
	
	private ScreenInfoService() {
		
	} // ScreenInfoService
	
	public static ScreenInfoService getInstance() {
		if(sis == null) {
			sis = new ScreenInfoService();
		} // end if
		return sis;
	} // getInstance
	
	// JSP에서 호출할 메서드
	public Map<String, Map<String, List<Map<String, String>>>> getMovieSchedule(String selectedDate) {
		
		ScreenInfoDAO siDAO = ScreenInfoDAO.getInstance();
		
		String sqlDate = selectedDate.replace('.', '-');
		
		// 2. DAO를 통해 원본 데이터 가져오기
		List<Map<String, String>> rawList = new ArrayList<>();
		try {
			rawList = siDAO.selectScreenList(sqlDate);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end try ~ catch
		
		// 3. 데이터 그룹화 (기존 JSP에 있던 while문 내부 로직)
		// 구조: Map<영화이름, Map<상영관이름, List<스케줄정보>>>
		Map<String, Map<String, List<Map<String, String>>>> movieScheduleMap = new LinkedHashMap<>();
		
		for (Map<String, String> row : rawList) {
			String movieName = row.get("MOVIE_NAME");
			String theaterName = row.get("THEATHER_NAME");
			
			// 영화별 그룹 생성
			if (!movieScheduleMap.containsKey(movieName)) {
				movieScheduleMap.put(movieName, new LinkedHashMap<>());
			} // end if
			Map<String, List<Map<String, String>>> theaterMap = movieScheduleMap.get(movieName);
			
			// 상영관별 그룹 생성
			if (!theaterMap.containsKey(theaterName)) {
				theaterMap.put(theaterName, new ArrayList<>());
			} // end if
			
			// 스케줄 리스트에 추가
			theaterMap.get(theaterName).add(row);
		} // end for
		
		return movieScheduleMap;
	} // getMovieSchedule
	
}
