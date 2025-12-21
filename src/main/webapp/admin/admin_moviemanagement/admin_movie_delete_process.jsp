<%@page import="movie.admin.AdminMovieService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String id = request.getParameter("id");
	
	boolean result = false;
	if(id != null && !id.isEmpty()){
		AdminMovieService as = AdminMovieService.getInstance();
		result = as.removeMovie(id);
	}
	
	JSONObject json = new JSONObject();
	json.put("result", result);
	out.print(json.toJSONString());
%>