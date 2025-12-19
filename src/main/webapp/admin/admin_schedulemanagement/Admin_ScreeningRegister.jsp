<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영 스케줄 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 공통 스타일 유지] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f5f6fa;
            color: #333;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select { font-family: 'Noto Sans KR', sans-serif; }

        /* [2. 사이드바] */
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

        /* [3. 메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* [4. 상단 탭] */
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }

        /* [5. 등록 폼 스타일] */
        .form-container {
            background: #fff; border-radius: 12px; padding: 40px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03); 
            max-width: 800px; margin: 0 auto;
        }
        .form-header { margin-bottom: 30px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .form-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }

        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 8px; }
        .required { color: #e74c3c; margin-left: 3px; }
        
        .form-input, .form-select {
            width: 100%; height: 45px; padding: 0 15px;
            border: 1px solid #ddd; border-radius: 6px;
            font-size: 14px; color: #555; background-color: #fff;
        }
        .form-input:focus, .form-select:focus { border-color: #503396; }
        .form-input[readonly] { background-color: #f9f9f9; color: #888; cursor: default; }

        /* 시간 입력 그룹 (시작 ~ 종료) */
        .time-group { display: flex; align-items: center; gap: 10px; }
        .time-separator { color: #888; font-weight: 600; }

        /* [검색형 드롭다운 (Movie Select)] */
        .search-select-container { position: relative; width: 100%; }
        .search-input-wrap { position: relative; }
        .search-input-wrap i { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #aaa; }
        
        .dropdown-list {
            display: none; position: absolute; top: 100%; left: 0; width: 100%;
            max-height: 250px; overflow-y: auto; background: #fff; border: 1px solid #ddd;
            border-radius: 0 0 6px 6px; z-index: 100; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .dropdown-item {
            padding: 12px 15px; font-size: 14px; color: #333; cursor: pointer;
            border-bottom: 1px solid #f5f5f5; display: flex; justify-content: space-between;
        }
        .dropdown-item:hover { background-color: #f5f6fa; color: #503396; }
        .movie-runtime-badge { font-size: 12px; color: #888; background: #eee; padding: 2px 6px; border-radius: 4px; }


        /* 하단 버튼 */
        .form-actions {
            display: flex; justify-content: flex-end; gap: 10px; margin-top: 40px; 
            padding-top: 20px; border-top: 1px solid #eee;
        }
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
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link active"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer"><div class="admin-avatar">AD</div><div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div></div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>상영 스케줄 관리</h2>
                <p>영화 상영 일정을 조회, 등록, 수정, 삭제합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
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

                <form id="scheduleForm">
                    
                    <div class="form-group">
                        <label class="form-label">영화 선택 <span class="required">*</span></label>
                        <div class="search-select-container" id="movieSearchContainer">
                            <div class="search-input-wrap" onclick="toggleDropdown()">
                                <input type="text" class="form-input" id="selectedMovie" placeholder="영화를 검색 또는 선택하세요" readonly style="cursor:pointer;">
                                <i class="fa-solid fa-chevron-down"></i>
                                <input type="hidden" name="movieTitle" id="hiddenMovieTitle">
                                <input type="hidden" id="hiddenRuntime" value="0"> </div>
                            
                            <div class="dropdown-list" id="movieList">
                                <div class="dropdown-item" onclick="selectMovie('범죄도시4', 109)">
                                    <span>범죄도시4</span> <span class="movie-runtime-badge">109분</span>
                                </div>
                                <div class="dropdown-item" onclick="selectMovie('퓨리오사: 매드맥스', 148)">
                                    <span>퓨리오사: 매드맥스</span> <span class="movie-runtime-badge">148분</span>
                                </div>
                                <div class="dropdown-item" onclick="selectMovie('인사이드 아웃 2', 96)">
                                    <span>인사이드 아웃 2</span> <span class="movie-runtime-badge">96분</span>
                                </div>
                                <div class="dropdown-item" onclick="selectMovie('설계자', 99)">
                                    <span>설계자</span> <span class="movie-runtime-badge">99분</span>
                                </div>
                                <div class="dropdown-item" onclick="selectMovie('원더랜드', 113)">
                                    <span>원더랜드</span> <span class="movie-runtime-badge">113분</span>
                                </div>
                                </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">상영관 선택 <span class="required">*</span></label>
                        <select class="form-select" name="theaterName">
                            <option value="">상영관을 선택하세요</option>
                            <script>
                                for(let i=1; i<=15; i++) {
                                    document.write('<option value="'+i+'상영관">'+i+'상영관</option>');
                                }
                            </script>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">상영 날짜 <span class="required">*</span></label>
                        <input type="date" class="form-input" name="screenDate">
                    </div>

                    <div class="form-group">
                        <label class="form-label">상영 시간 (시작 ~ 종료) <span class="required">*</span></label>
                        <div class="time-group">
                            <input type="time" class="form-input" name="startTime" id="startTime" onchange="calculateEndTime()">
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
        // [1] 영화 선택 드롭다운 토글
        function toggleDropdown() {
            const list = document.getElementById('movieList');
            list.style.display = (list.style.display === 'block') ? 'none' : 'block';
        }

        // [2] 영화 선택 시 동작
        function selectMovie(title, runtime) {
            document.getElementById('selectedMovie').value = title;
            document.getElementById('hiddenMovieTitle').value = title;
            document.getElementById('hiddenRuntime').value = runtime; // 러닝타임 저장
            
            toggleDropdown(); // 닫기
            calculateEndTime(); // 시간 재계산
        }

        // [3] 종료 시간 자동 계산
        function calculateEndTime() {
            const startTime = document.getElementById('startTime').value;
            const runtime = parseInt(document.getElementById('hiddenRuntime').value);

            if (startTime && runtime > 0) {
                const [hours, minutes] = startTime.split(':').map(Number);
                
                // 날짜 객체로 계산
                const date = new Date();
                date.setHours(hours);
                date.setMinutes(minutes + runtime); // 러닝타임 더하기

                // HH:MM 형식으로 변환
                const endHours = String(date.getHours()).padStart(2, '0');
                const endMinutes = String(date.getMinutes()).padStart(2, '0');

                document.getElementById('endTime').value = endHours + ':' + endMinutes;
            }
        }

        // 외부 클릭 시 드롭다운 닫기
        window.addEventListener('click', function(e) {
            if (!e.target.closest('.search-select-container')) {
                document.getElementById('movieList').style.display = 'none';
            }
        });

        // [4] 저장 버튼
        function saveSchedule() {
            // 유효성 검사 예시
            if(!document.getElementById('hiddenMovieTitle').value) { alert('영화를 선택해주세요.'); return; }
            if(!document.getElementById('startTime').value) { alert('상영 시작 시간을 입력해주세요.'); return; }

            alert('스케줄이 성공적으로 등록되었습니다.');
            location.href = 'Admin_ScreeningList.jsp';
        }
    </script>

</body>
</html>