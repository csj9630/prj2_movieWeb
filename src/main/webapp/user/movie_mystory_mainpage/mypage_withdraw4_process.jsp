<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="MovieWithdraw.MovieWithdrawService"%>
<%
    request.setCharacterEncoding("UTF-8");

    String userId = (String)session.getAttribute("userId");
    if(userId == null) userId = "test1";

    String pass = request.getParameter("pass"); // 탈퇴 시 비밀번호 재확인

    MovieWithdrawService service = MovieWithdrawService.getInstance();
    
    // 1. 비밀번호 검증
    boolean isAuth = service.loginCheck(userId, pass);
    
    if(!isAuth) {
%>
    <script>
        alert("비밀번호가 일치하지 않습니다.");
        history.back();
    </script>
<%
        return;
    }

    // 2. 탈퇴 처리 (Active Update)
    boolean isWithdraw = service.withdrawUser(userId);

    if(isWithdraw) {
        session.invalidate(); // 세션 만료
%>
    <script>
        alert("회원 탈퇴가 완료되었습니다. 그동안 이용해주셔서 감사합니다.");
        location.href = "../movie/index_temp.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("회원 탈퇴 처리에 실패했습니다. 관리자에게 문의하세요.");
        history.back();
    </script>
<%
    }
%>
