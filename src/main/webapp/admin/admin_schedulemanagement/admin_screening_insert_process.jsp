<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="movie.screening_admin.ScreeningDTO" %>
<%@ page import="movie.admin.AdminScreeningService" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 파라미터 받기
    String movieCode = request.getParameter("movie_code");
    String theaterNum = request.getParameter("theater_num");
    String screenDate = request.getParameter("screen_date");
    String screenTime = request.getParameter("screen_time"); // 시작 시간
    String screenEndTime = request.getParameter("endTime");  // 종료 시간

    // 2. DTO 생성
    ScreeningDTO dto = new ScreeningDTO();
    dto.setMovieCode(movieCode);
    dto.setTheaterNum(theaterNum);
    dto.setScreenDate(screenDate);
    dto.setScreenTime(screenTime);
    dto.setScreenEndTime(screenEndTime);

    // 3. 서비스 호출
    AdminScreeningService service = AdminScreeningService.getInstance();
    int result = service.addScreening(dto);

    // 4. 결과 처리
    String msg = "";
    String url = "Admin_ScreeningList.jsp"; // 리스트 페이지로 이동

    if(result == 1) {
        msg = "상영 스케줄이 등록되었습니다.";
    } else if(result == -1) {
        msg = "해당 상영관/시간에 이미 상영 스케줄이 존재합니다.";
        url = "history.back()"; // 뒤로 가기
    } else {
        msg = "스케줄 등록에 실패했습니다.";
        url = "history.back()";
    }
%>
<script type="text/javascript">
    alert("<%= msg %>");
    <% if("history.back()".equals(url)) { %>
        history.back();
    <% } else { %>
        location.href = "<%= url %>";
    <% } %>
</script>