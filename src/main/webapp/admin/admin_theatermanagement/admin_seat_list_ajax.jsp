<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="movie.theater_admin.SeatDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.admin.AdminTheaterService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String id = request.getParameter("id");
	
	AdminTheaterService as = AdminTheaterService.getInstance();
	List<SeatDTO> list = as.getSeatList(id);
	
	JSONArray arr = new JSONArray();
	if(list != null) {
		for(SeatDTO s : list) {
			JSONObject obj = new JSONObject();
			obj.put("seatCode", s.getSeatCode());
			obj.put("status", s.getAvailableSeat());
			arr.add(obj);	
		}
	}
	out.print(arr.toJSONString());
%>