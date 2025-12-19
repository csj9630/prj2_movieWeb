package moviestory.dto;

import java.sql.Date;

/**
 * 리뷰 DTO
 * REVIEW 테이블 + MOVIE 테이블 JOIN 정보를 담는 데이터 전송 객체
 * 
 * [REVIEW 테이블 구조]
 * - review_num VARCHAR2(30) : 리뷰 번호 (PK)
 * - review_content VARCHAR2(3000) : 리뷰 내용
 * - review_score NUMBER : 평점 (0~100)
 * - review_date DATE : 작성일
 * - book_num VARCHAR2(30) : 예매 번호 (FK -> BOOK)
 * - users_id VARCHAR2(100) : 사용자 아이디 (FK -> USERS)
 */
public class MovieReviewDTO {

    // ========== [REVIEW 테이블 컬럼] ==========
    private String review_num;      // 리뷰 번호 (PK)
    private String review_content;  // 리뷰 내용
    private int review_score;       // 평점 (0~100)
    private Date review_date;       // 작성일
    private String book_num;        // 예매 번호 (FK)
    private String users_id;        // 사용자 아이디 (FK)

    // ========== [JOIN으로 가져오는 추가 정보] ==========
    private String movie_code;      // 영화 코드 (MOVIE 테이블)
    private String movie_name;      // 영화 제목 (화면 표시용)
    private String main_image;      // 영화 포스터 이미지 (선택)

    // ========== 기본 생성자 ==========
    public MovieReviewDTO() {
    }

    // ========== Getter / Setter ==========
    
    // review_num
    public String getReview_num() {
        return review_num;
    }
    public void setReview_num(String review_num) {
        this.review_num = review_num;
    }

    // review_content
    public String getReview_content() {
        return review_content;
    }
    public void setReview_content(String review_content) {
        this.review_content = review_content;
    }

    // review_score
    public int getReview_score() {
        return review_score;
    }
    public void setReview_score(int review_score) {
        this.review_score = review_score;
    }

    // review_date
    public Date getReview_date() {
        return review_date;
    }
    public void setReview_date(Date review_date) {
        this.review_date = review_date;
    }

    // book_num
    public String getBook_num() {
        return book_num;
    }
    public void setBook_num(String book_num) {
        this.book_num = book_num;
    }

    // users_id
    public String getUsers_id() {
        return users_id;
    }
    public void setUsers_id(String users_id) {
        this.users_id = users_id;
    }

    // movie_code
    public String getMovie_code() {
        return movie_code;
    }
    public void setMovie_code(String movie_code) {
        this.movie_code = movie_code;
    }

    // movie_name
    public String getMovie_name() {
        return movie_name;
    }
    public void setMovie_name(String movie_name) {
        this.movie_name = movie_name;
    }

    // main_image
    public String getMain_image() {
        return main_image;
    }
    public void setMain_image(String main_image) {
        this.main_image = main_image;
    }

    @Override
    public String toString() {
        return "MovieReviewDTO [review_num=" + review_num 
                + ", review_content=" + review_content
                + ", review_score=" + review_score 
                + ", review_date=" + review_date
                + ", movie_name=" + movie_name + "]";
    }
}
