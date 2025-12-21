package movie.admin;

import java.sql.SQLException;
import java.util.List;

import movie.theater_admin.SeatDTO;
import movie.theater_admin.TheaterDAO;
import movie.theater_admin.TheaterDTO;

public class AdminTheaterService {
	private static AdminTheaterService as;
	
	private AdminTheaterService() {}
	
	public static AdminTheaterService getInstance() {
		if(as == null) as = new AdminTheaterService();
		return as;
	}
	
	// 상영관 목록 조회
	public List<TheaterDTO> getTheaterList(int currentPage, int pageScale) {
		int startNum = (currentPage - 1) * pageScale + 1;
		int endNum = startNum + pageScale - 1;
		
		List<TheaterDTO> list = null;
		try {
			list = TheaterDAO.getInstance().selectTheaterList(startNum, endNum);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// 상영관 상세 조회
	public TheaterDTO getTheater(String id) {
		TheaterDTO tDTO = null;
		try {
			tDTO = TheaterDAO.getInstance().selectTheater(id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return tDTO;
	}
	
	// 총 상영관 수
	public int getTotalCount() {
		int count = 0;
		try {
			count = TheaterDAO.getInstance().selectTotalCount();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}
	
	// 총 페이지 수 계산
	public int totalPage(int totalCount, int pageScale) {
		return (int)Math.ceil((double)totalCount / pageScale);
	}
	
	// 상영관 등록
	public boolean registerTheater(TheaterDTO tDTO) {
		try {
			TheaterDAO.getInstance().insertTheater(tDTO);
			return true;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 상영관 수정
	public boolean modifyTheater(TheaterDTO tDTO) {
		try {
			return TheaterDAO.getInstance().updateTheater(tDTO) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 상영관 상태 변경
	public boolean modifyTheaterStatus(String id, String status) {
		try {
			return TheaterDAO.getInstance().updateTheaterStatus(id, status) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 좌석 정보 조회
	public List<SeatDTO> getSeatList(String theatherNum) {
		List<SeatDTO> list = null;
		try {
			list = TheaterDAO.getInstance().selectSeatList(theatherNum);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
//	// 좌석 상태 변경
//	public boolean modifySeatStatus(String seatCode, String status) {
//		try {
//			return TheaterDAO.getInstance().updateSeatStatus(seatCode, status) > 0;
//		} catch (SQLException e) {
//			e.printStackTrace();
//			return false;
//		}
//	}
	
	// 페이지네이션 HTML
	public String getPagination(int currentPage, int totalPage, int pageGroup, String url) {
		StringBuilder sb = new StringBuilder();
		int startPage = ((currentPage - 1) / pageGroup) * pageGroup + 1;
		int endPage = startPage + pageGroup - 1;
		if(endPage > totalPage) endPage = totalPage;
		
		if(startPage > pageGroup) {
			sb.append("<a href='").append(url).append("?currentPage=").append(startPage - 1)
			  .append("' class='page-link'><i class='fa-solid fa-chevron-left'></i></a>");
		} else {
			sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'><i class='fa-solid fa-chevron-left'></i></a>");
		}
		
		for(int i = startPage; i <= endPage; i++) {
			if(i == currentPage) {
				sb.append("<a href='javascript:void(0)' class='page-link active'>").append(i).append("</a>");
			} else {
				sb.append("<a href='").append(url).append("?currentPage=").append(i)
				  .append("' class='page-link'>").append(i).append("</a>");
			}
		}
		
		if(endPage < totalPage) {
			sb.append("<a href='").append(url).append("?currentPage=").append(endPage + 1)
			  .append("' class='page-link'><i class='fa-solid fa-chevron-right'></i></a>");
		} else {
			sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'><i class='fa-solid fa-chevron-right'></i></a>");
		}
		return sb.toString();
	}
}