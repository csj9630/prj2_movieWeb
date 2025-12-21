<%@page import="movie.admin.AdminTheaterService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	
	boolean result = false;
	if(id != null) {
		AdminTheaterService as = AdminTheaterService.getInstance();
		// 비활성화 요청이므로 무조건 'F'로 변경
		result = as.modifyTheaterStatus(id, "F");
	}
	
	JSONObject json = new JSONObject();
	json.put("result", result);
	out.print(json.toJSONString());
%>