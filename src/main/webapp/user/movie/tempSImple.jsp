<%@page import="movie.detail.DetailDTO"%>
<%@page import="movie.detail.DetailDAO"%>
<%@page import="movie.detail.DetailService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../../fragments/siteProperty.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
%>



<!DOCTYPE html>
<html lang="ko" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>asdfg</title>
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" />
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="${commonURL}/resources/css/movie_detail.css" />
<script src="${commonURL}/resources/js/tempSimple.js"></script>
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">



<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700;900&family=Playfair+Display:wght@700;900&display=swap"
	rel="stylesheet" />
<style>
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

:root {
	--primary-red: #e50914;
	--dark-bg: #ffffff;
	--card-bg: #ffffff;
	--text-primary: #222222;
	--text-secondary: #666666;
	--accent-gold: #ffd700;
	--hover-bg: #f8f8f8;
	--border-color: #e0e0e0;
	--success-green: #46d369;
}

body {
	font-family: "Noto Sans KR", sans-serif;
	background: #f5f5f5;
	color: var(--text-primary);
	min-height: 100vh;
	overflow-x: hidden;
	position: relative;
}

body::before {
	content: "";
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: transparent;
	pointer-events: none;
	z-index: 0;
}

.container {
	max-width: 1400px;
	margin: 0 auto;
	padding: 20px;
	position: relative;
	z-index: 1;
}

