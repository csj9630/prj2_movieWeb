<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> 
<%@ include file="../../fragments/siteProperty.jsp"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ page import="java.util.List"%>
<%@ page import="moviestory.service.MovieStoryService"%>
<%@ page import="moviestory.dto.MovieTimelineDTO"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>

<%-- Script moved to head --%>
<%-- <%@ include file="../../fragments/loginChk2.jsp"%> --%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <jsp:include page="../../fragments/loginChk.jsp" />
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>나의 무비스토리</title>
    <jsp:include page="/fragments/style_css.jsp" />
    <!-- Swiper CSS -->
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css"
    />

    <jsp:include page="style.jsp" />
<%
    // Session & User ID check
    String userId = (String) session.getAttribute("userId");
   /*  if (userId == null) {
        userId = "test1"; // Fallback for testing (Real DB Data: test1)
    } */

    // 3. 영화 데이터 생성 (Real DB Data)
    // [수정] DB 연동 시 에러가 발생해도 페이지가 깨지지 않도록 try-catch 추가
    String jsonResult = "[]"; // 기본값 (빈 배열)
    List<MovieTimelineDTO> timelineList = null; 
    try {
        timelineList = MovieStoryService.getInstance().getTimelineList(userId);
        
        if(timelineList != null && !timelineList.isEmpty()) {
            JSONArray jsonArr = new JSONArray();
            
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy.MM.dd");
            java.text.SimpleDateFormat yearFmt = new java.text.SimpleDateFormat("yyyy");
            
            for(MovieTimelineDTO dto : timelineList) {
                JSONObject jsonObj = new JSONObject();
                
                String mTitle = dto.getMovie_name(); 
                if(mTitle == null) mTitle = "";
                
                String mImg = dto.getMain_image();
                String mCode = dto.getMovie_code();
                if(mImg == null || mImg.isEmpty()) {
                   mImg = "https://via.placeholder.com/100x140?text=No+Image";
                } else {
                   mImg = request.getContextPath() + "/resources/images/movieImg/" + mCode + "/" + mImg;
                }
                
                String mTheater = dto.getTheather_name(); 
                if(mTheater == null) mTheater = "상영관 정보 없음";
                
                String mDate = "";
                String mYear = "";
                if(dto.getScreen_date() != null) {
                    mDate = sdf.format(dto.getScreen_date());
                    mYear = yearFmt.format(dto.getScreen_date());
                }
                
                jsonObj.put("year", mYear);
                jsonObj.put("date", mDate);
                jsonObj.put("title", mTitle);
                jsonObj.put("theater", mTheater);
                jsonObj.put("img", mImg);
                jsonObj.put("code", mCode);
                
                jsonArr.add(jsonObj);
            }
            jsonResult = jsonArr.toJSONString();
        }
    } catch (Exception e) {
        e.printStackTrace(); // 서버 콘솔에 에러 로그 출력
        jsonResult = "[]";   // 에러 발생 시 빈 데이터로 설정하여 스크립트 오류 방지
    }
    // EL 사용을 위해 pageContext에 저장
    pageContext.setAttribute("jsonResult", jsonResult);
    
    // [DEBUG]
    System.out.println("[DEBUG] mypage_movieStory1.jsp - userId: " + userId);
    System.out.println("[DEBUG] mypage_movieStory1.jsp - timelineList size: " + (timelineList != null ? timelineList.size() : "null"));
    System.out.println("[DEBUG] mypage_movieStory1.jsp - jsonResult: " + jsonResult);
