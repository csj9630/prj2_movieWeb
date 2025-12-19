package movie;

public class MovieDTO {
	private String moviecode, moviename, moviegenre, movierunningtime, moviegrade, 
	moviereleasedate, movieintro, moviemainimg, moviedailyaud, 
	movietotalaud, movieshowflag, moviebackimg;
	char moviedelflag;
	double bookrate;
	
	public MovieDTO() {
	}

	public MovieDTO(String moviecode, String moviename, String moviegenre, String movierunningtime, String moviegrade,
			String moviereleasedate, String movieintro, String moviemainimg, String moviedailyaud, String movietotalaud,
			String movieshowflag, String moviebackimg, char moviedelflag, double bookrate) {
		this.moviecode = moviecode;
		this.moviename = moviename;
		this.moviegenre = moviegenre;
		this.movierunningtime = movierunningtime;
		this.moviegrade = moviegrade;
		this.moviereleasedate = moviereleasedate;
		this.movieintro = movieintro;
		this.moviemainimg = moviemainimg;
		this.moviedailyaud = moviedailyaud;
		this.movietotalaud = movietotalaud;
		this.movieshowflag = movieshowflag;
		this.moviebackimg = moviebackimg;
		this.moviedelflag = moviedelflag;
		this.bookrate = bookrate;
	}

	public String getMoviecode() {
		return moviecode;
	}

	public String getMoviename() {
		return moviename;
	}

	public String getMoviegenre() {
		return moviegenre;
	}

	public String getMovierunningtime() {
		return movierunningtime;
	}

	public String getMoviegrade() {
		return moviegrade;
	}

	public String getMoviereleasedate() {
		return moviereleasedate;
	}

	public String getMovieintro() {
		return movieintro;
	}

	public String getMoviemainimg() {
		return moviemainimg;
	}

	public String getMoviedailyaud() {
		return moviedailyaud;
	}

	public String getMovietotalaud() {
		return movietotalaud;
	}

	public String getMovieshowflag() {
		return movieshowflag;
	}

	public String getMoviebackimg() {
		return moviebackimg;
	}

	public char getMoviedelflag() {
		return moviedelflag;
	}

	public void setMoviecode(String moviecode) {
		this.moviecode = moviecode;
	}

	public void setMoviename(String moviename) {
		this.moviename = moviename;
	}

	public void setMoviegenre(String moviegenre) {
		this.moviegenre = moviegenre;
	}

	public void setMovierunningtime(String movierunningtime) {
		this.movierunningtime = movierunningtime;
	}

	public void setMoviegrade(String moviegrade) {
		this.moviegrade = moviegrade;
	}

	public void setMoviereleasedate(String moviereleasedate) {
		this.moviereleasedate = moviereleasedate;
	}

	public void setMovieintro(String movieintro) {
		this.movieintro = movieintro;
	}

	public void setMoviemainimg(String moviemainimg) {
		this.moviemainimg = moviemainimg;
	}

	public void setMoviedailyaud(String moviedailyaud) {
		this.moviedailyaud = moviedailyaud;
	}

	public void setMovietotalaud(String movietotalaud) {
		this.movietotalaud = movietotalaud;
	}

	public void setMovieshowflag(String movieshowflag) {
		this.movieshowflag = movieshowflag;
	}

	public void setMoviebackimg(String moviebackimg) {
		this.moviebackimg = moviebackimg;
	}

	public void setMoviedelflag(char moviedelflag) {
		this.moviedelflag = moviedelflag;
	}

	public void setBookrate(double bookrate) {
		this.bookrate = bookrate;
	}

	public double getBookrate() {
		return bookrate;
	}

	@Override
	public String toString() {
		return "MovieDTO [moviecode=" + moviecode + ", moviename=" + moviename + ", moviegenre=" + moviegenre
				+ ", movierunningtime=" + movierunningtime + ", moviegrade=" + moviegrade + ", moviereleasedate="
				+ moviereleasedate + ", movieintro=" + movieintro + ", moviemainimg=" + moviemainimg
				+ ", moviedailyaud=" + moviedailyaud + ", movietotalaud=" + movietotalaud + ", movieshowflag="
				+ movieshowflag + ", moviebackimg=" + moviebackimg + ", moviedelflag=" + moviedelflag + ", bookrate="
				+ bookrate + "]";
	}
	
}