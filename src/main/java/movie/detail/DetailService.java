package movie.detail;

import java.sql.SQLException;

public class DetailService {
	// ------싱글톤 패턴------------------------
	private static DetailService ds;

	private DetailService() {
	}// DetailService

	public static DetailService getInstance() {
		if (ds == null) {
			ds = new DetailService();
		} // end if
		return ds;
	}// getInstance
		// --------------------------싱글톤 패턴----

	public DetailDTO searchMovieDetail(String code) {
		DetailDTO dtDTO = null;

		DetailDAO dtDAO = DetailDAO.getInstance();
		try {
			dtDTO = dtDAO.selectDetail(code);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return dtDTO;
	}// searchMovieDetail

	/**
	 * 영화 하나에 대한 일일 관객수와 누적 관객수를 수정한다.
	 * 
	 * @param dailyD 일일 관객수
	 * @param totalD 누적 관객수
	 * @param mvcode 영화 코드
	 * @return 성공/실패
	 */
	public boolean modifyAudience(int dailyD, int totalD, String mvcode) {
		boolean flag = false;

		DetailDAO dtDAO = DetailDAO.getInstance();

		try {
			flag = dtDAO.upDateAudience(dailyD, totalD, mvcode) == 1;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} // end catch

		return flag;
	}// addMember
}// class
