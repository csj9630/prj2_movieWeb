<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="movie.admin.AdminScreeningService" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    String screenCode = request.getParameter("screen_code");
    
    AdminScreeningService service = AdminScreeningService.getInstance();
    int result = service.removeScreening(screenCode);
    
    String msg = "";
    
    if(result == 1) {
        msg = "상영 스케줄이 삭제되었습니다.";
    } else if(result == -2) {
        msg = "이미 예매된 내역이 있어 삭제할 수 없습니다. (예매 취소 필요)";
    } else {
        msg = "삭제에 실패했습니다.";
    }
%>
<script type="text/javascript">
    alert("<%= msg %>");
    location.href = "Admin_ScreeningList.jsp"; // 실패하든 성공하든 리스트로
</script>