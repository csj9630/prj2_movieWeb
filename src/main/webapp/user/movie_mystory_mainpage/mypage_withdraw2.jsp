<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="MovieWithdraw.MovieWithdrawDAO" %>
<%@ page import="MovieWithdraw.MovieWithdrawDTO" %>
<%
    // 로그인 체크 및 데이터 조회
    String userId = (String)session.getAttribute("userId");
    if(userId == null) userId = "test1"; // 테스트용

    MovieWithdrawDAO dao = MovieWithdrawDAO.getInstance();
    MovieWithdrawDTO dto = dao.selectUser(userId);

    String email = "";
    if(dto != null && dto.getEmail() != null) email = dto.getEmail();
    String[] emailParts = email.split("@");
    String email1 = (emailParts.length > 0) ? emailParts[0] : "";
    String email2 = (emailParts.length > 1) ? emailParts[1] : "";

    String phone = "";
    if(dto != null && dto.getPhone_num() != null) phone = dto.getPhone_num();
    String[] phoneParts = phone.split("-");
    String phone1 = (phoneParts.length > 0) ? phoneParts[0] : "";
    String phone2 = (phoneParts.length > 1) ? phoneParts[1] : "";
    String phone3 = (phoneParts.length > 2) ? phoneParts[2] : "";
