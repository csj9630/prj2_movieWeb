<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="ci">
	<a href="${commonURL}/user/main/index.jsp" title="2GV 메인으로 가기"
		style="height:55px; background-image: url('${commonURL}/resources/images/mainHeader.png');"></a>
</h1>
<!-- 2019-04-15 마크업 수정 : 고객요청  -->
<div class="util-area">

	<div class="right-link">
		<!-- 로그인 상태 확인하여 상단바 바꿔주기 -->
		<%
		// 세션에서 값 가져오기
		String userId = (String) session.getAttribute("userId");
		String userName = (String) session.getAttribute("userName");
		%>
		<div class="login-status">
			<%
			if (userId != null && !"".equals(userId)) {
			%>
			<div class="after">
				<a href="${commonURL}/user/movie_mypage/mypage_main.jsp" class="" title=""><%=userName%>님</a>
				<a href="${commonURL}/user/member/logout.jsp" title="로그아웃">로그아웃</a>
			</div>
			<%
			} else {
			%>
			<div class="before">
				<a href="${commonURL}/user/member/memberLogin.jsp" title="로그인">로그인</a>
				<a href="${commonURL}/user/member/memberJoinFrm.jsp" title="회원가입">회원가입</a>
			</div>
			<%
			}
			%>
		</div>

		<!-- 로그인후 -->
		<div class="after" style="display: none">
			<a href="${commonURL}/user/member/logout.jsp"
				class="" title="로그아웃">로그아웃</a> 
				<a href="https://www.megabox.co.kr/movie" class="notice" title="알림">알림</a>

			<!-- layer-header-notice -->
			<div class="layer-header-notice">
				<div class="notice-wrap">
					<p class="tit-notice">알림함</p>

					<div class="count">
						<p class="left">
							전체 <em class="totalCnt">0</em> 건
						</p>

						<p class="right">* 최근 30일 내역만 노출됩니다.</p>
					</div>

					<!-- scroll -->
					<div
						class="scroll m-scroll mCustomScrollbar _mCS_1 mCS_no_scrollbar">
						<div id="mCSB_1"
							class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside"
							style="max-height: 0px;" tabindex="0">
							<div id="mCSB_1_container"
								class="mCSB_container mCS_no_scrollbar_y"
								style="position: relative; top: 0; left: 0;" dir="ltr">
								<ul class="list">
									<li class="no-list">알림 내역이 없습니다.</li>
								</ul>
							</div>
							<div id="mCSB_1_scrollbar_vertical"
								class="mCSB_scrollTools mCSB_1_scrollbar mCS-light mCSB_scrollTools_vertical">
								<div class="mCSB_draggerContainer">
									<div id="mCSB_1_dragger_vertical" class="mCSB_dragger"
										style="position: absolute; min-height: 30px; display: none; top: 0px;">
										<div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
									</div>
									<div class="mCSB_draggerRail"></div>
								</div>
							</div>
						</div>
					</div>
					<div class="notice-list-more">
						<button type="button" class="button btn-more-notice-list">
							더보기 <i class="iconset ico-btn-more-arr"></i>
						</button>
					</div>
					<!--// scroll -->
					<button type="button" class="btn-close-header-notice">알림
						닫기</button>
				</div>
				<!--// notice-wrap -->
				<!--// layer-header-notice -->
			</div>

		</div>

		<a href="${commonURL}/user/fast_booking/fastBooking.jsp">빠른예매</a>
	</div>
</div>
<!--// 2019-04-15 마크업 수정 : 고객요청  -->

<div class="link-area">
	<a href="https://www.megabox.co.kr/movie#layer_sitemap"
		class="header-open-layer btn-layer-sitemap" title="사이트맵">사이트맵</a>
	<!-- 새로운 페이지(DB연결 필요)를 만들어야 해서 시간 남으면 하는걸로. -->
	<!-- <a href="https://www.megabox.co.kr/booking/timetable" class="link-ticket" title="상영시간표">상영시간표</a> -->
	<!-- 나의 페이지로 바로 가게 만들기 -->
	<a href="${commonURL}/user/movie_mypage/mypage_main.jsp" class=" btn-layer-mymega" title="나의 메가박스">나의 메가박스</a>
</div>

<!-- gnb -->
<nav id="gnb">
	<ul class="gnb-depth1">
		<li><a href="${commonURL}/user/movie_all/movieList.jsp"
			class="gnb-txt-movie" title="영화">영화</a>
			<div class="gnb-depth2">
				<ul style="position: absolute; left: 10%;">
					<li><a href="${commonURL}/user/movie_all/movieList.jsp" title="전체영화">전체영화</a></li>
				</ul>
			</div></li>
		<li></li>
		<li><a href="${commonURL}/user/fast_booking/fastBooking.jsp"
			class="gnb-txt-reserve" title="예매">예매</a>
			<div class="gnb-depth2">
				<ul>
					<li><a href="${commonURL}/user/fast_booking/fastBooking.jsp" title="빠른예매">빠른예매</a></li>
					<li><a href="${commonURL}/user/dailyScreenSchedule/dailyScreenSchedule.jsp"
						title="상영시간표">상영시간표</a></li>
				</ul>
			</div></li>
		<li></li>

		<li style="position: relative;"><a
			href="${commonURL}/user/movie_seaterInfo/movie-seaterInfo.jsp" class="gnb-txt-theater"
			title="극장">극장</a>
		</li>
	</ul>
