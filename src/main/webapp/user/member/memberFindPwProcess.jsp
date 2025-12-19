<%@page import="SiteProperty.SitePropertyVO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="member.userDTO"%>
<%@page import="member.UserInfoService"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
//POST방식 한글 처리
request.setCharacterEncoding("UTF-8");

SitePropertyVO sv = new SitePropertyVO();
String key=sv.getKey();//키는 반드시 16글자
userDTO uDTO = new userDTO();
JSONObject jsonObj = new JSONObject();
//입력받은 데이터를 변수에 할당
/* String users_id = request.getParameter("users_id");
String users_name = request.getParameter("users_name");
String email = request.getParameter("email");
String users_pass = request.getParameter("users_pass"); */
uDTO.setUsers_id(request.getParameter("users_id"));
uDTO.setUsers_name(request.getParameter("users_name"));
uDTO.setEmail(request.getParameter("email"));
uDTO.setUsers_pass(request.getParameter("users_pass"));
/* System.out.println("id : " + users_id  + "  name : "  + users_name + " emil : " + email + " users_pass : " + users_pass); */
UserInfoService uis = UserInfoService.getInstance();
boolean isFwFlag = uis.checkUserPwInfo(uDTO, key);

if(isFwFlag) {
	jsonObj.put("msg","비밀번호 변경에 성공하셨습니다. 로그인 화면으로 이동합니다.");
	jsonObj.put("status","success");
} else {
	jsonObj.put("msg","비밀번호 변경에 실패하였습니다. 입력값을 다시 확인하여 주십시오.");
	jsonObj.put("status","fail");
}
out.print( jsonObj.toJSONString() );

%>
