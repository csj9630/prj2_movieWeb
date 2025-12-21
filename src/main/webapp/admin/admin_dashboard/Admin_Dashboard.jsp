<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

<title>2GV Admin Dashboard</title>

<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>



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

.top-header {
	height: 80px;
	background-color: #ffffff;
	border-bottom: 1px solid #e1e1e1;
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 0 30px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.02);
}

/* [추가] 스타일 맨 아래나 적당한 곳에 붙여넣으세요 */
.header-title {
	font-size: 24px;
	font-weight: 800;
	color: #1e1e2d;
	letter-spacing: -0.5px;
}

.header-search-bar {
	display: flex;
	align-items: center;
	gap: 10px;
	flex: 1;
	max-width: 1500px;
}

.search-select, .search-input {
	height: 40px;
	padding: 0 15px;
	border: 1px solid #e1e1e1;
	border-radius: 6px;
	font-size: 13px;
	color: #5e6278;
	background-color: #f9f9f9;
	transition: 0.2s;
}

.search-select:focus, .search-input:focus {
	border-color: #503396;
	background-color: #fff;
}

.search-input {
	flex: 1;
}

.search-btn {
	height: 40px;
	padding: 0 20px;
	background-color: #503396;
	color: #fff;
	font-weight: 700;
	font-size: 13px;
	border-radius: 6px;
	display: flex;
	align-items: center;
	gap: 5px;
	transition: 0.2s;
}

