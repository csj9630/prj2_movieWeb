package movie.trailer;

import java.sql.SQLException;
import java.util.List;

public class TrailerService {
	//------싱글톤 패턴------------------------
	private static TrailerService ts;
	
	private TrailerService() {
	}//DetailService
	
	public static TrailerService getInstance() {
		if(ts == null) {
			ts = new TrailerService();
		}//end if 
		return ts;
	}//getInstance
	//--------------------------싱글톤 패턴----
	
	/**
	 *  영화 코드를 입력 받아서 해당되는 모든 트레일러를 DTOList로 리턴한다.
	 * 
	 * @param code 영화코드
	 * @return
	 */
	public List<TrailerDTO> searchTrailerList(String code) {
		List<TrailerDTO> list = null;
		TrailerDAO tDAO = TrailerDAO.getInstance();
		try {
			list = tDAO.selectTrailer(code);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		
		return list;
	}//searchMovieDetail
}//class
