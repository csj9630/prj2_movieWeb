<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="screenInfo.ScreenInfoService"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- page directive -->
<%@taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../fragments/siteProperty.jsp"%>
<!DOCTYPE html>
<!-- saved from url=(0050)https://www.megabox.co.kr/theater/time?brchNo=1372 -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<link rel="shortcut icon" href="${commonURL}/resources/images/favicon.ico"/>

<title>(강남)상영시간표 &gt; 투지브이</title>

<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css" media="all" />

<!-- jQuery CDN 시작 -->
<script src="${commonURL}/resources/js/jquery-1.12.4.js"></script>
<script src="${commonURL}/resources/js/jquery-ui.1.12.1.js"></script>
<script src="${commonURL}/resources/js/gsaps.js"></script>
<script src="${commonURL}/resources/js/bootstrap-custom.js"></script>
<script src="${commonURL}/resources/js/bootstrap-select.js"></script>

<script src="${commonURL}/resources/js/commons.js"></script>
<script src="${commonURL}/resources/js/mega.prototype.js"></script>
<script src="${commonURL}/resources/js/megaboxCom.js"></script>
<script src="${commonURL}/resources/js/front.js"></script>

<script type="text/javascript">

</script>
<style type="text/css">
.date-list{
    overflow: visible !important; 
}
</style>

<!-- Google Tag Manager -->
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0], j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src= 'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f); })(window,document,'script','dataLayer','GTM-WG5DNB7D');</script>

</head>

<body>

	<!-- End Google Tag Manager body 영역에 추가-->
	<!-- Google Tag Manager (noscript) -->
	<noscript>
		<iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WG5DNB7D"
			height="0" width="0" style="display: none; visibility: hidden"></iframe>
	</noscript>
	<!-- End Google Tag Manager (noscript) -->

	<div class="skip" title="스킵 네비게이션">
		<a href="https://www.megabox.co.kr/theater/time?brchNo=1372#contents"
			title="본문 바로가기">본문 바로가기</a> <a
			href="https://www.megabox.co.kr/theater/time?brchNo=1372#footer"
			title="푸터 바로가기">푸터 바로가기</a>
	</div>

	<div class="body-wrap">

