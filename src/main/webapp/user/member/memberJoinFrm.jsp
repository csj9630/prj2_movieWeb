<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
<html lang="en" data-bs-theme="auto">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>2GV, 회원가입</title>
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
<style>
/* === 기본 설정 === */
.signup-wrapper {
	font-family: '맑은 고딕', 'Malgun Gothic', sans-serif;
	background-color: white;
	width: 100%;
	max-width: 480px;
	margin: 0 auto;
	padding: 40px 20px;
	box-sizing: bo rder-box;
	border: 1px solid #eaeaea;
	border-radius: 8px;
}

.signup-title {
	text-align: center;
	font-size: 28px;
	font-weight: 700;
	color: #333;
	margin-bottom: 40px;
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

/* === 인풋 박스 스타일 === */
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
	transition: box-shadow 0.2s;
}

.form-input::placeholder {
	color: #adb5bd;
}

.form-input:focus {
	box-shadow: 0 0 0 2px #7A5DE8;
}

/* === 아이디 중복확인 그룹 === */
.users_id-group {
	display: flex;
	gap: 10px;
}

.btn-check {
	width: 100px;
	background-color: #c4c8d0;
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	cursor: default;
	flex-shrink: 0;
	transition: background-color 0.2s, transform 0.1s;
}

.btn-check.active {
	background-color: #7A5DE8;
	cursor: pointer;
}

.btn-check.active:active {
	background-color: #684ac2;
	transform: scale(0.96);
}

/* === 비밀번호 그룹 (눈 아이콘) === */
.password-group {
	position: relative;
}

.password-icon {
	position: absolute;
	right: 15px;
	top: 50%;
	transform: translateY(-50%);
	cursor: pointer;
	opacity: 0.5;
	width: 24px;
	height: 24px;
	display: flex;
	align-items: center;
	justify-content: center;
	transition: opacity 0.2s;
}

.password-icon:hover {
	opacity: 1;
}

.icon-hide {
	display: none;
}

.password-icon.view-password .icon-show {
	display: none;
}

.password-icon.view-password .icon-hide {
	display: block;
}

/* === 약관 동의 === */
.terms-group {
	display: flex;
	align-items: center;
	margin: 25px 0;
	font-size: 14px;
	color: #333;
}

.terms-checkbox {
	width: 18px;
	height: 18px;
	margin-right: 10px;
	accent-color: #7A5DE8;
	cursor: pointer;
}

.terms-link {
	color: #7A5DE8;
	text-decoration: none;
	margin-left: 4px;
}

/* === 가입하기 버튼 === */
.btn-submit {
	width: 100%;
	height: 55px;
	background-color: #7A5DE8;
	color: white;
	font-size: 18px;
	font-weight: 600;
	border: none;
	border-radius: 8px;
	cursor: pointer;
	transition: background-color 0.2s;
}

.btn-submit:hover {
	background-color: #684ac2;
}

/* === 모달 팝업 스타일 === */
.modal-overlay {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.4);
	z-index: 9999;
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
	box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
	overflow: hidden;
	animation: fadeIn 0.3s ease-out;
}

