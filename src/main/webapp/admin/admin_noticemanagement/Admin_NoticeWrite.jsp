<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 공지 등록</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>

    <style>
        /* [공통 스타일 유지] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        
        /* [사이드바 스타일] */
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

        /* [메인 컨텐츠 스타일] */
        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        
        /* [★수정됨★ 컨텐츠 래퍼 - 중앙 정렬 적용] */
        .content-wrapper { 
            flex: 1; 
            padding: 40px 30px; 
            overflow-y: auto;
            
            /* 수직/수평 중앙 정렬을 위한 Flex 설정 */
            display: flex;
            flex-direction: column;
            justify-content: center; /* 수직 중앙 */
            align-items: center;     /* 수평 중앙 */
        }
        
        /* [폼 컨테이너 스타일] */
        .form-container { 
            background: #fff; 
            border-radius: 12px; 
            padding: 40px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.03); 
            max-width: 1000px; 
            width: 100%; /* 중앙 정렬 시 너비 확보 */
            /* margin: 0 auto; -> Flex 중앙 정렬 사용 시 제거해도 무방하지만 안전하게 유지 */
        }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 700; color: #333; margin-bottom: 8px; }
        .form-input { width: 100%; height: 45px; padding: 0 15px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; }
        
        /* 버튼 영역 */
        .btn-wrap { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .btn-save { padding: 12px 30px; background-color: #503396; color: white; border-radius: 6px; font-weight: bold; border: none; cursor: pointer; }
        .btn-cancel { padding: 12px 30px; background-color: #fff; border: 1px solid #ddd; color: #555; border-radius: 6px; font-weight: bold; cursor: pointer; }
    </style>

    <script>
        // Summernote 초기화
        $(document).ready(function() {
            $('#summernote').summernote({
                placeholder: '내용을 입력해주세요',
                tabsize: 2,
                height: 400,               // 에디터 높이
                lang: 'ko-KR',             // 한국어 설정
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

        function checkForm() {
            var f = document.frm;
            if(f.title.value == "") { 
                alert("제목을 입력해주세요."); 
                f.title.focus(); 
                return; 
            }
            // Summernote 내용은 textarea에 담깁니다.
            if($('#summernote').summernote('isEmpty')) {
                alert("내용을 입력해주세요."); 
                $('#summernote').summernote('focus');
                return; 
            }
            f.submit();
        }
    </script>
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
                <li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i class="fa-solid fa-calendar-days menu-icon"></i><span>상영 스케줄 관리</span></a></li>
            </ul>
            <div class="menu-category">BOARD</div>
            <ul>
                <li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
                <li><a href="Admin_NoticeList.jsp" class="menu-link active"><i class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>
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
                <h2>공지사항 관리</h2>
                <p>사이트 내 공지사항을 등록하고 관리합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <div class="form-container">
                <h3 style="margin-bottom: 20px; font-size: 20px; font-weight:800;">📢 공지사항 등록</h3>
                
                <form name="frm" action="admin_notice_insert_process.jsp" method="post">
                    <div class="form-group">
                        <label class="form-label">제목</label>
                        <input type="text" name="title" class="form-input" placeholder="예: [공지] 서버 점검 안내">
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label">내용</label>
                        <textarea id="summernote" name="content"></textarea>
                    </div>
                    
                    <div class="btn-wrap">
                        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
                        <button type="button" class="btn-save" onclick="checkForm()">등록</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>