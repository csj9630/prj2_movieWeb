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
List<MovieDTO> list=ms.showPageMovie(currentPage+1, size);

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

System.out.println(jsonArr.toString());
/* 여기서 이제 이런식으로 Service에서 가져와서 사용
SELECT *
FROM movie
WHERE release_date <= SYSDATE
ORDER BY release_date DESC
OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;
*/
%>