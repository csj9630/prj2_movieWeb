<%@page import="java.util.ArrayList"%>
<%@page import="movie_mypage_book.BookDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie_mypage_book.BookService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>

<%@ page import="java.time.LocalDate" %>
<%
request.setCharacterEncoding("UTF-8");
// 1. [Session 처리]
String userId = (String) session.getAttribute("userId");
/* if (userId == null)
	userId = "test1";  */

// 2. [파라미터 수신]
String paramType = request.getParameter("type");
String paramDate = request.getParameter("date"); // YYYY-MM format for PAST

String type = "ACTIVE"; // Default
if(paramType != null && !paramType.isEmpty()) {
	type = paramType;
}

// 년, 월 계산
String searchYear = String.valueOf(LocalDate.now().getYear()); // Default to current year
String searchMonth = "";

if("ACTIVE".equals(type)) {
	// 예매내역: 당월
	searchYear = String.valueOf(LocalDate.now().getYear());
	searchMonth = String.valueOf(LocalDate.now().getMonthValue());
} else if("PAST".equals(type)) {
	// 지난내역: 선택된 날짜 파싱 (paramDate ex: 2025-11)//삭제예정
	if(paramDate != null && paramDate.contains("-")) {
		String[] parts = paramDate.split("-");
		if(parts.length >= 2) {
			searchYear = parts[0];
			searchMonth = parts[1];
		}
	} else if(paramDate != null && paramDate.contains("/")) { // JS에서 2025/11로 넘길수도 있음
		String[] parts = paramDate.split("/");
		if(parts.length >= 2) {
			searchYear = parts[0];
			searchMonth = parts[1];
		}
	}
}

// 3. [DB 연동 및 데이터 조회]
BookService service = BookService.getInstance();
// 파라미터 전달: userId, type("ACTIVE"/"PAST"), year, month
List<BookDTO> bookList = service.getBookList(userId, type, searchYear, searchMonth); 

