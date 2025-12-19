<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 영화 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 공통 스타일 유지] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select, textarea { font-family: 'Noto Sans KR', sans-serif; }

        /* [사이드바] */
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

        /* [메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* [탭] */
        .sub-nav { display: flex; gap: 30px; border-bottom: 1px solid #e1e1e1; margin-bottom: 30px; padding-bottom: 15px; }
        .sub-nav-item { font-size: 16px; font-weight: 700; color: #aaa; cursor: pointer; text-decoration: none; position: relative; padding-bottom: 15px; transition: 0.2s; }
        .sub-nav-item:hover { color: #503396; }
        .sub-nav-item.active { color: #1e1e2d; }
        .sub-nav-item.active::after { content: ''; position: absolute; bottom: -1px; left: 0; width: 100%; height: 3px; background-color: #503396; }

        /* [검색 & 테이블] */
        .filter-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); margin-bottom: 25px; display: flex; gap: 10px; align-items: center; }
        .filter-input { height: 45px; border: 1px solid #ddd; border-radius: 6px; padding: 0 15px; font-size: 14px; color: #555; }
        .filter-input-long { flex: 1; }
        .filter-btn { height: 45px; padding: 0 30px; background-color: #1e1e2d; color: #fff; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .filter-btn:hover { background-color: #333; }
        
        .table-container { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        tbody tr { cursor: pointer; transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }

        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }

        .grade-badge { padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; color: #fff; }
        .grade-all { background-color: #27ae60; }
        .grade-12 { background-color: #f39c12; }
        .grade-15 { background-color: #e67e22; }
        .grade-19 { background-color: #c0392b; }


        /* [상세 모달 스타일] */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); z-index: 2000;
            justify-content: center; align-items: center;
        }
        
        .movie-modal-card {
            background-color: #fff; width: 850px; 
            border-radius: 15px; overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.3);
            animation: slideUp 0.3s ease-out;
            display: flex; flex-direction: column;
        }
        @keyframes slideUp { from { transform: translateY(50px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }

        .modal-header {
            padding: 20px 30px; background-color: #f9f9f9; border-bottom: 1px solid #eee;
            display: flex; justify-content: space-between; align-items: center;
        }
        .modal-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }
        .modal-close { font-size: 24px; color: #aaa; cursor: pointer; }
        .modal-close:hover { color: #333; }

        /* 모달 본문 */
        .modal-body { padding: 40px; display: flex; gap: 40px; align-items: flex-start; }
        
        /* 좌측: 포스터 */
        .movie-poster-area { width: 260px; flex-shrink: 0; text-align: center; position: relative; }
        .movie-poster {
            width: 100%; height: 380px; object-fit: cover; border-radius: 10px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2); margin-bottom: 15px;
            background-color: #eee;
        }
        .img-upload-btn {
            display: none; width: 100%; padding: 10px; background-color: #eee; color: #555;
            border: 1px solid #ddd; border-radius: 6px; font-size: 13px; font-weight: 600;
            cursor: pointer; margin-bottom: 10px;
        }
        .img-upload-btn:hover { background-color: #e0e0e0; }

        /* 우측: 상세 정보 */
        .movie-info-area { flex: 1; display: flex; flex-direction: column; gap: 15px; }
        .info-group { display: flex; flex-direction: column; position: relative; }
        .info-label { font-size: 13px; font-weight: 700; color: #888; margin-bottom: 5px; }
        .info-text { font-size: 15px; color: #333; padding: 8px 0; border-bottom: 1px solid #f0f0f0; min-height: 36px; }
        .title-text { font-size: 22px; font-weight: 800; color: #1e1e2d; border: none; padding: 0; margin-bottom: 10px; }

        /* 수정 모드 (입력창) */
        .info-input, .info-select {
            display: none; width: 100%; height: 38px; padding: 0 10px;
            border: 1px solid #ddd; border-radius: 4px; font-size: 14px; background-color: #fff;
        }
        .info-input:focus, .info-select:focus { border-color: #503396; }
        
        .intro-box {
            background-color: #f9f9f9; padding: 15px; border-radius: 8px;
            font-size: 14px; line-height: 1.6; color: #555; height: 100px; overflow-y: auto; margin-top: 5px;
        }
        .intro-input {
            display: none; width: 100%; height: 100px; padding: 10px;
            border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize: none; line-height: 1.6;
        }

        /* [--- NEW: 멀티 선택 검색형 드롭다운 스타일 ---] */
        .multi-select-container {
            display: none; position: relative; width: 100%;
        }
        .selected-tags {
            display: flex; flex-wrap: wrap; gap: 5px; padding: 5px;
            border: 1px solid #ddd; border-radius: 4px; min-height: 38px;
            background-color: #fff; cursor: text;
        }
        .tag {
            background-color: #e8fff3; color: #1bc5bd; font-size: 12px; font-weight: 600;
            padding: 4px 8px; border-radius: 4px; display: flex; align-items: center; gap: 5px;
        }
        .tag-close { cursor: pointer; font-weight: bold; }
        
        .search-input-inner {
            border: none; outline: none; font-size: 14px; flex: 1; min-width: 80px;
        }
        .dropdown-list {
            display: none; position: absolute; top: 100%; left: 0; width: 100%;
            max-height: 200px; overflow-y: auto; background: #fff; border: 1px solid #ddd;
            border-radius: 0 0 4px 4px; z-index: 10; box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .dropdown-item { padding: 10px; font-size: 14px; cursor: pointer; transition: 0.2s; }
        .dropdown-item:hover { background-color: #f5f5f5; color: #503396; }


        /* 하단 버튼 */
        .modal-footer {
            padding: 20px 30px; background-color: #f9f9f9; border-top: 1px solid #eee;
            display: flex; justify-content: flex-end; gap: 10px;
        }
        .btn-md { padding: 10px 25px; border-radius: 6px; font-weight: 600; font-size: 14px; cursor: pointer; transition: 0.2s; border: none; }
        .btn-edit { background-color: #503396; color: #fff; }
        .btn-edit:hover { background-color: #3e257a; }
        .btn-del { background-color: #fdedec; color: #e74c3c; border: 1px solid #fadbd8; }
        .btn-del:hover { background-color: #fceae9; }
        
        .btn-save-group { display: none; }
        .btn-save { background-color: #1bc5bd; color: #fff; }
        .btn-cancel { background-color: #fff; border: 1px solid #ddd; color: #555; }

        /* [확인 모달] */
        .confirm-card {
            background-color: #fff; width: 400px; border-radius: 12px; text-align: center;
            padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        .confirm-icon { font-size: 40px; color: #503396; margin-bottom: 20px; }
        .confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
        .confirm-actions { display: flex; justify-content: center; gap: 10px; }

    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="logo-area">
            <a href="../admin_dashboard/Admin_Dashboard.jsp"><img src="../../resources/img/2GV_LOGO_empty.png"></a>
        </div>
        <div class="menu-list">
            <div class="menu-category">MAIN</div>
            <ul><li><a href="../admin_dashboard/Admin_Dashboard.jsp" class="menu-link"><i class="fa-solid fa-chart-pie menu-icon"></i><span>메인 페이지</span></a></li></ul>
            <div class="menu-category">RESOURCE</div>
            <ul>
                <li><a href="../admin_usermanagement/Admin_UserManagement.jsp" class="menu-link"><i class="fa-solid fa-users menu-icon"></i><span>회원 관리</span></a></li>
                <li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link"><i class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link active"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer">
            <div class="admin-avatar">AD</div>
            <div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div>
        </div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title"><h2>영화 관리</h2><p>등록된 영화 정보를 조회, 수정, 삭제합니다.</p></div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <div class="sub-nav">
                <a href="Admin_MovieList.jsp" class="sub-nav-item active">영화 조회</a>
                <a href="Admin_MovieRegister.jsp" class="sub-nav-item">영화 등록</a>
            </div>
            <div class="filter-card">
                <select class="filter-input"><option value="title">영화명</option><option value="director">감독</option><option value="actor">출연진</option></select>
                <input type="text" class="filter-input filter-input-long" placeholder="검색어를 입력하세요">
                <button class="filter-btn">조회</button>
            </div>

            <div class="table-container">
                <div class="table-header"><p class="total-count">총 <span>15</span>개의 영화가 검색되었습니다.</p></div>
                <table>
                    <colgroup><col width="18%"> <col width="10%"> <col width="10%"> <col width="12%"> <col width="12%"> <col width="13%"> <col width="25%"></colgroup>
                    <thead>
                        <tr><th>영화명</th><th>장르</th><th>상영 시간</th><th>관람 등급</th><th>개봉일</th><th>감독</th><th>출연진</th></tr>
                    </thead>
                    <tbody>
                        <tr onclick="openDetailModal(this)">
                            <td>범죄도시4</td><td>액션</td><td>109분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-04-24</td><td>허명행</td><td>마동석, 김무열, 박지환</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_crimecity4.jpg">
                            <input type="hidden" class="movie-intro" value="괴물형사 마석도, 이번엔 온라인 불법 도박 조직을 소탕한다!">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>퓨리오사: 매드맥스</td><td>액션</td><td>148분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-05-22</td><td>조지 밀러</td><td>안야 테일러 조이</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_furiosa.jpg">
                            <input type="hidden" class="movie-intro" value="문명 붕괴 45년 후, 황무지를 떠돌던 퓨리오사가 고향으로 돌아가기 위해 모든 것을 건다.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>인사이드 아웃 2</td><td>애니메이션</td><td>96분</td><td><span class="grade-badge grade-all">전체 관람가</span></td><td>2024-06-12</td><td>켈시 만</td><td>에이미 포, 마야 호크</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_insideout2.jpg">
                            <input type="hidden" class="movie-intro" value="13살이 된 라일리의 머릿속 감정 컨트롤 본부에 새로운 감정들이 등장한다!">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>설계자</td><td>범죄</td><td>99분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-05-29</td><td>이요섭</td><td>강동원, 이무생, 이미숙</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="의뢰받은 청부 살인을 완벽한 사고사로 조작하는 설계자 영일.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>원더랜드</td><td>드라마</td><td>113분</td><td><span class="grade-badge grade-12">12세 관람가</span></td><td>2024-06-05</td><td>김태용</td><td>탕웨이, 수지, 박보검</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="죽은 사람을 인공지능으로 복원하는 영상통화 서비스 원더랜드.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>하이재킹</td><td>스릴러</td><td>100분</td><td><span class="grade-badge grade-12">12세 관람가</span></td><td>2024-06-21</td><td>김성한</td><td>하정우, 여진구, 성동일</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="1971년 겨울 속초공항, 여객기 납치 사건이 발생한다.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>콰이어트 플레이스</td><td>공포</td><td>100분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-06-26</td><td>마이클 사노스키</td><td>루피타 뇽오, 조셉 퀸</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="소리를 내는 순간 공격하는 괴생명체의 출현으로 전 세계가 파괴된다.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>탈주</td><td>액션</td><td>94분</td><td><span class="grade-badge grade-12">12세 관람가</span></td><td>2024-07-03</td><td>이종필</td><td>이제훈, 구교환</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="내일을 위한 탈주를 시작한 북한병사 규남과 그를 쫓는 보위부 장교 현상.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>데드풀과 울버린</td><td>액션</td><td>127분</td><td><span class="grade-badge grade-19">청소년 불가</span></td><td>2024-07-24</td><td>숀 레비</td><td>라이언 레이놀즈, 휴 잭맨</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="히어로 생활에서 은퇴한 데드풀이 위기를 맞아 울버린을 찾아간다.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>파일럿</td><td>코미디</td><td>110분</td><td><span class="grade-badge grade-12">12세 관람가</span></td><td>2024-07-31</td><td>김한결</td><td>조정석, 이주명, 한선화</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="하루 아침에 인생 추락한 스타 파일럿 한정우의 파격 변신 프로젝트.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>리볼버</td><td>범죄</td><td>114분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-08-07</td><td>오승욱</td><td>전도연, 지창욱, 임지연</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="모든 죄를 뒤집어쓰고 교도소에 들어갔던 전직 경찰 수영이 출소 후 오직 하나의 목적을 향해 직진한다.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>에이리언: 로물루스</td><td>SF/공포</td><td>119분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-08-14</td><td>페데 알바레즈</td><td>케일리 스패니</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="버려진 우주 정거장 로물루스에서 마주한 공포.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>행복의 나라</td><td>드라마</td><td>124분</td><td><span class="grade-badge grade-12">12세 관람가</span></td><td>2024-08-14</td><td>추창민</td><td>조정석, 이선균</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="1979년 대통령 암살 사건 재판을 다룬 이야기.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>베테랑2</td><td>액션</td><td>118분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-09-13</td><td>류승완</td><td>황정민, 정해인</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="나쁜 놈은 끝까지 잡는 베테랑 서도철 형사의 강력범죄수사대에 막내 박선우가 합류한다.">
                        </tr>
                        <tr onclick="openDetailModal(this)">
                            <td>조커: 폴리 아 되</td><td>스릴러</td><td>138분</td><td><span class="grade-badge grade-15">15세 관람가</span></td><td>2024-10-01</td><td>토드 필립스</td><td>호아킨 피닉스, 레이디 가가</td>
                            <input type="hidden" class="movie-poster" value="../images/poster_sample.jpg">
                            <input type="hidden" class="movie-intro" value="아서 플렉은 수감 중 할리 퀸을 만나 운명적인 사랑에 빠진다.">
                        </tr>
                    </tbody>
                </table>
                <div class="pagination"><a href="#" class="page-link active">1</a></div>
            </div>
        </div>
    </main>


    <div id="detailModal" class="modal-overlay">
        <div class="movie-modal-card">
            <div class="modal-header">
                <span class="modal-title">영화 상세 정보</span>
                <i class="fa-solid fa-xmark modal-close" onclick="closeDetailModal()"></i>
            </div>
            
            <div class="modal-body">
                <div class="movie-poster-area">
                    <img src="" id="viewPoster" class="movie-poster">
                    <button type="button" id="btnChangeImg" class="img-upload-btn"><i class="fa-solid fa-camera"></i> 이미지 변경</button>
                    <input type="file" id="fileInput" style="display:none" onchange="previewImage(this)">
                    
                    <div class="info-group" style="text-align: center;">
                        <div id="viewTitle" class="title-text"></div>
                        <input type="text" id="editTitle" class="info-input" style="text-align:center; font-weight:bold; font-size:18px;">
                    </div>
                </div>

                <div class="movie-info-area">
                    
                    <div class="info-group">
                        <label class="info-label">장르</label>
                        <div id="viewGenre" class="info-text"></div>
                        <select id="editGenre" class="info-select">
                            <option value="액션">액션</option><option value="범죄">범죄</option><option value="코미디">코미디</option>
                            <option value="드라마">드라마</option><option value="SF">SF</option><option value="애니메이션">애니메이션</option>
                        </select>
                    </div>

                    <div class="info-group">
                        <label class="info-label">상영 시간</label>
                        <div id="viewRuntime" class="info-text"></div>
                        <input type="text" id="editRuntime" class="info-input">
                    </div>

                    <div class="info-group">
                        <label class="info-label">관람 등급</label>
                        <div id="viewGrade" class="info-text"></div>
                        <select id="editGrade" class="info-select">
                            <option value="전체 관람가">전체 관람가</option><option value="12세 관람가">12세 관람가</option>
                            <option value="15세 관람가">15세 관람가</option><option value="청소년 불가">청소년 불가</option>
                        </select>
                    </div>

                    <div class="info-group">
                        <label class="info-label">개봉일</label>
                        <div id="viewDate" class="info-text"></div>
                        <input type="text" id="editDate" class="info-input">
                    </div>

                    <div class="info-group">
                        <label class="info-label">감독</label>
                        <div id="viewDirector" class="info-text"></div>
                        
                        <div id="editDirectorContainer" class="multi-select-container">
                            <div class="selected-tags" onclick="toggleDropdown('directorList')">
                                <input type="text" class="search-input-inner" placeholder="검색..." onkeyup="filterList('directorList', this.value)">
                            </div>
                            <div id="directorList" class="dropdown-list">
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '봉준호')">봉준호</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '박찬욱')">박찬욱</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '류승완')">류승완</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '최동훈')">최동훈</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '나홍진')">나홍진</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '김지운')">김지운</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '이준익')">이준익</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '장훈')">장훈</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '장철수')">장철수</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '추창민')">추창민</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '한재림')">한재림</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '김용화')">김용화</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '이재규')">이재규</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '이석훈')">이석훈</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '김한민')">김한민</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '이창동')">이창동</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '홍상수')">홍상수</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '연상호')">연상호</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '허진호')">허진호</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '장준환')">장준환</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '이병헌')">이병헌</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '민규동')">민규동</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '변영주')">변영주</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '이해영')">이해영</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '김태용')">김태용</div>

    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '크리스토퍼 놀란')">크리스토퍼 놀란</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '스티븐 스필버그')">스티븐 스필버그</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '제임스 카메론')">제임스 카메론</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '쿠엔틴 타란티노')">쿠엔틴 타란티노</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '마틴 스코세이지')">마틴 스코세이지</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '리들리 스콧')">리들리 스콧</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '데이비드 핀처')">데이비드 핀처</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '웨스 앤더슨')">웨스 앤더슨</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '팀 버튼')">팀 버튼</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '조지 밀러')">조지 밀러</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '피터 잭슨')">피터 잭슨</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '알폰소 쿠아론')">알폰소 쿠아론</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '기예르모 델 토로')">기예르모 델 토로</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '드니 빌뇌브')">드니 빌뇌브</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '신카이 마코토')">신카이 마코토</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '미야자키 하야오')">미야자키 하야오</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '고레에다 히로카즈')">고레에다 히로카즈</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '대런 아로노프스키')">대런 아로노프스키</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '데이미언 셔젤')">데이미언 셔젤</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '조던 필')">조던 필</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '그레타 거윅')">그레타 거윅</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '제임스 건')">제임스 건</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '토드 필립스')">토드 필립스</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', '마이클 베이')">마이클 베이</div>
    <div class="dropdown-item" onclick="addTag('editDirectorContainer', 'J.J. 에이브럼스')">J.J. 에이브럼스</div>
