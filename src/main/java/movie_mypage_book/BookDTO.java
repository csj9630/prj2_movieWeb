package movie_mypage_book;

public class BookDTO {
	private String book_num;
	private String users_id;
	private String screen_code;
	private String book_state; // 'T': Active, 'F': Cancelled/Refunded?
	private int total_book;
	private String book_time;
	
	// Join fields
	private String movie_name;
	private String main_image;
	private String movie_code;  // 영화 코드 (포스터 경로 및 상세페이지 링크용)
	private String theater_name;
	private String screen_date; // Keeping as String for now as per ScreenInfoDTO, check DB type later if needed
	private String screen_open; // 상영 시작 시간
	private int screen_price;
	
	public BookDTO() {
	}

	public String getBook_num() {
		return book_num;
	}

	public void setBook_num(String book_num) {
		this.book_num = book_num;
	}

	public String getUsers_id() {
		return users_id;
	}

	public void setUsers_id(String users_id) {
		this.users_id = users_id;
	}

	public String getScreen_code() {
		return screen_code;
	}

	public void setScreen_code(String screen_code) {
		this.screen_code = screen_code;
	}

	public String getBook_state() {
		return book_state;
	}

	public void setBook_state(String book_state) {
		this.book_state = book_state;
	}

	public int getTotal_book() {
		return total_book;
	}

	public void setTotal_book(int total_book) {
		this.total_book = total_book;
	}

	public String getBookTimeStr() {
		return book_time;
	}

	public void setBookTimeStr(String book_time) {
		this.book_time = book_time;
	}

	public String getMovie_name() {
		return movie_name;
	}

	public void setMovie_name(String movie_name) {
		this.movie_name = movie_name;
	}

	public String getMain_image() {
		return main_image;
	}

	public void setMain_image(String main_image) {
		this.main_image = main_image;
	}

	public String getMovie_code() {
		return movie_code;
	}

	public void setMovie_code(String movie_code) {
		this.movie_code = movie_code;
	}

	public String getTheater_name() {
		return theater_name;
	}

	public void setTheater_name(String theater_name) {
		this.theater_name = theater_name;
	}

	public String getScreen_date() {
		return screen_date;
	}

	public void setScreen_date(String screen_date) {
		this.screen_date = screen_date;
	}
	
	public String getScreen_open() {
		return screen_open;
	}

	public void setScreen_open(String screen_open) {
		this.screen_open = screen_open;
	}

	public int getScreen_price() {
		return screen_price;
	}

	public void setScreen_price(int screen_price) {
		this.screen_price = screen_price;
	}
	
	// Helper method to get total price/cancel amount
	public int getTotalPrice() {
		return total_book * screen_price;
	}
}
