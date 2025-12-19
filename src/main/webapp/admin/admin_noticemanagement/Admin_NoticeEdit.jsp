<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 수정할 글의 ID를 받았다고 가정 (실제로는 DB 조회)
    String id = request.getParameter("id");
    // 가데이터 (기존 내용 예시)
    String existingTitle = "[공지] 시스템 정기 점검 안내 (12/05)";
    String existingContent = "<p>안녕하세요. 2GV 영화관입니다.</p><br>"
                           + "<p>보다 안정적인 서비스 제공을 위해 시스템 정기 점검이 진행될 예정입니다.</p>"
                           + "<p>점검 시간 동안에는 예매 및 취소 서비스 이용이 제한되오니 양해 부탁드립니다.</p><br>"
                           + "<p><strong>[점검 일시]</strong></p>"
                           + "<p>2025년 12월 05일(금) 02:00 ~ 06:00 (4시간)</p>";
    String existingViews = "1250";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 공지사항 수정</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>

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
        input { font-family: 'Noto Sans KR', sans-serif; }
        
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

        /* [4. 수정 폼 스타일] */
        .write-container {
            background: #fff; border-radius: 12px; padding: 40px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03); max-width: 1000px; margin: 0 auto;
        }
        
        .form-header { margin-bottom: 30px; padding-bottom: 15px; border-bottom: 1px solid #eee; }
        .form-title { font-size: 20px; font-weight: 800; color: #1e1e2d; }

        .form-group { margin-bottom: 25px; }
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .required { color: #e74c3c; margin-left: 3px; }

        .form-input, .form-select {
            width: 100%; height: 50px; padding: 0 15px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 15px; color: #333;
        }
        .form-input:focus, .form-select:focus { border-color: #503396; }
        .form-input[readonly] { background-color: #f9f9f9; color: #888; cursor: default; }

        /* 하단 버튼 */
        .form-actions {
            display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px;
            padding-top: 20px; border-top: 1px solid #eee;
        }
        .btn-save { 
            padding: 12px 30px; background-color: #503396; color: #fff; 
            border-radius: 6px; font-weight: 700; transition: 0.2s; font-size: 15px; 
        }
        .btn-save:hover { background-color: #3e257a; }
        
        .btn-cancel { 
            padding: 12px 30px; background-color: #fff; border: 1px solid #ddd; 
            color: #555; border-radius: 6px; font-weight: 600; transition: 0.2s; font-size: 15px; 
        }
        .btn-cancel:hover { background-color: #f9f9f9; }

        /* Summernote 커스텀 */
        .note-editor.note-frame { border-radius: 6px; border-color: #ddd; }
        .note-toolbar { border-radius: 6px 6px 0 0; background-color: #f9f9f9; border-bottom: 1px solid #ddd; }
        .note-statusbar { border-radius: 0 0 6px 6px; }
        .note-editable { font-family: 'Noto Sans KR', sans-serif; font-size: 15px; line-height: 1.6; }

        /* [5. 확인 모달] */
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
        
        .confirm-icon { font-size: 40px; color: #503396; margin-bottom: 20px; }
        .confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
        .confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
        .confirm-actions { display: flex; justify-content: center; gap: 10px; }
        
        .btn-confirm-yes {
            padding: 10px 30px; border-radius: 6px; border: none; font-weight: 700; cursor: pointer;
            background-color: #503396; color: #fff;
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
                <h2>공지사항 수정</h2>
                <p>등록된 공지사항 내용을 수정합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            
            <div class="write-container">
                <div class="form-header">
                    <span class="form-title">게시글 수정</span>
                </div>

                <form id="editForm" action="../admin_noticemanagement/Admin_NoticeList.jsp" method="post">
                    
                    <div class="form-group">
                        <label class="form-label">분류</label>
                        <select class="form-select" name="category" style="width: 200px;">
                            <option value="공지" selected>공지</option>
                            <option value="이벤트">이벤트</option>
                            <option value="안내">안내</option>
                            <option value="채용">채용</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">제목 <span class="required">*</span></label>
                        <input type="text" class="form-input" name="title" value="<%= existingTitle %>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">작성자</label>
                        <input type="text" class="form-input" name="writer" value="관리자" readonly>
                    </div>

                    <div class="form-group">
                        <label class="form-label">조회수</label>
                        <input type="number" class="form-input" name="views" value="<%= existingViews %>" min="0" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">내용 <span class="required">*</span></label>
                        <textarea id="summernote" name="content"><%= existingContent %></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                        <button type="button" class="btn-save" onclick="openConfirmModal()">수정 저장</button>
                    </div>
                </form>
            </div>

        </div>
    </main>

    <div id="confirmModal" class="modal-overlay">
        <div class="confirm-card">
            <div class="confirm-icon"><i class="fa-solid fa-circle-check"></i></div>
            <div class="confirm-text">수정사항을 저장하시겠습니까?</div>
            <div class="confirm-sub">변경된 내용이 게시글에 반영됩니다.</div>
            <div class="confirm-actions">
                <button class="btn-confirm-no" onclick="closeConfirmModal()">아니오</button>
                <button class="btn-confirm-yes" onclick="executeSave()">예</button>
            </div>
        </div>
    </div>

    <script>
        // Summernote 초기화
        $(document).ready(function() {
            $('#summernote').summernote({
                placeholder: '내용을 입력하세요',
                tabsize: 2,
                height: 400,
                lang: 'ko-KR',
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'clear']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link', 'picture', 'video']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ]
            });
        });

        // 모달 열기 (유효성 검사 포함)
        function openConfirmModal() {
            var title = document.getElementsByName('title')[0].value;
            if(title.trim() == "") {
                alert("제목을 입력해주세요.");
                return;
            }
            if($('#summernote').summernote('isEmpty')) {
                alert("내용을 입력해주세요.");
                return;
            }
            document.getElementById('confirmModal').style.display = 'flex';
        }

        // 모달 닫기
        function closeConfirmModal() {
            document.getElementById('confirmModal').style.display = 'none';
        }

        // 실제 저장 동작
        function executeSave() {
            alert('수정 사항이 성공적으로 저장되었습니다.');
            // 폼 제출 or 페이지 이동
            document.getElementById('editForm').submit();
        }

        // 외부 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target == document.getElementById('confirmModal')) {
                closeConfirmModal();
            }
        }
    </script>

</body>
</html>