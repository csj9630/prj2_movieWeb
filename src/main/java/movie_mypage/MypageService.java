package movie_mypage;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import movie_mypage_book.BookDTO;

/**
 * 마이페이지 메인 화면용 Service
 * - DAO 호출 및 예외 처리
 * - 페이지 새로고침 시 데이터 갱신 (AJAX 미사용)
 */
public class MypageService {
    private static MypageService service;
    
    private MypageService() {
    }
    
    public static MypageService getInstance() {
        if(service == null) {
            service = new MypageService();
        }
        return service;
    }
    
    /**
     * 본 영화수 조회
     * @param userId 사용자 ID
     * @return 본 영화 수 (에러 시 0)
     */
    public int getWatchedMovieCount(String userId) {
        try {
            return MypageDAO.getInstance().getWatchedMovieCount(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 관람평 수 조회
     * @param userId 사용자 ID
     * @return 관람평 수 (에러 시 0)
     */
    public int getReviewCount(String userId) {
        try {
            return MypageDAO.getInstance().getReviewCount(userId);
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * 최근 예매내역 조회 (일주일 기준)
     * @param userId 사용자 ID
     * @return 최근 예매 목록 (에러 시 빈 리스트)
     */
    public List<BookDTO> getRecentBookingsWeek(String userId) {
        try {
            return MypageDAO.getInstance().getRecentBookings(userId, 7);
        } catch (SQLException e) {
            e.printStackTrace();
            return new ArrayList<BookDTO>();
        }
    }
    
    // /**
    //  * 최근 예매내역 조회 (한달 기준)
    //  * @param userId 사용자 ID
    //  * @return 최근 예매 목록 (에러 시 빈 리스트)
    //  */
    // public List<BookDTO> getRecentBookingsMonth(String userId) {
    //     try {
    //         return MypageDAO.getInstance().getRecentBookings(userId, 30);
    //     } catch (SQLException e) {
    //         e.printStackTrace();
    //         return new ArrayList<BookDTO>();
    //     }
    // }
    
    /**
     * 사용자 이름 조회 (마스킹 처리)
     * 예: "홍길동" -> "홍*동"
     * @param userId 사용자 ID
     * @return 마스킹된 사용자 이름
     */
    public String getMaskedUserName(String userId) {
        try {
            String name = MypageDAO.getInstance().getUserName(userId);
            
            if(name == null || name.isEmpty()) {
                return "회원";
            }
            
            // 이름 마스킹 처리 (가운데 글자를 *로)
            if(name.length() == 2) {
                return name.charAt(0) + "*";
            } else if(name.length() >= 3) {
                // 첫 글자 + * + 마지막 글자
                return name.charAt(0) + "*" + name.charAt(name.length() - 1);
            }
            
            return name;
        } catch (SQLException e) {
            e.printStackTrace();
            return "회원";
        }
    }
}
