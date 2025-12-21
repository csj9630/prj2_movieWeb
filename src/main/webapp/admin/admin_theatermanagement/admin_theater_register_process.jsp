<%@page import="movie.theater_admin.TheaterDTO"%>
<%@page import="movie.admin.AdminTheaterService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String mode = request.getParameter("mode");
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String soundCode = request.getParameter("sound"); // tn001 등
	String status = request.getParameter("status"); // T or F
	
	TheaterDTO tDTO = new TheaterDTO();
	tDTO.setTheatherNum(id);
	tDTO.setTheatherName(name);
	tDTO.setAvailability(status);
	tDTO.setSoundCode(soundCode);
	
	AdminTheaterService as = AdminTheaterService.getInstance();
	boolean result = false;
	
	if("insert".equals(mode)) {
		result = as.registerTheater(tDTO);
	} else {
		result = as.modifyTheater(tDTO);
	}
	
	JSONObject json = new JSONObject();
	json.put("result", result);
	out.print(json.toJSONString());
%>