<%@page import="movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../../fragments/siteProperty.jsp"%>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>빠른예매 (좌석선택)</title>
<link rel="shortcut icon" href="${commonURL}/resources/images/favicon.ico">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" media="all">
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* 1. 기본 & 레이아웃 */
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

 body {
	font-family: "맑은 고딕";
	background-color: white; /* 기본 배경(회색) */
	color: #333;
	-webkit-font-smoothing: antialiased;
}

.booking-container {
	display: flex;
	max-width: 1280px;
	min-width: 1100px;
	margin: 20px auto;
	border: 1px solid #ddd;
	background-color: white; /* 메인 컨테이너 배경: 밝은 회색 */
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}

.main-content {
	flex-grow: 1;
	padding: 25px;
	border-right: 1px solid #eee;
}

.sidebar {
	width: 300px;
	flex-shrink: 0;
	background-color: #3b3b3b;
	color: #fff;
	display: flex;
	flex-direction: column;
}

/* 2. 메인 컨텐츠 (왼쪽) */
.main-content h1 {
	font-size: 24px;
	padding-bottom: 20px;
	border-bottom: 2px solid #333;
}

/* 2.1. 인원 선택 바 (우대 추가) */
.person-selector-bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 20px 0;
	border-bottom: 1px solid #eee;
	margin-bottom: 20px;
}

.person-selector-bar h2 {
	font-size: 18px;
}

.person-controls {
	display: flex;
	gap: 15px; /* 컨트롤 간 간격 */
}

.person-control {
	display: flex;
	align-items: center;
	gap: 5px;
}

.person-control label {
	font-size: 15px;
	margin-right: 5px;
}

.person-control button {
	width: 28px;
	height: 28px;
	border: 1px solid #ccc;
	background-color: #fff;
	font-size: 20px;
	color: #555;
	cursor: pointer;
}

.person-control .count-display {
	width: 30px;
	height: 28px;
	border: 1px solid #ccc;
	border-left: none;
	border-right: none;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 16px;
	font-weight: bold;
}

#reset-button {
	border: 1px solid #ccc;
	background-color: #fff;
	padding: 5px 10px;
	font-size: 14px;
	cursor: pointer;
}

#reset-button:before {
	content: '↻';
	font-size: 16px;
	margin-right: 5px;
	font-weight: bold;
}

/* 2.2. 좌석 맵 */
.seat-map-container {
	position: relative;
	min-height: 500px;
	padding: 20px;
	border: 1px solid #ddd;
	background-color: #fdfdfd;
}

#seat-map-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(90, 90, 90, 0.85);
	color: #fff;
	display: flex; /* [중요] CSS로 기본 표시 */
	flex-direction: column;
	justify-content: center;
	align-items: center;
	font-size: 18px;
	font-weight: bold;
	z-index: 10;
	transition: opacity 0.3s ease;
}

.overlay-arrow {
	width: 36px;
	height: 36px;
	background-color: #4a90e2;
	border-radius: 4px;
	margin-bottom: 20px;
	position: relative;
}

.overlay-arrow::before {
	content: '';
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -70%);
	width: 0;
	height: 0;
	border-left: 8px solid transparent;
	border-right: 8px solid transparent;
	border-bottom: 12px solid white;
}

/* 2.3. 실제 좌석 맵 */
#seat-map {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 5px;
	margin-top: 10px;
}

#seat-map h3 { /* SCREEN 텍스트 */
	font-size: 16px;
	color: #888;
	letter-spacing: 5px;
	padding: 5px 20px;
	border: 1px solid #ccc;
	z-index: 2;
	position: relative;
	background: #fdfdfd;
}

.screen-arc-image {
	width: 644px;
	height: 30px;
	margin: 0 auto 5px auto;
	text-align: center;
	line-height: 30px;
	font-size: 12px;
	color: #aaa;
	margin-bottom: 20px;
}

.exit-icon-top, .exit-icon-bottom {
	position: absolute;
	right: 20px;
	z-index: 2;
	width: 30px;
	height: 30px;
	border: 1px dashed #ccc;
	font-size: 10px;
	color: #aaa;
	text-align: center;
}

.exit-icon-top {
	top: 60px;
}

.exit-icon-bottom {
	bottom: 20px;
}

.seat-row {
	display: flex;
	align-items: center;
	gap: 5px;
}

.seat-row .aisle {
	width: 30px; /* 통로 너비 */
}

.row-label {
	width: 25px;
	text-align: center;
	font-weight: bold;
	color: #777;
}

/* ========================================
        좌석 디자인
        ========================================
        */
