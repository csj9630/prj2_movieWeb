<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>회원정보 인증 - 2GV</title>
    <jsp:include page="/fragments/style_css.jsp" />

    <jsp:include page="mypage_withdraw1_style.jsp" />
    <script type="text/javascript">
      // 초기화
      window.onload = function() {
        const passInput = document.querySelector('input[name="pass"]');
        if(passInput) {
            passInput.addEventListener("keypress", function(e) {
                if(e.key === 'Enter') {
                    e.preventDefault(); 
                    checkAuth();
                }
            });
        }
      };

      function checkAuth() {
            const pass = document.querySelector('input[name="pass"]').value;
            const messageBox = document.getElementById("auth-msg");
            const btnConfirm = document.getElementById("btn-confirm");

            if(!pass) {
                alert("비밀번호를 입력해주세요.");
                return;
            }
            
            // AJAX 요청
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "mypage_withdraw1_process.jsp", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onreadystatechange = function() {
                if(xhr.readyState === 4 && xhr.status === 200) {
                    const response = xhr.responseText.trim();
                    if(response === "success") {
                        messageBox.style.display = "block";
                        messageBox.style.color = "blue";
                        messageBox.innerText = "인증이 되었습니다.";
                        // 확인 버튼 활성화 (혹은 클릭 가능 상태로 플래그 설정)
                        btnConfirm.disabled = false;
                        btnConfirm.classList.add("active");
                    } else {
                        messageBox.style.display = "block";
                        messageBox.style.color = "red";
                        messageBox.innerText = "비밀번호가 일치하지 않습니다.";
                        btnConfirm.disabled = true;
                        btnConfirm.classList.remove("active");
                    }
                }
            };
            xhr.send("mode=ajax&pass=" + encodeURIComponent(pass));
      }

      function goNext() {
          const btnConfirm = document.getElementById("btn-confirm");
          if(btnConfirm.disabled) {
              alert("먼저 비밀번호 인증을 완료해주세요.");
              return;
          }
          location.href = "mypage_withdraw2.jsp";
      }
    </script>
    <style>
        #auth-msg {
            display: none;
            margin-top: 10px;
            font-size: 14px;
            font-weight: bold;
        }
    </style>
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
          <li>
            <a href="index.html" title="홈으로 이동">
              <i class="fa-solid fa-house"></i>
            </a>
            <span class="breadcrumb-separator">></span>
          </li>
          <li>
            <a href="#">나의 2GV</a>
            <span class="breadcrumb-separator">></span>
          </li>
          <li>
            <span class="current">회원정보</span>
          </li>
        </ol>
      </div>
    </nav>

    <!-- 메인 컨텐츠 -->
    <div class="container">
      <div class="page-wrap">
        <!-- 사이드바 -->
        <% request.setAttribute("activeMenu", "profile"); %>
        <%@ include file="../../fragments/sideFrame.jsp" %>

        <!-- 메인 컨텐츠 -->
        <main class="main-content">
          <div class="page-title">회원정보</div>

          <div class="auth-box">
            <p class="auth-message">
              회원님의 개인정보 보호를 위해 비밀번호를 입력해주세요.
            </p>

            <div class="auth-form">
              <span class="auth-label">비밀번호</span>
              <input type="password" name="pass" class="auth-input" placeholder="비밀번호" />
              <button type="button" class="btn-auth-check" onclick="checkAuth()">인증</button>
            </div>
            
            <div id="auth-msg"></div>

            <div class="btn-group" style="margin-top: 20px;">
              <!-- 취소 버튼 제거됨 -->
              <button type="button" class="btn-confirm" id="btn-confirm" onclick="goNext()" disabled>확인</button>
            </div>
          </div>
        </main>
      </div>
    </div>

    <!-- 푸터 -->
    <div id="footer"><%@ include file="../../fragments/footer.jsp" %></div>
  </body>
</html>
