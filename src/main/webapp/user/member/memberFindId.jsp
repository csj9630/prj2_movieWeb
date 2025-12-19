<%@page import="SiteProperty.SitePropertyVO"%>
<%@page import="member.UserInfoService"%>
<%@page import="member.userDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<%
/* POST방식에서 한글 깨짐 방지. */
request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css"
	media="all">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
<title>아이디 찾기</title>
<style>
/* === [통일된 레이아웃] === */
body {
	margin: 0;
	background-color: #f9f9f9; /* 기본 배경(회색) */
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}

/* 중간 흰색 영역 (위치 고정의 핵심) */
.main-container-white {
	background-color: white;
	width: 100%;
	flex: 1; /* 남은 공간 채우기 */
	/* ★중요★: 카드 길이에 상관없이 무조건 위에서 60px 띄움 */
	padding-top: 60px;
	padding-bottom: 60px;
	display: flex;
	justify-content: center; /* 가로 중앙 정렬 */
	align-items: flex-start; /* 세로 상단 정렬 (이게 없으면 길이가 다를 때 흔들림) */
}

/* 카드 스타일 */
.wrapper {
	font-family: '맑은 고딕', 'Pretendard', sans-serif;
	background-color: white;
	width: 100%;
	max-width: 480px;
	margin: 0; /* 마진 0으로 고정 (위치 제어는 부모가 함) */
	padding: 40px 30px;
	box-sizing: border-box;
	border: 1px solid #eaeaea;
	border-radius: 8px;
	/* box-shadow: 0 4px 10px rgba(0,0,0,0.05); */
}

/* === 내부 요소 스타일 (두 파일 공통) === */
.title {
	text-align: center;
	font-size: 24px;
	font-weight: 700;
	color: #333;
	margin-bottom: 30px;
}

.tab-container {
	display: flex;
	margin-bottom: 30px;
}

.tab-item {
	flex: 1;
	text-align: center;
	padding: 12px 0;
	font-size: 15px;
	text-decoration: none;
	color: #888;
	border-bottom: 2px solid #ddd;
	cursor: pointer;
	transition: all 0.2s;
}

.tab-item.active {
	color: #7A5DE8;
	border-bottom: 2px solid #7A5DE8;
	font-weight: 600;
}

.form-group {
	margin-bottom: 20px;
}

.form-label {
	display: block;
	font-size: 14px;
	color: #555;
	margin-bottom: 8px;
	font-weight: 500;
}

.form-input {
	width: 100%;
	height: 50px;
	padding: 0 15px;
	font-size: 15px;
	border: none;
	background-color: #F4F5F7;
	border-radius: 6px;
	box-sizing: border-box;
	color: #333;
	outline: none;
}

.form-input:focus {
	box-shadow: 0 0 0 2px #7A5DE8;
}

.btn-submit {
	width: 100%;
	height: 55px;
	background-color: #7A5DE8;
	color: white;
	font-size: 16px;
	font-weight: 600;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	margin-top: 10px;
}

.btn-submit:hover {
	background-color: #684ac2;
}

/* 모달 스타일 */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4);
	z-index: 999;
	justify-content: center;
	align-items: center;
}

.modal-overlay.show {
	display: flex;
}

.modal-window {
	background: white;
	width: 320px;
	border-radius: 4px;
	overflow: hidden;
}

.modal-header {
	background-color: #55359E;
	color: white;
	padding: 12px 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	font-weight: 600;
}

.modal-close-btn {
	background: none;
	border: none;
	color: white;
	font-size: 20px;
	cursor: pointer;
}

.modal-body {
	padding: 30px 20px;
	text-align: center;
	font-size: 14px;
	line-height: 1.6;
	color: #333;
}

.modal-footer {
	padding-bottom: 20px;
	text-align: center;
}

.modal-confirm-btn {
	background-color: #55359E;
	color: white;
	border: none;
	padding: 8px 25px;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 600;
}
</style>
<script type="text/javascript">
	$(function() {

		/* modal창 닫기 */
		$("#checkModal").click(function() {
			$("#resultModal").removeClass("show");
		})//click

		/* modal창 닫기 */
		$("#closeModal").click(function() {
			$("#resultModal").removeClass("show");
		})//click

		//ID찾기 버튼 클릭 후 유효성 검사 및 데이터 back-end로 전송
		$("#btnFindId").click(function(e) {
			e.preventDefault();

			// 이름 유효성 검사
			if ($("#users_name").val().trim() === "") {
				alert("이름을 입력해주세요.");
				$("#users_name").focus();
				return;
			}

			// 생년월일 유효성 검사
			if ($("#birth").val().trim() === "") {
				alert("생년월일을 입력해주세요.");
				$("#birth").focus();
				return;
			}

			// 이메일 유효성 검사
			if ($("#mail").val().trim() === "") {
				alert("메일을 입력해주세요.");
				$("#mail").focus(); // 포커스 추가
				return;
			}

			// 도메인 유효성 검사
			if ($("#domain").val().trim() === "") {
				alert("도메인을 선택(또는 입력)해주세요."); // 메시지 수정 제안
				$("#domain").focus(); // 포커스 추가
				return;
			}

			// 휴대폰 번호 유효성 검사
			if (!isPhoneNumber($("#phone_num").val())) {
				alert("핸드폰 번호를 '010-XXXX-XXXX' 형식으로 입력하여 주십시오.");
				$("#phone_num").focus(); // #phone_num으로 수정됨
				return;
			}

			// 모든 유효성 검사 통과 시 폼 제출
			$("#findIdFrm").submit();
			/* $("#resultModal").addClass("show"); */
		});


	});//ready

	/* 휴대폰번호 입력 체크 정규식 */
	function isPhoneNumber(phone) {
		const regex = /^010-\d{4}-\d\d\d\d$/;

		// 입력된 값이 비어있는지 확인 (공백 포함)
		if (phone.trim() === "") {
			return false;
		}
		// 정규표현식 검사
		return regex.test(phone);
	}//isPhoneNumber