.seat {
	/* [추가] 버튼 기본 스타일 초기화 */
	border: none;
	padding: 0;
	font: inherit; /* 부모 폰트 상속 */
	background: none; /* 배경 제거 */
	-webkit-appearance: none; /* iOS Safari 스타일 제거 */
	-moz-appearance: none; /* Firefox 스타일 제거 */
	appearance: none; /* 표준 스타일 제거 */
	width: 28px;
	height: 28px;
	font-size: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 6px; /* [요청] 더 둥근 모서리 */
	cursor: pointer;
	transition: all 0.1s ease;
	font-weight: bold;
}

.seat.available {
	background-color: #707070; /* [요청] 살짝 더 진한 회색 */
	border: 2px solid #00dada; /* [요청] 얇고, 더 연한 틸 테두리 */
	color: #fff;
}

.seat.available:hover {
	background-color: #888; /* 호버 시 밝은 회색 */
	border-color: #00ffff; /* 밝은 틸 */
}

.seat.selected {
	background-color: #503396; /* 보라색 (선택됨) */
	border: 2px solid #503396; /* 2px border */
	color: #fff;
	border-radius: 6px; /* 6px radius */
}

.seat.reserved {
	background-color: #ddd; /* 예매완료 (밝은 회색) */
	border: 2px solid #ccc; /* 2px border */
	color: #aaa;
	cursor: not-allowed;
	position: relative;
	border-radius: 6px; /* 6px radius */
}

.seat.reserved:before {
	content: 'X';
	position: absolute;
	font-size: 20px;
	font-weight: bold;
	color: #aaa;
}

/* 3. 사이드바 (오른쪽) */
.sidebar-content {
	padding: 20px;
	flex-grow: 1;
}

.movie-info {
	display: flex;
	gap: 15px;
	border-bottom: 1px solid #555;
	padding-bottom: 20px;
}

.movie-info img {
	width: 80px;
	height: 116px;
	object-fit: cover;
	border-radius: 4px;
}

.movie-info h4 {
	font-size: 18px;
	margin-bottom: 5px;
}

.movie-info p {
	font-size: 14px;
	color: #ccc;
	margin-bottom: 5px;
}

.movie-info .time-select {
	background: #222;
	border: 1px solid #666;
	color: #fff;
	padding: 5px;
	width: 100%;
}

.rating-all {
	color: #00b8b2;
	border: 1px solid #00b8b2;
	padding: 0 4px;
	border-radius: 4px;
	font-size: 14px;
	margin-right: 5px;
}

.legend {
	padding: 20px 0;
	border-bottom: 1px solid #555;
	font-size: 13px;
	color: #ccc;
}

.legend-item {
	display: flex;
	align-items: center;
	margin-bottom: 8px;
}

.legend-item .color-box {
	width: 14px;
	height: 14px;
	margin-right: 8px;
	border: 1px solid #777;
    /* [수정] 가상 요소 배치를 위한 설정 */
    display: inline-block; 
    position: relative; 
}

/* [추가] 예매완료 (reserved) 범례에 X 표시 추가 */
.legend-item.reserved .color-box::after {
    content: 'X';
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 10px; 
    font-weight: bold;
    color: #aaa; 
}


.selected-seats-info h3 {
	font-size: 16px;
	margin-top: 20px;
	margin-bottom: 10px;
}

.selected-seats-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 8px;
}

.selected-seat-box {
	background-color: #555;
	color: #888;
	padding: 10px;
	text-align: center;
	border-radius: 4px;
	font-size: 14px;
	min-height: 40px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.selected-seat-box.active-placeholder {
	background-color: #503396;
	color: #fff;
	opacity: 0.7;
}

.selected-seat-box.filled {
	background-color: #503396;
	color: #fff;
	font-weight: bold;
	opacity: 1;
}

.price-summary {
	margin-top: 30px;
}

#price-summary-text {
	font-size: 14px;
	color: #ccc;
	text-align: left;
	margin-bottom: 5px;
}

#total-price {
	font-size: 28px;
	font-weight: bold;
	text-align: right;
	margin-top: -18px;
}

#total-price span {
	font-size: 18px;
	font-weight: normal;
	margin-left: 5px;
}

.sidebar-buttons {
	display: flex;
	margin-top: auto;
	border-top: 1px solid #555;
}

.sidebar-buttons button {
	flex: 1;
	padding: 18px;
	font-size: 18px;
	font-weight: bold;
	border: none;
	cursor: pointer;
}

#prev-button {
	background-color: #666;
	color: #fff;
}

#next-button {
	/* 초기 활성화 상태로 설정 */
	background-color: #00b8b2;
	color: #fff;
	cursor: pointer;
}

