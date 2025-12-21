package movie.announce_admin;

import java.sql.Date;

public class AnnounceDTO {
	private int announceNum;       // 공지 번호 (NUMBER -> int)
	private String announceName;   // 제목 (VARCHAR2 -> String)
	private String announceContent;// 내용
	private int announceViews;     // 조회수
	private Date announceDate;     // 작성일
	private String adminId;        // 관리자 ID (FK)
	
	public AnnounceDTO() {}

	public AnnounceDTO(int announceNum, String announceName, String announceContent, int announceViews,
			Date announceDate, String adminId) {
		super();
		this.announceNum = announceNum;
		this.announceName = announceName;
		this.announceContent = announceContent;
		this.announceViews = announceViews;
		this.announceDate = announceDate;
		this.adminId = adminId;
	}

	public int getAnnounceNum() {
		return announceNum;
	}

	public void setAnnounceNum(int announceNum) {
		this.announceNum = announceNum;
	}

	public String getAnnounceName() {
		return announceName;
	}

	public void setAnnounceName(String announceName) {
		this.announceName = announceName;
	}

	public String getAnnounceContent() {
		return announceContent;
	}

	public void setAnnounceContent(String announceContent) {
		this.announceContent = announceContent;
	}

	public int getAnnounceViews() {
		return announceViews;
	}

	public void setAnnounceViews(int announceViews) {
		this.announceViews = announceViews;
	}

	public Date getAnnounceDate() {
		return announceDate;
	}

	public void setAnnounceDate(Date announceDate) {
		this.announceDate = announceDate;
	}

	public String getAdminId() {
		return adminId;
	}

	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}

	@Override
	public String toString() {
		return "AnnounceDTO [announceNum=" + announceNum + ", announceName=" + announceName + ", announceContent="
				+ announceContent + ", announceViews=" + announceViews + ", announceDate=" + announceDate + ", adminId="
				+ adminId + "]";
	}

	
}