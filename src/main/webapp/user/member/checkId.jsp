<%@page import="member.UserInfoService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%
    // 세션에 userId가 있다면 이미 로그인된 상태
    if (session.getAttribute("userId") != null) {
%>
    <script type="text/javascript">
        alert("이미 로그인된 상태입니다.");
        // 메인 페이지로 이동
        location.href = "${commonURL}/user/main/index.jsp";
    </script>
<%
        return; // 아래쪽의 로그인 폼(HTML)이 그려지지 않도록 즉시 종료
    }
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<title>아이디 중복체크</title>

<link rel="shortcut icon" href="${commonURL}/resources/images/favicon.ico">

<!-- bootstrap CDN 시작-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
	crossorigin="anonymous"></script>



<meta name="theme-color" content="#712cf9">


<style type="text/css">
body {
	font-family: 'Malgun Gothic', '맑은 고딕';
	margin: 10px 10px 10px 10px;
	padding: 20px;
	background-color: #f8f8f8;
	border: 1px solid #ccc;
	width: 550px;
	padding: 20px;
}

/* 제목 스타일 */
.title {
	font-size: 24px;
	font-weight: bold;
	color: #333;
	margin-bottom: 15px;
	border-bottom: 2px solid #eee;
	padding-bottom: 10px;
}

/* 설명 텍스트 스타일 */
.description {
	font-size: 14px;
	color: #555;
	line-height: 1.5;
	margin-bottom: 20px;
}

/* 아이디 입력 섹션 */
.input-group {
	display: flex;
	gap: 10px;
	margin-bottom: 30px;
	align-items: center;
}

.input-group input[type="text"] {
	flex-grow: 1;
	padding: 8px 10px;
	font-size: 16px;
	border: 1px solid #ccc;
	border-radius: 4px;
	font-family: inherit; /* 맑은 고딕 적용 */
}

/* 중복체크 버튼 스타일 */
.check-button {
	padding: 8px 15px;
	font-size: 14px;
	color: #fff;
	background-color: #5d35b8; /* 확인 버튼과 비슷한 보라색 */
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-family: inherit;
}

.check-button:hover {
	background-color: #4a2890;
}

/* 하단 버튼 그룹 스타일 */
.button-group {
	display: flex;
	justify-content: center; /* 버튼을 오른쪽으로 정렬 */
	gap: 20px;
}

/* 취소 버튼 스타일 (흰색 바탕, 보라색 테두리) */
.btn-cancel {
	padding: 10px 20px;
	font-size: 16px;
	color: #5d35b8;
	background-color: #fff;
	border: 2px solid #5d35b8;
	border-radius: 4px;
	cursor: pointer;
	font-family: inherit;
	min-width: 80px;
	text-align: center;
}

/* 확인 버튼 스타일 (보라색 바탕, 흰색 글씨) */
.btn-confirm {
	padding: 10px 20px;
	font-size: 16px;
	color: #fff;
	background-color: #5d35b8;
	border: 2px solid #5d35b8; /* 통일성을 위해 테두리 추가 */
	border-radius: 4px;
	cursor: pointer;
	font-family: inherit;
	min-width: 80px;
	text-align: center;
}

.btn-cancel:hover, .btn-confirm:hover {
	opacity: 0.9;
}

#wrap {
	margin: 0px auto;
	width: 480px;
	height: 380px;
	align-content:
}
</style>
<!-- jQuery CDN 시작 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function() {
		$("#btnCheck").click(function() {
			findId();
		});
		$("#id").keydown(function(evt) {
			chkEnter(evt);
		});
		//취소버튼 클릭시 꺼짐
		
	});//ready 

	function chkEnter(evt) {
		if (evt.which == 13) {//엔터키를 눌렀다면 findId 실행
			findId();
		}//end if
	}//chkEnter
	function findId() {
		var obj = $("#popupFrm");

		var id = obj.find('#id').val();

		if (id.replace(/ /g, "") == "") {
			alert("중복검사할 아이디를 입력해주세요.");
			return;
		}//end if
		obj.submit();//백엔드로(여기선 자신) 요청을 보냄.
	}//findId

	function sendId(id) {
		var $opener = opener.window.jQuery; 
	    
	    // 1. isIdChecked 값을 'true'로 설정하여 폼 제출 허용
	    $opener("#isIdChecked").val('true');
	    
	    // 2. id 필드에 값 설정
	    $opener("#users_id").val(id); 
	    
	    // ⭐⭐⭐ 3. 메시지 출력 영역에 메시지 설정 ⭐⭐⭐
	    $opener("#idCheckMsg").html('*중복 확인이 완료되었습니다*'); 
	    
	    // 자식창 닫기
	    self.close();
	}
	
	function cancelIdCheck() {
			var parentIdCheckedField = opener.window.document.joinFrm.isIdChecked;
		    if (parentIdCheckedField) {
		        parentIdCheckedField.value = 'false';
		    }
		    opener.window.document.joinFrm.id.value = "";
		    // 3. 자식 창 닫기
		    self.close();
	}
</script>
</head>
<body>
	<div id="wrap">
		<div class="title">아이디 중복 확인</div>

		<div class="description">사용하고자 하시는 아이디를 입력 후 중복확인 버튼을 클릭해 주십시오.
			중복 체크 진행 후 사용 가능한 아이디일 경우에 사용 버튼을 눌러주세요.</div>

		<form id="popupFrm" action="checkId.jsp" method="get">
			<div class="input-group">
				<input type="text" name="id" id="id" value="${ param.id }"
					style="width: 200px" placeholder="아이디 입력" /> <input type="button"
					class="check-button" id="btnCheck" value="중복확인">
			</div>
		</form>

	<!-- 	<div class="button-group">
			<input type="button" class="btn-confirm" value="확인">
			<input type="button" class="btn-cancel" value="취소"> 
		</div> -->
		
		<c:if test="${ not empty param.id }">
			<div id="searchResult">
				<%
				UserInfoService uiService = UserInfoService.getInstance();
				boolean flagId = uiService.searchId(request.getParameter("id"));
				pageContext.setAttribute("flagId", flagId);
				%>
				아이디 상태 :
				<%=flagId%>
				<c:set var="resultCss" value="fail" />
				<c:set var="resultMsg" value="사용 불가능" />
				<c:if test="${ flagId }">
					<c:set var="resultCss" value="sucess" />
					<c:set var="resultMsg" value="사용 가능" />
				</c:if>
				입력하신 <strong>${ param.id }</strong>는 <span class="${ resultCss }">
					<c:out value="${resultMsg }" />
				</span>
				<div class="button-group">
				<c:if test="${flagId }">
					<a href="javascript: sendId( '${ param.id }' )"><input type="button" class="btn-confirm" value="확인"></a>
				</c:if>
				<input type="button" class="btn-cancel" id="btnCancel" value="취소" onclick="cancelIdCheck()";> 
				</div>
			</div>
		</c:if>
	</div>
</body>
</html>