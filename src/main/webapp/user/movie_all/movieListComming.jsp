<%@page import="movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieService"%>
<%@page import="movie.MovieDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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

#movieList.searching li:nth-child(4n) ~ li {
    margin-top: 0 !important;
}
</style>
<script type="text/javascript">
$(function() {
	// 개봉일순 버튼 누르면
	//$("#sortRelease").click(sortMoiveList);
	// 가나다순 버튼 누르면
	//$("#sortAlphabet").click(sortMoiveList);
	
	$("#ibxMovieNmSearch").keyup(searchMovie);
	
	// 더보기 버튼 누르면
	$("#btnAddMovie").click(function(){
		filterUpComming();
	})
});

function searchMovie() {
	var keyword = $("#ibxMovieNmSearch").val().toLowerCase().trim();
	
	if (keyword.length > 0) {
        $("#movieList").addClass("searching");
    } else {
        $("#movieList").removeClass("searching");
    }
	
	$("#movieList li").each(function() {
		var title = $(this).find(".tit").text().toLowerCase();
		if (title.includes(keyword)) {
			$(this).show();
		} else {
			$(this).hide();
		}
	});
}

function sortMoiveList(){

}//sortMovieList

var startRank=5; //더보기 버튼을 눌렀을 때 순위를 위해서 전역변수로 선언

function filterUpComming(){
	var currentPage = parseInt($("#currentPage").val()); //현재 페이지
	var size = $("#recordCountPerPage").val(); //한 화면에 보여줄 개수 4
	var param = {currentPage:currentPage, size:size};
	var nextPage = currentPage+1;
	
	/* if(paging) { // 데이터를 가져오면
		currentPage++; // 숫자를 1 추가
	} else { 
		currentPage=1;
		return;
	} */
	//var param = {currentPage:currentPage, size:size};
	
	$.ajax({
		url:"upCommingMovieList.jsp",
		type:"GET",
		data:param,
		dataType:"JSON",
		error:function(xhr){
			alert("개봉작 데이터를 불러올 수 없습니다.");
			console.log(xhr.statusText + "/" + xhr.status);
		},
		success:function(jsonArr){
		  	//데이터가 없으면 더보기 버튼 숨기기, 현재 구조에서는 마지막 배열 데이터 길이와 size가 같으면 더보기 버튼 한번 더 눌러야 되는 문제
		    if(jsonArr.length<size) {
		    	$("#btnAddMovie").hide();
		    }
			/* ajax 요청이 성공해서 넘어올 데이터 */
			$.each(jsonArr, (idx, obj) => {
				var rank=idx+startRank;
				var releasedate = obj.releasedate.replace(/-/g, ".");
				
				var appendMovie = 
			        "<li tabindex='0' class='no-img'>" +

			            "<div class='movie-list-info'>" +
			                "<a href='${commonURL}/user/movie/detail.jsp?code=" + obj.moviecode +
			                    "' class='wrap movieBtn' data-no='" + obj.moviecode + "' title='" + obj.moviename + " 상세보기'>" +

			                    "<p class='rank'>" +
			                        rank + "<span class='ir'>위</span>" +
			                    "</p>" +
			                    "<img src='${commonURL}/${movieImgPath}/"+ obj.moviecode +"/"+obj.mainimage +
			                         "' alt='" + obj.moviename + "' " +
			                         "class='poster lozad' " +
			                         "onerror='noImg(this)'>" +
			                "</a>" +
			            "</div>" +

			            "<div class='tit-area'>" +
			                "<p class='movie-grade age-" + obj.moviegrade + "'></p>" +
			                "<p title='" + obj.moviename + "' class='tit'>" + obj.moviename + "</p>" +
			            "</div>" +

			            "<div class='rate-date'>" +
			                "<span class='rate'>예매율 " + (obj.bookrate||0) + "%</span>" +
			                "<span class='date'>개봉일 " + releasedate + "</span>" +
			            "</div>" +

			            "<div class='btn-util'>" +
			                "<p class='txt movieStat1' style='display:none'>상영예정</p>" +
			                "<p class='txt movieStat2' style='display:none'>11월 개봉예정</p>" +
			                "<p class='txt movieStat5' style='display:none'>개봉예정</p>" +
			                "<p class='txt movieStat6' style='display:none'>상영종료</p>" +

			                "<div class='case col-2 movieStat3'>" +
			                    "<a href='${commonURL}/user/fast_booking/fastBooking.jsp' " +
			                        "class='button purple bokdBtn' data-no='" + obj.moviecode + "' title='영화 예매하기'>예매</a>" +
			                "</div>" +

			                "<div class='case movieStat4' style='display:none'>" +
			                    "<a href='#' class='button purple bokdBtn'>예매</a>" +
			                "</div>" +
			            "</div>" +

			        "</li>";
			    $("#movieList").append(appendMovie);
				
				$("#currentPage").val(nextPage);
			});//each
			startRank += jsonArr.length;
		}//success
	});//ajax
	
}//filterUpComming
</script>
</head>

<body>
<header id="header">
<jsp:include page="../../fragments/header.jsp"/>
</header>
<%
int currentPage=1;
int size=4;

MovieService ms=MovieService.getInstance();
List<MovieDTO> list=ms.showUpCommingMovie(currentPage, size);