if (bookList == null) {
	bookList = new ArrayList<BookDTO>();
}
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
<jsp:include page="../../fragments/loginChk.jsp" />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>나의 예매내역 - 2GV</title>
    <link
      rel="stylesheet"
      href="${commonURL}/resources/css/megabox.min.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />

    <jsp:include page="style.jsp" />
    <script type="text/javascript">
      // 1. 초기화 (window.onload)
      window.onload = function() {
        initBookingPage();
      };

      // 2. 이용안내 토글 함수 (HTML onclick 호출됨 - 전역 필요)
      function toggleGuide() {
        const content = document.getElementById("guideContent");
        content.classList.toggle("show");
      }

      // 3. 페이지 초기화 로직 분리
      function initBookingPage() {
        // Query Params (JSP에서 값을 꽂아주거나 URLSearchParams 사용)
        const urlParams = new URLSearchParams(window.location.search);
        const currentType = urlParams.get('type') || "ACTIVE";
        const currentDate = urlParams.get('date') || ""; // "YYYY-MM" or "YYYY/MM"

        const menuItems = document.querySelectorAll("[data-menu]");
        const menuContents = document.querySelectorAll(".menu-content");
        const type1Radio = document.getElementById("type1");
        const type2Radio = document.getElementById("type2");
        const dateDisplay = document.getElementById("dateDisplay");
        const dateSelect = document.getElementById("dateSelect");
        const searchBtn = document.getElementById("searchBtn");

        // 현재 날짜로 dateDisplay 설정 (서버시간 기준이 좋으나 JS로 간략히)
        const now = new Date();
        const currentYear = now.getFullYear();
        const currentMonth = now.getMonth() + 1;
        if(dateDisplay) {
            dateDisplay.textContent = currentYear + "년 " + currentMonth + "월";
        }

        // 12개월 옵션 생성
        generateMonthOptions();

        // ----------------------------------------------------
        // [초기 상태 설정] : 파라미터에 따라 라디오버튼/셀렉트박스 세팅
        if(currentType === "PAST") {
        	if(type2Radio) type2Radio.checked = true;
        	
        	// UI 상태 변경
        	if(dateDisplay) dateDisplay.style.display = "none";
            if(dateSelect) dateSelect.style.display = "inline-block";
            if(searchBtn) searchBtn.disabled = false;
            
            // 날짜 선택값 복원
            if(currentDate && dateSelect) {
            	// 옵션 값 포맷이 "YYYY/M" 형태인지 확인 필요. generateMonthOptions에서 "YYYY/M"으로 생성함.
            	// 파라미터가 "YYYY-MM" 등으로 올 수도 있으니 포맷 통일 필요.
            	// 일단 단순 값 일치 시도
            	for(let i=0; i < dateSelect.options.length; i++) {
            		// "/"로 비교
            		if(dateSelect.options[i].value === currentDate.replace("-", "/")) {
            			dateSelect.selectedIndex = i;
            			break;
            		}
            	}
            }
        } else {
        	// ACTIVE (기본)
        	if(type1Radio) type1Radio.checked = true;
        	if(dateDisplay) dateDisplay.style.display = "inline-block";
            if(dateSelect) dateSelect.style.display = "none";
            if(searchBtn) searchBtn.disabled = true;
        }
        // ----------------------------------------------------

        // 라디오 버튼 변경 이벤트
        if(type1Radio) {
            type1Radio.addEventListener("change", function () {
              if (this.checked) {
                dateDisplay.style.display = "inline-block";
                dateSelect.style.display = "none";
                searchBtn.disabled = true; 
                // 예매내역 클릭 시 바로 이동하려면:
                window.location.href = "mypageBook1.jsp?type=ACTIVE";
              }
            });
        }

        if(type2Radio) {
            type2Radio.addEventListener("change", function () {
              if (this.checked) {
                dateDisplay.style.display = "none";
                dateSelect.style.display = "inline-block";
                searchBtn.disabled = false;
              }
            });
        }

        // 조회 버튼 클릭 이벤트
        if(searchBtn) {
            searchBtn.addEventListener("click", function () {
              // 지난 내역 조회
              if(type2Radio.checked) {
              	  const selectedDate = dateSelect.value; // "YYYY/M"
              	  // 페이지 이동
              	  window.location.href = "mypageBook1.jsp?type=PAST&date=" + encodeURIComponent(selectedDate);
              }
            });
        }

        // 메뉴 클릭 이벤트 (기존 로직 유지)
        menuItems.forEach(function(item) {
          item.addEventListener("click", function () {
            const menuType = this.getAttribute("data-menu");

            // 모든 메뉴에서 active 제거
            menuItems.forEach(function(m) { m.classList.remove("active"); });

            // 클릭한 메뉴에 active 추가
            this.classList.add("active");

            // 모든 컨텐츠 숨기기
            menuContents.forEach(function(c) { c.classList.remove("active"); });

            // 해당 컨텐츠 보이기
            const targetContent = document.getElementById(menuType + "-content");
            if (targetContent) {
              targetContent.classList.add("active");
            }
          });
        });
      }

      // 4. 12개월 한 달 구간 생성 함수
      function generateMonthOptions() {
        const select = document.getElementById("dateSelect");
        if(!select) return;

        const now = new Date();

        // 기존 옵션 제거
        select.innerHTML = "";

        // 현재 기준으로 이전 12개월 생성
        for (let i = 0; i < 12; i++) {
          const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
          const year = date.getFullYear();
          const month = date.getMonth() + 1;

          const option = document.createElement("option");
          option.value = year + "/" + month;
          option.textContent = year + "년 " + month + "월";

          select.appendChild(option);
        }
      }
    </script>
  <body>
    <!-- 헤더 -->
    <div id="header">
    <jsp:include page="../../fragments/header.jsp" />
	</div>
    <!-- 브레드크럼 -->
    <nav class="breadcrumb" aria-label="breadcrumb">
      <div class="container">
        <ol class="breadcrumb-list">
          <li>
            <a href="${commonURL }/user/main/index.jsp" title="홈으로 이동">
              <i class="fa-solid fa-house"></i>
            </a>
            <span class="breadcrumb-separator">></span>
          </li>
          <li>
            <a href="#">나의 2GV</a>
            <span class="breadcrumb-separator">></span>
          </li>
          <li>
            <a href="#">나의 예매내역</a>
          </li>
        </ol>
      </div>
    </nav>

    <!-- 메인 컨텐츠 -->
    <div class="container">
      <div class="page-wrap">
        <!-- 사이드바 -->
        <% request.setAttribute("activeMenu", "booking"); %>
        <%@ include file="../../fragments/sideFrame.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">
          <!-- 예매/구매내역 컨텐츠 -->
          <div id="booking-content" class="menu-content active">
            <h1 class="page-title">예매</h1>

            <!-- 탭 -->
            <div class="tabs">
              <div class="tab-item active">예매</div>
            </div>

            <!-- 검색 영역 -->
            <div class="search-box">
              <div class="search-row">
                <span class="search-label">구분</span>
                <div class="radio-group">
                  <div class="radio-item">
                    <input type="radio" name="type" id="type1" checked />
                    <label for="type1">예매내역</label>
                  </div>
                  <div class="radio-item">
                    <input type="radio" name="type" id="type2" />
                    <label for="type2">지난내역</label>
                  </div>
                </div>
                <div class="date-display" id="dateDisplay">2025/11월</div>
                <select
                  class="date-select"
                  id="dateSelect"
                  style="display: none"
                >
                  <!-- JavaScript로 동적 생성 -->
                </select>
                <button class="btn-search" id="searchBtn">조회</button>
              </div>

            <!-- 예매확인/소식 -->
            <div class="info-box">
              <div class="info-box-header">예매내역</div>
              <table class="info-table">
                <thead>
                  <tr>
                    <th>영화명</th>
                    <th>예매일</th>
                    <th>극장</th>
                    <th>상영일시</th>
                    <th>예매취소여부</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    // 3. [데이터 출력]
                    if (bookList != null && !bookList.isEmpty()) {
                      for (BookDTO booking : bookList) {
                  %>
                        <tr>
                          <td><%= booking.getMovie_name() %></td>
                          <td><%= booking.getBookTimeStr() %></td>
                          <td><%= booking.getTheater_name() %></td>
                          <td>
                              <%= booking.getScreen_date() %> - <%= booking.getScreen_open() %>
                              <%-- 
                                  [유효성 검증: 상영일시 < 예매일자 체크]
                                  현재 데이터가 테스트 데이터라 상영일이 예매일보다 과거인 경우가 있음.
                                  추후 실제 운영 시 아래 로직 활성화 고려.
                              --%>
                              <%
                                  try {
                                      // 날짜 형식이 다를 수 있으므로 포맷터 준비
                                      // book_time: "25/12/15" (yy/MM/dd)
                                      // screen_date: "2025-10-11 00:00:00" (yyyy-MM-dd HH:mm:ss)
                                      
                                      String bDateStr = booking.getBookTimeStr();
                                      String sDateStr = booking.getScreen_date();
                                      
                                      if(bDateStr != null && sDateStr != null) {
                                          java.text.SimpleDateFormat sdfBook = new java.text.SimpleDateFormat("yy/MM/dd");
                                          java.text.SimpleDateFormat sdfScreen = new java.text.SimpleDateFormat("yyyy-MM-dd - HH:mm");
                                          
                                          java.util.Date bDate = sdfBook.parse(bDateStr);
                                          java.util.Date sDate = sdfScreen.parse(sDateStr);
                                          
                                          if(sDate.before(bDate)) {
                                              // [대처방안 예시]
                                              // 1. 텍스트 강조 (빨간색)
                                              // out.print("<span style='color:red; font-weight:bold; display:block;'>(날짜오류)</span>");
                                              
                                              // 2. 해당 행 숨기기 (tr style="display:none") - 위쪽 tr 태그 제어 필요
                                              
                                              // 3. 관리자 알림 또는 로그
                                              // System.err.println("DatErr: " + booking.getBook_num());
                                          }
                                      }
                                  } catch(Exception e) {
                                      // 날짜 파싱 에러 무시
                                  }
                              %>
                          </td>
                          <td><%= "결제완료".equals(booking.getBook_state()) ? "예매 완료" : "결제대기".equals(booking.getBook_state()) ? "결제 대기" : "예매 취소" %></td>
                        </tr>
                  <%
                      }
                    } else {
                  %>
                      <tr>
                        <td colspan="5" style="padding: 40px; color: #999; text-align: center;">
                          예매 내역이 없습니다.
                        </td>
                      </tr>
                  <%
                    }
                  %>
                </tbody>
              </table>
            </div>
            </div>



            <!-- 이용안내 -->
            <div class="guide-section">
              <div class="guide-header" onclick="toggleGuide()">
                <span>이용안내</span>
                <i class="fa-solid fa-chevron-down"></i>
              </div>
              <div class="guide-content" id="guideContent">
                <ul>
                  <li>상영일 기준 7월 전 예매한 내역만 확인이 가능합니다.</li>
                  <li>예매 취소는 최소 상영시간 20분 전까지만 가능합니다.</li>
                  <li>
                    취소 시 결제하신 카드사에 따라 환불 처리 시간이 다를 수
                    있습니다.
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <!-- 나의 무비스토리 컨텐츠 -->
          <div id="movie-story-content" class="menu-content">
            <h1 class="page-title">나의 무비스토리</h1>
            <div class="empty-state">나의 무비스토리 페이지입니다.</div>
          </div>

          <!-- 개인정보 수정 컨텐츠 -->
          <div id="profile-content" class="menu-content">
            <h1 class="page-title">개인정보 수정</h1>
            <div class="empty-state">개인정보 수정 페이지입니다.</div>
          </div>

          <!-- 선호장르 수정 컨텐츠 -->
          <div id="genre-content" class="menu-content">
            <h1 class="page-title">선호장르 수정</h1>
            <div class="empty-state">선호장르 수정 페이지입니다.</div>
          </div>
        </main>
      </div>
    </div>

    <!-- Script moved to head -->
    <!-- 푸터 -->
    <div id="footer">
    <jsp:include page="../../fragments/footer.jsp"/>
    </div>
  </body>
</html>
