<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="MovieWithdraw.MovieWithdrawDTO"%>
<%@ page import="MovieWithdraw.MovieWithdrawService"%>
<%
    request.setCharacterEncoding("UTF-8");

    // 세션 검증
    String authFlag = (String)session.getAttribute("authFlag");
    if(authFlag == null || !"true".equals(authFlag)) {
        response.sendRedirect("mypage_withdraw1.jsp");
        return;
    }

    String userId = (String)session.getAttribute("userId");
    if(userId == null) userId = "test1";

    // 파라미터 받기 (수정 가능한 정보: 이메일, 휴대폰)
    String phone1 = request.getParameter("phone1");
    String phone2 = request.getParameter("phone2");
    String phone3 = request.getParameter("phone3");
    String email1 = request.getParameter("email1");
    String email2 = request.getParameter("email2");
    
    String fullPhone = phone1 + "-" + phone2 + "-" + phone3;
    String fullEmail = email1 + "@" + email2;

    MovieWithdrawDTO dto = new MovieWithdrawDTO();
    dto.setUsers_id(userId);
    dto.setPhone_num(fullPhone);
    dto.setEmail(fullEmail);

    MovieWithdrawService service = MovieWithdrawService.getInstance();
    boolean isSuccess = service.updateUserInfo(dto);

    if(isSuccess) {
%>
    <script>
        alert("회원정보가 성공적으로 수정되었습니다.");
        location.href = "mypage_withdraw2.jsp";
    </script>
<%
    } else {
%>
    <script>
        alert("정보 수정에 실패했습니다. 다시 시도해주세요.");
        history.back();
    </script>
<%
    }
%>
