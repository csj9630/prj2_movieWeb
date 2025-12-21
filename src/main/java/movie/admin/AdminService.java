package movie.admin;

import java.sql.SQLException;
import java.util.List;

import kr.co.sist.chipher.DataDecryption;
import kr.co.sist.chipher.DataEncryption;
import movie.user_admin.UserDAO;
import movie.user_admin.UserDTO;

/**
 * 관리자 페이지의 핵심 비즈니스 로직을 담당하는 클래스
 * - 관리자 로그인
 * - 회원 관리 (리스트 조회, 검색, 페이징)
 */
public class AdminService {
	
	private static AdminService as;
	
	private AdminService() {
	}
	
	public static AdminService getInstance() {
		if(as == null) {
			as = new AdminService();
		}
		return as;
	}
	
	// =========================================================================
	// 1. 관리자 로그인 기능
	// =========================================================================
	
	/**
	 * 관리자 로그인을 수행합니다.
	 * @param id 입력받은 아이디
	 * @param pass 입력받은 비밀번호
	 * @return 로그인 성공 시 AdminDTO, 실패 시 null
	 */
	public AdminDTO login(String id, String pass) {
		AdminDTO aDTO = null;
		AdminDAO aDAO = AdminDAO.getInstance();
		
		try {
			aDTO = aDAO.selectLoginAdmin(id, pass);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return aDTO;
	}
	
	// =========================================================================
	// 2. 회원 관리 기능 (목록, 검색, 페이징)
	// =========================================================================
	
	/**
	 * 검색 조건에 맞는 회원 리스트를 조회합니다.
	 * @param currentPage 현재 페이지 번호
	 * @param pageScale 한 페이지당 보여줄 회원의 수 (보통 10명)
	 * @param field 검색 조건 (0:아이디, 1:이름, 2:연락처)
	 * @param keyword 검색어
	 * @return 조회된 회원 목록 List<UserDTO>
	 */
	public List<UserDTO> getUserList(int currentPage, int pageScale, String field, String keyword){
		List<UserDTO> list = null;
		
		// 1. 시작 번호와 끝 번호 계산
		int startNum = startNum(currentPage, pageScale);
		int endNum = endNum(startNum, pageScale);
		
		// 2. DAO를 통해 리스트 조회
		UserDAO uDAO = UserDAO.getInstance();
		try {
			list = uDAO.selectUserList(startNum, endNum, field, keyword);
			
			//암호화된 유저 정보를 복호화.
			for (UserDTO uDTO : list) {
				uDTO = decryptUserData(uDTO);
			}//end for
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	/**
	 * 검색 조건에 해당하는 총 회원 수를 구합니다. (페이지네이션 계산용)
	 * @param field 검색 조건
	 * @param keyword 검색어
	 * @return 총 회원 수
	 */
	public int getTotalCount(String field, String keyword) {
		int totalCount = 0;
		UserDAO uDAO = UserDAO.getInstance();
		try {
			totalCount = uDAO.selectTotalCount(field, keyword);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return totalCount;
	}
	
	// =========================================================================
	// 3. 페이지네이션(Pagination) 유틸리티 메소드
	// =========================================================================
	
	/**
	 * 페이지의 시작 번호(row_number)를 구합니다.
	 * @param currentPage 현재 페이지
	 * @param pageScale 페이지당 게시물 수
	 * @return 시작 번호
	 */
	public int startNum(int currentPage, int pageScale) {
		// 예: 1페이지 -> (1-1)*10 + 1 = 1
		// 예: 2페이지 -> (2-1)*10 + 1 = 11
		return (currentPage - 1) * pageScale + 1;
	}
	
	/**
	 * 페이지의 끝 번호(row_number)를 구합니다.
	 * @param startNum 시작 번호
	 * @param pageScale 페이지당 게시물 수
	 * @return 끝 번호
	 */
	public int endNum(int startNum, int pageScale) {
		// 예: 1페이지(시작1) -> 1 + 10 - 1 = 10
		return startNum + pageScale - 1;
	}
	
	/**
	 * 총 페이지 수를 구합니다.
	 * @param totalCount 총 게시물 수
	 * @param pageScale 페이지당 게시물 수
	 * @return 총 페이지 수
	 */
	public int totalPage(int totalCount, int pageScale) {
		int totalPage = (int)Math.ceil((double)totalCount / pageScale);
		return totalPage;
	}
	
	/**
	 * 페이지네이션 HTML을 생성합니다. (JSP에 정의된 커스텀 CSS 적용 버전)
	 * - <ul><li> 구조 대신 <a> 태그 나열 방식으로 변경
	 * - FontAwesome 아이콘 적용
	 */
	public String getPagination(int currentPage, int totalPage, int pageGroup, String url, String field, String keyword) {
		StringBuilder sb = new StringBuilder();
		
		// 1. 파라미터 유지를 위한 쿼리 스트링 생성
		String param = "";
		if(keyword != null && !"".equals(keyword)) {
			param = "&field=" + field + "&keyword=" + keyword;
		}
		
		// 2. 페이지 그룹 계산
		int startPage = ((currentPage - 1) / pageGroup) * pageGroup + 1;
		int endPage = startPage + pageGroup - 1;
		
		if(endPage > totalPage) {
			endPage = totalPage;
		}
		
		// 3. HTML 생성 (<a> 태그 나열 방식)
		
		// [이전] 버튼
		// 이전 그룹이 있으면 링크 활성화, 없으면 회색 처리
		if(startPage > pageGroup) {
			sb.append("<a href='").append(url)
			  .append("?currentPage=").append(startPage - 1).append(param)
			  .append("' class='page-link'><i class='fa-solid fa-chevron-left'></i></a>");
		} else {
			sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'>")
			  .append("<i class='fa-solid fa-chevron-left'></i></a>");
		}
		
		// [페이지 번호]
		for(int i = startPage; i <= endPage; i++) {
			if(i == currentPage) {
				// 현재 페이지: active 클래스 추가 (보라색 배경)
				sb.append("<a href='javascript:void(0)' class='page-link active'>").append(i).append("</a>");
			} else {
				// 다른 페이지: 링크 연결
				sb.append("<a href='").append(url)
				  .append("?currentPage=").append(i).append(param)
				  .append("' class='page-link'>").append(i).append("</a>");
			}
		}
		
		// [다음] 버튼
		// 다음 그룹이 있으면 링크 활성화, 없으면 회색 처리
		if(endPage < totalPage) {
			sb.append("<a href='").append(url)
			  .append("?currentPage=").append(endPage + 1).append(param)
			  .append("' class='page-link'><i class='fa-solid fa-chevron-right'></i></a>");
		} else {
			sb.append("<a href='javascript:void(0)' class='page-link' style='color:#ccc; cursor:default;'>")
			  .append("<i class='fa-solid fa-chevron-right'></i></a>");
		}
		
		return sb.toString();
	}
	
	/**
	 * 회원 상태를 변경합니다.
	 * @param userId 아이디
	 * @param status 변경할 상태 ('Y':활성, 'N':비활성)
	 * @return 변경 성공 여부
	 */
	public boolean modifyUserStatus(String userId, String status) {
		boolean result = false;
		UserDAO uDAO = UserDAO.getInstance();
		try {
			int cnt = uDAO.updateUserStatus(userId, status);
			if(cnt > 0) result = true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	//==========================================================================
	
	//유저 정보 복호화
	public UserDTO decryptUserData(UserDTO uDTO) {
		//String result = "";
		
		String key="a123456789012345";
		if (uDTO != null) {
			DataDecryption dd= new DataDecryption(key);//대칭키 : 암호화키와 복호화 키가 같아야 한다.
			try {
				uDTO.setUserName(dd.decrypt(uDTO.getUserName()));
				uDTO.setPhoneNum(dd.decrypt(uDTO.getPhoneNum()));
				uDTO.setEmail(dd.decrypt(uDTO.getEmail()));
			} catch (IllegalArgumentException e) {
	            // 로그를 남겨 어떤 데이터가 들어왔는지 확인하는 것이 중요합니다.
	            System.err.println("복호화 실패: 유효하지 않은 Base64 문자열입니다 -> " + e.getMessage());
	            return null; // 또는 빈 문자열, 혹은 사용자 정의 예외 던지기
	       
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		return uDTO;
	}//decryptUserData
	

	/**
	 * 유저 정보 암호화 - 유저 정보 수정 때 쓰려고 했으나 admin에서는 정보 수정 안한다고 하니 안 씀.
	 * @param uDTO
	 * @return
	 */
	public UserDTO encryptUserData(UserDTO uDTO) {
		
		String key="a123456789012345";
		
		DataEncryption de = new DataEncryption(key);
		if (uDTO.getUserName() != null && !"".equals(uDTO.getUserName())) {
			try {
				uDTO.setUserName(de.encrypt(uDTO.getUserName()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getEmail() != null && !"".equals(uDTO.getEmail())) {
			try {
				uDTO.setEmail(de.encrypt(uDTO.getEmail()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		if (uDTO.getPhoneNum() != null && !"".equals(uDTO.getPhoneNum())) {
			try {
				uDTO.setPhoneNum(de.encrypt(uDTO.getEmail()));
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end if
		
		return uDTO;
	}//decryptUserData
	
	
}