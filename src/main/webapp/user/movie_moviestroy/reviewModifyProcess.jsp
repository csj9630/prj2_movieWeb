<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="moviestory.service.MovieReviewService"%>
<%@ page import="moviestory.dto.MovieReviewDTO"%>
<%
    // 1. 파라미터 수신
    request.setCharacterEncoding("UTF-8");
    String reviewNumStr = request.getParameter("reviewNum");
    String content = request.getParameter("content");
    String scoreStr = request.getParameter("score");
    String userId = (String) session.getAttribute("userId");
    
    // 테스트용
    if(userId == null) userId = "test1";

    JSONObject json = new JSONObject();

    // 2. 유효성 검사
    if(reviewNumStr == null || content == null || scoreStr == null) {
        json.put("success", false);
        json.put("message", "필수 파라미터가 누락되었습니다.");
        out.print(json.toJSONString());
        return;
    }

    int score = 0;
    try {
        score = Integer.parseInt(scoreStr);
    } catch(NumberFormatException e) {
        json.put("success", false);
        json.put("message", "점수는 숫자여야 합니다.");
        out.print(json.toJSONString());
        return;
    }

    // 3. DTO 생성 및 서비스 호출
    MovieReviewDTO dto = new MovieReviewDTO();
    dto.setReview_num(reviewNumStr);
    dto.setReview_content(content);
    dto.setReview_score(score);
    dto.setUsers_id(userId);

    MovieReviewService service = MovieReviewService.getInstance();
    boolean isUpdated = service.modifyReview(dto);

    // 4. 결과 응답
    if(isUpdated) {
        json.put("success", true);
    } else {
        json.put("success", false);
        json.put("message", "수정에 실패했거나 권한이 없습니다.");
    }
    
    out.print(json.toJSONString());
%>