%>
    <script type="text/javascript">
    /* 1. 설정 (전역 변수) */
    var movieData = ${jsonResult};  
    var contextPath = "${pageContext.request.contextPath}";
    var startYear = 2000;  // 2000년도부터 시작
    var currentYear = new Date().getFullYear();  // 현재 연도 동적으로 가져오기
    var swiper; // Swiper 인스턴스 전역 변수

    // 2. 초기화 (window.onload)
    window.onload = function() {
        initYearSelector();
        initSidebarMenu();
        
        // 초기 렌더링 (마지막 연도 = 가장 최근 영화가 있는 연도)
        var slides = document.querySelectorAll(".swiper-slide");
        if(slides.length > 0) {
            var lastSlide = slides[slides.length - 1];
            updateActiveStyle(lastSlide);
            if(swiper) swiper.slideTo(slides.length - 1, 0);
        }
        
        // 스타일 디버그 (필요시 유지)
        checkStyleLoading();
    };

    // 3. 연도 선택기 초기화 함수
    function initYearSelector() {
        var yearWrapper = document.getElementById("yearWrapper");
        
        // ============================================
        // 본 영화가 있는 연도만 추출하여 표시
        // ============================================
        var yearsWithMovies = [];
        
        // movieData에서 연도 추출
        for (var i = 0; i < movieData.length; i++) {
            var movieYear = movieData[i].year;
            if (movieYear && yearsWithMovies.indexOf(movieYear) === -1) {
                yearsWithMovies.push(movieYear);
            }
        }
        
        // 연도 오름차순 정렬
        yearsWithMovies.sort(function(a, b) {
            return parseInt(a) - parseInt(b);
        });
        
        // 영화가 없으면 현재 연도만 표시
        if (yearsWithMovies.length === 0) {
            yearsWithMovies.push(String(currentYear));
        }
        
        // 본 영화가 있는 연도만 슬라이드 생성
        for (var idx = 0; idx < yearsWithMovies.length; idx++) {
            var y = yearsWithMovies[idx];
            var slide = document.createElement("div");
            slide.classList.add("swiper-slide");
            slide.innerText = y;
            slide.setAttribute("data-year", y);
            yearWrapper.appendChild(slide);
        }

        // Swiper 초기화
        swiper = new Swiper(".year-swiper", {
            slidesPerView: 5,
            spaceBetween: 0,
            centeredSlides: false,
            watchOverflow: true,
            slideToClickedSlide: true,
            navigation: {
                nextEl: ".swiper-button-next-custom",
                prevEl: ".swiper-button-prev-custom",
            },
            on: {
                click: function (sw) {
                    updateActiveStyle(sw.clickedSlide);
                },
            },
        });
    }

    // 4. 스타일 및 데이터 갱신 함수
    function updateActiveStyle(slideElement) {
        if (!slideElement) return;

        var slides = document.querySelectorAll(".swiper-slide");
        for (var k = 0; k < slides.length; k++) {
            slides[k].classList.remove("swiper-slide-thumb-active");
        }

        slideElement.classList.add("swiper-slide-thumb-active");

        var year = slideElement.getAttribute("data-year");
        renderMovies(year);
    }

    // 5. 영화 리스트 렌더링 함수
    function renderMovies(selectedYear) {
        var listContainer = document.getElementById("movieList");
        listContainer.innerHTML = ""; // 기존 내용 초기화

        // 선택된 연도 필터링
        var filteredMovies = movieData.filter(function (m) {
            return m.year == selectedYear;
        });

        if (filteredMovies.length === 0) {
            listContainer.innerHTML =
                '<div style="text-align:center; padding:50px; color:#999;">' +
                selectedYear +
                "년에는 관람 내역이 없습니다.</div>";
            return;
        }

        // HTML 생성
        filteredMovies.forEach(function (movie) {
            var html =
                '<div class="timeline-item">' +
                '<div class="date-badge">' + movie.date + "</div>" +
                '<div class="movie-content">' +
                '<a href="' + contextPath + '/user/movie/detail.jsp?code=' + movie.code + '">' +
                '<img src="' + movie.img + '" class="poster" alt="포스터">' +
                '</a>' +
                '<div class="info">' +
                '<span class="tag">본영화</span>' +
                "<h3>" + movie.title + "</h3>" +
                "<p>" + movie.theater + "</p>" +
                "<p>" + movie.date + " 관람</p>" +
                "</div>" +
                "</div>" +
                "</div>";

            listContainer.insertAdjacentHTML("beforeend", html);
        });
    }

    // 6. 사이드바 메뉴 초기화 함수
    function initSidebarMenu() {
        var menuItems = document.querySelectorAll("[data-menu]");
        var menuContents = document.querySelectorAll(".menu-content");

        // onclick 사용 권장이라고 했으나, querySelectorAll로 가져온 요소들은 addEventListener가 더 깔끔함.
        // 하지만 사용자 요청(onclick 사용)을 존중하여, HTML에 직접 박혀있지 않은(동적 or list) 경우 
        // 기존 addEventListener 유지하되 함수로 분리.
        // *여기서는 sidebar 메뉴가 include된 파일(sideFrame.jsp)에 있으므로, HTML을 직접 수정하기 어려울 수 있음.
        // 따라서 addEventListener 유지가 안전함.* 
        
        Array.prototype.forEach.call(menuItems, function (item) {
            item.addEventListener("click", function () {
                handleMenuClick(this, menuItems, menuContents);
            });
        });
    }

    function handleMenuClick(clickedItem, menuItems, menuContents) {
        var menuType = clickedItem.getAttribute("data-menu");

        Array.prototype.forEach.call(menuItems, function (m) {
            m.classList.remove("active");
        });
        clickedItem.classList.add("active");

        Array.prototype.forEach.call(menuContents, function (c) {
            c.classList.remove("active");
        });

        var targetContent = document.getElementById(menuType + "-content");
        if (targetContent) {
            targetContent.classList.add("active");
        }
    }

    // [DEBUG] 스타일 로딩 상태 진단
    function checkStyleLoading() {
        console.log("=== Style Loading Debug Info ===");
        // (디버그 로직 유지)
        var styleSheets = document.styleSheets;
        var isCommonCssLoaded = false;
        for (var i = 0; i < styleSheets.length; i++) {
            if (styleSheets[i].href && styleSheets[i].href.indexOf("megabox.min.css") !== -1) {
                isCommonCssLoaded = true;
                break;
            }
        }
        console.log("1. Megabox Config CSS Loaded:", isCommonCssLoaded);
    }
