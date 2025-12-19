<%@page import="seat.booking.SeatBookService"%>
<%@page import="movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
SeatBookService sbs = SeatBookService.getInstance();
String screen_code="scc001";
sbs.searchRestaurant(screen_code);
%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>빠른예매 (좌석선택)</title>
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css"
	media="all">
<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${commonURL}/resources/js/jquery-1.12.4.js"></script>
<script src="${commonURL}/resources/js/jquery-ui.1.12.1.js"></script>
<script src="${commonURL}/resources/js/gsaps.js"></script>
<script src="${commonURL}/resources/js/bootstrap-custom.js"></script>
<script src="${commonURL}/resources/js/bootstrap-select.js"></script>

<script src="${commonURL}/resources/js/commons.js"></script>
<script src="${commonURL}/resources/js/mega.prototype.js"></script>
<script src="${commonURL}/resources/js/megaboxCom.js"></script>
<script src="${commonURL}/resources/js/front.js"></script>
<style>
/* 기존 스타일 유지 */
* {
	box-sizing: border-box;
	margin: 0;
	padding: 0;
}

body {
	font-family: "맑은 고딕";
	background-color: white;
	color: #333;
	-webkit-font-smoothing: antialiased;
}

.booking-container {
	display: flex;
	max-width: 1280px;
	min-width: 1100px;
	margin: 20px auto;
	border: 1px solid #ddd;
	background-color: white;
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

.main-content h1 {
	font-size: 24px;
	padding-bottom: 20px;
	border-bottom: 2px solid #333;
}

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
	gap: 15px;
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
	display: flex;
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

#seat-map {
	display: flex;
	flex-direction: column;
	align-items: center;
	gap: 5px;
	margin-top: 10px;
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
	width: 30px;
}

.row-label {
	width: 25px;
	text-align: center;
	font-weight: bold;
	color: #777;
}

.seat {
	border: none;
	padding: 0;
	font: inherit;
	background: none;
	-webkit-appearance: none;
	appearance: none;
	width: 28px;
	height: 28px;
	font-size: 12px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.1s ease;
	font-weight: bold;
}

.seat.available {
	background-color: #707070;
	border: 2px solid #00dada;
	color: #fff;
}

.seat.available:hover {
	background-color: #888;
	border-color: #00ffff;
}

.seat.selected {
	background-color: #503396;
	border: 2px solid #503396;
	color: #fff;
}

.seat.reserved {
	background-color: #ddd;
	border: 2px solid #ccc;
	color: #aaa;
	cursor: not-allowed;
	position: relative;
}

.seat.reserved:before {
	content: 'X';
	position: absolute;
	font-size: 20px;
	font-weight: bold;
	color: #aaa;
}

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
	display: inline-block;
	position: relative;
}

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
	background-color: #00b8b2;
	color: #fff;
}