/* [수정됨] CSS 문법 오류 수정 (@와 keyframes 붙임) */
@
keyframes fadeIn {from { opacity:0;
	transform: translateY(-10px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.modal-header {
	background-color: #55359E;
	padding: 12px 15px;
	display: flex;
	justify-content: space-between;
	align-items: center;
	color: white;
	font-weight: 600;
	font-size: 16px;
}

.modal-close-btn {
	background: none;
	border: none;
	color: white;
	font-size: 20px;
	cursor: pointer;
	padding: 0;
	line-height: 1;
}

.modal-body {
	padding: 30px 20px;
	text-align: center;
	font-size: 14px;
	color: #333;
	line-height: 1.6;
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
	font-size: 14px;
	cursor: pointer;
	font-weight: 600;
	transition: background-color 0.2s;
}

.modal-confirm-btn:hover {
	background-color: #442a80;
}

/* === 성별 라디오 버튼 그룹 (추가된 CSS) === */
.gender-group {
	display: flex; /* 라벨과 버튼을 가로로 정렬 */
	gap: 15px; /* 라디오 버튼 간격 */
	align-items: center;
	padding: 10px 0; /* 상하 여백 조정 */
}

/* 라디오 버튼 자체의 스타일 재정의 */
.gender-group .radio-input {
	width: auto !important; /* form-input의 100% 너비 무력화 */
	height: auto !important; /* form-input의 50px 높이 무력화 */
	margin-right: 5px; /* 라디오 버튼과 텍스트 간격 */
	flex-shrink: 0;
	accent-color: #555; /* 체크 색상 */
}

/* 라디오 버튼 텍스트 (폼 라벨과 구별) */
.gender-group .radio-label {
	font-size: 15px;
	color: #333;
	font-weight: 400;
	margin-right: 10px;
}
</style>
<script type="text/javascript">
	$(function() {

		$("#btnCheck").click(function() {
			findId();
		});

		//이벤트 처리: 아이디 중복확인 팝업 열기
		function findId() {
			// #users_id로 수정됨
			window.open("checkId.jsp?id=" + $("#users_id").val(), "idWin",
					"width=515,height=405,top=" + (window.screenY + 150)
							+ ",left=" + (window.screenX + 200));
		}

		//joinform 유효성 검사(아이디 중복체크, 비밀번호 형태, 비밀번호 확인 일치여부)
		$("#btnJoin").click(function(e) {
			e.preventDefault();

			var isChecked = $("#isIdChecked").val();

			// 이름 유효성 검사
			if ($("#users_name").val().trim() === "") {
				alert("이름을 입력해주세요.");
				$("#users_name").focus();
				return;
			}

			// 성별 유효성 검사
			if ($("input[name='gender']:checked").length === 0) {
				alert("성별을 선택해주세요.");
				$("input[name='gender']:first").focus();
				return;
			}

			// 생년월일 유효성 검사
			if ($("#birth").val().trim() === "") {
				alert("생년월일을 입력해주세요.");
				$("#birth").focus();
				return;
			}

			// 아이디 중복 확인 유효성 검사
			if (isChecked != 'true') { // 'false'가 아닌 'true'여야 통과
				alert("아이디 중복 확인을 완료해 주세요.");
				$("#btnCheck").focus();
				return;
			}

			const usersPass = $("#users_pass").val();
			const checkPass = $("#checkPassword").val();

			// 비밀번호 유효성 검사
			if (!passCondition(usersPass)) {
				alert("비밀번호는 영문 및 숫자 포함 8자리 이상이어야 합니다.");
				$("#users_pass").focus(); // #users_pass로 수정됨
				return;
			}

			// 비밀번호 일치 확인 유효성 검사
			if (!isPasswordMatch(usersPass, checkPass)) {
				alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
				$("#checkPassword").focus(); // 포커스 추가
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
			$("#joinFrm").submit();
		});

		$("#users_id").on("input", function() {
			// 아이디 값이 변경되면 중복 체크 상태를 초기화
			$("#isIdChecked").val('false');
			$("#idCheckMsg").html(''); // 메시지 지우기
			$("#users_id").prop('disabled', false); // ID: #users_id로 수정
			$("#btnCheck").prop('disabled', false); // 버튼 활성화

			// 입력 값이 있을 때만 버튼 활성화 스타일 적용
			if (this.value.trim().length > 0) {
				$("#btnCheck").addClass('active');
			} else {
				$("#btnCheck").removeClass('active');
			}
		});

		$(".password-icon").click(function() {
			// 클릭한 아이콘의 부모(password-group) 안에서 input 요소를 찾음
			const $passwordInput = $(this).siblings(".form-input");
			const $iconContainer = $(this);

			// 현재 input의 type이 password이면 text로, 아니면 password로 변경
			if ($passwordInput.attr("type") === "password") {
				$passwordInput.attr("type", "text");
				$iconContainer.addClass("view-password"); // 아이콘 변경을 위한 클래스 추가
			} else {
				$passwordInput.attr("type", "password");
				$iconContainer.removeClass("view-password");
			}

		});
	});//ready
	//비밀번호 유효성 검사
	function passCondition(password) {
		// 영문, 숫자 포함, 8자리 이상 정규표현식
		var regex = /^(?=.*[a-zA-Z])(?=.*\d).{8,}$/;
		if (password.trim() === "") {
			return false;
		}
		return regex.test(password);
	}

	/* 비밀번호와 비밀번호 확인란이 서로 일치하는지 검사 */
	function isPasswordMatch(password, checkPassword) {
		if (checkPassword.trim() === "") {
			return false; // 확인란이 비어있으면 실패
		}
		if (password !== checkPassword) {
			return false; // 두 값이 다르면 실패
		}
		return true; // 일치함
	}

	/* 휴대폰번호 입력 체크 정규식 */
	function isPhoneNumber(phone) {
		const regex = /^010-\d{4}-\d\d\d\d$/;

		// 입력된 값이 비어있는지 확인 (공백 포함)
		if (phone.trim() === "") {
			return false;
		}
		// 정규표현식 검사
		return regex.test(phone);
	}
</script>

</head>

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

		<div class="signup-wrapper"
			style="margin-bottom: 40px; margin-top: 40px;">
			<h1 class="signup-title">회원가입</h1>

			<form id="joinFrm" name="joinFrm" method="post"
				action="memberJoinFrmProcess.jsp">
				<input type="hidden" name="isIdChecked" id="isIdChecked"
					value="false">
				<div class="form-group">
					<label class="form-label">이름</label> <input type="text"
						class="form-input" id="users_name" name="users_name"
						placeholder="이름 입력" value="">
				</div>

				<div class="form-group">
					<label class="form-label">성별</label>
					<div class="gender-group">
						<input type="radio" class="radio-input" id="gender_male"
							name="gender" value="남자" checked="checked"> <label
							for="gender_male" class="radio-label">남자</label> <input
							type="radio" class="radio-input" id="gender_female" name="gender"
							value="여자"> <label for="gender_female"
							class="radio-label">여자</label>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">생년월일</label> <input type="date"
						class="form-input" name="birth" id="birth"
						placeholder="0000 - 00 - 00" max="9999-12-31" min="1900-01-01"
						value="">
				</div>

				<div class="form-group">
					<label class="form-label">아이디</label>
					<div class="users_id-group">
						<input type="text" class="form-input" id="users_id"
							placeholder="아이디 입력" name="users_id" value=""> <input
							type="button" class="btn-check" id="btnCheck" value="중복 확인" />
					</div>
					<div id="idCheckMsg"
						style="font-size: 13px; color: gray; margin-top: 5px;"></div>
				</div>

				<div class="form-group">
					<label class="form-label">비밀번호</label>
					<div class="password-group">
						<input type="password" name="users_pass" id="users_pass"
							class="form-input" placeholder="영문, 숫자룰 포함한 8글자 이상"
							value="">
						<div class="password-icon">
							<svg class="icon-show" xmlns="http://www.w3.org/2000/svg"
								width="20" height="20" viewBox="0 0 24 24" fill="none"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round">
								<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
								<circle cx="12" cy="12" r="3"></circle></svg>
							<svg class="icon-hide" xmlns="http://www.w3.org/2000/svg"
								width="20" height="20" viewBox="0 0 24 24" fill="none"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round">
								<path
									d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
								<line x1="1" y1="1" x2="23" y2="23"></line></svg>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">비밀번호 확인</label>
					<div class="password-group">
						<input type="password" class="form-input" id="checkPassword"
							name="chkPassword" placeholder="영문, 숫자를 포함한 8글자 이상"
							value="">
						<div class="password-icon">
							<svg class="icon-show" xmlns="http://www.w3.org/2000/svg"
								width="20" height="20" viewBox="0 0 24 24" fill="none"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round">
								<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"></path>
								<circle cx="12" cy="12" r="3"></circle></svg>
							<svg class="icon-hide" xmlns="http://www.w3.org/2000/svg"
								width="20" height="20" viewBox="0 0 24 24" fill="none"
								stroke="currentColor" stroke-width="2" stroke-linecap="round"
								stroke-linejoin="round">
								<path
									d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"></path>
								<line x1="1" y1="1" x2="23" y2="23"></line></svg>
						</div>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">Email</label> <input type="text"
						class="form-input" name="mail" id="mail" placeholder="example"
						style="width: 50%;" value="">@ <select
						name="domain" id="domain" class="form-input" style="width: 45%;">
						<option value="gmail.com">gmail.com</option>
						<option value="naver.com">naver.com</option>
						<option value="daum.net">daum.net</option>
						<option value="hotmail.com">hotmail.com</option>
					</select>
				</div>

				<div class="form-group">
					<label class="form-label">휴대폰 번호</label> <input type="tel"
						name="phone_num" id="phone_num" class="form-input"
						placeholder="010-1234-5678" value="">
				</div>

				<div class="terms-group">
					<input type="checkbox" class="terms-checkbox" id="terms" checked>
					<label for="terms">By signing up, I agree with the <a
						href="#" class="terms-link">Privacy Policy</a></label>
				</div>
				<input type="button" value="회원가입" class="btn-submit" id="btnJoin" />
			</form>
		</div>

		<div class="quick-area">
			<a href="#" class="btn-go-top" title="top">top</a>
		</div>

		<footer id="footer">
			<jsp:include page="../../fragments/footer.jsp"></jsp:include>
		</footer>
	</div>