%>
<!DOCTYPE html>	
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>개인정보 수정 - 2GV</title>
    <jsp:include page="/fragments/style_css.jsp" />
    <!-- jQuery 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <!-- Firebase SDK (Phone Auth용) -->
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js"></script>
    <script src="https://www.gstatic.com/firebasejs/9.22.0/firebase-auth-compat.js"></script>

    <jsp:include page="mypage_withdraw2_style.jsp" />
    
    <!-- 이메일 인증 모달 및 버튼 스타일 -->
    <style>
      /* 인증 버튼 스타일 */
      .btn-auth {
        background-color: #7A5DE8;
        color: white;
        border: none;
        padding: 8px 12px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 13px;
        margin-left: 10px;
      }
      .btn-auth:hover {
        background-color: #6347c7;
      }
      .btn-auth:disabled {
        background-color: #ccc;
        cursor: not-allowed;
      }
      
      /* 인증 완료 표시 */
      .auth-status {
        margin-left: 10px;
        font-size: 13px;
        font-weight: bold;
      }
      .auth-status.success {
        color: #28a745;
      }
      .auth-status.pending {
        color: #dc3545;
      }
      
      /* 인증 모달 스타일 */
      .auth-modal-overlay {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        justify-content: center;
        align-items: center;
      }
      .auth-modal-overlay.show {
        display: flex;
      }
      .auth-modal-box {
        background: white;
        width: 350px;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 20px rgba(0,0,0,0.3);
      }
      .auth-modal-header {
        background-color: #3e2675;
        color: white;
        padding: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }
      .auth-modal-header span {
        font-weight: bold;
      }
      .auth-modal-close {
        background: none;
        border: none;
        color: white;
        font-size: 18px;
        cursor: pointer;
      }
      .auth-modal-body {
        padding: 25px;
        text-align: center;
      }
      .auth-modal-body p {
        margin-bottom: 20px;
        color: #555;
      }
      
      /* 인증코드 입력 박스 */
      .auth-code-container {
        display: flex;
        gap: 8px;
        justify-content: center;
        margin-bottom: 20px;
      }
      .auth-code-box {
        width: 45px;
        height: 50px;
        text-align: center;
        font-size: 20px;
        font-weight: bold;
        border: 2px solid #ddd;
        border-radius: 6px;
        outline: none;
      }
      .auth-code-box:focus {
        border-color: #7A5DE8;
      }
      
      .btn-verify {
        background-color: #7A5DE8;
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 6px;
        font-size: 15px;
        font-weight: bold;
        cursor: pointer;
      }
      .btn-verify:hover {
        background-color: #6347c7;
      }
      
      .verify-result {
        margin-top: 15px;
        font-size: 14px;
        font-weight: bold;
      }
      .verify-result.success {
        color: #28a745;
      }
      .verify-result.fail {
        color: #dc3545;
      }
    </style>
    <script type="text/javascript">
      window.onload = function() {
        const withdrawLinkBtn = document.getElementById("btn-withdraw-link");
        const submitBtn = document.getElementById("btn-submit");
        const modal = document.getElementById("success-modal");
        const closeButtons = document.querySelectorAll(".close-modal");

        // 회원탈퇴 버튼 클릭 -> 탈퇴 신청 페이지로 이동
        if(withdrawLinkBtn) {
            withdrawLinkBtn.addEventListener("click", function () {
              location.href = "mypage_withdraw4.jsp";
            });
        }

        // 비밀번호 변경 버튼 클릭 -> 비밀번호 변경 페이지로 이동
        const pwChangeBtn = document.getElementById("btn-pw-change");
        if(pwChangeBtn) {
            pwChangeBtn.addEventListener("click", function () {
                location.href = "mypage_withdraw3.jsp";
            });
        }
        
        // 모달 닫기
        closeButtons.forEach(function(btn) {
          btn.addEventListener("click", function () {
            if(modal) modal.style.display = "none";
          });
        });

        // 취소 버튼
        const cancelBtn = document.querySelector(".btn-cancel");
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
            <span class="current">개인정보 수정</span>
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
          <div class="page-title">개인정보 수정</div>

          <p class="info-guide">* 회원님의 정보를 정확히 입력해주세요.</p>

          <form name="updateForm" action="mypage_withdraw2_process.jsp" method="post">
          <table class="form-table">
            <colgroup>
              <col style="width: 140px" />
              <col />
            </colgroup>
            <tbody>
              <tr>
                <th>아이디</th>
                <td>
                  <input
                    type="text"
                    class="form-input"
                    value="<%= dto != null ? dto.getUsers_id() : "" %>"
                    readonly
                  />
                  <button type="button" class="btn-withdraw-link" id="btn-withdraw-link">
                    회원탈퇴
                  </button>
                </td>
              </tr>
              <tr>
                <th>이름 <span class="required">*</span></th>
                <td>
                  <input type="text" class="form-input" value="<%= dto != null ? dto.getUsers_name() : "" %>" readonly style="background-color: #f0f0f0;" />
                </td>
              </tr>
              <tr>
                <th>생년월일 <span class="required">*</span></th>
                <td>
                  <input
                    type="text"
                    class="form-input"
                    value="<%= dto != null ? dto.getBirth() : "" %>"
                    readonly
                  />
                </td>
              </tr>
              <tr>
                <th>휴대폰 <span class="required">*</span></th>
                <td>
                  <div class="phone-group" style="display: flex; align-items: center; flex-wrap: wrap; gap: 5px;">
                    <input type="text" name="phone1" id="phone1" class="phone-input" value="<%= phone1 %>" maxlength="3" />
                    <span>-</span>
                    <input type="text" name="phone2" id="phone2" class="phone-input" value="<%= phone2 %>" maxlength="4" />
                    <span>-</span>
                    <input type="text" name="phone3" id="phone3" class="phone-input" value="<%= phone3 %>" maxlength="4" />
                    <span class="auth-status" id="phone-auth-status"></span>
                  </div>
                  <!-- reCAPTCHA 컨테이너 (Firebase 필수) -->
                  <div id="recaptcha-container" style="margin-top: 10px;"></div>
                  <!-- 인증 완료 여부 hidden 필드 -->
                  <input type="hidden" name="phoneVerified" id="phoneVerified" value="false" />
                </td>
              </tr>
              <tr>
                <th>이메일 <span class="required">*</span></th>
                <td>
                  <div style="display: flex; align-items: center;">
                    <input type="text" name="email1" id="email1" class="form-input" value="<%= email1 %>" style="width: 120px" />
                    @
                    <input type="text" name="email2" id="email2" class="form-input" value="<%= email2 %>" style="width: 120px" />
                    <button type="button" class="btn-auth" id="btn-email-auth">인증요청</button>
                    <span class="auth-status" id="email-auth-status"></span>
                  </div>
                  <!-- 인증 완료 여부 hidden 필드 -->
                  <input type="hidden" name="emailVerified" id="emailVerified" value="false" />
                </td>
              </tr>
              <tr>
                <th>비밀번호 <span class="required">*</span></th>
                <td>
                  <button type="button" class="btn-small" style="margin-left: 0" id="btn-pw-change">
                    비밀번호 변경
                  </button>
                </td>
              </tr>
            </tbody>
          </table>

          <div class="btn-group">
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
            <button type="button" class="btn-submit" onclick="document.updateForm.submit()">등록</button>
          </div>
          </form>
        </main>
      </div>
    </div>

    <!-- 수정 완료 모달 -->
    <div class="modal-overlay" id="success-modal">
      <div class="modal-container">
        <div class="modal-header">
          <span>알림</span>
          <i class="fa-solid fa-xmark close-modal"></i>
        </div>
        <div class="modal-body">
          <p>회원 정보 수정이 성공적으로 완료되었습니다.</p>
          <button class="btn-confirm close-modal">확인</button>
        </div>
      </div>
    </div>

    <!-- 이메일 인증 모달 (인증 완료 전까지 닫기 불가) -->
    <div class="auth-modal-overlay" id="email-auth-modal">
      <div class="auth-modal-box">
        <div class="auth-modal-header">
          <span>이메일 인증</span>
          <!-- X 버튼 제거: 인증 완료 전까지 모달을 닫을 수 없음 -->
        </div>
        <div class="auth-modal-body">
          <p>이메일로 발송된 5자리 인증코드를 입력해주세요.</p>
          <p style="color: #dc3545; font-size: 12px; margin-bottom: 15px;">※ 인증이 완료되어야 창이 닫힙니다.</p>
          <div class="auth-code-container">
            <input type="text" class="auth-code-box" maxlength="1" id="emailCode1">
            <input type="text" class="auth-code-box" maxlength="1" id="emailCode2">
            <input type="text" class="auth-code-box" maxlength="1" id="emailCode3">
            <input type="text" class="auth-code-box" maxlength="1" id="emailCode4">
            <input type="text" class="auth-code-box" maxlength="1" id="emailCode5">
          </div>
          <button type="button" class="btn-verify" id="btn-verify-code">인증확인</button>
          <div class="verify-result" id="verify-result"></div>
        </div>
      </div>
    </div>
    <!-- 이메일 인증 AJAX 스크립트 -->
    <script type="text/javascript">
    $(document).ready(function() {
        // 이메일 인증 완료 상태
        var isEmailVerified = false;
        
        // ============================================
        // 기존 이메일 저장 (DB에서 가져온 값)
        // ============================================
        var originalEmail1 = "<%= email1 %>";
        var originalEmail2 = "<%= email2 %>";
        
        // ============================================
        // 1. 이메일 인증요청 버튼 클릭
        // ============================================
        $("#btn-email-auth").click(function() {
            var email1 = $("#email1").val().trim();
            var email2 = $("#email2").val().trim();
            
            // 유효성 검사
            if(!email1 || !email2) {
                alert("이메일을 입력해주세요.");
                return;
            }
            
            // 기존 이메일과 동일하면 인증 불필요
            if(email1 === originalEmail1 && email2 === originalEmail2) {
                alert("기존 이메일과 동일합니다. 새 이메일로 변경 후 인증해주세요.");
                return;
            }
            
            var fullEmail = email1 + "@" + email2;
            var btn = $(this);
            btn.prop("disabled", true).text("발송중...");
            
            // AJAX로 인증 메일 발송 요청
            $.ajax({
                url: "${pageContext.request.contextPath}/quickMail",
                type: "POST",
                data: { email: fullEmail },
                dataType: "text",
                success: function(result) {
                    btn.prop("disabled", false).text("인증요청");
                    var response = result.trim();
                    
                    if(response === "OK") {
                        alert("인증 메일이 발송되었습니다! 메일함을 확인하세요.");
                        // 모달 열기
                        $("#email-auth-modal").addClass("show");
                        // 첫번째 입력칸에 포커스
                        $("#emailCode1").focus();
                        // 결과 초기화
                        $("#verify-result").html("").removeClass("success fail");
                    } else {
                        alert("메일 발송에 실패했습니다. 이메일 주소를 확인해주세요. (코드: " + response + ")");
                    }
                },
                error: function() {
                    btn.prop("disabled", false).text("인증요청");
                    alert("서버 통신에 실패했습니다. 네트워크를 확인해주세요.");
                }
            });
        });
        
        // ============================================
        // 2. 인증코드 입력박스 자동 이동
        // ============================================
        $(".auth-code-box").on("input", function() {
            // 숫자만 허용
            this.value = this.value.replace(/[^0-9]/g, "");
            
            // 다음 칸으로 자동 이동
            if(this.value.length === 1) {
                $(this).next(".auth-code-box").focus();
            }
        });
        
        $(".auth-code-box").on("keydown", function(e) {
            // Backspace 시 이전 칸으로 이동
            if(e.key === "Backspace" && this.value === "") {
                $(this).prev(".auth-code-box").focus();
            }
        });
        
        // ============================================
        // 3. 인증확인 버튼 클릭
        // ============================================
        $("#btn-verify-code").click(function() {
            var code1 = $("#emailCode1").val();
            var code2 = $("#emailCode2").val();
            var code3 = $("#emailCode3").val();
            var code4 = $("#emailCode4").val();
            var code5 = $("#emailCode5").val();
            
            // 5자리 모두 입력되었는지 확인
            if(!code1 || !code2 || !code3 || !code4 || !code5) {
                $("#verify-result").html("인증코드 5자리를 모두 입력해주세요.").addClass("fail").removeClass("success");
                return;
            }
            
            var inputCode = code1 + code2 + code3 + code4 + code5;
            var btn = $(this);
            btn.prop("disabled", true).text("확인중...");
            
            // AJAX로 인증코드 확인 요청
            $.ajax({
                url: "checkEmailCode.jsp",
                type: "POST",
                data: { code: inputCode },
                dataType: "json",
                success: function(response) {
                    btn.prop("disabled", false).text("인증확인");
                    
                    if(response.status === "success") {
                        // 인증 성공!
                        isEmailVerified = true;
                        $("#emailVerified").val("true");
                        $("#verify-result").html("✓ " + response.message).addClass("success").removeClass("fail");
                        $("#email-auth-status").html("✓ 인증완료").addClass("success").removeClass("pending");
                        
                        // 2초 후 모달 닫기
                        setTimeout(function() {
                            $("#email-auth-modal").removeClass("show");
                            // 입력칸 초기화
                            $(".auth-code-box").val("");
                        }, 1500);
                        
                    } else if(response.status === "fail") {
                        // 인증 실패
                        $("#verify-result").html("✗ " + response.message).addClass("fail").removeClass("success");
                        
                    } else {
                        // 세션 만료 등 에러
                        $("#verify-result").html("✗ " + response.message).addClass("fail").removeClass("success");
                    }
                },
                error: function() {
                    btn.prop("disabled", false).text("인증확인");
                    $("#verify-result").html("서버 통신에 실패했습니다.").addClass("fail").removeClass("success");
                }
            });
        });
        
        // ============================================
        // 4. 모달 닫기 방지 (인증 완료 전까지)
        // ============================================
        // X 버튼이 제거되어 더 이상 사용하지 않음
        // 오버레이 클릭으로도 닫히지 않도록 이벤트 중단
        $("#email-auth-modal").click(function(e) {
            // 모달 박스 외부(오버레이) 클릭 시에도 닫히지 않음
            e.stopPropagation();
        });
        
        // ============================================
        // 5. 폼 제출 전 인증 확인 체크
        // ============================================
        $("form[name='updateForm']").on("submit", function(e) {
            var newEmail1 = $("#email1").val().trim();
            var newEmail2 = $("#email2").val().trim();
            
            // 이메일이 변경되었는지 확인
            var isEmailChanged = (newEmail1 !== originalEmail1 || newEmail2 !== originalEmail2);
            
            if(isEmailChanged) {
                // 이메일이 변경됨 → 인증 필수
                if($("#emailVerified").val() !== "true") {
                    alert("이메일이 변경되었습니다. 인증을 완료해주세요.");
                    e.preventDefault();
                    return false;
                }
            }
            // 이메일 변경 안 됨 → 인증 없이 통과
            return true;
        });
    });
    </script>
    <!-- 푸터 -->
    <div id="footer"><%@ include file="../../fragments/footer.jsp" %></div>
  </body>
</html>
