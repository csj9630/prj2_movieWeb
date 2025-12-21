<%@page import="movie.admin.AdminTheaterService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String seatCode = request.getParameter("seatCode");
	String currentStatus = request.getParameter("status"); // T or F
	
	// 토글: T -> F, F -> T
	String nextStatus = "T".equals(currentStatus) ? "F" : "T";
	
	boolean result = false;
	if(seatCode != null) {
		AdminTheaterService as = AdminTheaterService.getInstance();
		result = as.modifySeatStatus(seatCode, nextStatus);
	}
	
	JSONObject json = new JSONObject();
	json.put("result", result);
	json.put("nextStatus", nextStatus);
	out.print(json.toJSONString());
%>