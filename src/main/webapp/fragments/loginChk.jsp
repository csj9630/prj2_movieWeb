<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 세션 아이디 : userId      세션 네임 : userName -->

<!-- 미 인증 사용자(userId 부재): 로그인이 필요한 페이지에 대해 접근 시 로그인 페이지로 강제 리다이렉트. -->
<script type="text/javascript">
    // 서버의 세션값을 JS 문자열 변수로 할당
    var userId = "${sessionScope.userId}";

    if (userId === "" || userId === "null") {
        alert("로그인 후 이용해주시기 바랍니다.");
        location.href = "${commonURL}/user/member/memberLogin.jsp";
    }
</script>