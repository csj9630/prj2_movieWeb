package announcement;

import java.sql.SQLException;
import java.util.List;

public class AnnouncementService {
	private static AnnouncementService as;
	
	private AnnouncementService() {
		
	} // BoardService
	
	public static AnnouncementService getInstance() {
		if(as == null) {
			as = new AnnouncementService();
		} // end if
		return as;
	} // getInstance
	
	/**
	 * 총 게시물의 수
	 * @param rDTO
	 * @return
	 */
	public int totalCnt(RangeDTO rDTO) {
		int totalCnt = 0;
		AnnouncementDAO aDAO = AnnouncementDAO.getInstance();
		
		try {
			totalCnt = aDAO.selectAnnounceTotalCnt(rDTO);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return totalCnt;
	} // totalCnt
	
	/**
	 * 한 화면에 보여줄 페이지의 수
	 * @return
	 */
	public int pageScale() {
		return 10;
	} // pageScale
	
	/**
	 * 총 페이지 수
	 * @param totalCount: 전체 게시물의 수
	 * @param pageScale: 한 화면에 보여줄 게시물의 수
	 * @return
	 */
	public int totalPage(int totalCount, int pageScale) {
		return (int)Math.ceil((double)totalCount / pageScale);
	} // totalPage
	
	/**
	 * 페이지의 시작 번호 구하기
	 * @param currentPage: 현재 페이지
	 * @param pageScale: 한 화면에 보여줄 게시물의 수
	 * @return
	 */
	public int startNum(int currentPage, int pageScale) {
		return currentPage * pageScale - pageScale + 1;
	} // startNum
	
	/**
	 * 페이지의 끝 번호 구하기
	 * @param startNum: 시작 번호
	 * @param pageScale: 한 화면에 보여줄 게시물의 수
	 * @return
	 */
	public int endNum(int startNum, int pageScale) {
		return startNum + pageScale - 1;
	} // endNum
	
	/**
	 * 시작 번호, 끝 번호, 검색 필드, 검색 키워드를 사용한 게시글 검색
	 * @param rDTO
	 * @return
	 */
	public List<AnnouncementDTO> searchBoardList(RangeDTO rDTO) {
		List<AnnouncementDTO> list = null;
		AnnouncementDAO aDAO = AnnouncementDAO.getInstance();
		
		try {
			list = aDAO.selectRangeAnnouncement(rDTO);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end try ~ catch
		
		return list;
	} // searchBoardList
	
	/**
	 * 제목이 20자를 초과하면 19자까지 보여주고 뒤에 ...을 붙이는 일
	 * @param list
	 */
	public void titleSubStr(List<AnnouncementDTO> boardList) {
		String title = "";
		for(AnnouncementDTO aDTO : boardList) {
			title = aDTO.getAnnounce_name();
			if(title.length() > 19) {
				aDTO.setAnnounce_name(title.substring(0, 20) + "...");
			} // end if
		} // end for
	} // titleSubStr
	
	/**
	 * 페이지네이션 [<<] ... [1][2][3] ... [>>]
	 * @param rDTO
	 * @return
	 */
	public String pagination(RangeDTO rDTO) {
		StringBuilder pagination = new StringBuilder();
		
		// 1. 한 화면에 보여줄 pagination의 수
		int pageNumber = 10;
		
		// 2. 화면에 보여줄 시작 페이지 번호
		// 1, 2, 3 => 1로 시작
		// 4, 5, 6 => 4로 시작
		// 7, 8, 9 => 7로 시작
		// 10, 11, 12 => 10으로 시작
		// ...
		int startPage = ((rDTO.getCurrentPage() - 1)/pageNumber) * pageNumber + 1;
		
		// 3. 화면에 보여줄 마지막 페이지 번호
		int endPage = (((startPage - 1) + pageNumber) / pageNumber) * pageNumber;
		
		// 4. 총 페이지 수가 연산된 마지막 페이지 수보다 작다면 총 페이지 수가 마지막 페이지 수로 설정
		if(rDTO.getTotalPage() <= endPage) {
			endPage = rDTO.getTotalPage();
		} // end if
		
		// 5. 첫 페이지가 인덱스 화면(1 페이지)이 아닌 경우
		int movePage = 0;
		StringBuilder prevMark = new StringBuilder();
		prevMark.append("[ &lt;&lt; ]");
		/* prevMark.append("<li class='page-item'><a class='page-link' href='#'>Previous</a></li>"); */
		if(rDTO.getCurrentPage() > pageNumber) { // 시작 페이지 번호가 3보다 크면 
			movePage = startPage - 1; // 4, 5, 6 -> 3 -> 1 / 7, 8, 9 -> 6 -> 4 / ...
			prevMark.delete(0, prevMark.length()); // 이전에 링크가 없는 [<<] 삭제
			prevMark
			.append("[ <a href = '")
			.append(rDTO.getUrl())
			.append("?currentPage=")
			.append(movePage);
			
			// 검색 키워드가 있다면 검색 키워드를 붙인다.
			if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
				prevMark
				.append("&field=")
				.append(rDTO.getField())
				.append("&keyword=")
				.append(rDTO.getKeyword());
			} // end if
			
			prevMark.append("' class = 'prevMark'>&lt;&lt;</a> ]");
			
		} // end if
		
		// 6. 시작 페이지 번호부터 끝 페이지 번호까지 화면에 출력
		StringBuilder pageLink = new StringBuilder();
		movePage = startPage;
		
		while(movePage <= endPage) {
			
			if(movePage == rDTO.getCurrentPage()) { // 현재 페이지: 링크 X
				pageLink
				.append("[ <span class = 'currentPage'>")
				.append(movePage).append("</span> ]");
				
			} else { // 현재 페이지가 아닌 다른 페이지: 링크 O
				pageLink
				.append("[ <a class = 'notCurrentPage' href = '")
				.append(rDTO.getUrl())
				.append("?currentPage=")
				.append(movePage);
				
				// 검색 키워드가 있다면 검색 키워드를 붙인다.
				if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
					pageLink
					.append("&field=")
					.append(rDTO.getField())
					.append("&keyword=")
					.append(rDTO.getKeyword());
					
				} // end if
				
				pageLink
				.append("'>")
				.append(movePage)
				.append("</a> ]");
				
			} // end if ~ else
			
			movePage++;
			
		} // end while
		
		// 7. 뒤에 페이지가 더 있는 경우
		StringBuilder nextMark = new StringBuilder("[ &gt;&gt; ]");
		if(rDTO.getTotalPage() > endPage) { // 뒤에 페이지가 더 있음.
			
			movePage = endPage + 1;
			
			nextMark.delete(0, nextMark.length());
			nextMark
			.append("[ <a class = 'nextMark' href = '")
			.append(rDTO.getUrl())
			.append("?currentPage=")
			.append(movePage);
			
			// 검색 키워드가 있다면 검색 키워드를 붙인다.
			if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
				nextMark
				.append("&field=")
				.append(rDTO.getField())
				.append("&keyword=")
				.append(rDTO.getKeyword());
				
			} // end if
			
			nextMark
			.append("'>&gt;&gt;</a> ]");
			
		} // end if
		
