package screenInfo;

import java.util.Date;

public class ScreenInfoDTO {
	
	private String screen_code, screen_date, screen_delete, screen_showing, theather_num, movie_code;		
	private Date screen_open, screen_end;
	private int screen_price;
	
	public ScreenInfoDTO() {
		
	} // ScreenInfoDTO

	public ScreenInfoDTO(String screen_code, String screen_date, String screen_delete, String screen_showing,
			String theather_num, String movie_code, Date screen_open, Date screen_end, int screen_price) {
		this.screen_code = screen_code;
		this.screen_date = screen_date;
		this.screen_delete = screen_delete;
		this.screen_showing = screen_showing;
		this.theather_num = theather_num;
		this.movie_code = movie_code;
		this.screen_open = screen_open;
		this.screen_end = screen_end;
		this.screen_price = screen_price;
	} // ScreenInfoDTO
	
	public String getScreen_code() {
		return screen_code;
	} // getScreen_code
	
	public void setScreen_code(String screen_code) {
		this.screen_code = screen_code;
	} // setScreen_code
	
	public String getScreen_date() {
		return screen_date;
	} // getScreen_date
	
	public void setScreen_date(String screen_date) {
		this.screen_date = screen_date;
	} // setScreen_date
	
	public String getScreen_delete() {
		return screen_delete;
	} // getScreen_delete
	
	public void setScreen_delete(String screen_delete) {
		this.screen_delete = screen_delete;
	} // setScreen_delete
	
	public String getScreen_showing() {
		return screen_showing;
	} // getScreen_showing
	
	public void setScreen_showing(String screen_showing) {
		this.screen_showing = screen_showing;
	} // setScreen_showing
	
	public String getTheather_num() {
		return theather_num;
	} // getTheather_num
	
	public void setTheather_num(String theather_num) {
		this.theather_num = theather_num;
	} // setTheather_num
	
	public String getMovie_code() {
		return movie_code;
	} // getMovie_code
	
	public void setMovie_code(String movie_code) {
		this.movie_code = movie_code;
	} // setMovie_code
	
	public Date getScreen_open() {
		return screen_open;
	} // getScreen_open
	
	public void setScreen_open(Date screen_open) {
		this.screen_open = screen_open;
	} // setScreen_open
	
	public Date getScreen_end() {
		return screen_end;
	} // getScreen_end
	
	public void setScreen_end(Date screen_end) {
		this.screen_end = screen_end;
	} // setScreen_end
	
	public int getScreen_price() {
		return screen_price;
	} // getScreen_price
	
	public void setScreen_price(int screen_price) {
		this.screen_price = screen_price;
	} // setScreen_price
	
	
	
}
