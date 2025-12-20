<%@page import="java.text.SimpleDateFormat"%>
<%@page import="movie.booking.ScheduleDTO"%>
<%@page import="movie.booking.ScheduleService"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="screenInfo.ScreenInfoService"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
//파라미터 저장.
String date = request.getParameter("date");
String movieNo = request.getParameter("movieNo");

//파라미터가 없으면 빈 배열 반환
if (date == null || movieNo == null || date.trim().isEmpty() || movieNo.trim().isEmpty()) {
	out.print("[]");
	return;
}//end if

//DB 호출
ScheduleService sbs = ScheduleService.getInstance();
List<ScheduleDTO> sbList = sbs.getMovieSchedule(date, movieNo);

//JSON 세팅
JSONArray jsonArr = new JSONArray();
JSONObject jsonObj = null;
SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");

try {

	if (sbList == null || sbList.isEmpty()) {
		//조회 데이터가 없으면 빈 JSON 배열 반환.
		out.print("[]");
		return;
	} //end if

	for (ScheduleDTO dto : sbList) {
		jsonObj = new JSONObject();

		// 1. 기본 정보 매핑
		jsonObj.put("screen_code", dto.getScreenCode());
		jsonObj.put("movie_code", dto.getMovieCode());
		jsonObj.put("movie_name", dto.getMovieName());
		jsonObj.put("movie_grade", dto.getMovieGrade());
		jsonObj.put("theather_name", dto.getTheatherName());

		// 2. 시간 데이터 (포맷팅이 필요할 수 있음)
		jsonObj.put("screen_open", sdf.format(dto.getScreenOpen()));
		jsonObj.put("screen_end", sdf.format(dto.getScreenEnd()));
		jsonObj.put("running_time", dto.getRunningTime());

		// 3. 좌석 계산 로직
		jsonObj.put("total_seat", dto.getTotalSeat());
		jsonObj.put("seat_count", dto.getSeatCount());
		jsonObj.put("rem_seat", dto.getRemainingSeat());

		// 4. Array에 추가
		jsonArr.add(jsonObj);
	} //end for
	//System.out.println(sbList.toString());
	out.print(jsonArr.toJSONString());
	
	
} catch (Exception e) {
	e.printStackTrace();
	System.err.println("getSchedule.jsp에서 에러발생 Error: " + e.getMessage());
	out.print("[]");
}
%>


