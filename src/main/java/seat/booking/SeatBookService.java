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
	
	//예약 좌석 이름 찾기(예약된 좌석이 열행이름 붙힘 ex) A1, A2, A3...)
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
	
	//사용자가 선택한 좌석의 seat_code 얻기 (몇 상영관의 A1인지.) -> stxxx
	public List<String> getSeatCodes(List<String> seatNames, String theaterNum) {
	    List<String> seatCodesList = null;
	    SeatBookDAO sDAO = SeatBookDAO.getInstance();
	    
	    try {
	        // 좌석 이름이 비어있지 않은 경우에만 DAO 호출
	        if (seatNames != null && !seatNames.isEmpty()) {
	        	seatCodesList = sDAO.selectSeatCodes(seatNames, theaterNum);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return seatCodesList;
	}//getSeatCodes
	
	
	
	//영화 예매 진행하는 메인 메소드
	public String processCompleteBooking(SeatBookDTO sbDTO) {
	    String result = null;
	    SeatBookDAO sDAO = SeatBookDAO.getInstance();
	    
	    try {
	        // 결제 수단 고정 설정
	        // DAO의 트랜잭션 메서드 호출
	        result = sDAO.insertBookingTransaction(sbDTO);
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return result;
	}//processCompleteBooking
	
	//예매 좌석 중복 체크
	public boolean checkSeatAvailability(List<String> seatCodes, String screenCode) {
	    boolean isReserved = true;
	    try {
	        isReserved = SeatBookDAO.getInstance().isSeatAlreadyReserved(seatCodes, screenCode);
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return isReserved; // true면 이미 예약됨, false면 예약 가능
	}
	
}//class
