package seat.booking;

import java.util.List;

public class SeatBookDTO {
	//seat_book테이블에 넣을 기본 자료
	private String seat_book_code, seat_code, screen_code, book_num, discount_code, seat_name, bookNum;
	//영화 코드, 상영관 코드, 영화 제목, 유저ID, 좌석 코드, 할인 코드
	private String movieCode, screenCode, movieName, userId;
	//성인, 청소년, 경로 인원, 총 결제 금액
	private int adultCnt, youthCnt, seniorCnt, totalPrice;
	
	private List<String> seatCodes, discountCodes;
	
	public SeatBookDTO() {
		super();
	}

	public SeatBookDTO(String seat_book_code, String seat_code, String screen_code, String book_num,
			String discount_code, String seat_name, String bookNum, String movieCode, String screenCode,
			String movieName, String userId, int adultCnt, int youthCnt, int seniorCnt, int totalPrice,
			List<String> seatCodes, List<String> discountCodes) {
		super();
		this.seat_book_code = seat_book_code;
		this.seat_code = seat_code;
		this.screen_code = screen_code;
		this.book_num = book_num;
		this.discount_code = discount_code;
		this.seat_name = seat_name;
		this.bookNum = bookNum;
		this.movieCode = movieCode;
		this.screenCode = screenCode;
		this.movieName = movieName;
		this.userId = userId;
		this.adultCnt = adultCnt;
		this.youthCnt = youthCnt;
		this.seniorCnt = seniorCnt;
		this.totalPrice = totalPrice;
		this.seatCodes = seatCodes;
		this.discountCodes = discountCodes;
	}

	public String getSeat_book_code() {
		return seat_book_code;
	}

	public void setSeat_book_code(String seat_book_code) {
		this.seat_book_code = seat_book_code;
	}

	public String getSeat_code() {
		return seat_code;
	}

	public void setSeat_code(String seat_code) {
		this.seat_code = seat_code;
	}

	public String getScreen_code() {
		return screen_code;
	}

	public void setScreen_code(String screen_code) {
		this.screen_code = screen_code;
	}

	public String getBook_num() {
		return book_num;
	}

	public void setBook_num(String book_num) {
		this.book_num = book_num;
	}

	public String getDiscount_code() {
		return discount_code;
	}

	public void setDiscount_code(String discount_code) {
		this.discount_code = discount_code;
	}

	public String getSeat_name() {
		return seat_name;
	}

	public void setSeat_name(String seat_name) {
		this.seat_name = seat_name;
	}

	public String getBookNum() {
		return bookNum;
	}

	public void setBookNum(String bookNum) {
		this.bookNum = bookNum;
	}

	public String getMovieCode() {
		return movieCode;
	}

	public void setMovieCode(String movieCode) {
		this.movieCode = movieCode;
	}

	public String getScreenCode() {
		return screenCode;
	}

	public void setScreenCode(String screenCode) {
		this.screenCode = screenCode;
	}

	public String getMovieName() {
		return movieName;
	}

	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getAdultCnt() {
		return adultCnt;
	}

	public void setAdultCnt(int adultCnt) {
		this.adultCnt = adultCnt;
	}

	public int getYouthCnt() {
		return youthCnt;
	}

	public void setYouthCnt(int youthCnt) {
		this.youthCnt = youthCnt;
	}

	public int getSeniorCnt() {
		return seniorCnt;
	}

	public void setSeniorCnt(int seniorCnt) {
		this.seniorCnt = seniorCnt;
	}

	public int getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(int totalPrice) {
		this.totalPrice = totalPrice;
	}

	public List<String> getSeatCodes() {
		return seatCodes;
	}

	public void setSeatCodes(List<String> seatCodes) {
		this.seatCodes = seatCodes;
	}

	public List<String> getDiscountCodes() {
		return discountCodes;
	}

	public void setDiscountCodes(List<String> discountCodes) {
		this.discountCodes = discountCodes;
	}

	@Override
	public String toString() {
		return "SeatBookDTO [seat_book_code=" + seat_book_code + ", seat_code=" + seat_code + ", screen_code="
				+ screen_code + ", book_num=" + book_num + ", discount_code=" + discount_code + ", seat_name="
				+ seat_name + ", bookNum=" + bookNum + ", movieCode=" + movieCode + ", screenCode=" + screenCode
				+ ", movieName=" + movieName + ", userId=" + userId + ", adultCnt=" + adultCnt + ", youthCnt="
				+ youthCnt + ", seniorCnt=" + seniorCnt + ", totalPrice=" + totalPrice + ", seatCodes=" + seatCodes
				+ ", discountCodes=" + discountCodes + "]";
	}



}
