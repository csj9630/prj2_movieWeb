package member;

import java.util.Date;

public class userDTO {
	private String users_id, users_pass, email, users_name, gender, phone_num, active,birth;
	private Date  recent_login, join_date;

	public userDTO() {
	}

	public userDTO(String users_id, String users_pass, String email, String users_name, String gender, String phone_num,
			String active, String birth, Date recent_login, Date join_date) {
		super();
		this.users_id = users_id;
		this.users_pass = users_pass;
		this.email = email;
		this.users_name = users_name;
		this.gender = gender;
		this.phone_num = phone_num;
		this.active = active;
		this.birth = birth;
		this.recent_login = recent_login;
		this.join_date = join_date;
	}

	public String getUsers_id() {
		return users_id;
	}

	public void setUsers_id(String users_id) {
		this.users_id = users_id;
	}

	public String getUsers_pass() {
		return users_pass;
	}

	public void setUsers_pass(String users_pass) {
		this.users_pass = users_pass;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUsers_name() {
		return users_name;
	}

	public void setUsers_name(String users_name) {
		this.users_name = users_name;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getPhone_num() {
		return phone_num;
	}

	public void setPhone_num(String phone_num) {
		this.phone_num = phone_num;
	}

	public String getActive() {
		return active;
	}

	public void setActive(String active) {
		this.active = active;
	}

	public String getBirth() {
		return birth;
	}

	public void setBirth(String birth) {
		this.birth = birth;
	}

	public Date getRecent_login() {
		return recent_login;
	}

	public void setRecent_login(Date recent_login) {
		this.recent_login = recent_login;
	}

	public Date getJoin_date() {
		return join_date;
	}

	public void setJoin_date(Date join_date) {
		this.join_date = join_date;
	}

	@Override
	public String toString() {
		return "userDTO [users_id=" + users_id + ", users_pass=" + users_pass + ", email=" + email + ", users_name="
				+ users_name + ", gender=" + gender + ", phone_num=" + phone_num + ", active=" + active + ", birth="
				+ birth + ", recent_login=" + recent_login + ", join_date=" + join_date + "]";
	}

	

}
