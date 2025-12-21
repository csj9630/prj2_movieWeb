package movie.admin;

import java.sql.Date;

public class AdminDTO {

	private String adminId, adminPass; 
	private Date createDate;
	
	public AdminDTO() {
	}

	public AdminDTO(String adminId, String adminPass, Date createDate) {
		this.adminId = adminId;
		this.adminPass = adminPass;
		this.createDate = createDate;
	}

	public String getAdminId() {
		return adminId;
	}

	public void setAdminId(String adminId) {
		this.adminId = adminId;
	}

	public String getAdminPass() {
		return adminPass;
	}

	public void setAdminPass(String adminPass) {
		this.adminPass = adminPass;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Override
	public String toString() {
		return "AdminLoginDTO [adminId=" + adminId + ", adminPass=" + adminPass + ", createDate=" + createDate + "]";
	}
	
}
