<%@page import="movie.theater_admin.TheaterDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.admin.AdminTheaterService"%>
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
	
	String tempPage = request.getParameter("currentPage");
	int currentPage = 1;
	if(tempPage != null && !tempPage.equals("")) {
		try {
			currentPage = Integer.parseInt(tempPage);
		} catch(NumberFormatException nfe) {
			currentPage = 1;
		}
	}
	
	AdminTheaterService as = AdminTheaterService.getInstance();
	int totalCount = as.getTotalCount();
	int pageScale = 10;
	int totalPage = as.totalPage(totalCount, pageScale);
	
	List<TheaterDTO> list = as.getTheaterList(currentPage, pageScale);
	String pagination = as.getPagination(currentPage, totalPage, 5, "Admin_TheaterManagement.jsp");
	
	pageContext.setAttribute("theaterList", list);
	pageContext.setAttribute("pagination", pagination);
	pageContext.setAttribute("totalCount", totalCount);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 상영관 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; outline: none; }
        body { font-family: 'Noto Sans KR', sans-serif; background-color: #f5f6fa; color: #333; display: flex; height: 100vh; overflow: hidden; }
        a { text-decoration: none; color: inherit; }
        ul { list-style: none; }
        button { border: none; cursor: pointer; font-family: 'Noto Sans KR', sans-serif; }
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
        
        .table-container { 
            background: #fff; 
            border-radius: 12px; 
            padding: 25px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            min-height: 750px; 
        }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        .bottom-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
        .action-btn-lg { padding: 10px 20px; border-radius: 6px; font-size: 14px; font-weight: 700; border: 1px solid transparent; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 6px; }
        .btn-register { background-color: #503396; color: #fff; }
        .btn-register:hover { background-color: #3e257a; }
        .btn-disable { background-color: #fdedec; color: #e74c3c; border-color: #fadbd8; }
        .btn-disable:hover { background-color: #fceae9; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 25px; border-bottom: 1px solid #eee; }
        td { padding: 15px 25px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; transition: background-color 0.2s; }
        tbody tr { cursor: pointer; }
        tbody tr:hover { background-color: #f8f9fa; }
        .status-active { color: #1bc5bd; font-weight: 700; background: #e8fff3; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        .status-inactive { color: #999; font-weight: 700; background: #f1f1f1; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        
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
                <li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link active"><i class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>
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
                <h2>상영관 관리</h2>
                <p>등록된 상영관의 목록을 조회하고 관리합니다.</p>
            </div>
            <div class="header-right">
                <button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button>
            </div>
        </header>

        <div class="content-wrapper">
            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span><c:out value="${ totalCount }"/></span>개의 상영관이 있습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="5%">  <col width="20%"> <col width="25%"> <col width="15%"> <col width="25%"> <col width="10%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>선택</th>
                            <th>상영관 ID</th>
                            <th>상영관 이름</th>
                            <th>총 좌석 수</th>
                            <th>사운드 시스템</th>
                            <th>사용 가능 여부</th>
                        </tr>
                    </thead>
                    <tbody>
                    	<c:if test="${ empty theaterList }">
                    		<tr><td colspan="6" style="padding: 50px 0;">등록된 상영관이 없습니다.</td></tr>
                    	</c:if>
                    	
                    	<c:forEach var="theater" items="${ theaterList }">
                        <tr>
                            <td><input type="checkbox" class="row-check" value="${ theater.theatherNum }" onclick="checkOnlyOne(this)"></td>
                            <td><c:out value="${ theater.theatherNum }"/></td>
                            <td><c:out value="${ theater.theatherName }"/></td>
                            <td><c:out value="${ theater.totalSeat }"/>석</td>
                            <td><c:out value="${ theater.soundName }"/></td>
                            <td>
                            	<c:choose>
                            		<c:when test="${ theater.availability eq 'T' }">
                            			<span class="status-active">사용중</span>
                            		</c:when>
                            		<c:otherwise>
                            			<span class="status-inactive">미사용중</span>
                            		</c:otherwise>
                            	</c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="bottom-actions">
                    <button class="action-btn-lg btn-register" onclick="goRegisterOrEdit()">
                        <i class="fa-solid fa-pen-to-square"></i> 등록/수정
                    </button>
                    <button class="action-btn-lg btn-disable" onclick="deactivateTheater()">
                        <i class="fa-solid fa-ban"></i> 비활성화
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

        function goRegisterOrEdit() {
            const selected = document.querySelector('.row-check:checked');
            if (selected) {
                const id = selected.value;
                location.href = "Admin_TheaterRegister.jsp?id=" + id;
            } else {
                location.href = "Admin_TheaterRegister.jsp";
            }
        }

        function deactivateTheater() {
            const selected = document.querySelector('.row-check:checked');
            if (!selected) {
                alert("비활성화할 상영관을 선택해주세요.");
                return;
            }

            const theaterId = selected.value;
            const theaterName = selected.closest('tr').children[2].innerText;

            if (confirm(theaterName + "을(를) 비활성화 하시겠습니까?")) {
            	$.ajax({
            		url: "admin_theater_status_process.jsp",
            		type: "post",
            		dataType: "json",
            		data: { id: theaterId },
            		success: function(json){
            			if(json.result){
            				alert("처리되었습니다.");
            				location.reload();
            			} else {
            				alert("처리에 실패했습니다.");
            			}
            		},
            		error: function(){
            			alert("서버 통신 오류");
            		}
            	});
            }
        }
    </script>
</body>
</html>