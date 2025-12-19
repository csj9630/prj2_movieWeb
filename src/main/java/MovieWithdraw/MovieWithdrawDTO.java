package MovieWithdraw;

import java.sql.Date;

public class MovieWithdrawDTO {
    private String users_id;
    private String users_pass;
    private String email;
    private String users_name;
    private Date birth;
    private String gender;
    private String users_image;
    private Date recent_login;
    private Date join_date;
    private String active;
    private String phone_num;

    public MovieWithdrawDTO() {
    }

    public MovieWithdrawDTO(String users_id, String users_pass, String email, String users_name, Date birth,
            String gender, String users_image, Date recent_login, Date join_date, String active, String phone_num) {
        super();
        this.users_id = users_id;
        this.users_pass = users_pass;
        this.email = email;
        this.users_name = users_name;
        this.birth = birth;
        this.gender = gender;
        this.users_image = users_image;
        this.recent_login = recent_login;
        this.join_date = join_date;
        this.active = active;
        this.phone_num = phone_num;
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

    public Date getBirth() {
        return birth;
    }

    public void setBirth(Date birth) {
        this.birth = birth;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getUsers_image() {
        return users_image;
    }

    public void setUsers_image(String users_image) {
        this.users_image = users_image;
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

    public String getActive() {
        return active;
    }

    public void setActive(String active) {
        this.active = active;
    }

    public String getPhone_num() {
        return phone_num;
    }

    public void setPhone_num(String phone_num) {
        this.phone_num = phone_num;
    }

    @Override
    public String toString() {
        return "MovieWithdrawDTO [users_id=" + users_id + ", users_pass=" + users_pass + ", email=" + email
                + ", users_name=" + users_name + ", birth=" + birth + ", gender=" + gender + ", users_image="
                + users_image + ", recent_login=" + recent_login + ", join_date=" + join_date + ", active=" + active
                + ", phone_num=" + phone_num + "]";
    }
}
