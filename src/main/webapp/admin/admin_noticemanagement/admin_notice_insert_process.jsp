<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="movie.announce_admin.AnnounceDTO" %>
<%@ page import="movie.admin.AdminAnnounceService" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // Summernote의 내용(HTML 태그 포함)이 content 파라미터로 넘어옵니다.
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    
    AnnounceDTO dto = new AnnounceDTO();
    dto.setAnnounceName(title);
    dto.setAnnounceContent(content);
    dto.setAdminId("admin"); // 관리자 ID (세션 연동 시 session.getAttribute("adminId") 등 사용)
    
    AdminAnnounceService service = AdminAnnounceService.getInstance();
    int result = service.addAnnounce(dto);
    
    String msg = (result > 0) ? "공지사항이 등록되었습니다." : "등록에 실패했습니다.";
%>
<script>
    alert("<%= msg %>");
    location.href = "Admin_NoticeList.jsp";
</script>