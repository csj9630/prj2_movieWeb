package movie.screening_admin;

public class ScreeningDTO {
    private String screenCode;
    private String movieCode;
    private String theaterNum;
    private String screenDate;
    
    // 시간 관련
    private String screenTime;    // 시작 시간 (HH:mm)
    private String screenEndTime; // 종료 시간 (HH:mm) [추가됨]

    // 추가된 테이블 컬럼 대응
    private int screenPrice;      // 가격 (예: 14000)
    private String screenDelete;  // 삭제여부 ('F', 'T')
    private String screenShowing; // 상영여부 ('Y', 'N')

    // JOIN용 컬럼
    private String movieName;
    private String theaterName;

    public ScreeningDTO() {}

	public ScreeningDTO(String screenCode, String movieCode, String theaterNum, String screenDate, String screenTime,
			String screenEndTime, int screenPrice, String screenDelete, String screenShowing, String movieName,
			String theaterName) {
		super();
		this.screenCode = screenCode;
		this.movieCode = movieCode;
		this.theaterNum = theaterNum;
		this.screenDate = screenDate;
		this.screenTime = screenTime;
		this.screenEndTime = screenEndTime;
		this.screenPrice = screenPrice;
		this.screenDelete = screenDelete;
		this.screenShowing = screenShowing;
		this.movieName = movieName;
		this.theaterName = theaterName;
	}

	public String getScreenCode() {
		return screenCode;
	}

	public void setScreenCode(String screenCode) {
		this.screenCode = screenCode;
	}

	public String getMovieCode() {
		return movieCode;
	}

	public void setMovieCode(String movieCode) {
		this.movieCode = movieCode;
	}

	public String getTheaterNum() {
		return theaterNum;
	}

	public void setTheaterNum(String theaterNum) {
		this.theaterNum = theaterNum;
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

	public String getScreenEndTime() {
		return screenEndTime;
	}

	public void setScreenEndTime(String screenEndTime) {
		this.screenEndTime = screenEndTime;
	}

	public int getScreenPrice() {
		return screenPrice;
	}

	public void setScreenPrice(int screenPrice) {
		this.screenPrice = screenPrice;
	}

	public String getScreenDelete() {
		return screenDelete;
	}

	public void setScreenDelete(String screenDelete) {
		this.screenDelete = screenDelete;
	}

	public String getScreenShowing() {
		return screenShowing;
	}

	public void setScreenShowing(String screenShowing) {
		this.screenShowing = screenShowing;
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

	@Override
	public String toString() {
		return "ScreeningDTO [screenCode=" + screenCode + ", movieCode=" + movieCode + ", theaterNum=" + theaterNum
				+ ", screenDate=" + screenDate + ", screenTime=" + screenTime + ", screenEndTime=" + screenEndTime
				+ ", screenPrice=" + screenPrice + ", screenDelete=" + screenDelete + ", screenShowing=" + screenShowing
				+ ", movieName=" + movieName + ", theaterName=" + theaterName + "]";
	}

    
}