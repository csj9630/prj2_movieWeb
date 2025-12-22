<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>

<%@
    taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- <%@ include
    file="../../fragments/loginChk2.jsp"%> --%>
<%@ page import="java.util.*"%>
<%@ page import="moviestory.service.MovieReviewService"%>
<%@ page import="moviestory.dto.MovieReviewDTO"%>
<%
request.setCharacterEncoding("UTF-8");
// 1. [Session 처리]
String userId = (String) session.getAttribute("userId");
/* if (userId == null)
	userId = "test1"; // Hotfix for testing (Real DB Data: test1) */
// 2. [DB 연동 및 데이터 조회]
MovieReviewService service = MovieReviewService.getInstance();
List<MovieReviewDTO> reviewList = service.getReviewList(userId); // null 체크 
if (reviewList == null) {
	reviewList = new ArrayList<MovieReviewDTO>();
}

// (Merged scriptlet)
// 3. [DEBUG] 데이터 진단
System.out.println("[DEBUG] mypage_review.jsp - UserId: " + userId);
System.out.println("[DEBUG] mypage_review.jsp - ReviewList Size: " + (reviewList != null ? reviewList.size() : "null"));
%>
<!-- [DEBUG INFO] User: <%= userId %>, List Size: <%= (reviewList != null ? reviewList.size() : 0) %> -->
<!DOCTYPE html>
<html lang="ko">
<head>
<jsp:include page="../../fragments/loginChk.jsp" />
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>나의 관람평</title>
<jsp:include page="/fragments/style_css.jsp" />
<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<jsp:include page="style.jsp" />
<script type="text/javascript">
    // 1. 초기화 (window.onload)
    window.onload = function() {
        // 전역 클릭 이벤트 (메뉴 닫기)
        document.addEventListener("click", function() {
            closeAllMenus();
        });
    };

    // 2. 메뉴 토글 함수
    function toggleMenu(btn) {
        closeAllMenus();
        var dropdown = btn.nextElementSibling;
        dropdown.classList.toggle("show");
        event.stopPropagation();
    }

    function closeAllMenus() {
        var dropdowns = document.querySelectorAll(".menu-dropdown");
        dropdowns.forEach(function(d) {
            d.classList.remove("show");
        });
    }

    // 3. 인라인 수정 기능
    function startEdit(menuItem) {
        closeAllMenus();

        var reviewItem = $(menuItem).closest(".review-item");
        var reviewNum = reviewItem.data("review-num");
        var currentScore = reviewItem.find(".review-score").data("score");
        var currentContent = reviewItem.find(".review-text").data("content");

        var reviewBox = reviewItem.find(".review-box");
        var reviewLeft = reviewItem.find(".review-left");

        // 원래 내용 저장
        reviewItem.data("original-html", reviewLeft.html());

        // 수정 폼으로 변경
        var editHtml = '<span class="review-badge">관람평</span>'
                + '<input type="number" class="review-score-input" value="' + currentScore + '" min="1" max="10" />'
                + '<span class="review-separator"></span>'
                + '<div class="review-text-group" style="flex:1;">'
                + '<div class="movie-title">'
                + reviewItem.find(".movie-title").text()
                + "</div>"
                + '<textarea class="review-edit-input">' + currentContent + '</textarea>'
                + '<div class="edit-buttons">'
                + '<button class="btn-save" onclick="saveEdit(this)">저장</button>'
                + '<button class="btn-cancel" onclick="cancelEdit(this)">취소</button>'
                + "</div>" + "</div>";

        reviewLeft.html(editHtml);

        // 메뉴 버튼 숨기기
        reviewBox.find(".menu-btn").hide();
    }

    function saveEdit(btn) {
        var reviewItem = $(btn).closest(".review-item");
        var reviewNum = reviewItem.data("review-num");
        var newScore = reviewItem.find(".review-score-input").val();
        var newContent = reviewItem.find(".review-edit-input").val();

        if (newScore < 1 || newScore > 10) {
            alert("점수는 1점에서 10점 사이로 입력해주세요.");
            return;
        }

        // AJAX로 수정 요청
        $.ajax({
            url : "${commonURL}/user/movie_moviestroy/reviewModifyProcess.jsp",
            type : "POST",
            data : {
                reviewNum : reviewNum,
                score : newScore,
                content : newContent
            },
            dataType : "JSON",
            error : function(xhr) {
                alert("수정 중 오류가 발생했습니다.");
                console.log(xhr.statusText + "/" + xhr.status);
            },
            success : function(result) {
                if (result.success) {
                    // 성공 - 화면 업데이트
                    var movieTitle = reviewItem.find(".movie-title").text();

                    var newHtml = '<span class="review-badge">관람평</span>'
                            + '<span class="review-score" data-score="' + newScore + '">'
                            + newScore
                            + "</span>"
                            + '<span class="review-separator"></span>'
                            + '<div class="review-text-group">'
                            + '<div class="movie-title">'
                            + movieTitle
                            + "</div>"
                            + '<div class="review-text" data-content="' + newContent + '">'
                            + newContent + "</div>" + "</div>";

                    reviewItem.find(".review-left").html(newHtml);
                    reviewItem.find(".menu-btn").show();

                    alert("리뷰가 수정되었습니다.");
                } else {
                    alert(result.message || "수정에 실패했습니다.");
                }
            },
        });
    }

    function cancelEdit(btn) {
        var reviewItem = $(btn).closest(".review-item");
        var originalHtml = reviewItem.data("original-html");

        reviewItem.find(".review-left").html(originalHtml);
        reviewItem.find(".menu-btn").show();
    }

    // 4. 삭제 기능
    function deleteReview(menuItem) {
        closeAllMenus();

        if (!confirm("정말 이 리뷰를 삭제하시겠습니까?")) {
            return;
        }

        var reviewItem = $(menuItem).closest(".review-item");
        var reviewNum = reviewItem.data("review-num");

        // AJAX로 삭제 요청
        $.ajax({
            url : "${commonURL}/user/movie_moviestroy/reviewRemoveProcess.jsp",
            type : "POST",
            data : {
                reviewNum : reviewNum
            },
            dataType : "JSON",
            error : function(xhr) {
                alert("삭제 중 오류가 발생했습니다.");
                console.log(xhr.statusText + "/" + xhr.status);
            },
            success : function(result) {
                if (result.success) {
                    // 성공 - 해당 항목 제거 (애니메이션)
                    reviewItem.fadeOut(300, function() {
                        $(this).remove();

                        // 남은 리뷰가 없으면 메시지 표시
                        if ($("#reviewListContainer .review-item").length === 0) {
                            $("#reviewListContainer").html(
                                '<div style="text-align:center; padding:50px; color:#999;">작성한 관람평이 없습니다.</div>'
                            );
                        }
                    });
                    alert("리뷰가 삭제되었습니다.");
                } else {
                    alert(result.message || "삭제에 실패했습니다.");
                }
            },
        });
    }
