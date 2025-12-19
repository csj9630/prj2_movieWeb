package member;

public class LoginDTO {
	private String users_id,users_pass;

	public LoginDTO() {
		super();
		// TODO Auto-generated constructor stub
	}

	public LoginDTO(String users_id, String users_pass) {
		super();
		this.users_id = users_id;
		this.users_pass = users_pass;
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

	@Override
	public String toString() {
		return "LoginDTO [users_id=" + users_id + ", users_pass=" + users_pass + "]";
	}

	
}
