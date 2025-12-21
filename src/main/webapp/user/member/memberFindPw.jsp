<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=yes">
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>비밀번호 변경</title>
<link rel="stylesheet" href="${commonURL}/resources/css/megabox.min.css"
	media="all">
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
/* === [레이아웃] === */
body {
	margin: 0;
	background-color: #f9f9f9;
	display: flex;
	flex-direction: column;
	min-height: 100vh;
}

.main-container-white {
	background-color: white;
	width: 100%;
	flex: 1;
	padding-top: 60px;
	padding-bottom: 60px;
	display: flex;
	justify-content: center;
	align-items: flex-start;
}

.wrapper {
	font-family: '맑은 고딕', 'Pretendard', sans-serif;
	background-color: white;
	width: 100%;
	max-width: 480px;
	margin: 0;
	padding: 40px 30px;
	box-sizing: border-box;
	border: 1px solid #eaeaea;
	border-radius: 8px;
}

/* === 내부 요소 스타일 === */
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

.input-with-btn {
	display: flex;
	gap: 8px;
}

.input-with-btn .form-input {
	flex: 1;
}

/* 버튼 스타일 */
.btn-small {
	width: 80px;
	height: 50px;
	border: none;
	border-radius: 6px;
	font-size: 13px;
	font-weight: 600;
	color: white;
	cursor: default;
	transition: background-color 0.2s;
}

.btn-gray {
	background-color: #9aa0a6;
} /* 이메일 인증 기본색 */
.btn-dark {
	background-color: #6c757d;
} /* 인증확인 기본색 */

/* [활성화] 보라색 스타일 */
.btn-small.active {
	background-color: #7A5DE8;
	cursor: pointer;
}

.auth-code-wrapper {
	display: flex;
	align-items: center;
	gap: 8px;
}

.auth-box-container {
	display: flex;
	gap: 4px;
	flex: 1;
	justify-content: space-between;
}

.auth-box {
	width: 100%;
	height: 50px;
	text-align: center;
	font-size: 18px;
	border: 1px solid #ddd;
	border-radius: 6px;
	background-color: #fff;
	outline: none;
	padding: 0;
}

.auth-box:focus {
	border-color: #7A5DE8;
	box-shadow: 0 0 0 1px #7A5DE8;
}

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

/* 모달 */
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
}

.modal-close-btn {
	background: none;
	border: none;
	color: white;
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
}
</style>

