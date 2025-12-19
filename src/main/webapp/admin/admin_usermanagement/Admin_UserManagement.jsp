<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html lang="ko">

<head>

<meta charset="UTF-8">

<title>2GV Admin - 회원 관리</title>

<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">



<style>

/* [1. 초기화 & 공통] */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	outline: none;
}

body {
	font-family: 'Noto Sans KR', sans-serif;
	background-color: #f5f6fa;
	color: #333;
	display: flex;
	height: 100vh;
	overflow: hidden;
}

a {
	text-decoration: none;
	color: inherit;
}

ul {
	list-style: none;
}

button {
	border: none;
	cursor: pointer;
	font-family: 'Noto Sans KR', sans-serif;
}

input, select {
	font-family: 'Noto Sans KR', sans-serif;
}

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

.menu-list {
	padding: 20px 0;
	flex: 1;
	overflow-y: auto;
}

.menu-category {
	font-size: 11px;
	font-weight: 700;
	text-transform: uppercase;
	color: #5e6278;
	padding: 10px 25px;
	margin-top: 15px;
}

.menu-category:first-child {
	margin-top: 0;
}

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

.menu-icon {
	width: 25px;
	font-size: 16px;
	text-align: center;
	margin-right: 10px;
}

.sidebar-footer {
	padding: 20px;
	border-top: 1px solid #2d2d3f;
	display: flex;
	align-items: center;
	gap: 12px;
	background-color: #1e1e2d;
}

.admin-avatar {
	width: 40px;
	height: 40px;
	background-color: #503396;
	border-radius: 50%;
	display: flex;
	justify-content: center;
	align-items: center;
	color: #fff;
	font-weight: bold;
	font-size: 14px;
}

.admin-info h4 {
	font-size: 14px;
	color: #fff;
	font-weight: 500;
	margin-bottom: 2px;
}

.admin-info p {
	font-size: 12px;
	color: #727589;
}

/* [3. 메인 컨텐츠] */
.main-content {
	flex: 1;
	display: flex;
	flex-direction: column;
	min-width: 0;
}

/* [헤더] */
.top-header {
	height: 80px;
	background-color: #ffffff;
	border-bottom: 1px solid #e1e1e1;
	display: flex;
	justify-content: space-between; /* 양끝 정렬 */
	align-items: center;
	padding: 0 30px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
}

.header-left-title h2 {
	font-size: 24px;
	font-weight: 800;
	color: #1e1e2d;
	margin-bottom: 4px;
	letter-spacing: -0.5px;
}

.header-left-title p {
	font-size: 13px;
	color: #888;
	font-weight: 500;
}

.header-right {
	display: flex;
	align-items: center;
	gap: 20px;
	margin-left: 20px;
}

.logout-btn {
	padding: 8px 16px;
	border: 1px solid #e1e1e1;
	background-color: #fff;
	border-radius: 6px;
	font-size: 12px;
	font-weight: 600;
	color: #5e6278;
	transition: 0.2s;
}

.logout-btn:hover {
	background-color: #f9f9f9;
	border-color: #d1d1d1;
	color: #333;
}

/* [4. 본문 컨텐츠] */
.content-wrapper {
	flex: 1;
	padding: 30px;
	overflow-y: auto;
}

/* 필터 카드 */
.filter-card {
	background: #fff;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
	margin-bottom: 25px;
	display: flex;
	gap: 10px;
	align-items: center;
}

.filter-input {
	height: 45px;
	border: 1px solid #ddd;
	border-radius: 6px;
	padding: 0 15px;
	font-size: 14px;
	color: #555;
}

.filter-input-long {
	flex: 1;
}

.filter-btn {
	height: 45px;
	padding: 0 30px;
	background-color: #1e1e2d;
	color: #fff;
	border-radius: 6px;
	font-size: 14px;
	font-weight: 600;
	transition: 0.2s;
}

.filter-btn:hover {
	background-color: #333;
}

.reset-btn {
	height: 45px;
	padding: 0 20px;
	background-color: #fff;
	color: #555;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-size: 14px;
	font-weight: 600;
	transition: 0.2s;
}

