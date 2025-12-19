package moviestory.service;

import java.sql.SQLException;
import java.util.List;

import moviestory.dao.MovieReviewDAO;
import moviestory.dto.MovieReviewDTO;

/**
 * 리뷰 Service
 * 비즈니스 로직 담당 - DAO와 JSP 사이의 중간 계층
 */
public class MovieReviewService {
    
    // 싱글톤 인스턴스
    private static MovieReviewService mrService;
    
    // 생성자 - private
    private MovieReviewService() {
    }
    
    /**
     * 싱글톤 인스턴스 반환
     */
    public static MovieReviewService getInstance() {
        if (mrService == null) {
            mrService = new MovieReviewService();
        }
        return mrService;
    }

    // ========== [사용자별 리뷰 목록 조회] ==========
    /**
     * 특정 사용자의 모든 리뷰 목록 조회
     * @param users_id 사용자 아이디
     * @return 리뷰 목록 (에러 시 빈 리스트)
     */
    public List<MovieReviewDTO> getReviewList(String users_id) {
        List<MovieReviewDTO> list = null;
        
        try {
            MovieReviewDAO dao = MovieReviewDAO.getInstance();
            list = dao.selectReviewList(users_id);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return list;
    }

    // ========== [리뷰 단건 조회] ==========
    /**
     * 리뷰 번호로 단건 조회
     * @param review_num 리뷰 번호
     * @return 리뷰 정보 (없으면 null)
     */
    public MovieReviewDTO getReview(String review_num) {
        MovieReviewDTO dto = null;
        
        try {
            MovieReviewDAO dao = MovieReviewDAO.getInstance();
            dto = dao.selectReview(review_num);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return dto;
    }

    // ========== [리뷰 등록] ==========
    /**
     * 새 리뷰 등록
     * @param dto 리뷰 정보
     * @return 등록 성공 여부
     */
    public boolean addReview(MovieReviewDTO dto) {
        boolean result = false;
        
        try {
            MovieReviewDAO dao = MovieReviewDAO.getInstance();
            result = dao.insertReview(dto);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return result;
    }

    // ========== [리뷰 수정] ==========
    /**
     * 리뷰 내용 및 점수 수정
     * @param dto 리뷰 정보 (review_num, review_content, review_score, users_id 필수)
     * @return 수정 성공 여부
     */
    public boolean modifyReview(MovieReviewDTO dto) {
        boolean result = false;
        
        try {
            MovieReviewDAO dao = MovieReviewDAO.getInstance();
            result = dao.updateReview(dto);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return result;
    }

    // ========== [리뷰 삭제] ==========
    /**
     * 리뷰 삭제
     * @param review_num 리뷰 번호
     * @param users_id 사용자 아이디 (본인 확인용)
     * @return 삭제 성공 여부
     */
    public boolean removeReview(String review_num, String users_id) {
        boolean result = false;
        
        try {
            MovieReviewDAO dao = MovieReviewDAO.getInstance();
            result = dao.deleteReview(review_num, users_id);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return result;
    }
}
