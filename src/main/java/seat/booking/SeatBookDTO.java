package seat.booking;

public class SeatBookDTO {
	private String seat_book_code, seat_code, screen_code, book_num, discount_code;

	public SeatBookDTO() {
		super();
	}

	public SeatBookDTO(String seat_book_code, String seat_code, String screen_code, String book_num,
			String discount_code) {
		super();
		this.seat_book_code = seat_book_code;
		this.seat_code = seat_code;
		this.screen_code = screen_code;
		this.book_num = book_num;
		this.discount_code = discount_code;
	}

	public String getSeat_book_code() {
		return seat_book_code;
	}

	public void setSeat_book_code(String seat_book_code) {
		this.seat_book_code = seat_book_code;
	}

	public String getSeat_code() {
		return seat_code;
	}

	public void setSeat_code(String seat_code) {
		this.seat_code = seat_code;
	}

	public String getScreen_code() {
		return screen_code;
	}

	public void setScreen_code(String screen_code) {
		this.screen_code = screen_code;
	}

	public String getBook_num() {
		return book_num;
	}

	public void setBook_num(String book_num) {
		this.book_num = book_num;
	}

	public String getDiscount_code() {
		return discount_code;
	}

	public void setDiscount_code(String discount_code) {
		this.discount_code = discount_code;
	}

	@Override
	public String toString() {
		return "SeatBookDTO [seat_book_code=" + seat_book_code + ", seat_code=" + seat_code + ", screen_code="
				+ screen_code + ", book_num=" + book_num + ", discount_code=" + discount_code + "]";
	}
	
}
