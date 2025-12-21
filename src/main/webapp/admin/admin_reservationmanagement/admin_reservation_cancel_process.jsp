<%@page import="movie.admin.AdminReservationService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String bookNum = request.getParameter("bookNum");
	boolean result = false;
	
	if(bookNum != null) {
		AdminReservationService as = AdminReservationService.getInstance();
		result = as.cancelReservation(bookNum);
	}
	
	JSONObject json = new JSONObject();
	json.put("result", result);
	out.print(json.toJSONString());
%>