<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<head>
<!-- 상단 favicon 이미지  -->
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
<!-- 전체적인 css -->
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css"
	media="all">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style type="text/css">
.bokdBtn {
	width: 230px !important;
	height: 42px !important;
	line-height: 42px !important;
	text-align: center;
	padding: 0 !important;
}
 .quick-reserve-area	* {
	  /* body 태그의 자손(하위)인 모든 요소에 적용 */
	  border: 1px solid blue;
	  
}
	

</style>
<script type="text/javascript">
	$(function() {
		$(".btn-next").click(function() {

		});
	});
</script>
</head>
<body>
	<header id="header">
		<jsp:include page="../../fragments/header.jsp" />
	</header>
	<div class="inner-wrap"
		style="padding-top: 40px; padding-bottom: 100px;">
		<input type="hidden" id="playDe" name="playDe" value="2025.12.14">
		<input type="hidden" id="crtDe" name="crtDe" value="2025.12.14">

		<div class="quick-reserve">
			<div class="tit-util">
				<h2 class="tit">빠른예매</h2>
			</div>
			<!-- mege-quick-reserve-inculde : 다른 페이지에서 iframe 으로 설정될 영역 -->
			<div class="mege-quick-reserve-inculde">

				<!-- time-schedule -->
				<div class="time-schedule quick">
					<div class="wrap">

						<!-- 이전날짜 -->
						<button type="button" title="이전 날짜 보기" class="btn-pre"
							disabled="true">
							<i class="iconset ico-cld-pre"></i> <em>이전</em>
						</button>
						<!--// 이전날짜 -->

						<div class="date-list">
							<!-- 년도, 월 표시 -->
							<div class="year-area">
								<div class="year" style="left: 30px; z-index: 1; opacity: 1;">2025.12</div>
								<div class="year" style="left: 450px; z-index: 1; opacity: 0;"></div>
							</div>

							<div class="date-area" id="formDeList">
								<div class="wrap"
									style="position: relative; width: 2100px; border: none; left: -70px;">
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
									String[] dayNames = { "", "일", "월", "화", "수", "목", "금", "토" };
									String[] dayNamesEn = { "", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" };
									%>
									<div class="date-list" style="width: 1040px;">
										<%
										// 3. 14일치 날짜 생성 반복문
										for (int i = 0; i < 17; i++) {
											int year = cal.get(Calendar.YEAR);
											int month = cal.get(Calendar.MONTH); // 0~11
											int day = cal.get(Calendar.DATE) - 1;
											int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK); // 1(일) ~ 7(토)

											// 날짜 포맷팅 (yyyy.MM.dd)
											String dateData = String.format("%04d.%02d.%02d", year, month + 1, day);

											// CSS 클래스 계산 (토요일, 일요일, 그리고 선택된 날짜 'on')
											String btnClass = "";
											if (dayOfWeek == Calendar.SATURDAY)
												btnClass = "sat";
											else if (dayOfWeek == Calendar.SUNDAY)
												btnClass = "holi";

											// 현재 출력중인 날짜가 선택된 날짜와 같으면 'on' 클래스 추가
											if (dateData.equals(selectedDate)) {
												btnClass += " on";
											}

											// 표기할 요일 텍스트 결정 (오늘, 내일, 그 외 요일)
											String dayText = dayNames[dayOfWeek];

											// 오늘/내일 로직: 반복중인 cal 날짜와 고정된 todayCal 비교
											long diffSec = (cal.getTimeInMillis() - todayCal.getTimeInMillis()) / 1000;
											long diffDays = diffSec / (24 * 60 * 60); // 일수 차이 계산

											if (diffDays == 1)
												dayText = "오늘";
											else if (diffDays == 2)
												dayText = "내일";
										%>

										<button class="<%=btnClass%>" type="button"
											date-data="<%=dateData%>" month="<%=month%>"
											onclick="changeDate('<%=dateData%>')">

											<span class="ir"><%=year%>년 <%=month + 1%>월</span> <em
												style="pointer-events: none;"> <%=day%> <span
												style="pointer-events: none;" class="ir">일</span>
											</em> <span class="day-kr"
												style="pointer-events: none; display: inline-block"><%=dayText%></span>
											<span class="day-en"
												style="pointer-events: none; display: none"><%=dayNamesEn[dayOfWeek]%></span>
										</button>

										<%
										// 4. 핵심: 하루 증가 (이전 답변의 해결책 적용)
										cal.add(Calendar.DATE, 1);
										} // end for
										%>
									</div>
									
									<!-- button class="disabled sat" type="button"
										date-data="2025.12.13" month="11" tabindex="-1">


										<span class="ir">2025년 12월</span><em
											style="pointer-events: none;">13<span
											style="pointer-events: none;" class="ir">일</span></em><span
											class="day-kr"
											style="pointer-events: none; display: inline-block">토</span><span
											class="day-en" style="pointer-events: none; display: none">Sat</span>
									</button>
									<button class="on" type="button" date-data="2025.12.14"
										month="11">
										<span class="ir">2025년 12월</span><em
											style="pointer-events: none;">14<span
											style="pointer-events: none;" class="ir">일</span></em><span
											class="day-kr"
											style="pointer-events: none; display: inline-block">오늘</span><span
											class="day-en" style="pointer-events: none; display: none">Sun</span>
									</button> -->
								</div>
							</div>
						</div>

						<!-- 다음날짜 -->
						<button type="button" title="다음 날짜 보기" class="btn-next">
							<i class="iconset ico-cld-next"></i> <em>다음</em>
						</button>
						<!--// 다음날짜 -->

						<!-- 달력보기 -->
						<div class="bg-line">
							<input type="hidden" id="datePicker" value="2025.12.14"
								class="hasDatepicker">
							<!-- <button type="button" id="calendar" onclick="$(&#39;#datePicker&#39;).datepicker(&#39;show&#39;)" class="btn-calendar-large" title="달력보기"> 달력보기</button>
 -->
						</div>
						<!--// 달력보기 -->
					</div>
				</div>
				<!--// time-schedule -->

				<!-- quick-reserve-area -->
				<div class="quick-reserve-area">

					<!-- movie-choice : 영화 선택  -->
					<div class="movie-choice" style="width:50%;">
						<p class="tit">영화</p>

						<!-- list-area -->
						<div class="list-area">

							<!-- all : 전체 -->
							<div class="all-list">
								<button type="button" class="btn-tab on" id="movieAll">전체</button>
								<div class="list">
									<div class="scroll m-scroll mCustomScrollbar _mCS_1"
										id="movieList">
										<div id="mCSB_1"
											class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside"
											style="max-height: none;" tabindex="0">
											<div id="mCSB_1_container" class="mCSB_container"
												style="position: relative; top: 0; left: 0;" dir="ltr">
												<ul>
													<li><button type="button" class="btn"
															movie-nm="아바타: 불과 재" movie-no="25094900"
															img-path="/SharedImg/2025/12/01/E9stZsj4uMvXM0YSK7wIiShsutnOtAI2_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="N">
															<span class="movie-grade small age-12">12세이상관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">아바타: 불과 재</span>
														</button></li>
													<li><button type="button" class="btn"
															movie-nm="주토피아 2" movie-no="25089000"
															img-path="/SharedImg/2025/11/27/YiSbqEf6OvFcDoLoQCipDojOHqMCwKG4_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="Y">
															<span class="movie-grade small age-all">전체관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">주토피아 2</span>
														</button></li>
													<li><button type="button" class="btn"
															movie-nm="만약에 우리" movie-no="25096900"
															img-path="/SharedImg/2025/12/04/W6p1b8p719ZRz5LvVdBwWEOJqQZGYIyH_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="N">
															<span class="movie-grade small age-15">15세이상관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">만약에 우리</span>
														</button></li>
													<li><button type="button" class="btn" movie-nm="룩백"
															movie-no="24045300"
															img-path="/SharedImg/2024/09/05/nBHvmCh9wY9dOc0be7LJor2jDYNoOVqT_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="Y">
															<span class="movie-grade small age-all">전체관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">룩백</span>
														</button></li>
													<li><button type="button" class="btn"
															movie-nm="사운드 오브 폴링" movie-no="25092800"
															img-path="/SharedImg/2025/11/24/XWNcwsPyjtVmFZZWP55lY1I5WKqEllTt_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="N">
															<span class="movie-grade small age-15">15세이상관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">사운드 오브 폴링</span>
														</button></li>
												</ul>
											</div>
											<div id="mCSB_1_scrollbar_vertical"
												class="mCSB_scrollTools mCSB_1_scrollbar mCS-light mCSB_scrollTools_vertical"
												style="display: block;">
												<div class="mCSB_draggerContainer">
													<div id="mCSB_1_dragger_vertical" class="mCSB_dragger"
														style="position: absolute; min-height: 30px; display: block; max-height: 310px; top: 0px; height: 51px;">
														<div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
													</div>
													<div class="mCSB_draggerRail"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!--// all : 전체 -->

							<!-- other-list  : 12세 -->
							<div class="other-list">
								<button type="button" class="btn-tab" id="movieAgeAll"><span class="movie-grade small age-all"></span></button>
								<div class="list">
									<div
										class="scroll m-scroll mCustomScrollbar _mCS_2 mCS_no_scrollbar"
										id="crtnMovieList">
										<div id="mCSB_2"
											class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside"
											style="max-height: none;" tabindex="0">
											<div id="mCSB_2_container"
												class="mCSB_container mCS_no_scrollbar_y"
												style="position: relative; top: 0; left: 0;" dir="ltr">
												<ul>
													<li><button type="button" class="btn"
															movie-nm="주토피아 2" movie-no="25089000"
															img-path="/SharedImg/2025/11/27/YiSbqEf6OvFcDoLoQCipDojOHqMCwKG4_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="Y">
															<span class="movie-grade small age-all">전체관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">주토피아 2</span>
														</button></li>
												</ul>
											</div>
											<div id="mCSB_2_scrollbar_vertical"
												class="mCSB_scrollTools mCSB_2_scrollbar mCS-light mCSB_scrollTools_vertical">
												<div class="mCSB_draggerContainer">
													<div id="mCSB_2_dragger_vertical" class="mCSB_dragger"
														style="position: absolute; min-height: 30px; display: none; top: 0px;">
														<div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
													</div>
													<div class="mCSB_draggerRail"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							
							<!-- 12세 이하-->
							<div class="other-lists">
								<button type="button" class="btn-tab" id="movieAge12"><span class="movie-grade small age-12"></span></button>
								<div class="list">
									<div
										class="scroll m-scroll mCustomScrollbar _mCS_2 mCS_no_scrollbar"
										id="crtnMovieList">
										<div id="mCSB_2"
											class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside"
											style="max-height: none;" tabindex="0">
											<div id="mCSB_2_container"
												class="mCSB_container mCS_no_scrollbar_y"
												style="position: relative; top: 0; left: 0;" dir="ltr">
												<ul>
													<li><button type="button" class="btn"
															movie-nm="주토피아 2" movie-no="25089000"
															img-path="/SharedImg/2025/11/27/YiSbqEf6OvFcDoLoQCipDojOHqMCwKG4_150.jpg"
															movie-popup-at="N" movie-popup-no="0" form-at="Y">
															<span class="movie-grade small age-all">전체관람가</span><i
																class="iconset ico-heart-small">보고싶어 설정안함</i><span
																class="txt">주토피아 2</span>
														</button></li>
												</ul>
											</div>
											<div id="mCSB_2_scrollbar_vertical"
												class="mCSB_scrollTools mCSB_2_scrollbar mCS-light mCSB_scrollTools_vertical">
												<div class="mCSB_draggerContainer">
													<div id="mCSB_2_dragger_vertical" class="mCSB_dragger"
														style="position: absolute; min-height: 30px; display: none; top: 0px;">
														<div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
													</div>
													<div class="mCSB_draggerRail"></div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- 12세 이하-->
						</div>
						<!--// list-area -->

						<!-- view-area -->
						<div class="view-area">

							<!-- 영화 선택 하지 않았을 때 -->
							<div class="choice-all" id="choiceMovieNone">
								<strong>모든영화</strong> <span>목록에서 영화를 선택하세요.</span>
							</div>

							<!-- 영화를 한개라도 선택했을 때 -->
							<div class="choice-list" id="choiceMovieList"
								style="display: none;">
								<!-- 비어있는 영역 -->
								<div class="bg"></div>
								<div class="bg"></div>
								<div class="bg"></div>
							</div>
						</div>
						<!--// view-area -->
					</div>
					<!--// movie-choice : 영화 선택  -->

					<!-- time-choice : 상영시간표 선택 -->
					<div class="time-choice">
						<div class="tit-area">
							<p class="tit">시간</p>

							<div class="right legend">
								<i class="iconset ico-sun" title="조조"></i> 조조 <i
									class="iconset ico-brunch" title="브런치"></i> 브런치 <i
									class="iconset ico-moon" title="심야"></i> 심야
							</div>
						</div>

						<!-- hour-schedule : 시간 선택  : 00~30 시-->
						<div class="hour-schedule">
							<button type="button" class="btn-prev-time">이전 시간 보기</button>

							<div class="wrap">
								<div class="view" style="position: absolute; width: 1015px;">
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">00</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">01</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">02</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">03</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">04</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">05</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">06</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">07</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">08</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">09</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">10</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">11</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">12</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">13</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">14</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">15</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">16</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">17</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">18</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">19</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">20</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">21</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">22</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">23</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">24</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">25</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">26</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">27</button>
									<button type="button" class="hour" disabled="true"
										style="opacity: 0.5">28</button>

								</div>
							</div>

							<button type="button" class="btn-next-time">다음 시간 보기</button>
						</div>
						<!--// hour-schedule : 시간 선택  : 00~30 시-->

						<!-- movie-schedule-area : 시간표 출력 영역-->
						<div class="movie-schedule-area">

							<!-- 영화, 영화관 선택 안했을때 -->
							<!---->
							<div class="no-result" id="playScheduleNonList">
								<i class="iconset ico-movie-time"></i>

								<p class="txt">
									영화와 극장을 선택하시면<br> 상영시간표를 비교하여 볼 수 있습니다.
								</p>
							</div>


							<!-- 영화, 영화관 선택 했을때 -->
							<div class="result">
								<div
									class="scroll m-scroll mCustomScrollbar _mCS_4 mCS_no_scrollbar"
									id="playScheduleList" style="display: none;">
									<div id="mCSB_4"
										class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside"
										style="max-height: 760px;" tabindex="0">
										<div id="mCSB_4_container"
											class="mCSB_container mCS_no_scrollbar_y"
											style="position: relative; top: 0; left: 0;" dir="ltr"></div>
										<div id="mCSB_4_scrollbar_vertical"
											class="mCSB_scrollTools mCSB_4_scrollbar mCS-light mCSB_scrollTools_vertical">
											<div class="mCSB_draggerContainer">
												<div id="mCSB_4_dragger_vertical" class="mCSB_dragger"
													style="position: absolute; min-height: 30px; display: none; top: 0px;">
													<div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
												</div>
												<div class="mCSB_draggerRail"></div>
											</div>
										</div>
									</div>
								</div>

							</div>
						</div>
						<!--// movie-schedule-area : 시간표 출력 영역-->

					</div>
					<!--// time-choice : 상영시간표 선택 -->
				</div>
				<!--// quick-reserve-area -->
			</div>
			<!--// mege-quick-reserve-inculde : 다른 페이지에서 iframe 으로 설정될 영역 -->

		</div>
		<!--// quick-reserve -->

	</div>
	<!--// inner-wrap -->
	
	<footer id="footer">
		<jsp:include page="../../fragments/footer.jsp"></jsp:include>
	</footer>
	
</body>