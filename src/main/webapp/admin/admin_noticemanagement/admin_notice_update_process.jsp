<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.announce_admin.AnnounceDTO" %>
<%@ page import="movie.admin.AdminAnnounceService" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 파라미터 받기
    int noticeNum = Integer.parseInt(request.getParameter("notice_num"));
    String title = request.getParameter("title");
    String content = request.getParameter("content"); // Summernote HTML 내용
    
    AnnounceDTO dto = new AnnounceDTO();
    dto.setAnnounceNum(noticeNum);
    dto.setAnnounceName(title);
    dto.setAnnounceContent(content);
    
    AdminAnnounceService service = AdminAnnounceService.getInstance();
    int result = service.modifyAnnounce(dto);
    
    String msg = "";
    // 수정 후 상세 페이지로 다시 이동하거나 목록으로 이동
    String url = "Admin_NoticeView.jsp?notice_num=" + noticeNum;
    
    if(result > 0) {
        msg = "공지사항이 수정되었습니다.";
    } else {
        msg = "수정에 실패했습니다.";
        url = "history.back()";
    }
%>
<script>
    alert("<%= msg %>");
    location.href = "<%= url %>";
</script>