request.setAttribute("movies", list);
request.setAttribute("currentPage", currentPage);
request.setAttribute("size", size);
%>
<div class="container">
	<!-- 좌측 상단 홈/영화/전체영화  -->
	<div class="page-util">
		<div class="inner-wrap">
			<div class="location">
				<span>Home</span>
                <a href="#" title="영화 페이지로 이동">영화</a>
                <a href="#" title="전체영화 페이지로 이동">전체영화</a>
			</div>			
		</div>
	</div>

	<!-- contents -->
	<div id="contents" class="">
		<!-- inner-wrap -->
		<div class="inner-wrap">
			<h2 class="tit">전체영화</h2>

			<div class="tab-list fixed">
				<ul id="topMenu">
					<li><a href="movieList.jsp" title="박스오피스 탭으로 이동">박스오피스</a></li>
					<!-- 상영 예정작으로  -->
					<li class="on"><a href="" title="상영예정작 탭으로 이동">상영예정작</a></li>					
				</ul>
			</div>

			<!-- movie-list-util -->
			<div class="movie-list-util mt40">
				<!-- 상영예정작 -->
				<!-- <div class="topSort">
					<div class="movie-sorting sortTab">
						<span><button type="button" class="btn on" id="sortRelease" sort-type="rfilmDe">개봉일순</button></span>
						<span><button type="button" class="btn" id="sortAlphabet" sort-type="title">가나다순</button></span>
					</div>
				</div> -->
				<!--// 상영예정작 -->

				<!-- 검색결과 없을 때 -->
				<p class="no-result-count"><strong id="totCnt"><%= ms.totalUpComming() %></strong>개의 영화가 검색되었습니다.</p>
				<!--// 검색결과 없을 때 -->

				<div class="movie-search">
					<input type="text" title="영화명을 입력하세요" id="ibxMovieNmSearch" name="ibxMovieNmSearch" placeholder="영화명 검색" class="input-text">
					<button type="button" class="btn-search-input" id="btnSearch">검색</button>
				</div>
			</div>
			<!--// movie-list-util -->

			<!-- 페이지 로딩이 오래 걸리시 나오는 페이지 -->
			<div class="bg-loading" style="display: none;">
				<div class="spinner-border" role="status">
					<span class="sr-only">Loading...</span>
				</div>
			</div>

			<!-- movie-list -->
				<div class="movie-list">
					<!-- 현재 페이지 -->
					<input type="hidden" id="currentPage" value="${currentPage}">
					<!-- 페이지 당 개수 -->
					<input type="hidden" id="recordCountPerPage" value="${size}">

					<ol class="list" id="movieList">
						<c:forEach var="m" items="${movies}" varStatus="i">

							<li tabindex="0" class="no-img">

								<div class="movie-list-info">
									<!-- 여기가 이제  -->
									<a href="${commonURL}/user/movie/detail.jsp?code=${m.moviecode}"
										class="wrap movieBtn" data-no="${m.moviecode}" title="${m.moviename} 상세보기">
										<p class="rank">
											<c:out value="${i.index+1}"/><span class="ir">위</span>
										</p>
										<img
										src="${commonURL}/${movieImgPath}/${m.moviecode}/${m.moviemainimg}"
										alt="${m.moviename}" class="poster lozad" onerror="noImg(this)">
									</a>
								</div> 
								<div class="tit-area">
									<p class="movie-grade age-${m.moviegrade}"></p>
									<p title="${m.moviename}" class="tit">${m.moviename}</p>
								</div>
								<div class="rate-date">
									<span class="rate">예매율 ${m.bookrate}%</span> 
									<span class="date">개봉일 
									<fmt:parseDate value="${m.moviereleasedate}" pattern="yyyy-MM-dd" var="releaseDate"/>
        							<fmt:formatDate value="${releaseDate}" pattern="yyyy.MM.dd"/></span>
								</div>
								<div class="btn-util">
									<p class="txt movieStat1" style="display: none">상영예정</p>
									<p class="txt movieStat2" style="display: none">11월 개봉예정</p>
									<p class="txt movieStat5" style="display: none">개봉예정</p>
									<p class="txt movieStat6" style="display: none">상영종료</p>

									<div class="case col-2 movieStat3">
										<a
											href="${commonURL}/user/fast_booking/fastBooking.jsp"
											class="button purple bokdBtn" data-no="${m.moviecode}"
											title="영화 예매하기"> 예매 </a>
									</div>
									<div class="case movieStat4" style="display: none">
										<a href="#" class="button purple bokdBtn">예매</a>
									</div>
								</div>
							</li>
						</c:forEach>
					</ol>
				</div>
			<!--// movie-list -->

			<!-- 더보기 버튼 -->
			<div class="btn-more v1" id="addMovieDiv" style="">
				<button type="button" class="btn" id="btnAddMovie">더보기 <i class="iconset ico-btn-more-arr"></i></button>
			</div>

			<!-- 검색결과 없을 때 -->
			<div class="movie-list-no-result" id="noDataDiv" style="display: none;">
				<p>현재 상영중인 영화가 없습니다.</p>
			</div>
		</div>
	</div>
</div>
<footer id="footer">
	<jsp:include page="../../fragments/footer.jsp"></jsp:include>
</footer>
</body>