.search-btn:hover {
	background-color: #3e257a;
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

/* [4. 본문 컨텐츠 (수정됨)] */
.content-wrapper {
	flex: 1;
	/* [수정] 상단 패딩을 30px -> 60px로 늘려 아래로 내림 */
	padding: 60px 30px 30px 30px;
	overflow-y: auto;
}

/* 차트 섹션 */
.charts-row {
	display: flex;
	gap: 25px;
	margin-bottom: 25px;
	height: 45vh;
	min-height: 300px;
}

.chart-card {
	background: #fff;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
	flex: 1;
	display: flex;
	flex-direction: column;
	min-width: 0;
}

.chart-title {
	font-size: 16px;
	font-weight: 700;
	color: #1e1e2d;
	margin-bottom: 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.chart-body {
	flex: 1;
	position: relative;
	width: 100%;
	height: 100%;
	overflow: hidden;
}

/* 공지사항 & 리뷰 섹션 */
.board-row {
	display: flex;
	gap: 25px;
	margin-bottom: 25px;
}

.board-card {
	flex: 1;
	background: #fff;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.03);
}

.board-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 15px;
	padding-bottom: 10px;
	border-bottom: 1px solid #f0f0f0;
}

.board-title {
	font-size: 16px;
	font-weight: 700;
	color: #1e1e2d;
}

.more-link {
	font-size: 12px;
	color: #aaa;
	transition: 0.2s;
}

.more-link:hover {
	color: #503396;
}

.mini-list {
	width: 100%;
}

.mini-item {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 12px 0;
	border-bottom: 1px solid #f9f9f9;
	font-size: 13px;
	color: #555;
}

.mini-item:last-child {
	border-bottom: none;
}

.mini-item:hover {
	background-color: #fafafa;
}

.item-subject {
	flex: 1;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	margin-right: 15px;
	cursor: pointer;
}

.item-subject:hover {
	text-decoration: underline;
}

.item-meta {
	font-size: 12px;
	color: #999;
	min-width: 80px;
	text-align: right;
}

.star-rating {
	color: #ffc107;
	font-size: 12px;
	margin-right: 5px;
}
</style>

</head>

<body>



	<nav class="sidebar">

		<div class="logo-area">

			<a href="../admin_dashboard/Admin_Dashboard.jsp"><img
				src="../../resources/img/2GV_LOGO_empty.png" title="관리자 홈으로 이동"></a>

		</div>

		<div class="menu-list">

			<div class="menu-category">MAIN</div>

			<ul>
				<li><a href="../admin_dashboard/Admin_Dashboard.jsp"
					class="menu-link active"><i
						class="fa-solid fa-chart-pie menu-icon"></i><span>메인 페이지</span></a></li>
			</ul>

			<div class="menu-category">RESOURCE</div>

			<ul>

				<li><a href="../admin_usermanagement/Admin_UserManagement.jsp"
					class="menu-link"><i class="fa-solid fa-users menu-icon"></i><span>회원
							관리</span></a></li>

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

			<div class="header-title">관리자 대시보드</div>



			<div class="header-right">

				<button class="logout-btn" onclick="location.href='../admin_login/admin_logout.jsp'">로그아웃</button>

			</div>

		</header>



		<div class="content-wrapper">


			<div class="charts-row">

				<div class="chart-card">

					<div class="chart-title">
						일일 예매율 (최근 7일) <i class="fa-solid fa-chart-line"
							style="color: #503396"></i>
					</div>

					<div class="chart-body">
						<canvas id="bookingChart"></canvas>
					</div>

				</div>

				<div class="chart-card">

					<div class="chart-title">
						TOP 5 인기 영화 <i class="fa-solid fa-ranking-star"
							style="color: #503396"></i>
					</div>

					<div class="chart-body">
						<canvas id="movieRankChart"></canvas>
					</div>

				</div>

			</div>



			<div class="board-row">

				<div class="board-card">

					<div class="board-header">
						<span class="board-title">공지사항</span><a href="../admin_noticemanagement/Admin_NoticeList.jsp" class="more-link">더보기
							+</a>
					</div>

					<div class="mini-list">

						<div class="mini-item">
							<span class="item-subject">[공지] 12월 시스템 정기 점검 안내 (12/05)</span><span
								class="item-meta">2025.11.25</span>
						</div>

						<div class="mini-item">
							<span class="item-subject">[이벤트] 2GV 멤버십 VIP 혜택 변경 안내</span><span
								class="item-meta">2025.11.24</span>
						</div>

						<div class="mini-item">
							<span class="item-subject">[안내] 겨울철 상영관 적정 온도 유지 안내</span><span
								class="item-meta">2025.11.22</span>
						</div>

						<div class="mini-item">
							<span class="item-subject">[채용] 2GV 하반기 공개 채용 합격자 발표</span><span
								class="item-meta">2025.11.20</span>
						</div>

					</div>

				</div>

				<div class="board-card">

					<div class="board-header">
						<span class="board-title">새로 등록된 리뷰</span><a href="../admin_reviewmanagement/Admin_ReviewList.jsp"
							class="more-link">더보기 +</a>
					</div>

					<div class="mini-list">

						<div class="mini-item">
							<span class="item-subject">[범죄도시4] 진짜 마석도 형사님 최고에요! ㅋㅋ</span><span
								class="item-meta"><i class="fa-solid fa-star star-rating"></i>
								5.0</span>
						</div>

						<div class="mini-item">
							<span class="item-subject">[퓨리오사] 액션 미쳤다... 시간 가는 줄 모름</span><span
								class="item-meta"><i class="fa-solid fa-star star-rating"></i>
								4.5</span>
						</div>

						<div class="mini-item">
							<span class="item-subject">[설계자] 강동원 얼굴 보러 갔다가 실망함 ㅠ</span><span
								class="item-meta"><i class="fa-solid fa-star star-rating"></i>
								2.0</span>
						</div>

						<div class="mini-item">
							<span class="item-subject">[인사이드 아웃2] 너무 감동적이에요 ㅠㅠ 똥꼬에서
								피눈물남</span><span class="item-meta"><i
								class="fa-solid fa-star star-rating"></i> 5.0</span>
						</div>

					</div>

				</div>

			</div>



		</div>

	</main>



	<script>
		// 1. 일일 예매율 차트

		const ctxBooking = document.getElementById('bookingChart').getContext(
				'2d');

		new Chart(ctxBooking, {

			type : 'line',

			data : {

				labels : [ '11/20', '11/21', '11/22', '11/23', '11/24',
						'11/25', '11/26' ],

				datasets : [ {

					label : '예매 수',

					data : [ 120, 150, 180, 250, 300, 280, 150 ],

					borderColor : '#503396',

					backgroundColor : 'rgba(80, 51, 150, 0.1)',

					borderWidth : 2,

					fill : true,

					tension : 0.4

				} ]

			},

			options : {

				responsive : true,

				maintainAspectRatio : false,

				plugins : {
					legend : {
						display : false
					}
				},

				scales : {

					y : {
						beginAtZero : true,
						grid : {
							borderDash : [ 2, 2 ]
						}
					},

					x : {
						grid : {
							display : false
						}
					}

				}

			}

		});

		// 2. 인기 영화 차트

		const ctxMovie = document.getElementById('movieRankChart').getContext(
				'2d');

		new Chart(ctxMovie, {

			type : 'doughnut',

			data : {

				labels : [ '범죄도시4', '퓨리오사', '설계자', '인사이드 아웃2', '원더랜드' ],

				datasets : [ {

					data : [ 45, 25, 15, 10, 5 ],

					backgroundColor : [ '#503396', '#7b5ac2', '#a285e0',
							'#cbb4fc', '#e0d4fc' ],

					borderWidth : 0,

					hoverOffset : 4

				} ]

			},

			options : {

				responsive : true,

				maintainAspectRatio : false,

				plugins : {
					legend : {
						position : 'right'
					}
				}

			}

		});
	</script>



</body>

</html>