.reset-btn:hover {
	background-color: #f9f9f9;
}

/* 테이블 영역 */
.table-container {
	background: #fff;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
}

.table-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.total-count {
	font-size: 14px;
	color: #555;
	font-weight: 600;
}

.total-count span {
	color: #503396;
}

.btn-group {
	display: flex;
	gap: 8px;
}

.action-btn-top {
	padding: 8px 16px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	border: 1px solid transparent;
	cursor: pointer;
	transition: 0.2s;
	display: flex;
	align-items: center;
	gap: 5px;
}

.btn-activate {
	background-color: #e8fff3;
	color: #1bc5bd;
	border-color: #c9f7f5;
}

.btn-activate:hover {
	background-color: #d7fbe8;
}

.btn-delete {
	background-color: #fdedec;
	color: #e74c3c;
	border-color: #fadbd8;
}

.btn-delete:hover {
	background-color: #fceae9;
}

table {
	width: 100%;
	border-collapse: collapse;
	font-size: 14px;
}

th {
	background-color: #f9f9f9;
	color: #5e6278;
	font-weight: 600;
	text-align: center;
	padding: 15px 25px;
	border-bottom: 1px solid #eee;
}

td {
	padding: 15px 25px;
	border-bottom: 1px solid #f5f5f5;
	color: #3f4254;
	text-align: center;
	vertical-align: middle;
	transition: background-color 0.2s;
}

tbody tr {
	cursor: pointer;
}

tbody tr:hover {
	background-color: #f8f9fa;
}

.sort-icon {
	font-size: 11px;
	margin-left: 5px;
	color: #aaa;
	cursor: pointer;
}

.sort-icon:hover {
	color: #503396;
}

.action-btn {
	padding: 6px 12px;
	border-radius: 4px;
	font-size: 12px;
	font-weight: 600;
	border: 1px solid #ddd;
	background: #fff;
	color: #555;
	transition: 0.2s;
	cursor: pointer;
}

.action-btn:hover {
	background-color: #f0f0f0;
}

.pagination {
	display: flex;
	justify-content: center;
	margin-top: 30px;
	gap: 5px;
}

.page-link {
	width: 35px;
	height: 35px;
	display: flex;
	justify-content: center;
	align-items: center;
	border: 1px solid #eee;
	border-radius: 6px;
	font-size: 13px;
	color: #555;
	transition: 0.2s;
}

.page-link:hover {
	background-color: #f5f5f5;
	border-color: #ddd;
}

.page-link.active {
	background-color: #503396;
	color: #fff;
	border-color: #503396;
	font-weight: 700;
}

.status-active {
	color: #1bc5bd;
	font-weight: 700;
	background: #e8fff3;
	padding: 4px 10px;
	border-radius: 4px;
	font-size: 12px;
}

.status-inactive {
	color: #ffa800;
	font-weight: 700;
	background: #fff4de;
	padding: 4px 10px;
	border-radius: 4px;
	font-size: 12px;
}

/* [기존: 상세 모달 스타일] */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 2000;
	justify-content: center;
	align-items: center;
}

.modal-card {
	background-color: #fff;
	width: 500px;
	border-radius: 12px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
	overflow: hidden;
	animation: fadeIn 0.3s ease-out;
}

