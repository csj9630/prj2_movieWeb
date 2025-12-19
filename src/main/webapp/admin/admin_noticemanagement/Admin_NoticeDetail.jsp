<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 목록에서 넘겨준 파라미터 받기 (없으면 기본값 설정)
    String id = request.getParameter("id");
    String title = request.getParameter("title");
    String date = request.getParameter("date");
    String views = request.getParameter("views");

    // null 처리 (테스트용 가데이터)
    if(title == null) title = "[공지] 시스템 정기 점검 안내 (12/05)";
    if(date == null) date = "2025.11.25";
    if(views == null) views = "1,250";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 공지사항 상세</title>
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
        .logo-area img {
            height: 45px;
            object-fit: contain;
            display: block;
        }
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
        
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }

        /* [4. 상세 페이지 컨테이너] */
        .detail-container {
            background: #fff; border-radius: 12px; padding: 50px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03); max-width: 1000px; margin: 0 auto;
            min-height: 600px; display: flex; flex-direction: column;
        }

        /* 상세 헤더 */
        .detail-header {
            border-bottom: 1px solid #eee; padding-bottom: 20px; margin-bottom: 30px;
        }
        .detail-title { font-size: 26px; font-weight: 800; color: #1e1e2d; margin-bottom: 15px; line-height: 1.4; }
        
        .meta-info { display: flex; gap: 20px; font-size: 14px; color: #888; align-items: center; }
        .meta-item { display: flex; align-items: center; gap: 5px; }
        .meta-divider { width: 1px; height: 12px; background-color: #ddd; display: inline-block; }

        /* 상세 본문 */
        .detail-body {
            flex: 1; line-height: 1.8; font-size: 15px; color: #444;
            margin-bottom: 50px; min-height: 300px;
        }

        /* 하단 버튼 그룹 */
        .detail-footer {
            display: flex; justify-content: space-between; align-items: center;
            border-top: 1px solid #eee; padding-top: 30px;
        }
        
        /* 목록 버튼 */
        .btn-list {
            padding: 12px 30px; background-color: #fff; border: 1px solid #ddd;
            color: #555; font-weight: 600; border-radius: 6px; transition: 0.2s; font-size: 14px;
        }
        .btn-list:hover { background-color: #f9f9f9; }

        .right-btns { display: flex; gap: 10px; }
        
        /* 수정 버튼 */
        .btn-edit {
            padding: 12px 30px; background-color: #503396; color: #fff;
            font-weight: 700; border-radius: 6px; transition: 0.2s; font-size: 14px;
        }
        .btn-edit:hover { background-color: #3e257a; }

        /* 삭제 버튼 */
        .btn-delete {
            padding: 12px 30px; background-color: #fdedec; border: 1px solid #fadbd8;
            color: #e74c3c; font-weight: 700; border-radius: 6px; transition: 0.2s; font-size: 14px;
        }
        .btn-delete:hover { background-color: #fceae9; }

        /* [삭제 확인 모달] */
        .modal-overlay {
            display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.5); z-index: 2000;
            justify-content: center; align-items: center;
        }
        .confirm-card {
            background-color: #fff; width: 400px; border-radius: 12px; text-align: center;
            padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); animation: popIn 0.3s ease;
        }
        @keyframes popIn { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        
        .confirm-icon { font-size: 40px; color: #e74c3c; margin-bottom: 20px; }
        .confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
        .confirm-actions { display: flex; justify-content: center; gap: 10px; }
        
        .btn-confirm-yes {
            padding: 10px 30px; border-radius: 6px; border: none; font-weight: 700; cursor: pointer;
            background-color: #e74c3c; color: #fff;
        }
        .btn-confirm-no {
            padding: 10px 30px; border-radius: 6px; background-color: #fff; border: 1px solid #ddd;
            color: #555; font-weight: 600; cursor: pointer;
        }

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
                <h2>공지사항 상세</h2>
                <p>등록된 공지사항 내용을 확인합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="detail-container">
                <div class="detail-header">
                    <h2 class="detail-title"><%= title %></h2>
                    <div class="meta-info">
                        <span class="meta-item"><i class="fa-solid fa-user"></i> 2GV영화관</span>
                        <span class="meta-divider"></span>
                        <span class="meta-item"><i class="fa-regular fa-calendar"></i> <%= date %></span>
                        <span class="meta-divider"></span>
                        <span class="meta-item"><i class="fa-regular fa-eye"></i> <%= views %></span>
                    </div>
                </div>

                <div class="detail-body">
                    <p>안녕하세요. 2GV 영화관입니다.</p>
                    <br>
                    <p>언제나 저희 2GV 영화관을 이용해 주시는 고객님께 깊은 감사의 말씀을 드립니다.</p>
                    <p>보다 안정적이고 쾌적한 예매 서비스 제공을 위하여 아래와 같이 시스템 정기 점검이 진행될 예정입니다.</p>
                    <br>
                    <p style="background-color:#f9f9f9; padding:15px; border-radius:6px; border-left:4px solid #503396;">
                        <strong>[점검 일시]</strong><br>
                        2025년 12월 05일(금) 새벽 02:00 ~ 06:00 (총 4시간)
                    </p>
                    <br>
                    <p><strong>[점검 내용]</strong></p>
                    <ul>
                        <li>- 서버 안정화 작업 및 보안 패치 적용</li>
                        <li>- 결제 모듈 업데이트</li>
                    </ul>
                    <br>
                    <p>점검 시간 동안에는 홈페이지 및 모바일 앱 접속, 예매, 취소 서비스 이용이 일시 중단되오니 고객님의 너른 양해 부탁드립니다.</p>
                    <p>앞으로도 더 나은 서비스를 제공하기 위해 최선을 다하겠습니다.</p>
                    <br>
                    <p>감사합니다.</p>
                </div>

                <div class="detail-footer">
                    <button class="btn-list" onclick="location.href='Admin_NoticeList.jsp'">목록</button>
                    
                    <div class="right-btns">
                        <button class="btn-edit" onclick="location.href='Admin_NoticeEdit.jsp?id=<%= id %>'">수정</button>
                        <button class="btn-delete" onclick="openConfirmModal()">삭제</button>
                    </div>
                </div>
            </div>

        </div>
    </main>

    <div id="confirmModal" class="modal-overlay">
        <div class="confirm-card">
            <div class="confirm-icon"><i class="fa-solid fa-trash-can"></i></div>
            <div class="confirm-text">삭제하시겠습니까?</div>
            <div class="confirm-sub">삭제된 게시글은 복구할 수 없습니다.</div>
            <div class="confirm-actions">
                <button class="btn-confirm-no" onclick="closeConfirmModal()">아니오</button>
                <button class="btn-confirm-yes" onclick="executeDelete()">예, 삭제합니다</button>
            </div>
        </div>
    </div>

    <script>
        // 모달 열기
        function openConfirmModal() {
            document.getElementById('confirmModal').style.display = 'flex';
        }

        // 모달 닫기
        function closeConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // 실제 삭제 동작
        function executeDelete() {
            alert('공지사항이 정상적으로 삭제되었습니다.');
            location.href = 'Admin_NoticeList.jsp';
        }

        // 외부 클릭 닫기
        window.onclick = function(event) {
            if (event.target == document.getElementById('confirmModal')) {
                closeConfirmModal();
            }
        }
    </script>

</body>
</html>