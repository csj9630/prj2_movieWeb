package movie.review;

import java.sql.SQLException;
import java.util.List;

import moviestory.dao.MovieReviewDAO;
import moviestory.dto.MovieReviewDTO;

public class ReviewService {
	// ------싱글톤 패턴------------------------
	private static ReviewService rs;

	private ReviewService() {
	}// DetailService

	public static ReviewService getInstance() {
		if (rs == null) {
			rs = new ReviewService();
		} // end if
		return rs;
	}// getInstance
		// --------------------------싱글톤 패턴----

	/**
	 * 영화 하나의 리뷰 dto를 리스트로 저장한다
	 * 
	 * @param code 영화 코드
	 * @return
	 */
	public List<ReviewDTO> searchReviewList(String code) {
		List<ReviewDTO> list = null;
		ReviewDAO rDAO = ReviewDAO.getInstance();
		try {
			list = rDAO.selectReviewList(code);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// 아이디 일부를 *처리
		for (ReviewDTO rDTO : list) {
			rDTO.setUsers_id(maskUserId(rDTO.getUsers_id()));
		} // end for

		return list;
	}// searchReviewList

	/**
	 * 영화 리뷰 리스트로 영화 하나의 평점을 구한다.
	 * 리뷰가 없으면 0을 얼리 리턴한다.
	 * 평점을 소수점 2자리에서 반올림해서1자리만나오게 하기.
	 * @param list 리뷰리스트
	 * @return
	 */
	public double getScoreAverage(List<ReviewDTO> list) {
		double scoreAverage = 0;

		for (ReviewDTO rDTO : list) {
			scoreAverage += (double) rDTO.getScore();
		} // end for
		
		// 조회된 평점이 없으면 0 리턴하고 종료
		if (scoreAverage == 0) {
			return 0;
		}
		scoreAverage = Math.round((double) scoreAverage / list.size() * 10) / 10.0;
		return scoreAverage;
	}// getScoreAverage

	/**
	 * 아이디 앞2글자, 뒤2글자만 두고 나머지를 *로 마스킹.
	 * @param userId 원본 아이디
	 * @return 마스킹된 아이디
	 */
	public static String maskUserId(String userId) {
		// 아이디가 없거나,4보다 짧으면 마스킹하지 않고 반환
        if (userId == null || userId.length() < 5) {
            return userId; 
        }//end if

        int length = userId.length();
        
        // 앞 2글자 노출 (인덱스 0, 1)
        int startIndex = 2; 
        // 뒤 1글자 노출 (인덱스 length-2) -> 마스킹 종료 지점
        int endIndex = length - 2; 

        //마스킹할 글자 수 계산
        int maskLength = endIndex - startIndex;
        
        // 마스크 문자열 생성 ("***...")
        StringBuilder mask = new StringBuilder(maskLength);
        for(int i = 0; i < maskLength; i++) {
        	mask.append('*');
        }//end if

        // 앞 2글자 추출
        String prefix = userId.substring(0, startIndex); 
        // 뒤 2글자 추출
        String suffix = userId.substring(endIndex);     

        // 5. 합치기
        return prefix + mask.toString() + suffix;
    }//maskUserId
	
    // ========== [리뷰 등록] ==========
    /**
     * 새 리뷰 등록
     * @param dto 리뷰 정보
     * @return 등록 성공 여부
     */
    public boolean addReview(ReviewDTO dto) {
        boolean result = false;
        
        try {
        	ReviewDAO rDAO = ReviewDAO.getInstance();
            result = rDAO.insertReview(dto);
        } catch (SQLException se) {
            se.printStackTrace();
        }
        
        return result;
    }
    /**
     * 
     * 댓글 작성 전 영화 시청했는지 체크.
     * @param userId
     * @return 영화 본적없으면 empty, 있으면 book_num
     */
    public String checkBookBeforeReview(String movieCode, String userId) {
    	String result = "";
    	
    	try {
    		ReviewDAO rDAO = ReviewDAO.getInstance();
    		result = rDAO.selectBookForReview(movieCode,userId);

    		//System.out.println("service: "+result);
    	} catch (SQLException se) {
    		se.printStackTrace();
    	}
    	
    	return result;
    }
	
}// class
