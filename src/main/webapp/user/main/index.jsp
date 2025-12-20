<%@page import="movie.review.ReviewDTO"%>
<%@page import="movie.review.ReviewService"%>
<%@page import="movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<meta http-equiv="X-UA-Compatible" content="IE=edge">

<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
<title>2GV 메인화면.</title>
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css"
	media="all">
<link type="text/css" rel="stylesheet"
	href="chrome-extension://fheoggkfdfchfphceeifdbepaooicaho/css/mcafee_fonts.css">
</head>
<link rel="stylesheet" href="${commonURL}/resources/css/main.css"
	media="all">
	
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>	
<script src="${commonURL}/resources/js/megabox.api.min.js"></script>
<script src="${commonURL}/resources/js/lozad.min.js"></script>
<script src="${commonURL}/resources/js/ui.common.js"></script>
<script src="${commonURL}/resources/js/front.js"></script>

<script type="text/javascript">
$(function(){
	$("#btnSort").click(function(){
		location.href="${commonURL}/user/movie_all/movieListComming.jsp"
	});//click
	
	//$("#movieName")
	$("#btnSearch").click(function(){
		var searhText=$("#movieName").val();
		location.href="${commonURL}/user/movie_all/movieList.jsp?searchText="+searhText;
	});//click
	
});
</script>
<body style="padding: 0px;">
	<noscript>
		<iframe src="https://www.googletagmanager.com/ns.html?id=GTM-WG5DNB7D"
			height="0" width="0" style="display: none; visibility: hidden"></iframe>
	</noscript>
	<div class="body-wrap">

		<div></div>



		<header id="header" class="main-header no-bg">
			<jsp:include page="../../fragments/mainHeader.jsp" />
		</header>

		<div class="container main-container area-ad">
			<div id="contents">

				<div class="main-page">
					<div id="main_section01" class="section main-movie">
						<div class="bg">
							<div class="bg-pattern"></div>
							<img src="${commonURL}/resources/images/movie_bg.jpg"
								alt="still_01.jpg" onerror="noImg(this, &#39;main&#39;);">
						</div>

						<div class="cont-area">
							<div style="height: 50px;"></div>
							<div class="tab-sorting">
								<button type="button" class="on" sort="boxoRankList"
									name="btnSort" id="btnSort">박스오피스</button>
							</div>
							<a href="${commonURL}/user/movie_all/movieList.jsp" class="more-movie"
								title="더 많은 영화보기"> 더 많은 영화보기 <i
								class="iconset ico-more-corss gray"></i>
							</a>

							<%
							int currentPage = 1;
							int size = 4;
							
							MovieService ms = MovieService.getInstance();
							List<MovieDTO> list = ms.showPageMovie(currentPage, size);
							
							request.setAttribute("movies", list);
							request.setAttribute("currentPage", currentPage);
							request.setAttribute("size", size);
							%>
							<div class="main-movie-list">
								<ol class="list">
									<c:forEach var="m" items="${movies}" varStatus="i">
									<li name="li_boxoRankList" class="first" style="margin-right: 30px"><a
										href="${commonURL}/user/movie/detail.jsp?code=${m.moviecode}"
										class="movie-list-info" title="영화상세 보기">
											<div class="movie-grade_box">
												<div class="movie-grade big age-${m.moviegrade}"></div>
											</div>
											<p class="rank">
												<c:out value="${i.index+1}"/><span class="ir">위</span>
											</p> <img src="${commonURL}/${movieImgPath}/${m.moviecode}/${m.moviemainimg}"
											alt="${m.moviename}" class="poster"
											onerror="noImg(this, &#39;main&#39;);">
											<!-- <div class="wrap">
												<div class="summary">
													“아 집가고싶다”<br> <br>아 집가고싶다<br>‘아 집가고싶다<br>
												</div>
												<div class="score">
													<div class="preview">
														<p class="tit">관람평</p>
														<p class="number">
															0<span class="ir">점</span>
														</p>
													</div>
												</div>
											</div> -->
									</a>
										<div class="btn-util">
											<div class="case">
												<a href="${commonURL}/user/fast_booking/fastBooking.jsp"
													class="button gblue" title="영화 예매하기">예매</a>
											</div>
										</div></li>
									</c:forEach>
								</ol>
							</div>
							<div class="search-link">
								<div class="cell">
									<div class="search">
										<input type="text" placeholder="영화명을 입력해 주세요" title="영화 검색"
											class="input-text" id="movieName">
										<button type="button" class="btn" id="btnSearch">
											<i class="iconset ico-search-w"></i> 검색
										</button>
									</div>
								</div>

								<div class="cell">
									<a href="${commonURL}/user/dailyScreenSchedule/dailyScreenSchedule.jsp"
										title="상영시간표 보기"><i class="iconset ico-schedule-main"></i>
										상영시간표</a>
								</div>
								<div class="cell">
									<a href="${commonURL}/user/movie_all/movieList.jsp" title="박스오피스 보기"><i
										class="iconset ico-boxoffice-main"></i> 박스오피스</a>
								</div>
								<div class="cell">
									<a href="${commonURL}/user/fast_booking/fastBooking.jsp" title="빠른예매 보기"><i
										class="iconset ico-quick-reserve-main"></i> 빠른예매</a>
								</div>
							</div>
							<div class="moving-mouse">
								<img class="iconset" alt=""
									src="${commonURL}/resources/images/ico-mouse.png"
									style="top: 0px;">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<footer id="footer">
			<jsp:include page="../../fragments/footer.jsp"></jsp:include>
		</footer>
	</div>
	<form id="mainForm"></form>

	<div class="normalStyle"
		style="display: none; position: fixed; top: 0; left: 0; background: #000; opacity: 0.7; text-indent: -9999px; width: 100%; height: 100%; z-index: 100;">닫기</div>
	<div class="alertStyle"
		style="display: none; position: fixed; top: 0px; left: 0px; background: #000; opacity: 0.7; width: 100%; height: 100%; z-index: 5005;"></div>
	<span id="PING_CONTENT_DLS_POPUP" style="display: none;"></span>
</body>
</html>