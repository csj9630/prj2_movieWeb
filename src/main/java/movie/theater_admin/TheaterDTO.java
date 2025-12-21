package movie.theater_admin;

public class TheaterDTO {
	private String theatherNum;   // 상영관 번호 (PK)
	private String theatherName;  // 상영관 이름
	private int totalSeat;        // 총 좌석 수
	private String availability;  // 사용 가능 여부 (T/F)
	private String cinemaNum;     // 영화관 번호 (FK)
	private String soundCode;     // 사운드 코드 (FK)
	private String soundName;     // 사운드 이름 (JOIN 결과)
	
	public TheaterDTO() {
	}

	public TheaterDTO(String theatherNum, String theatherName, int totalSeat, String availability, String cinemaNum,
			String soundCode, String soundName) {
		super();
		this.theatherNum = theatherNum;
		this.theatherName = theatherName;
		this.totalSeat = totalSeat;
		this.availability = availability;
		this.cinemaNum = cinemaNum;
		this.soundCode = soundCode;
		this.soundName = soundName;
	}

	public String getTheatherNum() {
		return theatherNum;
	}

	public void setTheatherNum(String theatherNum) {
		this.theatherNum = theatherNum;
	}

	public String getTheatherName() {
		return theatherName;
	}

	public void setTheatherName(String theatherName) {
		this.theatherName = theatherName;
	}

	public int getTotalSeat() {
		return totalSeat;
	}

	public void setTotalSeat(int totalSeat) {
		this.totalSeat = totalSeat;
	}

	public String getAvailability() {
		return availability;
	}

	public void setAvailability(String availability) {
		this.availability = availability;
	}

	public String getCinemaNum() {
		return cinemaNum;
	}

	public void setCinemaNum(String cinemaNum) {
		this.cinemaNum = cinemaNum;
	}

	public String getSoundCode() {
		return soundCode;
	}

	public void setSoundCode(String soundCode) {
		this.soundCode = soundCode;
	}

	public String getSoundName() {
		return soundName;
	}

	public void setSoundName(String soundName) {
		this.soundName = soundName;
	}

	@Override
	public String toString() {
		return "TheaterDTO [theatherNum=" + theatherNum + ", theatherName=" + theatherName + ", totalSeat=" + totalSeat
				+ ", availability=" + availability + ", cinemaNum=" + cinemaNum + ", soundCode=" + soundCode
				+ ", soundName=" + soundName + "]";
	}

	
	
}