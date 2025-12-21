package movie.reservation_admin;

public class ReservationDTO {
	private String bookNum;       // 예매 번호 (PK)
	private String userId;        // 회원 ID
	private String userName;      // 회원 이름
	private String movieName;     // 영화 제목
	private String theaterName;   // 상영관 이름 (1관, 2관...)
	private String screenDate;    // 상영 날짜 (YYYY-MM-DD)
	private String screenTime;    // 상영 시간 (HH:mm)
	private int seatCount;        // 예매 인원 수
	private String seats;         // 좌석 번호 목록 (A1, A2...) - 상세 조회용
	private int price;            // 결제 금액
	private String bookState;     // 예매 상태 (T:완료, F:취소)
	private String paymentState;  // 결제 상태
	private String bookDate;      // 예매한 날짜 (YYYY-MM-DD)
	
	public ReservationDTO() {}

	public ReservationDTO(String bookNum, String userId, String userName, String movieName, String theaterName,
			String screenDate, String screenTime, int seatCount, String seats, int price, String bookState,
			String paymentState, String bookDate) {
		super();
		this.bookNum = bookNum;
		this.userId = userId;
		this.userName = userName;
		this.movieName = movieName;
		this.theaterName = theaterName;
		this.screenDate = screenDate;
		this.screenTime = screenTime;
		this.seatCount = seatCount;
		this.seats = seats;
		this.price = price;
		this.bookState = bookState;
		this.paymentState = paymentState;
		this.bookDate = bookDate;
	}

	public String getBookNum() {
		return bookNum;
	}

	public void setBookNum(String bookNum) {
		this.bookNum = bookNum;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getMovieName() {
		return movieName;
	}

	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}

	public String getTheaterName() {
		return theaterName;
	}

	public void setTheaterName(String theaterName) {
		this.theaterName = theaterName;
	}

	public String getScreenDate() {
		return screenDate;
	}

	public void setScreenDate(String screenDate) {
		this.screenDate = screenDate;
	}

	public String getScreenTime() {
		return screenTime;
	}

	public void setScreenTime(String screenTime) {
		this.screenTime = screenTime;
	}

	public int getSeatCount() {
		return seatCount;
	}

	public void setSeatCount(int seatCount) {
		this.seatCount = seatCount;
	}

	public String getSeats() {
		return seats;
	}

	public void setSeats(String seats) {
		this.seats = seats;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

	public String getBookState() {
		return bookState;
	}

	public void setBookState(String bookState) {
		this.bookState = bookState;
	}

	public String getPaymentState() {
		return paymentState;
	}

	public void setPaymentState(String paymentState) {
		this.paymentState = paymentState;
	}

	public String getBookDate() {
		return bookDate;
	}

	public void setBookDate(String bookDate) {
		this.bookDate = bookDate;
	}

	@Override
	public String toString() {
		return "ReservationDTO [bookNum=" + bookNum + ", userId=" + userId + ", userName=" + userName + ", movieName="
				+ movieName + ", theaterName=" + theaterName + ", screenDate=" + screenDate + ", screenTime="
				+ screenTime + ", seatCount=" + seatCount + ", seats=" + seats + ", price=" + price + ", bookState="
				+ bookState + ", paymentState=" + paymentState + ", bookDate=" + bookDate + "]";
	}

	
}