@keyframes fadeIn {
    from { opacity:0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}

.modal-header {
	padding: 20px 25px;
	border-bottom: 1px solid #eee;
	display: flex;
	justify-content: space-between;
	align-items: center;
	background-color: #f9f9f9;
}

.modal-title {
	font-size: 18px;
	font-weight: 700;
	color: #333;
}

.modal-close {
	font-size: 20px;
	color: #999;
	cursor: pointer;
	transition: 0.2s;
}

.modal-close:hover {
	color: #333;
}

.modal-body {
	padding: 30px 25px;
}

.detail-table {
	width: 100%;
	border-collapse: collapse;
}

.detail-table th {
	width: 140px;
	text-align: left;
	padding: 12px 0;
	color: #5e6278;
	font-weight: 600;
	font-size: 14px;
	border-bottom: 1px solid #f5f5f5;
}

.detail-table td {
	padding: 12px 0;
	color: #333;
	font-size: 14px;
	border-bottom: 1px solid #f5f5f5;
}

.detail-table tr:last-child th, .detail-table tr:last-child td {
	border-bottom: none;
}

.modal-footer {
	padding: 20px 25px;
	border-top: 1px solid #eee;
	text-align: right;
	background-color: #f9f9f9;
}

.modal-btn {
	padding: 8px 20px;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	cursor: pointer;
}

.btn-close {
	background: #fff;
	border: 1px solid #ddd;
	color: #555;
}


/* [NEW: 확인 모달 스타일 추가] */
.confirm-card {
    background-color: #fff; width: 400px; border-radius: 12px; text-align: center;
    padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}
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
			<a href="../admin_dashboard/Admin_Dashboard.jsp"><img
				src="../../resources/img/2GV_LOGO_empty.png"></a>
		</div>

		<div class="menu-list">

			<div class="menu-category">MAIN</div>

			<ul>
				<li><a href="../admin_dashboard/Admin_Dashboard.jsp"
					class="menu-link"><i class="fa-solid fa-chart-pie menu-icon"></i><span>메인
							페이지</span></a></li>
			</ul>

			<div class="menu-category">RESOURCE</div>

			<ul>

				<li><a href="../admin_usermanagement/Admin_UserManagement.jsp" class="menu-link active"><i
						class="fa-solid fa-users menu-icon"></i><span>회원 관리</span></a></li>

				<li><a href="../admin_theatermanagement/Admin_TheaterManagement.jsp" class="menu-link"><i
						class="fa-solid fa-couch menu-icon"></i><span>상영관 관리</span></a></li>

				<li><a href="../admin_moviemanagement/Admin_MovieList.jsp" class="menu-link"><i
						class="fa-solid fa-film menu-icon"></i><span>영화 관리</span></a></li>

			</ul>

			<div class="menu-category">SERVICE</div>

			<ul>

				<li><a href="../admin_reservationmanagement/Admin_ReservationList.jsp" class="menu-link"><i
						class="fa-solid fa-ticket menu-icon"></i><span>예매 관리</span></a></li>

				<li><a href="../admin_schedulemanagement/Admin_ScreeningList.jsp" class="menu-link"><i
						class="fa-solid fa-calendar-days menu-icon"></i><span>상영
							스케줄 관리</span></a></li>

			</ul>

			<div class="menu-category">BOARD</div>

			<ul>

				<li><a href="../admin_reviewmanagement/Admin_ReviewList.jsp" class="menu-link"><i
						class="fa-solid fa-comments menu-icon"></i><span>리뷰 관리</span></a></li>

				<li><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="menu-link"><i
						class="fa-solid fa-bullhorn menu-icon"></i><span>공지 사항</span></a></li>

			</ul>

		</div>

		<div class="sidebar-footer">

			<div class="admin-avatar">AD</div>

			<div class="admin-info">
				<h4>최고관리자</h4>
				<p>Super Admin</p>
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

				<button class="logout-btn"
					onclick="location.href='../admin_login/Admin_Login.jsp'">로그아웃</button>

			</div>

		</header>



		<div class="content-wrapper">

			<div class="filter-card">

				<input type="text" class="filter-input filter-input-long"
					placeholder="이름, 아이디, 이메일, 전화번호를 입력하세요">

				<button class="filter-btn">조회</button>

				<button class="reset-btn">
					<i class="fa-solid fa-rotate-right"></i>
				</button>

			</div>



			<div class="table-container">

				<div class="table-header">

					<p class="total-count">
						총 <span>124</span>명의 회원이 검색되었습니다.
					</p>

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

						<tr
							onclick="openModal('user1234', '홍길동', '010-1234-5678', 'hong@naver.com', '1990.05.05', '남', '2024.01.15', '2025.11.25', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>user1234</td>

							<td>홍길동</td>

							<td>hong@naver.com</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('user1234', '홍길동', '010-1234-5678', 'hong@naver.com', '1990.05.05', '남', '2024.01.15', '2025.11.25', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('hong_gd', '김철수', '010-9876-5432', 'cheolsu@gmail.com', '1995.12.25', '남', '2024.02.10', '2025.11.20', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>hong_gd</td>

							<td>김철수</td>

							<td>cheolsu@gmail.com</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('hong_gd', '김철수', '010-9876-5432', 'cheolsu@gmail.com', '1995.12.25', '남', '2024.02.10', '2025.11.20', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('test_user', '이영희', '010-1111-2222', 'younghee@daum.net', '1998.08.08', '여', '2024.03.01', '2025.10.05', '비활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>test_user</td>

							<td>이영희</td>

							<td>younghee@daum.net</td>

							<td><span class="status-inactive">비활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('test_user', '이영희', '010-1111-2222', 'younghee@daum.net', '1998.08.08', '여', '2024.03.01', '2025.10.05', '비활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('admin_01', '박민수', '010-3333-4444', 'minsoo@nate.com', '1988.07.07', '남', '2024.03.15', '2025.11.01', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>admin_01</td>

							<td>박민수</td>

							<td>minsoo@nate.com</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('admin_01', '박민수', '010-3333-4444', 'minsoo@nate.com', '1988.07.07', '남', '2024.03.15', '2025.11.01', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('movie_lover', '최지우', '010-5555-6666', 'jiwoo@kakao.com', '2000.01.01', '여', '2024.04.02', '2025.11.15', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>movie_lover</td>

							<td>최지우</td>

							<td>jiwoo@kakao.com</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('movie_lover', '최지우', '010-5555-6666', 'jiwoo@kakao.com', '2000.01.01', '여', '2024.04.02', '2025.11.15', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('popcorn123', '정재현', '010-7777-8888', 'jaehyun@icloud.com', '1992.06.15', '남', '2024.04.10', '2025.09.20', '비활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>popcorn123</td>

							<td>정재현</td>

							<td>jaehyun@icloud.com</td>

							<td><span class="status-inactive">비활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('popcorn123', '정재현', '010-7777-8888', 'jaehyun@icloud.com', '1992.06.15', '남', '2024.04.10', '2025.09.20', '비활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('cinema_king', '강하늘', '010-9999-0000', 'sky@naver.com', '1993.09.09', '남', '2024.05.01', '2025.11.10', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>cinema_king</td>

							<td>강하늘</td>

							<td>sky@naver.com</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('cinema_king', '강하늘', '010-9999-0000', 'sky@naver.com', '1993.09.09', '남', '2024.05.01', '2025.11.10', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('blue_sky', '송혜교', '010-1212-3434', 'song@gmail.com', '1985.11.22', '여', '2024.05.15', '2025.11.22', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>blue_sky</td>

							<td>송혜교</td>

							<td>song@gmail.com</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('blue_sky', '송혜교', '010-1212-3434', 'song@gmail.com', '1985.11.22', '여', '2024.05.15', '2025.11.22', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('star_wars', '이정재', '010-5656-7878', 'jjlee@daum.net', '1972.12.15', '남', '2024.06.01', '2025.11.24', '활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>star_wars</td>

							<td>이정재</td>

							<td>jjlee@daum.net</td>

							<td><span class="status-active">활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('star_wars', '이정재', '010-5656-7878', 'jjlee@daum.net', '1972.12.15', '남', '2024.06.01', '2025.11.24', '활성화')">상세</button></td>

						</tr>

						<tr
							onclick="openModal('bad_guy', '마동석', '010-4545-6767', 'ma@naver.com', '1971.03.01', '남', '2024.06.10', '2025.10.30', '비활성화')">

							<td onclick="event.stopPropagation()"><input type="checkbox"
								class="row-check"></td>

							<td>bad_guy</td>

							<td>마동석</td>

							<td>ma@naver.com</td>

							<td><span class="status-inactive">비활성화</span></td>

							<td><button class="action-btn"
									onclick="event.stopPropagation(); openModal('bad_guy', '마동석', '010-4545-6767', 'ma@naver.com', '1971.03.01', '남', '2024.06.10', '2025.10.30', '비활성화')">상세</button></td>

						</tr>

					</tbody>

				</table>



				<div class="pagination">

					<a href="#" class="page-link"><i
						class="fa-solid fa-chevron-left"></i></a> <a href="#"
						class="page-link active">1</a> <a href="#" class="page-link">2</a>

					<a href="#" class="page-link">3</a> <a href="#" class="page-link">4</a>

					<a href="#" class="page-link">5</a> <a href="#" class="page-link"><i
						class="fa-solid fa-chevron-right"></i></a>

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

					<tr>
						<th>아이디</th>
						<td id="modalId"></td>
					</tr>

					<tr>
						<th>이름</th>
						<td id="modalName"></td>
					</tr>

					<tr>
						<th>전화번호</th>
						<td id="modalPhone"></td>
					</tr>

					<tr>
						<th>이메일</th>
						<td id="modalEmail"></td>
					</tr>

					<tr>
						<th>생년월일</th>
						<td id="modalBirth"></td>
					</tr>

					<tr>
						<th>성별</th>
						<td id="modalGender"></td>
					</tr>

					<tr>
						<th>가입일</th>
						<td id="modalJoinDate"></td>
					</tr>

					<tr>
						<th>마지막 로그인</th>
						<td id="modalLastLogin"></td>
					</tr>

					<tr>
						<th>계정 상태</th>
						<td id="modalStatus"></td>
					</tr>

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

// 상세 모달 열기
function openModal(id, name, phone, email, birth, gender, joinDate, lastLogin, status) {

document.getElementById('modalId').innerText = id;

document.getElementById('modalName').innerText = name;

document.getElementById('modalPhone').innerText = phone;

document.getElementById('modalEmail').innerText = email;

document.getElementById('modalBirth').innerText = birth;

document.getElementById('modalGender').innerText = gender;

document.getElementById('modalJoinDate').innerText = joinDate;

document.getElementById('modalLastLogin').innerText = lastLogin;


let statusHtml = (status === '활성화') ? '<span class="status-active">활성화</span>' : '<span class="status-inactive">비활성화</span>';

document.getElementById('modalStatus').innerHTML = statusHtml;

document.getElementById('userModal').style.display = 'flex';

}

function closeModal() { document.getElementById('userModal').style.display = 'none'; }

// [NEW: 확인 모달 열기]
let currentAction = '';

function openConfirmModal(action) {
    // 1. 체크된 항목 있는지 확인
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

    // 2. 액션에 따라 내용 변경 (활성 vs 비활성)
    if (action === 'active') {
        title.innerText = "활성화하시겠습니까?";
        icon.innerHTML = '<i class="fa-solid fa-circle-check" style="color:#1bc5bd"></i>';
        btn.style.backgroundColor = "#1bc5bd";
    } else {
        title.innerText = "비활성화하시겠습니까?";
        icon.innerHTML = '<i class="fa-solid fa-ban" style="color:#e74c3c"></i>';
        btn.style.backgroundColor = "#e74c3c";
    }
    
    // 3. 모달 띄우기
    modal.style.display = 'flex';
}

function closeConfirmModal() {
    document.getElementById('confirmModal').style.display = 'none';
}

function executeAction() {
    alert("처리가 완료되었습니다.");
    closeConfirmModal();
    // 실제로는 여기서 form submit이나 ajax 호출
}

// 외부 클릭 닫기 (상세모달 & 확인모달)
window.onclick = function(event) {
    if (event.target == document.getElementById('userModal')) closeModal();
    if (event.target == document.getElementById('confirmModal')) closeConfirmModal();
}


const checkAll = document.getElementById('checkAll');

const rowChecks = document.querySelectorAll('.row-check');

checkAll.addEventListener('change', function() { rowChecks.forEach(checkbox => { checkbox.checked = this.checked; }); });


const pageLinks = document.querySelectorAll('.page-link');

pageLinks.forEach(link => {

link.addEventListener('click', function(e) {

e.preventDefault();

if(!this.innerHTML.includes('fa-chevron')) {

pageLinks.forEach(item => item.classList.remove('active'));

this.classList.add('active');

}

});

});

</script>



</body>

</html>