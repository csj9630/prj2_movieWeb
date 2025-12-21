package movie.user_admin;

import java.sql.Date;

public class UserDTO {

	private String userId, userName, phoneNum, email, birth, gender, active;
	private Date joinDate, recentLogin;
	
	public UserDTO() {
	}

	public UserDTO(String userId, String userName, String phoneNum, String email, String birth, String gender,
			String active, Date joinDate, Date recentLogin) {
		this.userId = userId;
		this.userName = userName;
		this.phoneNum = phoneNum;
		this.email = email;
		this.birth = birth;
		this.gender = gender;
		this.active = active;
		this.joinDate = joinDate;
		this.recentLogin = recentLogin;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPhoneNum() {
		return phoneNum;
	}

	public void setPhoneNum(String phoneNum) {
		this.phoneNum = phoneNum;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getActive() {
		return active;
	}

	public void setActive(String active) {
		this.active = active;
	}

	public Date getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(Date joinDate) {
		this.joinDate = joinDate;
	}

	public Date getRecentLogin() {
		return recentLogin;
	}

	public void setRecentLogin(Date recentLogin) {
		this.recentLogin = recentLogin;
	}

	@Override
	public String toString() {
		return "UserDTO [userId=" + userId + ", userName=" + userName + ", phoneNum=" + phoneNum + ", email=" + email
				+ ", birth=" + birth + ", gender=" + gender + ", active=" + active + ", joinDate=" + joinDate
				+ ", recentLogin=" + recentLogin + "]";
	}
	
}
