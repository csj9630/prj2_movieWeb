<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.movie_admin.MovieDTO" %>
<%@ page import="movie.admin.AdminMovieService" %> <%@ page import="movie.theater_admin.TheaterDAO" %>
<%@ page import="movie.theater_admin.TheaterDTO" %>
<%
    // [세션 검사] 로그인 안 된 상태면 로그인 화면으로 튕겨냄
    String adminId = (String) session.getAttribute("adminId");
    if (adminId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "../admin_login/Admin_Login.jsp";
    </script>
<%
        return; // 밑에 있는 HTML이나 자바 코드가 실행되지 않도록 여기서 멈춤
    }
%>
<%
    // [수정 핵심] 영화 목록 가져오기 (Service를 통해 상영중/개봉예정만 필터링)
    AdminMovieService as = AdminMovieService.getInstance();
    List<MovieDTO> movieList = as.getMoviesForSchedule(); // DAO 직접 호출 -> Service로 변경
    
    // 2. 상영관 목록 가져오기
    TheaterDAO tDAO = TheaterDAO.getInstance();
    List<TheaterDTO> theaterList = tDAO.selectTheaterList(1, 100);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영 스케줄 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 기존 CSS 스타일 유지 */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select { font-family: 'Noto Sans KR', sans-serif; }
        /* 사이드바 및 레이아웃 스타일 생략 (기존 코드 사용) */
        .sidebar { width: 260px; background-color: #1e1e2d; color: #a2a3b7; display: flex; flex-direction: column; flex-shrink: 0; transition: all 0.3s; }
        .logo-area { height: 80px; display: flex; align-items: center; justify-content: center; background-color: #1b1b28; border-bottom: 1px solid #2d2d3f; }
        .logo-area img { height: 45px; object-fit: contain; display: block; }
        .menu-list { padding: 20px 0; flex: 1; overflow-y: auto; }
        .menu-category { font-size: 11px; font-weight: 700; text-transform: uppercase; color: #5e6278; padding: 10px 25px; margin-top: 15px; }
        .menu-category:first-child { margin-top: 0; }
        .menu-link { display: flex; align-items: center; padding: 12px 25px; color: #a2a3b7; font-size: 14px; font-weight: 500; transition: 0.2s; border-left: 3px solid transparent; }
        .menu-link:hover, .menu-link.active { background-color: #2b2b40; color: #fff; border-left-color: #503396; }
        .menu-icon { width: 25px; font-size: 16px; text-align: center; margin-right: 10px; }
        .sidebar-footer { padding: 20px; border-top: 1px solid #2d2d3f; display: flex; align-items: center; gap: 12px; background-color: #1e1e2d; }
        .admin-avatar { width: 40px; height: 40px; background-color: #503396; border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-weight: bold; font-size: 14px; }
        .admin-info h4 { font-size: 14px; color: #fff; font-weight: 500; margin-bottom: 2px; }
        .admin-info p { font-size: 12px; color: #727589; }
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }
        
        .form-container { background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); max-width: 800px; margin: 0 auto; }
        .form-header { margin-bottom: 30px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .form-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 8px; }
        .required { color: #e74c3c; margin-left: 3px; }
        .form-input, .form-select { width: 100%; height: 45px; padding: 0 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; color: #555; background-color: #fff; }
        .form-input:focus, .form-select:focus { border-color: #503396; }
        .form-input[readonly] { background-color: #f9f9f9; color: #888; cursor: default; }
        .time-group { display: flex; align-items: center; gap: 10px; }
        .time-separator { color: #888; font-weight: 600; }
        .search-select-container { position: relative; width: 100%; }
        .search-input-wrap { position: relative; }
        .search-input-wrap i { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #aaa; }
        .dropdown-list { display: none; position: absolute; top: 100%; left: 0; width: 100%; max-height: 250px; overflow-y: auto; background: #fff; border: 1px solid #ddd; border-radius: 0 0 6px 6px; z-index: 100; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .dropdown-item { padding: 12px 15px; font-size: 14px; color: #333; cursor: pointer; border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between; }
        .dropdown-item:hover { background-color: #f5f6fa; color: #503396; }
        .movie-runtime-badge { font-size: 12px; color: #888; background: #eee; padding: 2px 6px; border-radius: 4px; }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 40px; padding-top: 20px; border-top: 1px solid #eee; }
        .btn-save { background-color: #503396; color: #fff; padding: 12px 30px; border-radius: 6px; font-weight: 700; transition: 0.2s; font-size: 15px; }
        .btn-save:hover { background-color: #3e257a; }
        .btn-cancel { background-color: #fff; border: 1px solid #ddd; color: #555; padding: 12px 30px; border-radius: 6px; font-weight: 600; transition: 0.2s; font-size: 15px; }
        .btn-cancel:hover { background-color: #f9f9f9; }
    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="logo-area"><a href="../admin_dashboard/Admin_Dashboard.jsp"><img src="../../resources/img/2GV_LOGO_empty.png"></a></div>
        <div class="menu-list">
            <div class="menu-category">MAIN</div>
            <ul><li><a href="../admin_dashboard/Admin_Dashboard.jsp" class="menu-link"><i class="fa-solid fa-chart-pie menu-icon"></i><span>메인 페이지</span></a></li></ul>
            <div class="menu-category">RESOURCE</div>
            <ul>
                <li><a href="../admin_usermanagement/Admin_UserManagement.jsp" class="menu-link"><i class="fa-solid fa-users menu-icon"></i><span>회원 관리</span></a></li>
                <li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link"><i class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="Admin_ScreeningList.jsp" class="menu-link active"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
    <div class="admin-avatar">
        <%= adminId != null && adminId.length() >= 2 ? adminId.substring(0, 2).toUpperCase() : "AD" %>
    </div>
    <div class="admin-info">
        <h4><%= adminId %></h4>
        <p>Admin Account</p>
    </div>
</div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>상영 스케줄 관리</h2>
                <p>영화 상영 일정을 조회, 등록, 수정, 삭제합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <div class="sub-nav">
                <a href="Admin_ScreeningList.jsp" class="sub-nav-item">스케줄 조회</a>
                <a href="Admin_ScreeningRegister.jsp" class="sub-nav-item active">스케줄 추가</a>
            </div>

            <div class="form-container">
                <div class="form-header">
                    <span class="form-title">신규 스케줄 등록</span>
                </div>

                <form id="scheduleForm" method="post" action="admin_screening_insert_process.jsp">
                    
                    <div class="form-group">
                        <label class="form-label">영화 선택 <span class="required">*</span></label>
                        <div class="search-select-container" id="movieSearchContainer">
                            <div class="search-input-wrap" onclick="toggleDropdown()">
                                <input type="text" class="form-input" id="selectedMovie" placeholder="영화를 검색 또는 선택하세요" readonly style="cursor:pointer;">
                                <i class="fa-solid fa-chevron-down"></i>
                                <input type="hidden" name="movie_code" id="hiddenMovieCode">
                                <input type="hidden" id="hiddenRuntime" value="0"> 
                            </div>
                            
                            <div class="dropdown-list" id="movieList">
                            <% 
                            if(movieList != null && !movieList.isEmpty()) { 
                                for(MovieDTO mDto : movieList) { 
                            %>
                                <div class="dropdown-item" onclick="selectMovie('<%= mDto.getMovieName() %>', '<%= mDto.getRunningTime() %>', '<%= mDto.getMovieCode() %>')">
                                    <span>[<%= mDto.getShowing() %>] <%= mDto.getMovieName() %></span> 
                                    <span class="movie-runtime-badge"><%= mDto.getRunningTime() %>분</span>
                                </div>
                            <%  
                                } 
                            } else {
                            %>
                                <div class="dropdown-item">등록 가능한 영화가 없습니다.</div>
                            <%
                            }
                            %>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">상영관 선택 <span class="required">*</span></label>
                        <select class="form-select" name="theater_num">
                            <option value="">상영관을 선택하세요</option>
                            <% 
                            if(theaterList != null) { 
                                for(TheaterDTO tDto : theaterList) { 
                                    // [수정] Availability가 'T'인 상영관만 표시
                                    if(tDto.getAvailability() != null && "T".equalsIgnoreCase(tDto.getAvailability().trim())) {
                            %>
                                <option value="<%= tDto.getTheatherNum() %>">
                                    <%= tDto.getTheatherName() %> (총 <%= tDto.getTotalSeat() %>석)
                                </option>
                            <%  
                                    } // if end
                                } // for end
                               } 
                            %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">상영 날짜 <span class="required">*</span></label>
                        <input type="date" class="form-input" name="screen_date" id="screen_date">
                    </div>

                    <div class="form-group">
                        <label class="form-label">상영 시간 (시작 ~ 종료) <span class="required">*</span></label>
                        <div class="time-group">
                            <input type="time" class="form-input" name="screen_time" id="startTime" onchange="calculateEndTime()">
                            <span class="time-separator">~</span>
                            <input type="time" class="form-input" name="endTime" id="endTime" readonly>
                        </div>
                        <p style="font-size:12px; color:#888; margin-top:5px;">
                            * 종료 시간은 영화의 러닝타임에 맞춰 자동 계산됩니다.
                        </p>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                        <button type="button" class="btn-save" onclick="saveSchedule()">등록</button>
                    </div>

                </form>
            </div>
        </div>
    </main>

    <script>
        function toggleDropdown() {
            const list = document.getElementById('movieList');
            list.style.display = (list.style.display === 'block') ? 'none' : 'block';
        }

        // 영화 선택 시
        function selectMovie(title, runtime, code) {
            document.getElementById('selectedMovie').value = title;
            document.getElementById('hiddenMovieCode').value = code; // PK 저장
            document.getElementById('hiddenRuntime').value = runtime; 
            
            toggleDropdown();
            calculateEndTime();
        }

        // 종료 시간 계산
        function calculateEndTime() {
            const startTime = document.getElementById('startTime').value;
            // DTO에서 String으로 넘어오므로 parseInt 필요
            const runtimeStr = document.getElementById('hiddenRuntime').value;
            const runtime = parseInt(runtimeStr);

            if (startTime && !isNaN(runtime) && runtime > 0) {
                const [hours, minutes] = startTime.split(':').map(Number);
                const date = new Date();
                date.setHours(hours);
                date.setMinutes(minutes + runtime);

                const endHours = String(date.getHours()).padStart(2, '0');
                const endMinutes = String(date.getMinutes()).padStart(2, '0');

                document.getElementById('endTime').value = endHours + ':' + endMinutes;
            }
        }

        window.addEventListener('click', function(e) {
            if (!e.target.closest('.search-select-container')) {
                document.getElementById('movieList').style.display = 'none';
            }
        });

        function saveSchedule() {
            const form = document.getElementById('scheduleForm');
            
            if(!form.movie_code.value) { alert('영화를 선택해주세요.'); return; }
            if(!form.theater_num.value) { alert('상영관을 선택해주세요.'); return; }
            if(!form.screen_date.value) { alert('상영 날짜를 선택해주세요.'); return; }
            if(!form.screen_time.value) { alert('상영 시작 시간을 입력해주세요.'); return; }

            form.submit(); 
        }
    </script>
</body>
</html>