.header2 {
	background: #ffffff;
	backdrop-filter: blur(20px);
	padding: 25px 0;
	border-bottom: 1px solid var(--border-color);
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	position: sticky;
	top: 0;
	z-index: 1000;
	animation: slideDown 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

@
keyframes slideDown {from { transform:translateY(-100%);
	opacity: 0;
}

to {
	transform: translateY(0);
	opacity: 1;
}

}
h1 {
	font-family: "Noto Sans KR", sans-serif;
	font-size: 2.8em;
	font-weight: 900;
	text-align: left;
	background: linear-gradient(135deg, var(--text-primary), #000);
	-webkit-background-clip: text;
	-webkit-text-fill-color: transparent;
	background-clip: text;
	letter-spacing: -1px;
}

.date-selector {
	background: #ffffff;
	backdrop-filter: blur(10px);
	padding: 20px;
	border-radius: 12px;
	margin: 30px 0;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	border: 1px solid var(--border-color);
	animation: fadeInUp 0.6s ease-out 0.2s both;
}

@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(30px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.date-scroll {
	display: flex;
	gap: 12px;
	overflow-x: auto;
	padding: 10px 0;
	scrollbar-width: thin;
	scrollbar-color: var(--primary-red) transparent;
}

.date-scroll::-webkit-scrollbar {
	height: 6px;
}

.date-scroll::-webkit-scrollbar-track {
	background: transparent;
}

.date-scroll::-webkit-scrollbar-thumb {
	background: var(--primary-red);
	border-radius: 3px;
}

.date-item {
	min-width: 100px;
	padding: 15px 20px;
	text-align: center;
	background: #f8f8f8;
	border: 2px solid transparent;
	border-radius: 12px;
	cursor: pointer;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	position: relative;
	overflow: hidden;
}

.date-item::before {
	content: "";
	position: absolute;
	top: 0;
	left: -100%;
	width: 100%;
	height: 100%;
	background: linear-gradient(90deg, transparent, rgba(229, 9, 20, 0.05),
		transparent);
	transition: left 0.5s;
}

.date-item:hover::before {
	left: 100%;
}

.date-item:hover {
	transform: translateY(-3px) scale(1.05);
	border-color: var(--primary-red);
	background: rgba(229, 9, 20, 0.05);
	box-shadow: 0 4px 12px rgba(229, 9, 20, 0.15);
}

.date-item.active {
	background: var(--primary-red);
	border-color: var(--primary-red);
	color: white;
	transform: scale(1.08);
	box-shadow: 0 4px 16px rgba(229, 9, 20, 0.3);
}

.date-day {
	font-size: 1.1em;
	font-weight: 700;
	margin-bottom: 5px;
}

.date-weekday {
	font-size: 0.85em;
	color: var(--text-secondary);
}

.date-item.active .date-weekday {
	color: rgba(255, 255, 255, 0.9);
}

.main-content {
	display: grid;
	grid-template-columns: 680px 1fr;
	gap: 25px;
	margin-top: 30px;
	animation: fadeInUp 0.6s ease-out 0.4s both;
}

.section {
	background: #ffffff;
	backdrop-filter: blur(10px);
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
	border: 1px solid var(--border-color);
	transition: all 0.3s ease;
}

.section:hover {
	border-color: #d0d0d0;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.section-title {
	font-size: 1.4em;
	font-weight: 700;
	margin-bottom: 20px;
	padding-bottom: 12px;
	border-bottom: 2px solid var(--primary-red);
	display: flex;
	align-items: center;
	gap: 10px;
}

.section-title::before {
	content: "";
	width: 4px;
	height: 24px;
	background: linear-gradient(180deg, var(--primary-red),
		var(--accent-gold));
	border-radius: 2px;
}

.tab-buttons {
	display: flex;
	gap: 10px;
	margin-bottom: 20px;
}

.tab-btn {
	flex: 1;
	padding: 12px;
	background: #f8f8f8;
	border: none;
	border-radius: 8px;
	color: var(--text-primary);
	cursor: pointer;
	font-weight: 500;
	transition: all 0.3s ease;
	position: relative;
	overflow: hidden;
}

.tab-btn::after {
	content: "";
	position: absolute;
	bottom: 0;
	left: 0;
	width: 100%;
	height: 2px;
	background: var(--primary-red);
	transform: scaleX(0);
	transition: transform 0.3s ease;
}

.tab-btn:hover {
	background: rgba(229, 9, 20, 0.05);
}

.tab-btn.active {
	background: var(--primary-red);
	color: white;
	font-weight: 700;
}

.tab-btn.active::after {
	transform: scaleX(1);
}

.movie-list {
	max-height: 600px;
	overflow-y: auto;
	scrollbar-width: thin;
	scrollbar-color: var(--primary-red) transparent;
}

.movie-list::-webkit-scrollbar {
	width: 6px;
}

.movie-list::-webkit-scrollbar-track {
	background: transparent;
}

.movie-list::-webkit-scrollbar-thumb {
	background: var(--primary-red);
	border-radius: 3px;
}

.movie-item {
	padding: 18px 20px;
	margin-bottom: 0;
	border-radius: 0;
	cursor: pointer;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	border: none;
	border-bottom: 1px solid var(--border-color);
	background: transparent;
	position: relative;
	overflow: hidden;
	display: flex;
	align-items: center;
	justify-content: space-between;
}

.movie-item::before {
	content: "";
	position: absolute;
	left: 0;
	top: 0;
	width: 4px;
	height: 100%;
	background: var(--primary-red);
	transform: scaleY(0);
	transition: transform 0.3s ease;
}

.movie-item:hover::before {
	transform: scaleY(1);
}

.movie-item:hover {
	background: #fafafa;
	transform: translateX(0);
	border-color: rgba(229, 9, 20, 0.2);
}

.movie-item.selected {
	background: #f5f5f5;
	border-color: rgba(229, 9, 20, 0.3);
	transform: translateX(0);
}

.movie-item.selected::before {
	transform: scaleY(1);
}

.movie-title {
	font-weight: 600;
	font-size: 1.05em;
	display: flex;
	align-items: center;
	gap: 10px;
}

.movie-rating {
	display: inline-flex;
	align-items: center;
	justify-content: center;
	min-width: 32px;
	height: 32px;
	padding: 0 10px;
	border-radius: 4px;
	font-size: 0.85em;
	font-weight: 700;
	flex-shrink: 0;
}

.rating-all {
	background: #50c759;
	color: white;
}

.rating-12 {
	background: #f4c518;
	color: #141414;
}

.rating-15 {
	background: #ff8a3d;
	color: white;
}

.rating-19 {
	background: #e50914;
	color: white;
}

.favorite-btn {
	width: 28px;
	height: 28px;
	border: 1px solid var(--border-color);
	background: transparent;
	border-radius: 4px;
	cursor: pointer;
	transition: all 0.3s ease;
	display: flex;
	align-items: center;
	justify-content: center;
	color: var(--text-secondary);
}

.favorite-btn:hover {
	border-color: var(--primary-red);
	color: var(--primary-red);
	background: rgba(229, 9, 20, 0.05);
}

.time-selector {
	display: flex;
	gap: 8px;
	margin-bottom: 20px;
	flex-wrap: wrap;
}

.time-badge {
	padding: 8px 16px;
	background: #f8f8f8;
	border: 1px solid var(--border-color);
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.3s ease;
	font-size: 0.95em;
}

.time-badge:hover {
	background: rgba(229, 9, 20, 0.05);
	border-color: var(--primary-red);
}

.time-badge.active {
	background: var(--primary-red);
	border-color: var(--primary-red);
	color: white;
	font-weight: 600;
}

.showtime-list {
	max-height: 600px;
	overflow-y: auto;
}

.showtime-item {
	background: transparent;
	padding: 18px 20px;
	margin-bottom: 0;
	border-radius: 0;
	border: none;
	border-bottom: 1px solid var(--border-color);
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	position: relative;
	overflow: hidden;
	display: grid;
	grid-template-columns: auto 1fr auto;
	align-items: center;
	gap: 20px;
}

.showtime-item::after {
	display: none;
}

.showtime-item:hover {
	background: #fafafa;
	border-color: rgba(229, 9, 20, 0.2);
	transform: scale(1);
	box-shadow: none;
}

.showtime-header {
	display: flex;
	flex-direction: column;
	gap: 5px;
	margin-bottom: 0;
}

.showtime-time {
	font-size: 1.6em;
	font-weight: 900;
	color: var(--text-primary);
	text-shadow: none;
}

.showtime-end {
	font-size: 0.85em;
	color: var(--text-secondary);
}

.showtime-badge {
	background: transparent;
	padding: 0;
	border-radius: 0;
	font-size: 0.9em;
	font-weight: 400;
	box-shadow: none;
	color: var(--text-secondary);
}

.showtime-details {
	display: flex;
	flex-direction: column;
	gap: 5px;
	color: var(--text-secondary);
	font-size: 0.9em;
	grid-template-columns: 1fr;
}

.showtime-detail {
	display: flex;
	align-items: center;
	gap: 8px;
}

.showtime-detail strong {
	color: var(--text-primary);
}

.showtime-footer {
	margin-top: 0;
	padding-top: 0;
	border-top: none;
	display: flex;
	flex-direction: column;
	align-items: flex-end;
	gap: 8px;
}

.showtime-screen {
	font-size: 1.05em;
	font-weight: 600;
	color: var(--text-primary);
}

.showtime-theater {
	font-size: 0.9em;
	color: var(--text-secondary);
}

.showtime-info-right {
	text-align: right;
}

.seat-info {
	font-size: 0.95em;
}

.seat-available {
	color: var(--success-green);
	font-weight: 700;
}

.book-btn {
	padding: 12px 28px;
	background: var(--primary-red);
	border: none;
	border-radius: 8px;
	color: white;
	font-weight: 700;
	cursor: pointer;
	transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
	box-shadow: 0 2px 8px rgba(229, 9, 20, 0.2);
	position: relative;
	overflow: hidden;
}

.book-btn::before {
	content: "";
	position: absolute;
	top: 50%;
	left: 50%;
	width: 0;
	height: 0;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.3);
	transform: translate(-50%, -50%);
	transition: width 0.6s, height 0.6s;
}

.book-btn:hover::before {
	width: 300px;
	height: 300px;
}

.book-btn:hover {
	transform: translateY(-2px) scale(1.05);
	box-shadow: 0 4px 16px rgba(229, 9, 20, 0.35);
}

.book-btn:active {
	transform: translateY(0) scale(0.98);
}

.empty-state {
	text-align: center;
	padding: 60px 20px;
	color: var(--text-secondary);
}

.empty-state-icon {
	font-size: 4em;
	margin-bottom: 20px;
	opacity: 0.3;
}

@media ( max-width : 1200px) {
	.main-content {
		grid-template-columns: 1fr;
	}
	.section:last-child {
		max-height: 500px;
	}
}

/* Loading Animation */
.loading {
	display: inline-block;
	width: 20px;
	height: 20px;
	border: 3px solid rgba(255, 255, 255, 0.3);
	border-radius: 50%;
	border-top-color: var(--primary-red);
	animation: spin 0.8s linear infinite;
}

@
keyframes spin {to { transform:rotate(360deg);
	
}

}

/* Pulse Animation */
@
keyframes pulse { 0%, 100% {
	opacity: 1;
}

50
%
{
opacity
:
0.5;
}
}
.loading-text {
	animation: pulse 1.5s ease-in-out infinite;
}
</style>




<!-- bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript">




</script>
</head>
<body>
	<header id="header">
		<c:import url="${commonURL}/fragments/header.jsp" />
	</header>
	<div class="header2">
		<div class="container">
			<h1>빠른 예매</h1>
		</div>
	</div>
	<div class="container">
		<div class="date-selector">
			<div class="date-scroll" id="dateScroll">
				<!-- Dates will be populated here -->
			</div>
		</div>

		<div class="main-content">
			<!-- Movies Section -->
			<div class="section">
				<h2 class="section-title">영화</h2>
				<div class="tab-buttons">
					<button class="tab-btn active" data-tab="all">전체</button>
					<button class="tab-btn" data-tab="all-rating">
						<span class="rating-all"
							style="width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center; border-radius: 3px; font-size: 0.7em; margin-right: 4px;">ALL</span>
					</button>
					<button class="tab-btn" data-tab="12">
						<span class="rating-12"
							style="width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center; border-radius: 3px; font-size: 0.7em; margin-right: 4px;">12</span>
					</button>
					<button class="tab-btn" data-tab="15">
						<span class="rating-15"
							style="width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center; border-radius: 3px; font-size: 0.7em; margin-right: 4px;">15</span>
					</button>
					<button class="tab-btn" data-tab="19">
						<span class="rating-19"
							style="width: 20px; height: 20px; display: inline-flex; align-items: center; justify-content: center; border-radius: 3px; font-size: 0.7em; margin-right: 4px;">19</span>
					</button>
				</div>
				<div class="movie-list" id="movieList">
					<div class="empty-state">
						<div class="empty-state-icon">🎬</div>
						<p class="loading-text">영화를 불러오는 중...</p>
					</div>
				</div>
			</div>

			<!-- Showtimes Section -->
			<div class="section">
				<h2 class="section-title">시간</h2>
				<div class="time-selector" id="timeSelector">
					<button class="time-badge active" data-time="all">☀️ 조조</button>
					<button class="time-badge" data-time="morning">🌤️ 브런치</button>
					<button class="time-badge" data-time="afternoon">🌙 심야</button>
				</div>
				<div id="hourSelector"
					style="display: flex; gap: 8px; margin-bottom: 20px; flex-wrap: wrap;">
					<!-- Hour buttons will be generated here -->
				</div>
				<div class="showtime-list" id="showtimeList">
					<div class="empty-state">
						<div class="empty-state-icon">⏰</div>
						<p>영화를 선택해주세요</p>
					</div>
				</div>
			</div>
		</div>
	</div>



	<footer id="footer">
		<c:import url="${commonURL}/fragments/footer.jsp" />
	</footer>
</body>

</html>