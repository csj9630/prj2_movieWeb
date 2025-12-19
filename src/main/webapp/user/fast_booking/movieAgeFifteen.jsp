<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="movie.MovieDTO"%>
<%@page import="java.util.List"%>
<%@page import="movie.MovieService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
MovieService ms=MovieService.getInstance();
List<MovieDTO> list=ms.showAgeFifteenMovie();

JSONArray jsonArr=new JSONArray();

for(MovieDTO mDTO:list) {
	JSONObject obj = new JSONObject();
    obj.put("moviecode", mDTO.getMoviecode());
    obj.put("moviename", mDTO.getMoviename());
    obj.put("mainimage", mDTO.getMoviemainimg());
    obj.put("moviegrade", mDTO.getMoviegrade());
    obj.put("releasedate", mDTO.getMoviereleasedate());
    jsonArr.add(obj);
}
out.print(jsonArr.toString());
%>