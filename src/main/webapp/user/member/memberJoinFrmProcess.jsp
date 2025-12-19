<%@page import="SiteProperty.SitePropertyVO"%>
<%@page import="member.UserInfoService"%>
<%@page import="java.util.Formatter"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css"
	media="all">
<%
/* POST방식에서 한글 깨짐 방지. */
request.setCharacterEncoding("UTF-8");
%>

<style>
/* signup-wrapper 스타일을 재활용하여 성공 메시지 박스로 사용 */
.success-wrapper {
	font-family: '맑은 고딕', 'Malgun Gothic', sans-serif;
	background-color: white;
	min-height: 50%;
	width: 100%;
	max-width: 780px; /* 폼과 동일한 최대 너비 */
	margin: 40px auto; /* 상하 여백 추가 */
	padding: 40px 20px;
	box-sizing: border-box;
	border: 1px solid black;
	border-radius: 8px;
	text-align: center; /* 내부 텍스트 중앙 정렬 */
}

.success-title {
	font-size: 24px;
	font-weight: 700;
	color: #333;
	margin-bottom: 20px;
}

.success-content {
	font-size: 16px;
	color: black;
	line-height: 1.6;
	margin-bottom: 30px;
}

.btn-main-page {
	background-color: #7A5DE8;
	color: red;
	font-size: 16px;
	font-weight: bold;
	padding: 12px 30px;
	border: none;
	border-radius: 6px;
	text-decoration: none;
	display: inline-block;
	cursor: pointer;
	transition: background-color 0.2s;
}

.btn-main-page:hover {
	background-color: #684ac2;
}

/* 중복 메시지 박스 스타일 */
.error-wrapper {
	max-width: 480px;
	min-height: 30%;
	margin: 40px auto;
	padding: 25px 20px;
	border: 1px solid #ffcccc; /* 빨간색 경계 */
	background-color: #fffafa; /* 연한 배경 */
	border-radius: 8px;
	text-align: center;
}

.error-wrapper p {
	margin-bottom: 15px;
	font-size: 16px;
	color: #cc0000;
}

.error-wrapper a {
	font-size: 14px;
	color: #7A5DE8;
	text-decoration: underline;
}
</style>

<body>


	<div class="body-wrap">
		<header id="header">
			<jsp:include page="../../fragments/header.jsp" />
		</header>

		<div class="page-util">
			<div class="inner-wrap">
				<div class="location">
					<span>Home</span> <a
						href="${commonURL}/user/member/memberLogin.jsp" title="회원">회원</a>
					<a href="#" title="회원가입">회원가입</a>
				</div>
			</div>
		</div>

		<jsp:useBean id="uDTO" class="member.userDTO" scope="page" />
		<%-- <jsp:setProperty property="*" name="uDTO" /> --%>
		<%
		uDTO.setUsers_id(request.getParameter("users_id"));
		uDTO.setUsers_pass(request.getParameter("users_pass"));
		uDTO.setUsers_name(request.getParameter("users_name"));
		uDTO.setGender(request.getParameter("gender"));
		uDTO.setPhone_num(request.getParameter("phone_num"));

		//가입 및 로그인 시간
		/* Date date = new Date(); */
		/* SimpleDateFormat sdfDate = new SimpleDateFormat("yyyy-MM-dd"); */
		/* SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd a hh:mm:ss"); */

		/* String nowDate = sdfDate.format(date); */
		/* String loginDate = sdfTime.format(date); */

		//일단 해놨는데, DB에는 sysdate로 넣음.
		/* uDTO.setJoin_date(sdfDate.parse(nowDate));
		uDTO.setRecent_login(sdfDate.parse(nowDate)); */

		//생일 데이터 입력(String형으로)
		String birthString = request.getParameter("birth");

		SimpleDateFormat sdfBirth = new SimpleDateFormat("yyyy-MM-dd");

		java.util.Date birthDate = sdfBirth.parse(birthString);
		String StrbirthDate = sdfBirth.format(birthDate);
		uDTO.setBirth(StrbirthDate);
		/* 		uDTO.setBirth(birthDate); */

		//name은 유일한 이름이기 때문에 괜찮지만
		//emain은 mail과 domain으로 분리되어 있다.
		uDTO.setEmail(request.getParameter("mail") + "@" + request.getParameter("domain"));

		UserInfoService uis = UserInfoService.getInstance();

		//한정적인 자원을(id) 동시에 사용할 때 조회를 먼저 수행한 후 다음 작업으로 진행한다.
		boolean idFlag = uis.searchId(request.getParameter("users_id"));

		if (!idFlag) {//아이디가 DB에 존재함 (중복됨/선점된 경우)
		%>

		<div class="error-wrapper">
			<p>
				입력하신 <strong>${ param.users_id }</strong>는 이미 사용중입니다.
			</p>
			<p>다른 아이디를 입력해주세요.</p>
			<a href="javascript:history.back()" class="btn btn-sucess">뒤로</a>
		</div>

		<%
		} else {
		SitePropertyVO sv = new SitePropertyVO();
		String key = sv.getKey();//키는 반드시 16글자

		//	boolean addFlag = uis.addMember(uDTO, spVO.getKey());
		boolean addFlag = uis.addMember(uDTO, key);
		pageContext.setAttribute("addFlag", addFlag);
		%>

		<c:choose>
			<c:when test="${addFlag }">
				<div class="success-wrapper">
					<h2 class="success-title">회원가입이 완료되었습니다.</h2>
					<p class="success-content">
						<strong>${ param.users_name }</strong> 고객님 2GV에 가입해 주셔서 감사합니다.<br>
						이제 다양한 서비스를 이용하실 수 있습니다.
					</p>
					<a href="${commonURL}/user/main/index.jsp" class="btn-main-page"
						style="color: black;">메인페이지로 이동</a>
				</div>

			</c:when>
			<c:otherwise>
				<div class="error-wrapper">
					<p>
						죄송합니다. <strong>${ param.users_name }</strong>님 회원 가입을 실패하였습니다.
					</p>
					<p>잠시 후 다시 시도해 주세요.</p>
					<a href="javascript:history.back()">뒤로</a>
				</div>
			</c:otherwise>
		</c:choose>
		<%
		} //end else
		%>
		<footer id="footer">
			<jsp:include page="../../fragments/footer.jsp"></jsp:include>
		</footer>
	</div>
</body>