</div>
                        </div>
                    </div>

                    <div class="info-group">
                        <label class="info-label">출연진</label>
                        <div id="viewCast" class="info-text"></div>
                        
                        <div id="editCastContainer" class="multi-select-container">
                            <div class="selected-tags" onclick="toggleDropdown('castList')">
                                <input type="text" class="search-input-inner" placeholder="검색..." onkeyup="filterList('castList', this.value)">
                            </div>
                            <div id="castList" class="dropdown-list">
    <div class="dropdown-item" onclick="addTag('editCastContainer', '마동석')">마동석</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '손석구')">손석구</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '김무열')">김무열</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '박지환')">박지환</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '이동휘')">이동휘</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '황정민')">황정민</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '이정재')">이정재</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '정우성')">정우성</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '송강호')">송강호</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '최민식')">최민식</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '설경구')">설경구</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '이병헌')">이병헌</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '하정우')">하정우</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '김윤석')">김윤석</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '유해진')">유해진</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '조진웅')">조진웅</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '박해일')">박해일</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '류승룡')">류승룡</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '강동원')">강동원</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '공유')">공유</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '현빈')">현빈</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '조인성')">조인성</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '김남길')">김남길</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '김혜수')">김혜수</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '전도연')">전도연</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '손예진')">손예진</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '전지현')">전지현</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '한효주')">한효주</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '김태리')">김태리</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '김고은')">김고은</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '박소담')">박소담</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '박보검')">박보검</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '조정석')">조정석</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '정해인')">정해인</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '이선균')">이선균</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '주지훈')">주지훈</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '임시완')">임시완</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '변요한')">변요한</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '구교환')">구교환</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '이제훈')">이제훈</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '최우식')">최우식</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '안재홍')">안재홍</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '류준열')">류준열</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '박서준')">박서준</div>

    <div class="dropdown-item" onclick="addTag('editCastContainer', '톰 크루즈')">톰 크루즈</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '레오나르도 디카프리오')">레오나르도 디카프리오</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '브래드 피트')">브래드 피트</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '조니 뎁')">조니 뎁</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '로버트 다우니 주니어')">로버트 다우니 주니어</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '크리스 헴스워스')">크리스 헴스워스</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '크리스 에반스')">크리스 에반스</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '스칼렛 요한슨')">스칼렛 요한슨</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '엠마 스톤')">엠마 스톤</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '제니퍼 로렌스')">제니퍼 로렌스</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '톰 홀랜드')">톰 홀랜드</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '티모시 샬라메')">티모시 샬라메</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '젠데이아')">젠데이아</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '안야 테일러 조이')">안야 테일러 조이</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '킬리언 머피')">킬리언 머피</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '호아킨 피닉스')">호아킨 피닉스</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '레이디 가가')">레이디 가가</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '라이언 레이놀즈')">라이언 레이놀즈</div>
    <div class="dropdown-item" onclick="addTag('editCastContainer', '휴 잭맨')">휴 잭맨</div>