/* 모달 관련 스타일 */
.hidden {
	display: none !important;
}
</style>
</head>
<body>
    <header id="header"><jsp:include page="../../fragments/header.jsp" /></header>

    <div class="page-util">
        <div class="inner-wrap">
            <div class="location">
                <span>Home</span>
                <a href="#" title="회원">예매</a>
                <a href="#">빠른 예매</a>
            </div>
        </div>
    </div>

	<%
	request.setCharacterEncoding("UTF-8");
	
	String movieCode=request.getParameter("movieCode");
	String movieName=request.getParameter("movieName");
	String screenCode=request.getParameter("screenCode");
	String theaterName=request.getParameter("theaterName");
	String screenOpen=request.getParameter("screenOpen");
	String screenEnd=request.getParameter("screenEnd");
	String screenDate=request.getParameter("screenDate");
	
	MovieService ms=MovieService.getInstance();
	String imgPath=ms.showMainImage(movieCode);
	
	request.setAttribute("imgPath", imgPath);
	System.out.println(movieCode);
	%>

	<div class="booking-container">

		<div class="main-content">
			<h1>빠른예매</h1>

			<div class="person-selector-bar">
				<h2>관람인원선택</h2>

				<div class="person-controls">
					<div class="person-control">
						<label for="adult-count">성인</label>
						<button class="btn-minus" data-type="adult">-</button>
						<span id="adult-count" class="count-display">0</span>
						<button class="btn-plus" data-type="adult">+</button>
					</div>
					<div class="person-control">
						<label for="youth-count">청소년</label>
						<button class="btn-minus" data-type="youth">-</button>
						<span id="youth-count" class="count-display">0</span>
						<button class="btn-plus" data-type="youth">+</button>
					</div>
					<div class="person-control">
						<label for="senior-count">경로</label>
						<button class="btn-minus" data-type="senior">-</button>
						<span id="senior-count" class="count-display">0</span>
						<button class="btn-plus" data-type="senior">+</button>
					</div>
					<div class="person-control">
						<label for="disabled-count">우대</label>
						<button class="btn-minus" data-type="disabled">-</button>
						<span id="disabled-count" class="count-display">0</span>
						<button class="btn-plus" data-type="disabled">+</button>
					</div>
				</div>

				<button id="reset-button">초기화</button>
			</div>

			<div class="seat-map-container">
				<div id="seat-map-overlay">
					<div class="overlay-arrow"></div>
					<span>관람인원을 선택하십시오</span>
				</div>

				<div class="screen-arc-image">
					<img src="${commonURL}/resources/images/img-theater-screen.png" />
				</div>

				<div class="exit-icon-top">Top Exit</div>
				<div class="exit-icon-bottom">Btm Exit</div>

				<div id="seat-map"></div>
			</div>

		</div>

		<div class="sidebar">
			<div class="sidebar-content">
				<div class="movie-info">
					<img src="${commonURL}/${movieImgPath}/<%= movieCode %>/${imgPath}" alt="<%= movieName %> 포스터">
					<div>
						<h4>
							 <span style="color:#fff;"><%= movieName %></span>
						</h4>
						<p><%= theaterName %></p>
						<p><%= screenDate %></p>
						<span style="color: #FFF"><%= screenOpen %>~<%= screenEnd %></span>
					</div>
				</div>

				<div class="legend">
					<div class="legend-item">
						<span class="color-box" style="background: #503396;"></span> 선택
					</div>
					<div class="legend-item reserved"> 
						<span class="color-box"
							style="background: #ddd; border-color: #ccc;"></span> 예매완료
					</div>
					<div class="legend-item">
						<span class="color-box"
							style="background: #707070; border: 2px solid #00dada;"></span>
						선택가능
					</div>
				</div>

				<div class="selected-seats-info">
					<h3>선택좌석</h3>
					<div class="selected-seats-grid" id="selected-seats-grid">
						<div class="selected-seat-box">-</div>
						<div class="selected-seat-box">-</div>
						<div class="selected-seat-box">-</div>
						<div class="selected-seat-box">-</div>
						<div class="selected-seat-box">-</div>
						<div class="selected-seat-box">-</div>
					</div>
				</div>

				<div class="price-summary">
					<p id="price-summary-text">총 0명</p>
					<div id="total-price">
						0<span>원</span>
					</div>
				</div>
			</div>

			<div class="sidebar-buttons">
				<button id="prev-button">이전</button>
				<button id="next-button">다음</button>
			</div>
		</div>
	</div>
	
	<!-- 임시 사용 중. 다음 버튼 누를 시 팝업 창 생성. -->
	<div id="alert-modal-booking"
		class="fixed inset-0 modal-overlay hidden flex items-center justify-center z-50"
		style="background-color: rgba(0, 0, 0, 0.5); font-family: 'Malgun Gothic', sans-serif;">
		<div
			class="bg-white w-[400px] shadow-lg border border-purple-800 text-left">
			<div
				class="bg-[#503396] text-white px-4 py-2 flex justify-between items-center">
				<span class="font-bold">알림</span>
				<button onclick="closeAlertModalBooking()" class="text-white">
					<i class="fas fa-times"></i>
				</button>
			</div>
			<div class="p-8 text-center">
				<p class="text-gray-700 mb-6 text-sm">
					임시 사용 중, 결제 페이지로 이동 하시겠습니까?
				</p>
				<div class="flex justify-center gap-2">
					<button onclick="closeAlertModalBooking()"
						class="px-6 py-2 border border-purple-800 text-purple-800 text-sm hover:bg-purple-50">취소</button>
					<button onclick="confirmMovePage()"
						class="px-6 py-2 bg-[#503396] text-white text-sm hover:bg-purple-800">확인</button>
				</div>
			</div>
		</div>
	</div>

	<script>
        $(function() { // jQuery ready 핸들러
            
            // --- 1. DOM 요소 캐싱 (jQuery 객체로) ---
            const dom = {
                personControls: $('.person-controls'),
                seatMapContainer: $('#seat-map'),
                seatMapOverlay: $('#seat-map-overlay'),
                nextButton: $('#next-button'), // 다음 버튼 추가
                alertModal: $('#alert-modal-booking') // 모달 캐싱
            };
            
            const NEXT_PAGE_URL = 'http://localhost/second_project_movie_reservation/index/paymentFrm.jsp';
            
            /*
            ========================================
             이벤트 리스너 (jQuery 방식) - 단순화
            ========================================
            */
            
            // 인원 선택(+,- 버튼) 영역을 클릭하면 오버레이를 숨깁니다.
            dom.personControls.on('click', function() {
                dom.seatMapOverlay.hide(); // jQuery hide() 메소드 사용
            });
            
            // '다음' 버튼 클릭 시 무조건 모달 팝업
            dom.nextButton.on('click', function(e) {
                e.preventDefault(); // 버튼의 기본 동작 방지 (페이지 이동 막기)
                
                // 조건 검사 없이 바로 모달 팝업
                dom.alertModal.removeClass('hidden'); 
            });


            /*
            ========================================
             [추가] 모달 제어 함수 (전역 함수로 정의)
            ========================================
            */
            // 모달의 '취소'나 'X' 버튼을 눌렀을 때 닫기
            window.closeAlertModalBooking = function() {
                dom.alertModal.addClass('hidden');
            };

            // 모달의 '확인' 버튼을 눌렀을 때 페이지 이동
            window.confirmMovePage = function() {
                location.href = NEXT_PAGE_URL;
            };
            

            /*
            ========================================
             좌석 맵 생성 함수 (기존 로직 유지)
            ========================================
            */
            function createSeatMap(numRows = 10, numCols = 10, aislePositions = [2, 8]) {
            	 
                const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                const reservedSeats = ['A5', 'A6', 'D10', 'E4', 'E5', 'J8', 'J9', 'J10'];

                for (let r = 0; r < numRows; r++) {
                    const rowLabel = alphabet[r];
                    if (!rowLabel) continue; 

                    const rowEl = document.createElement('div');
                    rowEl.className = 'seat-row';
                    
                    const labelEl = document.createElement('div');
                    labelEl.className = 'row-label';
                    labelEl.textContent = rowLabel;
                    rowEl.appendChild(labelEl);
                    
                    for (let c = 1; c <= numCols; c++) {
                        
                        const seatEl = document.createElement('button'); 
						seatEl.setAttribute("type", "button"); 
						
						const seatId = rowLabel + c; 
						
						seatEl.dataset.seatId = seatId;
						seatEl.textContent = c;
						
                        if (reservedSeats.includes(seatId)) {
                            seatEl.className = 'seat reserved';
                            seatEl.disabled = true; 
                        } else {
                            seatEl.className = 'seat available';
                        }
                        
                        rowEl.appendChild(seatEl);

                        if (aislePositions.includes(c) && c < numCols) { 
                             rowEl.appendChild(document.createElement('div')).className = 'aisle';
                        }
                    }
                    dom.seatMapContainer.append(rowEl); 
                }
            }
            
            // --- 3. 초기화 실행 ---
            
            // 좌석 맵 생성
            const defaultRows = 10;
            const defaultCols = 10;
            const defaultAisles = [2, 8];
            createSeatMap(defaultRows, defaultCols, defaultAisles);
            
            // 페이지 로드 시 '다음' 버튼을 활성화된 상태로 설정
            dom.nextButton.prop('disabled', false); 
        });
    </script>



    <footer id="footer"><jsp:include page="../../fragments/footer.jsp" /></footer>

</body>
</html>