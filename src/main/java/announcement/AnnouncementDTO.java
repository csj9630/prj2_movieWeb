package announcement;

import java.util.Date;

public class AnnouncementDTO {
	private int announce_num, announce_views;
	private String announce_name, announce_content, admin_id;
	private Date announce_date;
	
	public AnnouncementDTO() {
		
	} // AnnouncementDTO
	
	public AnnouncementDTO(int announce_num, int announce_views, String announce_name, String announce_content,
			String admin_id, Date announce_date) {
		this.announce_num = announce_num;
		this.announce_views = announce_views;
		this.announce_name = announce_name;
		this.announce_content = announce_content;
		this.admin_id = admin_id;
		this.announce_date = announce_date;
	} // AnnouncementDTO
	
	public int getAnnounce_num() {
		return announce_num;
	} // getAnnounce_num
	
	public void setAnnounce_num(int announce_num) {
		this.announce_num = announce_num;
	} // setAnnounce_num
	
	public int getAnnounce_views() {
		return announce_views;
	} // getAnnounce_views
	
	public void setAnnounce_views(int announce_views) {
		this.announce_views = announce_views;
	} // setAnnounce_views
	
	public String getAnnounce_name() {
		return announce_name;
	} // getAnnounce_name
	
	public void setAnnounce_name(String announce_name) {
		this.announce_name = announce_name;
	} // setAnnounce_name
	
	public String getAnnounce_content() {
		return announce_content;
	} // getAnnounce_content
	
	public void setAnnounce_content(String announce_content) {
		this.announce_content = announce_content;
	} // setAnnounce_content
	
	public String getAdmin_id() {
		return admin_id;
	} // getAdmin_id
	
	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	} // setAdmin_id
	
	public Date getAnnounce_date() {
		return announce_date;
	} // getAnnounce_date
	
	public void setAnnounce_date(Date announce_date) {
		this.announce_date = announce_date;
	} // setAnnounce_date
	
	@Override
	public String toString() {
		return "AnnouncementDTO [announce_num=" + announce_num + ", announce_views=" + announce_views
				+ ", announce_name=" + announce_name + ", announce_content=" + announce_content + ", admin_id="
				+ admin_id + ", announce_date=" + announce_date + "]";
	} // toString
	
} // class
