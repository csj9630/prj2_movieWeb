package reserve;

import java.sql.SQLException;

public class ReserveService {
	private static ReserveService sbs;

	private ReserveService() {

	} // ScreenInfoService

	public static ReserveService getInstance() {
		if (sbs == null) {
			sbs = new ReserveService();
		} // end if
		return sbs;
	} // getInstance

	/**
	 * 단일 좌석이 예약 가능한지 체크.
	 * @param screenCode 상영코드
	 * @param seatCode 좌석코드
	 * @return 예약 가능하면 참
	 */
	public boolean checkSeatStatus(String screenCode, String seatCode) {
		boolean flag = false;

		ReserveDAO bsDAO = ReserveDAO.getInstance();

		try {
			bsDAO.selectSeatStatus(screenCode, seatCode);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return flag;

	}// checkSeatStatus

}// class