<script src="${commonURL}/resources/js/hmac-sha256.js"></script>
<script src="${commonURL}/resources/js/enc-base64-min.js"></script>
<script src="${commonURL}/resources/js/megabox-simpleBokd.js"></script>
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function() { // HTML이 다 로딩된 후 실행
    
    // 1. 선택자 변경: .date-area 안에 있는 버튼만 가져옵니다.
    const dateButtons = document.querySelectorAll('.date-area button');

    dateButtons.forEach(button => {
        button.addEventListener('click', function() {
            
            // (선택사항) 이미 disabled 상태면 클릭 무시
            if (this.classList.contains('disabled')) return;

            // 2. 기존에 켜져있는(on) 버튼을 찾을 때도 범위를 .date-area 안으로 한정하는 것이 좋습니다.
            const currentOn = document.querySelector('.date-area button.on');
            
            if (currentOn) {
                currentOn.classList.remove('on');
            }

            // 3. 클릭한 버튼 활성화
            this.classList.add('on');
            
            // (추가 팁) 클릭한 날짜 값 확인하기
            const selectedDate = this.getAttribute('date-data');
            console.log("선택한 날짜:", selectedDate);
        });
    });
});
</script>
		
		<!-- header -->
		<header id="header">
			<jsp:include page="../../fragments/header.jsp"/>
		</header>
		<!--// header -->

		<div id="schdlContainer" class="container">
			<div class="page-util">
				<div class="inner-wrap">
					<div class="location">
						<span>Home</span>
							<a href="${commonURL}/user/dailyScreenSchedule/dailyScreenSchedule.jsp"
							title="상영시간표 페이지로 이동">상영시간표</a>
					</div>
				</div>
			</div>
			
			<!-- contents -->
			<div id="contents" class="no-padding">
			
				<!-- theater-detail-page -->
				<div class="theater-detail-page" style = "height: 130px;">

					<div class="bg-img"
						style="background-image: url(${commonURL}/resources/images/img-theater-detail.jpg);"></div>
					<div class="bg-pattern"></div>
					<div class="bg-mask"></div>

					<!-- theater-all -->
					<div class="theater-all">
						<p class="name" style = "height: 90px">강남</p>
					</div>
					<!--// theater-detail-cont -->
				</div>
				<!--// theater-detail-page -->

				<div class="inner-wrap pt40">

					<div class="tab-cont-wrap">
						
						<div id="tab" class="tab-cont on">
							<%-- Calendar cal = Calendar.getInstance(); --%>
							<a href="${commonURL}/screenSchedule/screenSchedule.jsp"
								class="ir">상영시간표 탭 화면 입니다.</a>
							<h2 class="tit small" style="display: none;">무대인사</h2>
							<div class="movie-greeting" style="display: none;"></div>
							<h2 class="tit small mt40">상영시간표</h2>
							<div class="time-schedule mb30">
								<div class="wrap">
									<button type="button" title="이전 날짜 보기" class="btn-pre"
										disabled="true" style = "width: 20px; height: 72px;">
										<i class="iconset ico-cld-pre" style = "margin-top: 15px; margin-right: 0px;"></i> <em>이전</em>
									</button>
									<div class="date-list" style = "width: 1060px;">
										<div class="date-area">
											<div class="wrap" style="position: relative; width: 2100px; border: none; left: -70px;">
												<%
												    // 1. 날짜 설정 초기화
												    Calendar cal = Calendar.getInstance(); // 반복문용 (계속 변함)
												    Calendar todayCal = Calendar.getInstance(); // 오늘 날짜 비교용 (고정)
													
												    // 2. 파라미터로 넘어온 선택된 날짜 확인 (없으면 오늘 날짜가 기본값)
												    String selectedDate = request.getParameter("date");
												    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");
												    
												    if (selectedDate == null || selectedDate.equals("")) {
												        selectedDate = sdf.format(todayCal.getTime());
												    }
													
												    // 요일 한글 배열
												    String[] dayNames = {"", "일", "월", "화", "수", "목", "금", "토"};
												    String[] dayNamesEn = {"", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};
													
													// -----------------------------------------------------------
												    // [설정] 버튼 하나의 너비 + 여백 (CSS와 맞춰야 합니다!)
												    // 예: 버튼 width 60px + margin-right 0px = 60
												    // 메가박스 등은 보통 70px~80px 정도 잡힙니다. 개발자도구로 확인 필요.
												    int btnWidth = 70;
												    int initLeft = 75;
												    // -----------------------------------------------------------
													
												    // HTML을 담을 버퍼 생성 (화면 출력용)
												    StringBuilder yearHtml = new StringBuilder(); // 상단 연/월 라벨용 (<div class="year-area"> 내부)
												    StringBuilder btnHtml = new StringBuilder();  // 하단 날짜 버튼용 (<div class="date-list"> 내부)
												    
												    // 3. 14일치 날짜 생성 반복문
												    for (int i = 0; i < 15; i++) {
												        int year = cal.get(Calendar.YEAR);
												        int month = cal.get(Calendar.MONTH) + 1; // 0~11
												        int day = cal.get(Calendar.DATE);
												        int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 1(일) ~ 7(토)
												        
												        // 날짜 포맷팅 (yyyy.MM.dd)
												        String dateData = String.format("%04d.%02d.%02d", year, month, day);
												        
												        // -----------------------------------------------------
												        // [로직 1] 연/월 라벨 생성 (요청하신 양식 유지)
												        // -----------------------------------------------------
												        // 첫 번째 루프이거나(오늘), 날짜가 1일인 경우 라벨 생성
												        if (i == 0 || day == 1) {
												            // 위치 계산: (현재 순번 index * 버튼 너비) px
												            int leftPos = (i * btnWidth) + initLeft; 
												            
												            // 요청하신 HTML 구조 그대로 문자열 생성
												            // 30px 등 고정값이 아니라 계산된 leftPos 변수를 넣습니다.
												            yearHtml.append(String.format(
												                "<div class='year' style='left: %dpx; z-index: 1; opacity: 1;'>%04d.%02d</div>", 
												                leftPos, year, month
												            ));
												        }
												        
												        // CSS 클래스 계산 (토요일, 일요일, 그리고 선택된 날짜 'on')
												        String btnClass = "";
												        if (dayOfWeek == Calendar.SATURDAY) btnClass = "sat";
												        else if (dayOfWeek == Calendar.SUNDAY) btnClass = "holi";
												        
												        // 현재 출력중인 날짜가 선택된 날짜와 같으면 'on' 클래스 추가
												        if (dateData.equals(selectedDate)) {
												            btnClass += " on";
												        }
														
												        // 표기할 요일 텍스트 결정 (오늘, 내일, 그 외 요일)
												        String dayText = dayNames[dayOfWeek];
												        
												        // 오늘/내일 로직: 반복중인 cal 날짜와 고정된 todayCal 비교
												        long diffSec = (cal.getTimeInMillis() - todayCal.getTimeInMillis()) / 1000;
												        long diffDays = diffSec / (24*60*60); // 일수 차이 계산
												        
												        if (diffDays == 0) dayText = "오늘";
												        else if (diffDays == 1) dayText = "내일";
												        
												    	// 버튼 HTML 누적
												        btnHtml.append("<button class='" + btnClass + "' type='button' ");
												        btnHtml.append("date-data='" + dateData + "' month='" + (month-1) + "' ");
												        btnHtml.append("onclick=\"changeDate('" + dateData + "')\">");
												        btnHtml.append("<span class='ir'>" + year + "년 " + month + "월</span>");
												        btnHtml.append("<em style='pointer-events: none;'>" + day + "<span class='ir'>일</span></em>");
												        btnHtml.append("<span class='day-kr' style='pointer-events: none; display: inline-block'>" + dayText + "</span>");
												        btnHtml.append("</button>");
												        
												        // 4. 핵심: 하루 증가 (이전 답변의 해결책 적용)
												        cal.add(Calendar.DATE, 1);
												    } // end for
												    %>
												    <div class="year-area">
													    <%= yearHtml.toString() %>
													</div>
													
													<div class="date-list" style="width: 1060px; margin-left: 75px;">
													    <%= btnHtml.toString() %>
													</div>
												    
												</div>
												<script>
												    function changeDate(date) {
												        // 날짜를 클릭하면 현재 페이지 URL에 '?date=2025.11.30' 형태로 파라미터를 붙여 이동합니다.
												        // 기존 쿼리스트링이 있다면 교체하거나 추가하는 로직이 필요할 수 있습니다.
												        // 가장 간단한 형태:
												        location.href = location.pathname + "?date=" + date;
												    }
												</script>
											</div>
										</div>
										<button type="button" title="다음 날짜 보기" class="btn-next"
											disabled="true" style="width: 20px;">
											<i class="iconset ico-cld-next" style = "margin-top: 15px; margin-right: 0px;"></i> <em>다음</em>
										</button>
									</div>
								</div>
							</div>
							<div class="movie-option mb20">
								<div class="rateing-lavel">
									<a href = "#favor_theater_setting" class = "right btn-modal-open" id = "favorBrchReg" w-data = "640" h-data = "470">관람등급안내</a>
								</div>
							</div>
							<div class="reserve theater-list-box">
								<div class="tab-block tab-layer mb30" style="display: none;">
									<ul></ul>
								</div>
								<%
								    // ---------------------------------------------------------
								    // 1. 요청 파라미터 처리 및 Service 호출
								    // ---------------------------------------------------------
								    
								    // 사용자가 선택한 날짜 가져오기 (없으면 오늘 날짜)
								    selectedDate = request.getParameter("date");
								    if (selectedDate == null || selectedDate.isEmpty()) {
								        selectedDate = new SimpleDateFormat("yyyy.MM.dd").format(new Date());
								    }
								    
								    // HTML 속성용 날짜 포맷 (예: 2025.11.30 -> 20251130)
								    String playDe = selectedDate.replace(".", "").replace("-", "");
									
								    // Service 객체 생성 및 데이터 가져오기
								    // (JSP에서는 SQL이나 DB 연결 정보를 전혀 몰라도 됩니다)
								    ScreenInfoService sis = ScreenInfoService.getInstance();
								    Map<String, Map<String, List<Map<String, String>>>> movieScheduleMap = 
								    		sis.getMovieSchedule(selectedDate);
								    
								    SimpleDateFormat screenSdf = new SimpleDateFormat("HH:mm");
								    
								%>
								
								<div class="schedule-output-area">
								
								<%
								    // 데이터가 아예 없는 경우에 대한 안내 메시지 처리
								    if (movieScheduleMap == null || movieScheduleMap.isEmpty()) {
								%>
								        <div class="no-data" style="text-align: center; padding: 50px;">
								            <p>해당 날짜에 상영 스케줄이 없습니다.</p>
								        </div>
								<%
								    } else {
								        // ---------------------------------------------------------
								        // Loop 1: 영화별 반복 (Key: 영화이름, Value: 상영관 맵)
								        // ---------------------------------------------------------
								        for (Map.Entry<String, Map<String, List<Map<String, String>>>> movieEntry : movieScheduleMap.entrySet()) {
								            String currentMovieName = movieEntry.getKey();
								            Map<String, List<Map<String, String>>> theaterGroup = movieEntry.getValue();
								            
								            // 영화 정보 출력을 위해 첫 번째 스케줄 데이터를 샘플로 가져옴
								            Map<String, String> firstSchedule = null;
								            for (List<Map<String, String>> list : theaterGroup.values()) {
								                if (!list.isEmpty()) {
								                    firstSchedule = list.get(0);
								                    break;
								                }
								            }
								            
								            // 데이터 방어 코드
								            if (firstSchedule == null) continue;
											
								            String runningTime = firstSchedule.get("RUNNING_TIME");
								            String movieCode = firstSchedule.get("MOVIE_CODE");
								            String movieGrade = firstSchedule.get("MOVIE_GRADE"); // 등급 데이터
								            
								            // 등급에 따른 CSS 클래스 결정 로직 (View 로직)
								            String gradeClass = "age-all";
								            if (movieGrade != null) {
								                if (movieGrade.contains("12")) gradeClass = "age-12";
								                else if (movieGrade.contains("15")) gradeClass = "age-15";
								                else if (movieGrade.contains("19") || movieGrade.contains("청불")) gradeClass = "age-19";
								                else if (movieGrade.contains("전체")) gradeClass = "age-all";
								            }
								%>
								    <div class="theater-list">
								        <div class="theater-tit">
								            <p class="movie-grade <%= gradeClass %>"></p>
								            <p>
								                <a href="/movie-detail?movieCode=<%= movieCode %>" title="<%= currentMovieName %> 상세보기">
								                    <%= currentMovieName %>
								                </a>
								            </p>
								            <p class="infomation">
								                <span>상영중</span>/상영시간 <%= runningTime %>분
								            </p>
								        </div>
								
								        <%
								            // ---------------------------------------------------------
								            // Loop 2: 상영관별 반복 (Key: 상영관이름, Value: 스케줄 리스트)
								            // ---------------------------------------------------------
								            for (Map.Entry<String, List<Map<String, String>>> theaterEntry : theaterGroup.entrySet()) {
								                String currentTheaterName = theaterEntry.getKey();
								                List<Map<String, String>> scheduleList = theaterEntry.getValue();
								                
								                // 상영관 좌석수는 해당 관의 스케줄 중 하나에서 가져옴
								                String totalSeat = scheduleList.get(0).get("TOTAL_SEAT");
								        %>
								        <div class="theater-type-box">
								            <div class="theater-type">
								                <p class="theater-name"><%= currentTheaterName %></p>
								                <p class="chair">총 <%= totalSeat %>석</p>
								            </div>
								            <div class="theater-time">
								                <div class="theater-time-box">
								                    <table class="time-list-table">
								                        <caption>상영시간표</caption>
								                        <colgroup>
								                            <col style="width: 99px;"><col style="width: 99px;"><col style="width: 99px;"><col style="width: 99px;">
								                            <col style="width: 99px;"><col style="width: 99px;"><col style="width: 99px;"><col style="width: 99px;">
								                        </colgroup>
								                        <tbody>
								                            <tr>
								                                <%
								                                    // ---------------------------------------------------------
								                                    // Loop 3: 시간표(회차)별 반복
								                                    // ---------------------------------------------------------
								                                    int playCount = 1; // 회차 카운트 (DB에 회차 정보가 없다면 임의 증가)
								                                    for (Map<String, String> schedule : scheduleList) {
								                                        String screenCode = schedule.get("SCREEN_CODE");  // 시작 시간
								                                        String screenOpen = schedule.get("SCREEN_OPEN");  // 시작 시간
								                                        String screenOpenTime = screenOpen.substring(screenOpen.indexOf(" "), screenOpen.lastIndexOf(":")).trim();
								                                        String remainSeat = schedule.get("REMAIN_SEAT");  // 잔여 좌석
								                                        
								                                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
								                                        LocalDateTime screenOpenDateTime = LocalDateTime.parse(screenOpen, formatter);
								                                        long minutesToAdd = Long.parseLong(runningTime);
								                                        LocalDateTime screenEndDateTime = screenOpenDateTime.plusMinutes(minutesToAdd);
								                                        String screenEnd = screenEndDateTime.toString();
								                                        String screenEndTime = screenEnd.substring(screenEnd.indexOf("T") + 1);
								                                        
								                                %>
								                                <td class="" 
								                                    play-de="<%= playDe %>" 
								                                    play-seq="<%= playCount %>" 
								                                    rpst-movie-no="<%= movieCode %>">
								                                    <div class="td-ab">
								                                        <div class="txt-center">
								                                            <a href="${commonURL}/user/fast_booking/fastBooking.jsp?movieCode=<%= movieCode %>&date=<%= selectedDate %>" title="영화예매하기">
								                                                <div class="ico-box">
								                                                    <i class="iconset ico-off"></i>
								                                                </div>
								                                                <p class="time"><%= screenOpenTime %></p>
								                                                <p class="chair"><%= remainSeat %></p>
								                                                <div class="play-time">
								                                                    <p><%= screenOpenTime %>~<%= screenEndTime %></p>
								                                                    <p><%= playCount %>회차</p>
								                                                </div>
								                                            </a>
								                                        </div>
								                                    </div>
								                                </td>
								                                <%
								                                        playCount++;
								                                    } // End Loop 3 (시간표)
								                                %>
								                            </tr>
								                        </tbody>
								                    </table>
								                </div>
								            </div>
								        </div>
								        <%
								            } // End Loop 2 (상영관)
								        %>
								    </div>
								<%
								        } // End Loop 1 (영화)
								    } // End if-else (데이터 유무 확인)
								%>
								</div>
								</div>
								<div class="box-border v1 mt30" style = "border: 0px solid; margin-bottom: 30px;">
									<li>지연입장에 의한 관람불편을 최소화하고자 본 영화는 약 10분 후 시작됩니다.</li>
									<li>쾌적한 관람 환경을 위해 상영시간 이전에 입장 부탁드립니다.</li>
								</div>
							</div>
						</div>
					</div>
						<!--// contents -->
					<div class="quick-area" style="display: none;">
						<a href="${commonURL}/screenSchedule/screenSchedule.jsp"
							class="btn-go-top" title="top" style="position: fixed;">top</a>
					</div>
				</div>
			<!-- footer -->
			<footer id="footer">
				<jsp:include page="../../fragments/footer.jsp"/>
			</footer>
			<!--// footer -->
			</div>
		<section id = "favor_theater_setting" class = "modal-layer">
			<div class = "wrap" style = "width: 640px; height: 500px; margin-left: -320px; margin-top: -235px;">
				<header class = "layer-header">
					<h3 class = "tit">관람등급안내</h3>
				</header>
				<div class = "layer-con" style = "height: 425px;">
					<div class = "table-wrap">
						<table class = "data-table grade-table">
							<caption>관람 등급을 등급명, 설명 순서로 보여줍니다.</caption>
							<colgroup>
								<col style = "width: 30%;"></col>
							</colgroup>
							<thead>
								<tr>
									<th>등급명</th>
									<th>설명</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>
										<p class = "movie-grade age-all">전체 관람가</p>
									</td>
									<td>
										모든 연령의 고객이 관람 가능
									</td>
								</tr>
								<tr>
									<td>
										<p class = "movie-grade age-12">12세 이상 관람가</p>
									</td>
									<td>
										만 12세 이상(주민등록상 생일 기준) 관람 가능
										<br>
										만 12세 미만 고객은 보호자(성인) 동반 시 관람 가능
									</td>
								</tr>
								<tr>
									<td>
										<p class = "movie-grade age-15">15세 이상 관람가</p>
									</td>
									<td>
										만 15세 이상(주민등록상 생일 기준) 관람 가능
										<br>
										만 15세 미만 고객은 보호자(성인) 동반 시 관람 가능
									</td>
								</tr>
								<tr>
									<td>
										<p class = "movie-grade age-15">청소년 관람 불가</p>
									</td>
									<td>
										만 19세 이상 관람 가능
										<br>
										- 19세가 되는 해의 1월 1일을 맞이한 경우 관람 가능
										<br>
										- 신분증 지참 필수 (티켓 구매, 입장시 확인)
										<br>
										만 19세 미만 고객은 보호자(성인) 동반 시에도 관람 불가	
									</td>
								</tr>
								<tr>
									<td>
										<p class = "movie-grade age-no">미정</p>
									</td>
									<td>
										등급 미정 영화
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<button type = "button" class = "btn-modal-close">레이어 닫기</button>
				</div>
			</div>
		</section>
</body>
</html>