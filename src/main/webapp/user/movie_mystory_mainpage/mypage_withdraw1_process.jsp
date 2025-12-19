<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="MovieWithdraw.MovieWithdrawService"%>


<%
    request.setCharacterEncoding("UTF-8");
    String mode = request.getParameter("mode");
    String pass = request.getParameter("pass");
    
    // 현재 로그인된 ID 가져오기
    String userId = (String)session.getAttribute("userId");
    if(userId == null) userId = "test1"; 

    // AJAX 요청 처리
    if("ajax".equals(mode)) {
        MovieWithdrawService service = MovieWithdrawService.getInstance();
        boolean isSuccess = service.loginCheck(userId, pass);
        
        if(isSuccess) {
            session.setAttribute("authFlag", "true");
            out.print("success");
        } else {
            out.print("fail");
        }
        return; // AJAX 응답 후 종료
    }

    // 기존 로직 (Fallback)
    boolean isSuccess = false;
    if(pass != null && !pass.isEmpty()) {
        MovieWithdrawService service = MovieWithdrawService.getInstance();
        isSuccess = service.loginCheck(userId, pass);
    }

    if(isSuccess) {
        session.setAttribute("authFlag", "true");
        response.sendRedirect("mypage_withdraw2.jsp");
    } else {
%>
    <script>
        alert("비밀번호가 일치하지 않습니다.");
        history.back();
    </script>
<%
    }
%>