		pagination
		.append(prevMark)
		.append("...")
		.append(pageLink)
		.append("...")
		.append(nextMark); 
		
		return pagination.toString();
		
	} // pagination
	
	public String pagination2( RangeDTO rDTO ) {
		StringBuilder pagination=new StringBuilder();
		//1. 한 화면에 보여줄 pagination의 수.
		int pageNumber=10;
		//2. 화면에 보여줄 시작페이지 번호. 1,2,3,4,5,6,7,8,9,10 => 1로 시작, 11,12,13,14,15,16,17,18,19,20 => 11로 시작
		int startPage= ((rDTO.getCurrentPage()-1)/pageNumber)*pageNumber+1;
		//3. 화면에 보여줄 마지막 페이지 번호 1,2,3,4,5,6,7,8,9,10 => 10
		int endPage= (((startPage-1)+pageNumber)/pageNumber)*pageNumber;
		//4. 총페이지수가 연산된 마지막 페이지수보다 작다면 총페이지 수가 마지막 페이지수로 설정
		//11,12,13,14,15,16,17,18,19,20인 경우 > 11로 설정
		if( rDTO.getTotalPage() <= endPage) {
			endPage=rDTO.getTotalPage();
		}//end if
		//5.첫페이지가 인덱스 화면 (1페이지) 가 아닌 경우
		int movePage=0;
		StringBuilder prevMark=new StringBuilder();
		prevMark.append("<li class='page-item disabled'>");
		prevMark.append("<a class='page-link'>Previous</a>");
		prevMark.append("</li>");
		//prevMark.append("<li class='page-item'><a class='page-link' href='#'>Previous</a></li>");
		if(rDTO.getCurrentPage() > pageNumber) {// 시작페이지 번호가 3보다 크면 
			movePage=startPage-1;// 11,12,13,14,15,16,17,18,19,20 -> 10 -> 1, 21,22,23,24,25,26,27,28,29,30 -> 20 -> 11
			prevMark.delete(0, prevMark.length());// 이전에 링크가 없는 [<<] 삭제
			prevMark.append("<li class='page-item'><a class='page-link' href='").append(rDTO.getUrl())
			.append("?currentPage=").append(movePage);
			//검색 키워드가 있다면 검색 키워드를 붙인다.
			if( rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty() ) {
				prevMark.append("&field=").append(rDTO.getField())
				.append("&keyword=").append(rDTO.getKeyword());
			}//end if
			prevMark.append("'>Previous</a></li>");
		}//end if
		
		//6.시작페이지 번호부터 끝 번호까지 화면에 출력
		StringBuilder pageLink=new StringBuilder();
		movePage=startPage;
		
		while( movePage <= endPage ) {
			if( movePage == rDTO.getCurrentPage()) { //현재 페이지 : 링크 x
				pageLink.append("<li class='page-item active page-link'>") 
				.append(movePage).append("</li>");
			}else {//현재페이지가 아닌 다른 페이지 : 링크 O
				pageLink.append("<li class='page-item'><a class='page-link' href='")
				.append(rDTO.getUrl()).append("?currentPage=").append(movePage);
				//검색 키워드가 있다면 검색 키워드를 붙인다.
				if( rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty() ) {
					pageLink.append("&field=").append(rDTO.getField())
					.append("&keyword=").append(rDTO.getKeyword());
				}//end if
				pageLink.append("'>").append(movePage).append("</a>");
				
			}//else
			
			movePage++;
		}//end while
		
		//7. 뒤에 페이지가 더 있는 경우
		StringBuilder nextMark=new StringBuilder("<li class='page-item page-link'>Next</li>");
		if( rDTO.getTotalPage() > endPage) { // 뒤에 페이지가 더 있음.
			movePage= endPage+1;
			nextMark.delete(0, nextMark.length());
			nextMark.append("<li class='page-item page-link'><a href='")
			.append(rDTO.getUrl()).append("?currentPage=").append(movePage);
			if( rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty() ) {
				nextMark.append("&field=").append(rDTO.getField())
				.append("&keyword=").append(rDTO.getKeyword());
			}//end if
			
			nextMark.append("'>Next</a></li>");
			
		}//end if
		pagination.append("<nav aria-label='...'>")
		.append("  <ul class='pagination'>");
		pagination.append(prevMark).append(pageLink).append(nextMark);
		pagination.append("</ul>")
		.append("  </nav>");
		
		return pagination.toString();
	}//pagination
	
	/**
	 * 상세보기
	 * @param num
	 * @return
	 */
	public AnnouncementDTO searchOneAnnouncement(int num) {
		AnnouncementDTO aDTO = null;
		AnnouncementDAO aDAO = AnnouncementDAO.getInstance();
		
		try {
			aDTO = aDAO.selectAnnounceDetail(num);
			/* modifyBoardCnt(num); */
		} catch (SQLException e) {
			e.printStackTrace();
		} // end try ~ catch
		
		return aDTO;
		
	} // searchOneAnnouncement
	
	public void modifyAnnounceViews(int num) {
		AnnouncementDAO aDAO = AnnouncementDAO.getInstance();
		
		try {
			aDAO.updateAnnounceViews(num);
		} catch (SQLException e) {
			e.printStackTrace();
		} // end try ~ catch
		
	} // modifyAnnounceViews
	
	/**
	 * 메가박스 스타일 페이지네이션 (<nav class="pagination">...)
	 * RangeDTO와 호환되도록 작성되었습니다.
	 */
	public String paginationMegaBoxStyle(RangeDTO rDTO) {
		StringBuilder sb = new StringBuilder();
		
		int pageScale = 10; // 한 화면에 보여줄 페이지 번호 개수
		int currentPage = rDTO.getCurrentPage();
		int totalPage = rDTO.getTotalPage();
		String url = rDTO.getUrl();
		String keywordParam = "";
		
		// 검색어 파라미터 유지 (RangeDTO의 필드명과 JSP의 input name을 맞춰야 함)
		if(rDTO.getKeyword() != null && !rDTO.getKeyword().isEmpty()) {
			keywordParam = "&field=" + rDTO.getField() + "&searchTxt=" + rDTO.getKeyword();
		}

		// 화면에 보여줄 시작/끝 페이지 계산
		int startPage = ((currentPage - 1) / pageScale) * pageScale + 1;
		int endPage = startPage + pageScale - 1;
		if(endPage > totalPage) endPage = totalPage;

		sb.append("<nav class='pagination'>");

		// 1. [이전] 버튼 그룹 (<, <<)
		// 맨 처음으로 (Optional)
		/*
		if(currentPage > 1) {
			sb.append("<a title='처음 페이지 보기' href='").append(url)
			  .append("?currentPage=1").append(keywordParam)
			  .append("' class='control first'>first</a>");
		}
		*/
		
		// 이전 10개 (startPage가 1보다 크면 이전 그룹이 존재함)
		if(startPage > 1) {
			sb.append("<a title='이전 페이지 보기' href='").append(url)
			  .append("?currentPage=").append(startPage - 1).append(keywordParam)
			  .append("' class='control prev'>prev</a>");
		}

		// 2. [페이지 번호] 출력
		for(int i = startPage; i <= endPage; i++) {
			if(i == currentPage) {
				// 현재 페이지: strong 태그 + active 클래스
				sb.append("<strong class='active'>").append(i).append("</strong>");
			} else {
				// 다른 페이지: a 태그
				sb.append("<a title='").append(i).append("페이지보기' href='").append(url)
				  .append("?currentPage=").append(i).append(keywordParam)
				  .append("'>").append(i).append("</a> ");
			}
		}

		// 3. [다음] 버튼 그룹 (>, >>)
		// 다음 10개 (totalPage가 endPage보다 크면 다음 그룹이 존재함)
		if(totalPage > endPage) {
			sb.append("<a title='이후 페이지 보기' href='").append(url)
			  .append("?currentPage=").append(endPage + 1).append(keywordParam)
			  .append("' class='control next'>next</a>");
		}
		
		// 맨 마지막으로 (Optional)
		if(totalPage > 0 && currentPage < totalPage) {
			sb.append("<a title='마지막 페이지 보기' href='").append(url)
			  .append("?currentPage=").append(totalPage).append(keywordParam)
			  .append("' class='control last'>last</a>");
		}

		sb.append("</nav>");
		
		return sb.toString();
	}
	
}
