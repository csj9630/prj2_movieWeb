<%@page import="java.text.DecimalFormat"%>
<%@page import="movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ include file="../../fragments/loginChk.jsp"%>
<%
/*ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ*/
request.setCharacterEncoding("UTF-8");

String movieCode=request.getParameter("movieCode");
String movieName=request.getParameter("movieName");
String screenCode=request.getParameter("screenCode");
String theaterName=request.getParameter("theaterName");
String screenOpen=request.getParameter("screenOpen");
String screenEnd=request.getParameter("screenEnd");
String screenDate=request.getParameter("screenDate");
String totalPrice=request.getParameter("totalPrice");
String theaterNum = request.getParameter("theaterNum");//추가해주세요ㅠㅠ..
String adultCnt = request.getParameter("adultCnt");
String youthCnt = request.getParameter("youthCnt");
String seniorCnt = request.getParameter("seniorCnt");

DecimalFormat df = new DecimalFormat("###,###");
int totalBooking = Integer.parseInt(adultCnt) + Integer.parseInt(youthCnt) + Integer.parseInt(seniorCnt);
int originPrice = totalBooking * 15000;
int totalDiscount = Math.abs(originPrice - Integer.parseInt(totalPrice));

String formattedTotalPrice = df.format(Integer.parseInt(totalPrice));
String formattedOriginPrice = df.format(originPrice);
String formattedTotalDiscount = df.format(totalDiscount);

MovieService ms=MovieService.getInstance();
String imgPath=ms.showMainImage(movieCode);
request.setAttribute("imgPath", imgPath);
%>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<link rel="shortcut icon" href="${commonURL}/resources/images/favicon.ico">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>결제 체크</title>

<!-- 기존 메가박스 CSS (경로 주의: 공백이나 한글이 포함된 경로는 웹에서 인식 못할 수 있음) -->
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" media="all">

<!-- Tailwind CSS (반드시 포함되어야 함) -->
<script src="https://cdn.tailwindcss.com"></script>
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
<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
/* 기본 폰트 설정: 맑은 고딕 */
.payment-container {
	font-family: '맑은 고딕';
}

/* 팝업창 숨김 강제 적용 */
.hidden {
	display: none !important;
}

/* 커스텀 체크박스 스타일 */
.custom-checkbox input:checked+div {
	background-color: #503396;
	border-color: #503396;
	color: white;
}

.custom-checkbox input+div {
	border: 2px solid #ccc;
	border-radius: 50%;
	width: 24px;
	height: 24px;
	display: flex;
	align-items: center;
	justify-content: center;
	color: transparent;
	cursor: pointer;
	transition: all 0.2s;
}

/* 우측 패널 스타일 */
.right-panel {
	background-color: #333333;
	color: white;
}

/* 버튼 스타일 */
.btn-pay {
	background-color: #11abb0;
	color: white;
}

.btn-cancel {
	background-color: #555;
	color: white;
}

/* 결제 수단 탭 스타일 */
.payment-tab {
	border: 1px solid #ddd;
	background-color: #f8f8f8;
	cursor: pointer;
	transition: all 0.2s;
}

.payment-tab.active {
	background-color: white;
	border-bottom: 2px solid #333;
	font-weight: bold;
	color: #333;
}

/* 모달 오버레이 */
.modal-overlay {
	background-color: rgba(0, 0, 0, 0.5);
}

/* Tailwind와 충돌 방지를 위한 스타일 리셋 보완 */
.payment-wrapper * {
	box-sizing: border-box;
}
</style>
<script type="text/javascript">
$(function() {
	$(function() {
	    $("#prev-button").click(function(e) {
	        e.preventDefault(); // 기본 동작 방지
	        $("#backFrm").submit(); // 파라미터와 함께 이전 페이지(좌석선택)로 이동
	    });
	});
});
</script>
</head>
<!-- body에서 flex 제거: 헤더와 푸터가 정상적으로 나오게 하기 위함 -->
<body>

