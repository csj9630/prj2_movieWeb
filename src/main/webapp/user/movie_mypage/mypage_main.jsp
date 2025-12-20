<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> 
<%@ include file="../../fragments/siteProperty.jsp"%> 

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.List"%>
<%@ page import="movie_mypage.MypageService"%>
<%@ page import="movie_mypage_book.BookDTO"%>

<%-- 로그인 체크 (필요시 활성화) --%>
<%-- <%@ include file="../../fragments/loginChk2.jsp"%> --%>

<%
    // 세션에서 사용자 ID 가져오기
    String userId = (String) session.getAttribute("userId");
   /*  if (userId == null) {
        userId = "test1"; // 테스트용 기본값
    } */
    
    // 서비스 호출 - 새로고침 시 자동 갱신 (AJAX 미사용)
    MypageService mypageService = MypageService.getInstance();
    
    // 1. 본 영화수 조회
    int watchedCount = mypageService.getWatchedMovieCount(userId);
    
    // 2. 관람평 수 조회
    int reviewCount = mypageService.getReviewCount(userId);
    
    // 3. 최근 예매내역 (일주일 기준 작은 범위)
    List<BookDTO> recentBookings = mypageService.getRecentBookingsWeek(userId);
    
    // 4. 마스킹된 사용자 이름
    // 4. 마스킹된 사용자 이름 (세션에서 가져와서 처리)
    String userName = (String) session.getAttribute("userName");
    String maskedName = "회원";
    
    if(userName != null && !userName.isEmpty()) {
        if(userName.length() == 2) {
            maskedName = userName.charAt(0) + "*";
        } else if(userName.length() >= 3) {
            // 가운데 글자 마스킹 (단순화: 홍*동)
            maskedName = userName.charAt(0) + "*" + userName.charAt(userName.length() - 1);
        } else {
            maskedName = userName;
        }
    }
    
    // EL에서 사용하기 위해 pageContext에 저장
    pageContext.setAttribute("watchedCount", watchedCount);
    pageContext.setAttribute("reviewCount", reviewCount);
    pageContext.setAttribute("recentBookings", recentBookings);
    pageContext.setAttribute("maskedName", maskedName);
%>

<!DOCTYPE html>
<html lang="ko">
  <head>
    <%@ include file="../../fragments/loginChk.jsp"%>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>마이페이지 - 2GV</title>
    <jsp:include page="/fragments/style_css.jsp" />

    <jsp:include page="style.jsp" />
    
    <style>
      /* 최근 예매내역 카드 스타일 */
      .booking-card {
        display: flex;
        align-items: center;
        gap: 15px;
        padding: 15px;
        background: #fff;
        border: 1px solid #eee;
        border-radius: 10px;
        margin-bottom: 12px;
        transition: box-shadow 0.2s, transform 0.2s;
        cursor: pointer;
      }
      
      .booking-card:hover {
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        transform: translateY(-2px);
      }
      
      .booking-poster {
        width: 60px;
        height: 85px;
        border-radius: 6px;
        object-fit: cover;
        flex-shrink: 0;
      }
      
      .booking-info {
        flex: 1;
        min-width: 0;
      }
      
      .booking-title {
        font-size: 15px;
        font-weight: 600;
        color: #333;
        margin-bottom: 6px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }
      
      .booking-detail {
        font-size: 12px;
        color: #888;
        margin-bottom: 3px;
      }
      
      .booking-date {
        font-size: 13px;
        color: #3e2675;
        font-weight: 500;
      }
      
      .booking-count {
        background: #3e2675;
        color: #fff;
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 500;
      }
    </style>
  </head>
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
            <a href="${commonURL}/user/main/index.jsp" title="홈으로 이동">
              <i class="fa-solid fa-house"></i>
            </a>
            <span class="breadcrumb-separator">></span>
          </li>
          <li>
            <span class="current">나의 2GV</span>
          </li>
        </ol>
      </div>
    </nav>

    <!-- 메인 컨텐츠 -->
    <div class="container">
      <div class="page-wrap">
        <!-- 사이드바 -->
        <%@ include file="../../fragments/sideFrame.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">
          <!-- 1. 프로필 배너 -->
          <div class="profile-banner">
            <div class="profile-avatar">
              <i class="fa-solid fa-user"></i>
            </div>
            <div class="profile-info">
              <h2>안녕하세요!<br />${maskedName}님</h2>
            </div>
          </div>

          <!-- 2. 나의 예매내역 -->
          <section class="dashboard-section">
            <div class="section-header">
              <h3 class="section-title">최근예매내역</h3>
              <a href="../movie_book/mypageBook1.jsp" class="more-link"
                >더보기 <i class="fa-solid fa-chevron-right"></i
              ></a>
            </div>
            
            <c:choose>
              <c:when test="${empty recentBookings}">
                <div class="booking-empty">예매 내역이 없습니다.</div>
              </c:when>
              <c:otherwise>
                <c:forEach var="booking" items="${recentBookings}">
                  <%-- 카드 전체를 클릭하면 영화 상세 페이지로 이동 --%>
                  <a href="${pageContext.request.contextPath}/user/movie/detail.jsp?mCode=${booking.movie_code}" 
                     class="booking-card" style="text-decoration: none; color: inherit;">
                    <%-- 영화 포스터 (movie_code 기반 경로) --%>
                    <c:choose>
                      <c:when test="${not empty booking.main_image}">
                        <img src="${pageContext.request.contextPath}/resources/images/movieImg/${booking.movie_code}/${booking.main_image}" 
                             alt="${booking.movie_name}" class="booking-poster"
                             onerror="this.src='https://via.placeholder.com/60x85?text=No+Image'">
                      </c:when>
                      <c:otherwise>
                        <img src="https://via.placeholder.com/60x85?text=No+Image" 
                             alt="포스터 없음" class="booking-poster">
                      </c:otherwise>
                    </c:choose>
                    
                    <%-- 예매 정보 --%>
                    <div class="booking-info">
                      <div class="booking-title">${booking.movie_name}</div>
                      <div class="booking-detail">${booking.theater_name}</div>
                      <div class="booking-date">${booking.screen_date} 관람예정</div>
                    </div>
                    
                    <%-- 인원수 --%>
                    <span class="booking-count">${booking.total_book}매</span>
                  </a>
                </c:forEach>
              </c:otherwise>
            </c:choose>
          </section>

          <!-- 3. 나의 무비스토리 -->
          <section class="dashboard-section">
            <div class="section-header">
              <h3 class="section-title">나의 무비스토리</h3>
              <a href="../movie_moviestroy/mypage_movieStory1.jsp" class="more-link"
                >더보기 <i class="fa-solid fa-chevron-right"></i
              ></a>
            </div>

            <div class="story-counts">
              <div class="count-item">
                <span class="count-num">${watchedCount}</span>
                <span class="count-label">본 영화</span>
              </div>
              <div class="count-item">
                <span class="count-num">${reviewCount}</span>
                <span class="count-label">관람평</span>
              </div>
            </div>

          </section>
        </main>
      </div>
    </div>

    <!-- 푸터 -->
    <div id="footer"><jsp:include page="../../fragments/footer.jsp"/></div>
  </body>
</html>
