package moviestory.service;

import java.sql.SQLException;
import java.util.Collections;
import java.util.List;

import moviestory.dao.MovieTimelineDAO;
import moviestory.dto.MovieTimelineDTO;

/**
 * MovieTimelineService -> MovieStoryService로 변경 (캐시 문제 해결 시도)
 */
public class MovieStoryService {
	
	private static MovieStoryService service;
	
	private MovieStoryService() {
	}
	
	public static MovieStoryService getInstance() {
		if(service == null) {
			service = new MovieStoryService();
		}
		return service;
	}
	
	public List<MovieTimelineDTO> getTimelineList(String userId) {
		List<MovieTimelineDTO> list = null;
		try {
			list = MovieTimelineDAO.getInstance().selectTimelineList(userId);
		} catch (SQLException e) {
			e.printStackTrace();
			list = Collections.emptyList(); 
		}
		return list;
	}

}
