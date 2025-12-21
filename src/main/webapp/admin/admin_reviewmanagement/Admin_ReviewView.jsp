<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.review_admin.ReviewDTO" %>
<%@ page import="movie.admin.AdminReviewService" %>
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
    // 1. 파라미터 받기
    String reviewNum = request.getParameter("review_num");
    
    // 2. 데이터 조회
    AdminReviewService service = AdminReviewService.getInstance();
    ReviewDTO dto = service.getReviewDetail(reviewNum);
    
    // 데이터가 없으면 목록으로 이동
    if(dto == null) {
%>
    <script>
        alert("존재하지 않는 리뷰입니다.");
        location.href = "Admin_ReviewList.jsp";
    </script>
<%
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 리뷰 상세</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 공통 스타일 (공지사항 관리와 동일한 디자인) */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        
        .sidebar { width: 260px; background-color: #1e1e2d; color: #a2a3b7; display: flex; flex-direction: column; flex-shrink: 0; }
        .logo-area { height: 80px; display: flex; align-items: center; justify-content: center; background-color: #1b1b28; border-bottom: 1px solid #2d2d3f; }
        .logo-area img { height: 45px; object-fit: contain; }
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
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; display: flex; justify-content: center; align-items: center; }
        .top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; }
        .header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
        .logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; cursor: pointer; }

        /* 상세 페이지 스타일 */
        .form-container { background: #fff; border-radius: 12px; padding: 40px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); max-width: 800px; width: 100%; }
        
        .review-header { border-bottom: 1px solid #eee; padding-bottom: 20px; margin-bottom: 30px; }
        .movie-title { font-size: 22px; font-weight: 800; color: #1e1e2d; margin-bottom: 10px; }
        .review-meta { display: flex; justify-content: space-between; color: #888; font-size: 14px; }
        .rating-badge { background-color: #f1c40f; color: #fff; padding: 3px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; margin-left: 10px; }
        
        .review-content-box { 
            min-height: 200px; 
            padding: 20px; 
            background-color: #f9f9f9; 
            border-radius: 8px; 
            font-size: 15px; 
            line-height: 1.6; 
            color: #444; 
        }

        .btn-wrap { display: flex; justify-content: flex-end; gap: 10px; margin-top: 30px; }
        .btn-common { padding: 10px 25px; border-radius: 6px; font-weight: bold; font-size: 14px; cursor: pointer; border: 1px solid transparent; }
        .btn-list { background-color: #fff; border-color: #ddd; color: #555; }
        .btn-delete { background-color: #fdedec; color: #e74c3c; border-color: #fadbd8; }
    </style>
    <script>
        function deleteReview() {
            if(confirm("이 리뷰를 삭제하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
                location.href = "admin_review_delete_process.jsp?review_num=<%= dto.getReviewNum() %>";
            }
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
                <li><a href="Admin_ReviewList.jsp" class="menu-link active"><i class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>
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
                <h2>리뷰 관리</h2>
                <p>등록된 영화 관람평을 조회하고 관리합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <div class="form-container">
                
                <div class="review-header">
                    <div class="movie-title">
                        <i class="fa-solid fa-film" style="color:#503396; font-size:18px; margin-right:5px;"></i>
                        <%= dto.getMovieName() %>
                    </div>
                    <div class="review-meta">
                        <span>
                            <i class="fa-solid fa-user"></i> <%= dto.getUserId() %>
                            <span style="margin: 0 10px; color:#ddd;">|</span>
                            <i class="fa-regular fa-clock"></i> <%= dto.getReviewDate() %>
                        </span>
                        <span>
                            평점 <span class="rating-badge"><i class="fa-solid fa-star"></i> <%= dto.getReviewScore() %></span>
                        </span>
                    </div>
                </div>

                <div class="review-content-box">
                    <% 
                        String content = dto.getReviewContent();
                        if(content != null) {
                            content = content.replace("\r\n", "<br>");
                        }
                    %>
                    <%= content %>
                </div>

                <div class="btn-wrap">
                    <button type="button" class="btn-common btn-list" onclick="location.href='Admin_ReviewList.jsp'">목록</button>
                    <button type="button" class="btn-common btn-delete" onclick="deleteReview()">삭제</button>
                </div>
            </div>
        </div>
    </main>
</body>
</html>