</nav>
<!--// gnb -->

<!-- 레이어 : 사이트맵 -->
<!-- 햄버거바 누르면 켜지는 거 야메로 만든 거. 삭제 ㄴㄴㄴㄴㄴㄴㄴ -->
<script type="text/javascript">
	document
			.addEventListener(
					'DOMContentLoaded',
					function() {
						// 1. 사이트맵 레이어 (토글 대상)와 버튼 요소 가져오기
						const sitemapLayer = document
								.getElementById('layer_sitemap');
						const sitemapButton = document
								.querySelector('.btn-layer-sitemap');

						if (!sitemapLayer || !sitemapButton) {
							console
									.error("필요한 요소를 찾을 수 없습니다 (layer_sitemap 또는 btn-layer-sitemap).");
							return;
						}

						// 2. 버튼 클릭 이벤트 리스너 등록
						sitemapButton.addEventListener('click',
								function(event) {
									// 기본 앵커 태그 동작(페이지 이동, 주소 변경) 방지
									event.preventDefault();

									// 3. 현재 display 상태를 확인하고 토글
									if (sitemapLayer.style.display === 'none') {
										// 숨겨져 있으면 보이게 (inline으로 변경)
										sitemapLayer.style.display = 'inline';
									} else {
										// 보이고 있으면 숨기게 (none으로 변경)
										sitemapLayer.style.display = 'none';
									}
								});

						// 💡 초기 상태 설정 (필요하다면)
						// HTML에 style="display: inline;"으로 되어있으므로, 이 부분을 주석 처리하거나 제거하면
						// 처음에는 숨겨진 상태로 시작하게 할 수 있습니다. (display: none; 이 기본 상태일 때)
						sitemapLayer.style.display = 'none';
					});
</script>

<div id="layer_sitemap" class="header-layer layer-sitemap"
	style="height: 700px;">
	<!-- wrap -->
	<div class="wrap">
		<a href="https://www.megabox.co.kr/main" class="link-acc"
			title="사이트맵 레이어 입니다.">사이트맵 레이어 입니다.</a>

		<p class="tit">SITEMAP</p>

		<div class="list position-1">
			<p class="tit-depth">회사소개</p>

			<ul class="list-depth">
				<li><a href="${commonURL}/user/companyIntro/companyIntro.jsp" title="2GV 소개">2GV
						소개</a></li>
			</ul>
		</div>

		<div class="list position-2">
			<p class="tit-depth">영화</p>

			<ul class="list-depth">
				<li><a href="${commonURL}/user/movie_all/movieList.jsp" title="전체영화">전체영화</a></li>
			</ul>
		</div>

		<div class="list position-3">
			<p class="tit-depth">안내</p>

			<ul class="list-depth">
				<li><a href="${commonURL}/user/announcement/announcementList.jsp"
					title="공지사항">공지사항</a></li>
			</ul>
		</div>

		<div class="list position-4">
			<p class="tit-depth">극장</p>

			<ul class="list-depth">
				<li><a href="${commonURL}/user/movie_seaterInfo/movie-seaterInfo.jsp" title="극장 정보">
						극장 정보</a></li>
			</ul>
		</div>

		<div class="list position-5">
			<p class="tit-depth">예매</p>

			<ul class="list-depth">
				<li><a href="${commonURL}/user/fast_booking/fastBooking.jsp" title="빠른 예매">빠른
						예매</a></li>
				<li><a href="${commonURL}/user/dailyScreenSchedule/dailyScreenSchedule.jsp"
					title="상영 시간표">상영 시간표</a></li>
			</ul>
		</div>
		<div class="list position-6">
			<p class="tit-depth">나의 2GV</p>
			<ul class="list-depth mymage">


				<li><a
					href="${commonURL}/user/movie_mypage/mypage_main.jsp"
					title="나의 메가박스 홈">마이페이지 홈</a></li>
				<li><a
					href="${commonURL}/user/movie_book/mypageBook1.jsp"
					title="예매/구매내역">예매/구매내역</a></li>
				<li><a
					href="${commonURL}/user/movie_moviestroy/mypage_movieStory1.jsp"
					title="나의 무비스토리">나의 무비스토리</a></li>
				<li><a
					href="${commonURL}/user/movie_mystory_mainpage/mypage_withdraw1.jsp"
					title="회원정보">회원정보</a></li>

			</ul>
		</div>



		<div class="ir">
			<a href="${commonURL}/user/main/index.jsp" class="layer-close"
				title="레이어닫기">레이어닫기</a>
		</div>
	</div>
	<!--// wrap -->
</div>
<!--// 레이어 : 사이트맵 -->