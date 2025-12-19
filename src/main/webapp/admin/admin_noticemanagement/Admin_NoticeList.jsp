<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 공지사항 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        /* [1. 초기화 & 공통] */
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
        .sidebar {
            width: 260px;
            background-color: #1e1e2d;
            color: #a2a3b7;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            transition: all 0.3s;
        }
        .logo-area {
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #1b1b28;
            border-bottom: 1px solid #2d2d3f;
        }
        .logo-area img { height: 45px; object-fit: contain; display: block; }
        
        .menu-list { padding: 20px 0; flex: 1; overflow-y: auto; }
        .menu-category {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            color: #5e6278;
            padding: 10px 25px;
            margin-top: 15px;
        }
        .menu-category:first-child { margin-top: 0; }
        
        .menu-link {
            display: flex;
            align-items: center;
            padding: 12px 25px;
            color: #a2a3b7;
            font-size: 14px;
            font-weight: 500;
            transition: 0.2s;
            border-left: 3px solid transparent;
        }
        .menu-link:hover, .menu-link.active {
            background-color: #2b2b40;
            color: #fff;
            border-left-color: #503396;
        }
        .menu-icon { width: 25px; font-size: 16px; text-align: center; margin-right: 10px; }

        .sidebar-footer {
            padding: 20px;
            border-top: 1px solid #2d2d3f;
            display: flex;
            align-items: center;
            gap: 12px;
            background-color: #1e1e2d;
        }
        .admin-avatar {
            width: 40px; height: 40px;
            background-color: #503396;
            border-radius: 50%;
            display: flex; justify-content: center; align-items: center;
            color: #fff; font-weight: bold; font-size: 14px;
        }
        .admin-info h4 { font-size: 14px; color: #fff; font-weight: 500; margin-bottom: 2px; }
        .admin-info p { font-size: 12px; color: #727589; }

        /* [3. 메인 컨텐츠] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        
        .top-header {
            height: 80px; 
            background-color: #ffffff; 
            border-bottom: 1px solid #e1e1e1;
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            padding: 0 30px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
        }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        
        .logout-btn {
            padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff;
            border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s;
        }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }

        /* [4. 본문 컨텐츠] */
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* 테이블 영역 */
        .table-container {
            background: #fff; border-radius: 12px; padding: 25px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03);
        }
        .table-header {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;
        }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        /* [공지사항 작성 버튼] */
        .btn-write {
            padding: 10px 20px;
            border-radius: 6px;
            background-color: #503396;
            color: #fff;
            font-weight: 700;
            font-size: 14px;
            display: flex; align-items: center; gap: 5px;
            transition: 0.2s;
        }
        .btn-write:hover { background-color: #3e257a; }

        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        
        th {
            background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center;
            padding: 15px 10px; border-bottom: 1px solid #eee;
        }
        td {
            padding: 15px 10px; border-bottom: 1px solid #f5f5f5;
            color: #3f4254; text-align: center; vertical-align: middle;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        tbody tr { cursor: pointer; transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }

        /* 제목은 왼쪽 정렬 */
        td.text-left { text-align: left; padding-left: 20px; }

        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link {
            width: 35px; height: 35px; display: flex; justify-content: center; align-items: center;
            border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s;
        }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }

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
                <li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link"><i class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>
            </ul>
            <div class="menu-category">SERVICE</div>
            <ul>
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link active"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
            </ul>
        </div>
        <div class="sidebar-footer"><div class="admin-avatar">AD</div><div class="admin-info"><h4>최고관리자</h4><p>Super Admin</p></div></div>
    </nav>

    <main class="main-content">
        <header class="top-header">
            <div class="header-left-title">
                <h2>공지사항 관리</h2>
                <p>공지사항을 등록하고 조회합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span>120</span>건의 공지사항이 있습니다.</p>
                    
                    <button class="btn-write" onclick="location.href='Admin_NoticeWrite.jsp'">
                        <i class="fa-solid fa-pen"></i> 공지사항 작성
                    </button>
                </div>

                <table>
                    <colgroup>
                        <col width="10%"> <col width="50%"> <col width="20%"> <col width="20%"> </colgroup>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>제목</th>
                            <th>등록일</th>
                            <th>조회수</th>
                        </tr>
                    </thead>
                    <tbody id="noticeTableBody">
                        </tbody>
                </table>

                <div class="pagination">
                    <a href="#" class="page-link active">1</a>
                    <a href="#" class="page-link">2</a>
                    <a href="#" class="page-link">3</a>
                    <a href="#" class="page-link">4</a>
                    <a href="#" class="page-link">5</a>
                </div>
            </div>
        </div>
    </main>

    <script>
        window.onload = function() {
            renderTable();
        };

        function renderTable() {
            const tbody = document.getElementById('noticeTableBody');
            var html = "";

            // 다양한 공지사항 데이터 배열
            var notices = [
                { title: "[공지] 2025학년도 대학수학능력시험 수험생 할인 이벤트 안내", type: "event" },
                { title: "[시스템] 12월 정기 서버 점검 안내 (12/05)", type: "system" },
                { title: "[이벤트] 2GV 멤버십 VIP 혜택 변경 안내", type: "event" },
                { title: "[무대인사] 영화 <범죄도시4> 개봉주 무대인사 일정", type: "event" },
                { title: "[안내] 겨울철 상영관 적정 온도 유지 안내", type: "info" },
                { title: "[채용] 2GV 하반기 공개 채용 합격자 발표", type: "recruit" },
                { title: "[공지] 개인정보 처리방침 개정 안내 (2025.01.01 시행)", type: "system" },
                { title: "[이벤트] 크리스마스 기념 커플 콤보 할인", type: "event" },
                { title: "[안내] 외부 음식물 반입 규정 안내", type: "info" },
                { title: "[제휴] T멤버십 12월 VIP 초이스 혜택", type: "event" },
                { title: "[시스템] 간편결제 서비스(카카오페이) 점검 안내", type: "system" },
                { title: "[공지] 주차장 이용 요금 변경 안내", type: "info" },
                { title: "[특전] <인사이드 아웃 2> 오리지널 티켓 증정", type: "event" },
                { title: "[안내] 분실물 센터 운영 시간 변경 안내", type: "info" },
                { title: "[채용] 2026년 상반기 신입사원 모집 공고", type: "recruit" }
            ];

            // 15개 행 생성 (번호 내림차순 120 ~ 106)
            for (var i = 0; i < 15; i++) {
                var notice = notices[i];
                var num = 120 - i;
                
                // 날짜 생성 (오늘부터 하루씩 과거로)
                var dateObj = new Date();
                dateObj.setDate(dateObj.getDate() - i);
                var year = dateObj.getFullYear();
                var month = String(dateObj.getMonth() + 1).padStart(2, '0');
                var day = String(dateObj.getDate()).padStart(2, '0');
                var dateStr = year + "." + month + "." + day;

                // 조회수 랜덤
                var views = Math.floor(Math.random() * 3000) + 100;

                // 클릭 시 상세 페이지 이동 (id, title 파라미터 전달)
                // 주의: title에 특수문자가 있을 수 있으므로 encodeURIComponent 사용
                html += '<tr onclick="location.href=\'Admin_NoticeDetail.jsp?id=' + num + '&title=' + encodeURIComponent(notice.title) + '&date=' + dateStr + '&views=' + views + '\'">';
                html += '<td>' + num + '</td>';
                html += '<td class="text-left">' + notice.title + '</td>';
                html += '<td>' + dateStr + '</td>';
                html += '<td>' + views + '</td>';
                html += '</tr>';
            }
            tbody.innerHTML = html;
        }
    </script>

</body>
</html>