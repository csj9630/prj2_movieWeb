package moviestory.dto;

import java.sql.Date;

/**
 * 무비 타임라인 DTO
 * 
 * 화면에 표시되는 정보:
 * - 포스터 이미지, 영화 제목, 개봉 연도, 상영관 정보, 관람 날짜
 * 
 * JOIN 구조:
 * BOOK → SCREEN_INFO → MOVIE
 * → THEATHER_INFO
 */
public class MovieTimelineDTO {

    // ========== [MOVIE 테이블] ==========
    private String movie_name; // 영화 제목
    private String main_image; // 포스터 이미지
    private String release_date; // 개봉일
    private String movie_code; // 영화 코드

    // ========== [SCREEN_INFO 테이블] ==========
    private Date screen_date; // 관람 날짜

    // ========== [THEATHER_INFO 테이블] ==========
    private String theather_name; // 상영관 이름 ex) "1관", "2관"

    // ========== [BOOK 테이블] ==========
    private String users_id; // 사용자 아이디

    // ========== 기본 생성자 ==========
    public MovieTimelineDTO() {
    }

    // ========== 전체 필드 생성자 ==========
    public MovieTimelineDTO(String movie_name, String main_image, String release_date,
            Date screen_date, String theather_name, String users_id) {
        this.movie_name = movie_name;
        this.main_image = main_image;
        this.release_date = release_date;
        this.screen_date = screen_date;
        this.theather_name = theather_name;
        this.users_id = users_id;
    }

    // ========== Getter / Setter ==========
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

    public String getRelease_date() {
        return release_date;
    }

    public void setRelease_date(String release_date) {
        this.release_date = release_date;
    }

    public Date getScreen_date() {
        return screen_date;
    }

    public void setScreen_date(Date screen_date) {
        this.screen_date = screen_date;
    }

    public String getTheather_name() {
        return theather_name;
    }

    public void setTheather_name(String theather_name) {
        this.theather_name = theather_name;
    }

    public String getUsers_id() {
        return users_id;
    }

    public void setUsers_id(String users_id) {
        this.users_id = users_id;
    }

    public String getMovie_code() {
        return movie_code;
    }

    public void setMovie_code(String movie_code) {
        this.movie_code = movie_code;
    }

    @Override
    public String toString() {
        return "MovieTimelineDTO [movie_name=" + movie_name + ", main_image=" + main_image + ", release_date="
                + release_date + ", screen_date=" + screen_date + ", theather_name=" + theather_name + ", users_id="
                + users_id + "]";
    }

}
