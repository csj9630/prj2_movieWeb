package movie.admin;

import java.sql.SQLException;
import java.util.List;

import movie.review_admin.ReviewDAO;
import movie.review_admin.ReviewDTO;

public class AdminReviewService {
	private static AdminReviewService service;
	private AdminReviewService() {}
	public static AdminReviewService getInstance() {
		if(service == null) service = new AdminReviewService();
		return service;
	}
	
	private ReviewDAO rDAO = ReviewDAO.getInstance();
	
	public List<ReviewDTO> getReviewList(int page, int pageSize, String field, String query) {
		List<ReviewDTO> list = null;
		try {
			int startNum = (page - 1) * pageSize + 1;
			int endNum = startNum + pageSize - 1;
			list = rDAO.selectReviewList(startNum, endNum, field, query);
		} catch (SQLException e) { e.printStackTrace(); }
		return list;
	}
	
	public int getTotalCount(String field, String query) {
		int count = 0;
		try { count = rDAO.selectTotalCount(field, query); } catch (SQLException e) { e.printStackTrace(); }
		return count;
	}
	
	public int removeReview(String reviewNum) {
		int result = 0;
		try { result = rDAO.deleteReview(reviewNum); } catch (SQLException e) { e.printStackTrace(); }
		return result;
	}
	
	public ReviewDTO getReviewDetail(String reviewNum) {
		ReviewDTO dto = null;
		try {
			dto = rDAO.selectReviewDetail(reviewNum);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}
}