</script>
</head>
<body>
	<header id="header"><jsp:include
			page="../../fragments/header.jsp" /></header>

	<div class="page-util">
		<div class="inner-wrap">
			<div class="location">
				<span>Home</span> <a href="${commonURL}/user/member/memberLogin.jsp"
					title="회원">회원</a> <a href="#">아이디 찾기</a>
			</div>
		</div>
	</div>

	<div class="main-container-white">
		<div class="wrapper">
			<h1 class="title">아이디 / 비밀번호 찾기</h1>

			<div class="tab-container">
				<a href="#" class="tab-item active">아이디 찾기</a> <a
					href="${commonURL}/user/member/memberFindPw.jsp" class="tab-item">비밀번호
					찾기</a>
			</div>

			<%-- <jsp:useBean id="uDTO" class="member.userDTO" scope="page" />
			<jsp:setProperty property="*" name="uDTO" /> --%>

			<%
			boolean formSubmitted = (request.getParameter("users_name") != null);
			String scriptToExecute = ""; // 실행할 JavaScript 코드를 담을 변수
			System.out.println(request.getParameter("users_name"));
			System.out.println(request.getParameter("phone_num"));
			System.out.println(request.getParameter("birth"));
			if (formSubmitted) {
				userDTO uDTO = new userDTO();
				uDTO.setUsers_name(request.getParameter("users_name"));
				uDTO.setPhone_num(request.getParameter("phone_num"));
				uDTO.setBirth(request.getParameter("birth"));

				uDTO.setEmail(request.getParameter("mail") + "@" + request.getParameter("domain"));
				UserInfoService uis = UserInfoService.getInstance();
				/* 임시 key */
				SitePropertyVO sv = new SitePropertyVO();
				String key = sv.getKey();//키는 반드시 16글자
				boolean flagId = false;
				flagId = uis.searchUserId(uDTO, key);
				System.out.println("d결과 : " + flagId);
				if (flagId != false) { // 성공 시
					// 성공 시 모달 내용 업데이트
					String modalContent = "회원님의 아이디는 <b>[ " + uDTO.getUsers_id() + " ] 입니다.</b>";
			%>
			<script type="text/javascript">
                    $(document).ready(function() {
                        $("#resultModal .modal-body").html('<%=modalContent%>');
                        $("#resultModal").addClass("show");
                        
                    });
                </script>
			<%
			} else { // 실패 시
			// 실패 시 모달 내용 업데이트
			String modalContent = "입력하신 정보와 일치하는 아이디를 찾을 수 없습니다.";
			%>
			<script type="text/javascript">
                    $(document).ready(function() {
                        $("#resultModal .modal-body").html('<%=modalContent%>');
					$("#resultModal").addClass("show");
				});
			</script>
			<%
			}
			//--------------
			%>

			<%
			}
			%>
			<form id="findIdFrm" name="findIdFrm" method="post">
				<div class="form-group">
					<label class="form-label">이름</label> <input type="text"
						class="form-input" id="users_name" name="users_name"
						placeholder="이름 입력" value="으악">
				</div>

				<div class="form-group">
					<label class="form-label">생년월일</label> <input type="date"
						class="form-input" name="birth" id="birth"
						placeholder="0000 - 00 - 00" max="9999-12-31" min="1900-01-01"
						value="1995-05-13">
				</div>

				<div class="form-group">
					<label class="form-label">Email</label> <input type="text"
						class="form-input" name="mail" id="mail" placeholder="example"
						style="width: 50%;" value="으악">@ <select name="domain"
						id="domain" class="form-input" style="width: 45%;">
						<option value="gmail.com">gmail.com</option>
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hotmail.com">hotmail.com</option>
					</select>
				</div>

				<div class="form-group">
					<label class="form-label">휴대폰 번호</label> <input type="tel"
						name="phone_num" id="phone_num" class="form-input"
						placeholder="010-1234-5678" value="010-1234-5678">
				</div>
				<input type="button" value="아이디 찾기" class="btn-submit"
					id="btnFindId" />
			</form>
		</div>
	</div>

	<div class="modal-overlay" id="resultModal">
		<div class="modal-window">
			<div class="modal-header">
				<span>알림</span>
				<button class="modal-close-btn" id="closeModal">✕</button>
			</div>
			<div class="modal-body"></div>
			<div class="modal-footer">
				<button class="modal-confirm-btn" id="checkModal">확인</button>
			</div>
		</div>
	</div>

	<footer id="footer"><jsp:include
			page="../../fragments/footer.jsp" /></footer>



</body>
</html>