package seat.booking;

import java.sql.SQLException;
import java.util.List;


public class SeatBookService {
	private static SeatBookService sbs;

	private SeatBookService() {

	}
	
	public static SeatBookService getInstance() {
		if (sbs == null) {
			sbs = new SeatBookService();
		} // end if
		return sbs;
	}// getInstance
	
	public List<SeatBookDTO> searchRestaurant(String screen_code) {
		List<SeatBookDTO> list = null;
		
		SeatBookDAO sDAO = SeatBookDAO.getInstance();
		try {
			list = sDAO.selectAllSeatBook(screen_code);
		} catch (SQLException e) {
			e.printStackTrace();
		}//end catch
		
		return list;
	}//searchRestaurant
	
	
}//class