<script type="text/javascript">
//인증확인 절차를 통과하였는지 확인할 변수
let isCheckCode = false;
//인증확인을 완료하였을 경우, 인증번호 입력을 안 해도 괜찮게 할 변수.
	$(function() {
		
		/* modal창 닫기 */
		$("#btnClosePw").click(function() {
			$("#resultModal").removeClass("show");
		});//click

		/* modal창 닫기 */
		$("#closeModal").click(function() {
			$("#resultModal").removeClass("show");
		})//click

		
		 //비밀번호 변경 버튼 클릭 후 유효성 검사 및 데이터 back-end로 전송
		$("#btnChangePw").click(function(e) {
			e.preventDefault();
			validUsers_id
			// 아이디 유효성 검사
			if(!validUsers_id()) {
				return;
			};
			
			// 이름 유효성 검사
			if(!validUsers_name()) {
				return;
			};

			// 이메일 유효성 검사
			if(!validMail()) {
				return;
			};

			// 도메인 유효성 검사
			if(!validDomain()) {
				return;
			};
			// 인증번호 유효성 검사
			if(!validEmailCode()) {
				return;
			};
			
			
			// 비밀번호 유효성 검사
			if(!validUsers_pass()) {
				return;
			};
			const usersPass = $("#users_pass").val();
			const checkPass = $("#checkPassword").val();
			
			 // 비밀번호 유효성 검사
		    if(!passCondition(usersPass)) {
		    	alert("새 비밀번호는 영문 및 숫자 포함 8자리 이상이어야 합니다.");
		    	$("#users_pass").focus(); 
		    	return;
		    }//end if
			
			// 비밀번호 확인 유효성 검사
			if(!validCheckPassword()) {
				return;
			};
			
		    // 비밀번호 일치 확인 유효성 검사
		    if(!isPasswordMatch(usersPass, checkPass)){
		    	alert("비밀번호가 일치하지 않습니다. 다시 확인해주세요.");
		    	$("#checkPassword").focus(); // 포커스 추가
		    	return;
		    }//end if
		    
		    
			// 모든 유효성 검사 통과 시 ajax를 통해 DB와 통신 후 결과 전달
			if(isCheckCode) {
			resultFindPw();
			} else{
				alert("인증번호 확인 절차를 진행해주십시오.");
			}
		});

		
		//인증확인 버튼을 누르면 ajax를 사용하여 페이지를 새로고침 하지 않고 세션의 값을 받아와서 입력된 값과 비교.
		$('#authConfirmBtn').click(function() {
			//인증확인 버튼 눌렸을 시 우선 유효성 검사 진행
			if(!validEmailCode() && isCheckCode == false) {
				return;
			};
			
			//사용자가 입력한 코드 값
	        var inputCode = $("#checkCode1").val() + $("#checkCode2").val() + $("#checkCode3").val() + $("#checkCode4").val() + $("#checkCode5").val();
			
	        $.ajax({
	            url: 'checkPwCode.jsp', // AJAX 요청 대상 JSP 파일
	            type: 'POST',
	            dataType: 'json', // 서버의 응답을 JSON 형식으로 예상
	            data: {
	                code: inputCode // 사용자 입력 코드를 json 형태로 서버로 전송
	            },
	            success: function(response) {
	                if (response.status === 'success') {
	                	//인증 여부 확인용 변수
	                	isCheckCode = true;
	                    alert(response.message);
	                    // 성공 시 다음 단계 (비밀번호 변경 폼 노출 등) 로직 처리
	                } else if(response.status === 'fail'){
	                	//코드가 일치하지 않을 경우
	                	alert(response.message);
	                } else if(response.status === 'error'){
	                	//인증 완료시 세션 값이 삭제되므로, 이미 인증을 완료한 상태라면 alert(response.message);대신 완료 했다는 창을 대신 띄워짐.
	                	if(isCheckCode == true) {
	                	alert("이미 인증을 완료하셨습니다.");	
	                	return;
	                	}//end if
						//에러(세션 만료 등)
	                	alert(response.message);
	                }
	            },
	            error: function() {
	                // 통신 오류 발생 시 처리
	                alert('서버 통신에 실패했습니다.');
	            }
	        });
	    });
		
		
		
		/* mmmmmmmmmmmmmmmmmmmmmmm */
		
		//이메일 요청 버튼 활성화 JS
		function updateEmailAuthBtnState() {
            // 변수 대신 직접 선택자 사용
            const mailVal = $('#mail').val().trim();
            const domainVal = $('#domain').val().trim();
            const authReqBtn = $('#authReqBtn');

            if (mailVal.length > 0 && domainVal.length > 0) {
                authReqBtn.addClass('active').removeClass('btn-gray');
            } else {
                authReqBtn.removeClass('active').addClass('btn-gray');
            }
        }
        
        // 이메일 입력 및 도메인 선택 변경 시 버튼 상태 업데이트
        $('#mail').on('input', updateEmailAuthBtnState);
        $('#domain').on('change', updateEmailAuthBtnState);
     
      //버튼 활성화 상태 관련 js
        $('#authReqBtn').on('click', function() {
            const authReqBtn = $(this);
            // 버튼이 비활성화 상태면 요청 방지
            if (!authReqBtn.hasClass('active')) return; 

            const mailVal = $('#mail').val();
            const domainVal = $('#domain').val();
            
            if(!mailVal || !domainVal) {
                alert("이메일을 입력하세요.");
                return;
            }

            const emailVal = mailVal + '@' + domainVal;

          //이메일 인증 번호 날릴 때 사용할 ajax.
            $.ajax({
                url: '/prj2_movieWeb/quickMail', 
                type: 'POST',
                data: {
                    email: emailVal 
                },
                dataType: 'text', 
                
                success: function(result) {
                    const response = result.trim();
                    
                    if (response === "OK") { 
                        alert("인증 메일이 발송되었습니다! 메일함을 확인하세요.");
                    } else { 
                        alert("인증 메일 발송에 실패했습니다. 입력 정보를 확인하거나 잠시 후 다시 시도해 주세요. (코드: " + response + ")");
                    }
                },
                error: function() {
                    console.error("AJAX Error: 서버 통신 실패");
                    alert('네트워크 연결 실패 또는 서버와의 통신에 오류가 발생했습니다.');
                }
            });
        });
        // ==========================================================
        
        // 2. 비밀번호 눈 토글 
        $('.password-icon').on('click', function() {
            const input = $(this).prev('input'); 
            if (input.attr('type') === 'password') { 
                input.attr('type', 'text'); 
                $(this).addClass('view-password'); 
            } else { 
                input.attr('type', 'password'); 
                $(this).removeClass('view-password'); 
            }
        });

        // 4. [인증번호] 숫자만 입력 & 자동 이동 & 버튼 활성화 
        
        // 인증번호 버튼 상태 업데이트 함수
        function updateAuthBtnState() {
            let allFilled = true;
            const codeBoxes = $('.auth-box');
            const authConfirmBtn = $('#authConfirmBtn');
            
            codeBoxes.each(function() { 
                if($(this).val().trim().length !== 1) allFilled = false; 
            });

            if(allFilled) {
                authConfirmBtn.addClass('active').removeClass('btn-dark');
            } else {
                authConfirmBtn.removeClass('active').addClass('btn-dark');
            }
        }

        const codeBoxes = $('.auth-box'); // codeBoxes 변수는 반복문 밖에 선언하여 재사용
        
        codeBoxes.each(function(index) {
            const box = $(this);
            
            box.on('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');

                if (this.value.length === 1 && index < codeBoxes.length - 1) {
                    codeBoxes.eq(index + 1).focus(); 
                } else if (this.value.length === 1 && index === codeBoxes.length - 1) {
                    box.blur(); 
                }
                
                updateAuthBtnState();
            });
            
            box.on('keyup', function(e) {
                 if ([9, 13, 16, 17, 18, 20, 27, 33, 34, 35, 36, 37, 38, 39, 40, 91, 93].includes(e.keyCode)) {
                    return; 
                }

                if (this.value.length > 1) {
                    this.value = this.value.slice(-1); 
                    if (index < codeBoxes.length - 1) {
                        codeBoxes.eq(index + 1).focus();
                    } else {
                         box.blur(); 
                    }
                }
            });


            box.on('keydown', function(e) {
                if (e.key === 'Backspace') {
                    if (this.value === '' && index > 0) {
                        e.preventDefault(); 
                        codeBoxes.eq(index - 1).focus().val('');
                    }
                    setTimeout(updateAuthBtnState, 10);
                }
            });
        });

	});//ready

	//비밀번호 변경 버튼 클릭시, form 유효성 검사 통과 후, db와 통신하여 입력받은 데이터가 존재하는지 확인 후 결과창 띄워주기.
	function resultFindPw() {
	//form에서 필요한 데이터 받아와서 json 데이터로 저장
	var inputData="users_id="+$("#users_id").val()+"&users_name="+$("#users_name").val()
	+"&email="+($("#mail").val()+"@"+$("#domain").val())+"&users_pass="+$("#users_pass").val();

		$.ajax({
		    url: 'memberFindPwProcess.jsp', 
		    type: 'POST',
		    data: inputData,
		    dataType: "JSON",
		    success: function(response) {
		        if (response.status === 'success') {
		             $("#resultModal").addClass("show"); // 모달 표시 (현재 페이지 유지)
		             $("#sucessModal").text(response.msg);
		             // 모달 닫기 버튼 (#btnClosePw) 클릭 시 로그인 페이지로 이동 처리
		             $("#btnClosePw").off('click').on('click', function() {
		                 $("#resultModal").removeClass("show");
		                 window.location.href = "${commonURL}/user/member/memberLogin.jsp"; // 로그인 페이지 이동
		             });

		        } else if (response.status === 'fail') {
		        	 $("#resultModal").addClass("show"); // 모달 표시 (현재 페이지 유지)
		             $("#sucessModal").text(response.msg);
		        	 /* $("#resultModal").removeClass("show"); */
		        } else {
		        	 $("#resultModal").addClass("show"); // 모달 표시 (현재 페이지 유지)
		             $("#sucessModal").text(response.msg);
		        }
		    },
		    error: function() {
		        alert('서버 통신에 실패했습니다. 네트워크 연결을 확인하세요.');
		    }
		});
	}
	
	
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
	function isPasswordMatch(password, checkPassword){
	    if( checkPassword.trim() === "" ) {
	        return false; // 확인란이 비어있으면 실패
	    }
	    if( password !== checkPassword ) {
	        return false; // 두 값이 다르면 실패
	    }
	    return true; // 일치함
	}//end isPasswordMatch
	
	//인증확인 버튼 유효성 검사
	function validEmailCode() {
		if ($("#checkCode1").val().trim() === "" || $("#checkCode2").val().trim() === "" || $("#checkCode3").val().trim() === "" || $("#checkCode4").val().trim() === "" ||
				$("#checkCode5").val().trim() === "") {
			alert("인증번호를 입력해주세요."); 
			$("#checkCode1").focus(); // 포커스 추가
			return false;
		}//end if
		return true;
	}//validEmailCode
	
	function validUsers_id() {
		if ($("#users_id").val().trim() === "") {
			alert("아이디를 입력해주세요.");
			/* $("#resultModal").addClass("show"); // 모달 표시 (현재 페이지 유지) */
			/* $("#sucessModal").text("아이디를 입력해주세요."); */
			$("#users_id").focus();
			return false;
		}//end if
		return true;
	}//validUsers_id
	
	function validUsers_name() {
		if ($("#users_name").val().trim() === "") {
			alert("이름을 입력해주세요.");
			$("#users_name").focus();
			return false;
		}//end if
		return true;
	}//validUsers_name
	
	function validMail() {
		if ($("#mail").val().trim() === "") {
			alert("메일을 입력해주세요.");
			$("#mail").focus(); // 포커스 추가
			return false;
		}//end if
		return true;
	}//validMail
	
	function validDomain() {
		if ($("#domain").val().trim() === "") {
			alert("도메인을 선택(또는 입력)해주세요."); 
			$("#domain").focus(); // 포커스 추가
			return false;
		}//end if
		return true;
	}//validDomain
	
	function validUsers_pass() {
		if ($("#users_pass").val().trim() === "") {
			alert("새 비밀번호를 입력해주세요."); 
			$("#users_pass").focus(); // 포커스 추가
			return false;
		}//end if
		return true;
	}//validUsers_pass
	
	function validCheckPassword() {
		// 비밀번호 확인 유효성 검사
		if ($("#checkPassword").val().trim() === "") {
			alert("비밀번호 확인을 입력해주세요."); 
			$("#checkPassword").focus(); // 포커스 추가
			return false;
		}//end if
		return true;
	}//validCheckPassword
	
	
