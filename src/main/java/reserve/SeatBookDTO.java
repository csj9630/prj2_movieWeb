package reserve;

public class SeatBookDTO {

	private String seatBookCode; // 좌석 예매 코드
	private String seatCode; // 좌석 코드
	private String screenCode; // 상영 코드
	private String bookNum; // 예매 번호
	private String discountCode; // 할인 코드

	// 조인용 추가 필드 (SEAT 테이블)
	private String seatRow; // 좌석 행
	private String seatCol; // 좌석 열

	// 기본 생성자
	public SeatBookDTO() {}

	// 생성자 (INSERT용)
	public SeatBookDTO(String seatBookCode, String seatCode, String screenCode, 
	                       String bookNum, String discountCode) {
	        this.seatBookCode = seatBookCode;
	        this.seatCode = seatCode;
	        this.screenCode = screenCode;
	        this.bookNum = bookNum;
	        this.discountCode = discountCode;
	    }

	// Getters and Setters
	public String getSeatBookCode() {
		return seatBookCode;
	}

	public void setSeatBookCode(String seatBookCode) {
		this.seatBookCode = seatBookCode;
	}

	public String getSeatCode() {
		return seatCode;
	}

	public void setSeatCode(String seatCode) {
		this.seatCode = seatCode;
	}

	public String getScreenCode() {
		return screenCode;
	}

	public void setScreenCode(String screenCode) {
		this.screenCode = screenCode;
	}

	public String getBookNum() {
		return bookNum;
	}

	public void setBookNum(String bookNum) {
		this.bookNum = bookNum;
	}

	public String getDiscountCode() {
		return discountCode;
	}

	public void setDiscountCode(String discountCode) {
		this.discountCode = discountCode;
	}

	public String getSeatRow() {
		return seatRow;
	}

	public void setSeatRow(String seatRow) {
		this.seatRow = seatRow;
	}

	public String getSeatCol() {
		return seatCol;
	}

	public void setSeatCol(String seatCol) {
		this.seatCol = seatCol;
	}

	@Override
	public String toString() {
		return "SeatBookDTO [seatBookCode=" + seatBookCode + ", seatCode=" + seatCode + ", bookNum=" + bookNum
				+ ", seatRow=" + seatRow + ", seatCol=" + seatCol + "]";
	}

}