.hidden {
	display: none !important;
}
.selected-seat-box.filled {
	background-color: #503396 !important;
	color: #fff !important;
	font-weight: bold;
	border: 1px solid #7457c1;
}
</style>
<script type="text/javascript">
	$(function() {
		// 인원 저장을 위한 변수
		let adultCnt = 0;
		let youthCnt = 0;
		let seniorCnt = 0;

		// 플러스 버튼 클릭
		$(".btn-plus").click(function() {
			let type = $(this).data("type");
			let total = adultCnt + youthCnt + seniorCnt;

			if (total >= 6) {
				alert("최대 6명까지 선택 가능합니다.");
				return;
			}

			if (type === "adult")
				adultCnt++;
			else if (type === "youth")
				youthCnt++;
			else if (type === "senior")
				seniorCnt++;

			updateCount();
		});

		// 마이너스 버튼 클릭
		$(".btn-minus").click(function() {
			let type = $(this).data("type");

			if (type === "adult" && adultCnt > 0)
				adultCnt--;
			else if (type === "youth" && youthCnt > 0)
				youthCnt--;
			else if (type === "senior" && seniorCnt > 0)
				seniorCnt--;

			updateCount();
		});

		// 초기화 버튼
		$("#reset-button").click(function() {
			adultCnt = 0;
			youthCnt = 0;
			seniorCnt = 0;
			updateCount();
		});

		// 인원 UI 업데이트 함수
		function updateCount() {
		    $("#adult-count").text(adultCnt);
		    $("#youth-count").text(youthCnt);
		    $("#senior-count").text(seniorCnt);

		    let total = adultCnt + youthCnt + seniorCnt;
		    $("#price-summary-text").text("총 " + total + "명");

		    // 인원을 줄였을 때 초과된 좌석 선택 해제하기
		    let $selectedSeats = $(".seat.selected");
		    if ($selectedSeats.length > total) {
		        // 선택된 좌석들 중 인원수를 초과하는 만큼(뒤에서부터) 선택 해제
		        for (let i = $selectedSeats.length - 1; i >= total; i--) {
		            $($selectedSeats[i]).removeClass("selected").addClass("available");
		        }
		    }

		    // 금액 업데이트
		    let totalPrice = total * 12000; 
		    $("#total-price").html(totalPrice.toLocaleString() + "<span>원</span>");

		    // 인원 선택 여부에 따른 오버레이 제어
		    if (total > 0) {
		        $("#seat-map-overlay").hide();
		    } else {
		        // 인원을 0으로 만들면 모든 좌석 선택 해제
		        $(".seat.selected").removeClass("selected").addClass("available");
		        $("#seat-map-overlay").show();
		    }

		    // 우측 사이드바 정보 갱신
		    renderSelectedSeats();
		}

		// 다음 버튼 클릭 -> 모달 오픈
		$("#next-button").click(function() {
			$("#alert-modal-booking").removeClass("hidden");
		});

		// 모달 닫기 (취소 및 X 버튼)
		$(".close-modal").click(function() {
			$("#alert-modal-booking").addClass("hidden");
		});

		// 모달 확인 버튼 (페이지 이동)
		$("#btn-confirm-move").click(function() {
			location.href = "${commonURL}/user/payment/paymentFrm.jsp";
		});

		// 좌석 맵 생성 함수
		function createSeatMap() {
			const alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";//좌석번호
			const reservedSeats = [ 'A5', 'A6', 'D10', 'E4', 'E5', 'J8', 'J9',
					'J10' ];//예약 좌석
			const rows = 10;//행
			const cols = 10;//열
			const aisles = [ 2, 8 ];//통로

			for (let r = 0; r < rows; r++) {
				let rowLabel = alphabet[r];
				let $row = $('<div class="seat-row"></div>');
				$row.append('<div class="row-label">' + rowLabel + '</div>');

				for (let c = 1; c <= cols; c++) {
					let seatId = rowLabel + c;
					let isReserved = reservedSeats.includes(seatId);
					let $seat = $('<button type="button" class="seat '
							+ (isReserved ? 'reserved' : 'available') + '">'
							+ c + '</button>');
					//예약 좌석인지 확인
					if (isReserved){
						$seat.prop("disabled", true);
					}//end if
					//좌석 추가
					$row.append($seat);
					//복도 생성
					if (aisles.includes(c) && c < cols) {
						$row.append('<div class="aisle"></div>');
					}//end if
				}
				$("#seat-map").append($row);
			}
		}
		// 초기 실행
		createSeatMap();
		
		// 좌석 클릭 이벤트
		$(document).on("click", ".seat.available, .seat.selected", function() {
			let total = adultCnt + youthCnt + seniorCnt;
			if (total === 0) {
				alert("관람인원을 먼저 선택해주세요.");
				return;
			}

			if ($(this).hasClass("selected")) {
				$(this).removeClass("selected").addClass("available");
			} else {
				if ($(".seat.selected").length >= total) {
					alert("선택하신 인원수를 초과할 수 없습니다.");
					return;
				}
				$(this).removeClass("available").addClass("selected");
			}
			renderSelectedSeats(); // 선택 상태가 바뀔 때마다 우측 정보 갱신
		});

		// 선택된 좌석 정보를 우측 사이드바에 표시하는 함수
		function renderSelectedSeats() {
			// 모든 칸 초기화
			for (let i = 1; i <= 6; i++) {
				$("#selectSeat" + i).text("-").removeClass("filled");
			}

			// 선택된 좌석(.selected)을 찾아서 순서대로 채움
			$(".seat.selected").each(function(index) {
				let row = $(this).closest(".seat-row").find(".row-label").text();
				let col = $(this).text();
				let seatNum = row + col;

				if (index < 6) {
					$("#selectSeat" + (index + 1)).text(seatNum).addClass("filled");
				}
			});
		}
		
		
	});//ready
</script>
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

	<div class="booking-container">
		<div class="main-content">
			<h1>빠른예매</h1>

			<div class="person-selector-bar">
				<h2>관람인원선택</h2>
				<div class="person-controls">
					<div class="person-control">
						<label>성인</label>
						<button type="button" class="btn-minus" data-type="adult">-</button>
						<span id="adult-count" class="count-display">0</span>
						<button type="button" class="btn-plus" data-type="adult">+</button>
					</div>
					<div class="person-control">
						<label>청소년</label>
						<button type="button" class="btn-minus" data-type="youth">-</button>
						<span id="youth-count" class="count-display">0</span>
						<button type="button" class="btn-plus" data-type="youth">+</button>
					</div>
					<div class="person-control">
						<label>경로</label>
						<button type="button" class="btn-minus" data-type="senior">-</button>
						<span id="senior-count" class="count-display">0</span>
						<button type="button" class="btn-plus" data-type="senior">+</button>
					</div>
				</div>
				<button type="button" id="reset-button">초기화</button>
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
						<span class="color-box" style="background: #ddd;"></span> 예매완료
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
						<div class="selected-seat-box" id="selectSeat1">-</div>
						<div class="selected-seat-box" id="selectSeat2">-</div>
						<div class="selected-seat-box" id="selectSeat3">-</div>
						<div class="selected-seat-box" id="selectSeat4">-</div>
						<div class="selected-seat-box" id="selectSeat5">-</div>
						<div class="selected-seat-box" id="selectSeat6">-</div>
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
				<button type="button" id="prev-button">이전</button>
				<button type="button" id="next-button">다음</button>
			</div>
		</div>
	</div>

	<div id="alert-modal-booking"
		class="fixed inset-0 hidden flex items-center justify-center z-50"
		style="background-color: rgba(0, 0, 0, 0.5);">
		<div class="bg-white w-[400px] shadow-lg border border-purple-800">
			<div
				class="bg-[#503396] text-white px-4 py-2 flex justify-between items-center">
				<span class="font-bold">알림</span>
				<button type="button" class="close-modal text-white">✕</button>
			</div>
			<div class="p-8 text-center">
				<p class="text-gray-700 mb-6 text-sm">결제 페이지로 이동 하시겠습니까?</p>
				<div class="flex justify-center gap-2">
					<button type="button"
						class="close-modal px-6 py-2 border border-purple-800 text-purple-800 text-sm">취소</button>
					<button type="button" id="btn-confirm-move"
						class="px-6 py-2 bg-[#503396] text-white text-sm">확인</button>
				</div>
			</div>
		</div>
	</div>



	<footer id="footer"><jsp:include
			page="../../fragments/footer.jsp" /></footer>
</body>
</html>