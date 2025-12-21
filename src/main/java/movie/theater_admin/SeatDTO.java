package movie.theater_admin;

public class SeatDTO {
	private String seatCode;      // 좌석 코드 (PK)
	private String seatRow;       // 행
	private String seatCol;       // 열 (DB가 VARCHAR2이므로 String)
	private String availableSeat; // 예매 가능 여부 (T/F)
	private String theatherNum;   // 상영관 번호 (FK)
	
	public SeatDTO() {
	}

	public SeatDTO(String seatCode, String seatRow, String seatCol, String availableSeat, String theatherNum) {
		super();
		this.seatCode = seatCode;
		this.seatRow = seatRow;
		this.seatCol = seatCol;
		this.availableSeat = availableSeat;
		this.theatherNum = theatherNum;
	}

	public String getSeatCode() {
		return seatCode;
	}

	public void setSeatCode(String seatCode) {
		this.seatCode = seatCode;
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

	public String getAvailableSeat() {
		return availableSeat;
	}

	public void setAvailableSeat(String availableSeat) {
		this.availableSeat = availableSeat;
	}

	public String getTheatherNum() {
		return theatherNum;
	}

	public void setTheatherNum(String theatherNum) {
		this.theatherNum = theatherNum;
	}

	@Override
	public String toString() {
		return "SeatDTO [seatCode=" + seatCode + ", seatRow=" + seatRow + ", seatCol=" + seatCol + ", availableSeat="
				+ availableSeat + ", theatherNum=" + theatherNum + "]";
	}

	
	
}