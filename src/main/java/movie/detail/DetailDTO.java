package movie.detail;


public class DetailDTO {
	// movie_code, movie_name, movie_genre, running_time, movie_grade, release_date,
	// intro,
	// poster_image,bg_image, daily_audience, total_audience, movie_delete, showing
	
	//movie_code,movie_name,movie_genre,running_time,movie_grade,release_date,intro,main_image,bg_image,daily_audience,total_audience,movie_delete,showing
	private String code, name, genre, grade, intro, mainImg, bgImg, deleteFlag, showingFlag;
	private int runningTime, dailyAudience, totalAudience;
	private String releaseDate;
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getGenre() {
		return genre;
	}
	public void setGenre(String genre) {
		this.genre = genre;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public String getIntro() {
		return intro;
	}
	public void setIntro(String intro) {
		this.intro = intro;
	}
	public String getMainImg() {
		return mainImg;
	}
	public void setMainImg(String mainImg) {
		this.mainImg = mainImg;
	}
	public String getBgImg() {
		return bgImg;
	}
	public void setBgImg(String bgImg) {
		this.bgImg = bgImg;
	}
	public String getDeleteFlag() {
		return deleteFlag;
	}
	public void setDeleteFlag(String deleteFlag) {
		this.deleteFlag = deleteFlag;
	}
	public String getShowingFlag() {
		return showingFlag;
	}
	public void setShowingFlag(String showingFlag) {
		this.showingFlag = showingFlag;
	}
	public int getRunningTime() {
		return runningTime;
	}
	public void setRunningTime(int runningTime) {
		this.runningTime = runningTime;
	}
	public int getDailyAudience() {
		return dailyAudience;
	}
	public void setDailyAudience(int dailyAudience) {
		this.dailyAudience = dailyAudience;
	}
	public int getTotalAudience() {
		return totalAudience;
	}
	public void setTotalAudience(int totalAudience) {
		this.totalAudience = totalAudience;
	}
	public String getReleaseDate() {
		return releaseDate;
	}
	public void setReleaseDate(String releaseDate) {
		this.releaseDate = releaseDate;
	}
	@Override
	public String toString() {
		return "DetailDTO [code=" + code + ",<br> name=" + name + ",<br> genre=" + genre + ",<br> grade=" + grade + ",<br> intro="
				+ intro + ",<br> mainImg=" + mainImg + ",<br> bgImg=" + bgImg + ",<br> deleteFlag=" + deleteFlag + ",<br> showingFlag="
				+ showingFlag + ",<br> runningTime=" + runningTime + ",<br> dailyAudience=" + dailyAudience + ",<br> totalAudience="
				+ totalAudience + ",<br> releaseDate=" + releaseDate + "]";
	}

	

}// class
