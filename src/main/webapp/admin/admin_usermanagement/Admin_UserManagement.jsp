<%@page import="movie.user_admin.UserDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.admin.AdminService"%>
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
        try{
            currentPage = Integer.parseInt(tempPage);
        }catch(NumberFormatException nfe){
            currentPage = 1;
        }
    }

    AdminService as = AdminService.getInstance();
    int totalCount = as.getTotalCount(field, keyword);
    int pageScale = 10;
    int totalPage = as.totalPage(totalCount, pageScale);
    List<UserDTO> list = as.getUserList(currentPage, pageScale, field, keyword);
    String pagination = as.getPagination(currentPage, totalPage, 5, "Admin_UserManagement.jsp", field, keyword);

    pageContext.setAttribute("userList", list);
    pageContext.setAttribute("pagination", pagination);
    pageContext.setAttribute("totalCount", totalCount);
    pageContext.setAttribute("currentPage", currentPage);
    pageContext.setAttribute("pageScale", pageScale);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>2GV Admin - 회원 관리</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<style>
/* [초기화 & 공통] */
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
.top-header { height: 80px; background-color: #ffffff; border-bottom: 1px solid #e1e1e1; display: flex; justify-content: space-between; align-items: center; padding: 0 30px; box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02); }
.header-left-title h2 { font-size: 24px; font-weight: 800; color: #1e1e2d; margin-bottom: 4px; letter-spacing: -0.5px; }
.header-left-title p { font-size: 13px; color: #888; font-weight: 500; }
.header-right { display: flex; align-items: center; gap: 20px; margin-left: 20px; }
.logout-btn { padding: 8px 16px; border: 1px solid #e1e1e1; background-color: #fff; border-radius: 6px; font-size: 12px; font-weight: 600; color: #5e6278; transition: 0.2s; }
.logout-btn:hover { background-color: #f9f9f9; border-color: #d1d1d1; color: #333; }
.content-wrapper { flex: 1; padding: 30px; overflow-y: auto; }
.filter-card { background: #fff; border-radius: 12px; padding: 25px; box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03); margin-bottom: 25px; display: flex; gap: 10px; align-items: center; }
.filter-input { height: 45px; border: 1px solid #ddd; border-radius: 6px; padding: 0 15px; font-size: 14px; color: #555; }
.filter-input-long { flex: 1; }
.filter-btn { height: 45px; padding: 0 30px; background-color: #1e1e2d; color: #fff; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
.filter-btn:hover { background-color: #333; }
.reset-btn { height: 45px; padding: 0 20px; background-color: #fff; color: #555; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; font-weight: 600; transition: 0.2s; }
.reset-btn:hover { background-color: #f9f9f9; }

/* [테이블 영역 - 페이지네이션 고정 수정] */
.table-container { 
    background: #fff; 
    border-radius: 12px; 
    padding: 25px; 
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
    
    /* 1. Flexbox 설정 */
    display: flex;
    flex-direction: column;
    /* 2. 최소 높이 설정 (헤더+10개행+패딩 등을 고려하여 적절히 설정) */
    min-height: 750px; 
}

.table-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.total-count { font-size: 14px; color: #555; font-weight: 600; }
.total-count span { color: #503396; }
.btn-group { display: flex; gap: 8px; }
.action-btn-top { padding: 8px 16px; border-radius: 6px; font-size: 13px; font-weight: 600; border: 1px solid transparent; cursor: pointer; transition: 0.2s; display: flex; align-items: center; gap: 5px; }
.btn-activate { background-color: #e8fff3; color: #1bc5bd; border-color: #c9f7f5; }
.btn-activate:hover { background-color: #d7fbe8; }
.btn-delete { background-color: #fdedec; color: #e74c3c; border-color: #fadbd8; }
.btn-delete:hover { background-color: #fceae9; }
table { width: 100%; border-collapse: collapse; font-size: 14px; }
th { background-color: #f9f9f9; color: #5e6278; font-weight: 600; text-align: center; padding: 15px 25px; border-bottom: 1px solid #eee; }
td { padding: 15px 25px; border-bottom: 1px solid #f5f5f5; color: #3f4254; text-align: center; vertical-align: middle; transition: background-color 0.2s; }
tbody tr { cursor: pointer; }
tbody tr:hover { background-color: #f8f9fa; }
.sort-icon { font-size: 11px; margin-left: 5px; color: #aaa; cursor: pointer; }
.sort-icon:hover { color: #503396; }
.action-btn { padding: 6px 12px; border-radius: 4px; font-size: 12px; font-weight: 600; border: 1px solid #ddd; background: #fff; color: #555; transition: 0.2s; cursor: pointer; }
.action-btn:hover { background-color: #f0f0f0; }

/* [페이지네이션 - 하단 고정 수정] */
.pagination { 
    display: flex; 
    justify-content: center; 
    /* 3. 상단 여백을 자동으로 채워서 바닥으로 밀어냄 */
    margin-top: auto; 
    padding-top: 20px; /* 테이블과 너무 붙지 않게 */
    gap: 5px; 
}
.page-link { width: 35px; height: 35px; display: flex; justify-content: center; align-items: center; border: 1px solid #eee; border-radius: 6px; font-size: 13px; color: #555; transition: 0.2s; }
.page-link:hover { background-color: #f5f5f5; border-color: #ddd; }
.page-link.active { background-color: #503396; color: #fff; border-color: #503396; font-weight: 700; }
.status-active { color: #1bc5bd; font-weight: 700; background: #e8fff3; padding: 4px 10px; border-radius: 4px; font-size: 12px; }
.status-inactive { color: #ffa800; font-weight: 700; background: #fff4de; padding: 4px 10px; border-radius: 4px; font-size: 12px; }

.modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 2000; justify-content: center; align-items: center; }
.modal-card { background-color: #fff; width: 500px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2); overflow: hidden; animation: fadeIn 0.3s ease-out; }
@keyframes fadeIn { from { opacity:0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
.modal-header { padding: 20px 25px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center; background-color: #f9f9f9; }
.modal-title { font-size: 18px; font-weight: 700; color: #333; }
.modal-close { font-size: 20px; color: #999; cursor: pointer; transition: 0.2s; }
.modal-close:hover { color: #333; }
.modal-body { padding: 30px 25px; }
.detail-table { width: 100%; border-collapse: collapse; }
.detail-table th { width: 140px; text-align: left; padding: 12px 0; color: #5e6278; font-weight: 600; font-size: 14px; border-bottom: 1px solid #f5f5f5; }
.detail-table td { padding: 12px 0; color: #333; font-size: 14px; border-bottom: 1px solid #f5f5f5; }
.detail-table tr:last-child th, .detail-table tr:last-child td { border-bottom: none; }
.modal-footer { padding: 20px 25px; border-top: 1px solid #eee; text-align: right; background-color: #f9f9f9; }
.modal-btn { padding: 8px 20px; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; }
.btn-close { background: #fff; border: 1px solid #ddd; color: #555; }
.confirm-card { background-color: #fff; width: 400px; border-radius: 12px; text-align: center; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
.confirm-icon { font-size: 40px; margin-bottom: 20px; }
.confirm-text { font-size: 18px; font-weight: 700; color: #333; margin-bottom: 10px; }
.confirm-sub { font-size: 14px; color: #888; margin-bottom: 30px; }
.confirm-actions { display: flex; justify-content: center; gap: 10px; }
.btn-confirm-yes { padding: 10px 30px; border-radius: 6px; border: none; font-weight: 700; cursor: pointer; color: #fff; }
.btn-confirm-no { padding: 10px 30px; border-radius: 6px; background-color: #fff; border: 1px solid #ddd; color: #555; font-weight: 600; cursor: pointer; }
</style>
</head>

<body>
	<nav class="sidebar">
		<div class="logo-area">
			<a href="../admin_dashboard/Admin_Dashboard.jsp"><img src="../../resources/img/2GV_LOGO_empty.png"></a>
		</div>
		<div class="menu-list">
			<div class="menu-category">MAIN</div>
			<ul>
				<li><a href="../admin_dashboard/Admin_Dashboard.jsp" class="menu-link"><i class="fa-solid fa-chart-pie menu-icon"></i><span>메인 페이지</span></a></li>
			</ul>
			<div class="menu-category">RESOURCE</div>
			<ul>
				<li><a href="../admin_usermanagement/Admin_UserManagement.jsp" class="menu-link active"><i class="fa-solid fa-users menu-icon"></i><span>회원 관리</span></a></li>
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
				<h2>회원 관리</h2>
				<p>등록된 회원의 정보를 조회하고 관리합니다.</p>
			</div>
			<div class="header-right">
				<button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button>
			</div>
		</header>

		<div class="content-wrapper">
			<form name="searchFrm" action="Admin_UserManagement.jsp" method="get">
				<div class="filter-card">
					<select name="field" class="filter-input" style="width: 120px;">
						<option value="0" ${ param.field eq '0' ? 'selected' : '' }>아이디</option>
						<option value="1" ${ param.field eq '1' ? 'selected' : '' }>이름</option>
						<option value="2" ${ param.field eq '2' ? 'selected' : '' }>전화번호</option>
					</select>
					<input type="text" name="keyword" class="filter-input filter-input-long" placeholder="검색어를 입력하세요" value="${ param.keyword }">
					<button type="submit" class="filter-btn">조회</button>
					<button type="button" class="reset-btn" onclick="location.href='Admin_UserManagement.jsp'">
						<i class="fa-solid fa-rotate-right"></i>
					</button>
				</div>
			</form>

			<div class="table-container">
				<div class="table-header">
					<p class="total-count">총 <span><c:out value="${ totalCount }"/></span>명의 회원이 검색되었습니다.</p>
					<div class="btn-group">
						<button class="action-btn-top btn-activate" onclick="openConfirmModal('active')">
							<i class="fa-solid fa-check"></i> 활성화
						</button>
						<button class="action-btn-top btn-delete" onclick="openConfirmModal('inactive')">
							<i class="fa-solid fa-ban"></i> 비활성화
						</button>
					</div>
				</div>

				<table>
					<colgroup>
						<col width="5%">
						<col width="20%">
						<col width="20%">
						<col width="35%">
						<col width="10%">
						<col width="10%">
					</colgroup>
					<thead>
						<tr>
							<th><input type="checkbox" id="checkAll"></th>
							<th>아이디</th>
							<th>이름 <i class="fa-solid fa-sort sort-icon"></i></th>
							<th>이메일</th>
							<th>계정 상태</th>
							<th>관리</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${ empty userList }">
							<tr>
								<td colspan="6" style="text-align: center; padding: 50px;">검색된 회원이 없습니다.</td>
							</tr>
						</c:if>

						<c:forEach var="user" items="${ userList }" varStatus="i">
							<fmt:formatDate var="fmtJoinDate" value="${ user.joinDate }" pattern="yyyy-MM-dd"/>
							<fmt:formatDate var="fmtLastLogin" value="${ user.recentLogin }" pattern="yyyy-MM-dd"/>
							<c:set var="userStatus" value="${ user.active }"/>

							<tr onclick="openModal('${user.userId}', '${user.userName}', '${user.phoneNum}', '${user.email}', '${user.birth}', '${user.gender}', '${fmtJoinDate}', '${fmtLastLogin}', '${userStatus}')">
								<td onclick="event.stopPropagation()">
									<input type="checkbox" class="row-check" value="${user.userId}">
								</td>
								<td><c:out value="${user.userId}"/></td>
								<td><c:out value="${user.userName}"/></td>
								<td><c:out value="${user.email}"/></td>
								<td>
									<c:choose>
										<c:when test="${userStatus eq '비활성화'}">
											<span class="status-inactive">비활성화</span>
										</c:when>
										<c:otherwise>
											<span class="status-active">활성화</span>
										</c:otherwise>
									</c:choose>
								</td>
								<td>
									<button class="action-btn"
										onclick="event.stopPropagation(); openModal('${user.userId}', '${user.userName}', '${user.phoneNum}', '${user.email}', '${user.birth}', '${user.gender}', '${fmtJoinDate}', '${fmtLastLogin}', '${userStatus}')">
										상세
									</button>
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

	<div id="userModal" class="modal-overlay">
		<div class="modal-card">
			<div class="modal-header">
				<h3 class="modal-title">회원 상세 정보</h3>
				<i class="fa-solid fa-xmark modal-close" onclick="closeModal()"></i>
			</div>
			<div class="modal-body">
				<table class="detail-table">
					<tr><th>아이디</th><td id="modalId"></td></tr>
					<tr><th>이름</th><td id="modalName"></td></tr>
					<tr><th>전화번호</th><td id="modalPhone"></td></tr>
					<tr><th>이메일</th><td id="modalEmail"></td></tr>
					<tr><th>생년월일</th><td id="modalBirth"></td></tr>
					<tr><th>성별</th><td id="modalGender"></td></tr>
					<tr><th>가입일</th><td id="modalJoinDate"></td></tr>
					<tr><th>마지막 로그인</th><td id="modalLastLogin"></td></tr>
					<tr><th>계정 상태</th><td id="modalStatus"></td></tr>
				</table>
			</div>
			<div class="modal-footer">
				<button class="modal-btn btn-close" onclick="closeModal()">닫기</button>
			</div>
		</div>
	</div>

	<div id="confirmModal" class="modal-overlay" style="z-index: 2100;">
		<div class="confirm-card">
			<div class="confirm-icon" id="confirmIcon"></div>
			<div id="confirmTitle" class="confirm-text"></div>
			<div class="confirm-sub">선택된 회원의 상태를 변경하시겠습니까?</div>
			<div class="confirm-actions">
				<button class="btn-confirm-no" onclick="closeConfirmModal()">아니오</button>
				<button class="btn-confirm-yes" onclick="executeAction()">예</button>
			</div>
		</div>
	</div>

	<script>
	function openModal(id, name, phone, email, birth, gender, joinDate, lastLogin, status) {
		document.getElementById('modalId').innerText = id;
		document.getElementById('modalName').innerText = name;
		document.getElementById('modalPhone').innerText = phone;
		document.getElementById('modalEmail').innerText = email;
		document.getElementById('modalBirth').innerText = birth;
		document.getElementById('modalGender').innerText = gender;
		document.getElementById('modalJoinDate').innerText = joinDate;
		document.getElementById('modalLastLogin').innerText = lastLogin;

		let safeStatus = status ? status.trim() : "";
		let statusHtml = "";
		if(safeStatus === '활성화') {
			statusHtml = '<span class="status-active">활성화</span>';
		} else {
			statusHtml = '<span class="status-inactive">비활성화</span>';
		}
		
		document.getElementById('modalStatus').innerHTML = statusHtml;
		document.getElementById('userModal').style.display = 'flex';
	}

	function closeModal() { document.getElementById('userModal').style.display = 'none'; }

	let currentAction = '';
	function openConfirmModal(action) {
		const checked = document.querySelectorAll('.row-check:checked');
		if (checked.length === 0) {
			alert("회원을 선택해주세요.");
			return;
		}
		currentAction = action;
		const modal = document.getElementById('confirmModal');
		const icon = document.getElementById('confirmIcon');
		const title = document.getElementById('confirmTitle');
		const btn = document.querySelector('.btn-confirm-yes');

		if (action === 'active') {
			title.innerText = "활성화하시겠습니까?";
			icon.innerHTML = '<i class="fa-solid fa-circle-check" style="color:#1bc5bd"></i>';
			btn.style.backgroundColor = "#1bc5bd";
		} else {
			title.innerText = "비활성화하시겠습니까?";
			icon.innerHTML = '<i class="fa-solid fa-ban" style="color:#e74c3c"></i>';
			btn.style.backgroundColor = "#e74c3c";
		}
		modal.style.display = 'flex';
	}

	function closeConfirmModal() {
		document.getElementById('confirmModal').style.display = 'none';
	}

	function executeAction() {
		const checkedBoxes = document.querySelectorAll('.row-check:checked');
		if(checkedBoxes.length === 0) return;

		let promises = [];
		checkedBoxes.forEach(function(checkbox){
			let userId = checkbox.value;
			let request = $.ajax({
				url: "admin_user_status_process.jsp",
				type: "post",
				dataType: "json",
				data: { 
					userId: userId, 
					status: currentAction 
				}
			});
			promises.push(request);
		});

		Promise.all(promises).then(function(results) {
			alert("처리가 완료되었습니다.");
			location.reload();
		}).catch(function(err) {
			alert("일부 처리에 실패했습니다. 다시 시도해주세요.");
			location.reload();
		});

		closeConfirmModal();
	}

	window.onclick = function(event) {
		if (event.target == document.getElementById('userModal')) closeModal();
		if (event.target == document.getElementById('confirmModal')) closeConfirmModal();
	}
	const checkAll = document.getElementById('checkAll');
	const rowChecks = document.querySelectorAll('.row-check');
	checkAll.addEventListener('change', function() { rowChecks.forEach(checkbox => { checkbox.checked = this.checked; }); });
	</script>
</body>
</html>