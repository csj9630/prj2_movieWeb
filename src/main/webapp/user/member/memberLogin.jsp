<%@page import="SiteProperty.SitePropertyVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
<title>로그인</title>
<link rel="shortcut icon"
	href="${commonURL}/resources/images/favicon.ico">
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
    /* === [공통 레이아웃] === */
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

    .title { text-align: center; font-size: 24px; font-weight: 700; color: #333; margin-bottom: 30px; }

    .tab-container { display: flex; margin-bottom: 30px; }
    .tab-item { flex: 1; text-align: center; padding: 12px 0; font-size: 15px; text-decoration: none; color: #888; border-bottom: 2px solid #ddd; cursor: default; }
    .tab-item.active { color: #7A5DE8; border-bottom: 2px solid #7A5DE8; font-weight: 600; }

    .form-group { margin-bottom: 15px; }
    
    .form-input {
        width: 100%; height: 50px; padding: 0 15px; font-size: 15px;
        border: none; background-color: #F4F5F7; border-radius: 6px;
        box-sizing: border-box; color: #333; outline: none; transition: box-shadow 0.2s;
    }
    .form-input:focus { box-shadow: 0 0 0 2px #7A5DE8; }

    .btn-submit {
        width: 100%; height: 55px; background-color: #7A5DE8; color: white;
        font-size: 18px; font-weight: 600; border: none; border-radius: 8px;
        cursor: pointer; margin-top: 10px; transition: background-color 0.2s;
    }
    .btn-submit:hover { background-color: #684ac2; }

    .link-container { margin-top: 25px; text-align: center; font-size: 14px; color: #666; }
    .link-container a { text-decoration: none; color: #666; margin: 0 10px; transition: color 0.2s; }
    .link-container a:hover { color: #7A5DE8; font-weight: 600; }
    .divider { color: #ddd; font-size: 12px; }

    /* === 모달(팝업) 스타일 === */
    .modal-overlay { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); z-index: 999; justify-content: center; align-items: center; }
    .modal-overlay.show { display: flex; }
    .modal-window { background: white; width: 320px; border-radius: 4px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.2); animation: fadeIn 0.3s ease-out; }
    
    @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }

    .modal-header { background-color: #55359E; color: white; padding: 12px 15px; display: flex; justify-content: space-between; align-items: center; font-weight: 600; }
    .modal-close-btn { background: none; border: none; color: white; font-size: 20px; cursor: pointer; padding: 0; line-height: 1; }
    .modal-body { padding: 30px 20px; text-align: center; font-size: 14px; line-height: 1.6; color: #333; }
    .modal-footer { padding-bottom: 20px; text-align: center; }
    .modal-confirm-btn { background-color: #55359E; color: white; border: none; padding: 8px 25px; border-radius: 4px; cursor: pointer; font-weight: 600; }
</style>
<script type="text/javascript">
$(function() {
	
	/* /* modal창 닫기 */
	$("#modalClose").click(function() {
		$("#loginModal").removeClass("show");
	});//click

	/* modal창 닫기 */
	$("#modalConfirm").click(function() {
		$("#loginModal").removeClass("show");
	})//click */
	
	
	$("#btnLogin").click(function(){
			if($("#users_id").val() == ""){
				alert("아이디는 필수 입력!");
				return;
			}//end if
			if($("#users_pass").val() == ""){
				alert("비밀번호는 필수 입력!");
				return;
			}//end if
			resultLogin();
			/* $("#loginForm").submit(); */
			/*  $("#loginModal").addClass("show"); // 모달 표시 (현재 페이지 유지) */
		});
//비밀번호 입력창에서 엔터 키 이벤트 추가
$("#users_pass").keydown(function(e) {
    if (e.keyCode == 13) {
        $("#btnLogin").click();
    }
});
});//ready


 //로그인 버튼 클릭시 ajax로 값 비교 후 결과 알려주기
/* function resultLogin() {
    var param = {
        users_id: $("#users_id").val(),
        users_pass: $("#users_pass").val()
    };

    $.ajax({
        url: 'memberLoginProcess.jsp',
        type: 'POST',
        data: param,
        dataType: "JSON",
        success: function(response) {
            $("#loginModal").addClass("show");
            $("#textModal").text(response.msg);

            // 기존 이벤트를 제거하여 중복 실행 방지
            $("#modalConfirm, #modalClose").off('click');

            if (response.status === 'success') {
                $("#modalConfirm, #modalClose").on('click', function() {
                    $("#loginModal").removeClass("show");
                    // 에러 원인 수정: 함수형태()가 아닌 대입형태= 사용
                    window.location.href = "${commonURL}/user/main/index.jsp";
                });
            } else {
                // 실패 시 모달만 닫도록 설정
                $("#modalConfirm, #modalClose").on('click', function() {
                    $("#loginModal").removeClass("show");
                });
            }
        }, // success 끝
        error: function(xhr) {
            alert("비정상적인 접근이 감지되었습니다.(데이터베이스 등의 문제)");
            console.log(xhr.status);
        }
    }); // ajax 끝
} */

function resultLogin() {
    var param = {
        users_id: $("#users_id").val(),
        users_pass: $("#users_pass").val()
    };

    $.ajax({
        url: 'memberLoginProcess.jsp',
        type: 'POST',
        data: param,
        dataType: "JSON",
        success: function(response) {
            $("#loginModal").addClass("show");
            $("#textModal").text(response.msg);

            $("#modalConfirm, #modalClose").off('click');

            if (response.status === 'success') {
                $("#modalConfirm, #modalClose").on('click', function() {
                    $("#loginModal").removeClass("show");

                    var prevPage = document.referrer;

                    // 현재 페이지 파일명이 memberLogin.jsp인지 확인 필요
                    if (prevPage && prevPage.indexOf("memberLogin.jsp") === -1) {
                        location.href = prevPage;
                    } else {
                        location.href = "${commonURL}/user/main/index.jsp";
                    }
                });
            } else {
                $("#modalConfirm, #modalClose").on('click', function() {
                    $("#loginModal").removeClass("show");
                });
            }
        },
        error: function(xhr) {
            alert("비정상적인 접근이 감지되었습니다.");
        }
    }); // 이 부분이 빠져있었습니다.
} // 이 부분도 빠져있었습니다
</script>
</head>

<body>
    <div class="body-wrap">
        <header id="header">
            <jsp:include page="../../fragments/header.jsp"/>
        </header>

        <div class="page-util">
            <div class="inner-wrap">
                <div class="location">
                    <span>Home</span>
                    <a href="#" title="회원">회원</a>
                    <a href="#" title="로그인">로그인</a>
                </div>
            </div>
        </div>

        <div class="main-container-white">
            <div class="wrapper">
                <h1 class="title">로그인</h1>


                <form id="loginForm" name="loginForm" method="post" action="memberLoginProcess.jsp">
                    <div class="form-group">
                        <input type="text" name="users_id" id="users_id" class="form-input" placeholder="아이디" title="아이디를 입력하세요" value="">
                    </div>

                    <div class="form-group">
                        <input type="password" name="users_pass" id="users_pass" class="form-input" placeholder="비밀번호" title="비밀번호를 입력하세요" value="">
                    </div>
					<input type="button" id="btnLogin" class="btn-submit" value="로그인">
                    <!-- <button type="button" id="btnLogin" class="btn-submit">로그인</button> -->

                    <div class="link-container">
                        <a href="memberFindId.jsp">ID 찾기</a>
                        <span class="divider">|</span>
                        <a href="memberFindPw.jsp">PW 변경</a>
                        <span class="divider">|</span>
                        <a href="memberJoinFrm.jsp">회원가입</a>
                    </div>
                </form>
            </div>
        </div>

        <div class="modal-overlay" id="loginModal">
            <div class="modal-window">
                <div class="modal-header">
                    <span>알림</span>
                    <button class="modal-close-btn" id="modalClose">✕</button>
                </div>
                <div class="modal-body" id="textModal">
                    로그인 되었습니다.
                </div>
                <div class="modal-footer">
                    <button class="modal-confirm-btn" id="modalConfirm">확인</button>
                </div>
            </div>
        </div>

        <footer id="footer">
            <jsp:include page="../../fragments/footer.jsp"></jsp:include>
        </footer>
    </div>
    
    <form id="mainForm"></form>

</body>
</html>