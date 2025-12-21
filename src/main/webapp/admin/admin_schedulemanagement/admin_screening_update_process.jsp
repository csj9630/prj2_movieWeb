<%@page import="movie.admin.AdminScreeningService"%>
<%@page import="movie.screening_admin.ScreeningDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String screenCode = request.getParameter("screen_code");
    String movieCode = request.getParameter("movie_code");
    String theaterNum = request.getParameter("theater_num");
    String screenDate = request.getParameter("screen_date");
    String screenTime = request.getParameter("screen_time");
    
    if(screenCode != null && movieCode != null) {
        ScreeningDTO dto = new ScreeningDTO();
        dto.setScreenCode(screenCode);
        dto.setMovieCode(movieCode);
        dto.setTheaterNum(theaterNum);
        dto.setScreenDate(screenDate); // YYYY-MM-DD
        dto.setScreenTime(screenTime); // HH:mm
        
        AdminScreeningService service = AdminScreeningService.getInstance();
        
        // 서비스 호출 (종료 시간 자동 계산 -> DAO 업데이트)
        int cnt = service.modifyScreening(dto);
        
        if(cnt > 0) {
            %>
            <script>
                alert("상영 스케줄이 수정되었습니다.");
                location.href = "Admin_ScreeningList.jsp";
            </script>
            <%
        } else {
            %>
            <script>
                alert("수정 실패: DB 오류가 발생했습니다.");
                history.back();
            </script>
            <%
        }
    } else {
        %>
        <script>
            alert("잘못된 접근입니다.");
            location.href = "Admin_ScreeningList.jsp";
        </script>
        <%
    }
%>