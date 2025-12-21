<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="movie.review_admin.ReviewDTO" %>
<%@ page import="movie.admin.AdminReviewService" %>
<%
    // [세션 검사] 로그인 안 된 상태면 로그인 화면으로 튕겨냄
    String adminId = (String) session.getAttribute("adminId");
    if (adminId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "../admin_logout/Admin_Login.jsp";
    </script>
<%
        return; // 밑에 있는 HTML이나 자바 코드가 실행되지 않도록 여기서 멈춤
    }
%>
<%
    // 파라미터 처리
    String field = request.getParameter("field");
    String query = request.getParameter("query");
    String pageNum = request.getParameter("pageNum");
    
    int currentPage = 1;
    if(pageNum != null && !pageNum.equals("")){
        currentPage = Integer.parseInt(pageNum);
    }
    int pageSize = 10; 
    
    // 서비스 호출
    AdminReviewService service = AdminReviewService.getInstance();
    List<ReviewDTO> list = service.getReviewList(currentPage, pageSize, field, query);
    int totalCount = service.getTotalCount(field, query);
    
    // 페이징 계산
    int totalPage = (int)Math.ceil((double)totalCount / pageSize);
    int pageBlock = 5;
    int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
    int endPage = startPage + pageBlock - 1;
    if(endPage > totalPage) endPage = totalPage;
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 리뷰 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* [공통 스타일 - 스케줄 관리 페이지와 동일] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select { font-family: 'Noto Sans KR', sans-serif; }
        
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
        .sort-info-area { display: flex; justify-content: space-between; margin-bottom: 15px; align-items: center; }
        .search-area { display: flex; gap: 5px; }
        .search-select { height: 35px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px; font-size: 13px; }
        .search-input { height: 35px; border: 1px solid #ddd; border-radius: 4px; padding: 0 10px; font-size: 13px; width: 200px; }
        .search-btn { height: 35px; background-color: #503396; color: #fff; border-radius: 4px; padding: 0 15px; font-size: 13px; font-weight: bold; }
        
        .table-container { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03); }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        tbody tr { transition: 0.2s; }
        tbody tr:hover { background-color: #f8f9fa; }
        
        .content-cell { text-align: left; padding-left: 20px; }
        .star-rating { color: #f1c40f; font-size: 12px; }
        
        .btn-delete-sm { padding: 5px 10px; background-color: #fdedec; color: #e74c3c; border-radius: 4px; font-size: 12px; font-weight: bold; }
        .btn-delete-sm:hover { background-color: #fceae9; }
        
        .pagination { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }
    </style>
    <script>
        function deleteReview(reviewNum) {
            if(confirm('선택하신 리뷰를 삭제하시겠습니까?\n삭제 후 복구할 수 없습니다.')) {
                location.href = 'admin_review_delete_process.jsp?review_num=' + reviewNum;
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
            
            <div class="sort-info-area">
                <span style="font-size:13px; color:#888;"><i class="fa-solid fa-circle-info"></i> 부적절한 내용은 관리자가 삭제할 수 있습니다.</span>
                
                <form action="Admin_ReviewList.jsp" method="get" class="search-area">
                    <select name="field" class="search-select">
                        <option value="movie" <%= "movie".equals(field) ? "selected" : "" %>>영화제목</option>
                        <option value="user" <%= "user".equals(field) ? "selected" : "" %>>작성자ID</option>
                        <option value="content" <%= "content".equals(field) ? "selected" : "" %>>내용</option>
                    </select>
                    <input type="text" name="query" class="search-input" value="<%= query != null ? query : "" %>" placeholder="검색어 입력">
                    <button type="submit" class="search-btn">검색</button>
                </form>
            </div>

            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span><%= totalCount %></span>건의 리뷰가 있습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="5%"> 
                        <col width="15%"> 
                        <col width="10%"> 
                        <col width="10%"> 
                        <col width="40%"> 
                        <col width="10%"> 
                        <col width="10%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>영화 제목</th>
                            <th>작성자</th>
                            <th>평점</th>
                            <th>내용</th>
                            <th>작성일</th>
                            <th>관리</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if(list == null || list.isEmpty()) { %>
                        <tr><td colspan="7">등록된 리뷰가 없습니다.</td></tr>
                    <% } else { 
                        int num = totalCount - (currentPage - 1) * pageSize;
                        for(ReviewDTO dto : list) {
                    %>
                        <tr onclick="location.href='Admin_ReviewView.jsp?review_num=<%= dto.getReviewNum() %>'" style="cursor:pointer;">
                            <td><%= num-- %></td>
                            <td><%= dto.getMovieName() %></td>
                            <td><%= dto.getUserId() %></td>
                            <td>
                                <span class="star-rating">
                                    <i class="fa-solid fa-star"></i> <%= dto.getReviewScore() %>
                                </span>
                            </td>
                            <td class="content-cell" title="<%= dto.getReviewContent() %>">
                                <% 
                                    String content = dto.getReviewContent();
                                    if(content != null && content.length() > 30) {
                                        content = content.substring(0, 30) + "...";
                                    }
                                %>
                                <%= content %>
                            </td>
                            <td><%= dto.getReviewDate() %></td>
                            <td>
                                <button class="btn-delete-sm" onclick="event.stopPropagation(); deleteReview('<%= dto.getReviewNum() %>')">
                                    삭제
                                </button>
                            </td>
                        </tr>
                    <%  } 
                       } %>
                    </tbody>
                </table>

                <div class="pagination">
                    <% if(startPage > pageBlock) { %>
                        <a href="Admin_ReviewList.jsp?pageNum=<%= startPage-1 %>&field=<%= field==null?"":field %>&query=<%= query==null?"":query %>" class="page-link"><i class="fa-solid fa-angle-left"></i></a>
                    <% } %>
                    
                    <% for(int i=startPage; i<=endPage; i++) { %>
                        <a href="Admin_ReviewList.jsp?pageNum=<%= i %>&field=<%= field==null?"":field %>&query=<%= query==null?"":query %>" class="page-link <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    
                    <% if(endPage < totalPage) { %>
                        <a href="Admin_ReviewList.jsp?pageNum=<%= endPage+1 %>&field=<%= field==null?"":field %>&query=<%= query==null?"":query %>" class="page-link"><i class="fa-solid fa-angle-right"></i></a>
                    <% } %>
                </div>
            </div>
        </div>
    </main>

</body>
</html>