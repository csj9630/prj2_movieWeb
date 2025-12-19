<%@page import="member.LoginDTO"%>
<%@page import="member.userDTO"%>
<%@page import="SiteProperty.SitePropertyVO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="member.UserInfoService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    request.setCharacterEncoding("UTF-8");
    // POST 방식 체크 (AJAX는 보통 POST로 보냅니다)
    if(!"POST".equals(request.getMethod())) {
    	System.out.println("pOST에러");
        return; // 혹은 에러 JSON 반환
    }
%>
<jsp:useBean id="lDTO" class="member.LoginDTO" scope="page"/>
<jsp:setProperty name="lDTO" property="*"/>

<%
/* LoginDTO lDTO = new LoginDTO();
lDTO.setId(request.getParameter("users_id"));
lDTO.setPassword(request.getParameter("users_pass")); */
SitePropertyVO sv = new SitePropertyVO();
JSONObject jsonObj = new JSONObject();
String key = sv.getKey();//키는 반드시 16글자
UserInfoService uis = UserInfoService.getInstance();
userDTO uDTO= uis.searchLogin(lDTO, key);
if( uDTO != null) {//로그인 성공
	//세션에 값을 할당.
	session.setAttribute("userId", uDTO.getUsers_id());
	session.setAttribute("userName", uDTO.getUsers_name());
	jsonObj.put("msg","로그인에 성공하셨습니다. 원래 페이지로 넘어갑니다.");
	jsonObj.put("status","success");

} else { // uDTO가 null인 경우 처리 추가
	jsonObj.put("msg","아이디 또는 비밀번호가 맞지 않습니다. 로그인 정보를 다시 확인바랍니다.");
	jsonObj.put("status","fail");
	System.out.println("여기오나요?");
}
out.print(jsonObj.toJSONString());
%>