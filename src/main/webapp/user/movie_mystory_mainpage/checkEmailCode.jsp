<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 인증번호 검증용 JSP (AJAX 응답)
    // 세션에 저장된 authCode와 사용자 입력값 비교
    
    request.setCharacterEncoding("UTF-8");
    
    String inputCode = request.getParameter("code");
    String sessionCode = (String)session.getAttribute("authCode");
    
    String result;
    
    if(sessionCode == null) {
        // 세션에 인증코드가 없음 (만료 또는 미발송)
        result = "{\"status\":\"error\", \"message\":\"인증 시간이 만료되었습니다. 다시 인증요청해주세요.\"}";
        
    } else if(sessionCode.equals(inputCode)) {
        // 인증 성공
        session.removeAttribute("authCode"); // 사용 후 삭제
        session.setAttribute("emailVerified", "true"); // 인증 완료 플래그 저장
        result = "{\"status\":\"success\", \"message\":\"인증이 완료되었습니다.\"}";
        
    } else {
        // 인증 실패 (코드 불일치)
        result = "{\"status\":\"fail\", \"message\":\"인증번호가 일치하지 않습니다.\"}";
    }
    
    out.print(result);
%>