</script>
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
            <a href="#">나의 2GV</a>
            <span class="breadcrumb-separator">></span>
          </li>
          <li><span class="current">나의 무비스토리</span></li>
        </ol>
      </div>
    </nav>

    <!-- 메인 컨텐츠 -->
    <div class="container">
      <div class="page-wrap">
        <!-- 사이드바 (sideFrame.jsp 적용) -->
        <% request.setAttribute("activeMenu", "movie-story"); %> 
        <%@ include file="../../fragments/sideFrame.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">
          <!-- 나의 무비스토리 컨텐츠 (Active) -->
          <div id="movie-story-content" class="menu-content active">
            <h1 class="page-title">나의 무비스토리</h1>

            <!-- 탭 메뉴 -->
            <div class="tab-menu">
              <div
                class="tab-item active"
                onclick="location.href='mypage_movieStory1.jsp'"
              >
                무비타임라인
              </div>
              <div class="tab-item" onclick="location.href='mypage_review.jsp'">
                관람평
              </div>
            </div>

            <!-- 연도 선택기 (Swiper) -->
            <div class="year-selector-wrap">
              <div class="nav-btn swiper-button-prev-custom">&lt;</div>

              <div class="swiper year-swiper">
                <div class="swiper-wrapper" id="yearWrapper"></div>
              </div>

              <div class="nav-btn swiper-button-next-custom">&gt;</div>
            </div>

            <!-- 결과 영역 (타임라인 리스트) -->
            <div class="timeline-list" id="movieList">
              <!-- JS로 동적 생성됨 -->
            </div>
          </div>

          <!-- 다른 메뉴 컨텐츠 (Hidden) -->
          <div id="booking-content" class="menu-content">
            <h1 class="page-title">예매/구매내역</h1>
            <div class="empty-state">예매/구매내역 페이지입니다.</div>
          </div>

          <div id="profile-content" class="menu-content">
            <h1 class="page-title">개인정보 수정</h1>
            <div class="empty-state">개인정보 수정 페이지입니다.</div>
          </div>

          
        </main>
      </div>
    </div>

    <!-- 푸터 -->
    <div id="footer"><jsp:include page="../../fragments/footer.jsp"/></div>

    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    <!-- Script moved to head -->
  </body>
</html>
