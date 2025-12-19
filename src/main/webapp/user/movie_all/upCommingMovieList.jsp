<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
int currentPage=Integer.parseInt(request.getParameter("currentPage"));
int size=Integer.parseInt(request.getParameter("size"));

MovieService ms=MovieService.getInstance();
List<MovieDTO> list=ms.showUpCommingMovie(currentPage+1, size);

JSONArray jsonArr=new JSONArray();

for(MovieDTO mDTO:list) {
	JSONObject obj=new JSONObject();
	obj.put("moviecode", mDTO.getMoviecode());
    obj.put("moviename", mDTO.getMoviename());
    obj.put("mainimage", mDTO.getMoviemainimg());
    obj.put("moviegrade", mDTO.getMoviegrade());
    obj.put("releasedate", mDTO.getMoviereleasedate());
    jsonArr.add(obj);
}

out.print(jsonArr.toString());
%>