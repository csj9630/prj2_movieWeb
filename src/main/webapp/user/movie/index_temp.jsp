<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">

<title>상세 전용 임시홈</title>
<link rel="shortcut icon"
	href="http://192.168.10.82/jsp_prj/common/images/favicon.ico">

<style type="text/css">
#wrap {
	margin: 0px auto;
	width: 1200px;
	height: 1000px;
}

#header {
	height: 150px;
}

#container {
	height: 700px;
}

#footer {
	height: 150px;
}
</style>
<!-- jQuery CDN 시작 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

<script type="text/javascript">
	$(function() {

	});//ready
</script>


</head>
<body>

	<main>
		<!-- Wrap the rest of the page in another container to center all the content. -->
		<div class="container marketing">
			<hr class="featurette-divider">
			<div class="row featurette">
				<div class="col-md-7" style="text-align: center;">
					<!-- 여기서부터 작성 시작-->
					<h1>클릭하면 영화 상세 페이지로 이동합니다...</h1>
					<h2>
						<a
							href="${commonURL}/user/movie/detail_process_test.jsp">DB 테스트용</a>
					</h2>
					<%--
					<h3><a href="http://localhost/sist_myLab_prj2_movie/user/movie/detail.jsp?name=mc001">MC001</a></h3>
					 --%>
					<%
					String code = null;
					int limit = 50; //현 시점 영화 4개까지 준비됨

					for (int i = 0; i < limit; i++) {
						code = "mc";
						code += String.format("%3s", i + 1).replace(" ", "0");
					%>
					<h2>
						<a href="${commonURL}/user/movie/detail.jsp?name=<%=code%>">영화 코드 : <%=code%></a>
					</h2>
					<%
					} //end for
					%>
				</div>

			</div>
			<hr class="featurette-divider">
			<!-- /END THE FEATURETTES -->
		</div>
		<!-- /.container -->
		<!-- FOOTER -->

	</main>

</body>
</html>