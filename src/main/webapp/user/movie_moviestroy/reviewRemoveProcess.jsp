<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="moviestory.service.MovieReviewService"%>
<%
    // 1. 파라미터 수신
    request.setCharacterEncoding("UTF-8");
    String reviewNum = request.getParameter("reviewNum");
    String userId = (String) session.getAttribute("userId");
    
    // 테스트용 (세션 없을 때)
    if(userId == null) userId = "test1";
    
    System.out.println("[DEBUG] reviewRemoveProcess.jsp Start");
    System.out.println("[DEBUG] params - reviewNum: " + reviewNum + ", userId: " + userId);

    JSONObject json = new JSONObject();
    
    // 2. 유효성 검사
    if(reviewNum == null || reviewNum.isEmpty()) {
        System.out.println("[DEBUG] Missing reviewNum");
        json.put("success", false);
        json.put("message", "리뷰 번호가 누락되었습니다.");
        out.print(json.toJSONString());
        return;
    }

    // 3. 서비스 호출
    MovieReviewService service = MovieReviewService.getInstance();
    boolean isDeleted = service.removeReview(reviewNum, userId);
    
    System.out.println("[DEBUG] Delete Result: " + isDeleted);

    // 4. 결과 응답
    if(isDeleted) {
        json.put("success", true);
    } else {
        json.put("success", false);
        json.put("message", "삭제에 실패했거나 권한이 없습니다.");
    }
    
    out.print(json.toJSONString());
%>