<form id="backFrm" action="${commonURL}/user/booking/quickBookingSeat.jsp" method="post">
    <input type="hidden" name="movieCode" value="<%= movieCode %>">
    <input type="hidden" name="movieName" value="<%= movieName %>">
    <input type="hidden" name="screenCode" value="<%= screenCode %>">
    <input type="hidden" name="theaterName" value="<%= theaterName %>">
    <input type="hidden" name="screenOpen" value="<%= screenOpen %>">
    <input type="hidden" name="screenEnd" value="<%= screenEnd %>">
    <input type="hidden" name="screenDate" value="<%= screenDate %>">
    <input type="hidden" name="theaterNum" value="<%= theaterNum %>">
</form>


	<header id="header">
		<jsp:include page="../../fragments/header.jsp" />
	</header>

	<div class="page-util">
		<div class="inner-wrap">
			<div class="location">
				<span>Home</span> <a href="#" title="회원">예매</a> <a href="#">빠른
					예매</a>
			</div>
		</div>
	</div>

	<!-- 여기서부터 결제 화면 컨테이너 시작 -->
	<!-- min-h-screen 제거: 화면 전체 높이를 강제하지 않도록 수정 -->
	<div
		class="payment-wrapper w-full flex justify-center py-10 bg-[#f2f4f8]">

		<!-- 기존 결제 UI 코드 -->
		<div class="payment-container w-full max-w-5xl flex gap-6 px-4">

			<!-- 좌측 콘텐츠 영역 -->
			<div
				class="flex-1 bg-white p-6 shadow-sm border border-gray-200 text-left">
				<h1
					class="text-2xl font-bold mb-6 border-b-2 border-black pb-4 text-black">결제하기</h1>

				<!-- 예매 정보 -->
				<div class="mb-8">
					<h2 class="font-bold text-lg mb-4 text-black">예매정보</h2>
					<div class="flex gap-4 border border-gray-200 p-4 rounded-sm">
						<div
							class="w-24 h-36 bg-gray-800 text-white flex items-center justify-center text-xs text-center shrink-0 overflow-hidden">
							<!-- 이미지 -->
							<img src="${commonURL}/${movieImgPath}/<%= movieCode %>/${imgPath}"
						alt="<%= movieName %> 포스터">
						</div>
						<div class="flex flex-col gap-1 text-sm">
							<div class="font-bold text-lg mb-1 text-black"><%=movieName%></div>
							<div class="text-gray-600"><strong><%=screenDate%>&nbsp;/&nbsp;<%=screenOpen%>~<%=screenEnd%></strong></div>
							<div class="text-gray-600 "><%=theaterName%></div>
							<div class="text-gray-600 font-bold">성인 <%=adultCnt %>명</div>
							<div class="text-gray-600 font-bold">청소년 <%=youthCnt %>명</div>
							<div class="text-gray-600 font-bold">경로 <%=seniorCnt %>명</div>
						</div>
					</div>
				</div>

				<!-- 결제 수단 -->
				<div class="mb-8">
					<div class="flex justify-between items-end mb-2">
						<h2 class="font-bold text-lg text-black">결제수단</h2>
						<button onclick="resetPaymentTab()"
							class="text-xs text-gray-500 border border-gray-300 px-2 py-1 rounded hover:bg-gray-100 transition">초기화</button>
					</div>

					<div class="grid grid-cols-4 text-center text-sm mb-4">
						<div id="tab-credit" class="payment-tab active py-3 text-black"
							onclick="selectPaymentTab('credit', '신용카드')" style="width : 591.81px;">신용카드</div>
						<!-- <div id="tab-a" class="payment-tab py-3 text-black"
							onclick="selectPaymentTab('a', 'A수단')">어플결제</div> -->
					</div>

					<div class="border-t border-gray-200 pt-4 px-2">
						<p id="payment-desc" class="text-sm text-gray-600">신용카드 결제를
							선택하셨습니다.</p>
					</div>
				</div>

				<!-- 약관 동의 1 -->
				<div class="mb-6">
					<div
						class="flex items-center gap-2 mb-2 border-b border-gray-300 pb-2">
						<label
							class="custom-checkbox flex items-center gap-2 cursor-pointer">
							<input type="checkbox" id="chk-term-1" class="hidden">
							<div>
								<i class="fas fa-check text-xs"></i>
							</div> <span class="font-bold text-gray-800">결제대행 서비스 약관 필수 동의</span>
						</label>
					</div>

					<ul class="text-sm text-gray-600 space-y-2 pl-0 list-none">
						<li
							class="flex justify-between items-center border p-3 bg-gray-50">
							<span>전자금융거래 기본약관</span>
							<button onclick="openTermsModal('전자금융거래 기본약관')"
								class="underline text-gray-500 text-xs hover:text-black cursor-pointer">내용보기</button>
						</li>
						<li
							class="flex justify-between items-center border p-3 bg-gray-50">
							<span>개인정보 수집 및 이용에 대한 동의</span>
							<button onclick="openTermsModal('개인정보 수집 및 이용에 대한 동의')"
								class="underline text-gray-500 text-xs hover:text-black cursor-pointer">내용보기</button>
						</li>
						<li
							class="flex justify-between items-center border p-3 bg-gray-50">
							<span>개인정보의 제 3자 제공 동의</span>
							<button onclick="openTermsModal('개인정보의 제 3자 제공 동의')"
								class="underline text-gray-500 text-xs hover:text-black cursor-pointer">내용보기</button>
						</li>
						<li
							class="flex justify-between items-center border p-3 bg-gray-50">
							<span>개인정보의 처리 위탁 동의</span>
							<button onclick="openTermsModal('개인정보의 처리 위탁 동의')"
								class="underline text-gray-500 text-xs hover:text-black cursor-pointer">내용보기</button>
						</li>
					</ul>
				</div>

				<!-- 약관 동의 2 -->
				<div class="mb-8">
					<div
						class="flex items-center gap-2 mb-2 border-b border-gray-300 pb-2">
						<label
							class="custom-checkbox flex items-center gap-2 cursor-pointer">
							<input type="checkbox" id="chk-term-2" class="hidden">
							<div>
								<i class="fas fa-check text-xs"></i>
							</div> <span class="font-bold text-gray-800">취소/환불 정책에 대한 동의</span>
						</label>
					</div>
					<ul class="list-none text-xs text-gray-500 space-y-1 pl-2">
						<li>- 온라인 예매는 영화 상영시간 20분전까지 취소 가능하며, 20분 이후 현장 취소만 가능합니다.</li>
						<li>- 현장 취소 시 영화 상영시간 이전까지만 가능합니다.</li>
					</ul>
				</div>
			</div>

			<!-- 우측 고정 패널 -->
			<div class="w-80 shrink-0 flex flex-col h-fit text-left">
				<div class="right-panel p-6 rounded-t-md">
					<h2 class="text-lg font-bold mb-6">결제금액</h2>

					<div class="space-y-4 text-sm border-b border-gray-600 pb-6 mb-6">
						<div class="flex justify-between">
							<span>총 인원</span> <span><%=totalBooking%>명</span>
						</div>
						<div class="flex justify-between font-bold text-white">
							<span>총 금액</span> <span><%=formattedOriginPrice%>원</span>
						</div>
					</div>

					<div class="flex justify-center mb-6">
						<div
							class="w-6 h-6 rounded-full bg-cyan-500 flex items-center justify-center text-xs font-bold text-white">-</div>
					</div>

					<div
						class="flex justify-between  mb-6 pb-6 border-b border-gray-600">
						<span>할인 금액</span> <span><%=formattedTotalDiscount%>원</span>
					</div>

					<div
						class="flex justify-between items-end text-xl font-bold text-cyan-400 mb-6">
						<span class="text-sm text-white font-normal">최종결제금액</span> <span><%=formattedTotalPrice %>원</span>
					</div>

					<div class="flex justify-between text-xs text-gray-400">
						<span>결제수단</span> <span id="selected-payment-method">신용카드</span>
					</div>
				</div>

				<!-- 버튼 영역 -->
				<div class="flex h-14">
					<button class="flex-1 btn-cancel font-bold" id="prev-button">이전</button>
					<button onclick="handlePayment()" class="flex-1 btn-pay font-bold">결제</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 결제 화면 컨테이너 끝 -->

	<!-- 모달 및 팝업 (body 태그 닫기 직전에 위치) -->
	<!-- 1. 약관 내용 보기 모달 -->
	<div id="terms-modal"
		class="fixed inset-0 modal-overlay hidden flex items-center justify-center z-50">
		<div
			class="bg-white w-[600px] h-[500px] flex flex-col shadow-2xl rounded-sm overflow-hidden border border-gray-500 text-left">
			<div
				class="bg-slate-800 text-white px-4 py-2 flex justify-between items-center">
				<span id="modal-title" class="text-sm font-bold">약관 상세</span>
				<button onclick="closeTermsModal()"
					class="text-white hover:text-gray-300">
					<i class="fas fa-times"></i>
				</button>
			</div>
			<div class="bg-slate-700 px-4 py-1 flex items-center gap-2">
				<div
					class="bg-slate-900 text-gray-400 text-xs px-2 py-1 rounded w-full truncate">
					https://megabox.kicc.co.kr/html/terms/terms2.html</div>
			</div>
			<div class="p-8 overflow-y-auto flex-1 bg-white text-gray-800">
				<h3 class="text-xl font-bold text-blue-900 mb-4"
					id="modal-content-title">[임시 제목]</h3>
				<p class="text-sm leading-6 text-gray-600">내용이 표시됩니다...</p>
				<!-- 테이블 등 생략된 내용... -->
			</div>
		</div>
	</div>

	<!-- 2. 경고 팝업 -->
	<div id="alert-modal"
		class="fixed inset-0 modal-overlay hidden flex items-center justify-center z-50">
		<div class="bg-white w-[400px] shadow-lg border border-purple-800">
			<div
				class="bg-[#503396] text-white px-4 py-2 flex justify-between items-center">
				<span class="font-bold">알림</span>
				<button onclick="closeAlertModal()" class="text-white">
					<i class="fas fa-times"></i>
				</button>
			</div>
			<div class="p-8 text-center">
				<p class="text-gray-700 mb-6 text-sm">
					결제대행 서비스 약관에 동의하시겠습니까?<br>(또는 취소/환불 정책)
				</p>
				<div class="flex justify-center gap-2">
					<button onclick="closeAlertModal()"
						class="px-6 py-2 border border-purple-800 text-purple-800 text-sm hover:bg-purple-50">취소</button>
					<button onclick="confirmAutoCheck()"
						class="px-6 py-2 bg-[#503396] text-white text-sm hover:bg-purple-800">확인</button>
				</div>
			</div>
		</div>
	</div>

	<script>
        // DOM 요소 가져오기
        const termsModal = document.getElementById('terms-modal');
        const alertModal = document.getElementById('alert-modal');
        const modalTitle = document.getElementById('modal-title');
        const modalContentTitle = document.getElementById('modal-content-title');
        
        const chkTerm1 = document.getElementById('chk-term-1');
        const chkTerm2 = document.getElementById('chk-term-2');

        const paymentDesc = document.getElementById('payment-desc');
        const selectedPaymentMethod = document.getElementById('selected-payment-method');

        function selectPaymentTab(type, name) {
            document.querySelectorAll('.payment-tab').forEach(tab => tab.classList.remove('active'));
            document.getElementById('tab-' + type).classList.add('active');
            paymentDesc.innerText = name + ' 결제를 선택하셨습니다.';
            selectedPaymentMethod.innerText = name;
        }

        function resetPaymentTab() {
            selectPaymentTab('credit', '신용카드');
        }

        function openTermsModal(title) {
            modalTitle.innerText = title;
            modalContentTitle.innerText = "[" + title + "]";
            termsModal.classList.remove('hidden');
        }

        function closeTermsModal() {
            termsModal.classList.add('hidden');
        }

        function handlePayment() {
            if (!chkTerm1.checked || !chkTerm2.checked) {
                alertModal.classList.remove('hidden');
            } else {
                // 결제 성공 시 페이지 이동 (카드 결제 페이지)
                location.href = '${commonURL}/user/payment/payment.jsp'; 
                // 또는 서버 로직에 따라 form submit 등을 수행
            }
        }

        function closeAlertModal() {
            alertModal.classList.add('hidden');
        }

        function confirmAutoCheck() {
            if (!chkTerm1.checked) {
                chkTerm1.checked = true;
            } else if (!chkTerm2.checked) {
                chkTerm2.checked = true;
            }
            closeAlertModal();
        }
    </script>

	<footer id="footer">
		<jsp:include page="../../fragments/footer.jsp" />
	</footer>
</body>
</html>