</div>
                        </div>
                    </div>

                    <div class="info-group">
                        <label class="info-label">소개</label>
                        <div id="viewIntro" class="intro-box"></div>
                        <textarea id="editIntro" class="intro-input"></textarea>
                    </div>

                </div>
            </div>

            <div class="modal-footer">
                <div id="viewBtns">
                    <button class="btn-md btn-edit" onclick="toggleEditMode(true)">수정</button>
                    <button class="btn-md btn-del" onclick="openConfirmModal('delete')">삭제</button>
                </div>
                <div id="editBtns" class="btn-save-group">
                    <button class="btn-md btn-cancel" onclick="toggleEditMode(false)">취소</button>
                    <button class="btn-md btn-save" onclick="openConfirmModal('save')">저장</button>
                </div>
            </div>
        </div>
    </div>

    <div id="confirmModal" class="modal-overlay" style="z-index: 2100;">
        <div class="confirm-card">
            <div class="confirm-icon"><i class="fa-solid fa-circle-question"></i></div>
            <div id="confirmTitle" class="confirm-text"></div>
            <div id="confirmSub" class="confirm-sub"></div>
            <div class="confirm-actions">
                <button class="btn-md btn-cancel" onclick="closeConfirmModal()">아니오</button>
                <button id="confirmOkBtn" class="btn-md btn-save">예</button>
            </div>
        </div>
    </div>

    <script>
        // [1. 상세 모달 열기]
        function openDetailModal(tr) {
            const cells = tr.children;
            
            // 데이터 추출
            const data = {
                title: cells[0].innerText, genre: cells[1].innerText,
                runtime: cells[2].innerText, grade: cells[3].innerText,
                date: cells[4].innerText, director: cells[5].innerText,
                cast: cells[6].innerText,
                poster: tr.querySelector('.movie-poster').value,
                intro: tr.querySelector('.movie-intro').value
            };

            // 뷰 채우기
            document.getElementById('viewTitle').innerText = data.title;
            document.getElementById('viewGenre').innerText = data.genre;
            document.getElementById('viewRuntime').innerText = data.runtime;
            document.getElementById('viewGrade').innerText = data.grade;
            document.getElementById('viewDate').innerText = data.date;
            document.getElementById('viewDirector').innerText = data.director;
            document.getElementById('viewCast').innerText = data.cast;
            document.getElementById('viewIntro').innerText = data.intro;
            document.getElementById('viewPoster').src = data.poster ? data.poster : 'https://via.placeholder.com/250x360';

            // 입력폼 채우기
            document.getElementById('editTitle').value = data.title;
            document.getElementById('editGenre').value = data.genre;
            document.getElementById('editRuntime').value = data.runtime;
            document.getElementById('editGrade').value = data.grade;
            document.getElementById('editDate').value = data.date;
            document.getElementById('editIntro').value = data.intro;

            // 멀티 태그 초기화
            initTags('editDirectorContainer', data.director);
            initTags('editCastContainer', data.cast);

            toggleEditMode(false);
            document.getElementById('detailModal').style.display = 'flex';
        }

        function closeDetailModal() { document.getElementById('detailModal').style.display = 'none'; }

        // [2. 수정 모드 토글]
        function toggleEditMode(isEdit) {
            const texts = document.querySelectorAll('.info-text, .title-text, .intro-box');
            const inputs = document.querySelectorAll('.info-input, .info-select, .intro-input');
            const multis = document.querySelectorAll('.multi-select-container'); // 멀티 셀렉트
            
            if (isEdit) {
                texts.forEach(el => el.style.display = 'none');
                inputs.forEach(el => el.style.display = 'block');
                multis.forEach(el => el.style.display = 'block');
                
                document.getElementById('btnChangeImg').style.display = 'block';
                document.getElementById('viewBtns').style.display = 'none';
                document.getElementById('editBtns').style.display = 'flex';
                
                document.getElementById('btnChangeImg').onclick = function() { document.getElementById('fileInput').click(); };
            } else {
                texts.forEach(el => el.style.display = 'block');
                inputs.forEach(el => el.style.display = 'none');
                multis.forEach(el => el.style.display = 'none');
                
                document.getElementById('btnChangeImg').style.display = 'none';
                document.getElementById('viewBtns').style.display = 'flex';
                document.getElementById('editBtns').style.display = 'none';
            }
        }

        // [3. 멀티 태그 기능]
        function initTags(containerId, text) {
            const container = document.getElementById(containerId).querySelector('.selected-tags');
            // 기존 태그 삭제 (input 제외)
            Array.from(container.children).forEach(child => {
                if (!child.classList.contains('search-input-inner')) container.removeChild(child);
            });
            
            if(!text) return;
            const items = text.split(', ');
            items.forEach(item => addTag(containerId, item));
        }

        function addTag(containerId, value) {
            const container = document.getElementById(containerId).querySelector('.selected-tags');
            const input = container.querySelector('.search-input-inner');
            
            // 중복 체크
            const exists = Array.from(container.querySelectorAll('.tag')).some(t => t.innerText.includes(value));
            if (exists) return;

            const tag = document.createElement('div');
            tag.className = 'tag';
            tag.innerHTML = value + ' <span class="tag-close" onclick="removeTag(this)">x</span>';
            container.insertBefore(tag, input);
        }

        function removeTag(element) {
            element.parentElement.remove();
        }

        function toggleDropdown(listId) {
            const list = document.getElementById(listId);
            list.style.display = (list.style.display === 'block') ? 'none' : 'block';
        }

        function filterList(listId, keyword) {
            const list = document.getElementById(listId);
            list.style.display = 'block';
            const items = list.getElementsByClassName('dropdown-item');
            for (let item of items) {
                if (item.innerText.includes(keyword)) item.style.display = 'block';
                else item.style.display = 'none';
            }
        }

        // 외부 클릭 시 드롭다운 닫기
        window.addEventListener('click', function(e) {
            if (!e.target.closest('.multi-select-container')) {
                document.querySelectorAll('.dropdown-list').forEach(el => el.style.display = 'none');
            }
        });


        // [4. 확인 모달]
        function openConfirmModal(action) {
            const modal = document.getElementById('confirmModal');
            const title = document.getElementById('confirmTitle');
            const sub = document.getElementById('confirmSub');
            const okBtn = document.getElementById('confirmOkBtn');

            if (action === 'save') {
                title.innerText = "수정 사항을 저장하시겠습니까?";
                sub.innerText = "변경된 내용이 시스템에 반영됩니다.";
                okBtn.innerText = "예";
                okBtn.onclick = function() {
                    alert('수정 사항을 저장하였습니다.');
                    closeConfirmModal();
                    closeDetailModal();
                };
            } else if (action === 'delete') {
                title.innerText = "정말 삭제하시겠습니까?";
                sub.innerText = "삭제된 데이터는 복구할 수 없습니다.";
                okBtn.innerText = "예";
                okBtn.onclick = function() {
                    alert('삭제되었습니다.');
                    closeConfirmModal();
                    closeDetailModal();
                };
            }
            modal.style.display = 'flex';
        }
        function closeConfirmModal() { document.getElementById('confirmModal').style.display = 'none'; }
    </script>

</body>
</html>