</script>
</head>
<body>
	<header id="header"><jsp:include
			page="../../fragments/header.jsp" /></header>

	<div class="page-util">
		<div class="inner-wrap">
			<div class="location">
				<span>Home</span> <a href="${commonURL}/user/member/memberLogin.jsp"
					title="회원">회원</a> <a href="#">비밀번호 변경</a>
			</div>
		</div>
	</div>

	<div class="main-container-white">
		<div class="wrapper">
			<h1 class="title">아이디 / 비밀번호 변경</h1>

			<div class="tab-container">
				<a href="${commonURL}/user/member/memberFindId.jsp" class="tab-item">아이디
					찾기</a> <a href="#" class="tab-item active">비밀번호 변경</a>
			</div>

			<form id="findPwFrm" name="findPwFrm" method="post">
				<div class="form-group">
					<label class="form-label">아이디</label>
					<div class="users_id-group">
						<input type="text" class="form-input" id="users_id"
							placeholder="아이디 입력" name="users_id" value="lee">
					</div>
					<div id="idCheckMsg"
						style="font-size: 13px; color: gray; margin-top: 5px;"></div>
				</div>

				<div class="form-group">
					<label class="form-label">이름</label> <input type="text"
						class="form-input" id="users_name" name="users_name"
						placeholder="이름 입력" value="이정우">
				</div>

				<div class="form-group">
					<label class="form-label">Email</label>
					<div class="input-with-btn">
						<input type="text" class="form-input" name="mail" id="mail"
							placeholder="example" style="width: 50%;" value="1">@ <select
							name="domain" id="domain" class="form-input" style="width: 45%;">
							<option value="gmail.com">gmail.com</option>
							<option value="naver.com">naver.com</option>
							<option value="daum.net">daum.net</option>
							<option value="hotmail.com">hotmail.com</option>
						</select>
						<button type="button" class="btn-small btn-gray" id="authReqBtn">인증요청</button>
					</div>
				</div>
				<div class="form-group">
					<label class="form-label">인증번호</label>
					<div class="auth-code-wrapper">
						<div class="auth-box-container">
							<input type="text" class="auth-box" maxlength="1" id="checkCode1"
								value="1"> <input type="text" class="auth-box"
								maxlength="1" id="checkCode2" value="1"> <input
								type="text" class="auth-box" maxlength="1" id="checkCode3"
								value="1"> <input type="text" class="auth-box"
								maxlength="1" id="checkCode4" value="1"> <input
								type="text" class="auth-box" maxlength="1" id="checkCode5"
								value="1">
						</div>
						<button type="button" class="btn-small btn-dark"
							id="authConfirmBtn">인증확인</button>
					</div>
				</div>

				<div class="form-group">
					<label class="form-label">새 비밀번호</label>
					<div class="password-group">
						<input type="password" name="users_pass" id="users_pass"
							class="form-input" placeholder="영문, 숫자룰 포함한 8글자 이상"
							value="12341234a">
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
							value="12341234a">
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

				<input type="button" class="btn-submit" id="btnChangePw"
					value="비밀번호 변경" />
			</form>
		</div>
	</div>

	<div class="modal-overlay" id="resultModal">
		<div class="modal-window">
			<div class="modal-header">
				<span>알림</span>
				<button class="modal-close-btn" id="closeModal">✕</button>
			</div>
			<div class="modal-body" id="sucessModal">
				비밀번호 변경이 성공적으로 완료되었습니다.<br>로그인 화면으로 이동합니다.
			</div>
			<div class="modal-footer">
				<button class="modal-confirm-btn" id="btnClosePw">확인</button>
			</div>
		</div>
	</div>


	<footer id="footer"><jsp:include
			page="../../fragments/footer.jsp" /></footer>

	<!-- <script>
       

        // 2. 비밀번호 눈 토글 (유지)
        document.querySelectorAll('.password-icon').forEach(icon => {
            icon.addEventListener('click', function() {
                const input = this.previousElementSibling;
                if (input.type === 'password') { input.type = 'text'; this.classList.add('view-password'); }
                else { input.type = 'password'; this.classList.remove('view-password'); }
            });
        });

        // 3. [이메일] 입력 시 버튼 활성화 (수정된 부분)
        const mailInput = document.getElementById('mail');
        const domainSelect = document.getElementById('domain');
        const authReqBtn = document.getElementById('authReqBtn');
        
        // 이메일 입력 및 도메인 선택 변경 시 버튼 상태 업데이트 함수
        function updateEmailAuthBtnState() {
            // mail 입력 필드와 domain 선택이 모두 채워져야 활성화
            // domainSelect.value는 기본적으로 옵션의 value를 가지므로, trim()만 체크
            if (mailInput.value.trim().length > 0 && domainSelect.value.trim().length > 0) {
                authReqBtn.classList.add('active');
                authReqBtn.classList.remove('btn-gray');
            } else {
                authReqBtn.classList.remove('active');
                authReqBtn.classList.add('btn-gray');
            }
        }
        
        // 이벤트 리스너 연결
        mailInput.addEventListener('input', updateEmailAuthBtnState);
        domainSelect.addEventListener('change', updateEmailAuthBtnState);
     
     // -----------------------------------------------------------
        // [인증 요청] 버튼 클릭 시 자바 서블릿 실행 (AJAX)
        // -----------------------------------------------------------
        authReqBtn.addEventListener('click', function() {
            // 버튼이 비활성화(회색) 상태면 클릭 안 되게 막기
            //if (this.classList.contains('btn-gray')) return;

            const mailVal = mailInput.value;
            const domainVal = domainSelect.value;
            
            if(!mailVal || !domainVal) {
                alert("이메일을 입력하세요.");
                return;
            }

            const emailVal = mailVal + '@' + domainVal;

            // 2. 서블릿(/quickMail) 찌르기
            fetch('/second_project_movie_reservation/quickMail', { 
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'email=' + encodeURIComponent(emailVal)
            })
            .then(res => res.text()) // ⭐️ 응답을 텍스트(String)로 읽습니다.
            .then(result => {
                const response = result.trim();
                
                if (response === "OK") { // ⭐️ 성공 응답 처리
                	receivedAuthCode = response;
                    alert("인증 메일이 발송되었습니다! 메일함을 확인하세요.");
                } else { // ⭐️ 실패 응답 처리
                    // 서버에서 "FAIL" 또는 "SERVER_ERROR" 응답이 왔을 경우
                    alert("인증 메일 발송에 실패했습니다. 입력 정보를 확인하거나 잠시 후 다시 시도해 주세요. (코드: " + response + ")");
                }
            })
            .catch(err => {
                console.error("Fetch Error:", err);
                alert("네트워크 연결 실패 또는 서버와의 통신에 오류가 발생했습니다.");
            });
        });
        // -----------------------------------------------------------
     
        // 4. [인증번호] 숫자만 입력 & 자동 이동 & 버튼 활성화 (유지)
        const codeBoxes = document.querySelectorAll('.auth-box');
        const authConfirmBtn = document.getElementById('authConfirmBtn');

        // 인증번호 버튼 상태 업데이트 함수
        function updateAuthBtnState() {
            let allFilled = true;
            codeBoxes.forEach(box => {
                // 1글자로 채워졌는지 확인 (공백 아님)
                if(box.value.trim().length !== 1) allFilled = false; 
            });

            if(allFilled) {
                authConfirmBtn.classList.add('active'); 
                authConfirmBtn.classList.remove('btn-dark'); 
            } else {
                authConfirmBtn.classList.remove('active'); 
                authConfirmBtn.classList.add('btn-dark'); 
            }
        }

        codeBoxes.forEach((box, index) => {
            box.addEventListener('input', (e) => {
                box.value = box.value.replace(/[^0-9]/g, '');

                if (box.value.length === 1 && index < codeBoxes.length - 1) {
                    codeBoxes[index + 1].focus();
                } else if (box.value.length === 1 && index === codeBoxes.length - 1) {
                    box.blur(); 
                }
                
                updateAuthBtnState();
            });
            
            box.addEventListener('keyup', (e) => {
                 if ([9, 13, 16, 17, 18, 20, 27, 33, 34, 35, 36, 37, 38, 39, 40, 91, 93].includes(e.keyCode)) {
                    return; 
                }

                if (box.value.length > 1) {
                    box.value = box.value.slice(-1); 
                    if (index < codeBoxes.length - 1) {
                        codeBoxes[index + 1].focus();
                    } else {
                         box.blur(); 
                    }
                }
            });


            box.addEventListener('keydown', (e) => {
                if (e.key === 'Backspace') {
                    if (box.value === '' && index > 0) {
                        e.preventDefault(); 
                        codeBoxes[index - 1].focus();
                        codeBoxes[index - 1].value = ''; 
                    }
                    setTimeout(updateAuthBtnState, 10);
                }
            });
        });
    </script> -->
</body>
</html>