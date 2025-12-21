<%@page import="movie.reservation_admin.ReservationDTO"%>
<%@page import="movie.admin.AdminReservationService"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // [세션 검사] 로그인 안 된 상태면 로그인 화면으로 튕겨냄
    String adminId = (String) session.getAttribute("adminId");
    if (adminId == null) {
%>
    <script>
        alert("로그인이 필요한 서비스입니다.");
        location.href = "../admin_login/Admin_Login.jsp";
    </script>
<%
        return; // 밑에 있는 HTML이나 자바 코드가 실행되지 않도록 여기서 멈춤
    }
%>
<%
	String bookNum = request.getParameter("bookNum");
	ReservationDTO dto = null;
	
	if(bookNum != null) {
		AdminReservationService as = AdminReservationService.getInstance();
		dto = as.getReservationDetail(bookNum);
	}
	
	if(dto == null) {
		out.print("<div style='text-align:center;'>정보가 없습니다.</div>");
		return;
	}
%>
<input type="hidden" id="detailBookState" value="<%= dto.getBookState() %>">

<table class="detail-table">
    <tr><th>예매번호</th><td><%= dto.getBookNum() %></td></tr>
    <tr><th>회원정보</th><td><%= dto.getUserName() %> (<%= dto.getUserId() %>)</td></tr>
    <tr><th>예매일시</th><td><%= dto.getBookDate() %></td></tr>
    <tr><td colspan="2" style="border-bottom:1px solid #ddd;"></td></tr>
    <tr><th>영화</th><td><strong><%= dto.getMovieName() %></strong></td></tr>
    <tr><th>상영관</th><td><%= dto.getTheaterName() %></td></tr>
    <tr><th>상영일시</th><td><%= dto.getScreenDate() %> <%= dto.getScreenTime() %></td></tr>
    <tr><th>인원/좌석</th><td><%= dto.getSeatCount() %>명 / [<%= dto.getSeats() %>]</td></tr>
    <tr><td colspan="2" style="border-bottom:1px solid #ddd;"></td></tr>
    <tr><th>결제금액</th><td><fmt:formatNumber value="<%= dto.getPrice() %>" pattern="#,###"/>원</td></tr>
    <tr><th>결제상태</th><td><%= dto.getPaymentState() %></td></tr>
    <tr><th>예매상태</th>
        <td>
            <% if("결제완료".equals(dto.getBookState())) { %>
                <span style="color:#1bc5bd; font-weight:700;">예매완료</span>
            <% } else { %>
                <span style="color:#e74c3c; font-weight:700;">예매취소</span>
            <% } %>
        </td>
    </tr>
</table>