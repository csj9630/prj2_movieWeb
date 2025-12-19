package movie.review;

import java.sql.Date;

//review_rvCode,review_content,review_score,review_date,book_code,users_id
public class ReviewDTO {
	private String rvCode, content, book_code, users_id, dateStr;
	private Date date;
	private int score;
	
	
	public ReviewDTO() {
		super();
		// TODO Auto-generated constructor stub
	}


	@Override
	public String toString() {
		return "ReviewDTO [rvCode=" + rvCode + ", content=" + content + ", book_code=" + book_code + ", users_id="
				+ users_id + ", dateStr=" + dateStr + ", date=" + date + ", score=" + score + "]";
	}


	public ReviewDTO(String rvCode, String content, String book_code, String users_id, String dateStr, Date date,
			int score) {
		super();
		this.rvCode = rvCode;
		this.content = content;
		this.book_code = book_code;
		this.users_id = users_id;
		this.dateStr = dateStr;
		this.date = date;
		this.score = score;
	}


	public String getRvCode() {
		return rvCode;
	}


	public void setRvCode(String rvCode) {
		this.rvCode = rvCode;
	}


	public String getContent() {
		return content;
	}


	public void setContent(String content) {
		this.content = content;
	}


	public String getBook_code() {
		return book_code;
	}


	public void setBook_code(String book_code) {
		this.book_code = book_code;
	}


	public String getUsers_id() {
		return users_id;
	}


	public void setUsers_id(String users_id) {
		this.users_id = users_id;
	}


	public String getDateStr() {
		return dateStr;
	}


	public void setDateStr(String dateStr) {
		this.dateStr = dateStr;
	}


	public Date getDate() {
		return date;
	}


	public void setDate(Date date) {
		this.date = date;
	}


	public int getScore() {
		return score;
	}


	public void setScore(int score) {
		this.score = score;
	}

	
}// class
