<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <%@ include file="../../fragments/siteProperty.jsp"%>
 <%@
    taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> <%-- <%@ include
    file="../../fragments/loginChk2.jsp"%> --%>
    <!DOCTYPE html>
    <html lang="ko">
      <head>
<jsp:include page="../../fragments/loginChk.jsp" />
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>회원탈퇴 - 2GV</title>
        <jsp:include page="/fragments/style_css.jsp" />
    
        <jsp:include page="mypage_withdraw4_style.jsp" />
    <script type="text/javascript">
      window.onload = function() {
        const withdrawBtn = document.getElementById("btn-withdraw");
        const cancelBtn = document.querySelector(".btn-cancel");

        // 탈퇴 버튼 클릭 시
        if(withdrawBtn) {
            withdrawBtn.addEventListener("click", function () {
              const passInput = document.forms["withdrawForm"]["pass"];
              if (!passInput.value) {
                alert("비밀번호를 입력해주세요.");
                passInput.focus();
                return;
              }

              if(confirm("정말로 탈퇴하시겠습니까? 탈퇴 시 30일간 재가입이 불가능하며 모든 정보가 삭제됩니다.")) {
                  document.withdrawForm.submit();
              }
            });
        }

        // 취소 버튼 클릭 시
        if(cancelBtn) {
            cancelBtn.addEventListener("click", function () {
                history.back();
            });
        }
      };
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
              <li>
                <a href="${commonURL}/user/main/index.jsp" title="홈으로 이동">
                  <i class="fa-solid fa-house"></i>
                </a>
                <span class="breadcrumb-separator">></span>
              </li>
              <li>
                <a href="#">나의 2GV</a>
                <span class="breadcrumb-separator">></span>
              </li>
              <li>
                <span class="current">회원탈퇴</span>
              </li>
            </ol>
          </div>
        </nav>
        <!-- 메인 컨텐츠 -->
        <div class="container">
          <div class="page-wrap">
            <!-- 사이드바 -->
            <% request.setAttribute("activeMenu", "profile"); %> <%@ include
            file="../../fragments/sideFrame.jsp" %>
    
            <!-- 메인 컨텐츠 -->
            <main class="main-content">
              <div class="page-title">회원탈퇴</div>
    
              <div class="withdraw-guide">
                <p class="guide-intro">
                  [주의] 2GV 회원탈퇴를 신청하기 전에 안내 사항을 꼭
                  확인해주세요.
                </p>
    
                <div class="guide-section">
                  <h4>1. 30일간 회원 재가입이 불가능합니다.</h4>
                  <ul>
                    <li>회원 탈퇴 후, 30일 경과 후 재가입할 수 있습니다.</li>
                  </ul>
                </div>
    
                <div class="guide-section">
                  <h4>2. 다음에 경우에 회원 탈퇴가 제한됩니다.</h4>
                  <ul>
                    <li>영화예매 내역이 있는 경우</li>
                    <li>모바일오더 주문건이 있는 경우</li>
                    <li>기명식 기프트카드 잔액이 있을 경우</li>
                    <li>기명식 기프트카드가 카드정지 상태인 경우</li>
                    <li>기명식 기프트카드 환불신청이 진행중인 경우</li>
                  </ul>
                </div>
    
                <div class="guide-section">
                  <h4>3. 탈퇴 후 삭제 내역</h4>
                  <p class="sub-text">
                    (회원 탈퇴하시면 회원정보와 개인 보유 포인트 등 정보가 삭제되며
                    데이터는 복구되지 않습니다.)
                  </p>
                  <ul>
                    <li>2GV 멤버십 포인트 및 적립/차감 내역</li>
                    <li>관람권 및 쿠폰</li>
                    <li>영화 관람 내역</li>
                    <li>간편 로그인 연동 정보</li>
                  </ul>
                </div>
    
                <div class="confirm-section">
                  <h4>
                    4. 회원님의 비밀번호를 입력하시고 [탈퇴] 버튼을 클릭해주세요.
                  </h4>
                  <div class="password-input-box">
                    <form name="withdrawForm" action="mypage_withdraw4_process.jsp" method="post">
                    <label for="user-pw">비밀번호</label>
                    <input type="password" name="pass" id="user-pw" />
                    </form>
                  </div>
                </div>
    
                <div class="btn-group">
                  <button class="btn-cancel">취소</button>
                  <button class="btn-withdraw" id="btn-withdraw">탈퇴</button>
                </div>
              </div>
            </main>
          </div>
        </div>
    
        <!-- 탈퇴 완료 모달 -->
        <div class="modal-overlay" id="withdraw-modal">
          <div class="modal-container">
            <div class="modal-header">
              <span>알림</span>
              <i class="fa-solid fa-xmark close-modal"></i>
            </div>
            <div class="modal-body">
              <p>회원 탈퇴가 완료되었습니다.</p>
              <button class="btn-confirm close-modal">확인</button>
            </div>
          </div>
        </div>
    
    <!-- Script moved to head -->
        <!-- 푸터 -->
        <div id="footer"><jsp:include page="../../fragments/footer.jsp"/></div>
      </body>
    </html>
