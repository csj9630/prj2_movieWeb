<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="movie.admin.AdminReviewService" %>

<%
    request.setCharacterEncoding("UTF-8");
    
    // 파라미터 받기 (review_num)
    String reviewNum = request.getParameter("review_num");
    
    // 서비스 호출
    AdminReviewService service = AdminReviewService.getInstance();
    int result = service.removeReview(reviewNum);
    
    String msg = "";
    
    if(result > 0) {
        msg = "리뷰가 삭제되었습니다.";
    } else {
        msg = "삭제에 실패했습니다. 이미 삭제되었거나 존재하지 않는 리뷰입니다.";
    }
%>
<script type="text/javascript">
    alert("<%= msg %>");
    location.href = "Admin_ReviewList.jsp";
</script>