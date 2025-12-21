package movie.review_admin;

import java.sql.Date;

public class ReviewDTO {
	private String reviewNum;      // 리뷰 번호 (PK)
	private String reviewContent;  // 리뷰 내용
	private int reviewScore;       // 평점
	private Date reviewDate;       // 작성일
	private String bookNum;        // 예매 번호 (FK) - BOOK 테이블 참조
	private String userId;         // 작성자 ID (FK) - USERS 테이블 참조
	
	// JOIN을 통해 가져올 추가 정보 (화면 표시용)
	private String movieName;      // 영화 제목

	public ReviewDTO() {}

	public ReviewDTO(String reviewNum, String reviewContent, int reviewScore, Date reviewDate, String bookNum,
			String userId, String movieName) {
		super();
		this.reviewNum = reviewNum;
		this.reviewContent = reviewContent;
		this.reviewScore = reviewScore;
		this.reviewDate = reviewDate;
		this.bookNum = bookNum;
		this.userId = userId;
		this.movieName = movieName;
	}

	public String getReviewNum() {
		return reviewNum;
	}

	public void setReviewNum(String reviewNum) {
		this.reviewNum = reviewNum;
	}

	public String getReviewContent() {
		return reviewContent;
	}

	public void setReviewContent(String reviewContent) {
		this.reviewContent = reviewContent;
	}

	public int getReviewScore() {
		return reviewScore;
	}

	public void setReviewScore(int reviewScore) {
		this.reviewScore = reviewScore;
	}

	public Date getReviewDate() {
		return reviewDate;
	}

	public void setReviewDate(Date reviewDate) {
		this.reviewDate = reviewDate;
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

	public String getMovieName() {
		return movieName;
	}

	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}

	@Override
	public String toString() {
		return "ReviewDTO [reviewNum=" + reviewNum + ", reviewContent=" + reviewContent + ", reviewScore=" + reviewScore
				+ ", reviewDate=" + reviewDate + ", bookNum=" + bookNum + ", userId=" + userId + ", movieName="
				+ movieName + "]";
	}

	
}