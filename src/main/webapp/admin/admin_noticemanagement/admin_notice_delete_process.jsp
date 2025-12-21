<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.admin.AdminAnnounceService" %>

<%
    // 파라미터 받기
    int noticeNum = Integer.parseInt(request.getParameter("notice_num"));
    
    AdminAnnounceService service = AdminAnnounceService.getInstance();
    int result = service.removeAnnounce(noticeNum);
    
    String msg = "";
    
    if(result > 0) {
        msg = "공지사항이 삭제되었습니다.";
    } else {
        msg = "삭제에 실패했습니다.";
    }
%>
<script>
    alert("<%= msg %>");
    location.href = "Admin_NoticeList.jsp";
</script>