package movie.admin;

import java.sql.SQLException;
import java.util.List;

import kr.co.sist.chipher.DataDecryption;
import movie.reservation_admin.ReservationDAO;
import movie.reservation_admin.ReservationDTO;
import movie.user_admin.UserDTO;

public class AdminReservationService {
	private static AdminReservationService as;
	
	private AdminReservationService() {}
	
	public static AdminReservationService getInstance() {
		if(as == null) as = new AdminReservationService();
		return as;
	}
	
	// 리스트 조회
	public List<ReservationDTO> getReservationList(int currentPage, int pageScale, String field, String keyword) {
		int startNum = (currentPage - 1) * pageScale + 1;
		int endNum = startNum + pageScale - 1;
		String key="a123456789012345";
		String temp="";
		List<ReservationDTO> list = null;
		try {
			list = ReservationDAO.getInstance().selectReservationList(startNum, endNum, field, keyword);
			//ID 복호화
			for (ReservationDTO rd : list) {
				
				temp= rd.getUserName();
				if(temp != null || !temp.isEmpty()) {
					rd.setUserName(decryptUserData(temp));
					//System.out.println("===============");
					//System.out.println(temp);
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}
	
	// 총 개수
	public int getTotalCount(String field, String keyword) {
		int count = 0;
		try {
			count = ReservationDAO.getInstance().selectTotalCount(field, keyword);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return count;
	}
	
	// 페이지 수 계산
	public int totalPage(int totalCount, int pageScale) {
		return (int)Math.ceil((double)totalCount / pageScale);
	}
	
	// 상세 조회 (모달용)
	public ReservationDTO getReservationDetail(String bookNum) {
		ReservationDTO dto = null;
		try {
			dto = ReservationDAO.getInstance().selectReservationDetail(bookNum);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return dto;
	}
	
	// 예매 취소
	public boolean cancelReservation(String bookNum) {
		try {
			return ReservationDAO.getInstance().cancelReservation(bookNum) > 0;
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}
	
	// 페이지네이션 HTML
	public String getPagination(int currentPage, int totalPage, int pageGroup, String url, String field, String keyword) {
		StringBuilder sb = new StringBuilder();
		String param = "";
		if(keyword != null && !keyword.isEmpty()) {
			param = "&field=" + field + "&keyword=" + keyword;
		}
		
		int startPage = ((currentPage - 1) / pageGroup) * pageGroup + 1;
		int endPage = startPage + pageGroup - 1;
		if(endPage > totalPage) endPage = totalPage;
		
		if(startPage > pageGroup) {
			sb.append("<a href='").append(url).append("?currentPage=").append(startPage - 1).append(param)
			  .append("' class='page-link'><i class='fa-solid fa-chevron-left'></i></a>");
		} else {
			sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'><i class='fa-solid fa-chevron-left'></i></a>");
		}
		
		for(int i = startPage; i <= endPage; i++) {
			if(i == currentPage) {
				sb.append("<a href='javascript:void(0)' class='page-link active'>").append(i).append("</a>");
			} else {
				sb.append("<a href='").append(url).append("?currentPage=").append(i).append(param)
				  .append("' class='page-link'>").append(i).append("</a>");
			}
		}
		
		if(endPage < totalPage) {
			sb.append("<a href='").append(url).append("?currentPage=").append(endPage + 1).append(param)
			  .append("' class='page-link'><i class='fa-solid fa-chevron-right'></i></a>");
		} else {
			sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'><i class='fa-solid fa-chevron-right'></i></a>");
		}
		return sb.toString();
	}
	
	//유저 정보 복호화
	public static String decryptUserData(String userId) {
		String result = "";
		String key="a123456789012345";
		if (userId != null) {
			DataDecryption dd= new DataDecryption(key);//대칭키 : 암호화키와 복호화 키가 같아야 한다.
			try {
				result = dd.decrypt(userId);
			} catch (IllegalArgumentException e) {
	            // 로그를 남겨 어떤 데이터가 들어왔는지 확인하는 것이 중요합니다.
	            System.err.println("복호화 실패: 유효하지 않은 Base64 문자열입니다 -> " + e.getMessage());
	            return userId; // 매개변수 그대로 넘기기.
	       
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}//decryptUserData
}