</script>
</head>
<body>
	<!-- 헤더 -->
	<div id="header">
		<jsp:include page="../../fragments/header.jsp" />
	</div>

	<!-- 브레드크럼 -->
	<nav class="breadcrumb" aria-label="breadcrumb">
		<div class="container">
			<ol class="breadcrumb-list">
				<li><a href="${commonURL}/user/main/index.jsp" title="홈으로 이동"> <i
						class="fa-solid fa-house"></i>
				</a> <span class="breadcrumb-separator">></span></li>
				<li><span class="current">나의 2GV</span> <span class="breadcrumb-separator">></span>
				</li>
				<li><span class="current">나의 관람평</span></li>
			</ol>
		</div>
	</nav>

	<!-- 메인 컨텐츠 -->
	<div class="container">
		<div class="page-wrap">
			<!-- 사이드바 (sideFrame.jsp 적용) -->
			<%
			request.setAttribute("activeMenu", "movie-story");
			%>
			<%@ include file="../../fragments/sideFrame.jsp"%>

			<!-- 메인 컨텐츠 -->
			<main class="main-content">
				<h1 class="page-title">나의 무비스토리</h1>

				<!-- 탭 메뉴 -->
				<div class="tab-menu">
					<div class="tab-item"
						onclick="location.href='mypage_movieStory1.jsp'">무비타임라인</div>
					<div class="tab-item active"
						onclick="location.href='mypage_review.jsp'">관람평</div>
				</div>

				<div class="review-list-container" id="reviewListContainer">
					<%
					for (MovieReviewDTO review : reviewList) {
					%>
					<!-- Review Item (Repeated) -->
					<div class="review-item"
						data-review-num="<%=review.getReview_num()%>">
						<div class="reviewer-info">
                            <a href="${pageContext.request.contextPath}/user/movie/detail.jsp?mCode=<%=review.getMovie_code()%>">
                            <img src="${pageContext.request.contextPath}/resources/images/movieImg/<%=review.getMovie_code()%>/<%=review.getMain_image()%>" class="poster" alt="포스터">
                            </a>
                            <div class="username" style="margin-top: 5px;"><%=userId%></div>
						</div>
						<div class="review-content-wrap">
							<div class="review-box">
								<div class="review-left">
									<span class="review-badge">관람평</span> <span
										class="review-score"
										data-score="<%=review.getReview_score()%>"><%=review.getReview_score()%></span>
									<span class="review-separator"></span>
									<div class="review-text-group">
										<div class="movie-title">
											<%=review.getMovie_name()%>
										</div>
										<div class="review-text"
											data-content="<%=review.getReview_content()%>">
											<%=review.getReview_content()%>
										</div>
									</div>
								</div>
								<div class="menu-btn" onclick="toggleMenu(this)">
									<i class="fa-solid fa-ellipsis-vertical"></i>
								</div>
								<div class="menu-dropdown">
									<div class="menu-dropdown-item" onclick="startEdit(this)">
										수정</div>
									<div class="menu-dropdown-item delete"
										onclick="deleteReview(this)">삭제</div>
								</div>
							</div>
							<div class="review-meta">
								<%=review.getReview_date() != null ? review.getReview_date().toString() : ""%>
							</div>
						</div>
					</div>
					<%
					} // end for
					%>
					<%
					if (reviewList.isEmpty()) {
					%>
					<div style="text-align: center; padding: 50px; color: #999">
						작성한 관람평이 없습니다.</div>
					<%
					}
					%>
				</div>
			</main>
		</div>
	</div>

	<!-- 푸터 -->
	<div id="footer"><jsp:include page="../../fragments/footer.jsp"/></div>

    <!-- Script moved to head -->
</body>
</html>
