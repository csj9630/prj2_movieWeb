package reserve;

import java.sql.Date;

public class BookDTO {
	private String bookNum, bookTime, bookState, screenCode, usersId;
	private Date bookCancelDate;
	private int totalBookNum;

	public BookDTO() {
		super();
		// TODO Auto-generated constructor stub

	}

	@Override
	public String toString() {
		return "BookDTO [bookNum=" + bookNum + ", bookTime=" + bookTime + ", bookState=" + bookState + ", screenCode="
				+ screenCode + ", usersId=" + usersId + ", bookCancelDate=" + bookCancelDate + ", totalBookNum="
				+ totalBookNum + "]";
	}

	public String getBookNum() {
		return bookNum;
	}

	public void setBookNum(String bookNum) {
		this.bookNum = bookNum;
	}

	public String getBookTime() {
		return bookTime;
	}

	public void setBookTime(String bookTime) {
		this.bookTime = bookTime;
	}

	public String getBookState() {
		return bookState;
	}

	public void setBookState(String bookState) {
		this.bookState = bookState;
	}

	public String getScreenCode() {
		return screenCode;
	}

	public void setScreenCode(String screenCode) {
		this.screenCode = screenCode;
	}

	public String getUsersId() {
		return usersId;
	}

	public void setUsersId(String usersId) {
		this.usersId = usersId;
	}

	public Date getBookCancelDate() {
		return bookCancelDate;
	}

	public void setBookCancelDate(Date bookCancelDate) {
		this.bookCancelDate = bookCancelDate;
	}

	public int getTotalBookNum() {
		return totalBookNum;
	}

	public void setTotalBookNum(int totalBookNum) {
		this.totalBookNum = totalBookNum;
	}

	public BookDTO(String bookNum, String bookTime, String bookState, String screenCode, String usersId,
			Date bookCancelDate, int totalBookNum) {
		super();
		this.bookNum = bookNum;
		this.bookTime = bookTime;
		this.bookState = bookState;
		this.screenCode = screenCode;
		this.usersId = usersId;
		this.bookCancelDate = bookCancelDate;
		this.totalBookNum = totalBookNum;
	}
}
