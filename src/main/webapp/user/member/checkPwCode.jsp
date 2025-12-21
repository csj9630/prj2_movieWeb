<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
/*     // 응답 타입을 JSON으로 설정
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
 */
// 사용자가 입력한 코드값 parameter로 받아오기.
String inputCode = request.getParameter("code");

// 3. 세션 값 가져오기
/*  HttpSession currentSession = request.getSession();
 String storedCode = (String) currentSession.getAttribute("authCode"); */
String sessioncode = (String) session.getAttribute("authCode");
// JSON 응답 객체 준비
JSONObject jsonResponse = new JSONObject();
boolean isValid = false;
//테스트 때 사용할 관리자용 코드
System.out.println("관리자 : " + inputCode + inputCode.equals("11111"));
if (inputCode.equals("11111")) {
	jsonResponse.put("status", "success");
	jsonResponse.put("message", "관리자용 인증번호로 인증이 완료되었습니다.");
	isValid = true;
} else if (inputCode == null || sessioncode == null) {
	// 입력 코드가 없거나, 세션에 코드가 없는 경우
	jsonResponse.put("status", "error");
	jsonResponse.put("message", "인증세션이 만료되었습니다. 다시 메일을 보내주십시오.");
} else if (inputCode.equals(sessioncode)) {
	//세션 성공 시 보여줄 msg
	jsonResponse.put("status", "success");
	jsonResponse.put("message", "인증을 성공하셨습니다. 비밀번호를 변경하여 주십시오.");
	isValid = true;

	// 인증 완료 하였으니 세션 삭제.

} else {
	// 5. 인증 실패
	jsonResponse.put("status", "fail");
	jsonResponse.put("message", "인증 코드가 일치하지 않습니다.");
}
// 6. 클라이언트에게 JSON 응답 반환
out.print(jsonResponse.toString());
out.flush();
%>