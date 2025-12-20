<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../../fragments/siteProperty.jsp"%>
<%@ page import="MovieWithdraw.MovieWithdrawService"%>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    if(userId == null) userId = "test1";

    String newPass = request.getParameter("newPass");
    String confirmPass = request.getParameter("confirmPass");

    if(newPass == null || !newPass.equals(confirmPass)) {
%>
    <script>
        alert("비밀번호 확인이 일치하지 않습니다.");
        history.back();
    </script>
<%
        return;
    }

    MovieWithdrawService service = MovieWithdrawService.getInstance();
    int result = service.updatePassword(userId, newPass);

    if(result == 1) { // 성공
		session.invalidate(); // 비밀번호 변경 후 로그아웃 처리
%>
    <script>
        alert("비밀번호가 변경되었습니다. 다시 로그인해주세요.");
        location.href = "${commonURL}/user/main/index.jsp"; 
    </script>
<%
    } else if(result == -1) { // 기존 비밀번호와 동일
%>
    <script>
        alert("현재 사용중인 비밀번호와 동일합니다. 다른 비밀번호를 입력해주세요.");
        history.back();
    </script>
<%
    } else { // 실패 (0)
%>
    <script>
        alert("비밀번호 변경에 실패했습니다. 관리자에게 문의하세요.");
        history.back();
    </script>
<%
    }
%>
