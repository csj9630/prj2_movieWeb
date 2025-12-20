package movie.booking;

import java.util.Date;

public class ScheduleDTO {
	@Override
	public String toString() {
		return "ScheduleDTO [screenCode=" + screenCode + ", screenDate=" + screenDate + ", screenOpen=" + screenOpen
				+ ", screenEnd=" + screenEnd + ", movieCode=" + movieCode + ", movieGrade=" + movieGrade
				+ ", movieName=" + movieName + ", runningTime=" + runningTime + ", theatherName=" + theatherName
				+ ", theatherNum=" + theatherNum + ", totalSeat=" + totalSeat + ", seatCount=" + seatCount + "]";
	}


	public String getTheatherNum() {
		return theatherNum;
	}


	public void setTheatherNum(String theatherNum) {
		this.theatherNum = theatherNum;
	}


	// screen_info 테이블
    private String screenCode;
    private String screenDate;
    private Date screenOpen;
    private Date screenEnd;

    // movie 테이블 (Join)
    private String movieCode;
    private String movieGrade;
    private String movieName;
    private int runningTime;

    // theather_info 테이블 (Join)
    private String theatherName;
    private String theatherNum;
    private int totalSeat;

    // 서브쿼리 결과 (예약 좌석 수)
    private int seatCount;

    // 추가하면 좋은 필드 (잔여 좌석 계산)
    public int getRemainingSeat() {
        return this.totalSeat - this.seatCount;
    }
	
	
	public String getScreenCode() {
		return screenCode;
	}

	public void setScreenCode(String screenCode) {
		this.screenCode = screenCode;
	}

	public String getScreenDate() {
		return screenDate;
	}

	public void setScreenDate(String screenDate) {
		this.screenDate = screenDate;
	}

	public Date getScreenOpen() {
		return screenOpen;
	}

	public void setScreenOpen(Date screenOpen) {
		this.screenOpen = screenOpen;
	}

	public Date getScreenEnd() {
		return screenEnd;
	}

	public void setScreenEnd(Date screenEnd) {
		this.screenEnd = screenEnd;
	}

	public String getMovieCode() {
		return movieCode;
	}

	public void setMovieCode(String movieCode) {
		this.movieCode = movieCode;
	}

	public String getMovieGrade() {
		return movieGrade;
	}

	public void setMovieGrade(String movieGrade) {
		this.movieGrade = movieGrade;
	}

	public String getMovieName() {
		return movieName;
	}

	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}

	public int getRunningTime() {
		return runningTime;
	}

	public void setRunningTime(int runningTime) {
		this.runningTime = runningTime;
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

	public int getSeatCount() {
		return seatCount;
	}

	public void setSeatCount(int seatCount) {
		this.seatCount = seatCount;
	}

	
	public ScheduleDTO(String screenCode, String screenDate, Date screenOpen, Date screenEnd, String movieCode,
			String movieGrade, String movieName, int runningTime, String theatherName, String theatherNum,
			int totalSeat, int seatCount) {
		super();
		this.screenCode = screenCode;
		this.screenDate = screenDate;
		this.screenOpen = screenOpen;
		this.screenEnd = screenEnd;
		this.movieCode = movieCode;
		this.movieGrade = movieGrade;
		this.movieName = movieName;
		this.runningTime = runningTime;
		this.theatherName = theatherName;
		this.theatherNum = theatherNum;
		this.totalSeat = totalSeat;
		this.seatCount = seatCount;
	}


	public ScheduleDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
    
	
	
}
