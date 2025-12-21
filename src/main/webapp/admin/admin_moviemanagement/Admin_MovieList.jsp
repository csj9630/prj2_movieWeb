<%@page import="movie.movie_admin.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.admin.AdminMovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    request.setCharacterEncoding("UTF-8");

    // 1. 파라미터 수신
    String tempPage = request.getParameter("currentPage");
    String keyword = request.getParameter("keyword"); // 검색어

    int currentPage = 1;
    if(tempPage != null && !tempPage.equals("")){
        try{
            currentPage = Integer.parseInt(tempPage);
        }catch(NumberFormatException nfe){
            currentPage = 1;
        }
    }

    // 2. Service 연동
    AdminMovieService as = AdminMovieService.getInstance();
    
    // 총 게시물 수 (검색어 포함)
    int totalCount = as.getTotalCount(keyword);
    
    // 페이징 설정
    int pageScale = 5; // 영화는 포스터 때문에 높이가 커서 5개씩 보여줌
    int totalPage = as.totalPage(totalCount, pageScale);
    
    // 리스트 조회
    List<MovieDTO> list = as.getMovieList(currentPage, pageScale, keyword);
    
    // 페이지네이션 HTML
    String pagination = as.getPagination(currentPage, totalPage, 5, "Admin_MovieList.jsp", keyword);

    // 3. Scope 저장
    pageContext.setAttribute("movieList", list);
    pageContext.setAttribute("pagination", pagination);
    pageContext.setAttribute("totalCount", totalCount);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 영화 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <style>
        /* [공통 스타일] */
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
        input, select { font-family: 'Noto Sans KR', sans-serif; }
        
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

        /* [검색 필터] */
        .filter-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03); margin-bottom: 25px; display: flex; gap: 10px; align-items: center; }
        .filter-input { height: 45px; border: 1px solid #ddd; border-radius: 6px; padding: 0 15px; font-size: 14px; color: #555; }
        .filter-input-long { flex: 1; }
        .filter-btn { height: 45px; padding: 0 30px; background-color: #1e1e2d; color: #fff; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .filter-btn:hover { background-color: #333; }
        .reset-btn { height: 45px; padding: 0 20px; background-color: #fff; color: #555; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
        .reset-btn:hover { background-color: #f9f9f9; }

        /* [테이블 영역] */
        .table-container { 
            background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03);
            display: flex; flex-direction: column; min-height: 800px; /* 영화는 포스터때문에 높이가 좀 큼 */
        }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 25px; border-bottom: 1px solid #eee; }
        td { padding: 15px 25px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; transition: background-color 0.2s; }
        tbody tr { cursor: pointer; }
        tbody tr:hover { background-color: #f8f9fa; }
        
        /* 영화 썸네일 스타일 */
        .movie-thumb { width: 60px; height: 85px; object-fit: cover; border-radius: 4px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        
        .status-active { color: #1bc5bd; font-weight: 700; background: #e8fff3; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        .status-inactive { color: #ffa800; font-weight: 700; background: #fff4de; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        .status-soon { color: #8950fc; font-weight: 700; background: #eee5ff; padding: 4px 10px; border-radius: 4px; font-size: 12px; }

        .bottom-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .action-btn-lg { padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 700; border: 1px solid transparent; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; }
        .btn-register { background-color: #503396; color: #fff; }
        .btn-register:hover { background-color: #3e257a; }
        .btn-delete { background-color: #fdedec; color: #e74c3c; border-color: #fadbd8; }
        .btn-delete:hover { background-color: #fceae9; }

        .pagination { display: flex; justify-content: center; margin-top: auto; padding-top: 20px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }
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
                <h2>영화 관리</h2>
                <p>등록된 영화의 정보를 조회, 수정 및 삭제합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <form action="Admin_MovieList.jsp" method="get">
                <div class="filter-card">
                    <input type="text" name="keyword" class="filter-input filter-input-long" placeholder="영화 제목을 검색하세요" value="${ param.keyword }">
                    <button type="submit" class="filter-btn">조회</button>
                    <button type="button" class="reset-btn" onclick="location.href='Admin_MovieList.jsp'"><i class="fa-solid fa-rotate-right"></i></button>
                </div>
            </form>

            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span><c:out value="${ totalCount }"/></span>편의 영화가 검색되었습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="5%"> <col width="10%"> <col width="10%"> <col width="35%"> <col width="15%"> <col width="15%"> <col width="10%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>영화 코드</th>
                            <th>포스터</th>
                            <th>영화 제목</th>
                            <th>장르</th>
                            <th>개봉일</th>
                            <th>상영 상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${ empty movieList }">
                            <tr><td colspan="7" style="padding: 50px 0;">등록된 영화가 없습니다.</td></tr>
                        </c:if>
                        
                        <c:forEach var="movie" items="${ movieList }">
                        <tr>
                            <td><input type="checkbox" class="row-check" value="${ movie.movieCode }" onclick="checkOnlyOne(this)"></td>
                            <td><c:out value="${ movie.movieCode }"/></td>
                            <td>
                                <img src="../../resources/images/movieImg/${ movie.movieCode }/${ movie.mainImage }" 
                                     class="movie-thumb" 
                                     onerror="this.onerror=null; this.src='../../resources/images/no_image.png'">
                            </td>
                            <td style="text-align: left; padding-left: 20px; font-weight: 600;"><c:out value="${ movie.movieName }"/></td>
                            <td><c:out value="${ movie.movieGenre }"/></td>
                            <td><c:out value="${ movie.releaseDate }"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${ movie.showing eq '상영중' }">
                                        <span class="status-active">상영중</span>
                                    </c:when>
                                    <c:when test="${ movie.showing eq '개봉예정' }">
                                        <span class="status-soon">개봉예정</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-inactive">상영종료</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="bottom-actions">
                    <button class="action-btn-lg btn-register" onclick="goRegister()">
                        <i class="fa-solid fa-plus"></i> 영화 등록
                    </button>
                    <button class="action-btn-lg btn-register" onclick="goEdit()" style="background-color: #8950fc;">
                        <i class="fa-solid fa-pen"></i> 수정
                    </button>
                    <button class="action-btn-lg btn-delete" onclick="deleteMovie()">
                        <i class="fa-solid fa-trash-can"></i> 삭제
                    </button>
                </div>

                <div class="pagination">
                    <c:out value="${ pagination }" escapeXml="false"/>
                </div>
            </div>
        </div>
    </main>

    <script>
        function checkOnlyOne(element) {
            const allChecks = document.querySelectorAll('.row-check');
            allChecks.forEach((cb) => { cb.checked = false; });
            element.checked = true;
        }

        function goRegister() {
            location.href = "Admin_MovieRegister.jsp";
        }

        function goEdit() {
            const selected = document.querySelector('.row-check:checked');
            if (!selected) {
                alert("수정할 영화를 선택해주세요.");
                return;
            }
            location.href = "Admin_MovieRegister.jsp?id=" + selected.value;
        }

        function deleteMovie() {
            const selected = document.querySelector('.row-check:checked');
            if (!selected) {
                alert("삭제할 영화를 선택해주세요.");
                return;
            }

            const name = selected.closest('tr').children[3].innerText;
            if(confirm("정말 '" + name + "' 영화를 삭제하시겠습니까?\n삭제된 영화는 복구되지 않습니다.")) {
                $.ajax({
                    url: "admin_movie_delete_process.jsp",
                    type: "post",
                    dataType: "json",
                    data: { id: selected.value },
                    success: function(json) {
                        if(json.result) {
                            alert("삭제되었습니다.");
                            location.reload();
                        } else {
                            alert("삭제 처리에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("서버 통신 오류");
                    }
                });
            }
        }
    </script>
</body>
</html>