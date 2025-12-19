<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    boolean isSuccess = service.updatePassword(userId, newPass);

    if(isSuccess) {
%>
    <script>
        alert("비밀번호가 변경되었습니다. 다시 로그인해주세요.");
        // 로그아웃 처리 후 메인으로 이동 (가정)
        location.href = "../movie/index_temp.jsp"; 
    </script>
<%
    } else {
%>
    <script>
        alert("비밀번호 변경에 실패했습니다.");
        history.back();
    </script>
<%
    }
%>
