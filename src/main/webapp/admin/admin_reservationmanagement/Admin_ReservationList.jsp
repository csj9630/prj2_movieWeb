<%@page import="movie.reservation_admin.ReservationDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.admin.AdminReservationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	String field = request.getParameter("field");
	String keyword = request.getParameter("keyword");
	
	int currentPage = 1;
	if(tempPage != null && !tempPage.equals("")){
		try { currentPage = Integer.parseInt(tempPage); } catch(Exception e) {}
	}
	
	AdminReservationService as = AdminReservationService.getInstance();
	int totalCount = as.getTotalCount(field, keyword);
	int pageScale = 10;
	int totalPage = as.totalPage(totalCount, pageScale);
	
	List<ReservationDTO> list = as.getReservationList(currentPage, pageScale, field, keyword);
	String pagination = as.getPagination(currentPage, totalPage, 5, "Admin_ReservationList.jsp", field, keyword);
	
	pageContext.setAttribute("list", list);
	pageContext.setAttribute("pagination", pagination);
	pageContext.setAttribute("totalCount", totalCount);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>2GV Admin - 예매 관리</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <style>
        /* 공통 스타일 */
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

        .main-content { flex: 1; display: flex; flex-direction: column; min-width: 0; }
        .top-header { height: 80px; background-color: #fff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; }
        .header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; }
        .header-left-title p { font-size: 13px; color: #888; }
 		.logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
        .logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
        .content-wrapper { flex: 1; padding: 40px 30px; overflow-y: auto; }
        
        .filter-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03); margin-bottom: 25px; display: flex; gap: 10px; align-items: center; }
        .filter-input { height: 45px; border: 1px solid #ddd; border-radius: 6px; padding: 0 15px; font-size: 14px; color: #555; }
        .filter-input-long { flex: 1; }
        .filter-btn { height: 45px; padding: 0 30px; background-color: #1e1e2d; color: #fff; border-radius: 6px; font-size: 14px; font-weight: 600; }
        .reset-btn { height: 45px; padding: 0 20px; background-color: #fff; border: 1px solid #ddd; border-radius: 6px; }

        .table-container { 
            background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.03);
            display: flex; flex-direction: column; min-height: 750px; 
        }
        .table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .total-count { font-size: 14px; color: #555; font-weight: 600; }
        .total-count span { color: #503396; }
        
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 10px; border-bottom: 1px solid #eee; }
        td { padding: 15px 10px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; }
        tbody tr:hover { background-color: #f8f9fa; cursor: pointer; }
        
        .status-active { color: #1bc5bd; font-weight: 700; background: #e8fff3; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        .status-cancel { color: #e74c3c; font-weight: 700; background: #fdedec; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
        
        .pagination { display: flex; justify-content: center; margin-top: auto; padding-top: 20px; gap: 5px; }
        .page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
        .page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
        .page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }
        
        /* 모달 스타일 */
        .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); z-index: 2000; justify-content: center; align-items: center; }
        .modal-card { background-color: #fff; width: 600px; border-radius: 12px; box-shadow: 0 10px 30px rgba(0,0,0,0.2); overflow: hidden; }
        .modal-header { padding: 20px 25px; background-color: #f9f9f9; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; }
        .modal-title { font-size: 18px; font-weight: 700; color: #333; }
        .modal-close { font-size: 20px; color: #999; cursor: pointer; }
        .modal-body { padding: 30px 25px; }
        
        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th { text-align: left; padding: 12px 0; color: #5e6278; font-weight: 600; width: 120px; border-bottom: 1px solid #f0f0f0; }
        .detail-table td { padding: 12px 0; color: #333; border-bottom: 1px solid #f0f0f0; }
        
        .modal-footer { padding: 20px 25px; background-color: #f9f9f9; border-top: 1px solid #eee; display: flex; justify-content: flex-end; gap: 10px; }
        .btn-close { padding: 10px 20px; background: #fff; border: 1px solid #ddd; border-radius: 6px; cursor: pointer; font-weight: 600; color: #555; }
        .btn-cancel-book { padding: 10px 20px; background: #e74c3c; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-weight: 700; }
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
                <li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link active"><i class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>
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
                <h2>예매 관리</h2>
                <p>회원들의 영화 예매 내역을 조회하고 취소 처리합니다.</p>
            </div>
            <div class="header-right"><button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button></div>
        </header>

        <div class="content-wrapper">
            <form action="Admin_ReservationList.jsp" method="get">
                <div class="filter-card">
                    <select name="field" class="filter-input" style="width: 120px;">
                        <option value="0" ${ param.field eq '0' ? 'selected' : '' }>예매번호</option>
                        <option value="1" ${ param.field eq '1' ? 'selected' : '' }>아이디</option>
                        <option value="2" ${ param.field eq '2' ? 'selected' : '' }>영화제목</option>
                    </select>
                    <input type="text" name="keyword" class="filter-input filter-input-long" placeholder="검색어를 입력하세요" value="${ param.keyword }">
                    <button type="submit" class="filter-btn">조회</button>
                    <button type="button" class="reset-btn" onclick="location.href='Admin_ReservationList.jsp'"><i class="fa-solid fa-rotate-right"></i></button>
                </div>
            </form>

            <div class="table-container">
                <div class="table-header">
                    <p class="total-count">총 <span><c:out value="${ totalCount }"/></span>건의 예매 내역이 있습니다.</p>
                </div>

                <table>
                    <colgroup>
                        <col width="10%"> <col width="15%"> <col width="25%"> <col width="20%"> <col width="15%"> <col width="15%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>예매번호</th>
                            <th>예매자 (ID)</th>
                            <th>영화 제목</th>
                            <th>상영 일시</th>
                            <th>결제 금액</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${ empty list }">
                            <tr><td colspan="6" style="padding: 50px 0;">예매 내역이 없습니다.</td></tr>
                        </c:if>
                        
                        <c:forEach var="res" items="${ list }">
                        <tr onclick="openDetailModal('${res.bookNum}')">
                            <td><c:out value="${ res.bookNum }"/></td>
                            <td><c:out value="${ res.userName }"/> (<c:out value="${ res.userId }"/>)</td>
                            <td style="text-align:left; padding-left:20px; font-weight:600;"><c:out value="${ res.movieName }"/></td>
                            <td><c:out value="${ res.screenDate }"/> <c:out value="${ res.screenTime }"/></td>
                            <td><fmt:formatNumber value="${ res.price }" pattern="#,###"/>원</td>
                            <td>
                                <c:choose>
                                    <c:when test="${ res.bookState eq '결제완료' }">
                                        <span class="status-active">예매완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-cancel">예매취소</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="pagination">
                    <c:out value="${ pagination }" escapeXml="false"/>
                </div>
            </div>
        </div>
    </main>

    <div id="detailModal" class="modal-overlay">
        <div class="modal-card">
            <div class="modal-header">
                <h3 class="modal-title">예매 상세 정보</h3>
                <i class="fa-solid fa-xmark modal-close" onclick="closeModal()"></i>
            </div>
            <div class="modal-body" id="modalContent">
                <div style="text-align:center; padding:30px;">로딩 중...</div>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel-book" id="btnCancelBook" style="display:none;" onclick="cancelBook()">예매 취소</button>
                <button class="btn-close" onclick="closeModal()">닫기</button>
            </div>
        </div>
    </div>

    <script>
        let currentBookNum = "";

        function openDetailModal(bookNum) {
            currentBookNum = bookNum;
            document.getElementById('detailModal').style.display = 'flex';
            
            // AJAX 요청
            $.ajax({
                url: "admin_reservation_detail_ajax.jsp",
                type: "post",
                data: { bookNum: bookNum },
                success: function(html) {
                    $("#modalContent").html(html);
                    
                    // 상태값 체크 (hidden input값)
                    let state = $("#detailBookState").val();
                    if(state === '결제완료') {
                        $("#btnCancelBook").show(); // 예매 완료 상태면 취소 버튼 보임
                    } else {
                        $("#btnCancelBook").hide();
                    }
                },
                error: function() {
                    $("#modalContent").html("정보를 불러오는데 실패했습니다.");
                }
            });
        }

        function closeModal() {
            document.getElementById('detailModal').style.display = 'none';
        }

        function cancelBook() {
            if(confirm("정말 이 예매를 취소하시겠습니까?\n취소 후에는 복구할 수 없습니다.")) {
                $.ajax({
                    url: "admin_reservation_cancel_process.jsp",
                    type: "post",
                    dataType: "json",
                    data: { bookNum: currentBookNum },
                    success: function(json) {
                        if(json.result) {
                            alert("예매가 정상적으로 취소되었습니다.");
                            location.reload();
                        } else {
                            alert("취소 처리에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("서버 통신 오류");
                    }
                });
            }
        }
        
        // 모달 밖 클릭 시 닫기
        window.onclick = function(event) {
            if (event.target == document.getElementById('detailModal')) {
                closeModal();
            }
        }
    </script>
</body>
</html>