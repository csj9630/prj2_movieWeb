package movie.movie_admin;

public class MovieDTO {
	private String movieCode;      // 영화 코드 (PK)
	private String movieName;      // 영화 제목
	private String movieGenre;     // 장르
	private String runningTime;    // 러닝타임 (분)
	private String movieGrade;     // 등급 (15세 이용가 등)
	private String releaseDate;    // 개봉일 (YYYY-MM-DD)
	private String intro;          // 줄거리
	private String mainImage;      // 메인 포스터 파일명
	private String bgImage;        // 배경 이미지 파일명
	private String dailyAudience;  // 일일 관객수
	private String totalAudience;  // 누적 관객수
	private String movieDelete;    // 삭제 여부 (T/F)
	private String showing;        // 상영 상태 (상영중/상영종료/개봉예정)
	
	private String directorNames; // 화면에 보여질 감독 이름들 (콤마로 구분)
    private String actorNames;    // 화면에 보여질 배우 이름들 (콤마로 구분)
    
	public MovieDTO() {
	}

	public MovieDTO(String movieCode, String movieName, String movieGenre, String runningTime, String movieGrade,
			String releaseDate, String intro, String mainImage, String bgImage, String dailyAudience,
			String totalAudience, String movieDelete, String showing, String directorNames, String actorNames) {
		super();
		this.movieCode = movieCode;
		this.movieName = movieName;
		this.movieGenre = movieGenre;
		this.runningTime = runningTime;
		this.movieGrade = movieGrade;
		this.releaseDate = releaseDate;
		this.intro = intro;
		this.mainImage = mainImage;
		this.bgImage = bgImage;
		this.dailyAudience = dailyAudience;
		this.totalAudience = totalAudience;
		this.movieDelete = movieDelete;
		this.showing = showing;
		this.directorNames = directorNames;
		this.actorNames = actorNames;
	}

	public String getMovieCode() {
		return movieCode;
	}

	public void setMovieCode(String movieCode) {
		this.movieCode = movieCode;
	}

	public String getMovieName() {
		return movieName;
	}

	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}

	public String getMovieGenre() {
		return movieGenre;
	}

	public void setMovieGenre(String movieGenre) {
		this.movieGenre = movieGenre;
	}

	public String getRunningTime() {
		return runningTime;
	}

	public void setRunningTime(String runningTime) {
		this.runningTime = runningTime;
	}

	public String getMovieGrade() {
		return movieGrade;
	}

	public void setMovieGrade(String movieGrade) {
		this.movieGrade = movieGrade;
	}

	public String getReleaseDate() {
		return releaseDate;
	}

	public void setReleaseDate(String releaseDate) {
		this.releaseDate = releaseDate;
	}

	public String getIntro() {
		return intro;
	}

	public void setIntro(String intro) {
		this.intro = intro;
	}

	public String getMainImage() {
		return mainImage;
	}

	public void setMainImage(String mainImage) {
		this.mainImage = mainImage;
	}

	public String getBgImage() {
		return bgImage;
	}

	public void setBgImage(String bgImage) {
		this.bgImage = bgImage;
	}

	public String getDailyAudience() {
		return dailyAudience;
	}

	public void setDailyAudience(String dailyAudience) {
		this.dailyAudience = dailyAudience;
	}

	public String getTotalAudience() {
		return totalAudience;
	}

	public void setTotalAudience(String totalAudience) {
		this.totalAudience = totalAudience;
	}

	public String getMovieDelete() {
		return movieDelete;
	}

	public void setMovieDelete(String movieDelete) {
		this.movieDelete = movieDelete;
	}

	public String getShowing() {
		return showing;
	}

	public void setShowing(String showing) {
		this.showing = showing;
	}

	public String getDirectorNames() {
		return directorNames;
	}

	public void setDirectorNames(String directorNames) {
		this.directorNames = directorNames;
	}

	public String getActorNames() {
		return actorNames;
	}

	public void setActorNames(String actorNames) {
		this.actorNames = actorNames;
	}

	@Override
	public String toString() {
		return "MovieDTO [movieCode=" + movieCode + ", movieName=" + movieName + ", movieGenre=" + movieGenre
				+ ", runningTime=" + runningTime + ", movieGrade=" + movieGrade + ", releaseDate=" + releaseDate
				+ ", intro=" + intro + ", mainImage=" + mainImage + ", bgImage=" + bgImage + ", dailyAudience="
				+ dailyAudience + ", totalAudience=" + totalAudience + ", movieDelete=" + movieDelete + ", showing="
				+ showing + ", directorNames=" + directorNames + ", actorNames=" + actorNames + "]";
	}

	
}